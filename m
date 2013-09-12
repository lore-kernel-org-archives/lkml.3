Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3ILLPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:15:08 -0400
Received: from multi.imgtec.com ([194.200.65.239]:61082 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab3ILLPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:15:06 -0400
Message-ID: <5231A233.1060900@imgtec.com>
Date: Thu, 12 Sep 2013 12:14:59 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [RFC PATCH v2 10/25] smp, metag: kill SMP single function call
 interrupt
References: <1378915649-16395-1-git-send-email-liuj97@gmail.com> <1378915649-16395-11-git-send-email-liuj97@gmail.com>
In-Reply-To: <1378915649-16395-11-git-send-email-liuj97@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_09_12_12_15_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/13 17:07, Jiang Liu wrote:
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

Seems to work.

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
>  arch/metag/include/asm/smp.h | 2 --
>  arch/metag/kernel/smp.c      | 6 +-----
>  2 files changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/metag/include/asm/smp.h b/arch/metag/include/asm/smp.h
> index e0373f8..1d7e770 100644
> --- a/arch/metag/include/asm/smp.h
> +++ b/arch/metag/include/asm/smp.h
> @@ -7,13 +7,11 @@
>  
>  enum ipi_msg_type {
>  	IPI_CALL_FUNC,
> -	IPI_CALL_FUNC_SINGLE,
>  	IPI_RESCHEDULE,
>  };
>  
>  extern void arch_send_call_function_single_ipi(int cpu);
>  extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
> -#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
>  
>  asmlinkage void secondary_start_kernel(void);
>  
> diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
> index 7c01131..5b3933b4 100644
> --- a/arch/metag/kernel/smp.c
> +++ b/arch/metag/kernel/smp.c
> @@ -491,7 +491,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
>  
>  void arch_send_call_function_single_ipi(int cpu)
>  {
> -	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
> +	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC);
>  }
>  
>  void show_ipi_list(struct seq_file *p)
> @@ -546,10 +546,6 @@ static int do_IPI(struct pt_regs *regs)
>  			generic_smp_call_function_interrupt();
>  			break;
>  
> -		case IPI_CALL_FUNC_SINGLE:
> -			generic_smp_call_function_single_interrupt();
> -			break;
> -
>  		default:
>  			pr_crit("CPU%u: Unknown IPI message 0x%lx\n",
>  				cpu, nextmsg);
> 

