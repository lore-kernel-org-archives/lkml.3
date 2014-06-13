Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaFMUs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:48:29 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45926 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaFMUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:48:28 -0400
Date: Fri, 13 Jun 2014 13:48:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613204822.GT4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
 <20140613012432.GH4581@linux.vnet.ibm.com>
 <20140613013515.GA9589@linux.vnet.ibm.com>
 <20140613124714.GC6635@localhost.localdomain>
 <20140613155233.GM4581@linux.vnet.ibm.com>
 <20140613160002.GL6635@localhost.localdomain>
 <20140613161630.GQ4581@linux.vnet.ibm.com>
 <20140613162130.GP6635@localhost.localdomain>
 <20140613164441.GA14232@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613164441.GA14232@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061320-9332-0000-0000-0000011750B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 09:44:41AM -0700, Josh Triplett wrote:
> On Fri, Jun 13, 2014 at 06:21:32PM +0200, Frederic Weisbecker wrote:
> > On Fri, Jun 13, 2014 at 09:16:30AM -0700, Paul E. McKenney wrote:
> > > > Is it because we have dynticks CPUs staying too long in the kernel without
> > > > taking any quiescent states? Are we perhaps missing some rcu_user_enter() or
> > > > things?
> > > 
> > > Sort of the former, but combined with the fact that in-kernel CPUs still
> > > need scheduling-clock interrupts for RCU to make progress.  I could
> > > move this to RCU's context-switch hook, but that could be very bad for
> > > workloads that do lots of context switching.
> > 
> > Or I can restart the tick if the CPU stays in the kernel for too long without
> > a tick. I think that's what we were doing before but we removed that because
> > we never implemented it correctly (we sent scheduler IPI that did nothing...)
> 
> I wonder if timer slack would make sense here: when you have at least
> one RCU callback pending, set a timer with a huge amount of timer slack,
> and cancel it if you end up handling the callback via a trip through the
> scheduler.

But in this case, we need the tick even if the current CPU has no callbacks
because it might be in an RCU read-side critical section.

							Thanx, Paul

