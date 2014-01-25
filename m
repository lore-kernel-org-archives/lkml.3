Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaAYOYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:24:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52483 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaAYOYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:24:47 -0500
Date: Sat, 25 Jan 2014 06:24:27 -0800
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-64389998151214c71ba59ac893180744fd880052@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com, rja@sgi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com,
        jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hedi@sgi.com, rja@sgi.com, tglx@linutronix.de
In-Reply-To: <20140114162551.635540667@asylum.americas.sgi.com>
References: <20140114162551.635540667@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] x86/uv/nmi, kgdb/kdb:
  Fix UV NMI handler when KDB not configured
Git-Commit-ID: 64389998151214c71ba59ac893180744fd880052
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:24:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64389998151214c71ba59ac893180744fd880052
Gitweb:     http://git.kernel.org/tip/64389998151214c71ba59ac893180744fd880052
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 14 Jan 2014 10:25:54 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 08:55:11 +0100

x86/uv/nmi, kgdb/kdb: Fix UV NMI handler when KDB not configured

Fix UV call into kgdb to depend only on whether KGDB is defined
and not both KGDB and KDB.  This allows the power nmi command to
use the gdb remote connection if enabled.  Note new action of
'kgdb' needs to be set as well to indicate user wants to wait
for gdb to be connected.  If it's set to 'kdb' then an error
message is displayed if KDB is not configured.

Also note that if both KGDB and KDB are enabled, then the action
of 'kgdb' or 'kdb' has no affect on which is used.  See the KGDB
documentation for further information.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20140114162551.635540667@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/uv_nmi.c | 56 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 3a3c425..be27da6 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -148,7 +148,8 @@ module_param_named(retry_count, uv_nmi_retry_count, int, 0644);
  *  "dump"	- dump process stack for each cpu
  *  "ips"	- dump IP info for each cpu
  *  "kdump"	- do crash dump
- *  "kdb"	- enter KDB/KGDB (default)
+ *  "kdb"	- enter KDB (default)
+ *  "kgdb"	- enter KGDB
  */
 static char uv_nmi_action[8] = "kdb";
 module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
@@ -537,18 +538,45 @@ static inline void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
 }
 #endif /* !CONFIG_KEXEC */
 
+#ifdef CONFIG_KGDB
 #ifdef CONFIG_KGDB_KDB
-/* Call KDB from NMI handler */
-static void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+static inline int uv_nmi_kdb_reason(void)
 {
-	int ret;
+	return KDB_REASON_SYSTEM_NMI;
+}
+#else /* !CONFIG_KGDB_KDB */
+static inline int uv_nmi_kdb_reason(void)
+{
+	/* Insure user is expecting to attach gdb remote */
+	if (uv_nmi_action_is("kgdb"))
+		return 0;
 
+	pr_err("UV: NMI error: KDB is not enabled in this kernel\n");
+	return -1;
+}
+#endif /* CONFIG_KGDB_KDB */
+
+/*
+ * Call KGDB/KDB from NMI handler
+ *
+ * Note that if both KGDB and KDB are configured, then the action of 'kgdb' or
+ * 'kdb' has no affect on which is used.  See the KGDB documention for further
+ * information.
+ */
+static void uv_call_kgdb_kdb(int cpu, struct pt_regs *regs, int master)
+{
 	if (master) {
+		int reason = uv_nmi_kdb_reason();
+		int ret;
+
+		if (reason < 0)
+			return;
+
 		/* call KGDB NMI handler as MASTER */
-		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs,
-			KDB_REASON_SYSTEM_NMI, &uv_nmi_slave_continue);
+		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs, reason,
+				&uv_nmi_slave_continue);
 		if (ret) {
-			pr_alert("KDB returned error, is kgdboc set?\n");
+			pr_alert("KGDB returned error, is kgdboc set?\n");
 			atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
 		}
 	} else {
@@ -567,12 +595,12 @@ static void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
 	uv_nmi_sync_exit(master);
 }
 
-#else /* !CONFIG_KGDB_KDB */
-static inline void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+#else /* !CONFIG_KGDB */
+static inline void uv_call_kgdb_kdb(int cpu, struct pt_regs *regs, int master)
 {
-	pr_err("UV: NMI error: KGDB/KDB is not enabled in this kernel\n");
+	pr_err("UV: NMI error: KGDB is not enabled in this kernel\n");
 }
-#endif /* !CONFIG_KGDB_KDB */
+#endif /* !CONFIG_KGDB */
 
 /*
  * UV NMI handler
@@ -606,9 +634,9 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 	if (uv_nmi_action_is("ips") || uv_nmi_action_is("dump"))
 		uv_nmi_dump_state(cpu, regs, master);
 
-	/* Call KDB if enabled */
-	else if (uv_nmi_action_is("kdb"))
-		uv_call_kdb(cpu, regs, master);
+	/* Call KGDB/KDB if enabled */
+	else if (uv_nmi_action_is("kdb") || uv_nmi_action_is("kgdb"))
+		uv_call_kgdb_kdb(cpu, regs, master);
 
 	/* Clear per_cpu "in nmi" flag */
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
