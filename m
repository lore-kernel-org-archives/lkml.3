Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3IEWv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:51:27 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51623 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753029Ab3IEWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:35 -0400
Message-Id: <20130905225033.730379071@asylum.americas.sgi.com>
References: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:37 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] KGDB/KDB: add support for external NMI handler to call KGDB/KDB.
Content-Disposition: inline; filename=kgdb-add-nmi-callin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a kgdb_nmicallin() interface that can be used by
external NMI handlers to call the KGDB/KDB handler.  The primary need
for this is for those types of NMI interrupts where all the CPUs
have already received the NMI signal.  Therefore no send_IPI(NMI)
is required, and in fact it will cause a 2nd unhandled NMI to occur.
This generates the "Dazed and Confuzed" messages.

Since all the CPUs are getting the NMI at roughly the same time, it's not
guaranteed that the first CPU that hits the NMI handler will manage to
enter KGDB and set the dbg_master_lock before the slaves start entering.
The new argument "send_ready" was added for KGDB to signal the NMI handler
to release the slave CPUs for entry into KGDB.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hberrich@sgi.com>
---
 include/linux/kgdb.h      |    1 +
 kernel/debug/debug_core.c |   41 +++++++++++++++++++++++++++++++++++++++++
 kernel/debug/debug_core.h |    1 +
 3 files changed, 43 insertions(+)

--- linux.orig/include/linux/kgdb.h
+++ linux/include/linux/kgdb.h
@@ -310,6 +310,7 @@ extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
 		      struct pt_regs *regs);
 extern int kgdb_nmicallback(int cpu, void *regs);
+extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
 extern void gdbstub_exit(int status);
 
 extern int			kgdb_single_step;
--- linux.orig/kernel/debug/debug_core.c
+++ linux/kernel/debug/debug_core.c
@@ -578,6 +578,10 @@ return_normal:
 	/* Signal the other CPUs to enter kgdb_wait() */
 	if ((!kgdb_single_step) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
+
+	/* If optional send ready pointer, signal CPUs to proceed */
+	if (kgdb_info[cpu].send_ready)
+		atomic_set(kgdb_info[cpu].send_ready, 1);
 #endif
 
 	/*
@@ -729,6 +733,43 @@ int kgdb_nmicallback(int cpu, void *regs
 		return 0;
 	}
 #endif
+	return 1;
+}
+
+int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
+{
+#ifdef CONFIG_SMP
+	if (!kgdb_io_ready(0))
+		return 1;
+
+	if (kgdb_info[cpu].enter_kgdb == 0) {
+		struct kgdb_state kgdb_var;
+		struct kgdb_state *ks = &kgdb_var;
+		int save_kgdb_do_roundup = kgdb_do_roundup;
+
+		memset(ks, 0, sizeof(struct kgdb_state));
+		ks->cpu			= cpu;
+		ks->ex_vector		= trapnr;
+		ks->signo		= SIGTRAP;
+		ks->err_code		= 0;
+		ks->kgdb_usethreadid	= 0;
+		ks->linux_regs		= regs;
+
+		/* Do not broadcast NMI */
+		kgdb_do_roundup = 0;
+
+		/* Indicate there are slaves waiting */
+		kgdb_info[cpu].send_ready = send_ready;
+		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
+		kgdb_do_roundup = save_kgdb_do_roundup;
+		kgdb_info[cpu].send_ready = NULL;
+
+		/* Wait till all the CPUs have quit from the debugger. */
+		while (atomic_read(&slaves_in_kgdb))
+			cpu_relax();
+		return 0;
+	}
+#endif
 	return 1;
 }
 
--- linux.orig/kernel/debug/debug_core.h
+++ linux/kernel/debug/debug_core.h
@@ -37,6 +37,7 @@ struct kgdb_state {
 struct debuggerinfo_struct {
 	void			*debuggerinfo;
 	struct task_struct	*task;
+	atomic_t		*send_ready;
 	int			exception_state;
 	int			ret_state;
 	int			irq_depth;

-- 
