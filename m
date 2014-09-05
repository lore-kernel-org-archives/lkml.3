Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaIEPEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:04:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31793 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaIEPEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:04:39 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-1e-5409d105b998
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] dmaengine: pl330: Do not dereference pl330_thread pointer
 before non-NULL check
Date: Fri, 05 Sep 2014 17:04:24 +0200
Message-id: <1409929466-29506-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7qsFzlDDPb/5bbYOGM9q8Xrf9NZ
	LKZPvcBosXrqXyD3haHF2aY37BZLJs9ntbi8aw6bxdojd9kt3r2MsHjZt5/Fgdtj8Z6XTB5L
	3hxi9fj49BaLR9+WVYwenzfJeez9/JslgC2KyyYlNSezLLVI3y6BK2P/gTVsBYc4Ktb3z2Rt
	YGxl72Lk5JAQMJF48vM0M4QtJnHh3nq2LkYuDiGBpYwSn5sXskA4fUwSjbtXMIJUsQkYS2xe
	vgSsSkSglUni4rrpYFXMAkcZJab3vmUCqRIWSJM40fAXbC6LgKrEq3PbwfbxCrhL3H/5CGqf
	nMTJY5NZJzByL2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kRElhfdzAuPWZ1iFGAg1GJ
	h7dDkzNEiDWxrLgy9xCjBAezkgiv7W6gEG9KYmVValF+fFFpTmrxIUYmDk6pBsZZFr/rGQ4Z
	razb2VW8XGxq+za5x/sDBWexnNv19Ju6wbfFHzxd9GL9qxs61yre8Li0LCXTb4uvhFQJy6Hu
	DUpuveXdQTumvpwqXLT2KtfSxG7xvaF/tP6sZZoiuZPRfeGGOrdFoeeNGVkCL9yW/v8yOZKh
	/KacvIBI5jye/1rC107OY9F4nKPEUpyRaKjFXFScCABv412VCgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not dereference the 'struct pl330_thread *thrd' before the check for
non-NULL value.

This fixes following warning:
drivers/dma/pl330.c:1376 pl330_submit_req() warn: variable dereferenced before check 'thrd' (see line 1367)

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/dma/pl330.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index d5149aacd2fe..47d82070848d 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1364,7 +1364,7 @@ static inline u32 _prepare_ccr(const struct pl330_reqcfg *rqc)
 static int pl330_submit_req(struct pl330_thread *thrd,
 	struct dma_pl330_desc *desc)
 {
-	struct pl330_dmac *pl330 = thrd->dmac;
+	struct pl330_dmac *pl330;
 	struct _xfer_spec xs;
 	unsigned long flags;
 	void __iomem *regs;
@@ -1376,6 +1376,7 @@ static int pl330_submit_req(struct pl330_thread *thrd,
 	if (!desc || !thrd || thrd->free)
 		return -EINVAL;
 
+	pl330 = thrd->dmac;
 	regs = thrd->dmac->base;
 
 	if (pl330->state == DYING
-- 
1.9.1

