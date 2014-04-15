Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaDOORS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:17:18 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58075 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbaDOOQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121257955"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 6/9] x86/xen: do not use _PAGE_IOMAP in xen_remap_domain_mfn_range()
Date: Tue, 15 Apr 2014 15:15:34 +0100
Message-ID: <1397571337-20409-7-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
References: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_PAGE_IOMAP is used in xen_remap_domain_mfn_range() to prevent the
pfn_pte() call in remap_area_mfn_pte_fn() from using the p2m to translate
the MFN.  If mfn_pte() is used instead, the p2m look up is avoided and
the use of _PAGE_IOMAP is no longer needed.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/mmu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 86e02ea..d916024 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2522,7 +2522,7 @@ static int remap_area_mfn_pte_fn(pte_t *ptep, pgtable_t token,
 				 unsigned long addr, void *data)
 {
 	struct remap_data *rmd = data;
-	pte_t pte = pte_mkspecial(pfn_pte(rmd->mfn++, rmd->prot));
+	pte_t pte = pte_mkspecial(mfn_pte(rmd->mfn++, rmd->prot));
 
 	rmd->mmu_update->ptr = virt_to_machine(ptep).maddr;
 	rmd->mmu_update->val = pte_val_ma(pte);
@@ -2547,8 +2547,6 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return -EINVAL;
 
-	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
-
 	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_IO)) == (VM_PFNMAP | VM_IO)));
 
 	rmd.mfn = mfn;
-- 
1.7.2.5

