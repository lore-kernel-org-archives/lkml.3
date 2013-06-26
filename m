Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab3FZOXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:23:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53291 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab3FZOWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:22:53 -0400
Date: Wed, 26 Jun 2013 07:16:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Rojhalat Ibrahim <imr@rtschenk.de>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: Regression in RCU subsystem in latest mainline kernel
Message-ID: <20130626141617.GJ3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130614122800.GL5146@linux.vnet.ibm.com>
 <1645938.As0LR1yeVd@pcimr>
 <1371243967.9844.338.camel@gandalf.local.home>
 <1371261741.21896.20.camel@pasglop>
 <20130617074213.GA3589@concordia>
 <20130619040906.GA5146@linux.vnet.ibm.com>
 <20130625071914.GA29957@concordia>
 <20130625074422.GB29957@concordia>
 <20130625160332.GA3828@linux.vnet.ibm.com>
 <20130626081057.GB10796@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626081057.GB10796@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062614-2876-0000-0000-00000A3BF966
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 06:10:58PM +1000, Michael Ellerman wrote:
> On Tue, Jun 25, 2013 at 09:03:32AM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 25, 2013 at 05:44:23PM +1000, Michael Ellerman wrote:
> > > On Tue, Jun 25, 2013 at 05:19:14PM +1000, Michael Ellerman wrote:
> > > > 
> > > > Here's another trace from 3.10-rc7 plus a few local patches.
> > > 
> > > And here's another with CONFIG_RCU_CPU_STALL_INFO=y in case that's useful:
> > > 
> > > PASS running test_pmc5_6_overuse()
> > > INFO: rcu_sched self-detected stall on CPU
> > > 	8: (1 GPs behind) idle=8eb/140000000000002/0 softirq=215/220 
> > 
> > So this CPU has been out of action since before the beginning of the
> > current grace period ("1 GPs behind").  It is not idle, having taken
> > a pair of nested interrupts from process context (matching the stack
> > below).  This CPU has take five softirqs since the last grace period
> > that it noticed, which makes it likely that the loop is within the
> > softirq handler.
> > 
> > > 	 (t=2100 jiffies g=18446744073709551583 c=18446744073709551582 q=13)
> > 
> > Assuming HZ=100, this stall has been going on  for 21 seconds.  There
> > is a grace period in progress according to RCU's global state (which
> > this CPU is not yet aware of).  There are a total of 13 RCU callbacks
> > queued across the entire system.
> > 
> > If the system is at all responsive, I suggest using ftrace (either from
> > the boot command line or at runtime) to trace __do_softirq() and
> > hrtimer_interrupt().
> 
> Thanks for decoding it Paul.
> 
> I've narrowed down the test case and I think this is probably just a
> case of too many perf interrupts. If I reduce the sampling period by
> half the test runs fine.
> 
> There is logic in perf to detect an interrupt storm, but for some reason
> it's not saving us. I'll dig in there, but I don't think it's an RCU
> problem.

Whew!  ;-)

							Thanx, Paul

