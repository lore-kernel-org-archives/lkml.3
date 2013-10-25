Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3JYIKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:10:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:54551 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751476Ab3JYIKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:10:15 -0400
Message-ID: <1382688595.6143.5.camel@pippen.local.home>
Subject: Re: [PATCH V2] ARM: trace: Add tracepoint for the Inter Processor
 Interrupt
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, shaojie.sun@linaro.org
Date: Fri, 25 Oct 2013 04:09:55 -0400
In-Reply-To: <526A145E.1010809@linaro.org>
References: <1381839042-3533-1-git-send-email-daniel.lezcano@linaro.org>
	 <526A145E.1010809@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 08:49 +0200, Daniel Lezcano wrote:
> On 10/15/2013 02:10 PM, Daniel Lezcano wrote:
> > The Inter Processor Interrupt is used on ARM to tell another processor to do
> > a specific action. This is mainly used to emulate a timer interrupt on an idle
> > cpu, force a cpu to reschedule or run a function on another processor context.
> >
> > Add a tracepoint when raising an IPI and in the entry/exit handler functions.
> >
> > When a cpu raises an IPI, the targeted cpus is an interesting information, the
> > cpumask conversion in hexa is added in the trace using the cpumask_scnprintf
> > function.
> >
> > Tested-on Vexpress TC2 (5 processors).
> >
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> Hi All,
> 
> does this patch sound good for inclusion ?

Ug, I never sent my email. It was half written and in my drafts folder.

I'll reply below.

> 
> Thanks in advance
> 
>    -- Daniel
> 
> > diff --git a/include/trace/events/ipi.h b/include/trace/events/ipi.h
> > new file mode 100644
> > index 0000000..80b734b
> > --- /dev/null
> > +++ b/include/trace/events/ipi.h
> > @@ -0,0 +1,104 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM ipi
> > +
> > +#if !defined(_TRACE_IPI_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_IPI_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +#define ipi_name(ipinr) { IPI_##ipinr, #ipinr }
> > +#define show_ipi_name(val)				\
> > +	__print_symbolic(val,				\
> > +			 ipi_name(WAKEUP),		\
> > +			 ipi_name(TIMER),		\
> > +			 ipi_name(RESCHEDULE),		\
> > +			 ipi_name(CALL_FUNC),		\
> > +			 ipi_name(CALL_FUNC_SINGLE),	\
> > +			 ipi_name(CPU_STOP))
> > +
> > +DECLARE_EVENT_CLASS(ipi,
> > +
> > +    TP_PROTO(int ipinr),
> > +
> > +    TP_ARGS(ipinr),
> > +
> > +    TP_STRUCT__entry(
> > +	    __field(int, ipinr)
> > +    ),
> > +
> > +    TP_fast_assign(
> > +	    __entry->ipinr = ipinr;
> > +    ),
> > +
> > +    TP_printk("ipi=%d, name=%s", __entry->ipinr,
> > +	      show_ipi_name(__entry->ipinr))
> > +);
> > +
> > +/**
> > + * ipi_handle_entry - called right before the IPI handler
> > + * @ipinr: the IPI number
> > + *
> > + * The @ipinr value must be valid and the action name associated with
> > + * the IPI value is given in the trace.
> > + */
> > +DEFINE_EVENT_CONDITION(ipi, ipi_handler_entry,
> > +
> > +    TP_PROTO(int ipinr),
> > +
> > +    TP_ARGS(ipinr),
> > +
> > +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0)
> > +);
> > +
> > +/**
> > + * ipi_handle_exit - called right after the IPI handler
> > + * @ipinr: the IPI number
> > + *
> > + * The @ipinr value must be valid and the action name associated with
> > + * the IPI value is given in the trace.
> > + */
> > +DEFINE_EVENT_CONDITION(ipi, ipi_handler_exit,
> > +
> > +    TP_PROTO(int ipinr),
> > +
> > +    TP_ARGS(ipinr),
> > +
> > +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0)
> > +);
> > +
> > +/**
> > + * ipi_raise - called when a smp cross call is made
> > + * @ipinr: the IPI number
> > + * @cpumask: the recipients for the IPI
> > + *
> > + * The @ipinr value must be valid and the action name associated with
> > + * the IPI value is given in the trace as well as the cpumask of the
> > + * targeted cpus.
> > + */
> > +TRACE_EVENT_CONDITION(ipi_raise,
> > +
> > +    TP_PROTO(const struct cpumask *cpumask, int ipinr),
> > +
> > +    TP_ARGS(cpumask, ipinr),
> > +
> > +    TP_CONDITION(ipinr < NR_IPI && ipinr >= 0),
> > +
> > +    TP_STRUCT__entry(
> > +	    __field(int, ipinr)
> > +	    __array(char, cpumask, NR_CPUS)
> > +    ),
> > +
> > +    TP_fast_assign(
> > +	    __entry->ipinr = ipinr;
> > +	    cpumask_scnprintf(__entry->cpumask,
> > +			      ARRAY_SIZE(__entry->cpumask), cpumask);

Please do not do the scnprintf() in the TP_fast_assign(). It's heavy
weight and this is done in the code path. Just copy the actual cpumask
itself.

Now, how to do that exactly is the reason I never sent my original mail,
because I never got around to looking how to do it, but it is possible.
Unfortunately, I'm at Kernel Summit at the moment, and still don't have
time to look at the best way to do it. But you can use dynamic arrays
for the cpus_online.

> > +    ),
> > +
> > +    TP_printk("ipi=%d, cpumask=0x%s, name=%s", __entry->ipinr, __entry->cpumask,
> > +	      show_ipi_name(__entry->ipinr))

Here is where you can convert the cpumask saved in the ring buffer to a
snprintf() format. Now this may need some work too, and perhaps even a
handler to help. I thought there was already some printk format that
does cpumasks.

If the helpers are not there, then I can work on adding some.

-- Steve


> > +);
> > +
> > +#endif /* _TRACE_IPI_H */
> > +
> > +/* This part must be outside protection */
> > +#include <trace/define_trace.h>
> >
> 
> 


