Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935336Ab3BOGNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:13:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3BOGNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:13:42 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0JbqKwDi4LkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=QQ3-LshB6dIA:10 a=07d9gI8wAAAA:8 a=hSqgzqeBgeVYPsFRUp8A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360908819.23152.97.camel@gandalf.local.home>
Subject: [RFC] sched: The removal of idle_balance()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Fri, 15 Feb 2013 01:13:39 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on cleaning up the scheduler a little and I moved the
call to idle_balance() from directly in the scheduler proper into the
idle class. Benchmarks (well hackbench) improved slightly as I did this.
I was adding some more tweaks and running perf stat on the results when
I made a mistake and notice a drastic change.

My runs looked something like this on my i7 4 core 4 hyperthreads:

[root@bxtest ~]# perf stat -a -r 100  /work/c/hackbench 500
Time: 16.354
Time: 25.299
Time: 20.621
Time: 19.457
Time: 14.484
Time: 7.615
Time: 35.346
Time: 29.366
Time: 18.474
Time: 14.492
Time: 5.660
Time: 25.955
Time: 9.363
Time: 34.834
Time: 18.736
Time: 30.895
Time: 33.827
Time: 11.237
Time: 17.031
Time: 18.615
Time: 29.222
Time: 14.298
Time: 35.798
Time: 7.109
Time: 16.437
Time: 18.782
Time: 4.923
Time: 10.595
Time: 16.685
Time: 9.000
Time: 18.686
Time: 21.355
Time: 10.280
Time: 21.159
Time: 30.955
Time: 15.496
Time: 6.452
Time: 19.625
Time: 20.656
Time: 19.679
Time: 12.484
Time: 31.189
Time: 19.136
Time: 20.763
Time: 11.415
Time: 15.652
Time: 23.935
Time: 28.225
Time: 9.930
Time: 11.658
[...]

With my changes making the average get better by a second or two. The
output from the perf stat looked like this:

 Performance counter stats for '/work/c/hackbench 500' (100 runs):

     199820.045583 task-clock                #    8.016 CPUs utilized            ( +-  5.29% ) [100.00%]
         3,594,264 context-switches          #    0.018 M/sec                    ( +-  5.94% ) [100.00%]
           352,240 cpu-migrations            #    0.002 M/sec                    ( +-  3.31% ) [100.00%]
         1,006,732 page-faults               #    0.005 M/sec                    ( +-  0.56% )
   293,801,912,874 cycles                    #    1.470 GHz                      ( +-  4.20% ) [100.00%]
   261,808,125,109 stalled-cycles-frontend   #   89.11% frontend cycles idle     ( +-  4.38% ) [100.00%]
   <not supported> stalled-cycles-backend  
   135,521,344,089 instructions              #    0.46  insns per cycle        
                                             #    1.93  stalled cycles per insn  ( +-  4.37% ) [100.00%]
    26,198,116,586 branches                  #  131.109 M/sec                    ( +-  4.59% ) [100.00%]
       115,326,812 branch-misses             #    0.44% of all branches          ( +-  4.12% )

      24.929136087 seconds time elapsed                                          ( +-  5.31% )

Again, my patches made slight improvements. Down to 22 and 21 seconds at best.

But then when I made a small tweak, it looked like this:

[root@bxtest ~]# perf stat -a -r 100  /work/c/hackbench 500
Time: 5.820
Time: 28.815
Time: 5.032
Time: 17.151
Time: 8.347
Time: 5.142
Time: 5.138
Time: 18.695
Time: 5.099
Time: 4.994
Time: 5.016
Time: 5.076
Time: 5.049
Time: 21.453
Time: 5.241
Time: 10.498
Time: 5.011
Time: 6.142
Time: 4.953
Time: 5.145
Time: 5.004
Time: 14.848
Time: 5.846
Time: 5.076
Time: 5.826
Time: 5.108
Time: 5.122
Time: 5.254
Time: 5.309
Time: 5.018
Time: 7.561
Time: 5.176
Time: 21.142
Time: 5.063
Time: 5.235
Time: 6.535
Time: 4.993
Time: 5.219
Time: 5.070
Time: 5.232
Time: 5.029
Time: 5.091
Time: 6.092
Time: 5.020
[...]

 Performance counter stats for '/work/c/hackbench 500' (100 runs):

      98258.962617 task-clock                #    7.998 CPUs utilized            ( +- 12.12% ) [100.00%]
         2,572,651 context-switches          #    0.026 M/sec                    ( +-  9.35% ) [100.00%]
           224,004 cpu-migrations            #    0.002 M/sec                    ( +-  5.01% ) [100.00%]
           913,813 page-faults               #    0.009 M/sec                    ( +-  0.71% )
   215,927,081,108 cycles                    #    2.198 GHz                      ( +-  5.48% ) [100.00%]
   189,246,626,321 stalled-cycles-frontend   #   87.64% frontend cycles idle     ( +-  6.07% ) [100.00%]
   <not supported> stalled-cycles-backend  
   102,965,954,824 instructions              #    0.48  insns per cycle        
                                             #    1.84  stalled cycles per insn  ( +-  5.40% ) [100.00%]
    19,280,914,558 branches                  #  196.226 M/sec                    ( +-  5.89% ) [100.00%]
        87,284,617 branch-misses             #    0.45% of all branches          ( +-  5.06% )

      12.285025160 seconds time elapsed                                          ( +- 12.14% )

And it consistently looked like that. I thought to myself, geeze! That
tweek did one hell of an improvement. But that tweak should not have, as
I just moved some code around. Things were only being called in
different places.

Looking at my change, I discovered my *bug*, which in this case,
happened to be a true feature. It prevented idle_balance() from ever
being called.

This is a 50% improvement! On a benchmark that stresses the scheduler.
OK, I know that hackbench isn't a real world benchmark, but this got me
thinking. I started looking into the history of idle_balance() and
discovered that it existed from the start of git (2005), and is probably
older (I didn't bother checking other historical archives, although I
did find this: http://lwn.net/Articles/109371/ ). This was a time that
SMP processors were just becoming affordable for the public. It's when I
first bought my own. But they were on small boxes, nothing large. 8 CPUs
was still considered huge then (for us mere mortals).

idle_balance() is the notion of when the CPU is about to go idle, go
snoop around the other CPUs and pull anything over that might be
available. But this pull is actually hurting the task more than helping,
as it would lose all its cache. Just letting the normal tick based load
balancing will save these tasks from constantly having their cache
ripped out from underneath them.

with idle_balance:

perf stat -r 10 -e cache-misses /work/c/hackbench 500

 Performance counter stats for '/work/c/hackbench 500' (10 runs):

       720,120,346 cache-misses                                                  ( +-  9.87% )

      34.445262454 seconds time elapsed                                          ( +- 32.55% )

perf stat -r 10 -a -e sched:sched_migrate_task -a /work/c/hackbench 500 

 Performance counter stats for '/work/c/hackbench 500' (10 runs):

           306,398 sched:sched_migrate_task                                      ( +-  4.62% )

      18.376370212 seconds time elapsed                                          ( +- 14.15% )


When we remove idle balance:

perf stat -r 10 -e cache-misses /work/c/hackbench 500

 Performance counter stats for '/work/c/hackbench 500' (10 runs):

       550,392,064 cache-misses                                                  ( +-  4.89% )

      12.836740930 seconds time elapsed                                          ( +- 23.53% )

perf stat -r 10 -a -e sched:sched_migrate_task -a /work/c/hackbench 500 

 Performance counter stats for '/work/c/hackbench 500' (10 runs):

           219,725 sched:sched_migrate_task                                      ( +-  2.83% )

       8.019037539 seconds time elapsed                                          ( +-  6.90% )

(cut down to just 10 runs to save time)

The cache misses dropped by ~23% and migrations dropped by ~28%. I
really believe that the idle_balance() hurts performance, and not just
for something like hackbench, but the aggressive nature for migration
that idle_balance() causes takes a large hit on a process' cache.

Think about it some more, just because we go idle isn't enough reason to
pull a runable task over. CPUs go idle all the time, and tasks are woken
up all the time. There's no reason that we can't just wait for the sched
tick to decide its time to do a bit of balancing. Sure, it would be nice
if the idle CPU did the work. But I think that frame of mind was an
incorrect notion from back in the early 2000s and does not apply to
today's hardware, or perhaps it doesn't apply to the (relatively) new
CFS scheduler. If you want aggressive scheduling, make the task rt, and
it will do aggressive scheduling.

But anyway, please, try it yourself. It's a really simple patch. This
isn't the final patch, for if this proves to be as big of a hit as
hackbench shows, the complete removal of idle_balance would be in order.

Who knows, maybe I'm missing something and this is just a fluke with
hackbench. I'm Cc'ing the guru's of the scheduler. Maybe they can show
me why idle_balance() is correct.

Go forth and test!

-- Steve

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1dff78a..a9317b7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2927,9 +2927,6 @@ need_resched:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
-
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
 	clear_tsk_need_resched(prev);


