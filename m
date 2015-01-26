Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbbAZVND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:13:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbbAZVNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:13:00 -0500
Date: Mon, 26 Jan 2015 19:12:31 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Cc: Clark Williams <clark.williams@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] timer: upper bound on loops of __run_timers
 processing
Message-ID: <20150126211231.GA32649@amt.cnet>
References: <20141230195228.GA3057@amt.cnet>
 <20150114172147.GA16570@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114172147.GA16570@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ping ?

On Wed, Jan 14, 2015 at 03:21:47PM -0200, Marcelo Tosatti wrote:
> 
> Ping?
> 
> On Tue, Dec 30, 2014 at 05:52:28PM -0200, Marcelo Tosatti wrote:
> > 
> > Commit "timers: do not raise softirq unconditionally", allows for timer
> > wheel processing (__run_timers) to be delayed for long periods of time.
> > 
> > The effect is that 
> > 
> > loops = jiffies - base->timer_jiffies
> > 
> > Can grow to very large values resulting in __run_timers taking hundreds
> > of milliseconds to execute.
> > 
> > Fix by creating an upper bound on the number of loops to be processed.
> > This allows a nohz=off kernel to achieve desired latencies.
> > 
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > 
> > diff --git a/kernel/timer.c b/kernel/timer.c
> > index f59e18c..c128416 100644
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -1488,6 +1488,12 @@ void run_local_timers(void)
> >  	}
> >  #endif
> >  
> > +	if (time_after_eq(jiffies, base->timer_jiffies)) {
> > +		unsigned long jiffies_delta = jiffies - base->timer_jiffies;
> > +		if (jiffies_delta > TVR_SIZE)
> > +			raise_softirq(TIMER_SOFTIRQ);
> > +	}
> > +
> >  	if (!base->active_timers)
> >  		goto out;
> >  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
