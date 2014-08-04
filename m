Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaHDKXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:23:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56060 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaHDKXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:23:04 -0400
Date: Mon, 4 Aug 2014 12:23:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, jan.kiszka@siemens.com,
        mingo@kernel.org, huawei.libin@huawei.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Message-ID: <20140804102301.GB4808@pd.tnic>
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 04:59:02PM +0800, Lan Tianyu wrote:
> Some test result shows cpu offline consumes more than 100ms during S3.
> After some researchs, found native_cpu_die() would fall into 100ms
> sleep if cpu idle loop thread marked cpu state slower. What native_cpu_die()
> does is that poll cpu state and wait for 100ms if cpu state hasn't been marked
> to DEAD. The 100ms sleep doesn't make sense. To avoid such long sleep, this
> patch is to add struct completion to each cpu, wait for the completion
> in the native_cpu_die() and wakeup the completion when the cpu state is
> marked to DEAD.

I like the general idea of not msleeping but using a completion but you
have to sell it to us. What test did you run before and what improvement
do you observe with this patch? Why do we care at all to apply it?

> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  arch/x86/kernel/smpboot.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 5492798..15d9d9f 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -102,6 +102,9 @@ DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
>  DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
>  EXPORT_PER_CPU_SYMBOL(cpu_info);
>  
> +DEFINE_PER_CPU(struct completion, die_complete);
> +
> +

one \n too many.

>  atomic_t init_deasserted;
>  
>  /*
> @@ -1331,7 +1334,7 @@ int native_cpu_disable(void)
>  		return ret;
>  
>  	clear_local_APIC();
> -
> +	init_completion(&per_cpu(die_complete, smp_processor_id()));
>  	cpu_disable_common();
>  	return 0;
>  }
> @@ -1339,18 +1342,16 @@ int native_cpu_disable(void)
>  void native_cpu_die(unsigned int cpu)
>  {
>  	/* We don't do anything here: idle task is faking death itself. */
> -	unsigned int i;
> +	wait_for_completion_timeout(&per_cpu(die_complete, cpu),
> +			msecs_to_jiffies(1000));

No need to break this line.

>  
> -	for (i = 0; i < 10; i++) {
> -		/* They ack this in play_dead by setting CPU_DEAD */
> -		if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
> -			if (system_state == SYSTEM_RUNNING)
> -				pr_info("CPU %u is now offline\n", cpu);
> -			return;
> -		}
> -		msleep(100);
> -	}
> -	pr_err("CPU %u didn't die...\n", cpu);
> +	/* They ack this in play_dead by setting CPU_DEAD */
> +	if (per_cpu(cpu_state, cpu) == CPU_DEAD) {
> +		if (system_state == SYSTEM_RUNNING)
> +			pr_info("CPU %u is now offline\n", cpu);
> +		return;

Superfluous "return".

> +	} else
> +		pr_err("CPU %u didn't die...\n", cpu);
>  }

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
