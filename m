Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3IKE37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3IKE3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:00 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=496kBHEi9UcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9082a5M3i6MA:10 a=6ohNodAXAAAA:8 a=LpQP-O61AAAA:8 a=KKAkSRfTAAAA:8 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=xGj2gx-jdxhNmRsWumUA:9 a=Zh68SRI7RUMA:10 a=gDjHQkheYgsA:10 a=YDjxKKMXsvQA:10 a=WwgC8nHKvroA:10 a=ESTKKtUg-DoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042854.922539674@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [017/251] tick: Prevent uncontrolled switch to oneshot mode
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0017-tick-Prevent-uncontrolled-switch-to-oneshot-mode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 1f73a9806bdd07a5106409bbcab3884078bd34fe ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/time/tick-broadcast.c |   10 +++++++++-
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
1.7.10.4


