Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3H2OEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:04:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10159 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab3H2OEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:04:40 -0400
From: Libin <huawei.libin@huawei.com>
To: <akpm@linux-foundation.org>, <tj@kernel.org>, <viro@zeniv.linux.org.uk>,
        <eparis@redhat.com>, <tglx@linutronix.de>, <rusty@rustcorp.com.au>,
        <ebiederm@xmission.com>, <paulmck@linux.vnet.ibm.com>,
        <john.stultz@linaro.org>, <mingo@redhat.com>, <peterz@infradead.org>,
        <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <jovi.zhangwei@huawei.com>, <guohanjun@huawei.com>,
        <zhangdianfang@huawei.com>, <wangyijing@huawei.com>,
        <huawei.libin@huawei.com>
Subject: [PATCH 06/14] irq: Fix invalid wakeup in irq_wait_for_interrupt
Date: Thu, 29 Aug 2013 21:57:41 +0800
Message-ID: <1377784669-28140-7-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this thread is preempted at(or before) location a, and the other thread
set the condition(kthread_stop). After that when this thread is re-scheduled,
calling set_current_state to set itself as state TASK_INTERRUPTIBLE, if it is
preempted again after that and before __set_current_state(TASK_RUNNING), it
triggers the invalid wakeup problem.
-----------------------
irq_wait_for_interrupt()
-----------------------
...
//location a
set_current_state(TASK_INTERRUPTIBLE);
//location b
while (!kthread_should_stop()) {

	if (test_and_clear_bit(IRQTF_RUNTHREAD,
					   &action->thread_flags)) {
			__set_current_state(TASK_RUNNING);
			return 0;
	}
	schedule();//location c
	set_current_state(TASK_INTERRUPTIBLE);
	//location d
}
__set_current_state(TASK_RUNNING);
...

The following circumstance will also trigger this issue:
At location c, consumer is scheduled out, and be preempted after calling
set_current_state(TASK_INTERRUPTIBLE) when it be re-schdeuled.

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/irq/manage.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 514bcfd..09cb02f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -655,6 +655,7 @@ static irqreturn_t irq_nested_primary_handler(int irq, void *dev_id)
 
 static int irq_wait_for_interrupt(struct irqaction *action)
 {
+	preempt_disable();
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!kthread_should_stop()) {
@@ -662,12 +663,16 @@ static int irq_wait_for_interrupt(struct irqaction *action)
 		if (test_and_clear_bit(IRQTF_RUNTHREAD,
 				       &action->thread_flags)) {
 			__set_current_state(TASK_RUNNING);
+			preempt_enable();
 			return 0;
 		}
+		preempt_enable();
 		schedule();
+		preempt_disable();
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 	return -1;
 }
 
-- 
1.8.2.1


