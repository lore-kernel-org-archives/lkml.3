Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3H2OC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:02:27 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:20574 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab3H2OCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:02:25 -0400
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
Subject: [PATCH 11/14] trace: Fix invalid wakeup in wait_to_die
Date: Thu, 29 Aug 2013 21:57:46 +0800
Message-ID: <1377784669-28140-12-git-send-email-huawei.libin@huawei.com>
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

If thread is preempted before calling set_current_state(TASK_INTERRUPTIBLE),
and the other thread set the condition(kthread_stop). After that when this
thread is re-scheduled, calling set_current_state to set itself as state
TASK_INTERRUPTIBLE, if it is preempted again after that and before
__set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.
-------------
wait_to_die()
-------------
set_current_state(TASK_INTERRUPTIBLE);
while (!kthread_should_stop()) {
	schedule();
	set_current_state(TASK_INTERRUPTIBLE);
}
__set_current_state(TASK_RUNNING);

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.
-------------
wait_to_die()
-------------
preempt_disable();
set_current_state(TASK_INTERRUPTIBLE);
while (!kthread_should_stop()) {
	preempt_enable();
	schedule();
	preempt_disable();
	set_current_state(TASK_INTERRUPTIBLE);
}
__set_current_state(TASK_RUNNING);
preempt_enable();

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/trace/ring_buffer_benchmark.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index a5457d5..3c0bc03 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -359,12 +359,16 @@ static void ring_buffer_producer(void)
 
 static void wait_to_die(void)
 {
+	preempt_disable();
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
+		preempt_enable();
 		schedule();
+		preempt_disable();
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 }
 
 static int ring_buffer_consumer_thread(void *arg)
-- 
1.8.2.1


