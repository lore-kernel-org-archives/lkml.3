Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaDPGdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:33:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44289 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaDPGda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:33:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <534E2422.1040706@jp.fujitsu.com>
Date: Wed, 16 Apr 2014 15:33:06 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race
 on idle time stats
References: <53465F54.708@jp.fujitsu.com> <534660D2.1080505@jp.fujitsu.com> <20140415101910.GN11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140415101910.GN11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 19:19), Peter Zijlstra wrote:
> On Thu, Apr 10, 2014 at 06:13:54PM +0900, Hidetoshi Seto wrote:
>> [WHAT THIS PATCH PROPOSED]:
>>
>> To fix problem 1, this patch adds seqcount for NO_HZ idle
>> accounting to avoid possible races between reader/writer.
>>
>> And to cope with problem 2, I introduced delayed iowait
>> accounting to get approximate value without making observers
>> to writers. Refer comment in patch for the detail.
> 
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -407,15 +407,42 @@ static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
>>  {
>>  	ktime_t delta;
>>  
>> +	write_seqcount_begin(&ts->idle_sleeptime_seq);
>> +
>>  	/* Updates the per cpu time idle statistics counters */
>>  	delta = ktime_sub(now, ts->idle_entrytime);
>> +
>> +	/*
>> +	 * Perform delayed iowait accounting:
>> +	 *
>> +	 * We account sleep time as iowait when nr_iowait of cpu indicates
>> +	 * there are taskes blocked by io, at the end of idle (=here).
>> +	 * It means we can not determine whether the sleep time will be idle
>> +	 * or iowait on the fly.
>> +	 * Therefore introduce a new rule:
>> +	 * - basically observers assign delta to idle
>> +	 * - if cpu find nr_iowait>0 at idle exit, accumulate delta as missed
>> +	 *   iowait, and account it in next turn of sleep instead.
>> +	 * - if observer find accumulated iowait while cpu is in sleep, it
>> +	 *   can calculate proper value to be accounted.
>> +	 */
>> +	if (ktime_compare(ts->iowait_pending, delta) > 0) {
>>  		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
>> +		ts->iowait_pending = ktime_sub(ts->iowait_pending, delta);
>> +	} else {
>> +		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime,
>> +					ktime_sub(delta, ts->iowait_pending));
>> +		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime,
>> +						 ts->iowait_pending);
>> +		ts->iowait_pending = ktime_set(0, 0);
>> +	}
>> +	if (nr_iowait_cpu(smp_processor_id()) > 0)
>> +		ts->iowait_pending = ktime_add(ts->iowait_pending, delta);
>> +
>>  	ts->idle_active = 0;
>>  
>> +	write_seqcount_end(&ts->idle_sleeptime_seq);
>> +
>>  	sched_clock_idle_wakeup_event(0);
>>  }
> 
> Why!? Both changelog and comment are silent on this. This doesn't appear
> to make any sense nor really solve anything.

Sorry about my poor description.
I hope I can clarify my idea and thoughts in the following sentence...


[1] : should we make a change on a /proc/stat field semantic? 

As Frederic stated in previous mail:
<quote>
> So what we can do for example is to account it per task and update stats
> on the CPU where the blocking task wakes up. This way we guarantee
> that we only account locally, which is good for scalability.
> 
> This is going to be an ABI change on a /proc/stat field semantic.
> We usually can not do that as it can break userspace. But I think
> we have a reasonable exception here:
> 
> 1) On a performance POV we don't have the choice.
> 
> 2) It has always been a buggy stat on SMP. Given the possible fast iowait update
> rate, I doubt it has ever dumped correct stats. So I guess that few user apps
> have ever correctly relied on it. 
</quote>

Basically I agree with this idea if we maintain only latest upstream in
development. But in case if target kernel is in family of stables or
some kind of distributor's kernel, I suppose this idea is not acceptable
because keeping semantics are very important for such environment.

For example, you may propose that "hey, per-cpu iowait is completely
crap! so how about making this field in /proc/stat to stick to 0?"
It would be OK for latest upstream, as interim measure till new
iowait accounting mechanism is invented. But for stable kernels,
it will bring new regression report so it will not be any help.

So we need 2 operations:
  a) remove regression
  b) implement new iowait accounting mechanism

What Frederic mentioned is that we don't need a) once if we invent
the solution for b). But I doubt it because a) is still required
for stable environment including some distributor's kernel.
It is clear that patches for b) will not be backportable.

Still the b) is disease that has no known cure. There is no reason
to wait works on b) before starting works for a).

If we need a semantics change, we can do it for latest upstream.
But OTOH regressions on stable kernels must be fixed.

That's why I wrote these patch set.


[2] : minimum locking for performance

To keep semantics and emulates behavior of tick-based accounting,
my v2 patch set uses seqlock to allow observer to update time stats
of sleeping cpu. I believe v2 do the very minimum implement.

However there were concerns about the performance affect by the
new seqlock. So I started v3 as rework to use minimum locking.

What we required here are:

  - Monotonicity:
     It should be, and it is what we were complained about.

  - Accuracy:
     No, it is really inaccurate from the first.
     However expected is "roughly same with traditional
     tick-based accounting."

  - Exclusivity:
     Expected. A sleep duration time must be accounted
     either idle or iowait, not both. 

  - Performance:
     Even if per-cpu iowait have gone, idle time need to be
     calculated on observing cpu with delta and accumulated,
     and beside update performed locally on idle exit.
     Therefore minimum locking here should be seqcount
     (as Frederic already expected).

Therefore v3 is designed to use seqcount instead of seqlock,
by sacrificing accuracy (=or... reasonability?) on some level.

[3] : new tricks

To use seqcount, observers must be readers and never be writers.
It means that:

  - Observed cpu's time stats are fixed at idle entry, and
    unchanged while sleeping (otherwise results of readers will
    not be coherent).

  - Readers must not refer nr_iowait of sleeping cpu because
    it can be changed by task woken up on other cpu.

At this point:

  - As already pointed out, stating "I'll sleep as iowait"
    at idle entry will result in infinite iowait.
      => Then how about stating:
          "I'll sleep for <e.g. few nsec> as iowait
           and rest as idle"?
      => how to determine reasonable <few nsecs>?

  - Original code accounts iowait only when nr_iowait is >0
    at idle exit. It means we can not determine whether the
    sleep time will be idle or iowait on the fly.
      => we cannot determine <few nsecs> at idle entry

  - No matter how long >0 continues (e.g. sleep 100ms while
    nr_iowait>0 until 99ms), we ignore iowait in sleep time
    if nr_iowait=0 at the end. 
      => if we give temporal arbitrary <few nsec> for
         every idle entry, it will bump up iowait
         unreasonably.

  - It is completely crap but in fact no one complain about
    the inaccuracy.
      => No one notice it if accounted iowait value have
         <few nsec> gaps, even if it was <few msec>.

So new strategy is:

>> +	 * Therefore introduce a new rule:
>> +	 * - basically observers assign delta to idle
>> +	 * - if cpu find nr_iowait>0 at idle exit, accumulate delta as missed
>> +	 *   iowait, and account it in next turn of sleep instead.
>> +	 * - if observer find accumulated iowait while cpu is in sleep, it
>> +	 *   can calculate proper value to be accounted.

... I think I wrote a lot but might missed some point to be clear.
Questions?

I'll write v4 while waiting new replies.


Thanks,
H.Seto

