Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3JDQu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:50:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51334 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3JDQuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:50:55 -0400
Date: Fri, 4 Oct 2013 18:50:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, peter@hurleysoftware.com
Subject: Re: tty^Wrcu/perf lockdep trace.
Message-ID: <20131004165044.GV28601@twins.programming.kicks-ass.net>
References: <20131003190830.GA18672@redhat.com>
 <20131003194226.GO28601@twins.programming.kicks-ass.net>
 <20131003195832.GU5790@linux.vnet.ibm.com>
 <20131004065835.GP28601@twins.programming.kicks-ass.net>
 <20131004160352.GF5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004160352.GF5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 09:03:52AM -0700, Paul E. McKenney wrote:
> The problem exists, but NOCB made it much more probable.  With non-NOCB
> kernels, an irq-disabled call_rcu() invocation does a wake_up() only if
> there are more than 10,000 callbacks stacked up on the CPU.  With a NOCB
> kernel, the wake_up() happens on the first callback.

Oh I see.. so I was hoping this was some NOCB crackbrained damage we
could still 'fix'.

And that wakeup is because we moved grace-period advancing into
kthreads, right?

> I am not too happy about the complexity of deferring, but maybe it is
> the right approach, at least assuming perf isn't going to whack me
> with a timer lock.  ;-)

I'm not too thrilled about trying to move the call_rcu() usage either.

> Any other approaches that I am missing?

Probably; so the regular no-NOCB would be easy to work around by
providing me a call_rcu variant that never does the wakeup.

NOCB might be a little more difficult; depending on the reason why it
needs to do this wakeup on every single invocation; that seems
particularly expensive.

Man, RCU was so much easier when all it was was a strict per-cpu state
with timer-interrupt driven state machine; non of all this nonsense.
