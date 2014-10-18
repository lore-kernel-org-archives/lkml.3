Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaJRA2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:28:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:50668 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaJRA2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:28:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-rt-users@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 6/7] simplewait: don't run a possibly infinite number of wake under raw lock
Date: Fri, 17 Oct 2014 20:23:01 -0400
Message-ID: <1413591782-23453-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The simple wait queues use a raw lock in order to be functional
for the preempt-rt kernels.  PeterZ suggested[1] the following
change to ensure we come up for air now and again in order to be
deterministic.

I'm not really in love with the solution of passing the flags around,
but couldn't think of anything cleaner to achieve the same thing.

[1] http://marc.info/?l=linux-kernel&m=138089860308430

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 2a57e00250f9..46e2591c22b6 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -262,7 +262,7 @@ void __swake_up(struct swait_head *q, unsigned int mode, int nr);
 void __cwake_up_locked_key(struct cwait_head *q, unsigned int mode, void *key);
 void __cwake_up_sync_key(struct cwait_head *q, unsigned int mode, int nr, void *key);
 void __cwake_up_locked(struct cwait_head *q, unsigned int mode, int nr);
-void __swake_up_locked(struct swait_head *q, unsigned int mode, int nr);
+void __swake_up_locked(struct swait_head *q, unsigned int mode, int nr, unsigned long *flags);
 void __cwake_up_sync(struct cwait_head *q, unsigned int mode, int nr);
 void __cwake_up_bit(struct cwait_head *, void *, int);
 int __cwait_on_bit(struct cwait_head *, struct cwait_bit *, cwait_bit_action_f *, unsigned);
diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index 7a165c697956..87ef42158fdf 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -32,7 +32,7 @@ void complete(struct completion *x)
 
 	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__swake_up_locked(&x->wait, TASK_NORMAL, 1);
+	__swake_up_locked(&x->wait, TASK_NORMAL, 1, &flags);
 	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
@@ -52,7 +52,7 @@ void complete_all(struct completion *x)
 
 	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__swake_up_locked(&x->wait, TASK_NORMAL, 0);
+	__swake_up_locked(&x->wait, TASK_NORMAL, 0, &flags);
 	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 634427c25945..25e5886ed8d9 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -123,8 +123,12 @@ static void __cwake_up_common(struct cwait_head *q, unsigned int mode,
 	}
 }
 
+/*
+ * The swait version gets the extra flags arg so that we can mitigate
+ * against a possibly large number of wakeups done under a raw lock.
+ */
 static void __swake_up_common(struct swait_head *q, unsigned int mode,
-			      int nr_exclusive)
+			      int nr_exclusive, unsigned long *flags)
 {
 	struct swait *curr, *next;
 	int woken = 0;
@@ -146,6 +150,10 @@ static void __swake_up_common(struct swait_head *q, unsigned int mode,
 				break;
 		}
 
+		if (need_resched()) {
+			raw_spin_unlock_irqrestore(&q->lock, *flags);
+			raw_spin_lock_irqsave(&q->lock, *flags);
+		}
 	}
 }
 
@@ -178,7 +186,7 @@ void __swake_up(struct swait_head *q, unsigned int mode, int nr_exclusive)
 		return;
 
 	raw_spin_lock_irqsave(&q->lock, flags);
-	__swake_up_common(q, mode, nr_exclusive);
+	__swake_up_common(q, mode, nr_exclusive, &flags);
 	raw_spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(__swake_up);
@@ -192,12 +200,13 @@ void __cwake_up_locked(struct cwait_head *q, unsigned int mode, int nr)
 }
 EXPORT_SYMBOL_GPL(__cwake_up_locked);
 
-void __swake_up_locked(struct swait_head *q, unsigned int state, int nr)
+void __swake_up_locked(struct swait_head *q, unsigned int state, int nr,
+		       unsigned long *flags)
 {
 	if (!swait_active(q))
 		return;
 
-	__swake_up_common(q, state, nr);
+	__swake_up_common(q, state, nr, flags);
 }
 EXPORT_SYMBOL_GPL(__swake_up_locked);
 
-- 
1.9.2

