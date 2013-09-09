Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3IIPau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:30:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31424 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab3IIP0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:26:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=bhxVZlKqwjsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xPLaIx7fqxsA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=9HL7raVLAAAA:8 a=Yj-eAbKCAAAA:8 a=_UZCbbHauV_kxHeOyvkA:9 a=ucBF-G1wxy4A:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909143534.655639785@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 10:35:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH RT 03/16] genirq: Set irq thread to RT priority on creation
References: <20130909143517.641735717@goodmis.org>
Content-Disposition: inline; filename=0003-genirq-Set-irq-thread-to-RT-priority-on-creation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ivo Sieben <meltedpianoman@gmail.com>

When a threaded irq handler is installed the irq thread is initially
created on normal scheduling priority. Only after the irq thread is
woken up it sets its priority to RT_FIFO MAX_USER_RT_PRIO/2 itself.

This means that interrupts that occur directly after the irq handler
is installed will be handled on a normal scheduling priority instead
of the realtime priority that one would expect.

Fix this by setting the RT priority on creation of the irq_thread.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
Cc: Sebastian Andrzej Siewior  <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1370254322-17240-1-git-send-email-meltedpianoman@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/irq/manage.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index d750268..9d702cf 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -780,9 +780,6 @@ static irqreturn_t irq_thread_fn(struct irq_desc *desc,
  */
 static int irq_thread(void *data)
 {
-	static const struct sched_param param = {
-		.sched_priority = MAX_USER_RT_PRIO/2,
-	};
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -795,7 +792,6 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
-	sched_setscheduler(current, SCHED_FIFO, &param);
 	current->irqaction = action;
 
 	while (!irq_wait_for_interrupt(action)) {
@@ -932,11 +928,17 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (new->thread_fn && !nested) {
 		struct task_struct *t;
+		static const struct sched_param param = {
+			.sched_priority = MAX_USER_RT_PRIO/2,
+		};
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
 		if (IS_ERR(t))
 			return PTR_ERR(t);
+
+		sched_setscheduler(t, SCHED_FIFO, &param);
+
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
-- 
1.7.10.4


