Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaIZUzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:55:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59012 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbaIZUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:55:01 -0400
Date: Fri, 26 Sep 2014 13:54:56 -0700
From: Joonwoo Park <joonwoop@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 RESEND/RFC] timer: make deferrable cpu unbound timers
 really not bound to a cpu
Message-ID: <20140926205456.GA12742@codeaurora.org>
References: <1410836376-27267-1-git-send-email-joonwoop@codeaurora.org>
 <alpine.DEB.2.10.1409231808110.4604@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409231808110.4604@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 08:33:34PM +0200, Thomas Gleixner wrote:
> On Mon, 15 Sep 2014, Joonwoo Park wrote:
> > +#ifdef CONFIG_SMP
> > +static struct tvec_base *tvec_base_deferral = &boot_tvec_bases;
> > +#endif
> 
> In principle I like the idea of a deferrable wheel, but this
> implementation is going to go nowhere.
> 
> First of all making it SMP only is silly. The deferrable stuff is a
> pain in other places as well.
> 
> But whats way worse is:
> 
> > +static inline void __run_timers(struct tvec_base *base, bool try)
> >  {
> >  	struct timer_list *timer;
> >  
> > -	spin_lock_irq(&base->lock);
> > +	if (!try)
> > +		spin_lock_irq(&base->lock);
> > +	else if (!spin_trylock_irq(&base->lock))
> > +		return;
> 
> Yuck. All cpus fighting about a single spinlock roughly at the same
> time? You just created a proper thundering herd cacheline bouncing
> issue. 

Since __run_timers() for deferrable wheel do spin_lock_try() always, none of cpus would spin but just return if spinlock is already acquired.

I agree with cacheline bouncing issue of timer base (maybe you're worried about coherency of spinlock too?).
The other approach I thought about is the way that waking up cpus which has expired deferrable timer from active cpu rather than having global deferrable wheel.
I didn't go with this way because this sounds conflict with the idea of 'deferrable' and consumes more power compare to the patch I proposed.  Cache prefetching isn't free of power consumption either though.
What do you think about this approach?

Or I think we can migrate expired deferrable timers from idle cpu to active cpus but I doubt if this good idea as migration seems expensive.

> 
> No way. We have already mechanisms in place to deal with such
> problems, you just have to use them.

The problem I'm trying to tackle down is a case that a driver needs a deferrable delayed_work to prevent from waking up cpus because of that timer while it's still in need of making sure scheduling the deferrable timer in time if any of cpus are active.

Would you mind shed some lights on me about the mechanisms you're referring to?
I thought about queuing cpu bound deferrable timer to all cpus and cancel all others when any of them got scheduled, but this overkill.

Thanks,
Joonwoo

> 
> Thanks,
> 
> 	tglx

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
