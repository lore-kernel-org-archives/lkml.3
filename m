Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3A3Bcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:32:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3A3Bcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:32:39 -0500
Date: Tue, 29 Jan 2013 17:31:42 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-100542306f644fc580857a8ca4896fb12b794d41@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-14-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-14-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, 64bit: Don'
 t set max_pfn_mapped wrong value early on native path
Git-Commit-ID: 100542306f644fc580857a8ca4896fb12b794d41
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:31:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  100542306f644fc580857a8ca4896fb12b794d41
Gitweb:     http://git.kernel.org/tip/100542306f644fc580857a8ca4896fb12b794d41
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:54 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:20:16 -0800

x86, 64bit: Don't set max_pfn_mapped wrong value early on native path

We are not having max_pfn_mapped set correctly until init_memory_mapping.
So don't print its initial value for 64bit

Also need to use KERNEL_IMAGE_SIZE directly for highmap cleanup.

-v2: update comments about max_pfn_mapped according to Stefano Stabellini.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-14-git-send-email-yinghai@kernel.org
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head64.c |  3 ---
 arch/x86/kernel/setup.c  |  2 ++
 arch/x86/mm/init_64.c    | 10 +++++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 816fc85..f3b1968 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -148,9 +148,6 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* clear bss before set_intr_gate with early_idt_handler */
 	clear_bss();
 
-	/* XXX - this is wrong... we need to build page tables from scratch */
-	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
-
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index db9c41d..d58083a 100644
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
index 9fbb85c..dc67337 100644
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
