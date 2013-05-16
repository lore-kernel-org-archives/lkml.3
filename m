Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3EPXOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 19:14:31 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:63269 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3EPXOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 19:14:30 -0400
Date: Fri, 17 May 2013 01:14:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
Message-ID: <20130516231425.GA12928@somewhere>
References: <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
 <20130515150652.GP23604@redhat.com>
 <1368631622.6828.69.camel@gandalf.local.home>
 <20130515165915.GE13916@laptop.home>
 <1368637441.6828.70.camel@gandalf.local.home>
 <20130516081027.GD19669@dyad.programming.kicks-ass.net>
 <20130516150706.GY4442@linux.vnet.ibm.com>
 <20130516175602.GL19669@dyad.programming.kicks-ass.net>
 <1368729178.6828.105.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368729178.6828.105.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 02:32:58PM -0400, Steven Rostedt wrote:
> On Thu, 2013-05-16 at 19:56 +0200, Peter Zijlstra wrote:
> 
> > I suppose the fundamental question was: will receiving NMIs negate NO_HZ_FULL's
> > functionality? That is, will the getting of NMIs make us drop out of NO_HZ_FULL
> > and re-enable all sorts of things?
> 
> It shouldn't. The nmi_enter() notifies RCU that it can no longer ignore
> this CPU, where as nmi_enter() tells it that it can ignore it, as it has
> re-entered user space.
> 
> > 
> > Because clearly RCU needs to exit from EQS, which might (or might not) mean
> > leaving NO_HZ_FULL.
> 
> Yep, but the two are pretty much agnostic from each other.
> 
> We only need to leave NO_HZ_FULL if RCU (or anything for that matter)
> required having a tick again. But as Paul said, getting an NMI in idle
> wont restart the tick, so there's no need to restart it here either.
> 
> Now if an NMI were to do a call_rcu() then it would require a tick. But
> NMIs doing call_rcu() has much bigger issues to worry about ;-)

Actually even calling call_rcu() won't restart the tick because the callback
and the grace period lifecycle that come along are handled by the RCU nocb
kthreads. If you have migrated these kthreads accordingly this is handled in the
housekeeping CPU. Of course calling call_rcu() from an NMI involve more problems ;)

In fact we never need to restart the tick for RCU. Even round-trips in the kernel
that are potentially longer than irqs/nmis, such as IO syscalls/exception  are
fine because they are either actually short and quickly return to user mode, or they
sleep and go idle so the result is the same: RCU idle mode.

There is just a possible exception that is not yet completely handled: if
a task stays in the kernel too long without sleeping, it may extend a
grace period dangerously (there is no tick to report quiescent states).
In this case we should restart the tick. This is only half implemented
currently: RCU sends IPIs to CPUs that do these excessive grace periods
extensions. Just the CPU that receives that IPI doesn't yet detect the issue
and doesn't restart the tick. That's in the TODO list.
