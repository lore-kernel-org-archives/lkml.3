Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3EKBgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 21:36:35 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53358 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3EKBgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 21:36:33 -0400
Date: Sat, 11 May 2013 03:36:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86/sched/context_tracking: Call new
 schedule_preempt_user() from entry_64.S
Message-ID: <20130511013629.GE13340@somewhere>
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

So since it's only ever called right before resuming to userspace and after
the user_exit() call from the end of the syscall/exception/irq code,
you can use user_enter()/user_exit() directly.

I'm also wondering if this assumption that irqs are disabled by the time
we do user preemption is x86-centric or not. May be we can wait for complains
from those who'll port it...
