Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3KTE0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:26:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40745 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3KTEWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:35 -0500
Subject: [PATCH -tip v3 16/23] x86/nmi: Use NOKPROBE_SYMBOL macro for nmi
 handlers
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Zhang Rui <rui.zhang@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 20 Nov 2013 04:22:28 +0000
Message-ID: <20131120042228.15296.3460.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from
kprobes instead of __kprobes annotation for nmi handlers.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>
---
 arch/x86/kernel/apic/hw_nmi.c            |    3 ++-
 arch/x86/kernel/cpu/perf_event.c         |    3 ++-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    3 ++-
 arch/x86/kernel/nmi.c                    |   18 ++++++++++++------
 4 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index a698d71..73eb5b3 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -60,7 +60,7 @@ void arch_trigger_all_cpu_backtrace(void)
 	smp_mb__after_clear_bit();
 }
 
-static int __kprobes
+static int
 arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	int cpu;
@@ -80,6 +80,7 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return NMI_DONE;
 }
+NOKPROBE_SYMBOL(arch_trigger_all_cpu_backtrace_handler);
 
 static int __init register_trigger_all_cpu_backtrace(void)
 {
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 98f845b..396c1a2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1273,7 +1273,7 @@ void perf_events_lapic_init(void)
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
 }
 
-static int __kprobes
+static int
 perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	u64 start_clock;
@@ -1291,6 +1291,7 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return ret;
 }
+NOKPROBE_SYMBOL(perf_event_nmi_handler);
 
 struct event_constraint emptyconstraint;
 struct event_constraint unconstrained;
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index e09f0bf..c668309 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -592,7 +592,7 @@ out:
 	return 1;
 }
 
-static int __kprobes
+static int
 perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	int handled = 0;
@@ -605,6 +605,7 @@ perf_ibs_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 
 	return handled;
 }
+NOKPROBE_SYMBOL(perf_ibs_nmi_handler);
 
 static __init int perf_ibs_pmu_init(struct perf_ibs *perf_ibs, char *name)
 {
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 6fcb49c..38ce829 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -95,7 +95,7 @@ static int __init nmi_warning_debugfs(void)
 }
 fs_initcall(nmi_warning_debugfs);
 
-static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
+static int nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *a;
@@ -137,6 +137,7 @@ static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2
 	/* return total number of NMI events handled */
 	return handled;
 }
+NOKPROBE_SYMBOL(nmi_handle);
 
 int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 {
@@ -197,7 +198,7 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 }
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
-static __kprobes void
+static void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
 	/* check to see if anyone registered against these types of errors */
@@ -227,8 +228,9 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_SERR;
 	outb(reason, NMI_REASON_PORT);
 }
+NOKPROBE_SYMBOL(pci_serr_error);
 
-static __kprobes void
+static void
 io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
@@ -258,8 +260,9 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	reason &= ~NMI_REASON_CLEAR_IOCHK;
 	outb(reason, NMI_REASON_PORT);
 }
+NOKPROBE_SYMBOL(io_check_error);
 
-static __kprobes void
+static void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
 	int handled;
@@ -287,11 +290,12 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 	pr_emerg("Dazed and confused, but trying to continue\n");
 }
+NOKPROBE_SYMBOL(unknown_nmi_error);
 
 static DEFINE_PER_CPU(bool, swallow_nmi);
 static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
 
-static __kprobes void default_do_nmi(struct pt_regs *regs)
+static void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int handled;
@@ -390,6 +394,7 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 	else
 		unknown_nmi_error(reason, regs);
 }
+NOKPROBE_SYMBOL(default_do_nmi);
 
 /*
  * NMIs can hit breakpoints which will cause it to lose its
@@ -509,7 +514,7 @@ static inline void nmi_nesting_postprocess(void)
 }
 #endif
 
-dotraplinkage notrace __kprobes void
+dotraplinkage notrace void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_nesting_preprocess(regs);
@@ -526,6 +531,7 @@ do_nmi(struct pt_regs *regs, long error_code)
 	/* On i386, may loop back to preprocess */
 	nmi_nesting_postprocess();
 }
+NOKPROBE_SYMBOL(do_nmi);
 
 void stop_nmi(void)
 {


