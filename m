Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaABVzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:55:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33181 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaABVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:44 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCHv3 10/11] arm: Use for_each_potential_vmalloc_area
Date: Thu,  2 Jan 2014 13:53:28 -0800
Message-Id: <1388699609-18214-11-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_INTERMIX_VMALLOC it is no longer the case that all
vmalloc is contained between VMALLOC_START and VMALLOC_END.
Some portions of code still rely on operating on all those regions
however. Use for_each_potential_vmalloc_area where appropriate to
do whatever is necessary to those regions.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 arch/arm/kvm/mmu.c    |   12 ++++++++----
 arch/arm/mm/ioremap.c |   12 ++++++++----
 arch/arm/mm/mmu.c     |    9 +++++++--
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 58090698..4d2ca7e 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -225,16 +225,20 @@ void free_boot_hyp_pgd(void)
 void free_hyp_pgds(void)
 {
 	unsigned long addr;
+	int i;
+	unsigned long vstart, unsigned long vend;
 
 	free_boot_hyp_pgd();
 
 	mutex_lock(&kvm_hyp_pgd_mutex);
 
 	if (hyp_pgd) {
-		for (addr = PAGE_OFFSET; virt_addr_valid(addr); addr += PGDIR_SIZE)
-			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
-		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
-			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
+		for_each_potential_nonvmalloc_area(&vstart, &vend, &i)
+			for (addr = vstart; addr < vend; addr += PGDIR_SIZE)
+				unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
+		for_each_potential_vmalloc_area(&vstart, &vend, &i)
+			for (addr = vstart; addr < vend; addr += PGDIR_SIZE)
+				unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
 
 		kfree(hyp_pgd);
 		hyp_pgd = NULL;
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index ad92d4f..892bc82 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -115,13 +115,17 @@ EXPORT_SYMBOL(ioremap_page);
 void __check_vmalloc_seq(struct mm_struct *mm)
 {
 	unsigned int seq;
+	int i;
+	unsigned long vstart, vend;
 
 	do {
 		seq = init_mm.context.vmalloc_seq;
-		memcpy(pgd_offset(mm, VMALLOC_START),
-		       pgd_offset_k(VMALLOC_START),
-		       sizeof(pgd_t) * (pgd_index(VMALLOC_END) -
-					pgd_index(VMALLOC_START)));
+
+		for_each_potential_vmalloc_area(&vstart, &vend, &i)
+			memcpy(pgd_offset(mm, vstart),
+			       pgd_offset_k(vstart),
+			       sizeof(pgd_t) * (pgd_index(vend) -
+						pgd_index(vstart)));
 		mm->context.vmalloc_seq = seq;
 	} while (seq != init_mm.context.vmalloc_seq);
 }
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 55bd742..af8e43c 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1217,6 +1217,8 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
 	struct map_desc map;
 	unsigned long addr;
 	void *vectors;
+	unsigned long vstart, vend;
+	int i;
 
 	/*
 	 * Allocate the vector page early.
@@ -1225,8 +1227,11 @@ static void __init devicemaps_init(const struct machine_desc *mdesc)
 
 	early_trap_init(vectors);
 
-	for (addr = VMALLOC_START; addr; addr += PMD_SIZE)
-		pmd_clear(pmd_off_k(addr));
+
+	for_each_potential_vmalloc_area(&vstart, &vend, &i)
+		for (addr = vstart; addr < vend; addr += PMD_SIZE) {
+			pmd_clear(pmd_off_k(addr));
+	}
 
 	/*
 	 * Map the kernel if it is XIP.
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

