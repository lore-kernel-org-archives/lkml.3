Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3LBSCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 13:02:16 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56387 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab3LBSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 13:02:10 -0500
From: Will Deacon <will.deacon@arm.com>
To: dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2] dma: pl330: ensure DMA descriptors are zero-initialised
Date: Mon,  2 Dec 2013 18:01:30 +0000
Message-Id: <1386007290-13987-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see the following splat with 3.13-rc1 when attempting to perform DMA:

[  253.004516] Alignment trap: not handling instruction e1902f9f at [<c0204b40>]
[  253.004583] Unhandled fault: alignment exception (0x221) at 0xdfdfdfd7
[  253.004646] Internal error: : 221 [#1] PREEMPT SMP ARM
[  253.004691] Modules linked in: dmatest(+) [last unloaded: dmatest]
[  253.004798] CPU: 0 PID: 671 Comm: kthreadd Not tainted 3.13.0-rc1+ #2
[  253.004864] task: df9b0900 ti: df03e000 task.ti: df03e000
[  253.004937] PC is at dmaengine_unmap_put+0x14/0x34
[  253.005010] LR is at pl330_tasklet+0x3c8/0x550
[  253.005087] pc : [<c0204b44>]    lr : [<c0207478>]    psr: a00e0193
[  253.005087] sp : df03fe48  ip : 00000000  fp : df03bf18
[  253.005178] r10: bf00e108  r9 : 00000001  r8 : 00000000
[  253.005245] r7 : df837040  r6 : dfb41800  r5 : df837048  r4 : df837000
[  253.005316] r3 : dfdfdfcf  r2 : dfb41f80  r1 : df837048  r0 : dfdfdfd7
[  253.005384] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  253.005459] Control: 30c5387d  Table: 9fb9ba80  DAC: fffffffd
[  253.005520] Process kthreadd (pid: 671, stack limit = 0xdf03e248)

This is due to desc->txd.unmap containing garbage (uninitialised memory).

Rather than add another dummy initialisation to _init_desc, instead
ensure that the descriptors are zero-initialised during allocation and
remove the dummy, per-field initialisation.

Cc: Andriy Shevchenko <andriy.shevchenko@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/dma/pl330.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 98641eaca080..769f865b71db 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2492,12 +2492,9 @@ static dma_cookie_t pl330_tx_submit(struct dma_async_tx_descriptor *tx)
 
 static inline void _init_desc(struct dma_pl330_desc *desc)
 {
-	desc->pchan = NULL;
 	desc->req.x = &desc->px;
 	desc->req.token = desc;
 	desc->rqcfg.swap = SWAP_NO;
-	desc->rqcfg.privileged = 0;
-	desc->rqcfg.insnaccess = 0;
 	desc->rqcfg.scctl = SCCTRL0;
 	desc->rqcfg.dcctl = DCCTRL0;
 	desc->req.cfg = &desc->rqcfg;
@@ -2517,7 +2514,7 @@ static int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
 	if (!pdmac)
 		return 0;
 
-	desc = kmalloc(count * sizeof(*desc), flg);
+	desc = kcalloc(count, sizeof(*desc), flg);
 	if (!desc)
 		return 0;
 
-- 
1.8.2.2

