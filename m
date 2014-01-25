Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaAYO2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:28:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52463 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaAYOY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:24:27 -0500
Date: Sat, 25 Jan 2014 06:24:03 -0800
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-fc8b13740b2978b34872650cc8e928392e3758aa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com, rja@sgi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com,
        jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hedi@sgi.com, rja@sgi.com, tglx@linutronix.de
In-Reply-To: <20140114162551.318251993@asylum.americas.sgi.com>
References: <20140114162551.318251993@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] kgdb/kdb: Fix no KDB config problem
Git-Commit-ID: fc8b13740b2978b34872650cc8e928392e3758aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:24:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc8b13740b2978b34872650cc8e928392e3758aa
Gitweb:     http://git.kernel.org/tip/fc8b13740b2978b34872650cc8e928392e3758aa
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 14 Jan 2014 10:25:52 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 08:55:09 +0100

kgdb/kdb: Fix no KDB config problem

Some code added to the debug_core module had KDB dependencies
that it shouldn't have.  Move the KDB dependent REASON back to
the caller to remove the dependency in the debug core code.

Update the call from the UV NMI handler to conform to the new
interface.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20140114162551.318251993@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/uv_nmi.c | 2 +-
 include/linux/kgdb.h          | 3 ++-
 kernel/debug/debug_core.c     | 5 +++--
 kernel/debug/debug_core.h     | 2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 8eeccba..7486c21 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -546,7 +546,7 @@ static void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
 	if (master) {
 		/* call KGDB NMI handler as MASTER */
 		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs,
-					&uv_nmi_slave_continue);
+			KDB_REASON_SYSTEM_NMI, &uv_nmi_slave_continue);
 		if (ret) {
 			pr_alert("KDB returned error, is kgdboc set?\n");
 			atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index dfb4f2f..6b06d37 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -310,7 +310,8 @@ extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
 		      struct pt_regs *regs);
 extern int kgdb_nmicallback(int cpu, void *regs);
-extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
+extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, int err_code,
+			  atomic_t *snd_rdy);
 extern void gdbstub_exit(int status);
 
 extern int			kgdb_single_step;
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 7d2f35e..334b398 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -736,7 +736,8 @@ int kgdb_nmicallback(int cpu, void *regs)
 	return 1;
 }
 
-int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
+int kgdb_nmicallin(int cpu, int trapnr, void *regs, int err_code,
+							atomic_t *send_ready)
 {
 #ifdef CONFIG_SMP
 	if (!kgdb_io_ready(0) || !send_ready)
@@ -750,7 +751,7 @@ int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
 		ks->cpu			= cpu;
 		ks->ex_vector		= trapnr;
 		ks->signo		= SIGTRAP;
-		ks->err_code		= KGDB_KDB_REASON_SYSTEM_NMI;
+		ks->err_code		= err_code;
 		ks->linux_regs		= regs;
 		ks->send_ready		= send_ready;
 		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index 572aa4f..127d9bc 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -75,13 +75,11 @@ extern int kdb_stub(struct kgdb_state *ks);
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
