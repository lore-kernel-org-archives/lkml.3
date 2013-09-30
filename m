Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3I3Rrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:47:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab3I3Rry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:47:54 -0400
Date: Mon, 30 Sep 2013 19:40:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Message-ID: <20130930174054.GA28129@redhat.com>
References: <20130930152242.207382649@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930152242.207382649@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Peter Zijlstra wrote:
>
> Compile and boot tested on x86_64.

Looks fine, but I'll try to actually read this series tomorrow.
Not that I think this needs my review ;)

But at first glance, I think that something like below makes sense
as 7/6.

Once again, of course I do not blame this series, but
wait_event_timeout(wq, true, 0) still returns 0.

Oleg.


--- x/include/linux/wait.h
+++ x/include/linux/wait.h
@@ -184,9 +184,14 @@ wait_queue_head_t *bit_waitqueue(void *,
  	bool __cond = (condition);					\
  	if (__cond && !__ret)						\
  		__ret = 1;						\
- 	__cond || !__ret;						\
+ 	__cond;								\
 })
 
+#define ___wait_schedule_timeout(tout)					\
+	if (!tout)							\
+		break;							\
+	tout = schedule_timeout(tout)
+
 #define ___wait_signal_pending(state)					\
 	((state == TASK_INTERRUPTIBLE && signal_pending(current)) ||	\
 	 (state == TASK_KILLABLE && fatal_signal_pending(current)))
@@ -248,7 +253,7 @@ do {									\
 #define __wait_event_timeout(wq, condition, timeout)			\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
-		      __ret = schedule_timeout(__ret))
+		      ___wait_schedule_timeout(__ret))
 
 /**
  * wait_event_timeout - sleep until a condition gets true or a timeout elapses
@@ -270,7 +275,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition)) 						\
+	if (!___wait_cond_timeout(condition)) 				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
@@ -305,7 +310,7 @@ do {									\
 #define __wait_event_interruptible_timeout(wq, condition, timeout)	\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_INTERRUPTIBLE, 0, timeout,			\
-		      __ret = schedule_timeout(__ret))
+		      ___wait_schedule_timeout(__ret))
 
 /**
  * wait_event_interruptible_timeout - sleep until a condition gets true or a timeout elapses
@@ -328,7 +333,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq, 		\
 						condition, timeout);	\
 	__ret;								\
@@ -739,7 +744,7 @@ do {									\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_INTERRUPTIBLE, 0, ret,	      		\
 		      spin_unlock_irq(&lock);				\
-		      __ret = schedule_timeout(__ret);			\
+		      ___wait_schedule_timeout(__ret);			\
 		      spin_lock_irq(&lock));
 
 /**
@@ -770,7 +775,7 @@ do {									\
 						  timeout)		\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_lock_irq_timeout(	\
 					wq, condition, lock, timeout);	\
 	__ret;								\

