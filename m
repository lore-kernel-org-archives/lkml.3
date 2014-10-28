Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaJ1DZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:25:41 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53102 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaJ1DZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:25:39 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 1/4] CXL: Disable secondary hash in segment table
Date: Tue, 28 Oct 2014 14:25:27 +1100
Message-Id: <1414466730-15591-2-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414466730-15591-1-git-send-email-imunsie@au.ibm.com>
References: <1414466730-15591-1-git-send-email-imunsie@au.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102803-0033-0000-0000-000000664E60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch simplifies the process of finding a free segment table entry
by disabling the secondary hash. This reduces the number of possible
entries in the segment table for a given address from 16 to 8.

Due to the large segment sizes we use it is extremely unlikely that the
secondary hash would ever have been used in practice, so this should not
have any negative impacts and may even improve performance due to the
reduced number of comparisons that software & hardware need to perform.

This patch clears the SC bit in the hardware's state register
(CXL_PSL_SR_An) to disable the secondary hash in the hardware since we
can no longer fill out entries using it.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/fault.c  | 30 ++++++++----------------------
 drivers/misc/cxl/native.c |  4 ++--
 2 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/cxl/fault.c b/drivers/misc/cxl/fault.c
index 69506eb..d0e97fd 100644
--- a/drivers/misc/cxl/fault.c
+++ b/drivers/misc/cxl/fault.c
@@ -22,29 +22,19 @@
 #include "cxl.h"
 
 static struct cxl_sste* find_free_sste(struct cxl_sste *primary_group,
-				       bool sec_hash,
-				       struct cxl_sste *secondary_group,
 				       unsigned int *lru)
 {
-	unsigned int i, entry;
+	unsigned int entry;
 	struct cxl_sste *sste, *group = primary_group;
 
-	for (i = 0; i < 2; i++) {
-		for (entry = 0; entry < 8; entry++) {
-			sste = group + entry;
-			if (!(be64_to_cpu(sste->esid_data) & SLB_ESID_V))
-				return sste;
-		}
-		if (!sec_hash)
-			break;
-		group = secondary_group;
+	for (entry = 0; entry < 8; entry++) {
+		sste = group + entry;
+		if (!(be64_to_cpu(sste->esid_data) & SLB_ESID_V))
+			return sste;
 	}
 	/* Nothing free, select an entry to cast out */
-	if (sec_hash && (*lru & 0x8))
-		sste = secondary_group + (*lru & 0x7);
-	else
-		sste = primary_group + (*lru & 0x7);
-	*lru = (*lru + 1) & 0xf;
+	sste = primary_group + *lru;
+	*lru = (*lru + 1) & 0x7;
 
 	return sste;
 }
@@ -53,22 +43,18 @@ static void cxl_load_segment(struct cxl_context *ctx, struct copro_slb *slb)
 {
 	/* mask is the group index, we search primary and secondary here. */
 	unsigned int mask = (ctx->sst_size >> 7)-1; /* SSTP0[SegTableSize] */
-	bool sec_hash = 1;
 	struct cxl_sste *sste;
 	unsigned int hash;
 	unsigned long flags;
 
 
-	sec_hash = !!(cxl_p1n_read(ctx->afu, CXL_PSL_SR_An) & CXL_PSL_SR_An_SC);
-
 	if (slb->vsid & SLB_VSID_B_1T)
 		hash = (slb->esid >> SID_SHIFT_1T) & mask;
 	else /* 256M */
 		hash = (slb->esid >> SID_SHIFT) & mask;
 
 	spin_lock_irqsave(&ctx->sste_lock, flags);
-	sste = find_free_sste(ctx->sstp + (hash << 3), sec_hash,
-			      ctx->sstp + ((~hash & mask) << 3), &ctx->sst_lru);
+	sste = find_free_sste(ctx->sstp + (hash << 3), &ctx->sst_lru);
 
 	pr_devel("CXL Populating SST[%li]: %#llx %#llx\n",
 			sste - ctx->sstp, slb->vsid, slb->esid);
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

