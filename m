Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3H2ODt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:03:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9668 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324Ab3H2OBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:45 -0400
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
Subject: [PATCH 05/14] hrtimer: Fix invalid wakeup in do_nanosleep
Date: Thu, 29 Aug 2013 21:57:40 +0800
Message-ID: <1377784669-28140-6-git-send-email-huawei.libin@huawei.com>
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
 kernel/hrtimer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 383319b..a7845ba 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1539,14 +1539,18 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 {
 	hrtimer_init_sleeper(t, current);
 
+	preempt_disable();
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		hrtimer_start_expires(&t->timer, mode);
 		if (!hrtimer_active(&t->timer))
 			t->task = NULL;
 
-		if (likely(t->task))
+		if (likely(t->task)) {
+			preempt_enable();
 			freezable_schedule();
+			preempt_disable();
+		}
 
 		hrtimer_cancel(&t->timer);
 		mode = HRTIMER_MODE_ABS;
@@ -1554,6 +1558,7 @@ static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mod
 	} while (t->task && !signal_pending(current));
 
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 
 	return t->task == NULL;
 }
-- 
1.8.2.1


