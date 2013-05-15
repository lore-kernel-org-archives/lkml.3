Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3EOBjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 21:39:03 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:40003 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3EOBjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 21:39:01 -0400
Message-ID: <1368581930.2618.109.camel@ThinkPad-T5421>
Subject: Re: [PATCH 1/3] x86/sched/context_tracking: Call new
 schedule_preempt_user() from entry_64.S
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 15 May 2013 09:38:50 +0800
In-Reply-To: <20130514141306.GB19719@somewhere>
References: <20130510211225.594959788@goodmis.org>
	 <20130510211825.341015861@goodmis.org> <20130514141306.GB19719@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051501-9574-0000-0000-000007DF4B9C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 16:13 +0200, Frederic Weisbecker wrote:
> On Fri, May 10, 2013 at 05:12:26PM -0400, Steven Rostedt wrote:
> > +/*
> > + * This is a entry point to the scheduler() just before going
> > + * back to user space. This is called with irqs disabled
> > + * which prevents races with the CONTEXT_TRACKING updates.
> > + */
> > +asmlinkage void __sched schedule_preempt_user(void)
> > +{
> > +	enum ctx_state prev_state;
> > +
> > +	prev_state = exception_enter();
> > +
> > +	local_irq_enable();
> > +	__schedule();
> > +	local_irq_disable();
> > +
> > +	exception_exit(prev_state);
> > +}
> 
> Ok I just had a look at how ARM and PPC64 are handling user preemption and it seems
> that irqs are disabled around the call to schedule() on these archs too. Although
> do_work_pending() in ARM surprisingly doesn't re-enable irqs before calling schedule?
> 
> Anyway having irqs disabled around user preemption seem to be a requirement to make
> sure the TIF_NEED_RESCHED check is not racy against irqs and return to userspace.
> So I guess we can keep the above function as it is.
> 
> But perhaps we should queue this for 3.11 given that it's a bit of a sensitive change
> in the x86 user return path.
> 
> Look, I'm just going to make a seperate pull request with this patch based on 3.10-rc1
> and let Ingo choose the target.

Could the deletion of schedule_user() be separated to another patch. So
for other archs, such as ppc64, we could have both
schedule_preempt_user() and schedule_user() there for the conversion?

Or are there some better ways to avoid the conflict with arch trees? 

Thanks, Zhong

> 
> (Meanwhile I still think it would be a good idea to keep LOCKDEP_SYS_EXIT in the loop :-)
> 
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


