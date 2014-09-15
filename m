Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaIOE0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:26:08 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51930 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaIOE0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:26:06 -0400
Message-ID: <1410755159.5165.24.camel@marge.simpson.net>
Subject: Re: [PATCH v5] x86,cpu-hotplug: assign same CPU number to readded
 CPU
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, bp@alien8.de,
        gong.chen@linux.intel.com, tony.luck@intel.com, toshi.kani@hp.com,
        x86@kernel.org, imammedo@redhat.com, huawei.libin@huawei.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, peterz@infradead.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>, Linn Crosetto <linn@hp.com>
Date: Mon, 15 Sep 2014 06:25:59 +0200
In-Reply-To: <54114D83.7070004@jp.fujitsu.com>
References: <53CF2A81.7080505@jp.fujitsu.com>
	 <53D5CF2A.2030007@jp.fujitsu.com> <5407D27D.4020006@jp.fujitsu.com>
	 <54114D83.7070004@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:21 +0900, Yasuaki Ishimatsu wrote: 
> There is no response for two months since posting v4.
> What can I do for pushing the patch to upstream?

Looks to me like we have two patches floating about for more or less the
same problem, this one, and...

https://lkml.org/lkml/2014/7/29/159

..this one, which you reviewed, and HP both reviewed and tested.

We seem to kinda stuck with Boris having said don't diddle the
cpu_llc_shared_map, but HP/Intel saying that this map diddling fixes
their explosions.  If your alternative is preferred over diddling
cpu_llc_shared_map, perhaps HP/Intel can test/confirm that their
explosions stay gone? 

> Thanks,
> Yasuaki Ishimatsu
> 
> (2014/09/04 11:46), Yasuaki Ishimatsu wrote:
> > llc_shared_map is not cleared even if CPU is offline or hot removed.
> > So when hot-plugging CPU and assigning new CPU number to hot-added CPU,
> > the mask has wrong value. The mask is used by CSF schduler to create
> > sched_domain. So it breaks CFS scheduler.
> >
> > Here is a example on my system.
> > My system has 4 sockets and each socket has 15 cores and HT is enabled.
> > In this case, each core of sockes is numbered as follows:
> >
> >           | CPU#
> > Socket#0 | 0-14 , 60-74
> > Socket#1 | 15-29, 75-89
> > Socket#2 | 30-44, 90-104
> > Socket#3 | 45-59, 105-119
> >
> > Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
> > It means that last level cache of Socket#2 is shared with
> > CPU#30-44 and 90-104.
> >
> > When hot-removing socket#2 and #3, each core of sockets is numbered
> > as follows:
> >
> >           | CPU#
> > Socket#0 | 0-14 , 60-74
> > Socket#1 | 15-29, 75-89
> >
> > But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
> > having 0x3fff80000001fffc0000000.
> >
> > After that, when hot-adding socket#2 and #3, each core of sockets is
> > numbered as follows:
> >
> >           | CPU#
> > Socket#0 | 0-14 , 60-74
> > Socket#1 | 15-29, 75-89
> > Socket#2 | 30-59
> > Socket#3 | 90-119
> >
> > Then llc_shared_mask of CPU#30 becomes 0x3fff8000fffffffc0000000.
> > It means that last level cache of Socket#2 is shared with CPU#30-59
> > and 90-104. So the mask has wrong value.
> >
> > At first, I cleared hot-removed CPU number's bit from llc_shared_map
> > when hot removing CPU. But Borislav suggested that the problem will
> > disappear if readded CPU is assigned same CPU number. And llc_shared_map
> > must not be changed.
> >
> > So the patch assigns same CPU number to readded CPU by linking CPU
> > number to APIC ID. And by the patch, the problem disappers.
> >
> > Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > Suggested-by: Borislav Petkov <bp@alien8.de>
> > Reviewed-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> > v2: change cpuid to cpunum
> > v3: fix Borislav's email address of Suggested-by
> >      fix typo (ACPI ID to APIC ID)
> > v4: change cpu_used_xxx to cpu_number_xxx
> > v5: rebase to 3.17-rc3
> > ---
> >   arch/x86/kernel/apic/apic.c | 33 ++++++++++++++++++++++++++++++++-
> >   1 file changed, 32 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index 6776027..c476827 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -220,6 +220,23 @@ static void apic_pm_activate(void);
> >   static unsigned long apic_phys;
> >
> >   /*
> > + * Bind APIC ID to Logical CPU number
> > + * Logical CPU number to APIC ID does not change by this array
> > + * even if CPU is hotplugged. So don't clear the array even if
> > + * CPU is hot-removed
> > + */
> > +static int apicid_to_cpunum[MAX_LOCAL_APIC] = {
> > +    [0 ... MAX_LOCAL_APIC-1] = -1,
> > +};
> > +
> > +/*
> > + * Represent Logical CPU number bound to APIC ID
> > + * Don't clear a bit even if CPU is hot-removed
> > + */
> > +static DECLARE_BITMAP(cpu_number_bits, CONFIG_NR_CPUS);
> > +static struct cpumask *const cpu_number_mask = to_cpumask(cpu_number_bits);
> > +
> > +/*
> >    * Get the LAPIC version
> >    */
> >   static inline int lapic_get_version(void)
> > @@ -2109,6 +2126,17 @@ void disconnect_bsp_APIC(int virt_wire_setup)
> >       apic_write(APIC_LVT1, value);
> >   }
> >
> > +static int get_cpunum(int apicid)
> > +{
> > +    int cpu;
> > +
> > +    cpu = apicid_to_cpunum[apicid];
> > +    if (cpu < 0)
> > +        cpu = cpumask_next_zero(-1, cpu_number_mask);
> > +
> > +    return cpu;
> > +}
> > +
> >   int generic_processor_info(int apicid, int version)
> >   {
> >       int cpu, max = nr_cpu_ids;
> > @@ -2186,7 +2214,9 @@ int generic_processor_info(int apicid, int version)
> >            */
> >           cpu = 0;
> >       } else
> > -        cpu = cpumask_next_zero(-1, cpu_present_mask);
> > +        cpu = get_cpunum(apicid);
> > +
> > +    apicid_to_cpunum[apicid] = cpu;
> >
> >       /*
> >        * Validate version
> > @@ -2215,6 +2245,7 @@ int generic_processor_info(int apicid, int version)
> >       early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
> >           apic->x86_32_early_logical_apicid(cpu);
> >   #endif
> > +    cpumask_set_cpu(cpu, cpu_number_mask);
> >       set_cpu_possible(cpu, true);
> >       set_cpu_present(cpu, true);
> >
> 
> 


