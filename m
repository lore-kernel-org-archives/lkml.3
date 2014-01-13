Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaAMQmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:42:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53248 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaAMQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 092/208] ARM: fix footbridge clockevent device
Date: Mon, 13 Jan 2014 15:58:53 +0000
Message-Id: <1389628849-1614-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 4ff859fe1dc0da0f87bbdfff78f527898878fa4a upstream.

The clockevents code was being told that the footbridge clock event
device ticks at 16x the rate which it actually does.  This leads to
timekeeping problems since it allows the clocksource to wrap before
the kernel notices.  Fix this by using the correct clock.

Fixes: 4e8d76373c9fd ("ARM: footbridge: convert to clockevents/clocksource")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-footbridge/dc21285-timer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-footbridge/dc21285-timer.c b/arch/arm/mach-footbridge/dc21285-timer.c
index 9ee78f7..782f6c7 100644
--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -96,11 +96,12 @@ static struct irqaction footbridge_timer_irq = {
 void __init footbridge_timer_init(void)
 {
 	struct clock_event_device *ce = &ckevt_dc21285;
+	unsigned rate = DIV_ROUND_CLOSEST(mem_fclk_21285, 16);
 
-	clocksource_register_hz(&cksrc_dc21285, (mem_fclk_21285 + 8) / 16);
+	clocksource_register_hz(&cksrc_dc21285, rate);
 
 	setup_irq(ce->irq, &footbridge_timer_irq);
 
 	ce->cpumask = cpumask_of(smp_processor_id());
-	clockevents_config_and_register(ce, mem_fclk_21285, 0x4, 0xffffff);
+	clockevents_config_and_register(ce, rate, 0x4, 0xffffff);
 }
-- 
1.8.3.2

