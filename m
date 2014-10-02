Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaJBMQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:16:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:56175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbaJBMP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:15:59 -0400
Date: Thu, 2 Oct 2014 14:15:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, ilya.dryomov@inktank.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141002121553.GB6324@worktop.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <1411633803.15810.12.camel@marge.simpson.net>
 <20140925090619.GA5430@worktop>
 <20140925091556.GB5430@worktop>
 <20141002102251.GA6324@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002102251.GA6324@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 12:22:51PM +0200, Peter Zijlstra wrote:
> Subject: audit,wait: Fixup kauditd_thread wait loop
> 
> The kauditd_thread wait loop is a bit iffy; it has a number of problems:
> 
>  - calls try_to_freeze() before schedule(); you typically want the
>    thread to re-evaluate the sleep condition when unfreezing, also
>    freeze_task() issues a wakeup.
> 
>  - it unconditionally does the {add,remove}_wait_queue(), even when the
>    sleep condition is false.
> 
> Introduce a new wait_event() variant, wait_event_freezable() that does
> all the right things and employ it here.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Eric Paris <eparis@redhat.com>
> Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  include/linux/wait.h |   25 +++++++++++++++++++++++++
>  kernel/audit.c       |   11 +----------
>  2 files changed, 26 insertions(+), 10 deletions(-)
> 
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -266,6 +266,31 @@ do {									\
>  	__wait_event(wq, condition);					\
>  } while (0)
>  
> +#define __wait_event_freezable(wq, condition)				\
> +	(void)___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	\
> +			    schedule(); try_to_freeze())
> +
> +/**
> + * wait_event - sleep until a condition gets true or freeze (for kthreads)
> + * @wq: the waitqueue to wait on
> + * @condition: a C expression for the event to wait for
> + *
> + * The process is put to sleep (TASK_INTERRUPTIBLE -- so as not to contribute
> + * to system load) until the @condition evaluates to true. The
> + * @condition is checked each time the waitqueue @wq is woken up.
> + *
> + * wake_up() has to be called after changing any variable that could
> + * change the result of the wait condition.
> + */
> +#define wait_event_freezable(wq, condition)				\
> +do {									\
> +	WARN_ON_ONCE(!(current->flags & PF_KTHREAD));			\
> +	might_sleep();							\
> +	if (condition)							\
> +		break;							\
> +	__wait_event_freezable(wq, condition);				\
> +} while (0)
> +
>  #define __wait_event_timeout(wq, condition, timeout)			\
>  	___wait_event(wq, ___wait_cond_timeout(condition),		\
>  		      TASK_UNINTERRUPTIBLE, 0, timeout,			\

Bah, that doesn't compile, because there already appears to be one,
hidden in freezer.h. Now I can't actually tell if it does the same thing
or not.

Rafael?
