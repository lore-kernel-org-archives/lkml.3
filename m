Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3H2OBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:01:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:9727 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3H2OBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:01:53 -0400
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
Subject: [PATCH 03/14] audit: Fix invalid wakeup in wait_for_auditd
Date: Thu, 29 Aug 2013 21:57:38 +0800
Message-ID: <1377784669-28140-4-git-send-email-huawei.libin@huawei.com>
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
state TASK_UNINTERRUPTIBLE, if it is preempted again after that and before
__set_current_state(TASK_RUNNING), it triggers the invalid wakeup problem.
----------------
wait_for_auditd()
----------------
...
//location a
set_current_state(TASK_UNINTERRUPTIBLE);
...

if (audit_backlog_limit &&
			skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
	//location b
	schedule_timeout(sleep_time);
	//location c

__set_current_state(TASK_RUNNING);
//location d
...

To solve this problem, using preempt_disable() to bound the operaion that
setting the task state and the conditions(set by the wake thread) validation.
----------------
wait_for_auditd()
----------------
...
preempt_disable();
set_current_state(TASK_UNINTERRUPTIBLE);
...

if (audit_backlog_limit &&
			skb_queue_len(&audit_skb_queue) > audit_backlog_limit) {
	preempt_enable();
	schedule_timeout(sleep_time);
	preempt_disable();
}

__set_current_state(TASK_RUNNING);
preempt_enable();
...

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/audit.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index a7d1346..48d2f76 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1060,14 +1060,19 @@ static inline void audit_get_stamp(struct audit_context *ctx,
 static void wait_for_auditd(unsigned long sleep_time)
 {
 	DECLARE_WAITQUEUE(wait, current);
+	preempt_disable();
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(&audit_backlog_wait, &wait);
 
 	if (audit_backlog_limit &&
-	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
+	    skb_queue_len(&audit_skb_queue) > audit_backlog_limit) {
+		preempt_enable();
 		schedule_timeout(sleep_time);
+		preempt_disable();
+	}
 
 	__set_current_state(TASK_RUNNING);
+	preempt_enable();
 	remove_wait_queue(&audit_backlog_wait, &wait);
 }
 
-- 
1.8.2.1


