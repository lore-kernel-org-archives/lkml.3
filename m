Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241Ab3AXUV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:21:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49500 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3AXUUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:20:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/35] x86, 64bit: Don't set max_pfn_mapped wrong value early on native path
Date: Thu, 24 Jan 2013 12:19:54 -0800
Message-Id: <1359058816-7615-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are not having max_pfn_mapped set correctly until init_memory_mapping.
So don't print its initial value for 64bit

Also need to use KERNEL_IMAGE_SIZE directly for highmap cleanup.

-v2: update comments about max_pfn_mapped according to Stefano Stabellini.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head64.c |    3 ---
 arch/x86/kernel/setup.c  |    2 ++
 arch/x86/mm/init_64.c    |   10 +++++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index a3fc233..7061d8b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -146,9 +146,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
-	/* XXX - this is wrong... we need to build page tables from scratch */
-	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
-
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8e996e0..a3ef12e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -996,8 +996,10 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
+#ifdef CONFIG_X86_32
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
+#endif
 
 	reserve_real_mode();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f40b6c8..64e6fe0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -378,10 +378,18 @@ void __init init_extra_mapping_uc(unsigned long phys, unsigned long size)
 void __init cleanup_highmap(void)
 {
 	unsigned long vaddr = __START_KERNEL_map;
-	unsigned long vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+	unsigned long vaddr_end = __START_KERNEL_map + KERNEL_IMAGE_SIZE;
 	unsigned long end = roundup((unsigned long)_brk_end, PMD_SIZE) - 1;
 	pmd_t *pmd = level2_kernel_pgt;
 
+	/*
+	 * Native path, max_pfn_mapped is not set yet.
+	 * Xen has valid max_pfn_mapped set in
+	 *	arch/x86/xen/mmu.c:xen_setup_kernel_pagetable().
+	 */
+	if (max_pfn_mapped)
+		vaddr_end = __START_KERNEL_map + (max_pfn_mapped << PAGE_SHIFT);
+
 	for (; vaddr + PMD_SIZE - 1 < vaddr_end; pmd++, vaddr += PMD_SIZE) {
 		if (pmd_none(*pmd))
 			continue;
-- 
1.7.10.4

