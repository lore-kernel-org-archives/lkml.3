Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaBCWe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:34:58 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:61820 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaBCWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:34:56 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 3/7] clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs enabled
Date: Mon,  3 Feb 2014 14:34:33 -0800
Message-Id: <1391466877-28908-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391466877-28908-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1391466877-28908-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer core takes care of serialization and IRQs. Hence the driver is
no longer required to disable interrupts when calling
clockevents_update_freq().

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clocksource/cadence_ttc_timer.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 63f176de0d02..f05b9fdc7425 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -321,25 +321,12 @@ static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
 
 	switch (event) {
 	case POST_RATE_CHANGE:
-	{
-		unsigned long flags;
-
-		/*
-		 * clockevents_update_freq should be called with IRQ disabled on
-		 * the CPU the timer provides events for. The timer we use is
-		 * common to both CPUs, not sure if we need to run on both
-		 * cores.
-		 */
-		local_irq_save(flags);
-		clockevents_update_freq(&ttcce->ce,
-				ndata->new_rate / PRESCALE);
-		local_irq_restore(flags);
-
 		/* update cached frequency */
 		ttc->freq = ndata->new_rate;
 
+		clockevents_update_freq(&ttcce->ce, ndata->new_rate / PRESCALE);
+
 		/* fall through */
-	}
 	case PRE_RATE_CHANGE:
 	case ABORT_RATE_CHANGE:
 	default:
-- 
1.8.5.3

