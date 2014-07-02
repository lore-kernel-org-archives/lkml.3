Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaGBLpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:45:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:62723 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBLpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:45:53 -0400
Message-ID: <1404301549.18037.2.camel@marge.simpson.net>
Subject: Re: [PATCH] x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, bp@alien8.de,
        huawei.libin@huawei.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Date: Wed, 02 Jul 2014 13:45:49 +0200
In-Reply-To: <53B3A991.2070502@jp.fujitsu.com>
References: <53B3A991.2070502@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC Peter)

On Wed, 2014-07-02 at 15:41 +0900, Yasuaki Ishimatsu wrote: 
> llc_shared_mask is not cleared even if cpu is offline or hot removed.
> So when hot-plugging CPU, the mask has wrong value. The mask is used
> by CSF schduler. So it breaks CFS scheduler.
> 
> Here is a example on my system.
> My system has 4 sockets and each socket has 15 cores and HT is enabled.
> In this case, each core of sockes is numbered as follows:
> 
>          | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-44, 90-104
> Socket#3 | 45-59, 105-119
> 
> Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
> It means that cache of Socket#2 is shared with CPU#30-44 and 90-104.
> 
> When hot-removing socket#2 and #3, each core of sockets is numbered
> as follows:
> 
>          | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> 
> But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
> having 0x3fff80000001fffc0000000.
> 
> After that, when hot-adding socket#2 and #3, each core of sockets is
> numbered as follows:
> 
>          | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-59
> Socket#3 | 90-119
> 
> Then llc_shared_mask of CPU#30 becomes 0x3fff8000fffffffc0000000.
> It means that cache of Socket#2 is shared with CPU#30-59 and 90-104.
> So the mask has wrong value.
> 
> This patch fixes above problem by clearing llc_shared_mask bit of
> offlined cpu.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> ---
>  arch/x86/kernel/smpboot.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 5492798..893cd2b 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1279,6 +1279,7 @@ __init void prefill_possible_map(void)
>  static void remove_siblinginfo(int cpu)
>  {
>  	int sibling;
> +	int llc_shared;
>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
> 
>  	for_each_cpu(sibling, cpu_core_mask(cpu)) {
> @@ -1290,9 +1291,12 @@ static void remove_siblinginfo(int cpu)
>  			cpu_data(sibling).booted_cores--;
>  	}
> 
> +	for_each_cpu(llc_shared, cpu_llc_shared_mask(cpu))
> +		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(llc_shared));
>  	for_each_cpu(sibling, cpu_sibling_mask(cpu))
>  		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
>  	cpumask_clear(cpu_sibling_mask(cpu));
> +	cpumask_clear(cpu_llc_shared_mask(cpu));
>  	cpumask_clear(cpu_core_mask(cpu));
>  	c->phys_proc_id = 0;
>  	c->cpu_core_id = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


