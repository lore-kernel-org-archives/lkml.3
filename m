Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbaKTNyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:54:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:31142 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755240AbaKTNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:54:27 -0500
Date: Thu, 20 Nov 2014 08:54:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] tracing: Fix race of function probes counting
Message-ID: <20141120085425.746a9224@gandalf.local.home>
In-Reply-To: <546DD445.5080108@hitachi.com>
References: <20141118134643.4b550ee4@gandalf.local.home>
	<546DD445.5080108@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 20:45:09 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> I have found a couple of typos, but basically, it looks OK.
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Grumble. I already pushed this to next so it's in my "no rebase" state.

But I can add another patch to do these updates.

> 
> > ---
> >  kernel/trace/trace_functions.c | 117 +++++++++++++++++++++++++++++++++--------
> >  1 file changed, 96 insertions(+), 21 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> > index a8e0c7666164..973db52eb070 100644
> > --- a/kernel/trace/trace_functions.c
> > +++ b/kernel/trace/trace_functions.c
> > @@ -261,37 +261,74 @@ static struct tracer function_trace __tracer_data =
> >  };
> >  
> >  #ifdef CONFIG_DYNAMIC_FTRACE
> > -static int update_count(void **data)
> > +static void update_traceon_count(void **data, int on)
> 
> btw, why don't you use bool instead of int?

Because I didn't think of it ;-)

Yeah, bool would be better.

> 
> >  {
> > -	unsigned long *count = (long *)data;
> > +	long *count = (long *)data;
> > +	long old_count = *count;
> >  
> > -	if (!*count)
> > -		return 0;
> > +	/*
> > +	 * Tracing gets disabled (or enabled) once per count.
> > +	 * This function can be called at the same time on mulitple CPUs.
>                                                            ^^^^^^^^ multiple

You know, that is probably the biggest typo I make. My fingers do not
like to hit 't' before 'i' when I type "multiple". In fact, it did it
just then (I had to go back and correct it)!

> 
> > +	 * It is fine if both disable (or enable) tracing, as disabling
> > +	 * (or enabling) the second time doesn't do anything as the
> > +	 * state of the tracer is already disabled (or enabled).
> > +	 * What needs to be synchronized in this case is that the count
> > +	 * only gets decremented once, even if the tracer is disabled
> > +	 * (or enabled) twice, as the second one is really a nop.
> > +	 *
> > +	 * The memory barriers guarantee that we only decrement the
> > +	 * counter once. First the count is read to a local variable
> > +	 * and a read barrier is used to make sure that it is loaded
> > +	 * before checking if the tracer is in the state we want.
> > +	 * If the tracer is not in the state we want, then the count
> > +	 * is guaranteed to be the old count.
> > +	 *
> > +	 * Next the tracer is set to the state we want (disabled or enabled)
> > +	 * then a write memory barrier is used to make sure that
> > +	 * the new state is visible before changing the counter by
> > +	 * one minus the old counter. This guarantees that another CPU
> > +	 * executing this code will see the new state before seeing
> > +	 * the new counter value, and would not do anthing if the new
>                                                    ^^^^^^^anything?

OK, will fix.

Thanks,

-- Steve

> 
> > +	 * counter is seen.
> > +	 *
> > +	 * Note, there is no synchronization between this and a user
> > +	 * setting the tracing_on file. But we currently don't care
> > +	 * about that.
> > +	 */
> > +	if (!old_count)
> > +		return;
> >  
> > -	if (*count != -1)
> > -		(*count)--;
> > +	/* Make sure we see count before checking tracing state */
> > +	smp_rmb();
> >  
> > -	return 1;
> > +	if (on == !!tracing_is_on())
> > +		return;
> > +
> > +	if (on)
> > +		tracing_on();
> > +	else
> > +		tracing_off();
> > +
> > +	/* unlimited? */
> > +	if (old_count == -1)
> > +		return;
> > +
> > +	/* Make sure tracing state is visible before updating count */
> > +	smp_wmb();
> > +
> > +	*count = old_count - 1;
> >  }
> >  
> >  static void
> >  ftrace_traceon_count(unsigned long ip, unsigned long parent_ip, void **data)
> >  {
> > -	if (tracing_is_on())
> > -		return;
> > -
> > -	if (update_count(data))
> > -		tracing_on();
> > +	update_traceon_count(data, 1);
> >  }
> >  
> >  static void
> >  ftrace_traceoff_count(unsigned long ip, unsigned long parent_ip, void **data)
> >  {
> > -	if (!tracing_is_on())
> > -		return;
> > -
> > -	if (update_count(data))
> > -		tracing_off();
> > +	update_traceon_count(data, 0);
> >  }
> >  
> >  static void
> > @@ -330,11 +367,49 @@ ftrace_stacktrace(unsigned long ip, unsigned long parent_ip, void **data)
> >  static void
> >  ftrace_stacktrace_count(unsigned long ip, unsigned long parent_ip, void **data)
> >  {
> > -	if (!tracing_is_on())
> > -		return;
> > +	long *count = (long *)data;
> > +	long old_count;
> > +	long new_count;
> >  
> > -	if (update_count(data))
> > -		trace_dump_stack(STACK_SKIP);
> > +	/*
> > +	 * Stack traces should only execute the number of times the
> > +	 * user specified in the counter.
> > +	 */
> > +	do {
> > +
> > +		if (!tracing_is_on())
> > +			return;
> > +
> > +		old_count = *count;
> > +
> > +		if (!old_count)
> > +			return;
> > +
> > +		/* unlimited? */
> > +		if (old_count == -1) {
> > +			trace_dump_stack(STACK_SKIP);
> > +			return;
> > +		}
> > +
> > +		new_count = old_count - 1;
> > +		new_count = cmpxchg(count, old_count, new_count);
> > +		if (new_count == old_count)
> > +			trace_dump_stack(STACK_SKIP);
> > +
> > +	} while (new_count != old_count);
> > +}
> > +
> > +static int update_count(void **data)
> > +{
> > +	unsigned long *count = (long *)data;
> > +
> > +	if (!*count)
> > +		return 0;
> > +
> > +	if (*count != -1)
> > +		(*count)--;
> > +
> > +	return 1;
> >  }
> >  
> >  static void
> > 
> 
> 

