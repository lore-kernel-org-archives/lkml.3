Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab3G2Rxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:53:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33927 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3G2Rxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:53:39 -0400
Date: Mon, 29 Jul 2013 10:53:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 7/7] nohz_full: Force RCU's grace-period
 kthreads onto timekeeping CPU
Message-ID: <20130729175313.GR26694@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <51F5E325.4000607@cn.fujitsu.com>
 <20130729165253.GP26694@linux.vnet.ibm.com>
 <20130729165943.GA15686@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729165943.GA15686@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072917-7606-0000-0000-00000DC66E9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 06:59:46PM +0200, Frederic Weisbecker wrote:
> On Mon, Jul 29, 2013 at 09:52:53AM -0700, Paul E. McKenney wrote:
> > On Mon, Jul 29, 2013 at 11:36:05AM +0800, Lai Jiangshan wrote:
> > However, on small systems, rcu_sysidle_check_cpu() can be called from
> > the timekeeping CPU.  I suppose that this could potentially happen
> > before the first grace period starts, and in that case, we could
> > potentially see a spurious warning.  I could imagine a number of ways
> > to fix this:
> > 
> > 1.	Bind the kthread when it is created.
> > 
> > 2.	Bind the kthread when it first starts running, rather than just
> > 	after the grace period starts.
> > 
> > 3.	Suppress the warning when there is no grace period in progress.
> > 
> > 4.	Suppress the warning prior to the first grace period starting.
> > 
> > Seems like #3 is the most straightforward approach.  I just change it to:
> > 
> > 	if (rcu_gp_in_progress(rdp->rsp))
> > 		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
> > 
> > This still gets a WARN_ON_ONCE() if someone moves the timekeeping CPU,
> > but Frederic tells me that it never moves.  My WARN_ON_ONCE() has some
> > probability of complaining should some bug creep in.
> 
> It doesn't move for now but keep in mind that it will probably be able
> to move in the future. If we have several non full-dynticks CPUs, balancing
> the timekeeping duty between them, depending which one runs at a given time,
> may improve power savings even better.
> 
> But you can ignore that for now. Your patchset is entertaining enough that
> we don't need to add more complications yet ;)

Yeah, we will need some sort of handshake for that.  Might be a simple
as setting a flag that suppresses the warning, which I clear the next
time I bind the kthread.  Well, it would need to deal with closely-spaced
moves of the timekeeping duty, wouldn't it?  Plus it would need to deal
with the fact that sampling the variable referencing the timekeeping CPU,
sampling the current CPU, and binding the kthread cannot be done as one
big atomic operation.  Which means that their would need to be two calls
in the handshake, one to prepare to move the timekeeping CPU and another
to announce that it had in fact been moved.

Which is not too hard -- I use an irq-disable lock to guard setting and
clearing an internal-to-RCU flag noting the upcoming change.  The
check and WARN_ON_ONCE() are done while holding this same lock.  The
flag is cleared only after the kthread-bind operation that follows the
last "it has in fact been moved" handshake.  So the flag has three states,
idle, ready to move, and moved.  The possibility of closely spaced moves
of the timekeeping kthread are dealt with by transitioning from "moved"
to "ready to move".  The state goes back to "idle" only after completion
of a kthread-bind operation in the "moved" state.

So agreed, let's defer this one.  ;-)

							Thanx, Paul

