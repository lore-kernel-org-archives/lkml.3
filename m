Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab3JCQik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:38:40 -0400
Received: from relay2.sgi.com ([192.48.179.30]:50300 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752421Ab3JCQij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:38:39 -0400
Message-Id: <20131003163825.184494258@asylum.americas.sgi.com>
References: <20131003163824.966169920@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Oct 2013 11:38:25 -0500
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] PATCH: KGDB/KDB Fix no KDB config problem.
Content-Disposition: inline; filename=fix-non-kdb-config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some code added to the debug_core module had KDB dependencies
that it shouldn't have.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/debug/debug_core.c |    8 ++++----
 kernel/debug/debug_core.h |    2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

--- linux.orig/kernel/debug/debug_core.c
+++ linux/kernel/debug/debug_core.c
@@ -575,8 +575,8 @@ return_normal:
 		raw_spin_lock(&dbg_slave_lock);
 
 #ifdef CONFIG_SMP
-	/* If SYSTEM_NMI, slaves are already waiting */
-	if (ks->err_code == KDB_REASON_SYSTEM_NMI)
+	/* If send_ready set, slaves are already waiting */
+	if (ks->send_ready)
 		atomic_set(ks->send_ready, 1);
 
 	/* Signal the other CPUs to enter kgdb_wait() */
@@ -682,11 +682,11 @@ kgdb_handle_exception(int evector, int s
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
@@ -750,7 +750,7 @@ int kgdb_nmicallin(int cpu, int trapnr,
 		ks->cpu			= cpu;
 		ks->ex_vector		= trapnr;
 		ks->signo		= SIGTRAP;
-		ks->err_code		= KDB_REASON_SYSTEM_NMI;
+		ks->err_code		= KGDB_KDB_REASON_SYSTEM_NMI;
 		ks->linux_regs		= regs;
 		ks->send_ready		= send_ready;
 		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
--- linux.orig/kernel/debug/debug_core.h
+++ linux/kernel/debug/debug_core.h
@@ -75,11 +75,13 @@ extern int kdb_stub(struct kgdb_state *k
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

-- 
