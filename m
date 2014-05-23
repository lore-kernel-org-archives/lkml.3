Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaEWKwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:52:44 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:41206 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaEWKbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:53 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/71] clocksource: sh_cmt: Set cpumask to cpu_possible_mask
Date: Fri, 23 May 2014 12:30:53 +0200
Message-Id: <1400841111-6683-13-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The CMT is a global timer not restricted to a single CPU. It has a lower
rating than the TMU or ARM architected timer, but is still useful on
systems where the other timers are stopped during CPU sleep.

When multiple timers are available the timers core selects which timer
to use based on timer ratings.

On SMP systems where timer broadcasting is required, one dummy timer is
instantiated per CPU with a rating of 100. On those systems the CMT
timer has a rating of 80, which makes the dummy timer selected by
default on all CPUs. The CMT is then available, and will be used as a
broadcast timer.

On UP systems no dummy timer is instantiated. The CMT timer has a rating
of 125 on those systems and is used directly as a clock event device for
CPU0 without broadcasting.

The CMT rating shouldn't depend on whether we boot a UP or SMP system.
We can't raise the CMT rating to 125 on SMP systems. This would select
CMT as the clock event device for CPU0 as its rating is higher than the
dummy timer rating, and would leave the system without a broadcast
timer. We could instead lower the rating to 80 on all systems, but that
wouldn't reflect reality as ratings between 1 and 99 are documented as
"unfit for real use".

We should raise the rating above 99 and still have the CMT selected as a
broadcast timer. This can be done by changing the cpumask from
cpumask_of(0) to cpu_possible_mask. In that case the timer selection
logic will prefer the previously probed and already selected dummy timer
for all CPUs based on the fact that already selected per-cpu timers are
preferred over new global timers, regardless of their respective
ratings. This also better reflects reality, as the CMT is not tied to
the boot CPU.

Ideally the timer selection logic should realize that the CMT needs to
be used as a broadcast timer on SMP systems as no other broadcast timer
is available, regardless of the cpumask and rating.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index ce00baa..926abe2 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -776,7 +776,7 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
 	ced->rating = rating;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = sh_cmt_clock_event_next;
 	ced->set_mode = sh_cmt_clock_event_mode;
 	ced->suspend = sh_cmt_clock_event_suspend;
-- 
1.7.9.5

