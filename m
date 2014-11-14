Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaKNGjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:39:13 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:47575 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaKNGjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:39:11 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] CXL: Return error to PSL if IRQ demultiplexing fails & print clearer warning
Date: Fri, 14 Nov 2014 17:37:50 +1100
Message-Id: <1415947070-5232-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111406-0029-0000-0000-00000098616C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

If an AFU has a hardware bug that causes it to acknowledge a context
terminate or remove while that context has outstanding transactions, it
is possible for the kernel to receive an interrupt for that context
after we have removed it from the context list.

The kernel will not be able to demultiplex the interrupt (or worse - if
we have already reallocated the process handle we could mis-attribute it
to the new context), and printed a big scary warning.

It did not acknowledge the interrupt, which would effectively halt
further translation fault processing on the PSL.

This patch makes the warning clearer about the likely cause of the issue
(i.e. hardware bug) to make it obvious to future AFU designers of what
needs to be fixed. It also prints out the process handle which can then
be matched up with hardware and software traces for debugging.

It also acknowledges the interrupt to the PSL with either an address
error or acknowledge, so that the PSL can continue with other
translations.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/cxl.h    |  2 +-
 drivers/misc/cxl/irq.c    | 46 +++++++++++++++++++++++++++++-----------------
 drivers/misc/cxl/native.c | 14 +++++++-------
 3 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/misc/cxl/cxl.h b/drivers/misc/cxl/cxl.h
index 3a8dd05..fe07b6f 100644
--- a/drivers/misc/cxl/cxl.h
+++ b/drivers/misc/cxl/cxl.h
@@ -620,7 +620,7 @@ int cxl_attach_process(struct cxl_context *ctx, bool kernel, u64 wed,
 			    u64 amr);
 int cxl_detach_process(struct cxl_context *ctx);
 
-int cxl_get_irq(struct cxl_context *ctx, struct cxl_irq_info *info);
+int cxl_get_irq(struct cxl_afu *afu, struct cxl_irq_info *info);
 int cxl_ack_irq(struct cxl_context *ctx, u64 tfc, u64 psl_reset_mask);
 
 int cxl_check_error(struct cxl_afu *afu);
diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
index c239272..2858151 100644
--- a/drivers/misc/cxl/irq.c
+++ b/drivers/misc/cxl/irq.c
@@ -92,20 +92,13 @@ static irqreturn_t schedule_cxl_fault(struct cxl_context *ctx, u64 dsisr, u64 da
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t cxl_irq(int irq, void *data)
+static irqreturn_t cxl_irq(int irq, void *data, struct cxl_irq_info *irq_info)
 {
 	struct cxl_context *ctx = data;
-	struct cxl_irq_info irq_info;
 	u64 dsisr, dar;
-	int result;
 
-	if ((result = cxl_get_irq(ctx, &irq_info))) {
-		WARN(1, "Unable to get CXL IRQ Info: %i\n", result);
-		return IRQ_HANDLED;
-	}
-
-	dsisr = irq_info.dsisr;
-	dar = irq_info.dar;
+	dsisr = irq_info->dsisr;
+	dar = irq_info->dar;
 
 	pr_devel("CXL interrupt %i for afu pe: %i DSISR: %#llx DAR: %#llx\n", irq, ctx->pe, dsisr, dar);
 
@@ -149,9 +142,9 @@ static irqreturn_t cxl_irq(int irq, void *data)
 	if (dsisr & CXL_PSL_DSISR_An_UR)
 		pr_devel("CXL interrupt: AURP PTE not found\n");
 	if (dsisr & CXL_PSL_DSISR_An_PE)
-		return handle_psl_slice_error(ctx, dsisr, irq_info.errstat);
+		return handle_psl_slice_error(ctx, dsisr, irq_info->errstat);
 	if (dsisr & CXL_PSL_DSISR_An_AE) {
-		pr_devel("CXL interrupt: AFU Error %.llx\n", irq_info.afu_err);
+		pr_devel("CXL interrupt: AFU Error %.llx\n", irq_info->afu_err);
 
 		if (ctx->pending_afu_err) {
 			/*
@@ -163,10 +156,10 @@ static irqreturn_t cxl_irq(int irq, void *data)
 			 */
 			dev_err_ratelimited(&ctx->afu->dev, "CXL AFU Error "
 					    "undelivered to pe %i: %.llx\n",
-					    ctx->pe, irq_info.afu_err);
+					    ctx->pe, irq_info->afu_err);
 		} else {
 			spin_lock(&ctx->lock);
-			ctx->afu_err = irq_info.afu_err;
+			ctx->afu_err = irq_info->afu_err;
 			ctx->pending_afu_err = 1;
 			spin_unlock(&ctx->lock);
 
@@ -182,24 +175,43 @@ static irqreturn_t cxl_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t fail_psl_irq(struct cxl_afu *afu, struct cxl_irq_info *irq_info)
+{
+	if (irq_info->dsisr & CXL_PSL_DSISR_TRANS)
+		cxl_p2n_write(afu, CXL_PSL_TFC_An, CXL_PSL_TFC_An_AE);
+	else
+		cxl_p2n_write(afu, CXL_PSL_TFC_An, CXL_PSL_TFC_An_A);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t cxl_irq_multiplexed(int irq, void *data)
 {
 	struct cxl_afu *afu = data;
 	struct cxl_context *ctx;
+	struct cxl_irq_info irq_info;
 	int ph = cxl_p2n_read(afu, CXL_PSL_PEHandle_An) & 0xffff;
 	int ret;
 
+	if ((ret = cxl_get_irq(afu, &irq_info))) {
+		WARN(1, "Unable to get CXL IRQ Info: %i\n", ret);
+		return fail_psl_irq(afu, &irq_info);
+	}
+
 	rcu_read_lock();
 	ctx = idr_find(&afu->contexts_idr, ph);
 	if (ctx) {
-		ret = cxl_irq(irq, ctx);
+		ret = cxl_irq(irq, ctx, &irq_info);
 		rcu_read_unlock();
 		return ret;
 	}
 	rcu_read_unlock();
 
-	WARN(1, "Unable to demultiplex CXL PSL IRQ\n");
-	return IRQ_HANDLED;
+	WARN(1, "Unable to demultiplex CXL PSL IRQ for PE %i DSISR %.16llx DAR"
+		" %.16llx\n(Possible AFU HW issue - was a term/remove acked"
+		" with outstanding transactions?)\n", ph, irq_info.dsisr,
+		irq_info.dar);
+	return fail_psl_irq(afu, &irq_info);
 }
 
 static irqreturn_t cxl_irq_afu(int irq, void *data)
diff --git a/drivers/misc/cxl/native.c b/drivers/misc/cxl/native.c
index d47532e..9a5a442 100644
--- a/drivers/misc/cxl/native.c
+++ b/drivers/misc/cxl/native.c
@@ -637,18 +637,18 @@ int cxl_detach_process(struct cxl_context *ctx)
 	return detach_process_native_afu_directed(ctx);
 }
 
-int cxl_get_irq(struct cxl_context *ctx, struct cxl_irq_info *info)
+int cxl_get_irq(struct cxl_afu *afu, struct cxl_irq_info *info)
 {
 	u64 pidtid;
 
-	info->dsisr = cxl_p2n_read(ctx->afu, CXL_PSL_DSISR_An);
-	info->dar = cxl_p2n_read(ctx->afu, CXL_PSL_DAR_An);
-	info->dsr = cxl_p2n_read(ctx->afu, CXL_PSL_DSR_An);
-	pidtid = cxl_p2n_read(ctx->afu, CXL_PSL_PID_TID_An);
+	info->dsisr = cxl_p2n_read(afu, CXL_PSL_DSISR_An);
+	info->dar = cxl_p2n_read(afu, CXL_PSL_DAR_An);
+	info->dsr = cxl_p2n_read(afu, CXL_PSL_DSR_An);
+	pidtid = cxl_p2n_read(afu, CXL_PSL_PID_TID_An);
 	info->pid = pidtid >> 32;
 	info->tid = pidtid & 0xffffffff;
-	info->afu_err = cxl_p2n_read(ctx->afu, CXL_AFU_ERR_An);
-	info->errstat = cxl_p2n_read(ctx->afu, CXL_PSL_ErrStat_An);
+	info->afu_err = cxl_p2n_read(afu, CXL_AFU_ERR_An);
+	info->errstat = cxl_p2n_read(afu, CXL_PSL_ErrStat_An);
 
 	return 0;
 }
-- 
2.1.1

