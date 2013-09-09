Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3IILpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:45:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48695 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3IILpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:45:07 -0400
Date: Mon, 9 Sep 2013 13:44:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle
 balance
Message-ID: <20130909114453.GR31370@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
 <1377806736-3752-4-git-send-email-jason.low2@hp.com>
 <20130830101817.GE10002@twins.programming.kicks-ass.net>
 <20130830102941.GF10002@twins.programming.kicks-ass.net>
 <1378274579.3004.9.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378274579.3004.9.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 11:02:59PM -0700, Jason Low wrote:
> On Fri, 2013-08-30 at 12:29 +0200, Peter Zijlstra wrote:
> >  	rcu_read_lock();
> >  	for_each_domain(cpu, sd) {
> > +		/*
> > +		 * Decay the newidle max times here because this is a regular
> > +		 * visit to all the domains. Decay ~0.5% per second.
> > +		 */
> > +		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
> > +			sd->max_newidle_lb_cost =
> > +				(sd->max_newidle_lb_cost * 254) / 256;
> 
> I initially picked 0.5%, but after trying it out, it appears to decay very
> slowing when the max is at a high value. Should we increase the decay a
> little bit more? Maybe something like:
> 
> sd->max_newidle_lb_cost = (sd->max_newidle_lb_cost * 63) / 64;

So the half-life in either case is is given by:

  n = ln(1/2) / ln(x)

which gives 88 seconds for x := 254/256 or 44 seconds for x := 63/64.

I don't really care too much, but obviously something like:

 256*exp(ln(.5)/60) ~= 253

Is attractive ;-)

> > +		/*
> > +		 * Stop the load balance at this level. There is another
> > +		 * CPU in our sched group which is doing load balancing more
> > +		 * actively.
> > +		 */
> > +		if (!continue_balancing) {
> 
> Is "continue_balancing" named "balance" in older kernels?

Yeah, this patch crossed paths with a series remodeling the
load-balancer a bit, that should all be pushed-out to tip/master.

In particular see commit: 
  23f0d20 sched: Factor out code to should_we_balance()

> Here are the AIM7 results with the other 2 patches + this patch with the
> slightly higher decay value.

Just to clarify, 'this patch' is the one I sent?
