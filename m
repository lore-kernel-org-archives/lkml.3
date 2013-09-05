Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3IEWve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:51:34 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52527 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752862Ab3IEWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:35 -0400
Message-Id: <20130905225033.885420863@asylum.americas.sgi.com>
References: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:38 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] x86/UV: Add call to KGDB/KDB from NMI handler
Content-Disposition: inline; filename=uv-add-nmi-call-kdb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the capability to enter KDB (and KGDB) from the UV NMI
handler.  This is needed because the UV system console is not capable of
sending the 'break' signal to the serial console port.  It is also useful
when the kernel is hung in such a way that it isn't responding to normal
external I/O, so sending 'g' to sysreq-trigger does not work either.

Another benefit of the external NMI command is that all the cpus receive
the NMI signal at roughly the same time so they are more closely aligned
timewise.

It utilizes the newly added kgdb_nmicallin function to gain entry
to KGDB/KDB by the master.  The slaves still enter via the standard
kgdb_nmicallback function.  It also uses the new 'send_ready' pointer
to tell KGDB/KDB to signal the slaves when to proceed into the KGDB
slave loop.

It is enabled when the nmi action is set to "kdb" and the kernel is
built with CONFIG_KDB enabled.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hberrich@sgi.com>
---
 arch/x86/platform/uv/uv_nmi.c |   47 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
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
@@ -146,8 +149,9 @@ module_param_named(retry_count, uv_nmi_r
  *  "dump"	- dump process stack for each cpu
  *  "ips"	- dump IP info for each cpu
  *  "kdump"	- do crash dump
+ *  "kdb"	- enter KDB/KGDB (default)
  */
-static char uv_nmi_action[8] = "dump";
+static char uv_nmi_action[8] = "kdb";
 module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
 
 static inline bool uv_nmi_action_is(const char *action)
@@ -533,6 +537,43 @@ static inline void uv_nmi_kdump(int cpu,
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
+			ret = kgdb_nmicallback(cpu, regs);
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
@@ -565,6 +606,10 @@ int uv_handle_nmi(unsigned int reason, s
 	if (uv_nmi_action_is("ips") || uv_nmi_action_is("dump"))
 		uv_nmi_dump_state(cpu, regs, master);
 
+	/* Call KDB if enabled */
+	else if (uv_nmi_action_is("kdb"))
+		uv_call_kdb(cpu, regs, master);
+
 	/* Clear per_cpu "in nmi" flag */
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
 

-- 
