Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbaGPLL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:11:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38405 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528AbaGPLLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:11:13 -0400
Date: Wed, 16 Jul 2014 13:11:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, huawei.libin@huawei.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, umgwanakikbuti@gmail.com,
        peterz@infradead.org
Subject: Re: [PATCH v2] x86,cpu-hotplug: assign same CPU number to readded CPU
Message-ID: <20140716111107.GB17464@pd.tnic>
References: <53C62AAF.7060509@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53C62AAF.7060509@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:33:03PM +0900, Yasuaki Ishimatsu wrote:
> llc_shared_map is not cleared even if CPU is offline or hot removed.
> So when hot-plugging CPU and assigning new CPU number to hot-added CPU,
> the mask has wrong value. The mask is used by CSF schduler to create
> sched_domain. So it breaks CFS scheduler.
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
> It means that last level cache of Socket#2 is shared with
> CPU#30-44 and 90-104.
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
> Suggested-by: Borislav Petkov <bp@alien8.de1>

You can remove the "1" above as the domain is .de :-)

Ok, so after looking at the dmesg you sent me, it looks like it works as
expected.

Apparently, the cores get enumerated in the order they're listed in SRAT
- this also explains the mapping between APIC ID and core number in
Linux.

Your patch looks simple enough as you're basically making that mapping
explicit with apicid_to_cpunum and make sure it remains stable when the
cores reappear.

And since APIC ID doesn't change across physical hotplug (does it?), it
all works as expected.

But, since this is BIOS and BIOS does crazy hacks to accomodate b0rked
OSes, I'd like it if Tony looked at this too, whether it makes sense and
whether that solution is fine.

@Tony: the text should explain it all, leaving in the rest.

Thanks.

> ---
> v2: change cpuid to cpunum
> ---
>  arch/x86/kernel/apic/apic.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index ad28db7..5dc3e50 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -220,6 +220,23 @@ static void apic_pm_activate(void);
>  static unsigned long apic_phys;
> 
>  /*
> + * Bind ACPI ID to Logical CPU number
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
> +
> +/*
>   * Get the LAPIC version
>   */
>  static inline int lapic_get_version(void)
> @@ -2122,6 +2139,17 @@ void disconnect_bsp_APIC(int virt_wire_setup)
>  	apic_write(APIC_LVT1, value);
>  }
> 
> +static int get_cpunum(int apicid)
> +{
> +	int cpu;
> +
> +	cpu = apicid_to_cpunum[apicid];
> +	if (cpu < 0)
> +		cpu = cpumask_next_zero(-1, cpu_used_mask);
> +
> +	return cpu;
> +}
> +
>  int generic_processor_info(int apicid, int version)
>  {
>  	int cpu, max = nr_cpu_ids;
> @@ -2199,7 +2227,9 @@ int generic_processor_info(int apicid, int version)
>  		 */
>  		cpu = 0;
>  	} else
> -		cpu = cpumask_next_zero(-1, cpu_present_mask);
> +		cpu = get_cpunum(apicid);
> +
> +	apicid_to_cpunum[apicid] = cpu;
> 
>  	/*
>  	 * Validate version
> @@ -2228,6 +2258,7 @@ int generic_processor_info(int apicid, int version)
>  	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
>  		apic->x86_32_early_logical_apicid(cpu);
>  #endif
> +	cpumask_set_cpu(cpu, cpu_used_mask);
>  	set_cpu_possible(cpu, true);
>  	set_cpu_present(cpu, true);
> 
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
