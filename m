Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3FDXVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:21:00 -0400
Received: from 1wt.eu ([62.212.114.60]:35293 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab3FDWlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:42 -0400
Message-Id: <20130604172130.429372465@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Romain Francoise <romain@orebokech.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 003/184] 2.6.32.y: timekeeping: Fix nohz issue with commit
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 61b76840ddee647c0c223365378c3f394355b7d7

From: John Stultz <john.stultz@linaro.org>

Commit 61b76840ddee647c0c223365378c3f394355b7d7 ("time: Avoid
making adjustments if we haven't accumulated anything")
introduced a regression with nohz.

Basically with kernels between 2.6.20-something to 2.6.32,
we accumulate time in half second chunks, rather then every
timer-tick. This was added because when NOHZ landed, if you
were idle for a few seconds, you had to spin for every tick
we skipped in the accumulation loop, which created some bad
latencies.

However, this required that we create the xtime_cache() which
was still updated each tick, so that filesystem timestamps,
etc continued to see time increment normally.

Of course, the xtime_cache is updated at the bottom of
update_wall_time(). So the early return on
(offset < timekeeper.cycle_interval), added by the problematic
commit causes the xtime_cache to not be updated.

This can cause code using current_kernel_time() (like the mqueue
code) or hrtimer_get_softirq_time(), which uses the non-updated
xtime_cache, to see timers to fire with very coarse half-second
granularity.

Many thanks to Romain for describing the issue clearly,
providing test case to reproduce it and helping with testing
the solution.

This change is for 2.6.32-stable ONLY!

Cc: stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>
Cc: Romain Francoise <romain@orebokech.com>
Reported-by: Romain Francoise <romain@orebokech.com>
Tested-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/time/timekeeping.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 3d35af3..f65a0fb 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -809,7 +809,7 @@ void update_wall_time(void)
 #endif
 	/* Check if there's really nothing to do */
 	if (offset < timekeeper.cycle_interval)
-		return;
+		goto out;
 
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
@@ -881,6 +881,7 @@ void update_wall_time(void)
 	timekeeper.ntp_error +=	timekeeper.xtime_nsec <<
 				timekeeper.ntp_error_shift;
 
+out:
 	nsecs = clocksource_cyc2ns(offset, timekeeper.mult, timekeeper.shift);
 	update_xtime_cache(nsecs);
 
-- 
1.7.12.2.21.g234cd45.dirty



