Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab3HUT0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:26:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3HUT0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:26:31 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=OUE5rmK-_tYA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fBi3oY-DbjoA:10 a=QyXUC8HyAAAA:8 a=QCxB0KMVAXah00B4MXMA:9 a=CjuIK1q_8ugA:10 a=dGJ0OcVc7YAA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 15:26:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Fei <fei.li@intel.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, rob@landley.net,
        chuansheng.liu@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] irq: add irq handler function name in ftrace
Message-ID: <20130821152630.242bba48@gandalf.local.home>
In-Reply-To: <1377056661.32321.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1377056661.32321.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Are you OK with this change?

-- Steve


On Wed, 21 Aug 2013 11:44:21 +0800
Li Fei <fei.li@intel.com> wrote:

> At present, irq handler function name is not printed out when
> irq_handler_entry is added into trace event, which is inconvenient
> for debugging.
> In order to improve the debugging efficiency, print out the handler
> function name in irq_handler_entry.
> 
> Signed-off-by: Li Fei <fei.li@intel.com>
> Acked-by: Liu Chuansheng <chuansheng.liu@intel.com>
> ---
>  Documentation/trace/ftrace.txt |    8 ++++----
>  include/trace/events/irq.h     |    5 ++++-
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index b937c6e..907ecbd 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -2701,10 +2701,10 @@ CPU:2 [LOST 11745 EVENTS]
>              bash-1998  [000] ..s2   138.733106: softirq_exit: vec=1 [action=TIMER]
>              bash-1998  [000] ..s2   138.733106: softirq_entry: vec=9 [action=RCU]
>              bash-1998  [000] ..s2   138.733109: softirq_exit: vec=9 [action=RCU]
> -            sshd-1995  [001] d.h1   138.733278: irq_handler_entry: irq=21 name=uhci_hcd:usb4
> -            sshd-1995  [001] d.h1   138.733280: irq_handler_exit: irq=21 ret=unhandled
> -            sshd-1995  [001] d.h1   138.733281: irq_handler_entry: irq=21 name=eth0
> -            sshd-1995  [001] d.h1   138.733283: irq_handler_exit: irq=21 ret=handled
> +            kworker/0:2-161  [001] d.h1   138.733278: irq_handler_entry: irq=17 name=i2c-designware-pci-7 func=i2c_dw_isr
> +            kworker/0:2-161  [001] d.h1   138.733280: irq_handler_exit: irq=17 ret=unhandled
> +            kworker/0:2-161  [001] d.h1   138.733281: irq_handler_entry: irq=17 name=mmc0 func=sdhci_irq
> +            kworker/0:2-161  [001] d.h1   138.733283: irq_handler_exit: irq=17 ret=handled
>  [...]
>  
>   # cat instances/zoot/trace
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index 1c09820..3497eb3 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -43,14 +43,17 @@ TRACE_EVENT(irq_handler_entry,
>  	TP_STRUCT__entry(
>  		__field(	int,	irq		)
>  		__string(	name,	action->name	)
> +		__field(irq_handler_t, func)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->irq = irq;
>  		__assign_str(name, action->name);
> +		__entry->func = action->handler;
>  	),
>  
> -	TP_printk("irq=%d name=%s", __entry->irq, __get_str(name))
> +	TP_printk("irq=%d name=%s func=%pf",
> +		__entry->irq, __get_str(name), __entry->func)
>  );
>  
>  /**

