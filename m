Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3JDG6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:58:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39071 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab3JDG6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:58:46 -0400
Date: Fri, 4 Oct 2013 08:58:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131004065835.GP28601@twins.programming.kicks-ass.net>
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003195832.GU5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 12:58:32PM -0700, Paul E. McKenney wrote:
> On Thu, Oct 03, 2013 at 09:42:26PM +0200, Peter Zijlstra wrote:
> > 
> > That's not tty; that's RCU..
> > 
> > On Thu, Oct 03, 2013 at 03:08:30PM -0400, Dave Jones wrote:
> > >  ======================================================
> > >  [ INFO: possible circular locking dependency detected ]
> > >  3.12.0-rc3+ #92 Not tainted
> > >  -------------------------------------------------------
> > >  trinity-child2/15191 is trying to acquire lock:
> > >   (&rdp->nocb_wq){......}, at: [<ffffffff8108ff43>] __wake_up+0x23/0x50
> > >  
> > > but task is already holding lock:
> > >   (&ctx->lock){-.-...}, at: [<ffffffff81154c19>] perf_event_exit_task+0x109/0x230
> > > 
> > > which lock already depends on the new lock.
> > > 
> > > 
> > > the existing dependency chain (in reverse order) is:
> > > 
> > > -> #3 (&ctx->lock){-.-...}:
> > >  
> > > -> #2 (&rq->lock){-.-.-.}:
> > >  
> > > -> #1 (&p->pi_lock){-.-.-.}:
> > >  
> > > -> #0 (&rdp->nocb_wq){......}:
> 
> I suppose I could defer the ->nocb_wq wakeup until the next context switch
> or transition to idle/userspace, but it might be simpler for put_ctx()
> to maintain a per-CPU chain of callbacks which are kfree_rcu()ed when
> ctx->lock is dropped.  Also easier on the kernel/user and kernel/idle
> transition overhead/latency...
> 
> Other thoughts?

What's caused this? We've had that kfree_rcu() in there for ages. I need
to audit all the get/put_ctx calls anyway for an unrelated issue but I
fear its going to be messy to defer that kfree_rcu() call, but I can
try.


