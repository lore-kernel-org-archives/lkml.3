Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbaIDB3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 21:29:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11155 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236AbaIDB3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 21:29:49 -0400
From: Leo Yan <leoy@marvell.com>
To: <tglx@linutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Leo Yan <leoy@marvell.com>
Subject: [RFC PATCH v2] clockevents: re-calculate event when cpu enter idle
Date: Thu, 4 Sep 2014 09:25:33 +0800
Message-ID: <1409793933-29938-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-09-04_01:2014-09-03,2014-09-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409040014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below flow will have the redundant interrupts for broadcast timer:

1. Process A starts a hrtimer with 100ms timeout, then Process A will
   wait on the waitqueue to sleep;
2. The CPU which Process A runs on will enter idle and call notify
   CLOCK_EVT_NOTIFY_BROADCAST_ENTER, so the CPU will shutdown its local
   and set broadcast timer's next event with delta for 100ms timeout;
3. After 70ms later, the CPU is waken up by other peripheral's interrupt
   and Process A will be waken up as well; Process A will cancel the hrtimer
   at this point, kernel will remove the timer event from the event queue
   but it will not really disable broadcast timer;
4. So after 30ms later, the broadcast timer interrupt will be triggered
   even though the timer has been cancelled by s/w in step 3.

To fix this issue, in theory cpu can check this situation when the cpu
enter and exit idle; So it can iterate the related idle cpus to calculate
the correct broadcast event value.

But with upper method, it has the side effect. Due the cpu enter and exit
idle state very frequently in short time, so can optimize to only calculate
the correct state only when the cpu join into broadcast timer and set the
next event after calculate a different event compare to previous time.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 kernel/time/tick-broadcast.c | 56 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 8 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 64c5990..52f8879 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -324,6 +324,31 @@ unlock:
 	raw_spin_unlock(&tick_broadcast_lock);
 }
 
+static void tick_broadcast_oneshot_get_earlier_event(void)
+{
+	struct clock_event_device *bc;
+	struct tick_device *td;
+	ktime_t next_event;
+	int cpu, next_cpu = 0;
+
+	next_event.tv64 = KTIME_MAX;
+
+	/* iterate all expired events */
+	for_each_cpu(cpu, tick_broadcast_oneshot_mask) {
+
+		td = &per_cpu(tick_cpu_device, cpu);
+		if (td->evtdev->next_event.tv64 < next_event.tv64) {
+			next_event.tv64 = td->evtdev->next_event.tv64;
+			next_cpu = cpu;
+		}
+	}
+
+	bc = tick_broadcast_device.evtdev;
+	if (next_event.tv64 != KTIME_MAX &&
+	    next_event.tv64 != bc->next_event.tv64)
+		tick_broadcast_set_event(bc, next_cpu, next_event, 0);
+}
+
 /*
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
@@ -717,17 +742,32 @@ int tick_broadcast_oneshot_control(unsigned long reason)
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 			broadcast_shutdown_local(bc, dev);
+
+			/*
+			 * We only reprogram the broadcast timer if we did not
+			 * mark ourself in the force mask; If the current CPU
+			 * is in the force mask, then we are going to be woken
+			 * by the IPI right away.
+			 */
+			if (cpumask_test_cpu(cpu, tick_broadcast_force_mask))
+				goto out;
+
 			/*
-			 * We only reprogram the broadcast timer if we
-			 * did not mark ourself in the force mask and
-			 * if the cpu local event is earlier than the
-			 * broadcast event. If the current CPU is in
-			 * the force mask, then we are going to be
-			 * woken by the IPI right away.
+			 * Reprogram the broadcast timer if the cpu local event
+			 * is earlier than the broadcast event;
 			 */
-			if (!cpumask_test_cpu(cpu, tick_broadcast_force_mask) &&
-			    dev->next_event.tv64 < bc->next_event.tv64)
+			if (dev->next_event.tv64 < bc->next_event.tv64) {
 				tick_broadcast_set_event(bc, cpu, dev->next_event, 1);
+				goto out;
+			}
+
+			/*
+			 * It's possible the cpu has cancelled the timer which
+			 * has set the broadcast event at last time, so
+			 * re-calculate the broadcast timer according to all
+			 * related cpus' expire events.
+			 */
+			tick_broadcast_oneshot_get_earlier_event();
 		}
 		/*
 		 * If the current CPU owns the hrtimer broadcast
-- 
1.9.1

