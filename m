Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbaEIPwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:52:45 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57696 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEIPwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:52:43 -0400
X-Originating-IP: 50.43.32.211
Date: Fri, 9 May 2014 08:52:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 01/45] rcutorture: Add forward-progress
 checking for writer
Message-ID: <20140509155230.GA4152@thin>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507211649.GA27924@cloud>
 <20140507234313.GP8754@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507234313.GP8754@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:43:13PM -0700, Paul E. McKenney wrote:
> On Wed, May 07, 2014 at 02:16:49PM -0700, josh@joshtriplett.org wrote:
> > On Mon, Apr 28, 2014 at 05:24:49PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > The rcutorture output currently does not distinguish between stalls in
> > > the RCU implementation and stalls in the rcu_torture_writer() kthreads.
> > > This commit therefore adds some diagnostics to help distinguish between
> > > these two conditions, at least for the non-SRCU implementations.  (SRCU
> > > does not provide evidence of update-side forward progress by design.)
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > The concept makes sense, and the writer state annotations seem like a
> > useful debugging mechanism, but having RCU know about RCU torture types
> > seems fundamentally wrong.  This mechanism accesses rcu_state, which is
> > already implementation-specific, so why not just only define the
> > function for the RCU implementations that support it, and then have a
> > function pointer in the torture-test structure to report a stall?
> 
> Ouch.  It is worse than that!  When running RCU-bh or RCU-sched,
> the current code incorrectly returns the statistics for RCU.
> So I do need some way for rcutorture to tell RCU which flavor
> it is testing.
> 
> One thing I could do would be to pass in a pointer to the call_rcu()
> function (cur_ops->call from rcutorture's viewpoint), then scan the
> rcu_state structures looking for the selected flavor (rsp->call from
> tree.c's viewpoint).  In the SRCU and RCU-busted cases, the flavor would
> not be found, and I could then just set everything to zero.
> 
> Does that seem reasonable, or is there a better way to do this?

That search seems rather too hackish; why not just declare one
stats-returning function per RCU flavor, and put the pointer to the
corresponding function in the structure for each test type?

- Josh Triplett
