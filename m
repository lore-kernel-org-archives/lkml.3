Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046Ab3LFOXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:23:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab3LFM7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/272] ioatdma: fix sed pool selection
Date: Fri,  6 Dec 2013 12:55:00 +0000
Message-Id: <1386334761-25517-12-git-send-email-luis.henriques@canonical.com>
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

commit 5d48b9b5d80e3aa38a5161565398b1e48a650573 upstream.

The array to lookup the sed pool based on the number of sources
(pq16_idx_to_sedi) is 16 entries and expects a max source index.
However, we pass the total source count which runs off the end of the
array when src_cnt == 16.  The minimal fix is to just pass src_cnt-1,
but given we know the source count is > 8 we can just calculate the sed
pool by (src_cnt - 2) >> 3.

Cc: Dave Jiang <dave.jiang@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/ioat/dma_v3.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index dc4191c..40aea58 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -87,13 +87,6 @@ static const u8 pq_idx_to_field[] = { 1, 4, 5, 0, 1, 2, 4, 5 };
 static const u8 pq16_idx_to_field[] = { 1, 4, 1, 2, 3, 4, 5, 6, 7,
 					0, 1, 2, 3, 4, 5, 6 };
 
-/*
- * technically sources 1 and 2 do not require SED, but the op will have
- * at least 9 descriptors so that's irrelevant.
- */
-static const u8 pq16_idx_to_sed[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0,
-				      1, 1, 1, 1, 1, 1, 1 };
-
 static void ioat3_eh(struct ioat2_dma_chan *ioat);
 
 static dma_addr_t xor_get_src(struct ioat_raw_descriptor *descs[2], int idx)
@@ -135,12 +128,6 @@ static void pq_set_src(struct ioat_raw_descriptor *descs[2],
 	pq->coef[idx] = coef;
 }
 
-static int sed_get_pq16_pool_idx(int src_cnt)
-{
-
-	return pq16_idx_to_sed[src_cnt];
-}
-
 static bool is_jf_ioat(struct pci_dev *pdev)
 {
 	switch (pdev->device) {
@@ -1159,8 +1146,7 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 
 		descs[0] = (struct ioat_raw_descriptor *) pq;
 
-		desc->sed = ioat3_alloc_sed(device,
-					    sed_get_pq16_pool_idx(src_cnt));
+		desc->sed = ioat3_alloc_sed(device, (src_cnt-2) >> 3);
 		if (!desc->sed) {
 			dev_err(to_dev(chan),
 				"%s: no free sed entries\n", __func__);
-- 
1.8.3.2

