Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3HEB0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 21:26:31 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48597 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab3HEB0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 21:26:30 -0400
Date: Mon, 5 Aug 2013 03:26:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 2/7] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130805012624.GC6894@somewhere>
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374880764-14248-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:19:19PM -0700, Paul E. McKenney wrote:
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

Right, and it's somehow disturbing that this code is in RCU but yeah the
infrastructure is there.

It would be perhaps more neat to have a specific RCU flavour for which the
only quiescent state is when the system is fully idle. But like you said
that's some overhead to iterate another RCU flavor, while we can reuse rcu
traditional flavour as an opportunity since it often handle callbacks
around. Too bad.

Anyway, Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.
