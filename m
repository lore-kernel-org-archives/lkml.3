Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3FMSjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:39:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39178 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3FMSjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:39:52 -0400
Date: Thu, 13 Jun 2013 11:39:50 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, soren.brinkmann@xilinx.com
Subject: Re: [PATCHv7 01/11] clockevents: Prefer CPU local devices over
 global devices
Message-ID: <20130613183950.GA32061@codeaurora.org>
References: <1370291642-13259-1-git-send-email-sboyd@codeaurora.org>
 <1370291642-13259-2-git-send-email-sboyd@codeaurora.org>
 <51B0A6E8.20909@linaro.org>
 <20130606180425.GQ599@codeaurora.org>
 <51B10D85.1060507@linaro.org>
 <20130606223848.GR599@codeaurora.org>
 <20130612214435.GE10823@codeaurora.org>
 <51B991EF.70800@linaro.org>
 <alpine.LFD.2.02.1306131331430.22970@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1306131331430.22970@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Thomas Gleixner wrote:
> On Thu, 13 Jun 2013, Daniel Lezcano wrote:
> > I prefer Thomas to have a look at it and ack it. I changed Cc to To for
> > Thomas.
> 
> The patch does not apply on tip timers/core. The code has been
> reworked a month ago. Please work against tip timers/core. That's
> where this stuff ends up.
> 

Ah, I thought your patch series had stalled. Here is a refreshed
patch. Every other patch in this series applies cleanly to tip
timers/core so I don't want to resend them again unless
absolutely necessary.

-----8<-----
Subject: [PATCH v8] clockevents: Prefer CPU local devices over global devices

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
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/tick-common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 5edfb48..edd45f6 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -243,8 +243,13 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 			return false;
 	}
 
-	/* Use the higher rated one */
-	return !curdev || newdev->rating > curdev->rating;
+	/*
+	 * Use the higher rated one, but prefer a CPU local device with a lower
+	 * rating than a non-CPU local device
+	 */
+	return !curdev ||
+		newdev->rating > curdev->rating ||
+	       !cpumask_equal(curdev->cpumask, newdev->cpumask);
 }
 
 /*

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
