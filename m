Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbaEKUAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:00:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbaEKTUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:20:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 3.14 08/83] arm: KVM: fix possible misalignment of PGDs and bounce page
Date: Sun, 11 May 2014 21:19:09 +0200
Message-Id: <20140511191908.183594918@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Salter <msalter@redhat.com>

commit 5d4e08c45a6cf8f1ab3c7fa375007635ac569165 upstream.

The kvm/mmu code shared by arm and arm64 uses kalloc() to allocate
a bounce page (if hypervisor init code crosses page boundary) and
hypervisor PGDs. The problem is that kalloc() does not guarantee
the proper alignment. In the case of the bounce page, the page sized
buffer allocated may also cross a page boundary negating the purpose
and leading to a hang during kvm initialization. Likewise the PGDs
allocated may not meet the minimum alignment requirements of the
underlying MMU. This patch uses __get_free_page() to guarantee the
worst case alignment needs of the bounce page and PGDs on both arm
and arm64.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kvm/mmu.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -42,6 +42,8 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
+#define pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
+
 #define kvm_pmd_huge(_x)	(pmd_huge(_x) || pmd_trans_huge(_x))
 
 static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
@@ -199,14 +201,14 @@ void free_boot_hyp_pgd(void)
 	if (boot_hyp_pgd) {
 		unmap_range(NULL, boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
 		unmap_range(NULL, boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
-		kfree(boot_hyp_pgd);
+		free_pages((unsigned long)boot_hyp_pgd, pgd_order);
 		boot_hyp_pgd = NULL;
 	}
 
 	if (hyp_pgd)
 		unmap_range(NULL, hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
 
-	kfree(init_bounce_page);
+	free_page((unsigned long)init_bounce_page);
 	init_bounce_page = NULL;
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
@@ -236,7 +238,7 @@ void free_hyp_pgds(void)
 		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
 			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
 
-		kfree(hyp_pgd);
+		free_pages((unsigned long)hyp_pgd, pgd_order);
 		hyp_pgd = NULL;
 	}
 
@@ -930,7 +932,7 @@ int kvm_mmu_init(void)
 		size_t len = __hyp_idmap_text_end - __hyp_idmap_text_start;
 		phys_addr_t phys_base;
 
-		init_bounce_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		init_bounce_page = (void *)__get_free_page(GFP_KERNEL);
 		if (!init_bounce_page) {
 			kvm_err("Couldn't allocate HYP init bounce page\n");
 			err = -ENOMEM;
@@ -956,8 +958,9 @@ int kvm_mmu_init(void)
 			 (unsigned long)phys_base);
 	}
 
-	hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
-	boot_hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
+	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, pgd_order);
+	boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, pgd_order);
+
 	if (!hyp_pgd || !boot_hyp_pgd) {
 		kvm_err("Hyp mode PGD not allocated\n");
 		err = -ENOMEM;


