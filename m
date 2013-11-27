Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab3K0BHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:07:01 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:55836 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab3K0BFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:05:21 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 4/9] clocksource/cadence_ttc: Use enable/disable_irq
Date: Tue, 26 Nov 2013 17:04:51 -0800
Message-Id: <1385514296-26702-5-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To ensure that the timer interrupt is properly enabled/disabled across
the whole CPU cluster use enable/disable_irq() instead of
local_irq_disable().

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clocksource/cadence_ttc_timer.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index a92350b55d32..246d018d1e63 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -322,18 +322,16 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
 	switch (event) {
 	case POST_RATE_CHANGE:
 	{
-		unsigned long flags;
-
 		/*
 		 * clockevents_update_freq should be called with IRQ disabled on
 		 * the CPU the timer provides events for. The timer we use is
 		 * common to both CPUs, not sure if we need to run on both
 		 * cores.
 		 */
-		local_irq_save(flags);
+		disable_irq(ttcce->ce.irq);
 		clockevents_update_freq(&ttcce->ce,
 				ndata->new_rate / PRESCALE);
-		local_irq_restore(flags);
+		enable_irq(ttcce->ce.irq);
 
 		/* update cached frequency */
 		ttc->freq = ndata->new_rate;
-- 
1.8.4.4

