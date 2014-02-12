Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaBLIeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:34:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbaBLIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:57 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Russell King" <rmk+kernel@arm.linux.org.uk>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.115050120@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 60/79] ARM: fix footbridge clockevent device
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 4ff859fe1dc0da0f87bbdfff78f527898878fa4a upstream.

The clockevents code was being told that the footbridge clock event
device ticks at 16x the rate which it actually does.  This leads to
timekeeping problems since it allows the clocksource to wrap before
the kernel notices.  Fix this by using the correct clock.

Fixes: 4e8d76373c9fd ("ARM: footbridge: convert to clockevents/clocksource")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[bwh: Backported to 3.2: fold in the relevant parts of commit 838a2ae80a6a
 ('ARM: use clockevents_config_and_register() where possible')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-footbridge/dc21285-timer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -95,17 +95,14 @@
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

