Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbaCTRww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbaCTRwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:52:51 -0400
Date: Thu, 20 Mar 2014 18:51:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peng Tao <bergwolf@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/2] wait: introduce WQ_FLAG_EXCLUSIVE_HEAD
Message-ID: <20140320175158.GC7375@redhat.com>
References: <1395148208-2209-1-git-send-email-bergwolf@gmail.com> <20140318133331.GA23193@laptop.programming.kicks-ass.net> <CA+a=Yy74V9_N4L8DoG=6iLnjGyOb6=ifraAqs5jW7ZsCG0t7jw@mail.gmail.com> <20140318140504.GD23193@laptop.programming.kicks-ass.net> <20140318154724.GA5669@redhat.com> <CA+a=Yy4WPO9FQwqzDygz6AadT6xbOMEa_puwosZ6WFN17uCncw@mail.gmail.com> <20140319164907.GA10113@redhat.com> <20140319165747.GC8557@laptop.programming.kicks-ass.net> <20140319171906.GA11377@redhat.com> <20140320175111.GA7375@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320175111.GA7375@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally wait_queue_t is a FIFO list for exclusive waiting tasks,
but Lustre wants LIFO to wake up the most recent active thread and
avoid the unnecessary cache line pollution.

As Peter suggested we add the new WQ_FLAG_EXCLUSIVE_HEAD flag and
teach prepare_to_wait_event() to insert the new entry right before
the first WQ_FLAG_EXCLUSIVE task.

Note:
	- this obviously assumes that the user of EXCLUSIVE_HEAD
	  doesn't mix exclusive and !exclusive too much, otherwise
	  it should accept the cost of additional list_for_each().

	- WQ_FLAG_EXCLUSIVE_HEAD doesn't imply WQ_FLAG_EXCLUSIVE,
	  it only controls the placement in queue. So the new flag
	  can be used individually even if this is unlikely useful.

Requested-by: Peng Tao <bergwolf@gmail.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/wait.h |    3 ++-
 kernel/sched/wait.c  |   30 ++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index e547c6c..afd41eb 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -16,7 +16,8 @@ int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *ke
 struct __wait_queue {
 	unsigned int		flags;
 #define WQ_FLAG_EXCLUSIVE	0x01
-#define WQ_FLAG_MASK		WQ_FLAG_EXCLUSIVE
+#define WQ_FLAG_EXCLUSIVE_HEAD	0x02
+#define WQ_FLAG_MASK		(WQ_FLAG_EXCLUSIVE | WQ_FLAG_EXCLUSIVE_HEAD)
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	task_list;
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 7d50f79..894ff75 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -195,6 +195,28 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
 
+static void add_wait_queue_flag(wait_queue_head_t *q, wait_queue_t *wait)
+{
+	struct list_head *head = &q->task_list;
+
+	if (wait->flags & (WQ_FLAG_EXCLUSIVE | WQ_FLAG_EXCLUSIVE_HEAD)) {
+		if (wait->flags & WQ_FLAG_EXCLUSIVE_HEAD) {
+			wait_queue_t *curr;
+			/* find the first exclusive entry */
+			list_for_each_entry(curr, head, task_list) {
+				if (likely(curr->flags & WQ_FLAG_EXCLUSIVE)) {
+					head = &curr->task_list;
+					break;
+				}
+			}
+		}
+		/* turn list_add() below into list_add_tail() */
+		head = head->prev;
+	}
+
+	list_add(&wait->task_list, head);
+}
+
 long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
@@ -206,12 +228,8 @@ long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	wait->func = autoremove_wake_function;
 
 	spin_lock_irqsave(&q->lock, flags);
-	if (list_empty(&wait->task_list)) {
-		if (wait->flags & WQ_FLAG_EXCLUSIVE)
-			__add_wait_queue_tail(q, wait);
-		else
-			__add_wait_queue(q, wait);
-	}
+	if (list_empty(&wait->task_list))
+		add_wait_queue_flag(q, wait);
 	set_current_state(state);
 	spin_unlock_irqrestore(&q->lock, flags);
 
-- 
1.5.5.1


