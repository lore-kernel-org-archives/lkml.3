Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3H2OEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:04:09 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:20515 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3H2OBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:40 -0400
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
Subject: [PATCH 14/14] klist: Fix invalid wakeup in klist_remove
Date: Thu, 29 Aug 2013 21:57:49 +0800
Message-ID: <1377784669-28140-15-git-send-email-huawei.libin@huawei.com>
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

If thread is preempted before calling set_current_state(TASK_UNINTERRUPTIBLE),
and the other thread set the condition followed with wake_up_process. After
that when this thread is re-scheduled, calling set_current_state to set itself
as state TASK_UNINTERRUPTIBLE, if it is preempted again after that and before
__set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.
--------------
klist_remove()
--------------
...
for (;;) {
	set_current_state(TASK_UNINTERRUPTIBLE);
	if (waiter.woken)
		break;
	schedule();
}
__set_current_state(TASK_RUNNING);
...

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.
--------------
klist_remove()
--------------
...
preempt_disable();
for (;;) {
	set_current_state(TASK_UNINTERRUPTIBLE);
	if (waiter.woken)
		break;
	preempt_enable();
	schedule();
	preempt_disable();
}
__set_current_state(TASK_RUNNING);
preempt_enable();
...

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 lib/klist.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/klist.c b/lib/klist.c
index 358a368..e7c7208 100644
--- a/lib/klist.c
+++ b/lib/klist.c
@@ -249,13 +249,17 @@ void klist_remove(struct klist_node *n)
 
 	klist_del(n);
 
+	preempt_disable();
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (waiter.woken)
 			break;
+		preempt_enable();
 		schedule();
+		preempt_disable();
 	}
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 }
 EXPORT_SYMBOL_GPL(klist_remove);
 
-- 
1.8.2.1


