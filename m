Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3IKUHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:07:25 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60365 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab3IKUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:07:18 -0400
Message-ID: <5230CC84.1010503@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 01:33:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Shaohua Li <shli@kernel.org>,
        linux-arch@vger.kernel.org, Jiri Kosina <trivial@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wang YanQing <udknight@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linuxppc-dev@lists.ozlabs.org,
        Jiang Liu <jiang.liu@huawei.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 15/25] smp, ppc: kill SMP single function call
 interrupt
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com> <1378915649-16395-16-git-send-email-liuj97@gmail.com>
In-Reply-To: <1378915649-16395-16-git-send-email-liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091119-4790-0000-0000-00000A446516
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 09:37 PM, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one interrupt
> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---

It turns out that freeing up the IPI slot in powerpc is very useful, since
we actually wanted a slot for some other use-case (and there are only 4 slots
available on powerpc).

Here are the patches which achieve that:
http://marc.info/?l=linuxppc-embedded&m=137886807502898&w=2
http://marc.info/?l=linuxppc-embedded&m=137886811502909&w=2

So, can you kindly consider dropping the powerpc patch from your series,
if that is OK with you? Thanks!

BTW, after doing the powerpc cleanup, even I had thought about killing one
of the smp-function variants in various architectures, but never got around
to do it. But now that you have posted the series which does that, I'll try
to review them.

Thank you!

Regards,
Srivatsa S. Bhat

>  arch/powerpc/include/asm/smp.h |  3 +--
>  arch/powerpc/kernel/smp.c      | 12 +-----------
>  2 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
> index 48cfc85..53faa03 100644
> --- a/arch/powerpc/include/asm/smp.h
> +++ b/arch/powerpc/include/asm/smp.h
> @@ -119,8 +119,7 @@ extern int cpu_to_core_id(int cpu);
>   * in /proc/interrupts will be wrong!!! --Troy */
>  #define PPC_MSG_CALL_FUNCTION   0
>  #define PPC_MSG_RESCHEDULE      1
> -#define PPC_MSG_CALL_FUNC_SINGLE	2
> -#define PPC_MSG_DEBUGGER_BREAK  3
> +#define PPC_MSG_DEBUGGER_BREAK  2
> 
>  /* for irq controllers that have dedicated ipis per message (4) */
>  extern int smp_request_message_ipi(int virq, int message);
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 38b0ba6..0c53b10 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -123,12 +123,6 @@ static irqreturn_t reschedule_action(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
> 
> -static irqreturn_t call_function_single_action(int irq, void *data)
> -{
> -	generic_smp_call_function_single_interrupt();
> -	return IRQ_HANDLED;
> -}
> -
>  static irqreturn_t debug_ipi_action(int irq, void *data)
>  {
>  	if (crash_ipi_function_ptr) {
> @@ -146,14 +140,12 @@ static irqreturn_t debug_ipi_action(int irq, void *data)
>  static irq_handler_t smp_ipi_action[] = {
>  	[PPC_MSG_CALL_FUNCTION] =  call_function_action,
>  	[PPC_MSG_RESCHEDULE] = reschedule_action,
> -	[PPC_MSG_CALL_FUNC_SINGLE] = call_function_single_action,
>  	[PPC_MSG_DEBUGGER_BREAK] = debug_ipi_action,
>  };
> 
>  const char *smp_ipi_name[] = {
>  	[PPC_MSG_CALL_FUNCTION] =  "ipi call function",
>  	[PPC_MSG_RESCHEDULE] = "ipi reschedule",
> -	[PPC_MSG_CALL_FUNC_SINGLE] = "ipi call function single",
>  	[PPC_MSG_DEBUGGER_BREAK] = "ipi debugger",
>  };
> 
> @@ -225,8 +217,6 @@ irqreturn_t smp_ipi_demux(void)
>  			generic_smp_call_function_interrupt();
>  		if (all & (1 << (24 - 8 * PPC_MSG_RESCHEDULE)))
>  			scheduler_ipi();
> -		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNC_SINGLE)))
> -			generic_smp_call_function_single_interrupt();
>  		if (all & (1 << (24 - 8 * PPC_MSG_DEBUGGER_BREAK)))
>  			debug_ipi_action(0, NULL);
>  #else
> @@ -257,7 +247,7 @@ EXPORT_SYMBOL_GPL(smp_send_reschedule);
> 
>  void arch_send_call_function_single_ipi(int cpu)
>  {
> -	do_message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
> +	do_message_pass(cpu, PPC_MSG_CALL_FUNCTION);
>  }
> 
>  void arch_send_call_function_ipi_mask(const struct cpumask *mask)
> 

