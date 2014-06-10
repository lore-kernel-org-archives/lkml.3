Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaFJMb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:31:28 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:62028 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaFJMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:31:24 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 2/2] wait: Use the per-task wait_queue_t in ___wait_event macro
Date: Tue, 10 Jun 2014 14:29:19 +0200
Message-Id: <1402403359-6023-3-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
References: <CA+55aFyYQES1CbEfYzRkFas_aw=+YNSbDoLRJpjh2sDFxVV3vg@mail.gmail.com>
 <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ___wait_event macro satisfies the requirements for making use of
the per-task wait_queue_t, so use it. This should make the stack
footprint of all users of the wait_event_* macros smaller.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/wait.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 94279be..5f51252 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -207,17 +207,17 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 #define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
 ({									\
 	__label__ __out;						\
-	wait_queue_t __wait;						\
+	wait_queue_t *__wait = current_wq_get();			\
 	long __ret = ret;	/* explicit shadow */			\
 									\
-	INIT_LIST_HEAD(&__wait.task_list);				\
+	INIT_LIST_HEAD(&__wait->task_list);				\
 	if (exclusive)							\
-		__wait.flags = WQ_FLAG_EXCLUSIVE;			\
+		__wait->flags = WQ_FLAG_EXCLUSIVE;			\
 	else								\
-		__wait.flags = 0;					\
+		__wait->flags = 0;					\
 									\
 	for (;;) {							\
-		long __int = prepare_to_wait_event(&wq, &__wait, state);\
+		long __int = prepare_to_wait_event(&wq, __wait, state);	\
 									\
 		if (condition)						\
 			break;						\
@@ -225,7 +225,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 		if (___wait_is_interruptible(state) && __int) {		\
 			__ret = __int;					\
 			if (exclusive) {				\
-				abort_exclusive_wait(&wq, &__wait,	\
+				abort_exclusive_wait(&wq, __wait,	\
 						     state, NULL);	\
 				goto __out;				\
 			}						\
@@ -234,8 +234,9 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 									\
 		cmd;							\
 	}								\
-	finish_wait(&wq, &__wait);					\
-__out:	__ret;								\
+	finish_wait(&wq, __wait);					\
+__out:	current_wq_put(__wait);						\
+	__ret;								\
 })
 
 #define __wait_event(wq, condition)					\
-- 
1.9.2

