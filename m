Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3H2OCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:02:55 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11576 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3H2OBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:52 -0400
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
Subject: [PATCH 10/14] time: Fix invalid wakeup in alarmtimer_do_nsleep
Date: Thu, 29 Aug 2013 21:57:45 +0800
Message-ID: <1377784669-28140-11-git-send-email-huawei.libin@huawei.com>
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
 kernel/time/alarmtimer.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index eec50fc..624f2ed 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -629,16 +629,21 @@ static enum alarmtimer_restart alarmtimer_nsleep_wakeup(struct alarm *alarm,
 static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
 {
 	alarm->data = (void *)current;
+	preempt_disable();
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 		alarm_start(alarm, absexp);
-		if (likely(alarm->data))
+		if (likely(alarm->data)) {
+			preempt_enable();
 			schedule();
+			preempt_disable();
+		}
 
 		alarm_cancel(alarm);
 	} while (alarm->data && !signal_pending(current));
 
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 
 	return (alarm->data == NULL);
 }
-- 
1.8.2.1


