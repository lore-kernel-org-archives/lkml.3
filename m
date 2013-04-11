Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3DKVAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:00:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935637Ab3DKUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:21 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=l35N7ADuMIQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=m7TqotoGk10A:10 a=pGLkceISAAAA:8 a=g_0wNEBgAAAA:8 a=yQdBAQUQAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=CvGMfZLIdAowaUExdtwA:9 a=MSl-tDqOz04A:10 a=IcxpeKGZWnEA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202600.758615268@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Vine <chris@cvine.freeserve.co.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 089/171 ] b43: A fix for DMA transmission sequence errors
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0089-b43-A-fix-for-DMA-transmission-sequence-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Iestyn C. Elfick" <isedev@gmail.com>

[ Upstream commit b251412db99ccd4495ce372fec7daee27bf06923 ]

Intermittently, b43 will report "Out of order TX status report on DMA ring".
When this happens, the driver must be reset before communication can resume.
The cause of the problem is believed to be an error in the closed-source
firmware; however, all versions of the firmware are affected.

This change uses the observation that the expected status is always 2 less
than the observed value, and supplies a fake status report to skip one
header/data pair.

Not all devices suffer from this problem, but it can occur several times
per second under heavy load. As each occurence kills the unmodified driver,
this patch makes if possible for the affected devices to function. The patch
logs only the first instance of the reset operation to prevent spamming
the logs.

Tested-by: Chris Vine <chris@cvine.freeserve.co.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/b43/dma.c |   65 ++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 777cd74..92768d304 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1484,8 +1484,12 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	const struct b43_dma_ops *ops;
 	struct b43_dmaring *ring;
 	struct b43_dmadesc_meta *meta;
+	static const struct b43_txstatus fake; /* filled with 0 */
+	const struct b43_txstatus *txstat;
 	int slot, firstused;
 	bool frame_succeed;
+	int skip;
+	static u8 err_out1, err_out2;
 
 	ring = parse_cookie(dev, status->cookie, &slot);
 	if (unlikely(!ring))
@@ -1498,13 +1502,36 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 	firstused = ring->current_slot - ring->used_slots + 1;
 	if (firstused < 0)
 		firstused = ring->nr_slots + firstused;
+
+	skip = 0;
 	if (unlikely(slot != firstused)) {
 		/* This possibly is a firmware bug and will result in
-		 * malfunction, memory leaks and/or stall of DMA functionality. */
-		b43dbg(dev->wl, "Out of order TX status report on DMA ring %d. "
-		       "Expected %d, but got %d\n",
-		       ring->index, firstused, slot);
-		return;
+		 * malfunction, memory leaks and/or stall of DMA functionality.
+		 */
+		if (slot == next_slot(ring, next_slot(ring, firstused))) {
+			/* If a single header/data pair was missed, skip over
+			 * the first two slots in an attempt to recover.
+			 */
+			slot = firstused;
+			skip = 2;
+			if (!err_out1) {
+				/* Report the error once. */
+				b43dbg(dev->wl,
+				       "Skip on DMA ring %d slot %d.\n",
+				       ring->index, slot);
+				err_out1 = 1;
+			}
+		} else {
+			/* More than a single header/data pair were missed.
+			 * Report this error once.
+			 */
+			if (!err_out2)
+				b43dbg(dev->wl,
+				       "Out of order TX status report on DMA ring %d. Expected %d, but got %d\n",
+				       ring->index, firstused, slot);
+			err_out2 = 1;
+			return;
+		}
 	}
 
 	ops = ring->ops;
@@ -1519,11 +1546,13 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			       slot, firstused, ring->index);
 			break;
 		}
+
 		if (meta->skb) {
 			struct b43_private_tx_info *priv_info =
-				b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
+			     b43_get_priv_tx_info(IEEE80211_SKB_CB(meta->skb));
 
-			unmap_descbuffer(ring, meta->dmaaddr, meta->skb->len, 1);
+			unmap_descbuffer(ring, meta->dmaaddr,
+					 meta->skb->len, 1);
 			kfree(priv_info->bouncebuffer);
 			priv_info->bouncebuffer = NULL;
 		} else {
@@ -1535,8 +1564,9 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 			struct ieee80211_tx_info *info;
 
 			if (unlikely(!meta->skb)) {
-				/* This is a scatter-gather fragment of a frame, so
-				 * the skb pointer must not be NULL. */
+				/* This is a scatter-gather fragment of a frame,
+				 * so the skb pointer must not be NULL.
+				 */
 				b43dbg(dev->wl, "TX status unexpected NULL skb "
 				       "at slot %d (first=%d) on ring %d\n",
 				       slot, firstused, ring->index);
@@ -1547,9 +1577,18 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 
 			/*
 			 * Call back to inform the ieee80211 subsystem about
-			 * the status of the transmission.
+			 * the status of the transmission. When skipping over
+			 * a missed TX status report, use a status structure
+			 * filled with zeros to indicate that the frame was not
+			 * sent (frame_count 0) and not acknowledged
 			 */
-			frame_succeed = b43_fill_txstatus_report(dev, info, status);
+			if (unlikely(skip))
+				txstat = &fake;
+			else
+				txstat = status;
+
+			frame_succeed = b43_fill_txstatus_report(dev, info,
+								 txstat);
 #ifdef CONFIG_B43_DEBUG
 			if (frame_succeed)
 				ring->nr_succeed_tx_packets++;
@@ -1577,12 +1616,14 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
 		/* Everything unmapped and free'd. So it's not used anymore. */
 		ring->used_slots--;
 
-		if (meta->is_last_fragment) {
+		if (meta->is_last_fragment && !skip) {
 			/* This is the last scatter-gather
 			 * fragment of the frame. We are done. */
 			break;
 		}
 		slot = next_slot(ring, slot);
+		if (skip > 0)
+			--skip;
 	}
 	if (ring->stopped) {
 		B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
-- 
1.7.10.4


