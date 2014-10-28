Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaJ1D0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:26:36 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:53206 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaJ1D0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:26:35 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: mpe <mpe@ellerman.id.au>
Cc: greg <greg@kroah.com>, arnd <arnd@arndb.de>,
        benh <benh@kernel.crashing.org>, mikey <mikey@neuling.org>,
        anton <anton@samba.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, jk <jk@ozlabs.org>,
        imunsie <imunsie@au1.ibm.com>,
        cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 2/4] CXL: Refactor cxl_load_segment and find_free_sste
Date: Tue, 28 Oct 2014 14:25:28 +1100
Message-Id: <1414466730-15591-3-git-send-email-imunsie@au.ibm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414466730-15591-1-git-send-email-imunsie@au.ibm.com>
References: <1414466730-15591-1-git-send-email-imunsie@au.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102803-0033-0000-0000-000000664EAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This moves the segment table hash calculation from cxl_load_segment into
find_free_sste since that is the only place it is actually used.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 drivers/misc/cxl/fault.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/cxl/fault.c b/drivers/misc/cxl/fault.c
index d0e97fd..cb4f323 100644
--- a/drivers/misc/cxl/fault.c
+++ b/drivers/misc/cxl/fault.c
@@ -21,20 +21,30 @@
 
 #include "cxl.h"
 
-static struct cxl_sste* find_free_sste(struct cxl_sste *primary_group,
-				       unsigned int *lru)
+/* This finds a free SSTE for the given SLB */
+static struct cxl_sste* find_free_sste(struct cxl_context *ctx,
+				       struct copro_slb *slb)
 {
+	struct cxl_sste *primary, *sste;
+	unsigned int mask = (ctx->sst_size >> 7) - 1; /* SSTP0[SegTableSize] */
 	unsigned int entry;
-	struct cxl_sste *sste, *group = primary_group;
+	unsigned int hash;
+
+	if (slb->vsid & SLB_VSID_B_1T)
+		hash = (slb->esid >> SID_SHIFT_1T) & mask;
+	else /* 256M */
+		hash = (slb->esid >> SID_SHIFT) & mask;
 
-	for (entry = 0; entry < 8; entry++) {
-		sste = group + entry;
+	primary = ctx->sstp + (hash << 3);
+
+	for (entry = 0, sste = primary; entry < 8; entry++, sste++) {
 		if (!(be64_to_cpu(sste->esid_data) & SLB_ESID_V))
 			return sste;
 	}
+
 	/* Nothing free, select an entry to cast out */
-	sste = primary_group + *lru;
-	*lru = (*lru + 1) & 0x7;
+	sste = primary + ctx->sst_lru;
+	ctx->sst_lru = (ctx->sst_lru + 1) & 0x7;
 
 	return sste;
 }
@@ -42,19 +52,11 @@ static struct cxl_sste* find_free_sste(struct cxl_sste *primary_group,
 static void cxl_load_segment(struct cxl_context *ctx, struct copro_slb *slb)
 {
 	/* mask is the group index, we search primary and secondary here. */
-	unsigned int mask = (ctx->sst_size >> 7)-1; /* SSTP0[SegTableSize] */
 	struct cxl_sste *sste;
-	unsigned int hash;
 	unsigned long flags;
 
-
-	if (slb->vsid & SLB_VSID_B_1T)
-		hash = (slb->esid >> SID_SHIFT_1T) & mask;
-	else /* 256M */
-		hash = (slb->esid >> SID_SHIFT) & mask;
-
 	spin_lock_irqsave(&ctx->sste_lock, flags);
-	sste = find_free_sste(ctx->sstp + (hash << 3), &ctx->sst_lru);
+	sste = find_free_sste(ctx, slb);
 
 	pr_devel("CXL Populating SST[%li]: %#llx %#llx\n",
 			sste - ctx->sstp, slb->vsid, slb->esid);
-- 
2.1.1

