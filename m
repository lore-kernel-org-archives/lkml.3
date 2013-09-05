Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3IEWuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:50:39 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52501 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752786Ab3IEWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:35 -0400
Message-Id: <20130905225033.570006178@asylum.americas.sgi.com>
References: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:36 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] x86/UV: Add kdump to UV NMI handler
Content-Disposition: inline; filename=uv-add-kdump-on-nmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a system has hung and it no longer responds to external events, this
patch adds the capability of doing a standard kdump and system reboot
then triggered by the system NMI command.

It is enabled when the nmi action is changed to "kdump" and the
kernel is built with CONFIG_KEXEC enabled.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hberrich@sgi.com>
---
 arch/x86/platform/uv/uv_nmi.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -21,6 +21,7 @@
 
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/kexec.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
 #include <linux/sched.h>
@@ -70,6 +71,7 @@ static atomic_t	uv_in_nmi;
 static atomic_t uv_nmi_cpu = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_cpus_in_nmi = ATOMIC_INIT(-1);
 static atomic_t uv_nmi_slave_continue;
+static atomic_t uv_nmi_kexec_failed;
 static cpumask_var_t uv_nmi_cpu_mask;
 
 /* Values for uv_nmi_slave_continue */
@@ -143,6 +145,7 @@ module_param_named(retry_count, uv_nmi_r
  * Valid NMI Actions:
  *  "dump"	- dump process stack for each cpu
  *  "ips"	- dump IP info for each cpu
+ *  "kdump"	- do crash dump
  */
 static char uv_nmi_action[8] = "dump";
 module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
@@ -496,6 +499,40 @@ static void uv_nmi_touch_watchdogs(void)
 	touch_nmi_watchdog();
 }
 
+#if defined(CONFIG_KEXEC)
+static void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
+{
+	/* Call crash to dump system state */
+	if (master) {
+		pr_emerg("UV: NMI executing crash_kexec on CPU%d\n", cpu);
+		crash_kexec(regs);
+
+		pr_emerg("UV: crash_kexec unexpectedly returned, ");
+		if (!kexec_crash_image) {
+			pr_cont("crash kernel not loaded\n");
+			atomic_set(&uv_nmi_kexec_failed, 1);
+			uv_nmi_sync_exit(1);
+			return;
+		}
+		pr_cont("kexec busy, stalling cpus while waiting\n");
+	}
+
+	/* If crash exec fails the slaves should return, otherwise stall */
+	while (atomic_read(&uv_nmi_kexec_failed) == 0)
+		mdelay(10);
+
+	/* Crash kernel most likely not loaded, return in an orderly fashion */
+	uv_nmi_sync_exit(0);
+}
+
+#else /* !CONFIG_KEXEC */
+static inline void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
+{
+	if (master)
+		pr_err("UV: NMI kdump: KEXEC not supported in this kernel\n");
+}
+#endif /* !CONFIG_KEXEC */
+
 /*
  * UV NMI handler
  */
@@ -517,6 +554,10 @@ int uv_handle_nmi(unsigned int reason, s
 	/* Indicate we are the first CPU into the NMI handler */
 	master = (atomic_read(&uv_nmi_cpu) == cpu);
 
+	/* If NMI action is "kdump", then attempt to do it */
+	if (uv_nmi_action_is("kdump"))
+		uv_nmi_kdump(cpu, master, regs);
+
 	/* Pause as all cpus enter the NMI handler */
 	uv_nmi_wait(master);
 

-- 
