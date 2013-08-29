Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3H2OCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:02:04 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9740 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3H2OCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:02:01 -0400
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
Subject: [PATCH 07/14] module: Fix invalid wakeup in wait_for_zero_refcount
Date: Thu, 29 Aug 2013 21:57:42 +0800
Message-ID: <1377784669-28140-8-git-send-email-huawei.libin@huawei.com>
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
-----------------------
wait_for_zero_refcount()
-----------------------
...
for (;;) {
	pr_debug("Looking at refcount...\n");
	set_current_state(TASK_UNINTERRUPTIBLE);
	if (module_refcount(mod) == 0)
		break;
	schedule();
}
__set_current_state(TASK_RUNNING);
...

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.
-----------------------
wait_for_zero_refcount()
-----------------------
...
preempt_disable();
for (;;) {
	pr_debug("Looking at refcount...\n");
	set_current_state(TASK_UNINTERRUPTIBLE);
	if (module_refcount(mod) == 0)
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
 kernel/module.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2069158..22064e9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -816,14 +816,18 @@ static void wait_for_zero_refcount(struct module *mod)
 {
 	/* Since we might sleep for some time, release the mutex first */
 	mutex_unlock(&module_mutex);
+	preempt_disable();
 	for (;;) {
 		pr_debug("Looking at refcount...\n");
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (module_refcount(mod) == 0)
 			break;
+		preempt_enable();
 		schedule();
+		preempt_disable();
 	}
-	current->state = TASK_RUNNING;
+	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 	mutex_lock(&module_mutex);
 }
 
-- 
1.8.2.1


