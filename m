Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbaKTICi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:02:38 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41049 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaKTICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:02:36 -0500
Date: Thu, 20 Nov 2014 09:02:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20141120080227.GA4969@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 70b61e362187b5fccac206506d402f3424e3e749 x86, kaslr: Handle Gold linker for finding bss/brk

Misc fixes: gold linker build fix, noxsave command line parsing 
fix, NX setup fix and microcode fix.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, microcode: Update BSPs microcode on resume

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

Kees Cook (2):
      x86, mm: Set NX across entire PMD at boot
      x86, kaslr: Handle Gold linker for finding bss/brk


 arch/x86/kernel/cpu/common.c         |  2 ++
 arch/x86/kernel/cpu/microcode/core.c |  8 ++++++++
 arch/x86/mm/init_64.c                | 11 ++++++++++-
 arch/x86/tools/calc_run_size.pl      | 11 ++++++++++-
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b4f78c9ba19..cfa9b5b2c27a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -146,6 +146,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 
 static int __init x86_xsave_setup(char *s)
 {
+	if (strlen(s))
+		return 0;
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index dd9d6190b08d..2ce9051174e6 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -465,6 +465,14 @@ static void mc_bp_resume(void)
 
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
+	else if (!uci->mc)
+		/*
+		 * We might resume and not have applied late microcode but still
+		 * have a newer patch stashed from the early loader. We don't
+		 * have it in uci->mc so we have to load it the same way we're
+		 * applying patches early on the APs.
+		 */
+		load_ucode_ap();
 }
 
 static struct syscore_ops mc_syscore_ops = {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 4cb8763868fc..4e5dfec750fc 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1123,7 +1123,7 @@ void mark_rodata_ro(void)
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-	unsigned long all_end = PFN_ALIGN(&_end);
+	unsigned long all_end;
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -1134,7 +1134,16 @@ void mark_rodata_ro(void)
 	/*
 	 * The rodata/data/bss/brk section (but not the kernel text!)
 	 * should also be not-executable.
+	 *
+	 * We align all_end to PMD_SIZE because the existing mapping
+	 * is a full PMD. If we would align _brk_end to PAGE_SIZE we
+	 * split the PMD and the reminder between _brk_end and the end
+	 * of the PMD will remain mapped executable.
+	 *
+	 * Any PMD which was setup after the one which covers _brk_end
+	 * has been zapped already via cleanup_highmem().
 	 */
+	all_end = roundup((unsigned long)_brk_end, PMD_SIZE);
 	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
diff --git a/arch/x86/tools/calc_run_size.pl b/arch/x86/tools/calc_run_size.pl
index 0b0b124d3ece..23210baade2d 100644
--- a/arch/x86/tools/calc_run_size.pl
+++ b/arch/x86/tools/calc_run_size.pl
@@ -19,7 +19,16 @@ while (<>) {
 		if ($file_offset == 0) {
 			$file_offset = $offset;
 		} elsif ($file_offset != $offset) {
-			die ".bss and .brk lack common file offset\n";
+			# BFD linker shows the same file offset in ELF.
+			# Gold linker shows them as consecutive.
+			next if ($file_offset + $mem_size == $offset + $size);
+
+			printf STDERR "file_offset: 0x%lx\n", $file_offset;
+			printf STDERR "mem_size: 0x%lx\n", $mem_size;
+			printf STDERR "offset: 0x%lx\n", $offset;
+			printf STDERR "size: 0x%lx\n", $size;
+
+			die ".bss and .brk are non-contiguous\n";
 		}
 	}
 }
