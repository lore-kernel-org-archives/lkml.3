Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbaLLUws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:52:48 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52367 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbaLLUwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:52:47 -0500
Date: Fri, 12 Dec 2014 12:52:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Igor Mammedov <imammedo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] smpboot: Check for successfull allocation of cpumask
 vars
In-Reply-To: <1418178872-14949-1-git-send-email-bobby.prani@gmail.com>
Message-ID: <alpine.DEB.2.10.1412121248480.2273@chino.kir.corp.google.com>
References: <1418178872-14949-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014, Pranith Kumar wrote:

> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 7a8f584..35bc3f1 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1083,6 +1083,7 @@ static void __init smp_cpu_index_default(void)
>  void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  {
>  	unsigned int i;
> +	bool ret = true;

It's better to put this in the scope of the for_each_possible_cpu() loop 
so we don't implicitly rely on the fact that we always assume this to 
remain true from the previous iteration if the implementation subsequently 
changes.

>  
>  	preempt_disable();
>  	smp_cpu_index_default();
> @@ -1096,9 +1097,23 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  
>  	current_thread_info()->cpu = 0;  /* needed? */
>  	for_each_possible_cpu(i) {
> -		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
> -		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> -		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
> +		ret &= zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
> +		ret &= zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> +		ret &= zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
> +
> +		if (!ret) {
> +			/* cpumask allocation failed, remove this and next cpus from
> +			 * possible/present/online/active masks
> +			 */

Please read Documentation/CodingStyle.

> +			pr_warn("cpumask allocation failed!\n");

This is unnecessary since zalloc_cpumask_var() failure will already report 
this incident and provide a stacktrace.

> +			for (; i < nr_cpu_ids; i = cpumask_next(i, &cpu_possible_mask)) {
> +				set_cpu_possible(i, false);
> +				set_cpu_active(i, false);
> +				set_cpu_online(i, false);
> +				set_cpu_present(i, false);
> +			}
> +			break;

Looks like a memory leak of some maps that may have been successfully 
allocated.

> +		}
>  	}
>  	set_cpu_sibling_map(0);
>  
