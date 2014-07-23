Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaGWQXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:23:53 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:64641 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaGWQXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:23:52 -0400
Date: Wed, 23 Jul 2014 18:23:48 +0200
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
Message-ID: <20140723162346.GE23175@localhost.localdomain>
References: <20140719165350.GA18411@linux.vnet.ibm.com>
 <20140719180120.GA20887@localhost.localdomain>
 <20140720114759.GO8690@linux.vnet.ibm.com>
 <20140720203417.GV9918@twins.programming.kicks-ass.net>
 <20140721155741.GW8690@linux.vnet.ibm.com>
 <20140721170459.GP3935@laptop>
 <20140721173306.GA8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721173306.GA8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 10:33:06AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 21, 2014 at 07:04:59PM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 21, 2014 at 08:57:41AM -0700, Paul E. McKenney wrote:
> > > On Sun, Jul 20, 2014 at 10:34:17PM +0200, Peter Zijlstra wrote:
> > > > On Sun, Jul 20, 2014 at 04:47:59AM -0700, Paul E. McKenney wrote:
> > > > > So we really have to have -all- the CPUs be idle to turn off the timekeeper.
> > > > 
> > > > That seems to be pretty unavoidable any which way around.
> > > 
> > > Hmmm...  The exception would be the likely common case where none of
> > > the CPUs are flagged as nohz_full= CPUs.  If we handled that case as
> > > if CONFIG_NO_HZ_FULL=n, we would have handled almost all of
> > > the problem.
> > 
> > You mean that is not currently the case? Yes that seems like a fairly
> > sane thing to do.
> 
> Hard to say -- need to see where Frederic is putting the call to
> rcu_sys_is_idle().  On the RCU side, I could potentially lower overhead
> by checking tick_nohz_full_enabled() in a few functions.

Yeah you definetly can.

Just put this in the very beginning of rcu_sys_is_idle():

            if (tick_nohz_full_enabled())
                return true;

That imply perhaps a more appropriate name like rcu_sys_need_timekeeper(),
with inverted condition.
