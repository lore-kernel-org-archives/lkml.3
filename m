Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3JNMml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:42:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:41422 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3JNMmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:42:40 -0400
Date: Mon, 14 Oct 2013 13:42:43 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "pjt@google.com" <pjt@google.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>, "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 3/7] sched: power: go_faster/slower power driver
 hints
Message-ID: <20131014124243.GL31039@e103034-lin>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
 <1381511957-29776-4-git-send-email-morten.rasmussen@arm.com>
 <5258BABF.4020404@linux.vnet.ibm.com>
MIME-Version: 1.0
In-Reply-To: <5258BABF.4020404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 Oct 2013 12:42:35.0570 (UTC) FILETIME=[DBC26920:01CEC8DA]
X-MC-Unique: 113101413423703001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sat, Oct 12, 2013 at 03:58:07AM +0100, Michael wang wrote:
> Hi, Morten
> 
> On 10/12/2013 01:19 AM, Morten Rasmussen wrote:
> [snip]
> >  
> > @@ -5743,6 +5772,7 @@ static void run_rebalance_domains(struct softirq_action *h)
> >  	 */
> >  	nohz_idle_balance(this_cpu, idle);
> >  
> > +	inc_cpu_capacity(this_cpu);
> 
> Just wondering is this check necessary here? if rq get more tasks during
> the balance, enqueue_task() should already do the check each time when
> we move_task(), isn't it?

True. enqueue_task() should do the necessary check when we move tasks.
Hovewer, the cpu load may change over time without moving tasks if a
task changes its behavior. A small task may enter a cpu intensive phase
and grow bigger over time while staying on the rq due to the load
tracking. That won't be noticed unless we check the cpuload
periodically. That is the reason behind this check.

I will look at remove the redundant call to inc_cpu_capacity() when
actually did move tasks. More work is needed on the policy for
inc/dec_cpu_capacity(). I just added a few easy examples of how they can
be used for this post.

Thanks,
Morten

> 
> Regards,
> Michael Wang
> 
> >  	power_late_callback(this_cpu);
> >  }
> >  
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 907a967..88e7968 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -1367,8 +1367,26 @@ static inline u64 irq_time_read(int cpu)
> >  
> >  #ifdef CONFIG_SCHED_POWER
> >  extern void power_late_callback(int cpu);
> > +extern int at_max_capacity(int cpu);
> > +extern int go_faster(int cpu, int hint);
> > +extern int go_slower(int cpu, int hint);
> >  #else
> >  static inline void power_late_callback(int cpu)
> >  {
> >  }
> > +
> > +static inline int at_max_capacity(int cpu)
> > +{
> > +	return 1;
> > +}
> > +
> > +static inline int go_faster(int cpu, int hint)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int go_slower(int cpu, int hint)
> > +{
> > +	return 0;
> > +}
> >  #endif /* CONFIG_SCHED_POWER */
> > 
> 
> 

