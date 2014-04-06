Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaDFXkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:40:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59435 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lucas Stach" <dev@lynxeye.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Emil Goode" <emilgoode@gmail.com>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.748211789@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 13/18] net: asix: handle packets crossing URB boundaries
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Goode <emilgoode@gmail.com>

commit 8b5b6f5413e97c3e8bafcdd67553d508f4f698cd upstream.

ASIX AX88772B started to pack data even more tightly. Packets and the ASIX packet
header may now cross URB boundaries. To handle this we have to introduce
some state between individual calls to asix_rx_fixup().

Signed-off-by: Lucas Stach <dev@lynxeye.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Emil: backported to 3.2:
 - dropped changes to drivers/net/usb/ax88172a.c 
 - Introduced some static function declarations as the functions
   are not used outside of asix.c (sparse is complaining about it) ]
Signed-off-by: Emil Goode <emilgoode@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/asix.c |  125 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 97 insertions(+), 28 deletions(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -183,6 +183,17 @@ struct ax88172_int_data {
 	__le16 res3;
 } __packed;
 
+struct asix_rx_fixup_info {
+	struct sk_buff *ax_skb;
+	u32 header;
+	u16 size;
+	bool split_head;
+};
+
+struct asix_common_private {
+	struct asix_rx_fixup_info rx_fixup_info;
+};
+
 static int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 			    u16 size, void *data)
 {
@@ -304,49 +315,89 @@ asix_write_cmd_async(struct usbnet *dev,
 	}
 }
 
-static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+static int asix_rx_fixup_internal(struct usbnet *dev, struct sk_buff *skb,
+				  struct asix_rx_fixup_info *rx)
 {
 	int offset = 0;
 
-	while (offset + sizeof(u32) < skb->len) {
-		struct sk_buff *ax_skb;
-		u16 size;
-		u32 header = get_unaligned_le32(skb->data + offset);
-
-		offset += sizeof(u32);
-
-		/* get the packet length */
-		size = (u16) (header & 0x7ff);
-		if (size != ((~header >> 16) & 0x07ff)) {
-			netdev_err(dev->net, "asix_rx_fixup() Bad Header Length\n");
-			return 0;
+	while (offset + sizeof(u16) <= skb->len) {
+		u16 remaining = 0;
+		unsigned char *data;
+
+		if (!rx->size) {
+			if ((skb->len - offset == sizeof(u16)) ||
+			    rx->split_head) {
+				if(!rx->split_head) {
+					rx->header = get_unaligned_le16(
+							skb->data + offset);
+					rx->split_head = true;
+					offset += sizeof(u16);
+					break;
+				} else {
+					rx->header |= (get_unaligned_le16(
+							skb->data + offset)
+							<< 16);
+					rx->split_head = false;
+					offset += sizeof(u16);
+				}
+			} else {
+				rx->header = get_unaligned_le32(skb->data +
+								offset);
+				offset += sizeof(u32);
+			}
+
+			/* get the packet length */
+			rx->size = (u16) (rx->header & 0x7ff);
+			if (rx->size != ((~rx->header >> 16) & 0x7ff)) {
+				netdev_err(dev->net, "asix_rx_fixup() Bad Header Length 0x%x, offset %d\n",
+					   rx->header, offset);
+				rx->size = 0;
+				return 0;
+			}
+			rx->ax_skb = netdev_alloc_skb_ip_align(dev->net,
+							       rx->size);
+			if (!rx->ax_skb)
+				return 0;
 		}
 
-		if ((size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) ||
-		    (size + offset > skb->len)) {
+		if (rx->size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) {
 			netdev_err(dev->net, "asix_rx_fixup() Bad RX Length %d\n",
-				   size);
+				   rx->size);
+			kfree_skb(rx->ax_skb);
 			return 0;
 		}
-		ax_skb = netdev_alloc_skb_ip_align(dev->net, size);
-		if (!ax_skb)
-			return 0;
 
-		skb_put(ax_skb, size);
-		memcpy(ax_skb->data, skb->data + offset, size);
-		usbnet_skb_return(dev, ax_skb);
+		if (rx->size > skb->len - offset) {
+			remaining = rx->size - (skb->len - offset);
+			rx->size = skb->len - offset;
+		}
+
+		data = skb_put(rx->ax_skb, rx->size);
+		memcpy(data, skb->data + offset, rx->size);
+		if (!remaining)
+			usbnet_skb_return(dev, rx->ax_skb);
 
-		offset += (size + 1) & 0xfffe;
+		offset += (rx->size + 1) & 0xfffe;
+		rx->size = remaining;
 	}
 
 	if (skb->len != offset) {
-		netdev_err(dev->net, "asix_rx_fixup() Bad SKB Length %d\n",
-			   skb->len);
+		netdev_err(dev->net, "asix_rx_fixup() Bad SKB Length %d, %d\n",
+			   skb->len, offset);
 		return 0;
 	}
+
 	return 1;
 }
 
+static int asix_rx_fixup_common(struct usbnet *dev, struct sk_buff *skb)
+{
+	struct asix_common_private *dp = dev->driver_priv;
+	struct asix_rx_fixup_info *rx = &dp->rx_fixup_info;
+
+	return asix_rx_fixup_internal(dev, skb, rx);
+}
+
 static struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 					gfp_t flags)
 {
@@ -1106,9 +1157,19 @@ static int ax88772_bind(struct usbnet *d
 		dev->rx_urb_size = 2048;
 	}
 
+	dev->driver_priv = kzalloc(sizeof(struct asix_common_private), GFP_KERNEL);
+	if (!dev->driver_priv)
+		return -ENOMEM;
+
 	return 0;
 }
 
+static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
+{
+	if (dev->driver_priv)
+		kfree(dev->driver_priv);
+}
+
 static struct ethtool_ops ax88178_ethtool_ops = {
 	.get_drvinfo		= asix_get_drvinfo,
 	.get_link		= asix_get_link,
@@ -1441,6 +1502,10 @@ static int ax88178_bind(struct usbnet *d
 		dev->rx_urb_size = 2048;
 	}
 
+	dev->driver_priv = kzalloc(sizeof(struct asix_common_private), GFP_KERNEL);
+	if (!dev->driver_priv)
+			return -ENOMEM;
+
 	return 0;
 }
 
@@ -1487,22 +1552,24 @@ static const struct driver_info hawking_
 static const struct driver_info ax88772_info = {
 	.description = "ASIX AX88772 USB 2.0 Ethernet",
 	.bind = ax88772_bind,
+	.unbind = ax88772_unbind,
 	.status = asix_status,
 	.link_reset = ax88772_link_reset,
 	.reset = ax88772_reset,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
-	.rx_fixup = asix_rx_fixup,
+	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
 
 static const struct driver_info ax88178_info = {
 	.description = "ASIX AX88178 USB 2.0 Ethernet",
 	.bind = ax88178_bind,
+	.unbind = ax88772_unbind,
 	.status = asix_status,
 	.link_reset = ax88178_link_reset,
 	.reset = ax88178_reset,
 	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR,
-	.rx_fixup = asix_rx_fixup,
+	.rx_fixup = asix_rx_fixup_common,
 	.tx_fixup = asix_tx_fixup,
 };
 

