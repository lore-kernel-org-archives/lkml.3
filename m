Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3BDSbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:31:11 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50213 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3BDSbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:31:09 -0500
Date: Mon, 4 Feb 2013 19:31:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20130204183103.GA13132@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: f76e39c531304b114e27c3dd3e0036f56cd33df1 x86/intel/cacheinfo: Shut up annoying warning

Three small fixlets.

 Thanks,

	Ingo

------------------> Borislav Petkov (1):

H. Peter Anvin (1):
      x86, doc: Boot protocol 2.12 is in 3.8

Jan Beulich (1):
      x86-64: Replace left over sti/cli in ia32 audit exit code


 Documentation/x86/boot.txt            | 2 +-
 arch/x86/ia32/ia32entry.S             | 4 ++--
 arch/x86/kernel/cpu/intel_cacheinfo.c | 7 +++----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 3edb4c2..e540fd6 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -57,7 +57,7 @@ Protocol 2.10:	(Kernel 2.6.31) Added a protocol for relaxed alignment
 Protocol 2.11:	(Kernel 3.6) Added a field for offset of EFI handover
 		protocol entry point.
 
-Protocol 2.12:	(Kernel 3.9) Added the xloadflags field and extension fields
+Protocol 2.12:	(Kernel 3.8) Added the xloadflags field and extension fields
 	 	to struct boot_params for for loading bzImage and ramdisk
 		above 4G in 64bit.
 
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 102ff7c..142c4ce 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -207,7 +207,7 @@ sysexit_from_sys_call:
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%esi		/* second arg, syscall return value */
 	cmpl $-MAX_ERRNO,%eax	/* is it an error ? */
 	jbe 1f
@@ -217,7 +217,7 @@ sysexit_from_sys_call:
 	call __audit_syscall_exit
 	movq RAX-ARGOFFSET(%rsp),%rax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz \exit
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fe9edec..84c1309 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -298,8 +298,7 @@ struct _cache_attr {
 			 unsigned int);
 };
 
-#ifdef CONFIG_AMD_NB
-
+#if defined(CONFIG_AMD_NB) && defined(CONFIG_SYSFS)
 /*
  * L3 cache descriptors
  */
@@ -524,9 +523,9 @@ store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
 static struct _cache_attr subcaches =
 	__ATTR(subcaches, 0644, show_subcaches, store_subcaches);
 
-#else	/* CONFIG_AMD_NB */
+#else
 #define amd_init_l3_cache(x, y)
-#endif /* CONFIG_AMD_NB */
+#endif  /* CONFIG_AMD_NB && CONFIG_SYSFS */
 
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
