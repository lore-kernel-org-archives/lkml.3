Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaEHKrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:47:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaEHKrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:47:10 -0400
Date: Thu, 8 May 2014 03:46:38 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-6633akuird5hi3si4gbegkm8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tony.luck@intel.com, luto@amacapital.net, fenghua.yu@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tony.luck@intel.com, luto@amacapital.net, fenghua.yu@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle, ia64:
  Switch from TS_POLLING to TIF_POLLING_NRFLAG
Git-Commit-ID: 04075425331f91f7176a34232c21b63af0eafc53
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

Commit-ID:  04075425331f91f7176a34232c21b63af0eafc53
Gitweb:     http://git.kernel.org/tip/04075425331f91f7176a34232c21b63af0eafc53
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 11 Apr 2014 09:59:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 09:16:55 +0200

sched/idle, ia64: Switch from TS_POLLING to TIF_POLLING_NRFLAG

Standardize the idle polling indicator to TIF_POLLING_NRFLAG such that
both TIF_NEED_RESCHED and TIF_POLLING_NRFLAG are in the same word.
This will allow us, using fetch_or(), to both set NEED_RESCHED and
check for POLLING_NRFLAG in a single operation and avoid pointless
wakeups.

Changing from the non-atomic thread_info::status flags to the atomic
thread_info::flags shouldn't be a big issue since most polling state
changes were followed/preceded by a full memory barrier anyway.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: linux-ia64@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-6633akuird5hi3si4gbegkm8@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/ia64/include/asm/thread_info.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index 5957cf6..5b17418 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -107,6 +107,7 @@ struct thread_info {
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
 #define TIF_RESTORE_RSE		21	/* user RBS is newer than kernel RBS */
+#define TIF_POLLING_NRFLAG	22	/* idle is polling for TIF_NEED_RESCHED */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
@@ -118,6 +119,7 @@ struct thread_info {
 #define _TIF_MCA_INIT		(1 << TIF_MCA_INIT)
 #define _TIF_DB_DISABLED	(1 << TIF_DB_DISABLED)
 #define _TIF_RESTORE_RSE	(1 << TIF_RESTORE_RSE)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SYSCALL_AUDIT|\
@@ -125,7 +127,6 @@ struct thread_info {
 /* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
 #define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
 
-#define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 #define TS_RESTORE_SIGMASK	2	/* restore signal mask in do_signal() */
 
 #ifndef __ASSEMBLY__
