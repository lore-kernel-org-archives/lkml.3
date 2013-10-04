Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab3JDQWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:22:48 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48185 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3JDQWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:22:46 -0400
Date: Fri, 4 Oct 2013 09:22:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131004162242.GI5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131003184001.GM28601@twins.programming.kicks-ass.net>
 <20131003184719.GA11996@redhat.com>
 <20131003192135.GR5790@linux.vnet.ibm.com>
 <20131003193206.GA17796@redhat.com>
 <20131003193319.GB17796@redhat.com>
 <20131003195026.GT5790@linux.vnet.ibm.com>
 <20131003200002.GA23768@redhat.com>
 <20131003211009.GA4127@redhat.com>
 <20131003220057.GY5790@linux.vnet.ibm.com>
 <20131004112945.GB5699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004112945.GB5699@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100416-1344-0000-0000-0000022ABBB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 01:29:45PM +0200, Oleg Nesterov wrote:
> On 10/03, Paul E. McKenney wrote:
> >
> > On Thu, Oct 03, 2013 at 11:10:09PM +0200, Oleg Nesterov wrote:
> > >
> > > rcusync: introduce rcu_sync_struct->exclusive mode
> > >
> > > CHANGELOG.
> >
> > Should the changelog really be in all caps?  (Sorry, couldn't resist...)
> 
> Apparently you do not realize it is going to be an EXCELLENT changelog!

;-)

> > > @@ -53,9 +55,13 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
> > >  	if (need_sync) {
> > >  		rss->ops->sync();
> > >  		rss->gp_state = GP_PASSED;
> > > -		wake_up_all(&rss->gp_wait);
> > > +		if (!rss->exclusive)
> > > +			wake_up_all(&rss->gp_comp.wait);
> >
> > Not sure about the wake_up_all() on a completion,
> 
> Yes, we reuse completion->wait in the !exclusive case. Like we reuse
> its spinlock as rss_lock.
> 
> We can add a completion/complete union, but this will complicate the
> code a bit and imo doesn't make sense.

Fair enough!

							Thanx, Paul

> > but if we are exclusive,
> > don't we need to complete() the completion here?
> 
> No, if we are exclusive we should delay the "wake up the next writer"
> till rcu_sync_exit().
> 
> > Oh, I guess gp_comp.wait is exactly a wait_queue_head_t, so I guess
> > you can do wake_up_all() on it...
> 
> Yes, and we never "mix" completion/wait_queue_head_t operations/members.
> IOW, we always use ->gp_comp if "exclusive", and only ->gp_comp.wait is
> used otherwise.
> 
> > Never mind!!!
> 
> Agreed ;)
> 
> Oleg.
> 

