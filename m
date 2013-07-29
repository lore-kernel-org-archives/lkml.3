Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3G2Q7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:59:51 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42682 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3G2Q7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:59:50 -0400
Date: Mon, 29 Jul 2013 18:59:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 7/7] nohz_full: Force RCU's grace-period
 kthreads onto timekeeping CPU
Message-ID: <20130729165943.GA15686@somewhere>
References: <20130726231848.GA12967@linux.vnet.ibm.com>
 <1374880764-14248-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1374880764-14248-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <51F5E325.4000607@cn.fujitsu.com>
 <20130729165253.GP26694@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729165253.GP26694@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 09:52:53AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 29, 2013 at 11:36:05AM +0800, Lai Jiangshan wrote:
> However, on small systems, rcu_sysidle_check_cpu() can be called from
> the timekeeping CPU.  I suppose that this could potentially happen
> before the first grace period starts, and in that case, we could
> potentially see a spurious warning.  I could imagine a number of ways
> to fix this:
> 
> 1.	Bind the kthread when it is created.
> 
> 2.	Bind the kthread when it first starts running, rather than just
> 	after the grace period starts.
> 
> 3.	Suppress the warning when there is no grace period in progress.
> 
> 4.	Suppress the warning prior to the first grace period starting.
> 
> Seems like #3 is the most straightforward approach.  I just change it to:
> 
> 	if (rcu_gp_in_progress(rdp->rsp))
> 		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
> 
> This still gets a WARN_ON_ONCE() if someone moves the timekeeping CPU,
> but Frederic tells me that it never moves.  My WARN_ON_ONCE() has some
> probability of complaining should some bug creep in.

It doesn't move for now but keep in mind that it will probably be able
to move in the future. If we have several non full-dynticks CPUs, balancing
the timekeeping duty between them, depending which one runs at a given time,
may improve power savings even better.

But you can ignore that for now. Your patchset is entertaining enough that
we don't need to add more complications yet ;)
