Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaANQ0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:26:02 -0500
Received: from relay1.sgi.com ([192.48.179.29]:49310 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbaANQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:25:53 -0500
Message-Id: <20140114162551.480872353@asylum.americas.sgi.com>
References: <20140114162551.093907830@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Jan 2014 10:25:53 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] UV/NMI: Fix tip/bot/kbuild test robot problems v2
Content-Disposition: inline; filename=fix-tip-bot-errs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make uv_register_nmi_notifier() and uv_handle_nmi_ping() static to
address sparse warnings.

Fix problem where uv_nmi_kexec_failed is unused when CONFIG_KEXEC
is not defined.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
---
v2: update the description to include problems fixed.
---
 arch/x86/include/asm/uv/uv.h       |    2 --
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 -
 arch/x86/platform/uv/uv_nmi.c      |    9 ++++-----
 3 files changed, 4 insertions(+), 8 deletions(-)

--- linux.orig/arch/x86/include/asm/uv/uv.h
+++ linux/arch/x86/include/asm/uv/uv.h
@@ -12,7 +12,6 @@ extern enum uv_system_type get_uv_system
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
-extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
@@ -26,7 +25,6 @@ static inline enum uv_system_type get_uv
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
-static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long start, unsigned long end, unsigned int cpu)
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -980,7 +980,6 @@ void __init uv_system_init(void)
 	uv_nmi_setup();
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
-	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 
 	/* register Legacy VGA I/O redirection handler */
--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -74,7 +74,6 @@ static atomic_t	uv_in_nmi;
 static atomic_t uv_nmi_cpu = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_cpus_in_nmi = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_slave_continue;
-static atomic_t uv_nmi_kexec_failed;
 static cpumask_var_t uv_nmi_cpu_mask;
 
 /* Values for uv_nmi_slave_continue */
@@ -504,6 +503,7 @@ static void uv_nmi_touch_watchdogs(void)
 }
 
 #if defined(CONFIG_KEXEC)
+static atomic_t uv_nmi_kexec_failed;
 static void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
 {
 	/* Call crash to dump system state */
@@ -634,7 +634,7 @@ int uv_handle_nmi(unsigned int reason, s
 /*
  * NMI handler for pulling in CPUs when perf events are grabbing our NMI
  */
-int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
+static int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
 {
 	int ret;
 
@@ -651,7 +651,7 @@ int uv_handle_nmi_ping(unsigned int reas
 	return ret;
 }
 
-void uv_register_nmi_notifier(void)
+static void uv_register_nmi_notifier(void)
 {
 	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
 		pr_warn("UV: NMI handler failed to register\n");
@@ -695,6 +695,5 @@ void uv_nmi_setup(void)
 		uv_hub_nmi_per(cpu) = uv_hub_nmi_list[nid];
 	}
 	BUG_ON(!alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL));
+	uv_register_nmi_notifier();
 }
-
-

-- 
