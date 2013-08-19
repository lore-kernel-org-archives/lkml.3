Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3HSBfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:35:08 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46912 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3HSBfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:35:06 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 18 Aug 2013 18:34:53 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/9] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130819013453.GA10868@leaf>
References: <20130818014918.GA27827@linux.vnet.ibm.com>
 <1376790584-28120-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376790584-28120-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818030234.GG28923@leaf>
 <20130819012229.GZ29406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819012229.GZ29406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 06:22:29PM -0700, Paul E. McKenney wrote:
> On Sat, Aug 17, 2013 at 08:02:34PM -0700, Josh Triplett wrote:
> > On Sat, Aug 17, 2013 at 06:49:39PM -0700, Paul E. McKenney wrote:
> > > +#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
> > > +
> > > +/*
> > > + * Initialize dynticks sysidle state for CPUs coming online.
> > > + */
> > > +static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> > > +{
> > > +	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
> > > +}
> > > +
> > > +#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> > > +
> > > +static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> > > +{
> > > +}
> > > +
> > > +#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> > 
> > Just move the ifdef around the function body:
> > 
> > static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> > {
> > #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
> > 	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
> > #endif /* CONFIG_NO_HZ_FULL_SYSIDLE */
> > }
> 
> This makes sense for this isolated function, and it would also
> make sense if the end result had only functions that were exported.
> But if I try to apply this to the result, I will end up with something
> like the following.  Is that really what you want?
> 
> I suppose I could individually enclose whole functions whose definitions
> are unneeded for CONFIG_NO_HZ_FULL_SYSIDLE=n, but that doesn't seem
> helpful either.
> 
> Thoughts?

I see what you mean.  Short of sorting the functions to put all the
unexported ones together, which seems suboptimal, I don't see an obvious
fix.  The result you posted isn't *terrible*, but it's not great either.

I had mostly hoped to avoid having two duplicate function headers that
would then both need changing whenever changing the function signature,
and which could then potentially get out of sync without causing a
compilation error.

I'd say that if you have a single-function block like the one above, you
should use the ifdef-body approach, but if you've got a group of
functions that don't all use one or the other approach, go ahead and
wrap the whole thing in one big ifdef rather than one per function.

Use whichever approach seems most sensible on a case-by-case basis; your
call.  Feel free to add a
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
to whichever approach you go with.

- Josh Triplett
