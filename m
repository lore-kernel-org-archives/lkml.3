Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab3FCUeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:34:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45439 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab3FCUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:34:07 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCHv7 01/11] clockevents: Prefer CPU local devices over global devices
Date: Mon,  3 Jun 2013 13:33:52 -0700
Message-Id: <1370291642-13259-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org>
References: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an SMP system with only one global clockevent and a dummy
clockevent per CPU we run into problems. We want the dummy
clockevents to be registered as the per CPU tick devices, but
we can only achieve that if we register the dummy clockevents
before the global clockevent or if we artificially inflate the
rating of the dummy clockevents to be higher than the rating
of the global clockevent. Failure to do so leads to boot
hangs when the dummy timers are registered on all other CPUs
besides the CPU that accepted the global clockevent as its tick
device and there is no broadcast timer to poke the dummy
devices.

If we're registering multiple clockevents and one clockevent is
global and the other is local to a particular CPU we should
choose to use the local clockevent regardless of the rating of
the device. This way, if the clockevent is a dummy it will take
the tick device duty as long as there isn't a higher rated tick
device and any global clockevent will be bumped out into
broadcast mode, fixing the problem described above.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>,
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/tick-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 5d3fb10..3da62de 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -254,9 +254,10 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		    !(newdev->features & CLOCK_EVT_FEAT_ONESHOT))
 			goto out_bc;
 		/*
-		 * Check the rating
+		 * Check the rating, but prefer CPU local devices
 		 */
-		if (curdev->rating >= newdev->rating)
+		if (curdev->rating >= newdev->rating &&
+		    cpumask_equal(curdev->cpumask, newdev->cpumask))
 			goto out_bc;
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

