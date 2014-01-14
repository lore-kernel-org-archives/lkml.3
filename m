Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaANEYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:24:43 -0500
Received: from relay3.sgi.com ([192.48.152.1]:59701 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752146AbaANEYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:24:10 -0500
Message-Id: <20140114042408.438955013@asylum.americas.sgi.com>
References: <20140114042407.913800664@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 13 Jan 2014 22:24:10 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] PATCH: UV/NMI/KGDB/KDB Fix UV NMI handler when KDB not configed.
Content-Disposition: inline; filename=uv-fix-use-kgdb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix UV call into kgdb to depend only on whether KGDB is defined and not
both KGDB and KDB.  This allows the power nmi command to use the gdb
remote connection if enabled.  Note new action of 'kgdb' needs to be set
as well to indicate user wants to wait for gdb to be connected.  If it's
set to 'kdb' then an error message is displayed if KDB is not configured.

Note that if both KGDB and KDB are enabled, then the action of 'kgdb' or
'kdb' has no affect on which is used.  See the KGDB documention for further
information.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
---
 arch/x86/platform/uv/uv_nmi.c |   56 +++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 14 deletions(-)

--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -148,7 +148,8 @@ module_param_named(retry_count, uv_nmi_r
  *  "dump"	- dump process stack for each cpu
  *  "ips"	- dump IP info for each cpu
  *  "kdump"	- do crash dump
- *  "kdb"	- enter KDB/KGDB (default)
+ *  "kdb"	- enter KDB (default)
+ *  "kgdb"	- enter KGDB
  */
 static char uv_nmi_action[8] = "kdb";
 module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
@@ -537,18 +538,45 @@ static inline void uv_nmi_kdump(int cpu,
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
-  				KDB_REASON_SYSTEM_NMI, &uv_nmi_slave_continue);
+		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs, reason,
+				&uv_nmi_slave_continue);
 		if (ret) {
-			pr_alert("KDB returned error, is kgdboc set?\n");
+			pr_alert("KGDB returned error, is kgdboc set?\n");
 			atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
 		}
 	} else {
@@ -567,12 +595,12 @@ static void uv_call_kdb(int cpu, struct
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
@@ -606,9 +634,9 @@ int uv_handle_nmi(unsigned int reason, s
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

-- 
