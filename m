Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3JDRbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:31:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3JDRbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:31:50 -0400
Date: Fri, 4 Oct 2013 10:31:26 -0700
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-e379ea82dd53a5cc8e3ac0b7899a8012006c712c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com, a.p.zijlstra@chello.nl,
        jason.wessel@windriver.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
In-Reply-To: <20131002151418.089692683@asylum.americas.sgi.com>
References: <20131002151418.089692683@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV: Add call to KGDB/KDB from NMI handler
Git-Commit-ID: e379ea82dd53a5cc8e3ac0b7899a8012006c712c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:31:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e379ea82dd53a5cc8e3ac0b7899a8012006c712c
Gitweb:     http://git.kernel.org/tip/e379ea82dd53a5cc8e3ac0b7899a8012006c712c
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Wed, 2 Oct 2013 10:14:19 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 3 Oct 2013 18:48:09 +0200

x86/UV: Add call to KGDB/KDB from NMI handler

This patch restores the capability to enter KDB (and KGDB) from
the UV NMI handler.  This is needed because the UV system
console is not capable of sending the 'break' signal to the
serial console port.  It is also useful when the kernel is hung
in such a way that it isn't responding to normal external I/O,
so sending 'g' to sysreq-trigger does not work either.

Another benefit of the external NMI command is that all the cpus
receive the NMI signal at roughly the same time so they are more
closely aligned timewise.

It utilizes the newly added kgdb_nmicallin function to gain
entry to KGDB/KDB by the master.  The slaves still enter via the
standard kgdb_nmicallback function.  It also uses the new
'send_ready' pointer to tell KGDB/KDB to signal the slaves when
to proceed into the KGDB slave loop.

It is enabled when the nmi action is set to "kdb" and the kernel
is built with CONFIG_KDB enabled.  Note that if kgdb is
connected that interface will be used instead.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: http://lkml.kernel.org/r/20131002151418.089692683@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/uv_nmi.c | 47 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 9126dfb..9b8ac60 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -21,7 +21,9 @@
 
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/kdb.h>
 #include <linux/kexec.h>
+#include <linux/kgdb.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
 #include <linux/sched.h>
@@ -32,6 +34,7 @@
 #include <asm/kdebug.h>
 #include <asm/local64.h>
 #include <asm/nmi.h>
+#include <asm/traps.h>
 #include <asm/uv/uv.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
@@ -153,8 +156,9 @@ module_param_named(retry_count, uv_nmi_retry_count, int, 0644);
  *  "dump"	- dump process stack for each cpu
  *  "ips"	- dump IP info for each cpu
  *  "kdump"	- do crash dump
+ *  "kdb"	- enter KDB/KGDB (default)
  */
-static char uv_nmi_action[8] = "dump";
+static char uv_nmi_action[8] = "kdb";
 module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
 
 static inline bool uv_nmi_action_is(const char *action)
@@ -540,6 +544,43 @@ static inline void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
 }
 #endif /* !CONFIG_KEXEC */
 
+#ifdef CONFIG_KGDB_KDB
+/* Call KDB from NMI handler */
+static void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+{
+	int ret;
+
+	if (master) {
+		/* call KGDB NMI handler as MASTER */
+		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs,
+					&uv_nmi_slave_continue);
+		if (ret) {
+			pr_alert("KDB returned error, is kgdboc set?\n");
+			atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
+		}
+	} else {
+		/* wait for KGDB signal that it's ready for slaves to enter */
+		int sig;
+
+		do {
+			cpu_relax();
+			sig = atomic_read(&uv_nmi_slave_continue);
+		} while (!sig);
+
+		/* call KGDB as slave */
+		if (sig == SLAVE_CONTINUE)
+			kgdb_nmicallback(cpu, regs);
+	}
+	uv_nmi_sync_exit(master);
+}
+
+#else /* !CONFIG_KGDB_KDB */
+static inline void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+{
+	pr_err("UV: NMI error: KGDB/KDB is not enabled in this kernel\n");
+}
+#endif /* !CONFIG_KGDB_KDB */
+
 /*
  * UV NMI handler
  */
@@ -576,6 +617,10 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 	if (uv_nmi_action_is("ips") || uv_nmi_action_is("dump"))
 		uv_nmi_dump_state(cpu, regs, master);
 
+	/* Call KDB if enabled */
+	else if (uv_nmi_action_is("kdb"))
+		uv_call_kdb(cpu, regs, master);
+
 	/* Clear per_cpu "in nmi" flag */
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
 
