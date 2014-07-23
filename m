Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbaGWOXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:23:19 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48362 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbaGWOXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:23:18 -0400
Date: Wed, 23 Jul 2014 07:23:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/16] rcu: Remove redundant check for online cpu
Message-ID: <20140723142314.GV11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-10-git-send-email-bobby.prani@gmail.com>
 <20140723122112.GJ11241@linux.vnet.ibm.com>
 <CAJhHMCAoLQPnJYCeqftXwZb6D4ECuJb4g04b4OO5BLf6iC1ENw@mail.gmail.com>
 <20140723135024.GR11241@linux.vnet.ibm.com>
 <CAJhHMCAZ__1xkEou44iux=Z6v6NAKPrTvWob6tqorm23nNygOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCAZ__1xkEou44iux=Z6v6NAKPrTvWob6tqorm23nNygOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072314-1344-0000-0000-00000302C9A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:12:54AM -0400, Pranith Kumar wrote:
> On Wed, Jul 23, 2014 at 9:50 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Wed, Jul 23, 2014 at 08:59:06AM -0400, Pranith Kumar wrote:
> >> On Wed, Jul 23, 2014 at 8:21 AM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Wed, Jul 23, 2014 at 01:09:46AM -0400, Pranith Kumar wrote:
> >> >> There are two checks for an online CPU if two if() conditions. This commit
> >> >> simplies this by replacing it with only one check for the online CPU.
> >> >>
> >> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >> >
> >> > I admit that it is very early in the morning my time, but I don't see
> >> > this change as preserving the semantics in all cases.  Please recheck
> >> > your changes to the second check.
> >> >
> >> >                                                         Thanx, Paul
> >>
> >> I guess you must be thrown off by the complementary checks, the first
> >> check is for cpu_online() and second is for cpu_is_offline(). :)
> >>
> >> Previously, if a cpu is offline, the first condition is false and the
> >> second condition is true, so we return from the second if() condition.
> >> The same semantics are being preserved.
> >
> > Fair enough!
> >
> > Nevertheless, I am not seeing this as a simplification.
> 
> I am not sure what you mean here, do you mean that both the checks are
> actually required?

I mean that the current compound tests each mean something.  Pulling out
the offline test adds lines of code and obscures that meaning.   This means
that it is easier (for me, anyway) to see why the current code is correct
than it is to see why your suggested change is correct.

							Thanx, Paul

> >> --
> >> Pranith.
> >>
> >>
> >>
> >> >
> >> >> ---
> >> >>  kernel/rcu/tree.c | 9 ++++++---
> >> >>  1 file changed, 6 insertions(+), 3 deletions(-)
> >> >>
> >> >> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> >> >> index 5dcbf36..8d598a2 100644
> >> >> --- a/kernel/rcu/tree.c
> >> >> +++ b/kernel/rcu/tree.c
> >> >> @@ -2602,15 +2602,18 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
> >> >>  {
> >> >>       bool needwake;
> >> >>
> >> >> +     if (!cpu_online(smp_processor_id()))
> >> >> +             return;
> >> >> +
> >> >>       /*
> >> >>        * If called from an extended quiescent state, invoke the RCU
> >> >>        * core in order to force a re-evaluation of RCU's idleness.
> >> >>        */
> >> >> -     if (!rcu_is_watching() && cpu_online(smp_processor_id()))
> >> >> +     if (!rcu_is_watching())
> >> >>               invoke_rcu_core();
> >> >>
> >> >> -     /* If interrupts were disabled or CPU offline, don't invoke RCU core. */
> >> >> -     if (irqs_disabled_flags(flags) || cpu_is_offline(smp_processor_id()))
> >> >> +     /* If interrupts were disabled, don't invoke RCU core. */
> >> >> +     if (irqs_disabled_flags(flags))
> >> >>               return;
> >> >>
> >> >>       /*
> >> >> --
> >> >> 2.0.0.rc2
> >> >>
> >> >
> >>
> >>
> >>
> >> --
> >> Pranith
> >>
> >
> 
> 
> 
> -- 
> Pranith
> 

