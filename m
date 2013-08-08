Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142Ab3HHJE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:04:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:60106 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933829Ab3HHJEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:04:52 -0400
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable reprogramming in remove_hrtimer
From: "ethan.zhao" <ethan.kernel@gmail.com>
In-Reply-To: <BD6ACAD8-25D7-406B-A843-22696F9D8DCC@gmail.com>
Date: Thu, 8 Aug 2013 17:04:40 +0800
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>,
        Youquan Song <youquan.song@intel.com>, LenBrown <len.brown@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <260513AB-5C95-49F1-B437-91039CD8CD26@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com> <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de> <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com> <20130730093519.GP3008@twins.programming.kicks-ass.net> <1375774140.5412.9.camel@marge.simpson.net> <1375775172.5412.14.camel@marge.simpson.net> <BD6ACAD8-25D7-406B-A843-22696F9D8DCC@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 3.11-rc1 +Peterz' patch+ Mike's patch, No C-states in BIOS, got the same result as only Peter's patch.
Of course , No C states to enter, make sense.
[root@localhost ~]# time ./pip1m

real	0m4.381s
user	0m0.099s
sys	0m2.784s
[root@localhost ~]# time ./pip1m

real	0m4.436s
user	0m0.093s
sys	0m2.809s
[root@localhost ~]# 

Retest with C-states enabled in BIOS
[root@localhost ~]# time ./pip1m

real	0m8.670s
user	0m0.203s
sys	0m5.459s
[root@localhost ~]# time ./pip1m

real	0m8.489s
user	0m0.184s
sys	0m5.360s
[root@localhost ~]# 

So the result is Peter's patch working or Mike's ?  Compared with default 3.11-rc3
result of test case 1 as following, looks great.
[root@localhost ~]# time ./pip1m

real	0m10.683s
user	0m0.204s
sys	0m6.597s
[root@localhost ~]# time ./pip1m

real	0m10.629s
user	0m0.185s
sys	0m6.546s

So revert Mike's patch and retest, got
[root@localhost ~]# time ./pip1m

real	0m8.606s
user	0m0.193s
sys	0m5.449s
[root@localhost ~]# time ./pip1m

real	0m8.655s
user	0m0.198s
sys	0m5.519s
[root@localhost ~]# 

So, it's Peter's patch working¡­¡­¡­

The result of kernel 3.11-rc3 + Peter's patch + no rescheduling IPI and no C-states in BIOS is :
[root@localhost ~]# time ./pip1m

real	0m3.915s
user	0m0.088s
sys	0m2.487s
[root@localhost ~]# time ./pip1m

real	0m3.929s
user	0m0.082s
sys	0m2.560s
[root@localhost ~]# time ./pip1m

Got about 0.5 sec better than only Peter's patch, but it is strange, only no rescheduling IPI almost got the
same result.


Thanks,
Ethan


ÔÚ 2013-8-8£¬ÏÂÎç12:31£¬ethan.zhao <ethan.kernel@gmail.com> Ð´µÀ£º
>>> 
>>> sched: ratelimit nohz
>>> 
>>> Entering nohz code on every micro-idle is too expensive to bear.
>>> 
>>> Signed-off-by: Mike Galbraith <efault@gmx.de>
>>> 
>>> ---
>>> include/linux/sched.h    |    5 +++++
>>> kernel/sched/core.c      |    5 +++++
>>> kernel/time/tick-sched.c |    2 +-
>>> 3 files changed, 11 insertions(+), 1 deletion(-)
>>> 
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -235,9 +235,14 @@ extern int runqueue_is_locked(int cpu);
>>> extern void nohz_balance_enter_idle(int cpu);
>>> extern void set_cpu_sd_state_idle(void);
>>> extern int get_nohz_timer_target(void);
>>> +extern int sched_needs_cpu(int cpu);
>>> #else
>>> static inline void nohz_balance_enter_idle(int cpu) { }
>>> static inline void set_cpu_sd_state_idle(void) { }
>>> +static inline int sched_needs_cpu(int cpu)
>>> +{
>>> +	return 0;
>>> +}
>>> #endif
>>> 
>>> /*
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -650,6 +650,11 @@ static inline bool got_nohz_idle_kick(vo
>>> 	return false;
>>> }
>>> 
>>> +int sched_needs_cpu(int cpu)
>>> +{
>>> +	return  cpu_rq(cpu)->avg_idle < sysctl_sched_migration_cost;
>>> +}
>>> +
>>> #else /* CONFIG_NO_HZ_COMMON */
>>> 
>>> static inline bool got_nohz_idle_kick(void)
>>> --- a/kernel/time/tick-sched.c
>>> +++ b/kernel/time/tick-sched.c
>>> @@ -548,7 +548,7 @@ static ktime_t tick_nohz_stop_sched_tick
>>> 		time_delta = timekeeping_max_deferment();
>>> 	} while (read_seqretry(&jiffies_lock, seq));
>>> 
>>> -	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
>>> +	if (sched_needs_cpu(cpu) || rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
>>> 	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
>>> 		next_jiffies = last_jiffies + 1;
>>> 		delta_jiffies = 1;
>>> 
>>> 
>> 
>> 
> 

