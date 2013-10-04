Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3JDRby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:31:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58666 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3JDRbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:31:51 -0400
Date: Fri, 4 Oct 2013 10:31:15 -0700
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-8daaa5f8261bffd2f6217a960f9182d0503a5c44@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, jason.wessel@windriver.com,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com,
        jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, hedi@sgi.com, sivanich@sgi.com,
        tglx@linutronix.de
In-Reply-To: <20131002151417.928886849@asylum.americas.sgi.com>
References: <20131002151417.928886849@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] kdb:
  Add support for external NMI handler to call KGDB/KDB
Git-Commit-ID: 8daaa5f8261bffd2f6217a960f9182d0503a5c44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:31:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8daaa5f8261bffd2f6217a960f9182d0503a5c44
Gitweb:     http://git.kernel.org/tip/8daaa5f8261bffd2f6217a960f9182d0503a5c44
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Wed, 2 Oct 2013 10:14:18 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 3 Oct 2013 18:47:54 +0200

kdb: Add support for external NMI handler to call KGDB/KDB

This patch adds a kgdb_nmicallin() interface that can be used by
external NMI handlers to call the KGDB/KDB handler.  The primary
need for this is for those types of NMI interrupts where all the
CPUs have already received the NMI signal.  Therefore no
send_IPI(NMI) is required, and in fact it will cause a 2nd
unhandled NMI to occur. This generates the "Dazed and Confuzed"
messages.

Since all the CPUs are getting the NMI at roughly the same time,
it's not guaranteed that the first CPU that hits the NMI handler
will manage to enter KGDB and set the dbg_master_lock before the
slaves start entering. The new argument "send_ready" was added
for KGDB to signal the NMI handler to release the slave CPUs for
entry into KGDB.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20131002151417.928886849@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/kdb.h             |  1 +
 include/linux/kgdb.h            |  1 +
 kernel/debug/debug_core.c       | 32 ++++++++++++++++++++++++++++++--
 kernel/debug/debug_core.h       |  3 +++
 kernel/debug/kdb/kdb_debugger.c |  5 ++++-
 kernel/debug/kdb/kdb_main.c     |  3 +++
 6 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 7f6fe6e..290db12 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -109,6 +109,7 @@ typedef enum {
 	KDB_REASON_RECURSE,	/* Recursive entry to kdb;
 				 * regs probably valid */
 	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
+	KDB_REASON_SYSTEM_NMI,	/* In NMI due to SYSTEM cmd; regs valid */
 } kdb_reason_t;
 
 extern int kdb_trap_printk;
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index c6e091b..dfb4f2f 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -310,6 +310,7 @@ extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
 		      struct pt_regs *regs);
 extern int kgdb_nmicallback(int cpu, void *regs);
+extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
 extern void gdbstub_exit(int status);
 
 extern int			kgdb_single_step;
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0506d44..7d2f35e 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -575,8 +575,12 @@ return_normal:
 		raw_spin_lock(&dbg_slave_lock);
 
 #ifdef CONFIG_SMP
+	/* If send_ready set, slaves are already waiting */
+	if (ks->send_ready)
+		atomic_set(ks->send_ready, 1);
+
 	/* Signal the other CPUs to enter kgdb_wait() */
-	if ((!kgdb_single_step) && kgdb_do_roundup)
+	else if ((!kgdb_single_step) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
 #endif
 
@@ -678,11 +682,11 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	if (arch_kgdb_ops.enable_nmi)
 		arch_kgdb_ops.enable_nmi(0);
 
+	memset(ks, 0, sizeof(struct kgdb_state));
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
 	ks->signo		= signo;
 	ks->err_code		= ecode;
-	ks->kgdb_usethreadid	= 0;
 	ks->linux_regs		= regs;
 
 	if (kgdb_reenter_check(ks))
@@ -732,6 +736,30 @@ int kgdb_nmicallback(int cpu, void *regs)
 	return 1;
 }
 
+int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
+{
+#ifdef CONFIG_SMP
+	if (!kgdb_io_ready(0) || !send_ready)
+		return 1;
+
+	if (kgdb_info[cpu].enter_kgdb == 0) {
+		struct kgdb_state kgdb_var;
+		struct kgdb_state *ks = &kgdb_var;
+
+		memset(ks, 0, sizeof(struct kgdb_state));
+		ks->cpu			= cpu;
+		ks->ex_vector		= trapnr;
+		ks->signo		= SIGTRAP;
+		ks->err_code		= KGDB_KDB_REASON_SYSTEM_NMI;
+		ks->linux_regs		= regs;
+		ks->send_ready		= send_ready;
+		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
+		return 0;
+	}
+#endif
+	return 1;
+}
+
 static void kgdb_console_write(struct console *co, const char *s,
    unsigned count)
 {
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index 2235967..572aa4f 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -26,6 +26,7 @@ struct kgdb_state {
 	unsigned long		threadid;
 	long			kgdb_usethreadid;
 	struct pt_regs		*linux_regs;
+	atomic_t		*send_ready;
 };
 
 /* Exception state values */
@@ -74,11 +75,13 @@ extern int kdb_stub(struct kgdb_state *ks);
 extern int kdb_parse(const char *cmdstr);
 extern int kdb_common_init_state(struct kgdb_state *ks);
 extern int kdb_common_deinit_state(void);
+#define KGDB_KDB_REASON_SYSTEM_NMI KDB_REASON_SYSTEM_NMI
 #else /* ! CONFIG_KGDB_KDB */
 static inline int kdb_stub(struct kgdb_state *ks)
 {
 	return DBG_PASS_EVENT;
 }
+#define KGDB_KDB_REASON_SYSTEM_NMI 0
 #endif /* CONFIG_KGDB_KDB */
 
 #endif /* _DEBUG_CORE_H_ */
diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index 328d18e..8859ca3 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -69,7 +69,10 @@ int kdb_stub(struct kgdb_state *ks)
 	if (atomic_read(&kgdb_setting_breakpoint))
 		reason = KDB_REASON_KEYBOARD;
 
-	if (in_nmi())
+	if (ks->err_code == KDB_REASON_SYSTEM_NMI && ks->signo == SIGTRAP)
+		reason = KDB_REASON_SYSTEM_NMI;
+
+	else if (in_nmi())
 		reason = KDB_REASON_NMI;
 
 	for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT; i++, bp++) {
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 00eb8f7..0b097c8 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1200,6 +1200,9 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 			   instruction_pointer(regs));
 		kdb_dumpregs(regs);
 		break;
+	case KDB_REASON_SYSTEM_NMI:
+		kdb_printf("due to System NonMaskable Interrupt\n");
+		break;
 	case KDB_REASON_NMI:
 		kdb_printf("due to NonMaskable Interrupt @ "
 			   kdb_machreg_fmt "\n",
