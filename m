Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3ENONN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:13:13 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60677 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3ENONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:13:12 -0400
Date: Tue, 14 May 2013 16:13:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86/sched/context_tracking: Call new
 schedule_preempt_user() from entry_64.S
Message-ID: <20130514141306.GB19719@somewhere>
References: <20130510211225.594959788@goodmis.org>
 <20130510211825.341015861@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510211825.341015861@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 05:12:26PM -0400, Steven Rostedt wrote:
> +/*
> + * This is a entry point to the scheduler() just before going
> + * back to user space. This is called with irqs disabled
> + * which prevents races with the CONTEXT_TRACKING updates.
> + */
> +asmlinkage void __sched schedule_preempt_user(void)
> +{
> +	enum ctx_state prev_state;
> +
> +	prev_state = exception_enter();
> +
> +	local_irq_enable();
> +	__schedule();
> +	local_irq_disable();
> +
> +	exception_exit(prev_state);
> +}

Ok I just had a look at how ARM and PPC64 are handling user preemption and it seems
that irqs are disabled around the call to schedule() on these archs too. Although
do_work_pending() in ARM surprisingly doesn't re-enable irqs before calling schedule?

Anyway having irqs disabled around user preemption seem to be a requirement to make
sure the TIF_NEED_RESCHED check is not racy against irqs and return to userspace.
So I guess we can keep the above function as it is.

But perhaps we should queue this for 3.11 given that it's a bit of a sensitive change
in the x86 user return path.

Look, I'm just going to make a seperate pull request with this patch based on 3.10-rc1
and let Ingo choose the target.

(Meanwhile I still think it would be a good idea to keep LOCKDEP_SYS_EXIT in the loop :-)

Thanks!
