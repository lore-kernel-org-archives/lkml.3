Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaCBMCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 07:02:38 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39152 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaCBMCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 07:02:37 -0500
Message-ID: <53131DBE.7020500@linaro.org>
Date: Sun, 02 Mar 2014 07:02:06 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/14] uprobes: Add uprobes support for ARM
References: <1392017945-4507-1-git-send-email-dave.long@linaro.org> <20140301123026.GD21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140301123026.GD21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg,

I've been looking at arch/Kconfig and kernel/trace/Kconfig where they 
deal with uprobes.  The relevant items are CONFIG_UPROBES and 
CONFIG_UPROBE_EVENT.  It just doesn't look right to me.  It looks like 
"select" is used in part maybe just to avoid the recursive dependency 
error that would be generated if "depends on" were used in both places. 
However I don't think UPROBES should be dependent on UPROBE_EVENT, only 
the other way around.  As RK noted in previous email (copied in part 
below) the select does not pull in the lower level dependencies.  This 
all works on x86 only because arch/x86/Kconfig defines CONFIG_PERF_EVENT 
(which feels like a big hammer).  We don't need to do this on ARM, and 
we don't do it.  The result is that, unless PERF_EVENT is set 
separately, uprobes tends not to build.  I was lucking-out in my testing 
due to other default config items turning on PERF_EVENT.

What do you think about the following patch?:

> diff --git a/arch/Kconfig b/arch/Kconfig
> index 80bbb8c..8793066 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -87,7 +87,8 @@ config KPROBES_ON_FTRACE
>
>  config UPROBES
>  	bool "Transparent user-space probes (EXPERIMENTAL)"
> -	depends on UPROBE_EVENT && PERF_EVENTS
> +	depends on ARCH_SUPPORTS_UPROBES
> +	depends on PERF_EVENTS
>  	default n
>  	select PERCPU_RWSEM
>  	help
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 015f85a..7d2647e 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -422,9 +422,8 @@ config KPROBE_EVENT
>
>  config UPROBE_EVENT
>  	bool "Enable uprobes-based dynamic events"
> -	depends on ARCH_SUPPORTS_UPROBES
>  	depends on MMU
> -	select UPROBES
> +	depends on UPROBES
>  	select PROBE_EVENTS
>  	select TRACING
>  	default n


This removes the pseudo-recursive dependency.  The downside is that now 
you have to set PERF_EVENTS to use UPROBES, and UPROBES to use 
UPROBE_EVENT, whereas before on x86 you only had to set UPROBE_EVENT (as 
long as PERF_EVENTS stays hardcoded on). I think this could be avoided 
by making each "depends on" a "selects", since they apply transitively. 
  I'm sensing this would be an unpopular idea though.

-dl



On 03/01/14 07:30, Russell King - ARM Linux wrote:

[ ... ]

> Clearly, it doesn't make sense for UPROBES to be enabled with PERF_EVENTS
> disabled - and indeed the Kconfig ensures that this dependency is properly
> expressed:
>
> 	config UPROBES
> 	        bool "Transparent user-space probes (EXPERIMENTAL)"
> 	        depends on UPROBE_EVENT && PERF_EVENTS
> 	        default n
> 	        select PERCPU_RWSEM
>
> but where this all falls down is here:
>
> 	config UPROBE_EVENT
> 	        bool "Enable uprobes-based dynamic events"
> 	        depends on ARCH_SUPPORTS_UPROBES
> 	        depends on MMU
> 	        select UPROBES
> 	        select PROBE_EVENTS
> 	        select TRACING
> 	        default n
>
> Which is yet another brilliant example of why this "select" crap is soo
> evil.  Yes, the failing configuration has:
>
> 	CONFIG_UPROBE_EVENT=y
>
> Ineed, there was a Kconfig warning:
>
> 	warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENT && PERF_EVENTS)
>
> This is not your fault.  It's the fault of everyone who passed through
> commit f3f096cfedf8113380c56fc855275cc75cd8cf55 without properly reviewing
> it and paying attention to that select crap.  Given how evil "select" is,
> it's something which should always be thoroughly reviewed - with analysis
> of the dependencies.  I believe commits which introduce new select
> statements should document an analysis of why those new select statements
> are appropriate and how they ensure that any dependencies of the selected
> symbol are not violated.
>
> Therefore, I will not take the ARM uprobes code while this kind of
> select abortion is present - it needs to be fixed first to avoid these
> build errors.  Sorry.
>

