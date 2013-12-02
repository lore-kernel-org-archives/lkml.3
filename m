Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab3LBVBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:01:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3LBTNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3.10 073/173] ioatdma: fix sed pool selection
Date: Mon,  2 Dec 2013 11:10:56 -0800
Message-Id: <20131202191151.504580465@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/ioat/dma_v3.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -87,13 +87,6 @@ static const u8 pq_idx_to_field[] = { 1,
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
@@ -135,12 +128,6 @@ static void pq_set_src(struct ioat_raw_d
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
@@ -1212,8 +1199,7 @@ __ioat3_prep_pq16_lock(struct dma_chan *
 
 		descs[0] = (struct ioat_raw_descriptor *) pq;
 
-		desc->sed = ioat3_alloc_sed(device,
-					    sed_get_pq16_pool_idx(src_cnt));
+		desc->sed = ioat3_alloc_sed(device, (src_cnt-2) >> 3);
 		if (!desc->sed) {
 			dev_err(to_dev(chan),
 				"%s: no free sed entries\n", __func__);


