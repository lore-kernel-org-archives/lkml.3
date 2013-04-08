Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936294Ab3DHV1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:27:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41237 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760498Ab3DHV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:27:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,433,1363158000"; 
   d="scan'208";a="36848511"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv4 01/11] clockevents: Prefer CPU local devices over global devices
Date: Mon,  8 Apr 2013 14:27:23 -0700
Message-Id: <1365456453-16297-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
References: <1365456453-16297-1-git-send-email-sboyd@codeaurora.org>
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
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/tick-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index b1600a6..9ea59b9 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -251,9 +251,10 @@ static int tick_check_new_device(struct clock_event_device *newdev)
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

