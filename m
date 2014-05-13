Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129AbaEMKOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:14:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933663AbaEMKLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 130/182] arm: KVM: fix possible misalignment of PGDs and bounce page
Date: Tue, 13 May 2014 11:28:02 +0200
Message-Id: <9de8b0ca7dfc5c14fb25a74d35a5892a5ff25e69.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/kvm/mmu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index cb79a5dd6d96..fe59e4a19022 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -41,6 +41,8 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
+#define pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
+
 static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
 	/*
@@ -172,14 +174,14 @@ void free_boot_hyp_pgd(void)
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
@@ -209,7 +211,7 @@ void free_hyp_pgds(void)
 		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
 			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
 
-		kfree(hyp_pgd);
+		free_pages((unsigned long)hyp_pgd, pgd_order);
 		hyp_pgd = NULL;
 	}
 
@@ -781,7 +783,7 @@ int kvm_mmu_init(void)
 		size_t len = __hyp_idmap_text_end - __hyp_idmap_text_start;
 		phys_addr_t phys_base;
 
-		init_bounce_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		init_bounce_page = (void *)__get_free_page(GFP_KERNEL);
 		if (!init_bounce_page) {
 			kvm_err("Couldn't allocate HYP init bounce page\n");
 			err = -ENOMEM;
@@ -807,8 +809,9 @@ int kvm_mmu_init(void)
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
-- 
1.9.3

