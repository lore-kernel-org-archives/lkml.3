Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaAOWbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:31:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40916 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaAOV5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:06 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 130/166] ARM: fix footbridge clockevent device
Date: Wed, 15 Jan 2014 13:52:24 -0800
Message-Id: <1389822780-4729-131-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 4ff859fe1dc0da0f87bbdfff78f527898878fa4a upstream.

The clockevents code was being told that the footbridge clock event
device ticks at 16x the rate which it actually does.  This leads to
timekeeping problems since it allows the clocksource to wrap before
the kernel notices.  Fix this by using the correct clock.

Fixes: 4e8d76373c9fd ("ARM: footbridge: convert to clockevents/clocksource")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ kamal: backport to 3.8: also applied prereq dc21285-timer.c change from
  838a2ae "ARM: use clockevents_config_and_register() where possible" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-footbridge/dc21285-timer.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-footbridge/dc21285-timer.c b/arch/arm/mach-footbridge/dc21285-timer.c
index 3b54196..edb0ef3 100644
--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -96,17 +96,14 @@ static struct irqaction footbridge_timer_irq = {
 static void __init footbridge_timer_init(void)
 {
 	struct clock_event_device *ce = &ckevt_dc21285;
+	unsigned rate = DIV_ROUND_CLOSEST(mem_fclk_21285, 16);
 
-	clocksource_register_hz(&cksrc_dc21285, (mem_fclk_21285 + 8) / 16);
+	clocksource_register_hz(&cksrc_dc21285, rate);
 
 	setup_irq(ce->irq, &footbridge_timer_irq);
 
-	clockevents_calc_mult_shift(ce, mem_fclk_21285, 5);
-	ce->max_delta_ns = clockevent_delta2ns(0xffffff, ce);
-	ce->min_delta_ns = clockevent_delta2ns(0x000004, ce);
 	ce->cpumask = cpumask_of(smp_processor_id());
-
-	clockevents_register_device(ce);
+	clockevents_config_and_register(ce, rate, 0x4, 0xffffff);
 }
 
 struct sys_timer footbridge_timer = {
-- 
1.8.3.2

