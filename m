Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab3FLUtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:49:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41497 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3FLUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:49:18 -0400
Date: Wed, 12 Jun 2013 13:48:23 -0700
From: tip-bot for Ivo Sieben <tipbot@zytor.com>
Message-ID: <tip-ee23871389d51e07380d23887333622fbe7d3dd9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, bigeasy@linutronix.de, tglx@linutronix.de,
        meltedpianoman@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, bigeasy@linutronix.de,
        meltedpianoman@gmail.com
In-Reply-To: <1370254322-17240-1-git-send-email-meltedpianoman@gmail.com>
References: <1370254322-17240-1-git-send-email-meltedpianoman@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Set irq thread to RT priority on creation
Git-Commit-ID: ee23871389d51e07380d23887333622fbe7d3dd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Jun 2013 13:48:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee23871389d51e07380d23887333622fbe7d3dd9
Gitweb:     http://git.kernel.org/tip/ee23871389d51e07380d23887333622fbe7d3dd9
Author:     Ivo Sieben <meltedpianoman@gmail.com>
AuthorDate: Mon, 3 Jun 2013 12:12:02 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 11 Jun 2013 16:18:50 +0200

genirq: Set irq thread to RT priority on creation

When a threaded irq handler is installed the irq thread is initially
created on normal scheduling priority. Only after the irq thread is
woken up it sets its priority to RT_FIFO MAX_USER_RT_PRIO/2 itself.

This means that interrupts that occur directly after the irq handler
is installed will be handled on a normal scheduling priority instead
of the realtime priority that one would expect.

Fix this by setting the RT priority on creation of the irq_thread.

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Sebastian Andrzej Siewior  <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370254322-17240-1-git-send-email-meltedpianoman@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..e16caa8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -840,9 +840,6 @@ static void irq_thread_dtor(struct callback_head *unused)
 static int irq_thread(void *data)
 {
 	struct callback_head on_exit_work;
-	static const struct sched_param param = {
-		.sched_priority = MAX_USER_RT_PRIO/2,
-	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -854,8 +851,6 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
-
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, false);
 
@@ -950,6 +945,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (new->thread_fn && !nested) {
 		struct task_struct *t;
+		static const struct sched_param param = {
+			.sched_priority = MAX_USER_RT_PRIO/2,
+		};
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
@@ -957,6 +955,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			ret = PTR_ERR(t);
 			goto out_mput;
 		}
+
+		sched_setscheduler(t, SCHED_FIFO, &param);
+
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
