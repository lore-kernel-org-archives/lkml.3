Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaFNL0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 07:26:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60007 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaFNL0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 07:26:46 -0400
Date: Sat, 14 Jun 2014 04:26:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140614112639.GA11022@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140613161630.GQ4581@linux.vnet.ibm.com>
 <20140613162130.GP6635@localhost.localdomain>
 <20140613164441.GA14232@thin>
 <20140613204822.GT4581@linux.vnet.ibm.com>
 <20140613211034.GA10651@jtriplet-mobl1>
 <20140613224926.GW4581@linux.vnet.ibm.com>
 <20140613231033.GR6635@localhost.localdomain>
 <20140613232715.GB4581@linux.vnet.ibm.com>
 <20140613233933.GT6635@localhost.localdomain>
 <20140614050606.GD4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614050606.GD4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061411-0928-0000-0000-000002B2B80D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:06:06PM -0700, Paul E. McKenney wrote:
> On Sat, Jun 14, 2014 at 01:39:36AM +0200, Frederic Weisbecker wrote:
> > On Fri, Jun 13, 2014 at 04:27:15PM -0700, Paul E. McKenney wrote:

[ . . . ]

> > > If I was to extend rcu_needs_cpu(), I would add a flag and another counter
> > > to the rcu_data structure.  If rcu_needs_cpu() saw the flag set and the
> > > counter equal to the current ->completed value, it would return true.
> > > 
> > > I already have the rcu_kick_nohz_cpu() in rcu_implicit_dynticks_qs(),
> > > so it is just a matter of also setting the flag and copying ->completed
> > > to the new counter at that point.  I currently get to this point if the
> > > CPU has managed to run for more than one jiffy without hitting either
> > > idle or userspace execution.  Fair enough?
> > 
> > Perfect for me!
> 
> One complication...  So if the grace period has gone on for a long time,
> and you are returning to kernel mode, RCU will need the scheduling-clock
> tick.  However, in that very same situation, if you are returning to
> idle or to NO_HZ_FULL userspace execution, RCU does -not- need the
> scheduling-clock tick set.
> 
> One way I could do this is to have rcu_needs_cpu() return three values:
> Zero for RCU doesn't need a scheduling-clock tick for any reason,
> one if RCU needs a scheduling-clock tick only if returning to kernel
> mode, and two if RCU unconditionally needs the scheduling-clock tick.
> Would that work, or is there a better approach?

You know, it just feels like RCU -should- be able to solve this
internally.  So if determining that you are returning to kernel mode is
at all inconvenient, give me a couple days to think this through.

							Thanx, Paul

