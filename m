Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3H2OBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:01:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11574 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3H2OBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:50 -0400
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
Subject: [PATCH 08/14] namespace: Fix invalid wakeup in zap_pid_ns_processes
Date: Thu, 29 Aug 2013 21:57:43 +0800
Message-ID: <1377784669-28140-9-git-send-email-huawei.libin@huawei.com>
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
----------------------
zap_pid_ns_processes()
----------------------
...
for (;;) {
	set_current_state(TASK_UNINTERRUPTIBLE);
	if (pid_ns->nr_hashed == init_pids)
		break;
	schedule();
}
__set_current_state(TASK_RUNNING);
...

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/pid_namespace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 6917e8e..e3696a1 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -227,13 +227,17 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 * sys_wait4() above can't reap the TASK_DEAD children.
 	 * Make sure they all go away, see free_pid().
 	 */
+	preempt_disable();
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (pid_ns->nr_hashed == init_pids)
 			break;
+		preempt_enable();
 		schedule();
+		preempt_disable();
 	}
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 
 	if (pid_ns->reboot)
 		current->signal->group_exit_code = pid_ns->reboot;
-- 
1.8.2.1


