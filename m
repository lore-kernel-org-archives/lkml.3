Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3H2OBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:01:41 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9663 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3H2OBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:39 -0400
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
Subject: [PATCH 02/14] audit: Fix invalid wakeup in kauditd_thread
Date: Thu, 29 Aug 2013 21:57:37 +0800
Message-ID: <1377784669-28140-3-git-send-email-huawei.libin@huawei.com>
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
set the condition followed with wake_up_process. After that
when this thread is re-scheduled, calling set_current_state to set itself as
state TASK_INTERRUPTIBLE, if it is preempted again after that and before
__set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.
----------------
kauditd_thread()
----------------
while (!kthread_should_stop()) {
	...
		//location a
		set_current_state(TASK_INTERRUPTIBLE);
	...

		if (!skb_queue_len(&audit_skb_queue)) {
			//location b
			try_to_freeze();
			schedule();
			//location c
		}

	__set_current_state(TASK_RUNNING);
	//location d
	...
}

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.
----------------
kauditd_thread()
----------------
while (!kthread_should_stop()) {
	...
		preempt_disable();
	set_current_state(TASK_INTERRUPTIBLE);
	...

		if (!skb_queue_len(&audit_skb_queue)) {
			preempt_enable();
			try_to_freeze();
			schedule();
			preempt_disable();
		}

	__set_current_state(TASK_RUNNING);
	preempt_enable();
	...
}

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/audit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 91e53d0..a7d1346 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -455,15 +455,19 @@ static int kauditd_thread(void *dummy)
 				audit_printk_skb(skb);
 			continue;
 		}
+		preempt_disable();
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&kauditd_wait, &wait);
 
 		if (!skb_queue_len(&audit_skb_queue)) {
+			preempt_enable();
 			try_to_freeze();
 			schedule();
+			preempt_disable();
 		}
 
 		__set_current_state(TASK_RUNNING);
+		preempt_enable();
 		remove_wait_queue(&kauditd_wait, &wait);
 	}
 	return 0;
-- 
1.8.2.1


