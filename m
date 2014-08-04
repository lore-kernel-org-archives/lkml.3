Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaHDL67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:58:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42221 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:58:57 -0400
Date: Mon, 4 Aug 2014 13:58:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature changes for v3.17
Message-ID: <20140804115846.GA26004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpufeature-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpufeature-for-linus

   # HEAD: af0fa6f6b5851761e9fbf79eb14ba86e857b4e7b x86, cpu: Kill cpu_has_mp

The main changes in this cycle were:

 * Continued cleanups of CPU bugs mis-marked as 'missing features', by 
   Borislav Petkov.

 * Detect the xsaves/xrstors feature and releated cleanup, by Fenghua Yu.

 Thanks,

	Ingo

------------------>
Borislav Petkov (4):
      x86, cpufeature: Convert more "features" to bugs
      x86/cpufeature: Add bug flags to /proc/cpuinfo
      x86, amd: Cleanup init_amd
      x86, cpu: Kill cpu_has_mp

Fenghua Yu (2):
      x86/cpufeature.h: Reformat x86 feature macros
      x86/xsaves: Detect xsaves/xrstors feature


 arch/x86/include/asm/apic.h           |   2 +-
 arch/x86/include/asm/cpufeature.h     | 409 +++++++++++++++++-----------------
 arch/x86/include/asm/fpu-internal.h   |   2 +-
 arch/x86/include/asm/mwait.h          |   2 +-
 arch/x86/include/uapi/asm/msr-index.h |   2 +
 arch/x86/kernel/cpu/amd.c             | 341 ++++++++++++++--------------
 arch/x86/kernel/cpu/common.c          |   9 +
 arch/x86/kernel/cpu/intel.c           |   4 +-
 arch/x86/kernel/cpu/mkcapflags.sh     |  51 +++--
 arch/x86/kernel/cpu/proc.c            |   8 +
 arch/x86/kernel/cpu/scattered.c       |   1 -
 11 files changed, 433 insertions(+), 398 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 19b0eba..79752f2 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -99,7 +99,7 @@ static inline void native_apic_mem_write(u32 reg, u32 v)
 {
 	volatile u32 *addr = (volatile u32 *)(APIC_BASE + reg);
 
-	alternative_io("movl %0, %1", "xchgl %0, %1", X86_FEATURE_11AP,
+	alternative_io("movl %0, %1", "xchgl %0, %1", X86_BUG_11AP,
 		       ASM_OUTPUT2("=r" (v), "=m" (*addr)),
 		       ASM_OUTPUT2("0" (v), "m" (*addr)));
 }
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e265ff9..bb9b258 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -8,7 +8,7 @@
 #include <asm/required-features.h>
 #endif
 
-#define NCAPINTS	10	/* N 32-bit words worth of info */
+#define NCAPINTS	11	/* N 32-bit words worth of info */
 #define NBUGINTS	1	/* N 32-bit bug flags */
 
 /*
@@ -18,213 +18,218 @@
  */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (edx), word 0 */
-#define X86_FEATURE_FPU		(0*32+ 0) /* Onboard FPU */
-#define X86_FEATURE_VME		(0*32+ 1) /* Virtual Mode Extensions */
-#define X86_FEATURE_DE		(0*32+ 2) /* Debugging Extensions */
-#define X86_FEATURE_PSE		(0*32+ 3) /* Page Size Extensions */
-#define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
-#define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
-#define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Exception */
-#define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
-#define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
-#define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
-#define X86_FEATURE_MTRR	(0*32+12) /* Memory Type Range Registers */
-#define X86_FEATURE_PGE		(0*32+13) /* Page Global Enable */
-#define X86_FEATURE_MCA		(0*32+14) /* Machine Check Architecture */
-#define X86_FEATURE_CMOV	(0*32+15) /* CMOV instructions */
+#define X86_FEATURE_FPU		( 0*32+ 0) /* Onboard FPU */
+#define X86_FEATURE_VME		( 0*32+ 1) /* Virtual Mode Extensions */
+#define X86_FEATURE_DE		( 0*32+ 2) /* Debugging Extensions */
+#define X86_FEATURE_PSE		( 0*32+ 3) /* Page Size Extensions */
+#define X86_FEATURE_TSC		( 0*32+ 4) /* Time Stamp Counter */
+#define X86_FEATURE_MSR		( 0*32+ 5) /* Model-Specific Registers */
+#define X86_FEATURE_PAE		( 0*32+ 6) /* Physical Address Extensions */
+#define X86_FEATURE_MCE		( 0*32+ 7) /* Machine Check Exception */
+#define X86_FEATURE_CX8		( 0*32+ 8) /* CMPXCHG8 instruction */
+#define X86_FEATURE_APIC	( 0*32+ 9) /* Onboard APIC */
+#define X86_FEATURE_SEP		( 0*32+11) /* SYSENTER/SYSEXIT */
+#define X86_FEATURE_MTRR	( 0*32+12) /* Memory Type Range Registers */
+#define X86_FEATURE_PGE		( 0*32+13) /* Page Global Enable */
+#define X86_FEATURE_MCA		( 0*32+14) /* Machine Check Architecture */
+#define X86_FEATURE_CMOV	( 0*32+15) /* CMOV instructions */
 					  /* (plus FCMOVcc, FCOMI with FPU) */
-#define X86_FEATURE_PAT		(0*32+16) /* Page Attribute Table */
-#define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
-#define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
-#define X86_FEATURE_CLFLUSH	(0*32+19) /* CLFLUSH instruction */
-#define X86_FEATURE_DS		(0*32+21) /* "dts" Debug Store */
-#define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
-#define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
-#define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */
-#define X86_FEATURE_XMM		(0*32+25) /* "sse" */
-#define X86_FEATURE_XMM2	(0*32+26) /* "sse2" */
-#define X86_FEATURE_SELFSNOOP	(0*32+27) /* "ss" CPU self snoop */
-#define X86_FEATURE_HT		(0*32+28) /* Hyper-Threading */
-#define X86_FEATURE_ACC		(0*32+29) /* "tm" Automatic clock control */
-#define X86_FEATURE_IA64	(0*32+30) /* IA-64 processor */
-#define X86_FEATURE_PBE		(0*32+31) /* Pending Break Enable */
+#define X86_FEATURE_PAT		( 0*32+16) /* Page Attribute Table */
+#define X86_FEATURE_PSE36	( 0*32+17) /* 36-bit PSEs */
+#define X86_FEATURE_PN		( 0*32+18) /* Processor serial number */
+#define X86_FEATURE_CLFLUSH	( 0*32+19) /* CLFLUSH instruction */
+#define X86_FEATURE_DS		( 0*32+21) /* "dts" Debug Store */
+#define X86_FEATURE_ACPI	( 0*32+22) /* ACPI via MSR */
+#define X86_FEATURE_MMX		( 0*32+23) /* Multimedia Extensions */
+#define X86_FEATURE_FXSR	( 0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */
+#define X86_FEATURE_XMM		( 0*32+25) /* "sse" */
+#define X86_FEATURE_XMM2	( 0*32+26) /* "sse2" */
+#define X86_FEATURE_SELFSNOOP	( 0*32+27) /* "ss" CPU self snoop */
+#define X86_FEATURE_HT		( 0*32+28) /* Hyper-Threading */
+#define X86_FEATURE_ACC		( 0*32+29) /* "tm" Automatic clock control */
+#define X86_FEATURE_IA64	( 0*32+30) /* IA-64 processor */
+#define X86_FEATURE_PBE		( 0*32+31) /* Pending Break Enable */
 
 /* AMD-defined CPU features, CPUID level 0x80000001, word 1 */
 /* Don't duplicate feature flags which are redundant with Intel! */
-#define X86_FEATURE_SYSCALL	(1*32+11) /* SYSCALL/SYSRET */
-#define X86_FEATURE_MP		(1*32+19) /* MP Capable. */
-#define X86_FEATURE_NX		(1*32+20) /* Execute Disable */
-#define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
-#define X86_FEATURE_FXSR_OPT	(1*32+25) /* FXSAVE/FXRSTOR optimizations */
-#define X86_FEATURE_GBPAGES	(1*32+26) /* "pdpe1gb" GB pages */
-#define X86_FEATURE_RDTSCP	(1*32+27) /* RDTSCP */
-#define X86_FEATURE_LM		(1*32+29) /* Long Mode (x86-64) */
-#define X86_FEATURE_3DNOWEXT	(1*32+30) /* AMD 3DNow! extensions */
-#define X86_FEATURE_3DNOW	(1*32+31) /* 3DNow! */
+#define X86_FEATURE_SYSCALL	( 1*32+11) /* SYSCALL/SYSRET */
+#define X86_FEATURE_MP		( 1*32+19) /* MP Capable. */
+#define X86_FEATURE_NX		( 1*32+20) /* Execute Disable */
+#define X86_FEATURE_MMXEXT	( 1*32+22) /* AMD MMX extensions */
+#define X86_FEATURE_FXSR_OPT	( 1*32+25) /* FXSAVE/FXRSTOR optimizations */
+#define X86_FEATURE_GBPAGES	( 1*32+26) /* "pdpe1gb" GB pages */
+#define X86_FEATURE_RDTSCP	( 1*32+27) /* RDTSCP */
+#define X86_FEATURE_LM		( 1*32+29) /* Long Mode (x86-64) */
+#define X86_FEATURE_3DNOWEXT	( 1*32+30) /* AMD 3DNow! extensions */
+#define X86_FEATURE_3DNOW	( 1*32+31) /* 3DNow! */
 
 /* Transmeta-defined CPU features, CPUID level 0x80860001, word 2 */
-#define X86_FEATURE_RECOVERY	(2*32+ 0) /* CPU in recovery mode */
-#define X86_FEATURE_LONGRUN	(2*32+ 1) /* Longrun power control */
-#define X86_FEATURE_LRTI	(2*32+ 3) /* LongRun table interface */
+#define X86_FEATURE_RECOVERY	( 2*32+ 0) /* CPU in recovery mode */
+#define X86_FEATURE_LONGRUN	( 2*32+ 1) /* Longrun power control */
+#define X86_FEATURE_LRTI	( 2*32+ 3) /* LongRun table interface */
 
 /* Other features, Linux-defined mapping, word 3 */
 /* This range is used for feature bits which conflict or are synthesized */
-#define X86_FEATURE_CXMMX	(3*32+ 0) /* Cyrix MMX extensions */
-#define X86_FEATURE_K6_MTRR	(3*32+ 1) /* AMD K6 nonstandard MTRRs */
-#define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (= MTRRs) */
-#define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (= MTRRs) */
+#define X86_FEATURE_CXMMX	( 3*32+ 0) /* Cyrix MMX extensions */
+#define X86_FEATURE_K6_MTRR	( 3*32+ 1) /* AMD K6 nonstandard MTRRs */
+#define X86_FEATURE_CYRIX_ARR	( 3*32+ 2) /* Cyrix ARRs (= MTRRs) */
+#define X86_FEATURE_CENTAUR_MCR	( 3*32+ 3) /* Centaur MCRs (= MTRRs) */
 /* cpu types for specific tunings: */
-#define X86_FEATURE_K8		(3*32+ 4) /* "" Opteron, Athlon64 */
-#define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
-#define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
-#define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
-#define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
-#define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
-#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
-#define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
-#define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
-#define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
-#define X86_FEATURE_SYSCALL32	(3*32+14) /* "" syscall in ia32 userspace */
-#define X86_FEATURE_SYSENTER32	(3*32+15) /* "" sysenter in ia32 userspace */
-#define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well */
-#define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* "" Mfence synchronizes RDTSC */
-#define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
-#define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
-#define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-#define X86_FEATURE_ALWAYS	(3*32+21) /* "" Always-present feature */
-#define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
-#define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
-#define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
-#define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
-#define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
-#define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
-#define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
-#define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
-#define X86_FEATURE_NONSTOP_TSC_S3 (3*32+30) /* TSC doesn't stop in S3 state */
+#define X86_FEATURE_K8		( 3*32+ 4) /* "" Opteron, Athlon64 */
+#define X86_FEATURE_K7		( 3*32+ 5) /* "" Athlon */
+#define X86_FEATURE_P3		( 3*32+ 6) /* "" P3 */
+#define X86_FEATURE_P4		( 3*32+ 7) /* "" P4 */
+#define X86_FEATURE_CONSTANT_TSC ( 3*32+ 8) /* TSC ticks at a constant rate */
+#define X86_FEATURE_UP		( 3*32+ 9) /* smp kernel running on up */
+/* free, was #define X86_FEATURE_FXSAVE_LEAK ( 3*32+10) * "" FXSAVE leaks FOP/FIP/FOP */
+#define X86_FEATURE_ARCH_PERFMON ( 3*32+11) /* Intel Architectural PerfMon */
+#define X86_FEATURE_PEBS	( 3*32+12) /* Precise-Event Based Sampling */
+#define X86_FEATURE_BTS		( 3*32+13) /* Branch Trace Store */
+#define X86_FEATURE_SYSCALL32	( 3*32+14) /* "" syscall in ia32 userspace */
+#define X86_FEATURE_SYSENTER32	( 3*32+15) /* "" sysenter in ia32 userspace */
+#define X86_FEATURE_REP_GOOD	( 3*32+16) /* rep microcode works well */
+#define X86_FEATURE_MFENCE_RDTSC ( 3*32+17) /* "" Mfence synchronizes RDTSC */
+#define X86_FEATURE_LFENCE_RDTSC ( 3*32+18) /* "" Lfence synchronizes RDTSC */
+/* free, was #define X86_FEATURE_11AP	( 3*32+19) * "" Bad local APIC aka 11AP */
+#define X86_FEATURE_NOPL	( 3*32+20) /* The NOPL (0F 1F) instructions */
+#define X86_FEATURE_ALWAYS	( 3*32+21) /* "" Always-present feature */
+#define X86_FEATURE_XTOPOLOGY	( 3*32+22) /* cpu topology enum extensions */
+#define X86_FEATURE_TSC_RELIABLE ( 3*32+23) /* TSC is known to be reliable */
+#define X86_FEATURE_NONSTOP_TSC	( 3*32+24) /* TSC does not stop in C states */
+/* free, was #define X86_FEATURE_CLFLUSH_MONITOR ( 3*32+25) * "" clflush reqd with monitor */
+#define X86_FEATURE_EXTD_APICID	( 3*32+26) /* has extended APICID (8 bits) */
+#define X86_FEATURE_AMD_DCM     ( 3*32+27) /* multi-node processor */
+#define X86_FEATURE_APERFMPERF	( 3*32+28) /* APERFMPERF */
+#define X86_FEATURE_EAGER_FPU	( 3*32+29) /* "eagerfpu" Non lazy FPU restore */
+#define X86_FEATURE_NONSTOP_TSC_S3 ( 3*32+30) /* TSC doesn't stop in S3 state */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
-#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
-#define X86_FEATURE_PCLMULQDQ	(4*32+ 1) /* PCLMULQDQ instruction */
-#define X86_FEATURE_DTES64	(4*32+ 2) /* 64-bit Debug Store */
-#define X86_FEATURE_MWAIT	(4*32+ 3) /* "monitor" Monitor/Mwait support */
-#define X86_FEATURE_DSCPL	(4*32+ 4) /* "ds_cpl" CPL Qual. Debug Store */
-#define X86_FEATURE_VMX		(4*32+ 5) /* Hardware virtualization */
-#define X86_FEATURE_SMX		(4*32+ 6) /* Safer mode */
-#define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
-#define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
-#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
-#define X86_FEATURE_CID		(4*32+10) /* Context ID */
-#define X86_FEATURE_FMA		(4*32+12) /* Fused multiply-add */
-#define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
-#define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
-#define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
-#define X86_FEATURE_PCID	(4*32+17) /* Process Context Identifiers */
-#define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
-#define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
-#define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
-#define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
-#define X86_FEATURE_MOVBE	(4*32+22) /* MOVBE instruction */
-#define X86_FEATURE_POPCNT      (4*32+23) /* POPCNT instruction */
-#define X86_FEATURE_TSC_DEADLINE_TIMER	(4*32+24) /* Tsc deadline timer */
-#define X86_FEATURE_AES		(4*32+25) /* AES instructions */
-#define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
-#define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
-#define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
-#define X86_FEATURE_F16C	(4*32+29) /* 16-bit fp conversions */
-#define X86_FEATURE_RDRAND	(4*32+30) /* The RDRAND instruction */
-#define X86_FEATURE_HYPERVISOR	(4*32+31) /* Running on a hypervisor */
+#define X86_FEATURE_XMM3	( 4*32+ 0) /* "pni" SSE-3 */
+#define X86_FEATURE_PCLMULQDQ	( 4*32+ 1) /* PCLMULQDQ instruction */
+#define X86_FEATURE_DTES64	( 4*32+ 2) /* 64-bit Debug Store */
+#define X86_FEATURE_MWAIT	( 4*32+ 3) /* "monitor" Monitor/Mwait support */
+#define X86_FEATURE_DSCPL	( 4*32+ 4) /* "ds_cpl" CPL Qual. Debug Store */
+#define X86_FEATURE_VMX		( 4*32+ 5) /* Hardware virtualization */
+#define X86_FEATURE_SMX		( 4*32+ 6) /* Safer mode */
+#define X86_FEATURE_EST		( 4*32+ 7) /* Enhanced SpeedStep */
+#define X86_FEATURE_TM2		( 4*32+ 8) /* Thermal Monitor 2 */
+#define X86_FEATURE_SSSE3	( 4*32+ 9) /* Supplemental SSE-3 */
+#define X86_FEATURE_CID		( 4*32+10) /* Context ID */
+#define X86_FEATURE_FMA		( 4*32+12) /* Fused multiply-add */
+#define X86_FEATURE_CX16	( 4*32+13) /* CMPXCHG16B */
+#define X86_FEATURE_XTPR	( 4*32+14) /* Send Task Priority Messages */
+#define X86_FEATURE_PDCM	( 4*32+15) /* Performance Capabilities */
+#define X86_FEATURE_PCID	( 4*32+17) /* Process Context Identifiers */
+#define X86_FEATURE_DCA		( 4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM4_1	( 4*32+19) /* "sse4_1" SSE-4.1 */
+#define X86_FEATURE_XMM4_2	( 4*32+20) /* "sse4_2" SSE-4.2 */
+#define X86_FEATURE_X2APIC	( 4*32+21) /* x2APIC */
+#define X86_FEATURE_MOVBE	( 4*32+22) /* MOVBE instruction */
+#define X86_FEATURE_POPCNT      ( 4*32+23) /* POPCNT instruction */
+#define X86_FEATURE_TSC_DEADLINE_TIMER	( 4*32+24) /* Tsc deadline timer */
+#define X86_FEATURE_AES		( 4*32+25) /* AES instructions */
+#define X86_FEATURE_XSAVE	( 4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
+#define X86_FEATURE_OSXSAVE	( 4*32+27) /* "" XSAVE enabled in the OS */
+#define X86_FEATURE_AVX		( 4*32+28) /* Advanced Vector Extensions */
+#define X86_FEATURE_F16C	( 4*32+29) /* 16-bit fp conversions */
+#define X86_FEATURE_RDRAND	( 4*32+30) /* The RDRAND instruction */
+#define X86_FEATURE_HYPERVISOR	( 4*32+31) /* Running on a hypervisor */
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
-#define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
-#define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* "rng_en" RNG enabled */
-#define X86_FEATURE_XCRYPT	(5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
-#define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* "ace_en" on-CPU crypto enabled */
-#define X86_FEATURE_ACE2	(5*32+ 8) /* Advanced Cryptography Engine v2 */
-#define X86_FEATURE_ACE2_EN	(5*32+ 9) /* ACE v2 enabled */
-#define X86_FEATURE_PHE		(5*32+10) /* PadLock Hash Engine */
-#define X86_FEATURE_PHE_EN	(5*32+11) /* PHE enabled */
-#define X86_FEATURE_PMM		(5*32+12) /* PadLock Montgomery Multiplier */
-#define X86_FEATURE_PMM_EN	(5*32+13) /* PMM enabled */
+#define X86_FEATURE_XSTORE	( 5*32+ 2) /* "rng" RNG present (xstore) */
+#define X86_FEATURE_XSTORE_EN	( 5*32+ 3) /* "rng_en" RNG enabled */
+#define X86_FEATURE_XCRYPT	( 5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
+#define X86_FEATURE_XCRYPT_EN	( 5*32+ 7) /* "ace_en" on-CPU crypto enabled */
+#define X86_FEATURE_ACE2	( 5*32+ 8) /* Advanced Cryptography Engine v2 */
+#define X86_FEATURE_ACE2_EN	( 5*32+ 9) /* ACE v2 enabled */
+#define X86_FEATURE_PHE		( 5*32+10) /* PadLock Hash Engine */
+#define X86_FEATURE_PHE_EN	( 5*32+11) /* PHE enabled */
+#define X86_FEATURE_PMM		( 5*32+12) /* PadLock Montgomery Multiplier */
+#define X86_FEATURE_PMM_EN	( 5*32+13) /* PMM enabled */
 
 /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
-#define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
-#define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
-#define X86_FEATURE_SVM		(6*32+ 2) /* Secure virtual machine */
-#define X86_FEATURE_EXTAPIC	(6*32+ 3) /* Extended APIC space */
-#define X86_FEATURE_CR8_LEGACY	(6*32+ 4) /* CR8 in 32-bit mode */
-#define X86_FEATURE_ABM		(6*32+ 5) /* Advanced bit manipulation */
-#define X86_FEATURE_SSE4A	(6*32+ 6) /* SSE-4A */
-#define X86_FEATURE_MISALIGNSSE (6*32+ 7) /* Misaligned SSE mode */
-#define X86_FEATURE_3DNOWPREFETCH (6*32+ 8) /* 3DNow prefetch instructions */
-#define X86_FEATURE_OSVW	(6*32+ 9) /* OS Visible Workaround */
-#define X86_FEATURE_IBS		(6*32+10) /* Instruction Based Sampling */
-#define X86_FEATURE_XOP		(6*32+11) /* extended AVX instructions */
-#define X86_FEATURE_SKINIT	(6*32+12) /* SKINIT/STGI instructions */
-#define X86_FEATURE_WDT		(6*32+13) /* Watchdog timer */
-#define X86_FEATURE_LWP		(6*32+15) /* Light Weight Profiling */
-#define X86_FEATURE_FMA4	(6*32+16) /* 4 operands MAC instructions */
-#define X86_FEATURE_TCE		(6*32+17) /* translation cache extension */
-#define X86_FEATURE_NODEID_MSR	(6*32+19) /* NodeId MSR */
-#define X86_FEATURE_TBM		(6*32+21) /* trailing bit manipulations */
-#define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
-#define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
-#define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
-#define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
+#define X86_FEATURE_LAHF_LM	( 6*32+ 0) /* LAHF/SAHF in long mode */
+#define X86_FEATURE_CMP_LEGACY	( 6*32+ 1) /* If yes HyperThreading not valid */
+#define X86_FEATURE_SVM		( 6*32+ 2) /* Secure virtual machine */
+#define X86_FEATURE_EXTAPIC	( 6*32+ 3) /* Extended APIC space */
+#define X86_FEATURE_CR8_LEGACY	( 6*32+ 4) /* CR8 in 32-bit mode */
+#define X86_FEATURE_ABM		( 6*32+ 5) /* Advanced bit manipulation */
+#define X86_FEATURE_SSE4A	( 6*32+ 6) /* SSE-4A */
+#define X86_FEATURE_MISALIGNSSE ( 6*32+ 7) /* Misaligned SSE mode */
+#define X86_FEATURE_3DNOWPREFETCH ( 6*32+ 8) /* 3DNow prefetch instructions */
+#define X86_FEATURE_OSVW	( 6*32+ 9) /* OS Visible Workaround */
+#define X86_FEATURE_IBS		( 6*32+10) /* Instruction Based Sampling */
+#define X86_FEATURE_XOP		( 6*32+11) /* extended AVX instructions */
+#define X86_FEATURE_SKINIT	( 6*32+12) /* SKINIT/STGI instructions */
+#define X86_FEATURE_WDT		( 6*32+13) /* Watchdog timer */
+#define X86_FEATURE_LWP		( 6*32+15) /* Light Weight Profiling */
+#define X86_FEATURE_FMA4	( 6*32+16) /* 4 operands MAC instructions */
+#define X86_FEATURE_TCE		( 6*32+17) /* translation cache extension */
+#define X86_FEATURE_NODEID_MSR	( 6*32+19) /* NodeId MSR */
+#define X86_FEATURE_TBM		( 6*32+21) /* trailing bit manipulations */
+#define X86_FEATURE_TOPOEXT	( 6*32+22) /* topology extensions CPUID leafs */
+#define X86_FEATURE_PERFCTR_CORE ( 6*32+23) /* core performance counter extensions */
+#define X86_FEATURE_PERFCTR_NB  ( 6*32+24) /* NB performance counter extensions */
+#define X86_FEATURE_PERFCTR_L2	( 6*32+28) /* L2 performance counter extensions */
 
 /*
  * Auxiliary flags: Linux defined - For features scattered in various
  * CPUID levels like 0x6, 0xA etc, word 7
  */
-#define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
-#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
-#define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
-#define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
-#define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
-#define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
-#define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
-#define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
-#define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
-#define X86_FEATURE_PROC_FEEDBACK (7*32+ 9) /* AMD ProcFeedbackInterface */
+#define X86_FEATURE_IDA		( 7*32+ 0) /* Intel Dynamic Acceleration */
+#define X86_FEATURE_ARAT	( 7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
+#define X86_FEATURE_PLN		( 7*32+ 5) /* Intel Power Limit Notification */
+#define X86_FEATURE_PTS		( 7*32+ 6) /* Intel Package Thermal Status */
+#define X86_FEATURE_DTHERM	( 7*32+ 7) /* Digital Thermal Sensor */
+#define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
+#define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
 
 /* Virtualization flags: Linux defined, word 8 */
-#define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
-#define X86_FEATURE_VNMI        (8*32+ 1) /* Intel Virtual NMI */
-#define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
-#define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
-#define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
-#define X86_FEATURE_NPT		(8*32+ 5) /* AMD Nested Page Table support */
-#define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
-#define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
-#define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
-#define X86_FEATURE_TSCRATEMSR  (8*32+ 9) /* "tsc_scale" AMD TSC scaling support */
-#define X86_FEATURE_VMCBCLEAN   (8*32+10) /* "vmcb_clean" AMD VMCB clean bits support */
-#define X86_FEATURE_FLUSHBYASID (8*32+11) /* AMD flush-by-ASID support */
-#define X86_FEATURE_DECODEASSISTS (8*32+12) /* AMD Decode Assists support */
-#define X86_FEATURE_PAUSEFILTER (8*32+13) /* AMD filtered pause intercept */
-#define X86_FEATURE_PFTHRESHOLD (8*32+14) /* AMD pause filter threshold */
+#define X86_FEATURE_TPR_SHADOW  ( 8*32+ 0) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI        ( 8*32+ 1) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY ( 8*32+ 2) /* Intel FlexPriority */
+#define X86_FEATURE_EPT         ( 8*32+ 3) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID        ( 8*32+ 4) /* Intel Virtual Processor ID */
+#define X86_FEATURE_NPT		( 8*32+ 5) /* AMD Nested Page Table support */
+#define X86_FEATURE_LBRV	( 8*32+ 6) /* AMD LBR Virtualization support */
+#define X86_FEATURE_SVML	( 8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
+#define X86_FEATURE_NRIPS	( 8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
+#define X86_FEATURE_TSCRATEMSR  ( 8*32+ 9) /* "tsc_scale" AMD TSC scaling support */
+#define X86_FEATURE_VMCBCLEAN   ( 8*32+10) /* "vmcb_clean" AMD VMCB clean bits support */
+#define X86_FEATURE_FLUSHBYASID ( 8*32+11) /* AMD flush-by-ASID support */
+#define X86_FEATURE_DECODEASSISTS ( 8*32+12) /* AMD Decode Assists support */
+#define X86_FEATURE_PAUSEFILTER ( 8*32+13) /* AMD filtered pause intercept */
+#define X86_FEATURE_PFTHRESHOLD ( 8*32+14) /* AMD pause filter threshold */
 
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
-#define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
-#define X86_FEATURE_TSC_ADJUST	(9*32+ 1) /* TSC adjustment MSR 0x3b */
-#define X86_FEATURE_BMI1	(9*32+ 3) /* 1st group bit manipulation extensions */
-#define X86_FEATURE_HLE		(9*32+ 4) /* Hardware Lock Elision */
-#define X86_FEATURE_AVX2	(9*32+ 5) /* AVX2 instructions */
-#define X86_FEATURE_SMEP	(9*32+ 7) /* Supervisor Mode Execution Protection */
-#define X86_FEATURE_BMI2	(9*32+ 8) /* 2nd group bit manipulation extensions */
-#define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
-#define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
-#define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
-#define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
-#define X86_FEATURE_AVX512F	(9*32+16) /* AVX-512 Foundation */
-#define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
-#define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
-#define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
-#define X86_FEATURE_CLFLUSHOPT	(9*32+23) /* CLFLUSHOPT instruction */
-#define X86_FEATURE_AVX512PF	(9*32+26) /* AVX-512 Prefetch */
-#define X86_FEATURE_AVX512ER	(9*32+27) /* AVX-512 Exponential and Reciprocal */
-#define X86_FEATURE_AVX512CD	(9*32+28) /* AVX-512 Conflict Detection */
+#define X86_FEATURE_FSGSBASE	( 9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
+#define X86_FEATURE_TSC_ADJUST	( 9*32+ 1) /* TSC adjustment MSR 0x3b */
+#define X86_FEATURE_BMI1	( 9*32+ 3) /* 1st group bit manipulation extensions */
+#define X86_FEATURE_HLE		( 9*32+ 4) /* Hardware Lock Elision */
+#define X86_FEATURE_AVX2	( 9*32+ 5) /* AVX2 instructions */
+#define X86_FEATURE_SMEP	( 9*32+ 7) /* Supervisor Mode Execution Protection */
+#define X86_FEATURE_BMI2	( 9*32+ 8) /* 2nd group bit manipulation extensions */
+#define X86_FEATURE_ERMS	( 9*32+ 9) /* Enhanced REP MOVSB/STOSB */
+#define X86_FEATURE_INVPCID	( 9*32+10) /* Invalidate Processor Context ID */
+#define X86_FEATURE_RTM		( 9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_MPX		( 9*32+14) /* Memory Protection Extension */
+#define X86_FEATURE_AVX512F	( 9*32+16) /* AVX-512 Foundation */
+#define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
+#define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
+#define X86_FEATURE_SMAP	( 9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_CLFLUSHOPT	( 9*32+23) /* CLFLUSHOPT instruction */
+#define X86_FEATURE_AVX512PF	( 9*32+26) /* AVX-512 Prefetch */
+#define X86_FEATURE_AVX512ER	( 9*32+27) /* AVX-512 Exponential and Reciprocal */
+#define X86_FEATURE_AVX512CD	( 9*32+28) /* AVX-512 Conflict Detection */
+
+/* Extended state features, CPUID level 0x0000000d:1 (eax), word 10 */
+#define X86_FEATURE_XSAVEOPT	(10*32+ 0) /* XSAVEOPT */
+#define X86_FEATURE_XSAVEC	(10*32+ 1) /* XSAVEC */
+#define X86_FEATURE_XGETBV1	(10*32+ 2) /* XGETBV with ECX = 1 */
+#define X86_FEATURE_XSAVES	(10*32+ 3) /* XSAVES/XRSTORS */
 
 /*
  * BUG word(s)
@@ -234,8 +239,11 @@
 #define X86_BUG_F00F		X86_BUG(0) /* Intel F00F */
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
-#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
-#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
+#define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* "tlb_mmatch" AMD Erratum 383 */
+#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* "apic_c1e" AMD Erratum 400 */
+#define X86_BUG_11AP		X86_BUG(5) /* Bad local APIC aka 11AP */
+#define X86_BUG_FXSAVE_LEAK	X86_BUG(6) /* FXSAVE leaks FOP/FIP/FOP */
+#define X86_BUG_CLFLUSH_MONITOR	X86_BUG(7) /* AAI65, CLFLUSH required before MONITOR */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
@@ -245,6 +253,12 @@
 extern const char * const x86_cap_flags[NCAPINTS*32];
 extern const char * const x86_power_flags[32];
 
+/*
+ * In order to save room, we index into this array by doing
+ * X86_BUG_<name> - NCAPINTS*32.
+ */
+extern const char * const x86_bug_flags[NBUGINTS*32];
+
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
 
@@ -301,7 +315,6 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_avx		boot_cpu_has(X86_FEATURE_AVX)
 #define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
-#define cpu_has_mp		boot_cpu_has(X86_FEATURE_MP)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
 #define cpu_has_k6_mtrr		boot_cpu_has(X86_FEATURE_K6_MTRR)
 #define cpu_has_cyrix_arr	boot_cpu_has(X86_FEATURE_CYRIX_ARR)
@@ -328,6 +341,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaveopt	boot_cpu_has(X86_FEATURE_XSAVEOPT)
+#define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
 #define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
@@ -347,9 +361,6 @@ extern const char * const x86_power_flags[32];
 #undef  cpu_has_pae
 #define cpu_has_pae		___BUG___
 
-#undef  cpu_has_mp
-#define cpu_has_mp		1
-
 #undef  cpu_has_k6_mtrr
 #define cpu_has_k6_mtrr		0
 
@@ -539,20 +550,20 @@ static __always_inline __pure bool _static_cpu_has_safe(u16 bit)
 #define static_cpu_has_safe(bit)	boot_cpu_has(bit)
 #endif
 
-#define cpu_has_bug(c, bit)	cpu_has(c, (bit))
-#define set_cpu_bug(c, bit)	set_cpu_cap(c, (bit))
-#define clear_cpu_bug(c, bit)	clear_cpu_cap(c, (bit));
+#define cpu_has_bug(c, bit)		cpu_has(c, (bit))
+#define set_cpu_bug(c, bit)		set_cpu_cap(c, (bit))
+#define clear_cpu_bug(c, bit)		clear_cpu_cap(c, (bit))
 
-#define static_cpu_has_bug(bit)	static_cpu_has((bit))
-#define boot_cpu_has_bug(bit)	cpu_has_bug(&boot_cpu_data, (bit))
+#define static_cpu_has_bug(bit)		static_cpu_has((bit))
+#define static_cpu_has_bug_safe(bit)	static_cpu_has_safe((bit))
+#define boot_cpu_has_bug(bit)		cpu_has_bug(&boot_cpu_data, (bit))
 
-#define MAX_CPU_FEATURES	(NCAPINTS * 32)
-#define cpu_have_feature	boot_cpu_has
+#define MAX_CPU_FEATURES		(NCAPINTS * 32)
+#define cpu_have_feature		boot_cpu_has
 
-#define CPU_FEATURE_TYPEFMT	"x86,ven%04Xfam%04Xmod%04X"
-#define CPU_FEATURE_TYPEVAL	boot_cpu_data.x86_vendor, boot_cpu_data.x86, \
-				boot_cpu_data.x86_model
+#define CPU_FEATURE_TYPEFMT		"x86,ven%04Xfam%04Xmod%04X"
+#define CPU_FEATURE_TYPEVAL		boot_cpu_data.x86_vendor, boot_cpu_data.x86, \
+					boot_cpu_data.x86_model
 
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
-
 #endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 115e368..e3b8542 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -293,7 +293,7 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. "m" is a random variable that should be in L1 */
-	if (unlikely(static_cpu_has_safe(X86_FEATURE_FXSAVE_LEAK))) {
+	if (unlikely(static_cpu_has_bug_safe(X86_BUG_FXSAVE_LEAK))) {
 		asm volatile(
 			"fnclex\n\t"
 			"emms\n\t"
diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 1da25a5..a1410db 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -43,7 +43,7 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
 static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
 	if (!current_set_polling_and_test()) {
-		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+		if (static_cpu_has_bug(X86_BUG_CLFLUSH_MONITOR)) {
 			mb();
 			clflush((void *)&current_thread_info()->flags);
 			mb();
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index fcf2b3a..5cd1569 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -297,6 +297,8 @@
 #define MSR_IA32_TSC_ADJUST             0x0000003b
 #define MSR_IA32_BNDCFGS		0x00000d90
 
+#define MSR_IA32_XSS			0x00000da0
+
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
 #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff..bc360d3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -8,6 +8,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/smp.h>
 #include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
@@ -50,7 +51,6 @@ static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
 	return wrmsr_safe_regs(gprs);
 }
 
-#ifdef CONFIG_X86_32
 /*
  *	B step AMD K6 before B 9730xxxx have hardware bugs that can cause
  *	misexecution of code under Linux. Owners of such processors should
@@ -70,6 +70,7 @@ __asm__(".globl vide\n\t.align 4\nvide: ret");
 
 static void init_amd_k5(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 /*
  * General Systems BIOSen alias the cpu frequency registers
  * of the Elan at 0x000df000. Unfortuantly, one of the Linux
@@ -83,11 +84,12 @@ static void init_amd_k5(struct cpuinfo_x86 *c)
 		if (inl(CBAR) & CBAR_ENB)
 			outl(0 | CBAR_KEY, CBAR);
 	}
+#endif
 }
 
-
 static void init_amd_k6(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
 	u32 l, h;
 	int mbytes = get_num_physpages() >> (20-PAGE_SHIFT);
 
@@ -176,10 +178,44 @@ static void init_amd_k6(struct cpuinfo_x86 *c)
 		/* placeholder for any needed mods */
 		return;
 	}
+#endif
 }
 
-static void amd_k7_smp_check(struct cpuinfo_x86 *c)
+static void init_amd_k7(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_32
+	u32 l, h;
+
+	/*
+	 * Bit 15 of Athlon specific MSR 15, needs to be 0
+	 * to enable SSE on Palomino/Morgan/Barton CPU's.
+	 * If the BIOS didn't enable it already, enable it here.
+	 */
+	if (c->x86_model >= 6 && c->x86_model <= 10) {
+		if (!cpu_has(c, X86_FEATURE_XMM)) {
+			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
+			msr_clear_bit(MSR_K7_HWCR, 15);
+			set_cpu_cap(c, X86_FEATURE_XMM);
+		}
+	}
+
+	/*
+	 * It's been determined by AMD that Athlons since model 8 stepping 1
+	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
+	 * As per AMD technical note 27212 0.2
+	 */
+	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
+		rdmsr(MSR_K7_CLK_CTL, l, h);
+		if ((l & 0xfff00000) != 0x20000000) {
+			printk(KERN_INFO
+			    "CPU: CLK_CTL MSR was %x. Reprogramming to %x\n",
+					l, ((l & 0x000fffff)|0x20000000));
+			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
+		}
+	}
+
+	set_cpu_cap(c, X86_FEATURE_K7);
+
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
 		return;
@@ -207,7 +243,7 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
 	    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
 	     (c->x86_model > 7))
-		if (cpu_has_mp)
+		if (cpu_has(c, X86_FEATURE_MP))
 			return;
 
 	/* If we get here, not a certified SMP capable AMD system. */
@@ -219,45 +255,8 @@ static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 	WARN_ONCE(1, "WARNING: This combination of AMD"
 		" processors is not suitable for SMP.\n");
 	add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_NOW_UNRELIABLE);
-}
-
-static void init_amd_k7(struct cpuinfo_x86 *c)
-{
-	u32 l, h;
-
-	/*
-	 * Bit 15 of Athlon specific MSR 15, needs to be 0
-	 * to enable SSE on Palomino/Morgan/Barton CPU's.
-	 * If the BIOS didn't enable it already, enable it here.
-	 */
-	if (c->x86_model >= 6 && c->x86_model <= 10) {
-		if (!cpu_has(c, X86_FEATURE_XMM)) {
-			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
-			msr_clear_bit(MSR_K7_HWCR, 15);
-			set_cpu_cap(c, X86_FEATURE_XMM);
-		}
-	}
-
-	/*
-	 * It's been determined by AMD that Athlons since model 8 stepping 1
-	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
-	 * As per AMD technical note 27212 0.2
-	 */
-	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
-		rdmsr(MSR_K7_CLK_CTL, l, h);
-		if ((l & 0xfff00000) != 0x20000000) {
-			printk(KERN_INFO
-			    "CPU: CLK_CTL MSR was %x. Reprogramming to %x\n",
-					l, ((l & 0x000fffff)|0x20000000));
-			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
-		}
-	}
-
-	set_cpu_cap(c, X86_FEATURE_K7);
-
-	amd_k7_smp_check(c);
-}
 #endif
+}
 
 #ifdef CONFIG_NUMA
 /*
@@ -446,6 +445,26 @@ static void early_init_amd_mc(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
+
+#ifdef CONFIG_X86_64
+	if (c->x86 >= 0xf) {
+		unsigned long long tseg;
+
+		/*
+		 * Split up direct mapping around the TSEG SMM area.
+		 * Don't do it for gbpages because there seems very little
+		 * benefit in doing so.
+		 */
+		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
+			unsigned long pfn = tseg >> PAGE_SHIFT;
+
+			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
+			if (pfn_range_is_mapped(pfn, pfn + 1))
+				set_memory_4k((unsigned long)__va(tseg), 1);
+		}
+	}
+#endif
+
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 
 		if (c->x86 > 0x10 ||
@@ -515,101 +534,74 @@ static const int amd_erratum_383[];
 static const int amd_erratum_400[];
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
 
-static void init_amd(struct cpuinfo_x86 *c)
+static void init_amd_k8(struct cpuinfo_x86 *c)
 {
-	u32 dummy;
-	unsigned long long value;
-
-#ifdef CONFIG_SMP
-	/*
-	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
-	 * bit 6 of msr C001_0015
-	 *
-	 * Errata 63 for SH-B3 steppings
-	 * Errata 122 for all steppings (F+ have it disabled by default)
-	 */
-	if (c->x86 == 0xf)
-		msr_set_bit(MSR_K7_HWCR, 6);
-#endif
+	u32 level;
+	u64 value;
 
-	early_init_amd(c);
+	/* On C+ stepping K8 rep microcode works well for copy/memset */
+	level = cpuid_eax(1);
+	if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
 	/*
-	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
-	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
+	 * Some BIOSes incorrectly force this feature, but only K8 revision D
+	 * (model = 0x14) and later actually support it.
+	 * (AMD Erratum #110, docId: 25759).
 	 */
-	clear_cpu_cap(c, 0*32+31);
-
-#ifdef CONFIG_X86_64
-	/* On C+ stepping K8 rep microcode works well for copy/memset */
-	if (c->x86 == 0xf) {
-		u32 level;
-
-		level = cpuid_eax(1);
-		if ((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
-			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-
-		/*
-		 * Some BIOSes incorrectly force this feature, but only K8
-		 * revision D (model = 0x14) and later actually support it.
-		 * (AMD Erratum #110, docId: 25759).
-		 */
-		if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
-			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
-			if (!rdmsrl_amd_safe(0xc001100d, &value)) {
-				value &= ~(1ULL << 32);
-				wrmsrl_amd_safe(0xc001100d, value);
-			}
+	if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
+		clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
+		if (!rdmsrl_amd_safe(0xc001100d, &value)) {
+			value &= ~BIT_64(32);
+			wrmsrl_amd_safe(0xc001100d, value);
 		}
-
 	}
-	if (c->x86 >= 0x10)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 
-	/* get apicid instead of initial apic id from cpuid */
-	c->apicid = hard_smp_processor_id();
-#else
+	if (!c->x86_model_id[0])
+		strcpy(c->x86_model_id, "Hammer");
+}
+
+static void init_amd_gh(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_64
+	/* do this for boot cpu */
+	if (c == &boot_cpu_data)
+		check_enable_amd_mmconf_dmi();
+
+	fam10h_check_enable_mmcfg();
+#endif
 
 	/*
-	 *	FIXME: We should handle the K5 here. Set up the write
-	 *	range and also turn on MSR 83 bits 4 and 31 (write alloc,
-	 *	no bus pipeline)
+	 * Disable GART TLB Walk Errors on Fam10h. We do this here because this
+	 * is always needed when GART is enabled, even in a kernel which has no
+	 * MCE support built in. BIOS should disable GartTlbWlk Errors already.
+	 * If it doesn't, we do it here as suggested by the BKDG.
+	 *
+	 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
 	 */
+	msr_set_bit(MSR_AMD64_MCx_MASK(4), 10);
 
-	switch (c->x86) {
-	case 4:
-		init_amd_k5(c);
-		break;
-	case 5:
-		init_amd_k6(c);
-		break;
-	case 6: /* An Athlon/Duron */
-		init_amd_k7(c);
-		break;
-	}
+	/*
+	 * On family 10h BIOS may not have properly enabled WC+ support, causing
+	 * it to be converted to CD memtype. This may result in performance
+	 * degradation for certain nested-paging guests. Prevent this conversion
+	 * by clearing bit 24 in MSR_AMD64_BU_CFG2.
+	 *
+	 * NOTE: we want to use the _safe accessors so as not to #GP kvm
+	 * guests on older kvm hosts.
+	 */
+	msr_clear_bit(MSR_AMD64_BU_CFG2, 24);
 
-	/* K6s reports MCEs but don't actually have all the MSRs */
-	if (c->x86 < 6)
-		clear_cpu_cap(c, X86_FEATURE_MCE);
-#endif
+	if (cpu_has_amd_erratum(c, amd_erratum_383))
+		set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
+}
 
-	/* Enable workaround for FXSAVE leak */
-	if (c->x86 >= 6)
-		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
-
-	if (!c->x86_model_id[0]) {
-		switch (c->x86) {
-		case 0xf:
-			/* Should distinguish Models here, but this is only
-			   a fallback anyways. */
-			strcpy(c->x86_model_id, "Hammer");
-			break;
-		}
-	}
+static void init_amd_bd(struct cpuinfo_x86 *c)
+{
+	u64 value;
 
 	/* re-enable TopologyExtensions if switched off by BIOS */
-	if ((c->x86 == 0x15) &&
-	    (c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
+	if ((c->x86_model >= 0x10) && (c->x86_model <= 0x1f) &&
 	    !cpu_has(c, X86_FEATURE_TOPOEXT)) {
 
 		if (msr_set_bit(0xc0011005, 54) > 0) {
@@ -625,14 +617,60 @@ static void init_amd(struct cpuinfo_x86 *c)
 	 * The way access filter has a performance penalty on some workloads.
 	 * Disable it on the affected CPUs.
 	 */
-	if ((c->x86 == 0x15) &&
-	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
-
+	if ((c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
 		if (!rdmsrl_safe(0xc0011021, &value) && !(value & 0x1E)) {
 			value |= 0x1E;
 			wrmsrl_safe(0xc0011021, value);
 		}
 	}
+}
+
+static void init_amd(struct cpuinfo_x86 *c)
+{
+	u32 dummy;
+
+#ifdef CONFIG_SMP
+	/*
+	 * Disable TLB flush filter by setting HWCR.FFDIS on K8
+	 * bit 6 of msr C001_0015
+	 *
+	 * Errata 63 for SH-B3 steppings
+	 * Errata 122 for all steppings (F+ have it disabled by default)
+	 */
+	if (c->x86 == 0xf)
+		msr_set_bit(MSR_K7_HWCR, 6);
+#endif
+
+	early_init_amd(c);
+
+	/*
+	 * Bit 31 in normal CPUID used for nonstandard 3DNow ID;
+	 * 3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway
+	 */
+	clear_cpu_cap(c, 0*32+31);
+
+	if (c->x86 >= 0x10)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+	/* get apicid instead of initial apic id from cpuid */
+	c->apicid = hard_smp_processor_id();
+
+	/* K6s reports MCEs but don't actually have all the MSRs */
+	if (c->x86 < 6)
+		clear_cpu_cap(c, X86_FEATURE_MCE);
+
+	switch (c->x86) {
+	case 4:    init_amd_k5(c); break;
+	case 5:    init_amd_k6(c); break;
+	case 6:	   init_amd_k7(c); break;
+	case 0xf:  init_amd_k8(c); break;
+	case 0x10: init_amd_gh(c); break;
+	case 0x15: init_amd_bd(c); break;
+	}
+
+	/* Enable workaround for FXSAVE leak */
+	if (c->x86 >= 6)
+		set_cpu_bug(c, X86_BUG_FXSAVE_LEAK);
 
 	cpu_detect_cache_sizes(c);
 
@@ -656,33 +694,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
 
-#ifdef CONFIG_X86_64
-	if (c->x86 == 0x10) {
-		/* do this for boot cpu */
-		if (c == &boot_cpu_data)
-			check_enable_amd_mmconf_dmi();
-
-		fam10h_check_enable_mmcfg();
-	}
-
-	if (c == &boot_cpu_data && c->x86 >= 0xf) {
-		unsigned long long tseg;
-
-		/*
-		 * Split up direct mapping around the TSEG SMM area.
-		 * Don't do it for gbpages because there seems very little
-		 * benefit in doing so.
-		 */
-		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
-			unsigned long pfn = tseg >> PAGE_SHIFT;
-
-			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
-			if (pfn_range_is_mapped(pfn, pfn + 1))
-				set_memory_4k((unsigned long)__va(tseg), 1);
-		}
-	}
-#endif
-
 	/*
 	 * Family 0x12 and above processors have APIC timer
 	 * running in deep C states.
@@ -690,34 +701,6 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (c->x86 > 0x11)
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
-	if (c->x86 == 0x10) {
-		/*
-		 * Disable GART TLB Walk Errors on Fam10h. We do this here
-		 * because this is always needed when GART is enabled, even in a
-		 * kernel which has no MCE support built in.
-		 * BIOS should disable GartTlbWlk Errors already. If
-		 * it doesn't, do it here as suggested by the BKDG.
-		 *
-		 * Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=33012
-		 */
-		msr_set_bit(MSR_AMD64_MCx_MASK(4), 10);
-
-		/*
-		 * On family 10h BIOS may not have properly enabled WC+ support,
-		 * causing it to be converted to CD memtype. This may result in
-		 * performance degradation for certain nested-paging guests.
-		 * Prevent this conversion by clearing bit 24 in
-		 * MSR_AMD64_BU_CFG2.
-		 *
-		 * NOTE: we want to use the _safe accessors so as not to #GP kvm
-		 * guests on older kvm hosts.
-		 */
-		msr_clear_bit(MSR_AMD64_BU_CFG2, 24);
-
-		if (cpu_has_amd_erratum(c, amd_erratum_383))
-			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
-	}
-
 	if (cpu_has_amd_erratum(c, amd_erratum_400))
 		set_cpu_bug(c, X86_BUG_AMD_APIC_C1E);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ef1b93f..188a8c5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -634,6 +634,15 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_capability[9] = ebx;
 	}
 
+	/* Extended state features: level 0x0000000d */
+	if (c->cpuid_level >= 0x0000000d) {
+		u32 eax, ebx, ecx, edx;
+
+		cpuid_count(0x0000000d, 1, &eax, &ebx, &ecx, &edx);
+
+		c->x86_capability[10] = eax;
+	}
+
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a800290..0fd9557 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -253,7 +253,7 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 	 */
 	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
 	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
-		set_cpu_cap(c, X86_FEATURE_11AP);
+		set_cpu_bug(c, X86_BUG_11AP);
 
 
 #ifdef CONFIG_X86_INTEL_USERCOPY
@@ -391,7 +391,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 
 	if (c->x86 == 6 && cpu_has_clflush &&
 	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
-		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
+		set_cpu_bug(c, X86_BUG_CLFLUSH_MONITOR);
 
 #ifdef CONFIG_X86_64
 	if (c->x86 == 15)
diff --git a/arch/x86/kernel/cpu/mkcapflags.sh b/arch/x86/kernel/cpu/mkcapflags.sh
index 2bf6165..e2b22df 100644
--- a/arch/x86/kernel/cpu/mkcapflags.sh
+++ b/arch/x86/kernel/cpu/mkcapflags.sh
@@ -1,23 +1,25 @@
 #!/bin/sh
 #
-# Generate the x86_cap_flags[] array from include/asm/cpufeature.h
+# Generate the x86_cap/bug_flags[] arrays from include/asm/cpufeature.h
 #
 
 IN=$1
 OUT=$2
 
-TABS="$(printf '\t\t\t\t\t')"
-trap 'rm "$OUT"' EXIT
+function dump_array()
+{
+	ARRAY=$1
+	SIZE=$2
+	PFX=$3
+	POSTFIX=$4
 
-(
-	echo "#ifndef _ASM_X86_CPUFEATURE_H"
-	echo "#include <asm/cpufeature.h>"
-	echo "#endif"
-	echo ""
-	echo "const char * const x86_cap_flags[NCAPINTS*32] = {"
+	PFX_SZ=$(echo $PFX | wc -c)
+	TABS="$(printf '\t\t\t\t\t')"
+
+	echo "const char * const $ARRAY[$SIZE] = {"
 
-	# Iterate through any input lines starting with #define X86_FEATURE_
-	sed -n -e 's/\t/ /g' -e 's/^ *# *define *X86_FEATURE_//p' $IN |
+	# Iterate through any input lines starting with #define $PFX
+	sed -n -e 's/\t/ /g' -e "s/^ *# *define *$PFX//p" $IN |
 	while read i
 	do
 		# Name is everything up to the first whitespace
@@ -31,11 +33,32 @@ trap 'rm "$OUT"' EXIT
 		# Name is uppercase, VALUE is all lowercase
 		VALUE="$(echo "$VALUE" | tr A-Z a-z)"
 
-		TABCOUNT=$(( ( 5*8 - 14 - $(echo "$NAME" | wc -c) ) / 8 ))
-		printf "\t[%s]%.*s = %s,\n" \
-			"X86_FEATURE_$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+        if [ -n "$POSTFIX" ]; then
+            T=$(( $PFX_SZ + $(echo $POSTFIX | wc -c) + 2 ))
+	        TABS="$(printf '\t\t\t\t\t\t')"
+		    TABCOUNT=$(( ( 6*8 - ($T + 1) - $(echo "$NAME" | wc -c) ) / 8 ))
+		    printf "\t[%s - %s]%.*s = %s,\n" "$PFX$NAME" "$POSTFIX" "$TABCOUNT" "$TABS" "$VALUE"
+        else
+		    TABCOUNT=$(( ( 5*8 - ($PFX_SZ + 1) - $(echo "$NAME" | wc -c) ) / 8 ))
+            printf "\t[%s]%.*s = %s,\n" "$PFX$NAME" "$TABCOUNT" "$TABS" "$VALUE"
+        fi
 	done
 	echo "};"
+}
+
+trap 'rm "$OUT"' EXIT
+
+(
+	echo "#ifndef _ASM_X86_CPUFEATURE_H"
+	echo "#include <asm/cpufeature.h>"
+	echo "#endif"
+	echo ""
+
+	dump_array "x86_cap_flags" "NCAPINTS*32" "X86_FEATURE_" ""
+	echo ""
+
+	dump_array "x86_bug_flags" "NBUGINTS*32" "X86_BUG_" "NCAPINTS*32"
+
 ) > $OUT
 
 trap - EXIT
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 06fe3ed..5433658 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -97,6 +97,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
+	seq_printf(m, "\nbugs\t\t:");
+	for (i = 0; i < 32*NBUGINTS; i++) {
+		unsigned int bug_bit = 32*NCAPINTS + i;
+
+		if (cpu_has_bug(c, bug_bit) && x86_bug_flags[i])
+			seq_printf(m, " %s", x86_bug_flags[i]);
+	}
+
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b6f794a..4a8013d 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -38,7 +38,6 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006, 0 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
-		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
 		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
 		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_PROC_FEEDBACK,	CR_EDX,11, 0x80000007, 0 },
