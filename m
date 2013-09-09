Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3IIR50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:57:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59348 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab3IIR5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:57:24 -0400
Date: Mon, 9 Sep 2013 10:56:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Message-ID: <20130909175656.GF3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909134505.GF16280@somewhere>
 <20130909135656.GT3966@linux.vnet.ibm.com>
 <20130909101629.32df27a2@gandalf.local.home>
 <20130909161708.GX3966@linux.vnet.ibm.com>
 <20130909123422.7936e868@gandalf.local.home>
 <20130909165836.GB3966@linux.vnet.ibm.com>
 <20130909172908.GA31239@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909172908.GA31239@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090917-5806-0000-0000-000022ACA208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 01:29:08PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Sep 09, 2013 at 12:34:22PM -0400, Steven Rostedt wrote:
> [...]
> > > "rcu_is_ignored()" or "rcu_is_not_active()", "rcu_is_watching_you()"
> > 
> > You know, I am strongly tempted by "rcu_is_watching_you()", but I have
> > this feeling that it is too cute for its own good.  ;-)
> 
> Wow, I just got off the plane, and look at what happened to this thread
> ;-)

I had the same reaction when getting up this morning.  ;-)

> Referring to your earlier question Paul, what I meant by my earlier
> email on naming has been addressed by Steven: when exposing a new RCU
> API, even if it is just for in-kernel use, we should be really cautious
> not to tie it to implementation, but rather to concepts. Basically, my
> original thought is that we should be able to express the exact same
> concept in the kernel RCU implementation and in Userspace RCU. Here,
> binding the name on whether the CPU is watching RCU really makes no
> sense for urcu, since all the RCU flavors we currently have are watching
> threads, not CPUs.

More that that, userspace RCU doesn't have any energy management tie-ins.
It instead expects the application threads to invoke rcu_thread_offline()
when that thread goes idle and rcu_thread_offline() when the thread wakes
up again.  There is therefore less need for the application to query the
state because it was the application that set the state.

In contrast, within the Linux kernel, the RCU-watching state gets set
asynchronously with respect to in-kernel users of RCU.

Given the rest of the userspace RCU primitives, something like
rcu_thread_is_online() might make sense for the userspace RCU if some
application needs to know the state.  Or some other name that fits in
with rcu_thread_offline() and rcu_thread_online().  But such a name would
be problematic in the kernel due to CPU hotplug's use of those terms.

> Hence my proposal for "rcu_read_check()". It could be "rcu_is_active()"
> too, I don't really mind. It really minds: Is RCU actively watching the
> current execution context ? This can be translated to a runtime check
> too: is it safe to call rcu_read_lock() form this context ?

Although I do like rcu_is_active() better than rcu_read_check(), my
concern with rcu_is_active() is that it can easily be mistaken for a
global state rather than a per-CPU/thread/task/whatever state.

							Thanx, Paul

