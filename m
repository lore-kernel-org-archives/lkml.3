Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863AbaLNSNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:13:09 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49040 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaLNSNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:13:06 -0500
Date: Sun, 14 Dec 2014 10:13:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214181300.GD5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214164104.307127356@goodmis.org>
 <20141214164803.991954802@goodmis.org>
 <1556965801.27338.1418576749817.JavaMail.zimbra@efficios.com>
 <20141214121457.59b22354@gandalf.local.home>
 <20141214122136.1664e104@gandalf.local.home>
 <759389895.27358.1418578168225.JavaMail.zimbra@efficios.com>
 <20141214124431.48689d64@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214124431.48689d64@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121418-0025-0000-0000-000006EAD941
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 12:44:31PM -0500, Steven Rostedt wrote:
> On Sun, 14 Dec 2014 17:29:28 +0000 (UTC)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> > Given that your reason for having this RCU-specific logic in tracepoint.c
> > rather than within call_rcu*() is not slowing down a fast-path, how about
> > creating a new call_rcu_early() and call_rcu_sched_early() which can be
> > called in normal operation and at early boot ?
> 
> That's a possibility.
> 
> > 
> > This would allow us to keep the RCU logic within the RCU implementation
> > rather than strongly coupling it with the tracepoint code.
> > 
> 
> It's not that strong of a coupling to RCU. It's more coupled to being
> called really early (which needs special care).
> 
> It just happened that RCU failed for being called that early. Other
> things could possible fail too (if added to the tracepoint logic).
> Maybe I should rename the variable to "tracepoint_earlyboot" instead.

But you do have to call this quite early.  After rcu_init() is invoked,
things should work fine.

> But as RCU is the only thing that failed (so far in my testing), I'll
> think about adding a call_rcu_sched_early(). But then, this does make
> things more complex, and me more nervous about adding it.

I really am nervous about a call_rcu_sched_early() that immediately
invokes the specified callback.  That is just begging for someone to
invoke it while traversing a list in an RCU read-side critical section,
which will break.

My thought is to make the compiler initialize the pieces of RCU that
are needed.  That said, this initialization includes per-CPU variables,
so the question then becomes "when do per-CPU variables get initialized?"

							Thanx, Paul

