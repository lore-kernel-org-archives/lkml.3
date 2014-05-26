Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaEZTyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:54:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51459 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaEZTyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:54:53 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, CPU: Convert more features to bugs
Date: Mon, 26 May 2014 21:54:42 +0200
Message-Id: <1401134082-14673-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

X86_FEATURE_FXSAVE_LEAK, X86_FEATURE_11AP and
X86_FEATURE_CLFLUSH_MONITOR are not really features but synthetic bits
we use for applying different bug workarounds. Call them what they
really are.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/apic.h         | 2 +-
 arch/x86/include/asm/cpufeature.h   | 9 ++++++---
 arch/x86/include/asm/fpu-internal.h | 2 +-
 arch/x86/include/asm/mwait.h        | 2 +-
 arch/x86/kernel/cpu/amd.c           | 2 +-
 arch/x86/kernel/cpu/intel.c         | 4 ++--
 6 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 19b0ebafcd3e..79752f2bdec5 100644
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
index e265ff95d16d..5a0578fbd458 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -81,7 +81,7 @@
 #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
 #define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
 #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
-#define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
+/* free, was #define X86_FEATURE_FXSAVE_LEAK (3*32+10) "" FXSAVE leaks FOP/FIP/FOP */
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
@@ -90,13 +90,13 @@
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* "" Mfence synchronizes RDTSC */
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
-#define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
+/* free, was: #define X86_FEATURE_11AP	(3*32+19) "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_ALWAYS	(3*32+21) /* "" Always-present feature */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
-#define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
+/* free, was #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) "" clflush reqd with monitor */
 #define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
 #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
@@ -236,6 +236,9 @@
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
 #define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
 #define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
+#define X86_BUG_11AP		X86_BUG(5) /* Bad local APIC aka 11AP */
+#define X86_BUG_FXSAVE_LEAK	X86_BUG(6) /* FXSAVE leaks FOP/FIP/FOP */
+#define X86_BUG_CLFLUSH_MONITOR	X86_BUG(7) /* AAI65, CLFLUSH required before MONITOR */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 115e3689cd53..60171447d10c 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -293,7 +293,7 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. "m" is a random variable that should be in L1 */
-	if (unlikely(static_cpu_has_safe(X86_FEATURE_FXSAVE_LEAK))) {
+	if (unlikely(static_cpu_has_safe(X86_BUG_FXSAVE_LEAK))) {
 		asm volatile(
 			"fnclex\n\t"
 			"emms\n\t"
diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index 1da25a5f96f9..097523107474 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -43,7 +43,7 @@ static inline void __mwait(unsigned long eax, unsigned long ecx)
 static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
 	if (!current_set_polling_and_test()) {
-		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
+		if (static_cpu_has(X86_BUG_CLFLUSH_MONITOR)) {
 			mb();
 			clflush((void *)&current_thread_info()->flags);
 			mb();
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff0e0ef..f279ce665438 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -595,7 +595,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 
 	/* Enable workaround for FXSAVE leak */
 	if (c->x86 >= 6)
-		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
+		set_cpu_cap(c, X86_BUG_FXSAVE_LEAK);
 
 	if (!c->x86_model_id[0]) {
 		switch (c->x86) {
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a80029035bf2..59803ad0efa9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -253,7 +253,7 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 	 */
 	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
 	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
-		set_cpu_cap(c, X86_FEATURE_11AP);
+		set_cpu_cap(c, X86_BUG_11AP);
 
 
 #ifdef CONFIG_X86_INTEL_USERCOPY
@@ -391,7 +391,7 @@ static void init_intel(struct cpuinfo_x86 *c)
 
 	if (c->x86 == 6 && cpu_has_clflush &&
 	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
-		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
+		set_cpu_cap(c, X86_BUG_CLFLUSH_MONITOR);
 
 #ifdef CONFIG_X86_64
 	if (c->x86 == 15)
-- 
1.9.0

