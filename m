Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3EUNZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:25:13 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50934
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886Ab3EUNZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:25:10 -0400
Date: Tue, 21 May 2013 11:45:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130521094531.GE26912@twins.programming.kicks-ass.net>
References: <20130413220943.GB29861@linux.vnet.ibm.com>
 <20130514122049.GH15942@dyad.programming.kicks-ass.net>
 <20130514141245.GA4442@linux.vnet.ibm.com>
 <20130514145119.GC19669@dyad.programming.kicks-ass.net>
 <20130514154728.GC4442@linux.vnet.ibm.com>
 <20130515085639.GD10510@laptop.programming.kicks-ass.net>
 <20130515090234.GE10510@laptop.programming.kicks-ass.net>
 <20130515173142.GL4442@linux.vnet.ibm.com>
 <20130516094519.GJ19669@dyad.programming.kicks-ass.net>
 <20130516132210.GV4442@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516132210.GV4442@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 06:22:10AM -0700, Paul E. McKenney wrote:
> > But somehow I imagined making a CPU part of the GP would be easier than taking
> > it out. After all, taking it out is dangerous and careful work, one is not to
> > accidentally execute a callback or otherwise end a GP before time.
> > 
> > When entering the GP cycle there is no such concern, the CPU state is clean
> > after all.
> 
> But that would increase the overhead of GP initialization.  Right now,
> GP initialization touches only the leaf rcu_node structures, of which
> there are by default one per 16 CPUs (and can be configured up to one per
> 64 CPUs, which it is on really big systems).  So on busy mixed-workload
> systems, this approach increases GP initialization overhead for no
> good reason -- and on systems running these sorts of workloads, there
> usually aren't "sacrificial lamb" timekeeping CPUs whose utilization
> doesn't matter.

Right, so I read through some of the fqs code to get a better feel for
things and I suppose I see what you're talking about :-)

The only thing I could come up with is making fqslock a global/local
style lock, so that individual CPUs can adjust their own state without
bouncing the lock around.

It would make the fqs itself a 'bit' more expensive but ideally those
don't happen that often, ha!.

But yeah, every time you let the fqs propagate 'idle' state up the tree
your join becomes more expensive too.
