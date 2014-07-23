Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbaGWP56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:57:58 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49853 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaGWP54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:57:56 -0400
Date: Wed, 23 Jul 2014 17:57:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running
 for non-nohz_full= CPUs
Message-ID: <20140723155742.GB23175@localhost.localdomain>
References: <20140719165350.GA18411@linux.vnet.ibm.com>
 <20140719180120.GA20887@localhost.localdomain>
 <20140720114759.GO8690@linux.vnet.ibm.com>
 <20140720203417.GV9918@twins.programming.kicks-ass.net>
 <20140721155741.GW8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721155741.GW8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
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

Exactly, like you said on a further post, tick_nohz_full_enabled() is
the magic you need :)

> 
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
> 
> There have been some people saying that they want only a subset of
> their CPUs in nohz_full= state, and these guys seem to want to run a
> mixed workload.  For example, they have HPC (or RT) workloads on the
> nohz_full= CPUs, and also want normal high-throughput processing on the
> remaining CPUs.  If software was trivial (and making other unlikely
> assumptions about the perfection of the world and the invalidity of
> Murphy's lawy), we would want the timekeeping CPU to be able to move
> among the non-nohz_full= CPUs.
> 
> However, this should be a small fraction of the users, and many of
> these guys would probably be open to making a few changes.  Thus, a
> less-proactive approach should allow us to solve their actual problems, as
> opposed to the problems that we speculate that they might encounter.  ;-)

Sounds pretty good way of doing things!

> 							Thanx, Paul
> 
