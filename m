Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaANQ0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:26:05 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42778 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751503AbaANQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:25:53 -0500
Message-Id: <20140114162551.318251993@asylum.americas.sgi.com>
References: <20140114162551.093907830@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Jan 2014 10:25:52 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KGDB/KDB: Fix no KDB config problem v2.
Content-Disposition: inline; filename=fix-no-kdb-error.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code added to the debug_core module had KDB dependencies that it
shouldn't have.  Move the KDB dependent REASON back to the caller to
remove the dependency in the debug core code.

Update the call from the UV NMI handler to conform to the new interface.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
---
v2: fix checkpatch error: KDB_REASON_SYSTEM_NMI below had a preceding space.
---
 arch/x86/platform/uv/uv_nmi.c |    2 +-
 include/linux/kgdb.h          |    3 ++-
 kernel/debug/debug_core.c     |    5 +++--
 kernel/debug/debug_core.h     |    2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -546,7 +546,7 @@ static void uv_call_kdb(int cpu, struct
 	if (master) {
 		/* call KGDB NMI handler as MASTER */
 		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs,
-					&uv_nmi_slave_continue);
+			KDB_REASON_SYSTEM_NMI, &uv_nmi_slave_continue);
 		if (ret) {
 			pr_alert("KDB returned error, is kgdboc set?\n");
 			atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
--- linux.orig/include/linux/kgdb.h
+++ linux/include/linux/kgdb.h
@@ -310,7 +310,8 @@ extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
 		      struct pt_regs *regs);
 extern int kgdb_nmicallback(int cpu, void *regs);
-extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
+extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, int err_code,
+			  atomic_t *snd_rdy);
 extern void gdbstub_exit(int status);
 
 extern int			kgdb_single_step;
--- linux.orig/kernel/debug/debug_core.c
+++ linux/kernel/debug/debug_core.c
@@ -736,7 +736,8 @@ int kgdb_nmicallback(int cpu, void *regs
 	return 1;
 }
 
-int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
+int kgdb_nmicallin(int cpu, int trapnr, void *regs, int err_code,
+							atomic_t *send_ready)
 {
 #ifdef CONFIG_SMP
 	if (!kgdb_io_ready(0) || !send_ready)
@@ -750,7 +751,7 @@ int kgdb_nmicallin(int cpu, int trapnr,
 		ks->cpu			= cpu;
 		ks->ex_vector		= trapnr;
 		ks->signo		= SIGTRAP;
-		ks->err_code		= KGDB_KDB_REASON_SYSTEM_NMI;
+		ks->err_code		= err_code;
 		ks->linux_regs		= regs;
 		ks->send_ready		= send_ready;
 		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
--- linux.orig/kernel/debug/debug_core.h
+++ linux/kernel/debug/debug_core.h
@@ -75,13 +75,11 @@ extern int kdb_stub(struct kgdb_state *k
 extern int kdb_parse(const char *cmdstr);
 extern int kdb_common_init_state(struct kgdb_state *ks);
 extern int kdb_common_deinit_state(void);
-#define KGDB_KDB_REASON_SYSTEM_NMI KDB_REASON_SYSTEM_NMI
 #else /* ! CONFIG_KGDB_KDB */
 static inline int kdb_stub(struct kgdb_state *ks)
 {
 	return DBG_PASS_EVENT;
 }
-#define KGDB_KDB_REASON_SYSTEM_NMI 0
 #endif /* CONFIG_KGDB_KDB */
 
 #endif /* _DEBUG_CORE_H_ */

-- 
