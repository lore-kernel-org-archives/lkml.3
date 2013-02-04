Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3BDN7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:59:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60985 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab3BDN7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:59:00 -0500
Date: Mon, 4 Feb 2013 05:58:38 -0800
From: tip-bot for anish kumar <anish198519851985@gmail.com>
Message-ID: <tip-c02cf5f8ed6137e2b3b2f10e0fca336e06e09ba4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, anish198519851985@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, anish198519851985@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1359925703-24304-1-git-send-email-fweisbec@gmail.com>
References: <1359925703-24304-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq_work:
  Remove return value from the irq_work_queue() function
Git-Commit-ID: c02cf5f8ed6137e2b3b2f10e0fca336e06e09ba4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:58:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c02cf5f8ed6137e2b3b2f10e0fca336e06e09ba4
Gitweb:     http://git.kernel.org/tip/c02cf5f8ed6137e2b3b2f10e0fca336e06e09ba4
Author:     anish kumar <anish198519851985@gmail.com>
AuthorDate: Sun, 3 Feb 2013 22:08:23 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:50:59 +0100

irq_work: Remove return value from the irq_work_queue() function

As no one is using the return value of irq_work_queue(),
so it is better to just make it void.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
[ Fix stale comments, remove now unnecessary __irq_work_queue() intermediate function ]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1359925703-24304-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/irq_work.h |  2 +-
 kernel/irq_work.c        | 31 ++++++++++---------------------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..ce60c08 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -16,7 +16,7 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *work);
+void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 64eddd5..c9d7478 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -63,12 +63,20 @@ void __weak arch_irq_work_raise(void)
 }
 
 /*
- * Queue the entry and raise the IPI if needed.
+ * Enqueue the irq_work @entry unless it's already pending
+ * somewhere.
+ *
+ * Can be re-enqueued while the callback is still in progress.
  */
-static void __irq_work_queue(struct irq_work *work)
+void irq_work_queue(struct irq_work *work)
 {
 	bool empty;
 
+	/* Only queue if not already pending */
+	if (!irq_work_claim(work))
+		return;
+
+	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
 	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
@@ -78,25 +86,6 @@ static void __irq_work_queue(struct irq_work *work)
 
 	preempt_enable();
 }
-
-/*
- * Enqueue the irq_work @entry, returns true on success, failure when the
- * @entry was already enqueued by someone else.
- *
- * Can be re-enqueued while the callback is still in progress.
- */
-bool irq_work_queue(struct irq_work *work)
-{
-	if (!irq_work_claim(work)) {
-		/*
-		 * Already enqueued, can't do!
-		 */
-		return false;
-	}
-
-	__irq_work_queue(work);
-	return true;
-}
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
 /*
