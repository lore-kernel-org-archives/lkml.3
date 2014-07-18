Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbaGRUE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:04:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:42652 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755035AbaGRUE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:04:27 -0400
Date: Fri, 18 Jul 2014 16:04:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/4] ARM: add IPI tracepoints
Message-ID: <20140718160418.54d11f6a@gandalf.local.home>
In-Reply-To: <1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org>
References: <1405660735-13408-1-git-send-email-nicolas.pitre@linaro.org>
	<1405660735-13408-3-git-send-email-nicolas.pitre@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014 01:18:53 -0400
Nicolas Pitre <nicolas.pitre@linaro.org> wrote:

  
> -#ifdef CONFIG_IRQ_WORK
> -void arch_irq_work_raise(void)
> -{
> -	if (is_smp())
> -		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
> -}
> +static const char *ipi_types[NR_IPI]
> +#ifdef CONFIG_TRACING
> +__tracepoint_string
>  #endif

Oh, this is ugly. I should probably add a define when !CONFIG_TRACING
is set. Something like:

#ifdef CONFIG_TRACING
...
#else
# define __tracepoint_string
#endif

Such that users of __tracepoint_string don't need to add ugly ifdefs in
the code.

If you want to add that to ftrace_event.h to this series, I'll ack it.

-- Steve


> -
> -static const char *ipi_types[NR_IPI] = {
> += {
>  #define S(x,s)	[x] = s
>  	S(IPI_WAKEUP, "CPU wakeup interrupts"),
>  	S(IPI_TIMER, "Timer broadcast interrupts"),
> @@ -473,6 +457,12 @@ static const char *ipi_types[NR_IPI] = {
>  	S(IPI_COMPLETION, "completion interrupts"),
>  };
>  
