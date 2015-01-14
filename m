Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbbANRl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:41:56 -0500
Received: from smtprelay0001.hostedemail.com ([216.40.44.1]:56451 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257AbbANRlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:41:55 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:6261:7875:7903:10004:10400:10848:10967:11026:11232:11658:11914:12050:12296:12517:12519:12555:12740:13069:13311:13357:14093:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: actor21_2d7920ab89129
X-Filterd-Recvd-Size: 2382
Date: Wed, 14 Jan 2015 12:41:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] timer: upper bound on loops of __run_timers
 processing
Message-ID: <20150114124151.48d9ca69@gandalf.local.home>
In-Reply-To: <20150114172147.GA16570@amt.cnet>
References: <20141230195228.GA3057@amt.cnet>
	<20150114172147.GA16570@amt.cnet>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 15:21:47 -0200
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> 
> Ping?
> 

Sorry, I've fallen behind since the holidays and still trying to catch
up. I'll try to look at this this week.

-- Steve

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

