Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbaFVEYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 00:24:14 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:36308 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaFVEYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 00:24:13 -0400
Message-ID: <1403411049.5115.28.camel@marge.simpson.net>
Subject: Re: Latency histogram broken after "hrtimer: Set expiry time before
 switch_hrtimer_base()"
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Sun, 22 Jun 2014 06:24:09 +0200
In-Reply-To: <1403410224.5115.26.camel@marge.simpson.net>
References: <1403399065.23472.77.camel@deadeye.wl.decadent.org.uk>
	 <1403410224.5115.26.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCs stable -rt maintainer)

On Sun, 2014-06-22 at 06:10 +0200, Mike Galbraith wrote: 
> On Sun, 2014-06-22 at 02:04 +0100, Ben Hutchings wrote: 
> > In an rt-kernel with CONFIG_MISSED_TIMER_OFFSETS_HIST enabled,
> > __hrtimer_start_range_ns() now crashes, as new_base is not assigned
> > before it is used.
> 
> Oh yeah, forgot about this.
> 
> > I'm not sure how this should be fixed; is it:
> 
> My (3.12-ish tree) merge resolution was the later, but it shouldn't
> matter which you choose, what's stored where is unchanged pre/post.
> 
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -1108,7 +1108,7 @@ int __hrtimer_start_range_ns(struct hrti
> >  
> >  #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
> >  	{
> > -		ktime_t now = new_base->get_time();
> > +		ktime_t now = base->get_time();
> >  
> >  		if (ktime_to_ns(tim) < ktime_to_ns(now))
> >  			timer->praecox = now;
> > --- END ---
> > 
> > or:
> > 
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -1106,6 +1106,11 @@ int __hrtimer_start_range_ns(struct hrti
> >  #endif
> >  	}
> >  
> > +	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
> > +
> > +	/* Switch the timer base, if necessary: */
> > +	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
> > +
> >  #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
> >  	{
> >  		ktime_t now = new_base->get_time();
> > @@ -1117,11 +1122,6 @@ int __hrtimer_start_range_ns(struct hrti
> >  	}
> >  #endif
> >  
> > -	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
> > -
> > -	/* Switch the timer base, if necessary: */
> > -	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
> > -
> >  	timer_stats_hrtimer_set_start_info(timer);
> >  
> >  	leftmost = enqueue_hrtimer(timer, new_base);
> > --- END ---
> > 
> > or something else?
> > 
> > Ben.
> > 
> 
> 


