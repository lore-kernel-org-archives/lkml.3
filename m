Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaEHKtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:49:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaEHKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:47:04 -0400
Date: Thu, 8 May 2014 03:46:27 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-35zzwlvwr7cp8xj196y10yyx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        cmetcalf@tilera.com, luto@amacapital.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        cmetcalf@tilera.com, luto@amacapital.net, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle, tile:
  Switch from TS_POLLING to TIF_POLLING_NRFLAG
Git-Commit-ID: b3a8cb18ce284b5c47517b681c42fcb9d8a99992
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3a8cb18ce284b5c47517b681c42fcb9d8a99992
Gitweb:     http://git.kernel.org/tip/b3a8cb18ce284b5c47517b681c42fcb9d8a99992
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 11 Apr 2014 09:59:13 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 09:16:54 +0200

sched/idle, tile: Switch from TS_POLLING to TIF_POLLING_NRFLAG

Standardize the idle polling indicator to TIF_POLLING_NRFLAG such that
both TIF_NEED_RESCHED and TIF_POLLING_NRFLAG are in the same word.
This will allow us, using fetch_or(), to both set NEED_RESCHED and
check for POLLING_NRFLAG in a single operation and avoid pointless
wakeups.

Changing from the non-atomic thread_info::status flags to the atomic
thread_info::flags shouldn't be a big issue since most polling state
changes were followed/preceded by a full memory barrier anyway.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-35zzwlvwr7cp8xj196y10yyx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/tile/include/asm/thread_info.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 729aa10..d767ff9 100644
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
