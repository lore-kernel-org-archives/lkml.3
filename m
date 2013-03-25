Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab3CYSxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:53:39 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55850 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932973Ab3CYSuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:09 -0400
Message-Id: <20130325185008.853779813@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:17 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] KGDB/KDB: add support for external NMI handler to call KGDB/KDB.
Content-Disposition: inline; filename=kgdb-add-nmi-callin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface (kgdb_nmicallin) that can be used by
external NMI handlers to call the KGDB/KDB handler.  The primary need
for this is for those types of NMI interrupts where all the CPUs
have already received the NMI signal.  Therefore no send_IPI(NMI)
is required, and in fact it will cause a 2nd unhandled NMI to occur.

Since all the CPUs are getting the NMI at roughly the same time, it's not
guaranteed that the first CPU that hits the NMI handler will manage to
enter KGDB and set the dbg_master_lock before the slaves start entering.
The new argument "send_ready" is used by KGDB to signal the NMI handler
to release the slave CPUs for entry into KGDB.

Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
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
