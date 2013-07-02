Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3GBKjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 06:39:54 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35678 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3GBKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 06:39:52 -0400
Message-ID: <51D2ADCC.1090807@lab.ntt.co.jp>
Date: Tue, 02 Jul 2013 19:39:08 +0900
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
References: <201301152014.AAD52192.FOOHQVtSFMFOJL@I-love.SAKURA.ne.jp> <alpine.LFD.2.02.1301151313170.7475@ionos> <201301180857.r0I8vK7c052791@www262.sakura.ne.jp> <1363660703.4993.3.camel@nexus> <201304012205.DFC60784.HVOMJSFFLFtOOQ@I-love.SAKURA.ne.jp> <201304232145.AHE52181.HJVOOQSFLMFOtF@I-love.SAKURA.ne.jp> <20130428004940.GA10354@somewhere> <51D24F54.1000703@lab.ntt.co.jp>
In-Reply-To: <51D24F54.1000703@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年07月02日 12:56, Fernando Luis Vazquez Cao wrote:
> Hi Frederic,
>
> I'm sorry it's taken me so long to respond; I got sidetracked for
> a while. Comments follow below.
>
> On 2013/04/28 09:49, Frederic Weisbecker wrote:
>> On Tue, Apr 23, 2013 at 09:45:23PM +0900, Tetsuo Handa wrote:
>>> CONFIG_NO_HZ=y can cause idle/iowait values to decrease.
> [...]
>> It's not clear in the changelog why you see non-monotonic idle/iowait 
>> values.
>>
>> Looking at the previous patch from Fernando, it seems that's because 
>> we can
>> race with concurrent updates from the CPU target when it wakes up 
>> from idle?
>> (could be updated by drivers/cpufreq/cpufreq_governor.c as well).
>>
>> If so the bug has another symptom: we may also report a wrong 
>> iowait/idle time
>> by accounting the last idle time twice.
>>
>> In this case we should fix the bug from the source, for example we 
>> can force
>> the given ordering:
>>
>> = Write side =                          = Read side =
>>
>> // tick_nohz_start_idle()
>> write_seqcount_begin(ts->seq)
>> ts->idle_entrytime = now
>> ts->idle_active = 1
>> write_seqcount_end(ts->seq)
>>
>> // tick_nohz_stop_idle()
>> write_seqcount_begin(ts->seq)
>> ts->iowait_sleeptime += now - ts->idle_entrytime
>> t->idle_active = 0
>> write_seqcount_end(ts->seq)
>>
>>                                          // get_cpu_iowait_time_us()
>>                                          do {
>>                                              seq = 
>> read_seqcount_begin(ts->seq)
>>                                              if (t->idle_active) {
>>                                                  time = now - 
>> ts->idle_entrytime
>>                                                  time += 
>> ts->iowait_sleeptime
>>                                              } else {
>>                                                  time = 
>> ts->iowait_sleeptime
>>                                              }
>>                                          } while 
>> (read_seqcount_retry(ts->seq, seq));
>>
>> Right? seqcount should be enough to make sure we are getting a 
>> consistent result.
>> I doubt we need harder locking.
>
> I tried that and it doesn't suffice. The problem that causes the most
> serious skews is related to the CPU scheduler: the per-run queue
> counter nr_iowait can be updated not only from the CPU it belongs
> to but also from any other CPU if tasks are migrated out while
> waiting on I/O.
>
> The race looks like this:
>
> CPU0                            CPU1
>                                 [ CPU1_rq->nr_iowait == 0 ]
>                                 Task foo: io_schedule()
>                                             schedule()
>                                 [ CPU1_rq->nr_iowait == 1) ]
>                                 Task foo migrated to CPU0
>                                 Goes to sleep
>
> // get_cpu_iowait_time_us(1, NULL)
> [ CPU1_ts->idle_active == 1, CPU1_rq->nr_iowait == 1 ]
> [ CPU1_ts->iowait_sleeptime = 4, CPU1_ts->idle_entrytime = 3 ]
> now = 5
> delta = 5 - 3 = 2
> iowait = 4 + 2 = 6
>
> Task foo wakes up
> [ CPU1_rq->nr_iowait == 0 ]
>
>                                 CPU1 comes out of sleep state
>                                 tick_nohz_stop_idle()
>                                   update_ts_time_stats()
>                                     [ CPU1_ts->idle_active == 1, 
> CPU1_rq->nr_iowait == 0         ]
>                                     [ CPU1_ts->iowait_sleeptime = 4, 
> CPU1_ts->idle_entrytime = 3 ]
>                                     now = 6
>                                     delta = 6 - 3 = 3
>                                     (CPU1_ts->iowait_sleeptime is not 
> updated)
>                                     CPU1_ts->idle_entrytime = now = 6
>                                   CPU1_ts->idle_active = 0
>
> // get_cpu_iowait_time_us(1, NULL)
> [ CPU1_ts->idle_active == 0, CPU1_rq->nr_iowait == 0 ]
> [ CPU1_ts->iowait_sleeptime = 4, CPU1_ts->idle_entrytime = 6 ]
> iowait = CPU1_ts->iowait_sleeptime = 4
> (iowait decreased from 6 to 4)

A possible solution to the races above would be to add
a per-cpu variable such ->iowait_sleeptime_user which
shadows ->iowait_sleeptime but is maintained in
get_cpu_iowait_time_us() and kept monotonic,
the former being the one we would export to user
space.

Another approach would be updating ->nr_iowait
of the source and destination CPUs during task
migration, but this may be overkill.

What do you think?

Thanks,
Fernando
