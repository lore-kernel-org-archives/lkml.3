Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3JQQt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 12:49:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3JQQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 12:49:56 -0400
Date: Thu, 17 Oct 2013 09:49:12 -0700
From: tip-bot for Thierry Reding <tipbot@zytor.com>
Message-ID: <tip-4a7d3e8a9939cf8073c247286d81cbe0ae48eba2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, swarren@wwwdotorg.org,
        thierry.reding@gmail.com, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, treding@nvidia.com, sboyd@codeaurora.org,
        john.stultz@linaro.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, thierry.reding@gmail.com,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, treding@nvidia.com, sboyd@codeaurora.org,
        john.stultz@linaro.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1381843911-31962-1-git-send-email-treding@nvidia.com>
References: <1381843911-31962-1-git-send-email-treding@nvidia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: arch_timer:
  Do not register arch_sys_counter twice
Git-Commit-ID: 4a7d3e8a9939cf8073c247286d81cbe0ae48eba2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 09:49:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a7d3e8a9939cf8073c247286d81cbe0ae48eba2
Gitweb:     http://git.kernel.org/tip/4a7d3e8a9939cf8073c247286d81cbe0ae48eba2
Author:     Thierry Reding <thierry.reding@gmail.com>
AuthorDate: Tue, 15 Oct 2013 15:31:51 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Oct 2013 08:30:03 +0200

clocksource: arch_timer: Do not register arch_sys_counter twice

Commit:

   65cd4f6 ("arch_timer: Move to generic sched_clock framework")

added code to register the arch_sys_counter in arch_timer_register(),
but it is already registered in arch_counter_register().

This results in the timer being added to the clocksource list twice,
therefore causing an infinite loop in the list.

Remove the duplicate registration and register the scheduler
clock after the original registration instead.

This fixes a hang during boot on Tegra114 (Cortex-A15).

[ While I've only tested this on Tegra114, I suspect the same hang
  during boot happens for all processors that use this clock source. ]

Signed-off-by: Thierry Reding <treding@nvidia.com>
Acked-by: John Stultz <john.stultz@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: http://lkml.kernel.org/r/1381843911-31962-1-git-send-email-treding@nvidia.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index f655036..95fb944 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -436,6 +436,9 @@ static void __init arch_counter_register(unsigned type)
 	cyclecounter.mult = clocksource_counter.mult;
 	cyclecounter.shift = clocksource_counter.shift;
 	timecounter_init(&timecounter, &cyclecounter, start_count);
+
+	/* 56 bits minimum, so we assume worst case rollover */
+	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
 }
 
 static void arch_timer_stop(struct clock_event_device *clk)
@@ -515,15 +518,6 @@ static int __init arch_timer_register(void)
 		goto out;
 	}
 
-	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
-	cyclecounter.mult = clocksource_counter.mult;
-	cyclecounter.shift = clocksource_counter.shift;
-	timecounter_init(&timecounter, &cyclecounter,
-			 arch_counter_get_cntvct());
-
-	/* 56 bits minimum, so we assume worst case rollover */
-	sched_clock_register(arch_timer_read_counter, 56, arch_timer_rate);
-
 	if (arch_timer_use_virtual) {
 		ppi = arch_timer_ppi[VIRT_PPI];
 		err = request_percpu_irq(ppi, arch_timer_handler_virt,
