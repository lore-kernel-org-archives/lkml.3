Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062Ab3GKOjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:39:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932951Ab3GKO0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John Stultz <john.stultz@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 65/98] tick: Prevent uncontrolled switch to oneshot mode
Date: Thu, 11 Jul 2013 15:24:35 +0100
Message-Id: <1373552708-15235-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 1f73a9806bdd07a5106409bbcab3884078bd34fe upstream.

When the system switches from periodic to oneshot mode, the broadcast
logic causes a possibility that a CPU which has not yet switched to
oneshot mode puts its own clock event device into oneshot mode without
updating the state and the timer handler.

CPU0				CPU1
				per cpu tickdev is in periodic mode
				and switched to broadcast

Switch to oneshot mode
 tick_broadcast_switch_to_oneshot()
  cpumask_copy(tick_oneshot_broacast_mask,
	       tick_broadcast_mask);

  broadcast device mode = oneshot

				Timer interrupt

				irq_enter()
				 tick_check_oneshot_broadcast()
				  dev->set_mode(ONESHOT);

				tick_handle_periodic()
				 if (dev->mode == ONESHOT)
				   dev->next_event += period;
				   FAIL.

We fail, because dev->next_event contains KTIME_MAX, if the device was
in periodic mode before the uncontrolled switch to oneshot happened.

We must copy the broadcast bits over to the oneshot mask, because
otherwise a CPU which relies on the broadcast would not been woken up
anymore after the broadcast device switched to oneshot mode.

So we need to verify in tick_check_oneshot_broadcast() whether the CPU
has already switched to oneshot mode. If not, leave the device
untouched and let the CPU switch controlled into oneshot mode.

This is a long standing bug, which was never noticed, because the main
user of the broadcast x86 cannot run into that scenario, AFAICT. The
nonarchitected timer mess of ARM creates a gazillion of differently
broken abominations which trigger the shortcomings of that broadcast
code, which better had never been necessary in the first place.

Reported-and-tested-by: Stehle Vincent-B46079 <B46079@freescale.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>,
Cc: Mark Rutland <mark.rutland@arm.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/tick-broadcast.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 239a323..f8961bf 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -400,7 +400,15 @@ void tick_check_oneshot_broadcast(int cpu)
 	if (cpumask_test_cpu(cpu, to_cpumask(tick_broadcast_oneshot_mask))) {
 		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
 
-		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
+		/*
+		 * We might be in the middle of switching over from
+		 * periodic to oneshot. If the CPU has not yet
+		 * switched over, leave the device alone.
+		 */
+		if (td->mode == TICKDEV_MODE_ONESHOT) {
+			clockevents_set_mode(td->evtdev,
+					     CLOCK_EVT_MODE_ONESHOT);
+		}
 	}
 }
 
-- 
1.8.1.2

