Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaG0AoH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 20:44:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaG0AoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 20:44:05 -0400
Date: Sat, 26 Jul 2014 17:42:28 -0700
Message-Id: <201407270042.s6R0gSb6024405@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.16-rc7
Cc: <stable@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@suse.de>, Bruno Wolff III <bruno@wolff.to>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sven Wegener <sven.wegener@stealer.net>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A couple of crash fixes, plus a fix that on 32 bits would cause a
missing -ENOSYS for nonexistent system calls.

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

The head of this tree is bf72f5dee0656cfa9dc40bcb533f08d1d144e6ea.

for you to fetch changes up to bf72f5dee0656cfa9dc40bcb533f08d1d144e6ea:

  x86: Merge tag 'ras_urgent' into x86/urgent (2014-07-24 16:32:31 -0700)

----------------------------------------------------------------

Borislav Petkov (1):
      x86, MCE: Robustify mcheck_init_device

H. Peter Anvin (1):
      x86: Merge tag 'ras_urgent' into x86/urgent

Peter Zijlstra (1):
      x86, cpu: Fix cache topology for early P4-SMT

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

 arch/x86/kernel/cpu/intel.c           | 22 +++++++++++-----------
 arch/x86/kernel/cpu/intel_cacheinfo.c | 12 ++++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c      | 10 ++++++----
 arch/x86/kernel/entry_32.S            |  9 +++++----
 4 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a80029035bf2..f9e4fdd3b877 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -370,6 +370,17 @@ static void init_intel(struct cpuinfo_x86 *c)
 	 */
 	detect_extended_topology(c);
 
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
+		/*
+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
+		 * detection.
+		 */
+		c->x86_max_cores = intel_num_cpu_cores(c);
+#ifdef CONFIG_X86_32
+		detect_ht(c);
+#endif
+	}
+
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
@@ -438,17 +449,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_P3);
 #endif
 
-	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
-		/*
-		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
-		 * detection.
-		 */
-		c->x86_max_cores = intel_num_cpu_cores(c);
-#ifdef CONFIG_X86_32
-		detect_ht(c);
-#endif
-	}
-
 	/* Work around errata */
 	srat_detect_node(c);
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index a952e9c85b6f..9c8f7394c612 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -730,6 +730,18 @@ unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 	}
 
+#ifdef CONFIG_X86_HT
+	/*
+	 * If cpu_llc_id is not yet set, this means cpuid_level < 4 which in
+	 * turns means that the only possibility is SMT (as indicated in
+	 * cpuid1). Since cpuid2 doesn't specify shared caches, and we know
+	 * that SMT shares all caches, we can unconditionally set cpu_llc_id to
+	 * c->phys_proc_id.
+	 */
+	if (per_cpu(cpu_llc_id, cpu) == BAD_APICID)
+		per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
+#endif
+
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
 	return l2;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38153b2..9a79c8dbd8e8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2451,6 +2451,12 @@ static __init int mcheck_init_device(void)
 	for_each_online_cpu(i) {
 		err = mce_device_create(i);
 		if (err) {
+			/*
+			 * Register notifier anyway (and do not unreg it) so
+			 * that we don't leave undeleted timers, see notifier
+			 * callback above.
+			 */
+			__register_hotcpu_notifier(&mce_cpu_notifier);
 			cpu_notifier_register_done();
 			goto err_device_create;
 		}
@@ -2471,10 +2477,6 @@ static __init int mcheck_init_device(void)
 err_register:
 	unregister_syscore_ops(&mce_syscore_ops);
 
-	cpu_notifier_register_begin();
-	__unregister_hotcpu_notifier(&mce_cpu_notifier);
-	cpu_notifier_register_done();
-
 err_device_create:
 	/*
 	 * We didn't keep track of which devices were created above, but
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dbaa23e78b36..0d0c9d4ab6d5 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -425,8 +425,8 @@ sysenter_do_call:
 	cmpl $(NR_syscalls), %eax
 	jae sysenter_badsys
 	call *sys_call_table(,%eax,4)
-	movl %eax,PT_EAX(%esp)
 sysenter_after_call:
+	movl %eax,PT_EAX(%esp)
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_OFF
@@ -502,6 +502,7 @@ ENTRY(system_call)
 	jae syscall_badsys
 syscall_call:
 	call *sys_call_table(,%eax,4)
+syscall_after_call:
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
 	LOCKDEP_SYS_EXIT
@@ -675,12 +676,12 @@ syscall_fault:
 END(syscall_fault)
 
 syscall_badsys:
-	movl $-ENOSYS,PT_EAX(%esp)
-	jmp syscall_exit
+	movl $-ENOSYS,%eax
+	jmp syscall_after_call
 END(syscall_badsys)
 
 sysenter_badsys:
-	movl $-ENOSYS,PT_EAX(%esp)
+	movl $-ENOSYS,%eax
 	jmp sysenter_after_call
 END(syscall_badsys)
 	CFI_ENDPROC
