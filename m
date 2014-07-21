Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbaGURFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:05:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818AbaGURFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:05:15 -0400
Date: Mon, 21 Jul 2014 19:04:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running
 for non-nohz_full= CPUs
Message-ID: <20140721170459.GP3935@laptop>
References: <20140719165350.GA18411@linux.vnet.ibm.com>
 <20140719180120.GA20887@localhost.localdomain>
 <20140720114759.GO8690@linux.vnet.ibm.com>
 <20140720203417.GV9918@twins.programming.kicks-ass.net>
 <20140721155741.GW8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721155741.GW8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 08:57:41AM -0700, Paul E. McKenney wrote:
> On Sun, Jul 20, 2014 at 10:34:17PM +0200, Peter Zijlstra wrote:
> > On Sun, Jul 20, 2014 at 04:47:59AM -0700, Paul E. McKenney wrote:
> > > So we really have to have -all- the CPUs be idle to turn off the timekeeper.
> > 
> > That seems to be pretty unavoidable any which way around.
> 
> Hmmm...  The exception would be the likely common case where none of
> the CPUs are flagged as nohz_full= CPUs.  If we handled that case as
> if CONFIG_NO_HZ_FULL=n, we would have handled almost all of
> the problem.

You mean that is not currently the case? Yes that seems like a fairly
sane thing to do.

> > > This won't make the battery-powered embedded guys happy...
> > > 
> > > Other thoughts on this?  We really should not be setting
> > > CONFIG_NO_HZ_FULL_SYSIDLE by default until this is solved.
> > 
> > What are those same guys doing with nohz_full to begin with?
> 
> If CONFIG_NO_HZ_FULL_SYSIDLE=y is the default, my main concern is for
> people who didn't really want it, and who thus did not set the nohz_full=
> boot parameter.  Hence my suggestion above that we treat that case as
> if CONFIG_NO_HZ_FULL=n (and thus also as if CONFIG_NO_HZ_FULL_SYSIDLE=n).

ack

> There have been some people saying that they want only a subset of
> their CPUs in nohz_full= state, and these guys seem to want to run a
> mixed workload.  For example, they have HPC (or RT) workloads on the
> nohz_full= CPUs, and also want normal high-throughput processing on the
> remaining CPUs.  If software was trivial (and making other unlikely
> assumptions about the perfection of the world and the invalidity of
> Murphy's lawy), we would want the timekeeping CPU to be able to move
> among the non-nohz_full= CPUs.

Yeah, I don't see a problem with that, but then I'm not entirely sure
why we use RCU to track system idle state.

> However, this should be a small fraction of the users, and many of
> these guys would probably be open to making a few changes.  Thus, a
> less-proactive approach should allow us to solve their actual problems, as
> opposed to the problems that we speculate that they might encounter.  ;-)

But you still haven't talked about the battery people... I don't think
nohz_full is something they should care about / use.
