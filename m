Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3HIGwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:52:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3HIGwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:52:15 -0400
Message-ID: <1376031129.18997.43.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>
Date: Fri, 09 Aug 2013 08:52:09 +0200
In-Reply-To: <BBA29515-CD89-47C5-B155-B71A6F6632DC@gmail.com>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	 <20130730093519.GP3008@twins.programming.kicks-ass.net>
	 <1375774140.5412.9.camel@marge.simpson.net>
	 <BBA29515-CD89-47C5-B155-B71A6F6632DC@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:l4MmiqnYr1J1TwrjejlfhIzDshqhfareZmjTs+dFlTN
 ywgtVLV7+gVFYTb3pI9MskaELMxHEjm/DBIQP6sNrYRS4CFa7E
 R1kadizejrzKa5KtwgAhZSotyjqxhVTZE/SdxGAPjnza0r4mM8
 x3ufeokAizIr7ybkNMsF6pvT1xpr837T+zuk/f95PE4Mxl/40e
 Jlfey0JjYZV9WY4sGpjryglZaUFDmdVS67wdTQqqq+xbf5VO3P
 Wp0ksSvI6AZmTWjkIqtm7T6d23qXO9o3UsHD51QZGcIpvT33bQ
 s30hurvzS83zyd6lefAn1geIUI/jNX7021xJgd0RZnRMsVvGvU
 fS/kCqWpHDVfiw+CSWwWDW6g9iZe97OQoRozo+c2xJyXJ9Dur6
 mhjOOHjibtQHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 23:02 +0800, ethan.zhao wrote: 
> 在 2013-8-6，下午3:29，Mike Galbraith <bitbucket@online.de> 写道：
> 
> > +int sched_needs_cpu(int cpu)
> > +{
> > +	return  cpu_rq(cpu)->avg_idle < sysctl_sched_migration_cost;
> > +}
> > +
> > #else /* CONFIG_NO_HZ_COMMON */
> > 
> > static inline bool got_nohz_idle_kick(void)
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -548,7 +548,7 @@ static ktime_t tick_nohz_stop_sched_tick
> > 		time_delta = timekeeping_max_deferment();
> > 	} while (read_seqretry(&jiffies_lock, seq));
> > 
> > -	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
> > +	if (sched_needs_cpu(cpu) || rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
> > 	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
> > 		next_jiffies = last_jiffies + 1;
> > 		delta_jiffies = 1;
> 
> If the performace regression was caused by too much expensive clock device reprogramming and too frequent entering /exiting of C-states…   this patch should work.
> except the following result is almost always false under 3.11-rc3 code.
> 
> > return  cpu_rq(cpu)->avg_idle < sysctl_sched_migration_cost;

On my E5620 box, avg_idle works fine.  Patchlet doesn't save as much as
it used to, thanks to Peter's patch now killing the worst of the pain,
but it does still does save cycles.  I have too much regression left to
say exactly what it can now save max, doesn't matter much either.

The pertinent numbers:

v3.11-rc4-27-ge4ef108    496.7 KHz      .858     1.030     throttle+peterz
v3.11-rc4-27-ge4ef108    440.7 KHz      .761     1.296     nothrottle+peterz

-Mike

