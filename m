Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3HRDCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 23:02:44 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51492 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3HRDCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 23:02:43 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 17 Aug 2013 20:02:34 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/9] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130818030234.GG28923@leaf>
References: <20130818014918.GA27827@linux.vnet.ibm.com>
 <1376790584-28120-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1376790584-28120-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376790584-28120-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 06:49:39PM -0700, Paul E. McKenney wrote:
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
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

One comment below.  With that change:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> +#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
> +
> +/*
> + * Initialize dynticks sysidle state for CPUs coming online.
> + */
> +static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> +{
> +	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
> +}
> +
> +#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> +
> +static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
> +{
> +}
> +
> +#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */

Just move the ifdef around the function body:

static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
{
#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
#endif /* CONFIG_NO_HZ_FULL_SYSIDLE */
}

- Josh Triplett
