Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3GFQIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 12:08:13 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:35717 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3GFQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 12:08:11 -0400
From: Marcus Gelderie <redmnic@gmail.com>
To: artem.bityutskiy@linux.intel.com, herbert@gondor.hengli.com.au
Cc: linux-kernel@vger.kernel.org, Marcus Gelderie <redmnic@gmail.com>
Subject: [PATCH] kernel:time fix race condition in alaramtimer.c
Date: Sat,  6 Jul 2013 18:07:50 +0200
Message-Id: <1373126870-17978-1-git-send-email-redmnic@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a race condition whereby the process can be caused to
sleep indefinitely. The problem occurs when the process is preempted
after having set its state to TASK_INTERRUPTIBLE but before starting the
alarm.

Disabling preemption until the alarm has been set solves this problem.

A second problem may occur if the process reaches the alarm_cancel call
while still being in TASK_INTERRUPTIBLE. I do not see how this could
possibly happen (if schedule returns, the state is TASK_RUNNING; if
schedule is never called, the wakeup callback must have woken the
process (data==NULL) thereby setting its state to TASK_RUNNING) but
the code is clearly written under the assumption that it can happen.
In this case, the state must be set to TASK_RUNNING after the alarm
has been canceled for the same reasons as above.

Signed-off-by: Marcus Gelderie <redmnic@gmail.com>
---
 kernel/time/alarmtimer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..81c8b31 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -585,15 +585,19 @@ static int alarmtimer_do_nsleep(struct alarm *alarm, ktime_t absexp)
 {
 	alarm->data = (void *)current;
 	do {
+		preempt_disable();
 		set_current_state(TASK_INTERRUPTIBLE);
 		alarm_start(alarm, absexp);
+		preempt_enable_no_resched();
 		if (likely(alarm->data))
 			schedule();
 
+		preempt_disable();
 		alarm_cancel(alarm);
+		__set_current_state(TASK_RUNNING);
+		preempt_enable_no_resched();
 	} while (alarm->data && !signal_pending(current));
 
-	__set_current_state(TASK_RUNNING);
 
 	return (alarm->data == NULL);
 }
-- 
1.8.1.5

