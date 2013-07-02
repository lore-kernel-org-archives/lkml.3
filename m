Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051Ab3GBEGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 00:06:41 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:59429 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3GBEGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 00:06:40 -0400
Message-ID: <51D24F54.1000703@lab.ntt.co.jp>
Date: Tue, 02 Jul 2013 12:56:04 +0900
From: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] proc: Add workaround for idle/iowait decreasing problem.
References: <201301152014.AAD52192.FOOHQVtSFMFOJL@I-love.SAKURA.ne.jp> <alpine.LFD.2.02.1301151313170.7475@ionos> <201301180857.r0I8vK7c052791@www262.sakura.ne.jp> <1363660703.4993.3.camel@nexus> <201304012205.DFC60784.HVOMJSFFLFtOOQ@I-love.SAKURA.ne.jp> <201304232145.AHE52181.HJVOOQSFLMFOtF@I-love.SAKURA.ne.jp> <20130428004940.GA10354@somewhere>
In-Reply-To: <20130428004940.GA10354@somewhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

I'm sorry it's taken me so long to respond; I got sidetracked for
a while. Comments follow below.

On 2013/04/28 09:49, Frederic Weisbecker wrote:
> On Tue, Apr 23, 2013 at 09:45:23PM +0900, Tetsuo Handa wrote:
>> CONFIG_NO_HZ=y can cause idle/iowait values to decrease.
[...]
> It's not clear in the changelog why you see non-monotonic idle/iowait values.
>
> Looking at the previous patch from Fernando, it seems that's because we can
> race with concurrent updates from the CPU target when it wakes up from idle?
> (could be updated by drivers/cpufreq/cpufreq_governor.c as well).
>
> If so the bug has another symptom: we may also report a wrong iowait/idle time
> by accounting the last idle time twice.
>
> In this case we should fix the bug from the source, for example we can force
> the given ordering:
>
> = Write side =                          = Read side =
>
> // tick_nohz_start_idle()
> write_seqcount_begin(ts->seq)
> ts->idle_entrytime = now
> ts->idle_active = 1
> write_seqcount_end(ts->seq)
>
> // tick_nohz_stop_idle()
> write_seqcount_begin(ts->seq)
> ts->iowait_sleeptime += now - ts->idle_entrytime
> t->idle_active = 0
> write_seqcount_end(ts->seq)
>
>                                          // get_cpu_iowait_time_us()
>                                          do {
>                                              seq = read_seqcount_begin(ts->seq)
>                                              if (t->idle_active) {
>                                                  time = now - ts->idle_entrytime
>                                                  time += ts->iowait_sleeptime
>                                              } else {
>                                                  time = ts->iowait_sleeptime
>                                              }
>                                          } while (read_seqcount_retry(ts->seq, seq));
>
> Right? seqcount should be enough to make sure we are getting a consistent result.
> I doubt we need harder locking.

I tried that and it doesn't suffice. The problem that causes the most
serious skews is related to the CPU scheduler: the per-run queue
counter nr_iowait can be updated not only from the CPU it belongs
to but also from any other CPU if tasks are migrated out while
waiting on I/O.

The race looks like this:

CPU0                            CPU1
                                 [ CPU1_rq->nr_iowait == 0 ]
                                 Task foo: io_schedule()
                                             schedule()
                                 [ CPU1_rq->nr_iowait == 1) ]
                                 Task foo migrated to CPU0
                                 Goes to sleep

// get_cpu_iowait_time_us(1, NULL)
[ CPU1_ts->idle_active == 1, CPU1_rq->nr_iowait == 1         ]
[ CPU1_ts->iowait_sleeptime = 4, CPU1_ts->idle_entrytime = 3 ]
now = 5
delta = 5 - 3 = 2
iowait = 4 + 2 = 6

Task foo wakes up
[ CPU1_rq->nr_iowait == 0 ]

                                 CPU1 comes out of sleep state
                                 tick_nohz_stop_idle()
                                   update_ts_time_stats()
                                     [ CPU1_ts->idle_active == 1, CPU1_rq->nr_iowait == 0         ]
                                     [ CPU1_ts->iowait_sleeptime = 4, CPU1_ts->idle_entrytime = 3 ]
                                     now = 6
                                     delta = 6 - 3 = 3
                                     (CPU1_ts->iowait_sleeptime is not updated)
                                     CPU1_ts->idle_entrytime = now = 6
                                   CPU1_ts->idle_active = 0

// get_cpu_iowait_time_us(1, NULL)
[ CPU1_ts->idle_active == 0, CPU1_rq->nr_iowait == 0         ]
[ CPU1_ts->iowait_sleeptime = 4, CPU1_ts->idle_entrytime = 6 ]
iowait = CPU1_ts->iowait_sleeptime = 4
(iowait decreased from 6 to 4)


> Another thing while at it. It seems that an update done from drivers/cpufreq/cpufreq_governor.c
> (calling get_cpu_iowait_time_us() -> update_ts_time_stats()) can randomly race with a CPU
> entering/exiting idle. I have no idea why drivers/cpufreq/cpufreq_governor.c does the update
> itself. It can just compute the delta like any reader. May be we could remove that and only
> ever call update_ts_time_stats() from the CPU that exit idle.
>
> What do you think?

I am all for it. We just need to make sure that CPU governors
can cope with non-monotonic idle and iowait times. I'll take
a closer look at the code but I wouldn't mind if Arjan (CCed)
beat me at that.

Thanks,
Fernando
