Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbaDKN5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:57:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948AbaDKNzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:55:53 -0400
Message-Id: <20140411135218.242750053@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 11 Apr 2014 15:42:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, tglx@linutronix.de, luto@amacapital.net,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        peterz@infradead.org, umgwanakikbuti@gmail.com
Cc: linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>
Subject: [RFC][PATCH 2/8] sched,idle,tile: Switch from TS_POLLING to TIF_POLLING_NRFLAG
References: <20140411134243.160989490@infradead.org>
Content-Disposition: inline; filename=peterz-ts_polling-tile.patch
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
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/tile/include/asm/thread_info.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -129,6 +129,7 @@ extern void _cpu_idle(void);
 #define TIF_MEMDIE		7	/* OOM killer at work */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
 #define TIF_SYSCALL_TRACEPOINT	9	/* syscall tracepoint instrumentation */
+#define TIF_POLLING_NRFLAG	10	/* idle is polling for TIF_NEED_RESCHED */
 
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
@@ -140,6 +141,7 @@ extern void _cpu_idle(void);
 #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
+#define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 /* Work to do on any return to user space. */
 #define _TIF_ALLWORK_MASK \
@@ -162,7 +164,6 @@ extern void _cpu_idle(void);
 #ifdef __tilegx__
 #define TS_COMPAT		0x0001	/* 32-bit compatibility mode */
 #endif
-#define TS_POLLING		0x0004	/* in idle loop but not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
 
 #ifndef __ASSEMBLY__


