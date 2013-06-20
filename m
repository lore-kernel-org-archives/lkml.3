Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297Ab3FTS2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:28:13 -0400
Received: from 8bytes.org ([85.214.48.195]:35634 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965026Ab3FTS2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:28:12 -0400
Date: Thu, 20 Jun 2013 20:28:08 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: iommu@lists.linux-foundation.org, ddutile@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd_iommu: Fix leak in free_pagetable()
Message-ID: <20130620182808.GC11309@8bytes.org>
References: <20130618014459.20440.73844.stgit@bling.home>
 <20130618015116.20711.90269.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618015116.20711.90269.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 20:28:09 2013
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c349b920861577421911
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 07:52:14PM -0600, Alex Williamson wrote:
>  static void free_pagetable(struct protection_domain *domain)
>  {
> -	int i, j;
> -	u64 *p1, *p2, *p3;
> +	int i, j, k, l, m, depth = domain->mode;
> +	u64 *p1, *p2, *p3, *p4, *p5, *p6;
>  
>  	p1 = domain->pt_root;
>  
>  	if (!p1)
>  		return;
>  
> -	for (i = 0; i < 512; ++i) {
> +	for (i = 0; depth > 1 && i < 512; ++i) {
>  		if (!IOMMU_PTE_PRESENT(p1[i]))
>  			continue;
>  
>  		p2 = IOMMU_PTE_PAGE(p1[i]);
> -		for (j = 0; j < 512; ++j) {
> +		for (j = 0; depth > 2 && j < 512; ++j) {
>  			if (!IOMMU_PTE_PRESENT(p2[j]))
>  				continue;
> +
>  			p3 = IOMMU_PTE_PAGE(p2[j]);
> +			for (k = 0; depth > 3 && k < 512; ++k) {
> +				if (!IOMMU_PTE_PRESENT(p3[k]))
> +					continue;
> +
> +				p4 = IOMMU_PTE_PAGE(p3[k]);
> +				for (l = 0; depth > 4 && l < 512; ++l) {
> +					if (!IOMMU_PTE_PRESENT(p4[l]))
> +						continue;
> +
> +					p5 = IOMMU_PTE_PAGE(p4[l]);
> +					for (m = 0; depth > 5 && m < 512; ++m) {
> +						if (!IOMMU_PTE_PRESENT(p5[m]))
> +							continue;
> +						p6 = IOMMU_PTE_PAGE(p5[m]);
> +						free_page((unsigned long)p6);
> +					}
> +
> +					free_page((unsigned long)p5);
> +				}
> +
> +				free_page((unsigned long)p4);
> +			}
> +
>  			free_page((unsigned long)p3);
>  		}

Hmm, actually a recursive version would make more sense here. But since
recursion is a bad idea in the kernel, how about this approach instead:

>From d500d538ad1370679d05667663dcaf8603d529db Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joro@8bytes.org>
Date: Thu, 20 Jun 2013 20:22:58 +0200
Subject: [PATCH] iommu/amd: Fix memory leak in free_pagetable

The IOMMU pagetables can have up to 3 levels, but the code
in free_pagetable() only releases the first 3 levels. Fix
this leak by releasing all levels.

Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu.c |   73 ++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 21d02b0..5cde682 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1893,34 +1893,59 @@ static void domain_id_free(int id)
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 }
 
+#define DEFINE_FREE_PT_FN(LVL, FN)				\
+static void free_pt_##LVL (unsigned long __pt)			\
+{								\
+	unsigned long p;					\
+	u64 *pt;						\
+	int i;							\
+								\
+	pt = (u64 *)__pt;					\
+								\
+	for (i = 0; i < 512; ++i) {				\
+		if (!IOMMU_PTE_PRESENT(pt[i]))			\
+			continue;				\
+								\
+		p = (unsigned long)IOMMU_PTE_PAGE(pt[i]);	\
+		FN(p);						\
+	}							\
+	free_page((unsigned long)pt);				\
+}
+
+DEFINE_FREE_PT_FN(l2, free_page)
+DEFINE_FREE_PT_FN(l3, free_pt_l2)
+DEFINE_FREE_PT_FN(l4, free_pt_l3)
+DEFINE_FREE_PT_FN(l5, free_pt_l4)
+DEFINE_FREE_PT_FN(l6, free_pt_l5)
+
 static void free_pagetable(struct protection_domain *domain)
 {
-	int i, j;
-	u64 *p1, *p2, *p3;
-
-	p1 = domain->pt_root;
-
-	if (!p1)
-		return;
-
-	for (i = 0; i < 512; ++i) {
-		if (!IOMMU_PTE_PRESENT(p1[i]))
-			continue;
+	unsigned long root = (unsigned long)domain->pt_root;
 
-		p2 = IOMMU_PTE_PAGE(p1[i]);
-		for (j = 0; j < 512; ++j) {
-			if (!IOMMU_PTE_PRESENT(p2[j]))
-				continue;
-			p3 = IOMMU_PTE_PAGE(p2[j]);
-			free_page((unsigned long)p3);
-		}
-
-		free_page((unsigned long)p2);
+	switch (domain->mode) {
+	case PAGE_MODE_NONE:
+		break;
+	case PAGE_MODE_1_LEVEL:
+		free_page(root);
+		break;
+	case PAGE_MODE_2_LEVEL:
+		free_pt_l2(root);
+		break;
+	case PAGE_MODE_3_LEVEL:
+		free_pt_l3(root);
+		break;
+	case PAGE_MODE_4_LEVEL:
+		free_pt_l4(root);
+		break;
+	case PAGE_MODE_5_LEVEL:
+		free_pt_l5(root);
+		break;
+	case PAGE_MODE_6_LEVEL:
+		free_pt_l6(root);
+		break;
+	default:
+		BUG();
 	}
-
-	free_page((unsigned long)p1);
-
-	domain->pt_root = NULL;
 }
 
 static void free_gcr3_tbl_level1(u64 *tbl)
-- 
1.7.9.5




