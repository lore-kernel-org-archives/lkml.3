Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146Ab3K0BFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:05:35 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43201 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab3K0BFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:05:23 -0500
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
Subject: [PATCH v2 5/9] clocksource/cadence_ttc: Adjust interval in clock notifier
Date: Tue, 26 Nov 2013 17:04:52 -0800
Message-Id: <1385514296-26702-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clockevent has to be reprogrammed if the timer's input
clock frequency changes and the timer is in periodic mode, in order to
maintain the correct timer interval.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
v2:
 - adjust the timer interval while the timer interrupt is disabled
---
 drivers/clocksource/cadence_ttc_timer.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 246d018d1e63..77517675653e 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -322,6 +322,9 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
 	switch (event) {
 	case POST_RATE_CHANGE:
 	{
+		/* update cached frequency */
+		ttc->freq = ndata->new_rate;
+
 		/*
 		 * clockevents_update_freq should be called with IRQ disabled on
 		 * the CPU the timer provides events for. The timer we use is
@@ -329,12 +332,15 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
 		 * cores.
 		 */
 		disable_irq(ttcce->ce.irq);
+
 		clockevents_update_freq(&ttcce->ce,
 				ndata->new_rate / PRESCALE);
-		enable_irq(ttcce->ce.irq);
 
-		/* update cached frequency */
-		ttc->freq = ndata->new_rate;
+		if (ttcce->ce.mode == CLOCK_EVT_MODE_PERIODIC)
+			ttc_set_interval(ttc, DIV_ROUND_CLOSEST(ttc->freq,
+						PRESCALE * HZ));
+
+		enable_irq(ttcce->ce.irq);
 
 		/* fall through */
 	}
-- 
1.8.4.4

