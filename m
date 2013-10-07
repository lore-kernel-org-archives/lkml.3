Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab3JGSiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab3JGSiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:38:09 -0400
Date: Mon, 7 Oct 2013 20:31:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sched/wait: wait_event*_timeout() needs
	___wait_cond_timeout() too
Message-ID: <20131007183106.GA10973@redhat.com>
References: <20131007183043.GA10969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007183043.GA10969@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4c663cfc ("wait: fix false timeouts when using
wait_event_timeout()") introduced the additional condition checks
after a timeout but only in the "slow" __wait*() paths.

wait_event_timeout(wq, CONDITION, 0) still returns 0 if CONDITION
is already true and we do not call __wait*().

Now that we have ___wait_cond_timeout() we can use it instead to
ensure that __ret will be properly updated.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/wait.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index ff9e20f..ec099b0 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -273,7 +273,7 @@ do {									\
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
@@ -331,7 +331,7 @@ do {									\
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
 	__ret;								\
@@ -772,7 +772,7 @@ do {									\
 						  timeout)		\
 ({									\
 	long __ret = timeout;						\
-	if (!(condition))						\
+	if (!___wait_cond_timeout(condition))				\
 		__ret = __wait_event_interruptible_lock_irq_timeout(	\
 					wq, condition, lock, timeout);	\
 	__ret;								\
-- 
1.5.5.1


