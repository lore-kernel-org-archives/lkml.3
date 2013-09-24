Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab3IXIiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:38:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53261 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXIiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:38:13 -0400
Date: Tue, 24 Sep 2013 01:37:56 -0700
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-12ba6c990fab50fe568f3ad8715e81e356552428@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com, a.p.zijlstra@chello.nl,
        jason.wessel@windriver.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
In-Reply-To: <20130923212500.660567460@asylum.americas.sgi.com>
References: <20130923212500.660567460@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV: Add kdump to UV NMI handler
Git-Commit-ID: 12ba6c990fab50fe568f3ad8715e81e356552428
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 24 Sep 2013 01:38:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12ba6c990fab50fe568f3ad8715e81e356552428
Gitweb:     http://git.kernel.org/tip/12ba6c990fab50fe568f3ad8715e81e356552428
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 23 Sep 2013 16:25:03 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 24 Sep 2013 09:02:03 +0200

x86/UV: Add kdump to UV NMI handler

If a system has hung and it no longer responds to external
events, this patch adds the capability of doing a standard kdump
and system reboot then triggered by the system NMI command.

It is enabled when the nmi action is changed to "kdump" and the
kernel is built with CONFIG_KEXEC enabled.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: http://lkml.kernel.org/r/20130923212500.660567460@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/uv_nmi.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 4efcde1..2579fbd 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
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
@@ -143,6 +145,7 @@ module_param_named(retry_count, uv_nmi_retry_count, int, 0644);
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
@@ -517,6 +554,10 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 	/* Indicate we are the first CPU into the NMI handler */
 	master = (atomic_read(&uv_nmi_cpu) == cpu);
 
+	/* If NMI action is "kdump", then attempt to do it */
+	if (uv_nmi_action_is("kdump"))
+		uv_nmi_kdump(cpu, master, regs);
+
 	/* Pause as all cpus enter the NMI handler */
 	uv_nmi_wait(master);
 
