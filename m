Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3H2OBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:01:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9672 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3H2OBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:48 -0400
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
Subject: [PATCH 01/14] kthread: Fix invalid wakeup in kthreadd
Date: Thu, 29 Aug 2013 21:57:36 +0800
Message-ID: <1377784669-28140-2-git-send-email-huawei.libin@huawei.com>
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

If kthreadd is preempted at(or before) location a, and the other thread,
such as calling kthread_create_on_node(), adds a list item to
the kthread_create_list followed with wake_up_process(kthread). After that
when kthreadd is re-scheduled, calling set_current_state to set itself as
state TASK_INTERRUPTIBLE, if it is preempted again after that and before
__set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.
------------------------
kthreadd()
------------------------
...
for (;;) {
	//location a
	set_current_state(TASK_INTERRUPTIBLE);
	if (list_empty(&kthread_create_list)) {
		//location b
		schedule();
		//location c
	}
	__set_current_state(TASK_RUNNING);
	//location d
...
------------------------
kthread_create_on_node()
------------------------
...
spin_lock(&kthread_create_lock);
list_add_tail(&create.list, &kthread_create_list);
spin_unlock(&kthread_create_lock);
...
wake_up_process(kthreadd_task);
...

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.
------------------------
kthreadd()
------------------------
...
for (;;) {
	preempt_disable();
	set_current_state(TASK_INTERRUPTIBLE);
	if (list_empty(&kthread_create_list)) {
		preempt_enable();
		schedule();
		preempt_disable();
	}
...

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/kthread.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 760e86d..25c3fed 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -456,10 +456,15 @@ int kthreadd(void *unused)
 	current->flags |= PF_NOFREEZE;
 
 	for (;;) {
+		preempt_disable();
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (list_empty(&kthread_create_list))
+		if (list_empty(&kthread_create_list)) {
+			preempt_enable();
 			schedule();
+			preempt_disable();
+		}
 		__set_current_state(TASK_RUNNING);
+		preempt_enable();
 
 		spin_lock(&kthread_create_lock);
 		while (!list_empty(&kthread_create_list)) {
-- 
1.8.2.1


