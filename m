Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab3HFVgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:36:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:41955 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab3HFVgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:36:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,827,1367996400"; 
   d="scan'208";a="342624376"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ioatdma: Fix compiler warning
Date: Tue,  6 Aug 2013 14:36:03 -0700
Message-Id: <1375824963-19884-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC v4.6.3 complains:
drivers/dma/ioat/dma_v3.c: In function ‘__ioat3_prep_pq16_lock’:
drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]

This is due to the possibility of idx being negative, thus being outside
the boulds of the array.  Correct this by making idx an unsigned int.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/dma/ioat/dma_v3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index ca6ea9b..a17ef21 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -251,7 +251,7 @@ static bool is_bwd_noraid(struct pci_dev *pdev)
 }
 
 static void pq16_set_src(struct ioat_raw_descriptor *desc[3],
-			dma_addr_t addr, u32 offset, u8 coef, int idx)
+			 dma_addr_t addr, u32 offset, u8 coef, unsigned int idx)
 {
 	struct ioat_pq_descriptor *pq = (struct ioat_pq_descriptor *)desc[0];
 	struct ioat_pq16a_descriptor *pq16 =
@@ -1180,7 +1180,7 @@ __ioat3_prep_pq16_lock(struct dma_chan *c, enum sum_check_flags *result,
 	struct ioat_pq_descriptor *pq;
 	u32 offset = 0;
 	u8 op;
-	int i, s, idx, num_descs;
+	unsigned int i, s, idx, num_descs;
 
 	/* this function only handles src_cnt 9 - 16 */
 	BUG_ON(src_cnt < 9);
-- 
1.7.9.5

