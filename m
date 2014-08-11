Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaHKXEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 19:04:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaHKXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 19:03:59 -0400
Date: Mon, 11 Aug 2014 16:03:29 -0700
Message-Id: <201408112303.s7BN3T3h021165@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/xsave changes for v3.17-rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: bp@suse.de, fenghua.yu@intel.com, hpa@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a patchset to support the XSAVES instruction required to
support context switch of supervisor-only features in upcoming
silicon.  This patchset missed the 3.16 merge window, which is why it
is based on 3.15-rc7.

	-hpa

The following changes since commit c7208164e66f63e3ec1759b98087849286410741:

  Linux 3.15-rc7 (2014-05-25 16:06:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-xsave-for-linus

for you to fetch changes up to d0f2dd186133a0241a2ccefb188a0e49e8187859:

  x86, xsave: Add forgotten inline annotation (2014-06-18 15:19:59 -0700)

----------------------------------------------------------------
Borislav Petkov (1):
      x86, xsave: Add forgotten inline annotation

Fenghua Yu (17):
      x86/cpufeature.h: Reformat x86 feature macros
      x86/xsaves: Detect xsaves/xrstors feature
      x86/xsaves: Add a kernel parameter noxsaves to disable xsaves/xrstors
      x86/alternative: Add alternative_input_2 to support alternative with two features and input
      x86/xsaves: Change compacted format xsave area header
      x86/xsaves: Define macros for xsave instructions
      x86/xsaves: Define a macro for handling xsave/xrstor instruction fault
      x86/xsaves: Use xsaves/xrstors to save and restore xsave area
      x86/xsaves: Use xsaves/xrstors for context switch
      x86/xsaves: Use xsave/xrstor for saving and restoring user space context
      x86/xsaves: Clear reserved bits in xsave header
      x86/xsaves: Add xsaves and xrstors support for booting time
      x86/xsaves: Save xstate to task's xsave area in __save_fpu during booting time
      x86/xsaves: Call booting time xsaves and xrstors in setup_init_fpu_buf
      x86/xsaves: Enable xsaves/xrstors
      Define kernel API to get address of each state in xsave area
      x86/xsaves: Clean up code in xstate offsets computation in xsave area

H. Peter Anvin (1):
      x86/xsave: Make it clear that the XSAVE macros use (%edi)/(%rdi)

 Documentation/kernel-parameters.txt   |  15 ++
 arch/x86/include/asm/alternative.h    |  14 ++
 arch/x86/include/asm/cpufeature.h     | 370 +++++++++++++++++-----------------
 arch/x86/include/asm/fpu-internal.h   |   9 +-
 arch/x86/include/asm/processor.h      |   4 +-
 arch/x86/include/asm/xsave.h          | 223 +++++++++++++++-----
 arch/x86/include/uapi/asm/msr-index.h |   2 +
 arch/x86/kernel/cpu/common.c          |  17 ++
 arch/x86/kernel/cpu/scattered.c       |   1 -
 arch/x86/kernel/i387.c                |   2 +-
 arch/x86/kernel/process.c             |   1 +
 arch/x86/kernel/xsave.c               | 118 ++++++++++-
 12 files changed, 523 insertions(+), 253 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 30a8ad0d..0ebd952 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2124,6 +2124,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			and restore using xsave. The kernel will fallback to
 			enabling legacy floating-point and sse state.
 
+	noxsaveopt	[X86] Disables xsaveopt used in saving x86 extended
+			register states. The kernel will fall back to use
+			xsave to save the states. By using this parameter,
+			performance of saving the states is degraded because
+			xsave doesn't support modified optimization while
+			xsaveopt supports it on xsaveopt enabled systems.
+
+	noxsaves	[X86] Disables xsaves and xrstors used in saving and
+			restoring x86 extended register state in compacted
+			form of xsave area. The kernel will fall back to use
+			xsaveopt and xrstor to save and restore the states
+			in standard form of xsave area. By using this
+			parameter, xsave area per process might occupy more
+			memory on xsaves enabled systems.
+
 	eagerfpu=	[X86]
 			on	enable eager fpu restore
 			off	disable eager fpu restore
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 0a3f9c9..473bdbe 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -161,6 +161,20 @@ static inline int alternatives_text_reserved(void *start, void *end)
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
 		: : "i" (0), ## input)
 
+/*
+ * This is similar to alternative_input. But it has two features and
+ * respective instructions.
+ *
+ * If CPU has feature2, newinstr2 is used.
+ * Otherwise, if CPU has feature1, newinstr1 is used.
+ * Otherwise, oldinstr is used.
+ */
+#define alternative_input_2(oldinstr, newinstr1, feature1, newinstr2,	     \
+			   feature2, input...)				     \
+	asm volatile(ALTERNATIVE_2(oldinstr, newinstr1, feature1,	     \
+		newinstr2, feature2)					     \
+		: : "i" (0), ## input)
+
 /* Like alternative_input, but with a single output argument */
 #define alternative_io(oldinstr, newinstr, feature, output, input...)	\
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index e265ff9..b82f951 100644
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
+#define X86_FEATURE_FXSAVE_LEAK ( 3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
+#define X86_FEATURE_ARCH_PERFMON ( 3*32+11) /* Intel Architectural PerfMon */
+#define X86_FEATURE_PEBS	( 3*32+12) /* Precise-Event Based Sampling */
+#define X86_FEATURE_BTS		( 3*32+13) /* Branch Trace Store */
+#define X86_FEATURE_SYSCALL32	( 3*32+14) /* "" syscall in ia32 userspace */
+#define X86_FEATURE_SYSENTER32	( 3*32+15) /* "" sysenter in ia32 userspace */
+#define X86_FEATURE_REP_GOOD	( 3*32+16) /* rep microcode works well */
+#define X86_FEATURE_MFENCE_RDTSC ( 3*32+17) /* "" Mfence synchronizes RDTSC */
+#define X86_FEATURE_LFENCE_RDTSC ( 3*32+18) /* "" Lfence synchronizes RDTSC */
+#define X86_FEATURE_11AP	( 3*32+19) /* "" Bad local APIC aka 11AP */
+#define X86_FEATURE_NOPL	( 3*32+20) /* The NOPL (0F 1F) instructions */
+#define X86_FEATURE_ALWAYS	( 3*32+21) /* "" Always-present feature */
+#define X86_FEATURE_XTOPOLOGY	( 3*32+22) /* cpu topology enum extensions */
+#define X86_FEATURE_TSC_RELIABLE ( 3*32+23) /* TSC is known to be reliable */
+#define X86_FEATURE_NONSTOP_TSC	( 3*32+24) /* TSC does not stop in C states */
+#define X86_FEATURE_CLFLUSH_MONITOR ( 3*32+25) /* "" clflush reqd with monitor */
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
@@ -328,6 +333,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_xsaveopt	boot_cpu_has(X86_FEATURE_XSAVEOPT)
+#define cpu_has_xsaves		boot_cpu_has(X86_FEATURE_XSAVES)
 #define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index cea1c76..6099c0e 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -508,9 +508,12 @@ static inline void user_fpu_begin(void)
 
 static inline void __save_fpu(struct task_struct *tsk)
 {
-	if (use_xsave())
-		xsave_state(&tsk->thread.fpu.state->xsave, -1);
-	else
+	if (use_xsave()) {
+		if (unlikely(system_state == SYSTEM_BOOTING))
+			xsave_state_booting(&tsk->thread.fpu.state->xsave, -1);
+		else
+			xsave_state(&tsk->thread.fpu.state->xsave, -1);
+	} else
 		fpu_fxsave(&tsk->thread.fpu);
 }
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a4ea023..2c8d3b8 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -386,8 +386,8 @@ struct bndcsr_struct {
 
 struct xsave_hdr_struct {
 	u64 xstate_bv;
-	u64 reserved1[2];
-	u64 reserved2[5];
+	u64 xcomp_bv;
+	u64 reserved[6];
 } __attribute__((packed));
 
 struct xsave_struct {
diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index d949ef2..7e7a79a 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -52,24 +52,170 @@ extern void xsave_init(void);
 extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
 extern int init_fpu(struct task_struct *child);
 
-static inline int fpu_xrstor_checking(struct xsave_struct *fx)
+/* These macros all use (%edi)/(%rdi) as the single memory argument. */
+#define XSAVE		".byte " REX_PREFIX "0x0f,0xae,0x27"
+#define XSAVEOPT	".byte " REX_PREFIX "0x0f,0xae,0x37"
+#define XSAVES		".byte " REX_PREFIX "0x0f,0xc7,0x2f"
+#define XRSTOR		".byte " REX_PREFIX "0x0f,0xae,0x2f"
+#define XRSTORS		".byte " REX_PREFIX "0x0f,0xc7,0x1f"
+
+#define xstate_fault	".section .fixup,\"ax\"\n"	\
+			"3:  movl $-1,%[err]\n"		\
+			"    jmp  2b\n"			\
+			".previous\n"			\
+			_ASM_EXTABLE(1b, 3b)		\
+			: [err] "=r" (err)
+
+/*
+ * This function is called only during boot time when x86 caps are not set
+ * up and alternative can not be used yet.
+ */
+static inline int xsave_state_booting(struct xsave_struct *fx, u64 mask)
 {
-	int err;
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err = 0;
+
+	WARN_ON(system_state != SYSTEM_BOOTING);
+
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		asm volatile("1:"XSAVES"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+	else
+		asm volatile("1:"XSAVE"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+
+	asm volatile(xstate_fault
+		     : "0" (0)
+		     : "memory");
+
+	return err;
+}
+
+/*
+ * This function is called only during boot time when x86 caps are not set
+ * up and alternative can not be used yet.
+ */
+static inline int xrstor_state_booting(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err = 0;
+
+	WARN_ON(system_state != SYSTEM_BOOTING);
 
-	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : [err] "=r" (err)
-		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		asm volatile("1:"XRSTORS"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+	else
+		asm volatile("1:"XRSTOR"\n\t"
+			"2:\n\t"
+			: : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+			:   "memory");
+
+	asm volatile(xstate_fault
+		     : "0" (0)
+		     : "memory");
+
+	return err;
+}
+
+/*
+ * Save processor xstate to xsave area.
+ */
+static inline int xsave_state(struct xsave_struct *fx, u64 mask)
+{
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err = 0;
+
+	/*
+	 * If xsaves is enabled, xsaves replaces xsaveopt because
+	 * it supports compact format and supervisor states in addition to
+	 * modified optimization in xsaveopt.
+	 *
+	 * Otherwise, if xsaveopt is enabled, xsaveopt replaces xsave
+	 * because xsaveopt supports modified optimization which is not
+	 * supported by xsave.
+	 *
+	 * If none of xsaves and xsaveopt is enabled, use xsave.
+	 */
+	alternative_input_2(
+		"1:"XSAVE,
+		"1:"XSAVEOPT,
+		X86_FEATURE_XSAVEOPT,
+		"1:"XSAVES,
+		X86_FEATURE_XSAVES,
+		[fx] "D" (fx), "a" (lmask), "d" (hmask) :
+		"memory");
+	asm volatile("2:\n\t"
+		     xstate_fault
+		     : "0" (0)
 		     : "memory");
 
 	return err;
 }
 
+/*
+ * Restore processor xstate from xsave area.
+ */
+static inline int xrstor_state(struct xsave_struct *fx, u64 mask)
+{
+	int err = 0;
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+
+	/*
+	 * Use xrstors to restore context if it is enabled. xrstors supports
+	 * compacted format of xsave area which is not supported by xrstor.
+	 */
+	alternative_input(
+		"1: " XRSTOR,
+		"1: " XRSTORS,
+		X86_FEATURE_XSAVES,
+		"D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
+		: "memory");
+
+	asm volatile("2:\n"
+		     xstate_fault
+		     : "0" (0)
+		     : "memory");
+
+	return err;
+}
+
+/*
+ * Save xstate context for old process during context switch.
+ */
+static inline void fpu_xsave(struct fpu *fpu)
+{
+	xsave_state(&fpu->state->xsave, -1);
+}
+
+/*
+ * Restore xstate context for new process during context switch.
+ */
+static inline int fpu_xrstor_checking(struct xsave_struct *fx)
+{
+	return xrstor_state(fx, -1);
+}
+
+/*
+ * Save xstate to user space xsave area.
+ *
+ * We don't use modified optimization because xrstor/xrstors might track
+ * a different application.
+ *
+ * We don't use compacted format xsave area for
+ * backward compatibility for old applications which don't understand
+ * compacted format of xsave area.
+ */
 static inline int xsave_user(struct xsave_struct __user *buf)
 {
 	int err;
@@ -83,69 +229,34 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 		return -EFAULT;
 
 	__asm__ __volatile__(ASM_STAC "\n"
-			     "1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
+			     "1:"XSAVE"\n"
 			     "2: " ASM_CLAC "\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : [err] "=r" (err)
+			     xstate_fault
 			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
 			     : "memory");
 	return err;
 }
 
+/*
+ * Restore xstate from user space xsave area.
+ */
 static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 {
-	int err;
+	int err = 0;
 	struct xsave_struct *xstate = ((__force struct xsave_struct *)buf);
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 
 	__asm__ __volatile__(ASM_STAC "\n"
-			     "1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n"
+			     "1:"XRSTOR"\n"
 			     "2: " ASM_CLAC "\n"
-			     ".section .fixup,\"ax\"\n"
-			     "3:  movl $-1,%[err]\n"
-			     "    jmp  2b\n"
-			     ".previous\n"
-			     _ASM_EXTABLE(1b,3b)
-			     : [err] "=r" (err)
+			     xstate_fault
 			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
 			     : "memory");	/* memory required? */
 	return err;
 }
 
-static inline void xrstor_state(struct xsave_struct *fx, u64 mask)
-{
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-
-	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
-		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
-		     :   "memory");
-}
-
-static inline void xsave_state(struct xsave_struct *fx, u64 mask)
-{
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
+void *get_xsave_addr(struct xsave_struct *xsave, int xstate);
+void setup_xstate_comp(void);
 
-	asm volatile(".byte " REX_PREFIX "0x0f,0xae,0x27\n\t"
-		     : : "D" (fx), "m" (*fx), "a" (lmask), "d" (hmask)
-		     :   "memory");
-}
-
-static inline void fpu_xsave(struct fpu *fpu)
-{
-	/* This, however, we can work around by forcing the compiler to select
-	   an addressing mode that doesn't require extended registers. */
-	alternative_input(
-		".byte " REX_PREFIX "0x0f,0xae,0x27",
-		".byte " REX_PREFIX "0x0f,0xae,0x37",
-		X86_FEATURE_XSAVEOPT,
-		[fx] "D" (&fpu->state->xsave), "a" (-1), "d" (-1) :
-		"memory");
-}
 #endif
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..cdc9585 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -146,6 +146,7 @@ static int __init x86_xsave_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
 	setup_clear_cpu_cap(X86_FEATURE_AVX);
 	setup_clear_cpu_cap(X86_FEATURE_AVX2);
 	return 1;
@@ -159,6 +160,13 @@ static int __init x86_xsaveopt_setup(char *s)
 }
 __setup("noxsaveopt", x86_xsaveopt_setup);
 
+static int __init x86_xsaves_setup(char *s)
+{
+	setup_clear_cpu_cap(X86_FEATURE_XSAVES);
+	return 1;
+}
+__setup("noxsaves", x86_xsaves_setup);
+
 #ifdef CONFIG_X86_32
 static int cachesize_override = -1;
 static int disable_x86_serial_nr = 1;
@@ -632,6 +640,15 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
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
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index d5dd808..a9a4229 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -375,7 +375,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	/*
 	 * These bits must be zero.
 	 */
-	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+	memset(xsave_hdr->reserved, 0, 48);
 
 	return ret;
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4505e2a..f804dc9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -93,6 +93,7 @@ void arch_task_cache_init(void)
         	kmem_cache_create("task_xstate", xstate_size,
 				  __alignof__(union thread_xstate),
 				  SLAB_PANIC | SLAB_NOTRACK, NULL);
+	setup_xstate_comp();
 }
 
 /*
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a4b451c..940b142 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -8,6 +8,7 @@
 
 #include <linux/bootmem.h>
 #include <linux/compat.h>
+#include <linux/cpu.h>
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/sigframe.h>
@@ -24,7 +25,9 @@ u64 pcntxt_mask;
 struct xsave_struct *init_xstate_buf;
 
 static struct _fpx_sw_bytes fx_sw_reserved, fx_sw_reserved_ia32;
-static unsigned int *xstate_offsets, *xstate_sizes, xstate_features;
+static unsigned int *xstate_offsets, *xstate_sizes;
+static unsigned int xstate_comp_offsets[sizeof(pcntxt_mask)*8];
+static unsigned int xstate_features;
 
 /*
  * If a processor implementation discern that a processor state component is
@@ -283,7 +286,7 @@ sanitize_restored_xstate(struct task_struct *tsk,
 
 	if (use_xsave()) {
 		/* These bits must be zero. */
-		xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+		memset(xsave_hdr->reserved, 0, 48);
 
 		/*
 		 * Init the state that is not present in the memory
@@ -479,6 +482,52 @@ static void __init setup_xstate_features(void)
 }
 
 /*
+ * This function sets up offsets and sizes of all extended states in
+ * xsave area. This supports both standard format and compacted format
+ * of the xsave aread.
+ *
+ * Input: void
+ * Output: void
+ */
+void setup_xstate_comp(void)
+{
+	unsigned int xstate_comp_sizes[sizeof(pcntxt_mask)*8];
+	int i;
+
+	/*
+	 * The FP xstates and SSE xstates are legacy states. They are always
+	 * in the fixed offsets in the xsave area in either compacted form
+	 * or standard form.
+	 */
+	xstate_comp_offsets[0] = 0;
+	xstate_comp_offsets[1] = offsetof(struct i387_fxsave_struct, xmm_space);
+
+	if (!cpu_has_xsaves) {
+		for (i = 2; i < xstate_features; i++) {
+			if (test_bit(i, (unsigned long *)&pcntxt_mask)) {
+				xstate_comp_offsets[i] = xstate_offsets[i];
+				xstate_comp_sizes[i] = xstate_sizes[i];
+			}
+		}
+		return;
+	}
+
+	xstate_comp_offsets[2] = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+
+	for (i = 2; i < xstate_features; i++) {
+		if (test_bit(i, (unsigned long *)&pcntxt_mask))
+			xstate_comp_sizes[i] = xstate_sizes[i];
+		else
+			xstate_comp_sizes[i] = 0;
+
+		if (i > 2)
+			xstate_comp_offsets[i] = xstate_comp_offsets[i-1]
+					+ xstate_comp_sizes[i-1];
+
+	}
+}
+
+/*
  * setup the xstate image representing the init state
  */
 static void __init setup_init_fpu_buf(void)
@@ -496,15 +545,21 @@ static void __init setup_init_fpu_buf(void)
 
 	setup_xstate_features();
 
+	if (cpu_has_xsaves) {
+		init_xstate_buf->xsave_hdr.xcomp_bv =
+						(u64)1 << 63 | pcntxt_mask;
+		init_xstate_buf->xsave_hdr.xstate_bv = pcntxt_mask;
+	}
+
 	/*
 	 * Init all the features state with header_bv being 0x0
 	 */
-	xrstor_state(init_xstate_buf, -1);
+	xrstor_state_booting(init_xstate_buf, -1);
 	/*
 	 * Dump the init state again. This is to identify the init state
 	 * of any feature which is not represented by all zero's.
 	 */
-	xsave_state(init_xstate_buf, -1);
+	xsave_state_booting(init_xstate_buf, -1);
 }
 
 static enum { AUTO, ENABLE, DISABLE } eagerfpu = AUTO;
@@ -520,6 +575,30 @@ static int __init eager_fpu_setup(char *s)
 }
 __setup("eagerfpu=", eager_fpu_setup);
 
+
+/*
+ * Calculate total size of enabled xstates in XCR0/pcntxt_mask.
+ */
+static void __init init_xstate_size(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	int i;
+
+	if (!cpu_has_xsaves) {
+		cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
+		xstate_size = ebx;
+		return;
+	}
+
+	xstate_size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
+	for (i = 2; i < 64; i++) {
+		if (test_bit(i, (unsigned long *)&pcntxt_mask)) {
+			cpuid_count(XSTATE_CPUID, i, &eax, &ebx, &ecx, &edx);
+			xstate_size += eax;
+		}
+	}
+}
+
 /*
  * Enable and initialize the xsave feature.
  */
@@ -551,8 +630,7 @@ static void __init xstate_enable_boot_cpu(void)
 	/*
 	 * Recompute the context size for enabled features
 	 */
-	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
-	xstate_size = ebx;
+	init_xstate_size();
 
 	update_regset_xstate_info(xstate_size, pcntxt_mask);
 	prepare_fx_sw_frame();
@@ -572,8 +650,9 @@ static void __init xstate_enable_boot_cpu(void)
 		}
 	}
 
-	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
-		pcntxt_mask, xstate_size);
+	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x using %s\n",
+		pcntxt_mask, xstate_size,
+		cpu_has_xsaves ? "compacted form" : "standard form");
 }
 
 /*
@@ -635,3 +714,26 @@ void eager_fpu_init(void)
 	else
 		fxrstor_checking(&init_xstate_buf->i387);
 }
+
+/*
+ * Given the xsave area and a state inside, this function returns the
+ * address of the state.
+ *
+ * This is the API that is called to get xstate address in either
+ * standard format or compacted format of xsave area.
+ *
+ * Inputs:
+ *	xsave: base address of the xsave area;
+ *	xstate: state which is defined in xsave.h (e.g. XSTATE_FP, XSTATE_SSE,
+ *	etc.)
+ * Output:
+ *	address of the state in the xsave area.
+ */
+void *get_xsave_addr(struct xsave_struct *xsave, int xstate)
+{
+	int feature = fls64(xstate) - 1;
+	if (!test_bit(feature, (unsigned long *)&pcntxt_mask))
+		return NULL;
+
+	return (void *)xsave + xstate_comp_offsets[feature];
+}
