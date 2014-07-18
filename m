Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbaGRXZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:25:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47464 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbaGRXZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:25:00 -0400
Message-ID: <53C9ACCA.3070306@codeaurora.org>
Date: Fri, 18 Jul 2014 16:24:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] sched_clock: Avoid corrupting hrtimer tree during suspend
References: <1405721392-30795-1-git-send-email-sboyd@codeaurora.org> <53C99EC5.2060602@linaro.org> <53C9A1EC.8060905@codeaurora.org> <53C9A2E7.8020307@linaro.org>
In-Reply-To: <53C9A2E7.8020307@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/14 15:42, John Stultz wrote:
> If its a regression (and needs -stable backports) it needs to go in via
> tip/timers/urgent, and not via the regular merge window.
>
> Whats the additional risk -stable wise for canceling the timer during
> suspend and starting it back up during resume?
>

I'd say close to zero given that we'd only be making the timer run a
little bit later and we have slack in there already. Here's that version.

----8<-----

Subject: [PATCH] sched_clock: Avoid corrupting hrtimer tree during suspend

During suspend we call sched_clock_poll() to update the epoch and
accumulated time and reprogram the sched_clock_timer to fire
before the next wrap-around time. Unfortunately,
sched_clock_poll() doesn't restart the timer, instead it relies
on the hrtimer layer to do that and during suspend we aren't
calling that function from the hrtimer layer. Instead, we're
reprogramming the expires time while the hrtimer is enqueued,
which can cause the hrtimer tree to be corrupted. Furthermore, we
restart the timer during suspend but we update the epoch during
resume which seems counter-intuitive.

Let's fix this by saving the accumulated state and canceling the
timer during suspend. On resume we can update the epoch and
restart the timer similar to what we would do if we were starting
the clock for the first time.

Fixes: a08ca5d1089d "sched_clock: Use an hrtimer instead of timer"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 kernel/time/sched_clock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 445106d2c729..01d2d15aa662 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -191,7 +191,8 @@ void __init sched_clock_postinit(void)
 
 static int sched_clock_suspend(void)
 {
-	sched_clock_poll(&sched_clock_timer);
+	update_sched_clock();
+	hrtimer_cancel(&sched_clock_timer);
 	cd.suspended = true;
 	return 0;
 }
@@ -199,6 +200,7 @@ static int sched_clock_suspend(void)
 static void sched_clock_resume(void)
 {
 	cd.epoch_cyc = read_sched_clock();
+	hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
 	cd.suspended = false;
 }
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

