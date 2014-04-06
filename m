Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbaDFXkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:40:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59454 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754744AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Paul Stewart" <pstew@chromium.org>,
        "Aurelien Jacobs" <aurel@gnuage.org>,
        "Trond Wuellner" <trond@chromium.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Emil Goode" <emilgoode@gmail.com>,
        "Grant Grundler" <grundler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.590224716@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 12/18] asix: asix_rx_fixup surgery to reduce skb truesizes
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit a9e0aca4b37885b5599e52211f098bd7f565e749 upstream.

asix_rx_fixup() is complex, and does some unnecessary memory copies (at
least on x86 where NET_IP_ALIGN is 0)

Also, it tends to provide skbs with a big truesize (4096+256 with
MTU=1500) to upper stack, so incoming trafic consume a lot of memory and
I noticed early packet drops because we hit socket rcvbuf too fast.

Switch to a different strategy, using copybreak so that we provide nice
skbs to upper stack (including the NET_SKB_PAD to avoid future head
reallocations in some paths)

With this patch, I no longer see packets drops or tcp collapses on
various tcp workload with a AX88772 adapter.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Aurelien Jacobs <aurel@gnuage.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Trond Wuellner <trond@chromium.org>
Cc: Grant Grundler <grundler@chromium.org>
Cc: Paul Stewart <pstew@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Emil: Backported to 3.2: fixed small conflict ]
Signed-off-by: Emil Goode <emilgoode@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/asix.c |   88 +++++++++++-------------------------------------
 1 file changed, 20 insertions(+), 68 deletions(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -306,88 +306,40 @@ asix_write_cmd_async(struct usbnet *dev,
 
 static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
-	u8  *head;
-	u32  header;
-	char *packet;
-	struct sk_buff *ax_skb;
-	u16 size;
-
-	head = (u8 *) skb->data;
-	memcpy(&header, head, sizeof(header));
-	le32_to_cpus(&header);
-	packet = head + sizeof(header);
+	int offset = 0;
 
-	skb_pull(skb, 4);
+	while (offset + sizeof(u32) < skb->len) {
+		struct sk_buff *ax_skb;
+		u16 size;
+		u32 header = get_unaligned_le32(skb->data + offset);
 
-	while (skb->len > 0) {
-		if ((header & 0x07ff) != ((~header >> 16) & 0x07ff))
-			netdev_err(dev->net, "asix_rx_fixup() Bad Header Length\n");
+		offset += sizeof(u32);
 
 		/* get the packet length */
-		size = (u16) (header & 0x000007ff);
-
-		if ((skb->len) - ((size + 1) & 0xfffe) == 0) {
-			u8 alignment = (unsigned long)skb->data & 0x3;
-			if (alignment != 0x2) {
-				/*
-				 * not 16bit aligned so use the room provided by
-				 * the 32 bit header to align the data
-				 *
-				 * note we want 16bit alignment as MAC header is
-				 * 14bytes thus ip header will be aligned on
-				 * 32bit boundary so accessing ipheader elements
-				 * using a cast to struct ip header wont cause
-				 * an unaligned accesses.
-				 */
-				u8 realignment = (alignment + 2) & 0x3;
-				memmove(skb->data - realignment,
-					skb->data,
-					size);
-				skb->data -= realignment;
-				skb_set_tail_pointer(skb, size);
-			}
-			return 2;
+		size = (u16) (header & 0x7ff);
+		if (size != ((~header >> 16) & 0x07ff)) {
+			netdev_err(dev->net, "asix_rx_fixup() Bad Header Length\n");
+			return 0;
 		}
 
-		if (size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) {
+		if ((size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) ||
+		    (size + offset > skb->len)) {
 			netdev_err(dev->net, "asix_rx_fixup() Bad RX Length %d\n",
 				   size);
 			return 0;
 		}
-		ax_skb = skb_clone(skb, GFP_ATOMIC);
-		if (ax_skb) {
-			u8 alignment = (unsigned long)packet & 0x3;
-			ax_skb->len = size;
-
-			if (alignment != 0x2) {
-				/*
-				 * not 16bit aligned use the room provided by
-				 * the 32 bit header to align the data
-				 */
-				u8 realignment = (alignment + 2) & 0x3;
-				memmove(packet - realignment, packet, size);
-				packet -= realignment;
-			}
-			ax_skb->data = packet;
-			skb_set_tail_pointer(ax_skb, size);
-			usbnet_skb_return(dev, ax_skb);
-		} else {
+		ax_skb = netdev_alloc_skb_ip_align(dev->net, size);
+		if (!ax_skb)
 			return 0;
-		}
-
-		skb_pull(skb, (size + 1) & 0xfffe);
 
-		if (skb->len < sizeof(header))
-			break;
+		skb_put(ax_skb, size);
+		memcpy(ax_skb->data, skb->data + offset, size);
+		usbnet_skb_return(dev, ax_skb);
 
-		head = (u8 *) skb->data;
-		memcpy(&header, head, sizeof(header));
-		le32_to_cpus(&header);
-		packet = head + sizeof(header);
-		skb_pull(skb, 4);
+		offset += (size + 1) & 0xfffe;
 	}
 
-	if (skb->len < 0) {
+	if (skb->len != offset) {
 		netdev_err(dev->net, "asix_rx_fixup() Bad SKB Length %d\n",
 			   skb->len);
 		return 0;
@@ -1538,7 +1490,7 @@ static const struct driver_info ax88772_
 	.status = asix_status,
 	.link_reset = ax88772_link_reset,
 	.reset = ax88772_reset,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_LINK_INTR | FLAG_MULTI_PACKET,
 	.rx_fixup = asix_rx_fixup,
 	.tx_fixup = asix_tx_fixup,
 };

