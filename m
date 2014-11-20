Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbaKTWO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:14:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:53437 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaKTWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:14:26 -0500
Date: Thu, 20 Nov 2014 23:14:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL updated] x86 fixes
In-Reply-To: <20141120080227.GA4969@gmail.com>
Message-ID: <alpine.DEB.2.11.1411202307530.3950@nanos>
References: <20141120080227.GA4969@gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

this is an updated pull request for the x86 urgent stuff sent by Ingo
earlier. Updated with the obvious TIF_NOHZ bug fix.

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

Misc fixes: 
     - gold linker build fix
     - noxsave command line parsing fix
     - Bugfix for NX setup
     - Microcode resume path bug fix
     - _TIF_NOHZ versus TIF_NOHZ bugfix as discussed in the mysterious
       lockup thread

Thanks,

	tglx

------------------>
Andy Lutomirski (1):
      x86, syscall: Fix _TIF_NOHZ handling in syscall_trace_enter_phase1

Borislav Petkov (1):
      x86, microcode: Update BSPs microcode on resume

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

Kees Cook (2):
      x86, mm: Set NX across entire PMD at boot
      x86, kaslr: Handle Gold linker for finding bss/brk


 arch/x86/kernel/cpu/common.c         |  2 ++
 arch/x86/kernel/cpu/microcode/core.c |  8 ++++++++
 arch/x86/kernel/ptrace.c             |  2 +-
 arch/x86/mm/init_64.c                | 11 ++++++++++-
 arch/x86/tools/calc_run_size.pl      | 11 ++++++++++-
 5 files changed, 31 insertions(+), 3 deletions(-)

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
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 749b0e423419..e510618b2e91 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1484,7 +1484,7 @@ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
 	 */
 	if (work & _TIF_NOHZ) {
 		user_exit();
-		work &= ~TIF_NOHZ;
+		work &= ~_TIF_NOHZ;
 	}
 
 #ifdef CONFIG_SECCOMP
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
