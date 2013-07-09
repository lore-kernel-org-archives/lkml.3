Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3GIJmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:42:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51337 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3GIJmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:42:50 -0400
Date: Tue, 9 Jul 2013 11:37:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 2/7] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130709093728.GB17211@twins.programming.kicks-ass.net>
References: <20130709012934.GA26058@linux.vnet.ibm.com>
 <1373333406-26979-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1373333406-26979-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373333406-26979-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 06:30:01PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds fields to the rcu_dyntick structure that are used to
> detect idle CPUs.  These new fields differ from the existing ones in
> that the existing ones consider a CPU executing in user mode to be idle,
> where the new ones consider CPUs executing in user mode to be busy.
> The handling of these new fields is otherwise quite similar to that for
> the exiting fields.  This commit also adds the initialization required
> for these fields.
> 
> So, why is usermode execution treated differently, with RCU considering
> it a quiescent state equivalent to idle, while in contrast the new
> full-system idle state detection considers usermode execution to be
> non-idle?
> 
> It turns out that although one of RCU's quiescent states is usermode
> execution, it is not a full-system idle state.  This is because the
> purpose of the full-system idle state is not RCU, but rather determining
> when accurate timekeeping can safely be disabled.  Whenever accurate
> timekeeping is required in a CONFIG_NO_HZ_FULL kernel, at least one
> CPU must keep the scheduling-clock tick going.  If even one CPU is
> executing in user mode, accurate timekeeping is requires, particularly for
> architectures where gettimeofday() and friends do not enter the kernel.
> Only when all CPUs are really and truly idle can accurate timekeeping be
> disabled, allowing all CPUs to turn off the scheduling clock interrupt,
> thus greatly improving energy efficiency.
> 
> This naturally raises the question "Why is this code in RCU rather than in
> timekeeping?", and the answer is that RCU has the data and infrastructure
> to efficiently make this determination.

but but but but... why doesn't the regular nohz code qualify? I'd think
that too would be tracking pretty much the same things, no?
