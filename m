Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020AbaDKNz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:55:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39775 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934289AbaDKNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:54 -0400
Message-Id: <20140411135218.181563050@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>
Subject: [RFC][PATCH 1/8] sched,idle,alpha: Switch from TS_POLLING to TIF_POLLING_NRFLAG
References: <20140411134243.160989490@infradead.org>
Content-Disposition: inline; filename=peterz-ts_polling-alpha.patch
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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/alpha/include/asm/thread_info.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -73,12 +73,14 @@ register struct thread_info *__current_t
 #define TIF_SYSCALL_AUDIT	4	/* syscall audit active */
 #define TIF_DIE_IF_KERNEL	9	/* dik recursion lock */
 #define TIF_MEMDIE		13	/* is terminating due to OOM killer */
+#define TIF_POLLING_NRFLAG	14	/* idle is polling for TIF_NEED_RESCHED */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 /* Work to do on interrupt/exception return.  */
 #define _TIF_WORK_MASK		(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
@@ -92,8 +94,6 @@ register struct thread_info *__current_t
 #define TS_UAC_NOFIX		0x0002	/* ! flags as they match          */
 #define TS_UAC_SIGBUS		0x0004	/* ! userspace part of 'osf_sysinfo' */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
-#define TS_POLLING		0x0010	/* idle task polling need_resched,
-					   skip sending interrupt */
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1


