Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbaDKNzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:55:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39751 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDKNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:50 -0400
Message-Id: <20140411135218.358900564@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 4/8] sched,idle,x86: Switch from TS_POLLING to TIF_POLLING_NRFLAG
References: <20140411134243.160989490@infradead.org>
Content-Disposition: inline; filename=peterz-ts_polling-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize the idle polling indicator to TIF_POLLING_NRFLAG such that
both TIF_NEED_RESCHED and TIF_POLLING_NRFLAG are in the same word.
This will allow us, using fetch_or(), to both set NEED_RESCHED and
check for POLLING_NRFLAG in a single operation and avoid pointless
wakeups.

Changing from the non-atomic thread_info::status flags to the atomic
thread_info::flags shouldn't be a big issue since most polling state
changes were followed/preceded by a full memory barrier anyway.

Also, fix up the apm_32 idle function, clearly that was forgotten in
the last conversion. The default idle state is !POLLING so just kill
the lot.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/thread_info.h |    4 ++--
 arch/x86/kernel/apm_32.c           |   11 -----------
 2 files changed, 2 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -83,6 +83,7 @@ struct thread_info {
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_NOHZ		19	/* in adaptive nohz mode */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
+#define TIF_POLLING_NRFLAG	21	/* idle is polling for TIF_NEED_RESCHED */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
@@ -106,6 +107,7 @@ struct thread_info {
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
 #define _TIF_NOHZ		(1 << TIF_NOHZ)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		(1 << TIF_BLOCKSTEP)
@@ -191,8 +193,6 @@ static inline struct thread_info *curren
  * have to worry about atomic accesses.
  */
 #define TS_COMPAT		0x0002	/* 32bit syscall active (64BIT)*/
-#define TS_POLLING		0x0004	/* idle task polling need_resched,
-					   skip sending interrupt */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
 
 #ifndef __ASSEMBLY__
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -844,21 +844,10 @@ static int apm_do_idle(void)
 	int polling;
 	int err = 0;
 
-	polling = !!(current_thread_info()->status & TS_POLLING);
-	if (polling) {
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
-	}
 	if (!need_resched()) {
 		idled = 1;
 		ret = apm_bios_call_simple(APM_FUNC_IDLE, 0, 0, &eax, &err);
 	}
-	if (polling)
-		current_thread_info()->status |= TS_POLLING;
 
 	if (!idled)
 		return 0;


