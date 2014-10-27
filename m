Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111AbaJ0EYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 00:24:55 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48929 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaJ0EYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 00:24:54 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] CXL: Fix PSL error due to duplicate segment table entries
Date: Mon, 27 Oct 2014 15:24:35 +1100
Message-Id: <1414383875-20835-1-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102704-0021-0000-0000-00000068F551
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

In certain circumstances the PSL can send an interrupt for a segment
miss that the kernel has already handled. This can happen if multiple
translations for the same segment are queued in the PSL before the
kernel has restarted the first translation.

The CXL driver did not expect this situation and did not check if a
segment had already been handled. This could cause a duplicate segment
table entry which in turn caused a PSL error taking down the card.

This patch fixes the issue by checking for existing entries in the
segment table that match the segment it is trying to insert to avoid
inserting duplicate entries.

Some of the code has been refactored to simplify it - the segment table
hash has been moved from cxl_load_segment to find_free_sste where it is
used and we have disabled the secondary hash in the segment table to
reduce the number of entries that need to be tested from 16 to 8. Due to
the large segment sizes we use it is extremely unlikely that the
secondary hash would ever have been used in practice, so this should not
have any negative impacts and may even improve performance.

copro_calculate_slb will now mask the ESID by the correct mask for 1T vs
256M segments. This has no effect by itself as the extra bits were
ignored, but it makes debugging the segment table entries easier and
means that we can directly compare the ESID values for duplicates
without needing to worry about masking in the comparison.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/mm/copro_fault.c |  3 +-
 drivers/misc/cxl/fault.c      | 73 ++++++++++++++++++++++---------------------
 drivers/misc/cxl/native.c     |  4 +--
 3 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
index 0f9939e..5a236f0 100644
--- a/arch/powerpc/mm/copro_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -99,8 +99,6 @@ int copro_calculate_slb(struct mm_struct *mm, u64 ea, struct copro_slb *slb)
 	u64 vsid;
 	int psize, ssize;
 
-	slb->esid = (ea & ESID_MASK) | SLB_ESID_V;
-
 	switch (REGION_ID(ea)) {
 	case USER_REGION_ID:
 		pr_devel("%s: 0x%llx -- USER_REGION_ID\n", __func__, ea);
@@ -133,6 +131,7 @@ int copro_calculate_slb(struct mm_struct *mm, u64 ea, struct copro_slb *slb)
 	vsid |= mmu_psize_defs[psize].sllp |
 		((ssize == MMU_SEGSIZE_1T) ? SLB_VSID_B_1T : 0);
 
+	slb->esid = (ea & (ssize == MMU_SEGSIZE_1T ? ESID_MASK_1T : ESID_MASK)) | SLB_ESID_V;
 	slb->vsid = vsid;
 
 	return 0;
diff --git a/drivers/misc/cxl/fault.c b/drivers/misc/cxl/fault.c
index 69506eb..421cfd6 100644
--- a/drivers/misc/cxl/fault.c
+++ b/drivers/misc/cxl/fault.c
@@ -21,60 +21,63 @@
 
 #include "cxl.h"
 
-static struct cxl_sste* find_free_sste(struct cxl_sste *primary_group,
-				       bool sec_hash,
-				       struct cxl_sste *secondary_group,
-				       unsigned int *lru)
+static bool sste_matches(struct cxl_sste *sste, struct copro_slb *slb)
 {
-	unsigned int i, entry;
-	struct cxl_sste *sste, *group = primary_group;
-
-	for (i = 0; i < 2; i++) {
-		for (entry = 0; entry < 8; entry++) {
-			sste = group + entry;
-			if (!(be64_to_cpu(sste->esid_data) & SLB_ESID_V))
-				return sste;
-		}
-		if (!sec_hash)
-			break;
-		group = secondary_group;
+	return ((sste->vsid_data == cpu_to_be64(slb->vsid)) &&
+		(sste->esid_data == cpu_to_be64(slb->esid)));
+}
+
+/* This finds a free SSTE and checks to see if it's already in table */
+static struct cxl_sste* find_free_sste(struct cxl_context *ctx,
+				       struct copro_slb *slb)
+{
+	struct cxl_sste *primary, *sste, *ret = NULL;
+	unsigned int mask = (ctx->sst_size >> 7) - 1; /* SSTP0[SegTableSize] */
+	unsigned int entry;
+	unsigned int hash;
+
+	if (slb->vsid & SLB_VSID_B_1T)
+		hash = (slb->esid >> SID_SHIFT_1T) & mask;
+	else /* 256M */
+		hash = (slb->esid >> SID_SHIFT) & mask;
+
+	primary = ctx->sstp + (hash << 3);
+	sste = primary;
+
+	for (entry = 0; entry < 8; entry++) {
+		if (!ret && !(be64_to_cpu(sste->esid_data) & SLB_ESID_V))
+			ret = sste;
+		if (sste_matches(sste, slb))
+			return NULL;
+		sste++;
 	}
+	if (ret)
+		return ret;
+
 	/* Nothing free, select an entry to cast out */
-	if (sec_hash && (*lru & 0x8))
-		sste = secondary_group + (*lru & 0x7);
-	else
-		sste = primary_group + (*lru & 0x7);
-	*lru = (*lru + 1) & 0xf;
+	ret = primary + ctx->sst_lru;
+	ctx->sst_lru = (ctx->sst_lru + 1) & 0x7;
 
-	return sste;
+	return ret;
 }
 
 static void cxl_load_segment(struct cxl_context *ctx, struct copro_slb *slb)
 {
 	/* mask is the group index, we search primary and secondary here. */
-	unsigned int mask = (ctx->sst_size >> 7)-1; /* SSTP0[SegTableSize] */
-	bool sec_hash = 1;
 	struct cxl_sste *sste;
-	unsigned int hash;
 	unsigned long flags;
 
-
-	sec_hash = !!(cxl_p1n_read(ctx->afu, CXL_PSL_SR_An) & CXL_PSL_SR_An_SC);
-
-	if (slb->vsid & SLB_VSID_B_1T)
-		hash = (slb->esid >> SID_SHIFT_1T) & mask;
-	else /* 256M */
-		hash = (slb->esid >> SID_SHIFT) & mask;
-
 	spin_lock_irqsave(&ctx->sste_lock, flags);
-	sste = find_free_sste(ctx->sstp + (hash << 3), sec_hash,
-			      ctx->sstp + ((~hash & mask) << 3), &ctx->sst_lru);
+	sste = find_free_sste(ctx, slb);
+	if (!sste)
+		goto out_unlock;
 
 	pr_devel("CXL Populating SST[%li]: %#llx %#llx\n",
 			sste - ctx->sstp, slb->vsid, slb->esid);
 
 	sste->vsid_data = cpu_to_be64(slb->vsid);
 	sste->esid_data = cpu_to_be64(slb->esid);
+out_unlock:
 	spin_unlock_irqrestore(&ctx->sste_lock, flags);
 }
 
diff --git a/drivers/misc/cxl/native.c b/drivers/misc/cxl/native.c
index 623286a..d47532e 100644
--- a/drivers/misc/cxl/native.c
+++ b/drivers/misc/cxl/native.c
@@ -417,7 +417,7 @@ static int attach_afu_directed(struct cxl_context *ctx, u64 wed, u64 amr)
 	ctx->elem->haurp = 0; /* disable */
 	ctx->elem->sdr = cpu_to_be64(mfspr(SPRN_SDR1));
 
-	sr = CXL_PSL_SR_An_SC;
+	sr = 0;
 	if (ctx->master)
 		sr |= CXL_PSL_SR_An_MP;
 	if (mfspr(SPRN_LPCR) & LPCR_TC)
@@ -508,7 +508,7 @@ static int attach_dedicated(struct cxl_context *ctx, u64 wed, u64 amr)
 	u64 sr;
 	int rc;
 
-	sr = CXL_PSL_SR_An_SC;
+	sr = 0;
 	set_endian(sr);
 	if (ctx->master)
 		sr |= CXL_PSL_SR_An_MP;
-- 
2.1.1

