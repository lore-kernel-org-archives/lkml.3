Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbaLLGhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:37:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51846 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759039AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stanislaw Gruszka" <sgruszka@redhat.com>,
        "Henrik Asp" <solenskiner@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.266216923@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 125/164] rt2x00: do not align payload on modern H/W
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit cfd9167af14eb4ec21517a32911d460083ee3d59 upstream.

RT2800 and newer hardware require padding between header and payload if
header length is not multiple of 4.

For historical reasons we also align payload to to 4 bytes boundary, but
such alignment is not needed on modern H/W.

Patch fixes skb_under_panic problems reported from time to time:

https://bugzilla.kernel.org/show_bug.cgi?id=84911
https://bugzilla.kernel.org/show_bug.cgi?id=72471
http://marc.info/?l=linux-wireless&m=139108549530402&w=2
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1087591

Panic happened because we eat 4 bytes of skb headroom on each
(re)transmission when sending frame without the payload and the header
length not being multiple of 4 (i.e. QoS header has 26 bytes). On such
case because paylad_aling=2 is bigger than header_align=0 we increase
header_align by 4 bytes. To prevent that we could change the check to:

	if (payload_length && payload_align > header_align)
		header_align += 4;

but not aligning payload at all is more effective and alignment is not
really needed by H/W (that has been tested on OpenWrt project for few
years now).

Reported-and-tested-by: Antti S. Lankila <alankila@bel.fi>
Debugged-by: Antti S. Lankila <alankila@bel.fi>
Reported-by: Henrik Asp <solenskiner@gmail.com>
Originally-From: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c | 50 ++++++++-----------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -148,55 +148,29 @@ void rt2x00queue_align_frame(struct sk_b
 	skb_trim(skb, frame_length);
 }
 
-void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int header_length)
+/*
+ * H/W needs L2 padding between the header and the paylod if header size
+ * is not 4 bytes aligned.
+ */
+void rt2x00queue_insert_l2pad(struct sk_buff *skb, unsigned int hdr_len)
 {
-	unsigned int payload_length = skb->len - header_length;
-	unsigned int header_align = ALIGN_SIZE(skb, 0);
-	unsigned int payload_align = ALIGN_SIZE(skb, header_length);
-	unsigned int l2pad = payload_length ? L2PAD_SIZE(header_length) : 0;
-
-	/*
-	 * Adjust the header alignment if the payload needs to be moved more
-	 * than the header.
-	 */
-	if (payload_align > header_align)
-		header_align += 4;
+	unsigned int l2pad = (skb->len > hdr_len) ? L2PAD_SIZE(hdr_len) : 0;
 
-	/* There is nothing to do if no alignment is needed */
-	if (!header_align)
+	if (!l2pad)
 		return;
 
-	/* Reserve the amount of space needed in front of the frame */
-	skb_push(skb, header_align);
-
-	/*
-	 * Move the header.
-	 */
-	memmove(skb->data, skb->data + header_align, header_length);
-
-	/* Move the payload, if present and if required */
-	if (payload_length && payload_align)
-		memmove(skb->data + header_length + l2pad,
-			skb->data + header_length + l2pad + payload_align,
-			payload_length);
-
-	/* Trim the skb to the correct size */
-	skb_trim(skb, header_length + l2pad + payload_length);
+	skb_push(skb, l2pad);
+	memmove(skb->data, skb->data + l2pad, hdr_len);
 }
 
-void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length)
+void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int hdr_len)
 {
-	/*
-	 * L2 padding is only present if the skb contains more than just the
-	 * IEEE 802.11 header.
-	 */
-	unsigned int l2pad = (skb->len > header_length) ?
-				L2PAD_SIZE(header_length) : 0;
+	unsigned int l2pad = (skb->len > hdr_len) ? L2PAD_SIZE(hdr_len) : 0;
 
 	if (!l2pad)
 		return;
 
-	memmove(skb->data + l2pad, skb->data, header_length);
+	memmove(skb->data + l2pad, skb->data, hdr_len);
 	skb_pull(skb, l2pad);
 }
 

