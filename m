Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762591AbaGRUzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:55:46 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:58908 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762181AbaGRUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:55:45 -0400
Date: Fri, 18 Jul 2014 16:55:42 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/4] ARM: add IPI tracepoints
In-Reply-To: <20140718160418.54d11f6a@gandalf.local.home>
Message-ID: <alpine.LFD.2.11.1407181652080.3647@knanqh.ubzr>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org> <1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org> <20140718160418.54d11f6a@gandalf.local.home>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Steven Rostedt wrote:

> On Fri, 18 Jul 2014 01:18:53 -0400
> Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> 
>   
> > -#ifdef CONFIG_IRQ_WORK
> > -void arch_irq_work_raise(void)
> > -{
> > -	if (is_smp())
> > -		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
> > -}
> > +static const char *ipi_types[NR_IPI]
> > +#ifdef CONFIG_TRACING
> > +__tracepoint_string
> >  #endif
> 
> Oh, this is ugly. I should probably add a define when !CONFIG_TRACING
> is set. Something like:
> 
> #ifdef CONFIG_TRACING
> ...
> #else
> # define __tracepoint_string
> #endif
> 
> Such that users of __tracepoint_string don't need to add ugly ifdefs in
> the code.
> 
> If you want to add that to ftrace_event.h to this series, I'll ack it.

Here's the patch I have at the head of the series now, with the above
ugliness changed to an unconditional __tracepoint_string attribute.

From: Nicolas Pitre <nicolas.pitre@linaro.org>
Date: Fri, 18 Jul 2014 16:34:39 -0400
Subject: [PATCH] trace: don't refer __tracepoint_string to an undefined linker section

When CONFIG_TRACING is not set, the linker script doesn't specify any
__tracepoint_str section.  Let those __tracepoint_string marked strings
live in the default rodata section in that case.

Signed-off-by: Nicolas Pitre <nico@linaro.org>

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index cff3106ffe..d6346607e4 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -606,7 +606,11 @@ do {									\
 		static const char *___tp_str __tracepoint_string = str; \
 		___tp_str;						\
 	})
+#ifdef CONFIG_TRACING
 #define __tracepoint_string	__attribute__((section("__tracepoint_str")))
+#else
+#define __tracepoint_string
+#endif
 
 #ifdef CONFIG_PERF_EVENTS
 struct perf_event;
