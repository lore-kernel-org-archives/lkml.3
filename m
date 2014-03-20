Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbaCTRwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:52:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbaCTRw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:52:29 -0400
Date: Thu, 20 Mar 2014 18:51:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/2] wait: turn "bool exclusive" arg of __wait_event() into
	wflags
Message-ID: <20140320175136.GB7375@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <20140318154724.GA5669@redhat.com> <CA+a=Yy4WPO9FQwqzDygz6AadT6xbOMEa_puwosZ6WFN17uCncw@mail.gmail.com> <20140319164907.GA10113@redhat.com> <20140319165747.GC8557@laptop.programming.kicks-ass.net> <20140319171906.GA11377@redhat.com> <20140320175111.GA7375@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320175111.GA7375@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ___wait_event() to accept __wait.flags as an argument instead
of "exclusive", and change the only caller which uses exclusive == 1.

This allows us to add another WQ_FLAG (see the next patch). And this
is more flexible, we can overload this argument to pass more info.

This should not affect the  generated code, currently this argument is
always __builtin_constant_p().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/wait.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 559044c..e547c6c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -16,6 +16,7 @@ int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *ke
 struct __wait_queue {
 	unsigned int		flags;
 #define WQ_FLAG_EXCLUSIVE	0x01
+#define WQ_FLAG_MASK		WQ_FLAG_EXCLUSIVE
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	task_list;
@@ -191,17 +192,16 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 	(!__builtin_constant_p(state) ||				\
 		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
 
-#define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
+#define ___wait_event(wq, condition, state, wflags, ret, cmd)		\
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
 	long __ret = ret;						\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
-	if (exclusive)							\
-		__wait.flags = WQ_FLAG_EXCLUSIVE;			\
-	else								\
-		__wait.flags = 0;					\
+	BUILD_BUG_ON(__builtin_constant_p(wflags) &&			\
+			((wflags) & ~WQ_FLAG_MASK));			\
+	__wait.flags = wflags;						\
 									\
 	for (;;) {							\
 		long __int = prepare_to_wait_event(&wq, &__wait, state);\
@@ -211,7 +211,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 									\
 		if (___wait_is_interruptible(state) && __int) {		\
 			__ret = __int;					\
-			if (exclusive) {				\
+			if ((wflags) & WQ_FLAG_EXCLUSIVE) {		\
 				abort_exclusive_wait(&wq, &__wait,	\
 						     state, NULL);	\
 				goto __out;				\
@@ -438,8 +438,8 @@ do {									\
 })
 
 #define __wait_event_interruptible_exclusive(wq, condition)		\
-	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, 0,		\
-		      schedule())
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE,		\
+		      WQ_FLAG_EXCLUSIVE, 0, schedule())
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\
-- 
1.5.5.1


