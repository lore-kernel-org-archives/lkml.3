Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3GBMcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:32:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3GBMcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:32:04 -0400
Date: Tue, 2 Jul 2013 05:31:32 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-1f73a9806bdd07a5106409bbcab3884078bd34fe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        B46079@freescale.com, mark.rutland@arm.com, tglx@linutronix.de,
        sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        B46079@freescale.com, tglx@linutronix.de, mark.rutland@arm.com,
        sboyd@codeaurora.org
In-Reply-To: <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1307012153060.4013@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Prevent uncontrolled switch to oneshot mode
Git-Commit-ID: 1f73a9806bdd07a5106409bbcab3884078bd34fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Jul 2013 05:31:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f73a9806bdd07a5106409bbcab3884078bd34fe
Gitweb:     http://git.kernel.org/tip/1f73a9806bdd07a5106409bbcab3884078bd34fe
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 1 Jul 2013 22:14:10 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 2 Jul 2013 14:26:45 +0200

tick: Prevent uncontrolled switch to oneshot mode

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
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 4790037..248f80d 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -492,7 +492,15 @@ void tick_check_oneshot_broadcast(int cpu)
 	if (cpumask_test_cpu(cpu, tick_broadcast_oneshot_mask)) {
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
 
