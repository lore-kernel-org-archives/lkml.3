Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbaGVSno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:43:44 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:43198 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGVSnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:43:43 -0400
Message-ID: <1406054032.24809.2.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3] x86,cpu-hotplug: assign same CPU number to readded
 CPU
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@alien8.de,
        gong.chen@linux.intel.com, tony.luck@intel.com, x86@kernel.org,
        imammedo@redhat.com, huawei.libin@huawei.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, umgwanakikbuti@gmail.com,
        peterz@infradead.org
Date: Tue, 22 Jul 2014 12:33:52 -0600
In-Reply-To: <53C77C2B.1030000@jp.fujitsu.com>
References: <53C77C2B.1030000@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2014-07-17 at 16:32 +0900, Yasuaki Ishimatsu wrote:
> llc_shared_map is not cleared even if CPU is offline or hot removed.
> So when hot-plugging CPU and assigning new CPU number to hot-added CPU,
> the mask has wrong value. The mask is used by CSF schduler to create
> sched_domain. So it breaks CFS scheduler.
> 
> Here is a example on my system.
> My system has 4 sockets and each socket has 15 cores and HT is enabled.
> In this case, each core of sockes is numbered as follows:
> 
>           | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-44, 90-104
> Socket#3 | 45-59, 105-119
> 
> Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
> It means that last level cache of Socket#2 is shared with
> CPU#30-44 and 90-104.
> 
> When hot-removing socket#2 and #3, each core of sockets is numbered
> as follows:
> 
>           | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> 
> But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
> having 0x3fff80000001fffc0000000.
> 
> After that, when hot-adding socket#2 and #3, each core of sockets is
> numbered as follows:
> 
>           | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-59
> Socket#3 | 90-119
> 
> Then llc_shared_mask of CPU#30 becomes 0x3fff8000fffffffc0000000.
> It means that last level cache of Socket#2 is shared with CPU#30-59
> and 90-104. So the mask has wrong value.
> 
> At first, I cleared hot-removed CPU number's bit from llc_shared_map
> when hot removing CPU. But Borislav suggested that the problem will
> disappear if readded CPU is assigned same CPU number. And llc_shared_map
> must not be changed.
> 
> So the patch assigns same CPU number to readded CPU by linking CPU
> number to APIC ID. And by the patch, the problem disappers.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Suggested-by: Borislav Petkov <bp@alien8.de>

> ---
> v2: change cpuid to cpunum
> v3: fix Borislav's email address of Suggested-by
>      fix typo (ACPI ID to APIC ID)
> ---
>   arch/x86/kernel/apic/apic.c | 33 ++++++++++++++++++++++++++++++++-
>   1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index ad28db7..5dc3e50 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -220,6 +220,23 @@ static void apic_pm_activate(void);
>   static unsigned long apic_phys;
> 
>   /*
> + * Bind APIC ID to Logical CPU number
> + * Logical CPU number to APIC ID does not change by this array
> + * even if CPU is hotplugged. So don't clear the array even if
> + * CPU is hot-removed
> + */
> +static int apicid_to_cpunum[MAX_LOCAL_APIC] = {
> +	[0 ... MAX_LOCAL_APIC-1] = -1,
> +};
> +
> +/*
> + * Represent Logical CPU number bound to APIC ID
> + * Don't clear a bit even if CPU is hot-removed
> + */
> +static DECLARE_BITMAP(cpu_used_bits, CONFIG_NR_CPUS);
> +static struct cpumask *const cpu_used_mask = to_cpumask(cpu_used_bits);

I think the name of cpu_used_mask is confusing since the term "used" 
sounds representing some state of CPU, which is not the case here.  
How about cpu_number_mask?  This would be more specific, and avoid such
confusion.

Otherwise, the change looks good to me.

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

> +
> +/*
>    * Get the LAPIC version
>    */
  ^^
ps. I had a problem in applying this patch since there was an extra
blank character at the begging of unchanged lines.  But this might be an
issue in my mailer. 



