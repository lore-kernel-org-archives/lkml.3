Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbaCEOsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:48:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316AbaCEOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lucas Stach <dev@lynxeye.de>, "David S. Miller" <davem@davemloft.net>,
        Emil Goode <emilgoode@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 36/62] net: asix: handle packets crossing URB boundaries
Date: Wed,  5 Mar 2014 14:36:40 +0000
Message-Id: <1394030226-26652-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Goode <emilgoode@gmail.com>

commit 8b5b6f5413e97c3e8bafcdd67553d508f4f698cd upstream.

ASIX AX88772B started to pack data even more tightly. Packets and the ASIX packet
header may now cross URB boundaries. To handle this we have to introduce
some state between individual calls to asix_rx_fixup().

Signed-off-by: Lucas Stach <dev@lynxeye.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Emil: backported to 3.5: dropped changes to drivers/net/usb/ax88172a.c ]
Signed-off-by: Emil Goode <emilgoode@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/asix.c | 125 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 97 insertions(+), 28 deletions(-)

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index ebcb7d4..9402f9c 100644
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
@@ -304,49 +315,89 @@ asix_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value, u16 index,
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
+				if (!rx->split_head) {
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
@@ -1110,9 +1161,19 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->rx_urb_size = 2048;
 	}
 
+	dev->driver_priv = kzalloc(sizeof(struct asix_common_private),
+				   GFP_KERNEL);
+	if (!dev->driver_priv)
+		return -ENOMEM;
+
 	return 0;
 }
 
+static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
+{
+	kfree(dev->driver_priv);
+}
+
 static const struct ethtool_ops ax88178_ethtool_ops = {
 	.get_drvinfo		= asix_get_drvinfo,
 	.get_link		= asix_get_link,
@@ -1445,6 +1506,11 @@ static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->rx_urb_size = 2048;
 	}
 
+	dev->driver_priv = kzalloc(sizeof(struct asix_common_private),
+				   GFP_KERNEL);
+	if (!dev->driver_priv)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -1491,22 +1557,25 @@ static const struct driver_info hawking_uf200_info = {
 static const struct driver_info ax88772_info = {
 	.description = "ASIX AX88772 USB 2.0 Ethernet",
 	.bind = ax88772_bind,
+	.unbind = ax88772_unbind,
 	.status = asix_status,
 	.link_reset = ax88772_link_reset,
 	.reset = ax88772_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
-	.rx_fixup = asix_rx_fixup,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR |
+		 FLAG_MULTI_PACKET,
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
 
-- 
1.9.0

