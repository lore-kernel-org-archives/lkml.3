Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3IIVkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:40:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40886 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755673Ab3IIVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:40:31 -0400
Date: Mon, 9 Sep 2013 17:40:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
	section?
Message-ID: <20130909214026.GA8830@Krystal>
References: <20130909130851.GC16280@somewhere> <20130909092142.05780991@gandalf.local.home> <20130909134505.GF16280@somewhere> <20130909135656.GT3966@linux.vnet.ibm.com> <20130909101629.32df27a2@gandalf.local.home> <20130909161708.GX3966@linux.vnet.ibm.com> <20130909123422.7936e868@gandalf.local.home> <20130909165836.GB3966@linux.vnet.ibm.com> <20130909172908.GA31239@Krystal> <20130909175656.GF3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909175656.GF3966@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Sep 09, 2013 at 01:29:08PM -0400, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Mon, Sep 09, 2013 at 12:34:22PM -0400, Steven Rostedt wrote:
> > [...]
> > > > "rcu_is_ignored()" or "rcu_is_not_active()", "rcu_is_watching_you()"
> > > 
> > > You know, I am strongly tempted by "rcu_is_watching_you()", but I have
> > > this feeling that it is too cute for its own good.  ;-)
> > 
> > Wow, I just got off the plane, and look at what happened to this thread
> > ;-)
> 
> I had the same reaction when getting up this morning.  ;-)
> 
> > Referring to your earlier question Paul, what I meant by my earlier
> > email on naming has been addressed by Steven: when exposing a new RCU
> > API, even if it is just for in-kernel use, we should be really cautious
> > not to tie it to implementation, but rather to concepts. Basically, my
> > original thought is that we should be able to express the exact same
> > concept in the kernel RCU implementation and in Userspace RCU. Here,
> > binding the name on whether the CPU is watching RCU really makes no
> > sense for urcu, since all the RCU flavors we currently have are watching
> > threads, not CPUs.
> 
> More that that, userspace RCU doesn't have any energy management tie-ins.

So far! ;)

> It instead expects the application threads to invoke rcu_thread_offline()
> when that thread goes idle and rcu_thread_offline() when the thread wakes
> up again.  There is therefore less need for the application to query the
> state because it was the application that set the state.
> 
> In contrast, within the Linux kernel, the RCU-watching state gets set
> asynchronously with respect to in-kernel users of RCU.
> 
> Given the rest of the userspace RCU primitives, something like
> rcu_thread_is_online() might make sense for the userspace RCU if some
> application needs to know the state.  Or some other name that fits in
> with rcu_thread_offline() and rcu_thread_online().

I think calling it "rcu_thread_is_online()" would actually give away
some of the implementation details. I would be tempted to go for
something along the lines of "rcu_is_online()".

> But such a name would
>be problematic in the kernel due to CPU hotplug's use of those terms.

The kernel has a clearly defined notion of "online cpu". I don't see the
semantic clash with "online rcu". Whenever the RCU machinery is not
observing an execution context, it is considered "offline". Whether this
is caused by an explicit call (e.g. rcu_thread_offline() for urcu) or
done internally (kernel dynticks) should not matter.

> 
> > Hence my proposal for "rcu_read_check()". It could be "rcu_is_active()"
> > too, I don't really mind. It really minds: Is RCU actively watching the
> > current execution context ? This can be translated to a runtime check
> > too: is it safe to call rcu_read_lock() form this context ?
> 
> Although I do like rcu_is_active() better than rcu_read_check(), my
> concern with rcu_is_active() is that it can easily be mistaken for a
> global state rather than a per-CPU/thread/task/whatever state.

Agreed. So how about rcu_is_online() ?

Thanks,

Mathieu

> 
> 							Thanx, Paul
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
