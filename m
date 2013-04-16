Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3DPPZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:25:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45706 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3DPPZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:25:30 -0400
Message-ID: <1366125925.9604.0.camel@e103567-lin>
Subject: [RFC PATCH 0/3] Per-Task Load Tracking in the presence of DVFS
From: Chris Redpath <chris.redpath@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Alex Shi <alex.shi@intel.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Todd Poynor <toddpoynor@google.com>
Date: Tue, 16 Apr 2013 16:25:25 +0100
X-Mailer: Evolution 3.2.3-0ubuntu6
Mime-Version: 1.0
X-OriginalArrivalTime: 16 Apr 2013 15:25:25.0837 (UTC) FILETIME=[9E8617D0:01CE3AB6]
X-MC-Unique: 113041616252701601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, I realise this is rather a long cover letter but a lot of it is
the ascii graphs. My apologies. For skim readers the tl;dr version is:

The presence of CPUfreq in a system with more than one CPU frequency
domain causes the tracked load of tasks to be high when the CPU
frequency is low. When you use these stats to optimise task placement,
this can cause you to move tasks early. If you only have one frequency
domain, there are no side effects.

The long version:
While experimenting with big.LITTLE MP scheduling (e.g.
http://lwn.net/Articles/539089/) using the per-task load tracking
introduced in the recent patch set, we saw a situation where the load of
periodic tasks (like audio playback) would be higher when CPUfreq was
running the CPU at a low frequency.

Although this is an obvious result of the increased time required to
perform a constant amount of processing when the frequency of a CPU is
lowered, it was not without impact on our ability to use the load
statistic for balancing. 

While our problem is pretty specific to how we are using the load stats,
I think we are reasonably representative of the kinds of things that
people will want to use load tracking for. The interaction of DVFS and
reported load stats are therefore something I believe we ought to
discuss on the list.

I will not call the load profile incorrect since it is accurately
reflecting the historical compute consumption of the task. Where this
can become misleading is if we then wish to use the tracked load
statistic for load balancing between domains where there are different
compute capacities available either through microarchitectural means
(big.LITTLE) or separate frequencies (e.g. Qualcomm Krait systems). It
may also be an issue (as far as I can see) in any multi-socket system.

The issue is easiest to see using a busy loop driven by a periodic alarm
signal running on a CPU whose frequency is controlled by the ondemand
cpufreq governor. Although it's an artificial workload the issue is seen
in real traces, but the task is simpler to understand. The sample task
code is at the end of this mail. I use an ARM CoreTile Express 
V2P-CA15_A7, which has 2xA15 and 3xA7 CPUs. The test is run pinned to
one CPU.

For my A7 core running at 1GHz, running the alarm signal at 1024us
intervals with a busy loop count of 35500 generates a reasonably stable
50% load. Here I have used the performance governor and traced the task
contribution when the calculation is updated.

static inline void __update_task_entity_contrib(struct sched_entity *se)
{
  u32 contrib;

  /* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
  contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
  contrib /= (se->avg.runnable_avg_period + 1);
  se->avg.load_avg_contrib = scale_load(contrib);
  trace_sched_task_load_avg_contrib(task_of(se), scale_load(contrib),
										se->load.weight);
}

This produces the following load contribution (gnuplotted on dumb term
from ftrace data). The lack of time accounted to the period in early
task life is visible here but the load stabilises around 50% which the
busy loop count was calibrated for.


   +---------+--------+---------+---------+---------+---------+
   +         + A      +         + "contrib_filtered.csv"   A  +
1k ++                                                        ++
   |           A                                              |
   |           A                                              |
800++          A                                             ++
   |           A                                              |
   |           A                                              |
   |           A                                              |
600++          AA                                            ++
   |            AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA |
   |                   A                                      |
400++                                                        ++
   |                                                          |
   |                                                          |
   |                                                          |
200++                                                        ++
   |                                                          |
   +         +        +         +         +         +         +
 0 ++--------+--------+---------+---------+---------+---------+
  3043      3044     3045      3046      3047      3048     3049

Repeating the exercise using ondemand shows how the changing frequency
causes the task to be more busy, reflecting that the CPU is busy for
more time to do the same amount of work. The result is what you'd expect.

   +----------+-----------+----------+----------+-----------+
   +    AAAAAAAAAAAAA     +          + "contrib.csv"   A    +
1k++    AA          A                                      ++
   |    A           A                                       |
   |    A           A        AA          A        AAA       |
800++   A           A     AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA ++
   |    A           A     A                                 |
   |    A           A     A                                 |
   |    A           A     A                                 |
600++   A           AA    A                                ++
   |    A            AAAAAA                                 |
   |                                                        |
400++               ^     ^                                ++
   |                |     |                                 |
   |                |     |                                 |
   |                |     |                                 |
200++         1GHz->|     |<-600MHz                        ++
   |                                                        |
   +          +           +          +          +           +
 0 ++---------+-----------+----------+----------+-----------+
  4990       4992        4994       4996       4998        5000

Here the changes in load contribution are due to the frequency changes.
The CPU is running at 350MHz at the beginning, changing to 1GHz at 4993s
and 600MHz at 4994s. The governor is doing what is expected - our load
makes the CPU busy and after a couple of sample periods, the governor
has figured out which frequency to use to hit the 80% default busyness
target. 

The problem comes when you try to use these task load stats for
placement or load balancing. What you think is an 80% task is in reality
only a 50% task on another CPU which was running at full speed. As far
as I can see, within the range of possible CPU utilization and available
frequencies, demand-driven governors will always attempt to be a certain
amount busy and this will lead to all runqueues tending towards a load
of 80%. This directly influences the load accounted to tasks and
particularly for low-intensity periodic tasks where many could be
accommodated on the same CPU.

There are at least 3 attempts underway to use load tracking as a basis
for capacity based scheduling - our own big.LITTLE MP work reported at
http://lwn.net/Articles/541005/  , Alex Shi's patch set v5 at
https://lkml.org/lkml/2013/2/18/4  , and Preeti U Murthy's patch set at
https://lkml.org/lkml/2012/11/15/391  here on the list.

As I mentioned earlier, our first prototype big.LITTLE MP patches used
the load average statistic as a proxy for the 'bigness' of tasks. In the
first version we had a dual threshold for load average contribution.
Above the up threshold we would consider the task to be a candidate to
use an A15 CPU and below the down threshold we would consider the task
to be a candidate to use an A7 CPU. This works surprisingly well, but we
really require load signals to be consistent across all the CPUs to make
the mental models simple and also in the example given we would likely
recognise the 50% busy loop as a task deserving of more CPU power. This
would result in migrating the task and waking an A15 when we would
prefer to wait for CPUfreq to catch up.


In the enclosed patches, I present a simple method to modify the tracked
loads in accordance with the frequency of the CPU.

I have an older version of this patch set which is much less invasive
but for experimentation, I added two new runqueue variables to track the
current and max values of a made-up metric I called 'compute_capacity'.
This is a number which is supposed to represent the relative compute
capacity of a particular CPU compared to the most powerful in the system
running at its maximum speed.
The max_compute_capacity is determined by looking at the cpu_power of
all CPUs in the system and calculating what the cpu_power of each CPU
would be if the set was scaled to [0..1023].
The curr_compute_capacity is determined by taking the max_ for a CPU and
scaling it as the frequency varies from the reported max freq.

These stats are used when adding time to the task series' to modulate
the amount of time added like so:

time_added = (original time * curr_cpu_capacity) / max_cpu_capacity

and this is done separately at each time step which is added to the
accumulator.

This means that when a core is running at 50% of its max frequency, a
task running flat out can only accumulate a load of 50%.

For the example task, this changes the tracked load like so:

   +----------+-----------+----------+----------+-----------+
   +          +           +          + "contrib.csv"   A    +
1k ++                                                      ++
   |                                                        |
   |                                                        |
800++                                                      ++
   |                                                        |
   |                                                        |
   |                                                        |
600++                                                      ++
   |                 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
   |                AA                                      |
400++               A                                      ++
   |       AAAAAAAAAA                                       |
   |       A                                                |
   |       |        |                                       |
200++      |<------>| period A                             ++
   |                                                        |
   +          +           +          +          +           +
 0 ++---------+-----------+----------+----------+-----------+
  1648       1650        1652       1654       1656        1658

Scaling the accounted time in line with DVFS has the effect of making
the tracked load closely match the contribution to the potential
capacity of the CPU for these periodic tasks. Effectively, it
synchronises the scheduler and DVFS understanding of the system
condition.

A defect of the process can also be seen here. In period Z, the CPU is
running at 350MHz, and the timer load is calibrated for 50% at 1GHz. As
we could see earlier, the task fully loads the CPU however with the load
scaling we have capped the maximum load we can achieve when busy in line
with frequency. It may be beneficial to not scale the load when a CPU
has no idle time, but I haven't experimented with that.

A further defect in the patch set is that I update the CPU power each
time I calculate the stats. Normally, I update it only when cpu_power is
updated, but there is clearly a problem there since in these test
conditions load balancing does not happen and that is usually when the
cpu_power is updated. I probably need to change the update of
curr_compute_capacity to be triggered in response to the frequency
change notification rather than relying upon the scheduler pulling the
info at the right time.

Selecting an appropriate DVFS governor with very short sample times
somewhat mitigates this, but the underlying issue is still present.


[appendix 1] Sample task code (thanks to Morten Rasmussen for the
                               original)

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int busy_loops = 100000000;
useconds_t alarm_rate = 100000;

void
waste_time(int loops) {
  int i;
  int t = 0;
  for (i=0;i<loops;i++)
    t++; 
}

void
catch_alarm (int sig)
{
  waste_time(busy_loops);
  signal (sig, catch_alarm);
}

int
main(int argc, char **argv)
{

  if (argc != 3) {
    printf("Usage: timerload <alarm_rate> <busy_loops>\nalarm_rate:\t"
    "Busy loop invocation rate [us]. (Doesn't work for rate >= 1s)\n"
    "busy_loops:\tBusy loop iterations per invocation.\n");
    exit(0);
  }

  if (atoi(argv[1]) >= 1000000){
    printf("alarm_rate must be less than 1000000\n");
  }

  alarm_rate = (useconds_t) atoi(argv[1]);
  busy_loops = atoi(argv[2]);
  printf("alarm_rate = %d\nbusy_loops = %d\n",alarm_rate,busy_loops);

  /* Establish a handler for SIGALRM signals. */
  signal(SIGALRM, catch_alarm);
  
  /* Set an alarm to go off in a little while. */
  ualarm(alarm_rate,alarm_rate);
  
  /* Check the flag once in a while to see when to quit. */
  while (1) {
    pause();
  }

  return EXIT_SUCCESS;
}






Chris Redpath (3):
  ARM: (Experimental) Provide Estimated CPU Capacity measure
  sched: introduce compute capacity for CPUs, groups and domains
  sched: Scale load contribution by CPU Capacity

 arch/arm/Kconfig                  |   16 +++
 arch/arm/include/asm/topology.h   |    7 ++
 arch/arm/kernel/topology.c        |  216 ++++++++++++++++++++++++++++++++++++-
 drivers/base/topology.c           |   18 ++++
 include/linux/sched.h             |    7 ++
 include/trace/events/sched.h      |   24 +++++
 kernel/sched/core.c               |    2 +
 kernel/sched/debug.c              |    3 +
 kernel/sched/fair.c               |  120 ++++++++++++++++++---
 kernel/sched/sched.h              |    4 +
 linaro/configs/big-LITTLE-MP.conf |    3 +-
 11 files changed, 404 insertions(+), 16 deletions(-)

-- 
1.7.9.5



