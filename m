Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3H2OBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:01:37 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11540 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3H2OBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:35 -0400
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
Subject: [PATCH 04/14] exit: Fix invalid wakeup in do_wait
Date: Thu, 29 Aug 2013 21:57:39 +0800
Message-ID: <1377784669-28140-5-git-send-email-huawei.libin@huawei.com>
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
 kernel/exit.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index a949819..1ea7736 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1521,7 +1521,6 @@ repeat:
 	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
 		goto notask;
 
-	set_current_state(TASK_INTERRUPTIBLE);
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
@@ -1539,16 +1538,20 @@ repeat:
 	read_unlock(&tasklist_lock);
 
 notask:
+	preempt_disable();
+	set_current_state(TASK_INTERRUPTIBLE);
 	retval = wo->notask_error;
 	if (!retval && !(wo->wo_flags & WNOHANG)) {
 		retval = -ERESTARTSYS;
 		if (!signal_pending(current)) {
+			preempt_enable();
 			schedule();
 			goto repeat;
 		}
 	}
-end:
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
+end:
 	remove_wait_queue(&current->signal->wait_chldexit, &wo->child_wait);
 	return retval;
 }
-- 
1.8.2.1


