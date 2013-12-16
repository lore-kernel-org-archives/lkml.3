Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3LPQKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:10:37 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:35168 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab3LPQKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:10:36 -0500
Date: Mon, 16 Dec 2013 08:10:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, davej@redhat.com,
        linux-tip-commits@vger.kernel.org, laijs@cn.fujitsu.com
Subject: Re: [tip:core/rcu] rcu: Break call_rcu() deadlock involving
 scheduler and perf
Message-ID: <20131216161031.GD4200@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-96d3fd0d315a949e30adc80f086031c5cdf070d1@git.kernel.org>
 <20131216152636.GX21999@twins.programming.kicks-ass.net>
 <20131216153248.GA4200@linux.vnet.ibm.com>
 <20131216154539.GY21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216154539.GY21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121616-1542-0000-0000-0000044E71CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 04:45:39PM +0100, Peter Zijlstra wrote:
> On Mon, Dec 16, 2013 at 07:32:48AM -0800, Paul E. McKenney wrote:
> > On Mon, Dec 16, 2013 at 04:26:36PM +0100, Peter Zijlstra wrote:
> > > On Mon, Dec 16, 2013 at 07:19:22AM -0800, tip-bot for Paul E. McKenney wrote:
> > > > The underlying problem is that perf is invoking call_rcu() with the
> > > > scheduler locks held, but in NOCB mode, call_rcu() will with high
> > > > probability invoke the scheduler -- which just might want to use its
> > > > locks.  The reason that call_rcu() needs to invoke the scheduler is
> > > > to wake up the corresponding rcuo callback-offload kthread, which
> > > > does the job of starting up a grace period and invoking the callbacks
> > > > afterwards.
> > > > 
> > > > One solution (championed on a related problem by Lai Jiangshan) is to
> > > > simply defer the wakeup to some point where scheduler locks are no longer
> > > > held.  Since we don't want to unnecessarily incur the cost of such
> > > > deferral, the task before us is threefold:
> > > > 
> > > > 1.	Determine when it is likely that a relevant scheduler lock is held.
> > > > 
> > > > 2.	Defer the wakeup in such cases.
> > > > 
> > > > 3.	Ensure that all deferred wakeups eventually happen, preferably
> > > > 	sooner rather than later.
> > > > 
> > > > We use irqs_disabled_flags() as a proxy for relevant scheduler locks
> > > > being held.  This works because the relevant locks are always acquired
> > > > with interrupts disabled.  We may defer more often than needed, but that
> > > > is at least safe.
> > > 
> > > This would also allow us to do away with things like the below patch,
> > > right?
> > 
> > It takes care of one problem, but there are others, including
> > rcu_read_unlock() inovking the scheduler to deboost itself.  So for the
> > moment, we still need the below patch.
> 
> Oh right, see I knew I was forgetting something... :-)

I am hoping to make your patch unnecessary, but it ain't trivial.  ;-)

We will get there!  Especially if I can find Lai Jiangshan's old patch
that reworked deboosting.  :-/

							Thanx, Paul

