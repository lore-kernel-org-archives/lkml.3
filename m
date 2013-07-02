Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab3GBMcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:32:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3GBMcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:32:04 -0400
Date: Tue, 2 Jul 2013 05:31:41 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-07bd1172902e782f288e4d44b1fde7dec0f08b6f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        B46079@freescale.com, mark.rutland@arm.com, tglx@linutronix.de,
        sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        B46079@freescale.com, tglx@linutronix.de, mark.rutland@arm.com,
        sboyd@codeaurora.org
In-Reply-To: <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick: Sanitize broadcast control logic
Git-Commit-ID: 07bd1172902e782f288e4d44b1fde7dec0f08b6f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Jul 2013 05:31:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07bd1172902e782f288e4d44b1fde7dec0f08b6f
Gitweb:     http://git.kernel.org/tip/07bd1172902e782f288e4d44b1fde7dec0f08b6f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 1 Jul 2013 22:14:10 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 2 Jul 2013 14:26:45 +0200

tick: Sanitize broadcast control logic

The recent implementation of a generic dummy timer resulted in a
different registration order of per cpu local timers which made the
broadcast control logic go belly up.

If the dummy timer is the first clock event device which is registered
for a CPU, then it is installed, the broadcast timer is initialized
and the CPU is marked as broadcast target.

If a real clock event device is installed after that, we can fail to
take the CPU out of the broadcast mask. In the worst case we end up
with two periodic timer events firing for the same CPU. One from the
per cpu hardware device and one from the broadcast.

Now the problem is that we have no way to distinguish whether the
system is in a state which makes broadcasting necessary or the
broadcast bit was set due to the nonfunctional dummy timer
installment.

To solve this we need to keep track of the system state seperately and
provide a more detailed decision logic whether we keep the CPU in
broadcast mode or not.

The old decision logic only clears the broadcast mode, if the newly
installed clock event device is not affected by power states.

The new logic clears the broadcast mode if one of the following is
true:

  - The new device is not affected by power states.

  - The system is not in a power state affected mode

  - The system has switched to oneshot mode. The oneshot broadcast is
    controlled from the deep idle state. The CPU is not in idle at
    this point, so it's safe to remove it from the mask.

If we clear the broadcast bit for the CPU when a new device is
installed, we also shutdown the broadcast device when this was the
last CPU in the broadcast mask.

If the broadcast bit is kept, then we leave the new device in shutdown
state and rely on the broadcast to deliver the timer interrupts via
the broadcast ipis.

Reported-and-tested-by: Stehle Vincent-B46079 <B46079@freescale.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>,
Cc: Mark Rutland <mark.rutland@arm.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/time/tick-broadcast.c | 70 +++++++++++++++++++++++++++++++++++++-------
 kernel/time/tick-common.c    |  3 +-
 2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 248f80d..4430fa6 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -30,6 +30,7 @@
 
 static struct tick_device tick_broadcast_device;
 static cpumask_var_t tick_broadcast_mask;
+static cpumask_var_t tick_broadcast_on;
 static cpumask_var_t tmpmask;
 static DEFINE_RAW_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
@@ -140,8 +141,9 @@ static void tick_device_setup_broadcast_func(struct clock_event_device *dev)
  */
 int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 {
+	struct clock_event_device *bc = tick_broadcast_device.evtdev;
 	unsigned long flags;
-	int ret = 0;
+	int ret;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
@@ -155,20 +157,59 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		dev->event_handler = tick_handle_periodic;
 		tick_device_setup_broadcast_func(dev);
 		cpumask_set_cpu(cpu, tick_broadcast_mask);
-		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
+		tick_broadcast_start_periodic(bc);
 		ret = 1;
 	} else {
 		/*
-		 * When the new device is not affected by the stop
-		 * feature and the cpu is marked in the broadcast mask
-		 * then clear the broadcast bit.
+		 * Clear the broadcast bit for this cpu if the
+		 * device is not power state affected.
 		 */
-		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP)) {
-			int cpu = smp_processor_id();
+		if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
 			cpumask_clear_cpu(cpu, tick_broadcast_mask);
-			tick_broadcast_clear_oneshot(cpu);
-		} else {
+		else
 			tick_device_setup_broadcast_func(dev);
+
+		/*
+		 * Clear the broadcast bit if the CPU is not in
+		 * periodic broadcast on state.
+		 */
+		if (!cpumask_test_cpu(cpu, tick_broadcast_on))
+			cpumask_clear_cpu(cpu, tick_broadcast_mask);
+
+		switch (tick_broadcast_device.mode) {
+		case TICKDEV_MODE_ONESHOT:
+			/*
+			 * If the system is in oneshot mode we can
+			 * unconditionally clear the oneshot mask bit,
+			 * because the CPU is running and therefore
+			 * not in an idle state which causes the power
+			 * state affected device to stop. Let the
+			 * caller initialize the device.
+			 */
+			tick_broadcast_clear_oneshot(cpu);
+			ret = 0;
+			break;
+
+		case TICKDEV_MODE_PERIODIC:
+			/*
+			 * If the system is in periodic mode, check
+			 * whether the broadcast device can be
+			 * switched off now.
+			 */
+			if (cpumask_empty(tick_broadcast_mask) && bc)
+				clockevents_shutdown(bc);
+			/*
+			 * If we kept the cpu in the broadcast mask,
+			 * tell the caller to leave the per cpu device
+			 * in shutdown state. The periodic interrupt
+			 * is delivered by the broadcast device.
+			 */
+			ret = cpumask_test_cpu(cpu, tick_broadcast_mask);
+			break;
+		default:
+			/* Nothing to do */
+			ret = 0;
+			break;
 		}
 	}
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
@@ -298,6 +339,7 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 	switch (*reason) {
 	case CLOCK_EVT_NOTIFY_BROADCAST_ON:
 	case CLOCK_EVT_NOTIFY_BROADCAST_FORCE:
+		cpumask_set_cpu(cpu, tick_broadcast_on);
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
@@ -307,8 +349,12 @@ static void tick_do_broadcast_on_off(unsigned long *reason)
 			tick_broadcast_force = 1;
 		break;
 	case CLOCK_EVT_NOTIFY_BROADCAST_OFF:
-		if (!tick_broadcast_force &&
-		    cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
+		if (tick_broadcast_force)
+			break;
+		cpumask_clear_cpu(cpu, tick_broadcast_on);
+		if (!tick_device_is_functional(dev))
+			break;
+		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_mask)) {
 			if (tick_broadcast_device.mode ==
 			    TICKDEV_MODE_PERIODIC)
 				tick_setup_periodic(dev, 0);
@@ -366,6 +412,7 @@ void tick_shutdown_broadcast(unsigned int *cpup)
 
 	bc = tick_broadcast_device.evtdev;
 	cpumask_clear_cpu(cpu, tick_broadcast_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_on);
 
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC) {
 		if (bc && cpumask_empty(tick_broadcast_mask))
@@ -821,6 +868,7 @@ bool tick_broadcast_oneshot_available(void)
 void __init tick_broadcast_init(void)
 {
 	zalloc_cpumask_var(&tick_broadcast_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&tick_broadcast_on, GFP_NOWAIT);
 	zalloc_cpumask_var(&tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_TICK_ONESHOT
 	zalloc_cpumask_var(&tick_broadcast_oneshot_mask, GFP_NOWAIT);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index edd45f6..64522ec 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -194,7 +194,8 @@ static void tick_setup_device(struct tick_device *td,
 	 * When global broadcasting is active, check if the current
 	 * device is registered as a placeholder for broadcast mode.
 	 * This allows us to handle this x86 misfeature in a generic
-	 * way.
+	 * way. This function also returns !=0 when we keep the
+	 * current active broadcast state for this CPU.
 	 */
 	if (tick_device_uses_broadcast(newdev, cpu))
 		return;
