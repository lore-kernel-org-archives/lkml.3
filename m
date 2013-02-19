Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143Ab3BSP1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:27:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55012 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab3BSP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:27:51 -0500
Date: Tue, 19 Feb 2013 16:27:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug changes for v3.9
Message-ID: <20130219152747.GA15164@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   HEAD: 20bf062c6575e162ede00308ca3a5714ca112009 x86/memtest: Shorten time for tests

Two init annotations and a built-in memtest speedup.

 Thanks,

	Ingo

------------------>
Alexander Holler (1):
      x86/memtest: Shorten time for tests

Jan Beulich (2):
      x86/EFI: Properly init-annotate BGRT code
      x86: Convert a few mistaken __cpuinit annotations to __init


 arch/x86/kernel/cpu/intel_cacheinfo.c |  2 +-
 arch/x86/mm/memtest.c                 | 10 ++--------
 arch/x86/mm/tlb.c                     |  2 +-
 arch/x86/platform/efi/efi-bgrt.c      |  7 ++++---
 arch/x86/platform/sfi/sfi.c           |  2 +-
 5 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fe9edec..0e46240 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -1227,7 +1227,7 @@ static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier = {
 	.notifier_call = cacheinfo_cpu_callback,
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int __init cache_sysfs_init(void)
 {
 	int i;
 
diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c80b9fb..8dabbed 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -9,6 +9,7 @@
 #include <linux/memblock.h>
 
 static u64 patterns[] __initdata = {
+	/* The first entry has to be 0 to leave memtest with zeroed memory */
 	0,
 	0xffffffffffffffffULL,
 	0x5555555555555555ULL,
@@ -110,15 +111,8 @@ void __init early_memtest(unsigned long start, unsigned long end)
 		return;
 
 	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
-	for (i = 0; i < memtest_pattern; i++) {
+	for (i = memtest_pattern-1; i < UINT_MAX; --i) {
 		idx = i % ARRAY_SIZE(patterns);
 		do_one_pass(patterns[idx], start, end);
 	}
-
-	if (idx > 0) {
-		printk(KERN_INFO "early_memtest: wipe out "
-		       "test pattern from memory\n");
-		/* additional test with pattern 0 will do this */
-		do_one_pass(0, start, end);
-	}
 }
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 13a6b29..282375f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -335,7 +335,7 @@ static const struct file_operations fops_tlbflush = {
 	.llseek = default_llseek,
 };
 
-static int __cpuinit create_tlb_flushall_shift(void)
+static int __init create_tlb_flushall_shift(void)
 {
 	debugfs_create_file("tlb_flushall_shift", S_IRUSR | S_IWUSR,
 			    arch_debugfs_dir, NULL, &fops_tlbflush);
diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index d9c1b95..7145ec6 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -11,20 +11,21 @@
  * published by the Free Software Foundation.
  */
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/acpi.h>
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 
 struct acpi_table_bgrt *bgrt_tab;
-void *bgrt_image;
-size_t bgrt_image_size;
+void *__initdata bgrt_image;
+size_t __initdata bgrt_image_size;
 
 struct bmp_header {
 	u16 id;
 	u32 size;
 } __packed;
 
-void efi_bgrt_init(void)
+void __init efi_bgrt_init(void)
 {
 	acpi_status status;
 	void __iomem *image;
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index 7785b72..bcd1a70 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -35,7 +35,7 @@
 static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 
 /* All CPUs enumerated by SFI must be present and enabled */
-static void __cpuinit mp_sfi_register_lapic(u8 id)
+static void __init mp_sfi_register_lapic(u8 id)
 {
 	if (MAX_LOCAL_APIC - id <= 0) {
 		pr_warning("Processor #%d invalid (max %d)\n",
