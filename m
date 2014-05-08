Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaEHKrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:47:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaEHKrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:47:01 -0400
Date: Thu, 8 May 2014 03:46:09 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9tfzr196gs0n2afxv0ga8pc3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, zhenglong.cai@cs2c.com.cn,
        peterz@infradead.org, luto@amacapital.net, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        zhenglong.cai@cs2c.com.cn, luto@amacapital.net, mattst88@gmail.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle, alpha:
  Switch from TS_POLLING to TIF_POLLING_NRFLAG
Git-Commit-ID: 2a705ad65c9c393df1a684c780f890a29aab1128
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

Commit-ID:  2a705ad65c9c393df1a684c780f890a29aab1128
Gitweb:     http://git.kernel.org/tip/2a705ad65c9c393df1a684c780f890a29aab1128
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 11 Apr 2014 09:59:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 09:16:53 +0200

sched/idle, alpha: Switch from TS_POLLING to TIF_POLLING_NRFLAG

Standardize the idle polling indicator to TIF_POLLING_NRFLAG such that
both TIF_NEED_RESCHED and TIF_POLLING_NRFLAG are in the same word.
This will allow us, using fetch_or(), to both set NEED_RESCHED and
check for POLLING_NRFLAG in a single operation and avoid pointless
wakeups.

Changing from the non-atomic thread_info::status flags to the atomic
thread_info::flags shouldn't be a big issue since most polling state
changes were followed/preceded by a full memory barrier anyway.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Richard Henderson <rth@twiddle.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: 蔡正龙 <zhenglong.cai@cs2c.com.cn>
Cc: linux-alpha@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-9tfzr196gs0n2afxv0ga8pc3@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/include/asm/thread_info.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 3d6ce6d..48bbea6 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -73,12 +73,14 @@ register struct thread_info *__current_thread_info __asm__("$8");
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
@@ -92,8 +94,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define TS_UAC_NOFIX		0x0002	/* ! flags as they match          */
 #define TS_UAC_SIGBUS		0x0004	/* ! userspace part of 'osf_sysinfo' */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
-#define TS_POLLING		0x0010	/* idle task polling need_resched,
-					   skip sending interrupt */
 
 #ifndef __ASSEMBLY__
 #define HAVE_SET_RESTORE_SIGMASK	1
