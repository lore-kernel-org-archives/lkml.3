Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3H2OBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:01:46 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9667 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3H2OBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:43 -0400
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
Subject: [PATCH 12/14] trace: Fix invalid wakeup in ring_buffer_consumer_thread
Date: Thu, 29 Aug 2013 21:57:47 +0800
Message-ID: <1377784669-28140-13-git-send-email-huawei.libin@huawei.com>
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
and the other thread set the condition followed with wake_up_process. After
that when this thread is re-scheduled, calling set_current_state to set itself
as state TASK_INTERRUPTIBLE, if it is preempted again after that and before
__set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/trace/ring_buffer_benchmark.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 3c0bc03..4f43a96 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -172,6 +172,9 @@ static enum event_status read_page(int cpu)
 	return EVENT_FOUND;
 }
 
+/*
+ * Called in preemptation disabled environment.
+ */
 static void ring_buffer_consumer(void)
 {
 	/* toggle between reading pages and events */
@@ -204,9 +207,12 @@ static void ring_buffer_consumer(void)
 		if (reader_finish)
 			break;
 
+		preempt_enable();
 		schedule();
 		__set_current_state(TASK_RUNNING);
+		preempt_disable();
 	}
+
 	reader_finish = 0;
 	complete(&read_done);
 }
@@ -373,6 +379,7 @@ static void wait_to_die(void)
 
 static int ring_buffer_consumer_thread(void *arg)
 {
+	preempt_disable();
 	while (!kthread_should_stop() && !kill_test) {
 		complete(&read_start);
 
@@ -382,10 +389,13 @@ static int ring_buffer_consumer_thread(void *arg)
 		if (kthread_should_stop() || kill_test)
 			break;
 
+		preempt_enable();
 		schedule();
 		__set_current_state(TASK_RUNNING);
+		preempt_disable();
 	}
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 
 	if (kill_test)
 		wait_to_die();
-- 
1.8.2.1


