Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaBJCtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:49:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:7303 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbaBJCt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:49:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,815,1384329600"; 
   d="scan'208";a="472511436"
Message-ID: <52F83E34.8030305@intel.com>
Date: Mon, 10 Feb 2014 10:49:24 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
CC: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com
Subject: Re: [PATCH v1 01/10] perf/x86/uncore: fix initialization of cpumask
References: <1391432142-18723-1-git-send-email-eranian@google.com> <1391432142-18723-2-git-send-email-eranian@google.com>
In-Reply-To: <1391432142-18723-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

why not something like below. I think it's simpler.

---
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 29c2487..169ef4a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3799,9 +3799,6 @@ static int __init uncore_cpu_init(void)
 			ivt_uncore_cbox.num_boxes = max_cores;
 		msr_uncores = ivt_msr_uncores;
 		break;
-
-	default:
-		return 0;
 	}
 
 	ret = uncore_types_init(msr_uncores);


Regards
Yan, Zheng


On 02/03/2014 08:55 PM, Stephane Eranian wrote:
> On certain processors, the uncore PMU boxes may only be
> msr-bsed or PCI-based. But in both cases, the cpumask,
> suggesting on which CPUs to monitor to get full coverage
> of the particular PMU, must be created.
> 
> However with the current code base, the cpumask was only
> created on processor which had at least one MSR-based
> uncore PMU. This patch removes that restriction and
> ensures the cpumask is created even when there is no
> msr-based PMU. For instance, on SNB client where only
> a PCI-based memory controller PMU is supported.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c |   61 +++++++++++++++----------
>  1 file changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 29c2487..fe4255b 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -3764,7 +3764,7 @@ static void __init uncore_cpu_setup(void *dummy)
>  
>  static int __init uncore_cpu_init(void)
>  {
> -	int ret, cpu, max_cores;
> +	int ret, max_cores;
>  
>  	max_cores = boot_cpu_data.x86_max_cores;
>  	switch (boot_cpu_data.x86_model) {
> @@ -3808,29 +3808,6 @@ static int __init uncore_cpu_init(void)
>  	if (ret)
>  		return ret;
>  
> -	get_online_cpus();
> -
> -	for_each_online_cpu(cpu) {
> -		int i, phys_id = topology_physical_package_id(cpu);
> -
> -		for_each_cpu(i, &uncore_cpu_mask) {
> -			if (phys_id == topology_physical_package_id(i)) {
> -				phys_id = -1;
> -				break;
> -			}
> -		}
> -		if (phys_id < 0)
> -			continue;
> -
> -		uncore_cpu_prepare(cpu, phys_id);
> -		uncore_event_init_cpu(cpu);
> -	}
> -	on_each_cpu(uncore_cpu_setup, NULL, 1);
> -
> -	register_cpu_notifier(&uncore_cpu_nb);
> -
> -	put_online_cpus();
> -
>  	return 0;
>  }
>  
> @@ -3859,6 +3836,41 @@ static int __init uncore_pmus_register(void)
>  	return 0;
>  }
>  
> +static void uncore_cpumask_init(void)
> +{
> +	int cpu;
> +
> +	/*
> +	 * ony invoke once from msr or pci init code
> +	 */
> +	if (!cpumask_empty(&uncore_cpu_mask))
> +		return;
> +
> +	get_online_cpus();
> +
> +	for_each_online_cpu(cpu) {
> +		int i, phys_id = topology_physical_package_id(cpu);
> +
> +		for_each_cpu(i, &uncore_cpu_mask) {
> +			if (phys_id == topology_physical_package_id(i)) {
> +				phys_id = -1;
> +				break;
> +			}
> +		}
> +		if (phys_id < 0)
> +			continue;
> +
> +		uncore_cpu_prepare(cpu, phys_id);
> +		uncore_event_init_cpu(cpu);
> +	}
> +	on_each_cpu(uncore_cpu_setup, NULL, 1);
> +
> +	register_cpu_notifier(&uncore_cpu_nb);
> +
> +	put_online_cpus();
> +}
> +
> +
>  static int __init intel_uncore_init(void)
>  {
>  	int ret;
> @@ -3877,6 +3889,7 @@ static int __init intel_uncore_init(void)
>  		uncore_pci_exit();
>  		goto fail;
>  	}
> +	uncore_cpumask_init();
>  
>  	uncore_pmus_register();
>  	return 0;
> 

