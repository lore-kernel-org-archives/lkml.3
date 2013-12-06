Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab3LFOXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:23:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43568 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab3LFM7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/272] ioatdma: fix selection of 16 vs 8 source path
Date: Fri,  6 Dec 2013 12:55:01 +0000
Message-Id: <1386334761-25517-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 21e96c7313486390c694919522a76dfea0a86c59 upstream.

When performing continuations there are implied sources that need to be
added to the source count. Quoting dma_set_maxpq:

/* dma_maxpq - reduce maxpq in the face of continued operations
 * @dma - dma device with PQ capability
 * @flags - to check if DMA_PREP_CONTINUE and DMA_PREP_PQ_DISABLE_P are set
 *
 * When an engine does not support native continuation we need 3 extra
 * source slots to reuse P and Q with the following coefficients:
 * 1/ {00} * P : remove P from Q', but use it as a source for P'
 * 2/ {01} * Q : use Q to continue Q' calculation
 * 3/ {00} * Q : subtract Q from P' to cancel (2)
 *
 * In the case where P is disabled we only need 1 extra source:
 * 1/ {01} * Q : use Q to continue Q' calculation
 */

...fix the selection of the 16 source path to take these implied sources
into account.

Note this also kills the BUG_ON(src_cnt < 9) check in
__ioat3_prep_pq16_lock().  Besides not accounting for implied sources
the check is redundant given we already made the path selection.

Cc: Dave Jiang <dave.jiang@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/ioat/dma_v3.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 40aea58..2d8216b 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1116,9 +1116,6 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 	u8 op;
 	int i, s, idx, num_descs;
 
-	/* this function only handles src_cnt 9 - 16 */
-	BUG_ON(src_cnt < 9);
-
 	/* this function is only called with 9-16 sources */
 	op = result ? IOAT_OP_PQ_VAL_16S : IOAT_OP_PQ_16S;
 
@@ -1204,13 +1201,21 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 	return &desc->txd;
 }
 
+static int src_cnt_flags(unsigned int src_cnt, unsigned long flags)
+{
+	if (dmaf_p_disabled_continue(flags))
+		return src_cnt + 1;
+	else if (dmaf_continue(flags))
+		return src_cnt + 3;
+	else
+		return src_cnt;
+}
+
 static struct dma_async_tx_descriptor *
 ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 	      unsigned int src_cnt, const unsigned char *scf, size_t len,
 	      unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
-
 	/* specify valid address for disabled result */
 	if (flags & DMA_PREP_PQ_DISABLE_P)
 		dst[0] = dst[1];
@@ -1230,7 +1235,7 @@ ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 		single_source_coef[0] = scf[0];
 		single_source_coef[1] = 0;
 
-		return (src_cnt > 8) && (dma->max_pq > 8) ?
+		return src_cnt_flags(src_cnt, flags) > 8 ?
 			__ioat3_prep_pq16_lock(chan, NULL, dst, single_source,
 					       2, single_source_coef, len,
 					       flags) :
@@ -1238,7 +1243,7 @@ ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 					     single_source_coef, len, flags);
 
 	} else {
-		return (src_cnt > 8) && (dma->max_pq > 8) ?
+		return src_cnt_flags(src_cnt, flags) > 8 ?
 			__ioat3_prep_pq16_lock(chan, NULL, dst, src, src_cnt,
 					       scf, len, flags) :
 			__ioat3_prep_pq_lock(chan, NULL, dst, src, src_cnt,
@@ -1251,8 +1256,6 @@ ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 		  unsigned int src_cnt, const unsigned char *scf, size_t len,
 		  enum sum_check_flags *pqres, unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
-
 	/* specify valid address for disabled result */
 	if (flags & DMA_PREP_PQ_DISABLE_P)
 		pq[0] = pq[1];
@@ -1264,7 +1267,7 @@ ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 	 */
 	*pqres = 0;
 
-	return (src_cnt > 8) && (dma->max_pq > 8) ?
+	return src_cnt_flags(src_cnt, flags) > 8 ?
 		__ioat3_prep_pq16_lock(chan, pqres, pq, src, src_cnt, scf, len,
 				       flags) :
 		__ioat3_prep_pq_lock(chan, pqres, pq, src, src_cnt, scf, len,
@@ -1275,7 +1278,6 @@ static struct dma_async_tx_descriptor *
 ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 		 unsigned int src_cnt, size_t len, unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
 	unsigned char scf[src_cnt];
 	dma_addr_t pq[2];
 
@@ -1284,7 +1286,7 @@ ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
 	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[1] = dst; /* specify valid address for disabled result */
 
-	return (src_cnt > 8) && (dma->max_pq > 8) ?
+	return src_cnt_flags(src_cnt, flags) > 8 ?
 		__ioat3_prep_pq16_lock(chan, NULL, pq, src, src_cnt, scf, len,
 				       flags) :
 		__ioat3_prep_pq_lock(chan, NULL, pq, src, src_cnt, scf, len,
@@ -1296,7 +1298,6 @@ ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
 		     unsigned int src_cnt, size_t len,
 		     enum sum_check_flags *result, unsigned long flags)
 {
-	struct dma_device *dma = chan->device;
 	unsigned char scf[src_cnt];
 	dma_addr_t pq[2];
 
@@ -1310,8 +1311,7 @@ ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
 	flags |= DMA_PREP_PQ_DISABLE_Q;
 	pq[1] = pq[0]; /* specify valid address for disabled result */
 
-
-	return (src_cnt > 8) && (dma->max_pq > 8) ?
+	return src_cnt_flags(src_cnt, flags) > 8 ?
 		__ioat3_prep_pq16_lock(chan, result, pq, &src[1], src_cnt - 1,
 				       scf, len, flags) :
 		__ioat3_prep_pq_lock(chan, result, pq, &src[1], src_cnt - 1,
-- 
1.8.3.2

