Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab3GZPSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:18:13 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49944 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab3GZPSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:18:08 -0400
From: "ethan.kernel" <ethan.kernel@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] hrtimer: Fix a performance regression by disable reprogramming in remove_hrtimer
Date: Fri, 26 Jul 2013 23:18:00 +0800
Message-Id: <5A3BB669-19D7-4B30-B0FE-658E24368D6E@gmail.com>
Cc: johlstei@codeaurora.org, LKML <linux-kernel@vger.kernel.org>,
        yinghai@kernel.org, Jin Feng <joe.jin@oracle.com>,
        ethan.zhao@oracle.com
To: tglx@linutronix.de, mingo@kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 968320b hrtimer: Fix extra wakeups from __remove_hrtimer() introduced a significant scheduler 
performance regression, following is the test:

a. Test environment:
SUN FIRE X4170 M2 SERVER
CPU model name: Intel(R) Xeon(R) CPU X5675  @ 3.07GHz
2 socket X 6 core X 2 thread

b. To eliminate the disturbing of variable frequency technology of Intel CPU. We disabled the C-States, P-States
T-States etc SpeedStep, Turboboost, power management in BIOS configuration.

c. Test case:
1.test tool (Any better tools ?)

 #include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>
#include <linux/unistd.h>

#define LOOPS 1000000

int main (void)
{
	unsigned long long t0, t1;
	int pipe_1[2], pipe_2[2];
	int m = 0, i;

	pipe(pipe_1);
	pipe(pipe_2);

	if (!fork()) {
		for (i = 0; i < LOOPS; i++) {
			read(pipe_1[0], &m, sizeof(int));
			write(pipe_2[1], &m, sizeof(int));
		}
	} else {
		for (i = 0; i < LOOPS; i++) {
			write(pipe_1[1], &m, sizeof(int));
			read(pipe_2[0], &m, sizeof(int));
		}
	}

	return 0;
}
from  http://people.redhat.com/mingo/cfs-scheduler/tools/pipe-test-1m.c

2.after boot the test kernel a few minutes, execute
 $time ./pipe-test-1m
  collect data output by time like:
  real    0m9.326s
  user    0m0.352s
  sys     0m5.640s
3.after the test case finished a few seconds, redo the same one.

d. Test result data
Test kernel without patch 968320b hrtimer: Fix extra wakeups from __remove_hrtimer() /
Or applied this patch to disable reprogramming in remove_hrtimer()
---------------------------------------------------------------------------------------------------------
|      |    1     |     2    |   3      |    4     |    5     | 6    |    7     |    8     |   AVG        |
---------------------------------------------------------------------------------------------------------
| real | 0m5.328s | 0m5.372s | 0m5.307s | 0m5.307s | 0m5.330s | 0m5.315s | 0m5.318s | 0m5.317s | 5.32425s |
---------------------------------------------------------------------------------------------------------
| user | 0m0.106s | 0m0.098s | 0m0.108s | 0m0.120s | 0m0.113s | 0m0.121s | 0m0.125s | 0m0.103s | 0.11175s |
---------------------------------------------------------------------------------------------------------
| sys  | 0m2.287s | 0m2.334s | 0m2.269s | 0m2.269s | 0m2.298s | 0m2.274s | 0m2.263s | 0m2.292s | 2.28575s |
---------------------------------------------------------------------------------------------------------

With patch 968320b hrtimer: Fix extra wakeups from __remove_hrtimer()
Redo the test more than 10 times, select 8 of them, collect the data into following tables.
---------------------------------------------------------------------------------------------------------
|      |    1     |     2    |   3      |    4     |    5     | 6    |    7     |    8     |   AVG       |
---------------------------------------------------------------------------------------------------------
| real | 0m7.132s | 0m6.741s | 0m6.996s | 0m9.269s | 0m6.742s | 0m6.977s | 0m6.802s | 0m6.957s | 7.202s   |
---------------------------------------------------------------------------------------------------------
| user | 0m0.033s | 0m0.031s | 0m0.048s | 0m0.436s | 0m0.022s | 0m0.005s | 0m0.014s | 0m0.014s | 0.075375s|
---------------------------------------------------------------------------------------------------------
| sys  | 0m3.119s | 0m2.940s | 0m3.185s | 0m4.023s | 0m3.053s | 0m3.152s | 0m3.054s | 0m3.124s | 3.20625s |
---------------------------------------------------------------------------------------------------------

e. Conclusion
We found the performance has 1.87775S(average value) down introduced by commit
968320b hrtimer: Fix extra wakeups from __remove_hrtimer().
That is more than -35% !
 
Disable reprogramming in remove_hrtimer() to fix this performance regression:
function remove_hrtimer() with reprogramming the clock device is called in following two cases:

1.	In function hrtimer_try_to_cancel()
    Whatever you reprogram the clock device or not, the timer function wouldn¡¯t be called anymore. So set reprogram 
	to 0 doesn¡¯t change the result of hrtimer_try_to_cancel()

           hrtimer_try_to_cancel() 
           --- > remove_hrtimer() 
               ---- > __remove_hrtimer(timer, base, state, reprogram);

2.	In function  __hrtimer_start_range_ns(), 
    After remove_hrtimer() was called, the rest of code in this function will check the new timer added into queue is 
	the leftmost or not, if needed, will reprogram the clock device.

     __hrtimer_start_range_ns()
    {
      ¡­ ¡­
      ret = remove_hrtimer(timer, base);      
      ¡­ ¡­
      leftmost = enqueue_hrtimer(timer, new_base);
      if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
		&& hrtimer_enqueue_reprogram(timer, new_base)) {
      ¡­ ¡­
    }

Will we lose the chance to reprogram the clock device after remove_hrtimer() ?
I think No, Because we didn¡¯t reprogram the clock device in remove_hrtimer(), if the timer removed is just the next one 
will expire, we still could get reprogrammed in hrtimer_interrupt().     
So reprogramming in remove_hrtimer() is not necessary-----If I am wrong, just point out.
          
Why 
   commit 968320b hrtimer: Fix extra wakeups from __remove_hrtimer() 
Introduced performance regression?
The reprogramming is expensive ?  not cheap so far.
We lost one chance to wakeup? 
Yes, commit 968320b actually will delay the next expiry time to the timer next to the one removed. and it looks rational.
If the extra wakeup is not harmful, We really need it to keep the performance and get the chance to wakeup in time.

Reported-by: lijun.huang@oracle.com <lijun.huang@oracle.com>
Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
---
 kernel/hrtimer.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index fd4b13b..742dc6b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -934,26 +934,16 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
 {
 	if (hrtimer_is_queued(timer)) {
 		unsigned long state;
-		int reprogram;
 
-		/*
-		 * Remove the timer and force reprogramming when high
-		 * resolution mode is active and the timer is on the current
-		 * CPU. If we remove a timer on another CPU, reprogramming is
-		 * skipped. The interrupt event on this CPU is fired and
-		 * reprogramming happens in the interrupt handler. This is a
-		 * rare case and less expensive than a smp call.
-		 */
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
-		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		/*
 		 * We must preserve the CALLBACK state flag here,
 		 * otherwise we could move the timer base in
 		 * switch_hrtimer_base.
 		 */
 		state = timer->state & HRTIMER_STATE_CALLBACK;
-		__remove_hrtimer(timer, base, state, reprogram);
+		__remove_hrtimer(timer, base, state, 0);
 		return 1;
 	}
 	return 0;
-- 
1.7.1