Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3HUNmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:42:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43038 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3HUNmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:42:11 -0400
Date: Wed, 21 Aug 2013 06:42:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
Message-ID: <20130821134204.GU29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
 <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com>
 <20130808204020.GA31127@linux.vnet.ibm.com>
 <5205B6FF.7060502@cn.fujitsu.com>
 <20130810150715.GF29406@linux.vnet.ibm.com>
 <20130821031727.GA21711@linux.vnet.ibm.com>
 <52143343.4090303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52143343.4090303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082113-2398-0000-0000-000001AFC1D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:25:55AM +0800, Lai Jiangshan wrote:
> On 08/21/2013 11:17 AM, Paul E. McKenney wrote:
> > On Sat, Aug 10, 2013 at 08:07:15AM -0700, Paul E. McKenney wrote:
> >> On Sat, Aug 10, 2013 at 11:43:59AM +0800, Lai Jiangshan wrote:
> > 
> > [ . . . ]
> > 
> >>> So I have to narrow the range of suspect locks. Two choices:
> >>> A) don't call rt_mutex_unlock() from rcu_read_unlock(), only call it
> >>>    from rcu_preempt_not_context_switch(). we need to rework these
> >>>    two functions and it will add complexity to RCU, and it also still
> >>>    adds some probability of deferring.
> >>
> >> One advantage of bh-disable locks is that enabling bh checks
> >> TIF_NEED_RESCHED, so that there is no deferring beyond that
> >> needed by bh disable.  The same of course applies to preempt_disable().
> >>
> >> So one approach is to defer when rcu_read_unlock_special() is entered
> >> with either preemption or bh disabled.  Your current set_need_resched()
> >> trick would work fine in this case.  Unfortunately, re-enabling interrupts
> >> does -not- check TIF_NEED_RESCHED, which is why we have latency problems
> >> in that case.  (Hence my earlier question about making self-IPI safe
> >> on all arches, which would result in an interrupt as soon as interrupts
> >> were re-enabled.)
> >>
> >> Another possibility is to defer only when preemption or bh are disabled
> >> on entry ro rcu_read_unlock_special(), but to retain the current
> >> (admittedly ugly) nesting rules for the scheduler locks.
> > 
> > Would you be willing to do a patch that deferred rt_mutex_unlock() in
> > the preempt/bh cases?  This of course does not solve the irq-disable
> > case, but it should at least narrow the problem to the scheduler locks.
> > 
> > Not a big hurry, given the testing required, this is 3.13 or 3.14 material,
> > I think.
> > 
> > If you are busy, no problem, I can do it, just figured you have priority
> > if you want it.
> 
> I'm writing a special rt_mutex_unlock() for rcu deboost only.
> I hope Steven accept it.

That would be very cool, though if I understand the requirements,
especially for -rt, very challenging.  Looking forward to seeing it!

							Thanx, Paul

