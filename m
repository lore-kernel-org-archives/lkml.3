Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaAOV4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:56:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbaAOV43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Korsgaard <peter@korsgaard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 117/166] dm9601: work around tx fifo sync issue on dm962x
Date: Wed, 15 Jan 2014 13:52:11 -0800
Message-Id: <1389822780-4729-118-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

commit 4263c86dca5198da6bd3ad826d0b2304fbe25776 upstream.

Certain dm962x revisions contain an bug, where if a USB bulk transfer retry
(E.G. if bulk crc mismatch) happens right after a transfer with odd or
maxpacket length, the internal tx hardware fifo gets out of sync causing
the interface to stop working.

Work around it by adding up to 3 bytes of padding to ensure this situation
cannot trigger.

This workaround also means we never pass multiple-of-maxpacket size skb's
to usbnet, so the length adjustment to handle usbnet's padding of those can
be removed.

Reported-by: Joseph Chang <joseph_chang@davicom.com.tw>
Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/dm9601.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index ae2668e..d3891b1 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -473,7 +473,7 @@ static int dm9601_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 static struct sk_buff *dm9601_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 				       gfp_t flags)
 {
-	int len;
+	int len, pad;
 
 	/* format:
 	   b1: packet length low
@@ -481,12 +481,23 @@ static struct sk_buff *dm9601_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	   b3..n: packet data
 	*/
 
-	len = skb->len;
+	len = skb->len + DM_TX_OVERHEAD;
+
+	/* workaround for dm962x errata with tx fifo getting out of
+	 * sync if a USB bulk transfer retry happens right after a
+	 * packet with odd / maxpacket length by adding up to 3 bytes
+	 * padding.
+	 */
+	while ((len & 1) || !(len % dev->maxpacket))
+		len++;
 
-	if (skb_headroom(skb) < DM_TX_OVERHEAD) {
+	len -= DM_TX_OVERHEAD; /* hw header doesn't count as part of length */
+	pad = len - skb->len;
+
+	if (skb_headroom(skb) < DM_TX_OVERHEAD || skb_tailroom(skb) < pad) {
 		struct sk_buff *skb2;
 
-		skb2 = skb_copy_expand(skb, DM_TX_OVERHEAD, 0, flags);
+		skb2 = skb_copy_expand(skb, DM_TX_OVERHEAD, pad, flags);
 		dev_kfree_skb_any(skb);
 		skb = skb2;
 		if (!skb)
@@ -495,10 +506,10 @@ static struct sk_buff *dm9601_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 
 	__skb_push(skb, DM_TX_OVERHEAD);
 
-	/* usbnet adds padding if length is a multiple of packet size
-	   if so, adjust length value in header */
-	if ((skb->len % dev->maxpacket) == 0)
-		len++;
+	if (pad) {
+		memset(skb->data + skb->len, 0, pad);
+		__skb_put(skb, pad);
+	}
 
 	skb->data[0] = len;
 	skb->data[1] = len >> 8;
-- 
1.8.3.2

