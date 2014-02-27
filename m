Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaB0L2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:28:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53430 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaB0L2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:28:23 -0500
Date: Thu, 27 Feb 2014 03:27:37 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-f207dbe63c61158c234e2e8929a3725a7f6b2b9b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gregory.clement@free-electrons.com,
        hpa@zytor.com, mingo@kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, gregory.clement@free-electrons.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] Revert "sched/wait: Suppress Sparse '
 variable shadowing' warning"
Git-Commit-ID: f207dbe63c61158c234e2e8929a3725a7f6b2b9b
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

Commit-ID:  f207dbe63c61158c234e2e8929a3725a7f6b2b9b
Gitweb:     http://git.kernel.org/tip/f207dbe63c61158c234e2e8929a3725a7f6b2b9b
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 27 Feb 2014 12:20:31 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Feb 2014 12:20:31 +0100

Revert "sched/wait: Suppress Sparse 'variable shadowing' warning"

This reverts commit 980f88e414418bf65569a3b62b08b07e6fc2f4c6.

This warning is actually useful, don't suppress it.

We actually rely on the shadowing for ___wait_cond_timeout().

We further used the __ret variable in __wait_event_timeout()'s cmd
argument: __ret = schedule_timeout(__ret). That now explicitly uses the
wrong __ret.

Reported-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Requested-by: Andrew Morton <akpm@linux-foundation.org>
Requested-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-Q5blhuqqzwgVwvjf1gszrdol@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index c55ea5c..559044c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -195,7 +195,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
-	long ___ret = ret;						\
+	long __ret = ret;						\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
@@ -210,7 +210,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 			break;						\
 									\
 		if (___wait_is_interruptible(state) && __int) {		\
-			___ret = __int;					\
+			__ret = __int;					\
 			if (exclusive) {				\
 				abort_exclusive_wait(&wq, &__wait,	\
 						     state, NULL);	\
@@ -222,7 +222,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 		cmd;							\
 	}								\
 	finish_wait(&wq, &__wait);					\
-__out:	___ret;								\
+__out:	__ret;								\
 })
 
 #define __wait_event(wq, condition)					\
