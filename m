Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaASMIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:08:52 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48283 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaASMIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:08:49 -0500
Date: Sun, 19 Jan 2014 13:08:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140119120843.GA15682@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: bee09ed91cacdbffdbcd3b05de8409c77ec9fcd6 perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

It contains:

 - an s2ram related fix on AMD systems

 - a perf fault handling bug that is relatively old but which has
   become much easier to trigger in v3.13 after commit e00b12e64be9.

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      x86, mm, perf: Allow recursive faults from interrupts

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h


 arch/x86/kernel/cpu/perf_event_amd_ibs.c | 53 +++++++++++++++++++++++++++-----
 arch/x86/mm/fault.c                      | 18 +++++++++++
 2 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index e09f0bf..4b8e4d3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ptrace.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/apic.h>
 
@@ -816,6 +817,18 @@ out:
 	return ret;
 }
 
+static void ibs_eilvt_setup(void)
+{
+	/*
+	 * Force LVT offset assignment for family 10h: The offsets are
+	 * not assigned by the BIOS for this family, so the OS is
+	 * responsible for doing it. If the OS assignment fails, fall
+	 * back to BIOS settings and try to setup this.
+	 */
+	if (boot_cpu_data.x86 == 0x10)
+		force_ibs_eilvt_setup();
+}
+
 static inline int get_ibs_lvt_offset(void)
 {
 	u64 val;
@@ -851,6 +864,36 @@ static void clear_APIC_ibs(void *dummy)
 		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
 }
 
+#ifdef CONFIG_PM
+
+static int perf_ibs_suspend(void)
+{
+	clear_APIC_ibs(NULL);
+	return 0;
+}
+
+static void perf_ibs_resume(void)
+{
+	ibs_eilvt_setup();
+	setup_APIC_ibs(NULL);
+}
+
+static struct syscore_ops perf_ibs_syscore_ops = {
+	.resume		= perf_ibs_resume,
+	.suspend	= perf_ibs_suspend,
+};
+
+static void perf_ibs_pm_init(void)
+{
+	register_syscore_ops(&perf_ibs_syscore_ops);
+}
+
+#else
+
+static inline void perf_ibs_pm_init(void) { }
+
+#endif
+
 static int
 perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
@@ -877,18 +920,12 @@ static __init int amd_ibs_init(void)
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
-	/*
-	 * Force LVT offset assignment for family 10h: The offsets are
-	 * not assigned by the BIOS for this family, so the OS is
-	 * responsible for doing it. If the OS assignment fails, fall
-	 * back to BIOS settings and try to setup this.
-	 */
-	if (boot_cpu_data.x86 == 0x10)
-		force_ibs_eilvt_setup();
+	ibs_eilvt_setup();
 
 	if (!ibs_eilvt_valid())
 		goto out;
 
+	perf_ibs_pm_init();
 	get_online_cpus();
 	ibs_caps = caps;
 	/* make ibs_caps visible to other cpus: */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9ff85bb..9d591c8 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -641,6 +641,20 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 
 	/* Are we prepared to handle this kernel fault? */
 	if (fixup_exception(regs)) {
+		/*
+		 * Any interrupt that takes a fault gets the fixup. This makes
+		 * the below recursive fault logic only apply to a faults from
+		 * task context.
+		 */
+		if (in_interrupt())
+			return;
+
+		/*
+		 * Per the above we're !in_interrupt(), aka. task context.
+		 *
+		 * In this case we need to make sure we're not recursively
+		 * faulting through the emulate_vsyscall() logic.
+		 */
 		if (current_thread_info()->sig_on_uaccess_error && signal) {
 			tsk->thread.trap_nr = X86_TRAP_PF;
 			tsk->thread.error_code = error_code | PF_USER;
@@ -649,6 +663,10 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 			/* XXX: hwpoison faults will set the wrong code. */
 			force_sig_info_fault(signal, si_code, address, tsk, 0);
 		}
+
+		/*
+		 * Barring that, we can do the fixup and be happy.
+		 */
 		return;
 	}
 
