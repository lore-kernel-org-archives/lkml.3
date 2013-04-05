Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162514Ab3DEU5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:57:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37314 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162356Ab3DEU5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:57:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,416,1363158000"; 
   d="scan'208";a="36286248"
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: [PATCHv2] ARM: arch_timer: Silence debug preempt warnings
Date: Fri,  5 Apr 2013 13:57:29 -0700
Message-Id: <1365195449-6755-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hot-plugging with CONFIG_DEBUG_PREEMPT=y on a device with arm
architected timers causes a slew of "using smp_processor_id() in
preemptible" warnings:

  BUG: using smp_processor_id() in preemptible [00000000] code: sh/111
  caller is arch_timer_cpu_notify+0x14/0xc8

This happens because sometimes the cpu notifier,
arch_timer_cpu_notify(), is called in preemptible context and
other times in non-preemptible context but we use this_cpu_ptr()
to retrieve the clockevent in all cases. We're only going to
actually use the pointer in non-preemptible context though, so
push the this_cpu_ptr() access down into the cases to force the
checks to occur only in non-preemptible contexts.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v1:
 * Pushed down this_cpu_ptr and added a comment

 drivers/clocksource/arm_arch_timer.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index d7ad425..a65a710 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -248,14 +248,16 @@ static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
 static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
 					   unsigned long action, void *hcpu)
 {
-	struct clock_event_device *evt = this_cpu_ptr(arch_timer_evt);
-
+	/*
+	 * Grab cpu pointer in each case to avoid spurious
+	 * preemptible warnings
+	 */
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_STARTING:
-		arch_timer_setup(evt);
+		arch_timer_setup(this_cpu_ptr(arch_timer_evt));
 		break;
 	case CPU_DYING:
-		arch_timer_stop(evt);
+		arch_timer_stop(this_cpu_ptr(arch_timer_evt));
 		break;
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

