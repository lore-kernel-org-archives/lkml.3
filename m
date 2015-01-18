Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbbARON1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:13:27 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:49093 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbARON0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:13:26 -0500
Date: Sun, 18 Jan 2015 15:13:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Vince Weaver <vince@deater.net>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: perf fuzzer crash [PATCH] perf: Get group events reference
 before moving the group
Message-ID: <20150118141321.GA17708@gmail.com>
References: <20150116075746.GB2658@krava.brq.redhat.com>
 <20150116104644.GW23965@worktop.programming.kicks-ass.net>
 <20150116141104.GD21958@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116141104.GD21958@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -42,6 +42,7 @@
>  #include <linux/module.h>
>  #include <linux/mman.h>
>  #include <linux/compat.h>
> +#include <linux/percpu-rwsem.h>
>  
>  #include "internal.h"
>  
> @@ -122,6 +123,42 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
>  	return data.ret;
>  }
>  
> +/*
> + * Required to migrate events between contexts.
> + *
> + * Migrating events between contexts is rather tricky; there is no real
> + * serialization around the perf_event::ctx pointer.
> + *
> + * So what we do is hold this rwsem over the remove_from_context and
> + * install_in_context. The remove_from_context ensures the event is inactive
> + * and will not be used from IRQ/NMI context anymore, and the remaining
> + * sites can acquire the rwsem read side.
> + */
> +static struct percpu_rw_semaphore perf_rwsem;
> +
> +static inline struct perf_event_context *perf_event_ctx(struct perf_event *event)
> +{
> +#ifdef CONFIG_LOCKDEP
> +	/*
> +	 * Assert the locking rules outlined above; in order to dereference
> +	 * event->ctx we must either be attached to the context or hold
> +	 * perf_rwsem.
> +	 *
> +	 * XXX not usable from IPIs because the lockdep held lock context
> +	 * will be wrong; maybe add trylock variants to the percpu_rw_semaphore
> +	 */
> +	WARN_ON_ONCE(!(event->attach_state & PERF_ATTACH_CONTEXT) ||
> +		     (debug_locks && !lockdep_is_held(&perf_rwsem.rw_sem)));
> +#endif
> +
> +	return event->ctx;
> +}
> +
> +static inline struct perf_event_context *__perf_event_ctx(struct perf_event *event)
> +{
> +	return event->ctx;
> +}


So if this approach is acceptable I'd also rename event->ctx to 
event->__ctx, to make sure it's not used accidentally without 
serialization in any old (or new) perf related patches.

Thanks,

	Ingo
