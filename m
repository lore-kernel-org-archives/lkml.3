Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab3CYN7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:59:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3CYN7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:59:17 -0400
Date: Mon, 25 Mar 2013 09:59:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen/acpi-stub: Disable it b/c the acpi_processor_add is
 no longer called.
Message-ID: <20130325135909.GF11546@phenom.dumpdata.com>
References: <1363962480-1366-1-git-send-email-konrad.wilk@oracle.com>
 <DE8DF0795D48FD4CA783C40EC82923354340D3@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923354340D3@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 08:49:47AM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > With the Xen ACPI stub code (CONFIG_XEN_STUB=y) enabled, the power
> > C and P states are no longer uploaded to the hypervisor.
> > 
> > The reason is that the Xen CPU hotplug code: xen-acpi-cpuhotplug.c
> > and the xen-acpi-stub.c register themselves as the "processor" type
> > object. 
> > 
> > That means the generic processor (processor_driver.c) stops
> > working and it does not call (acpi_processor_add) which populates the
> > 
> >          per_cpu(processors, pr->id) = pr;
> > 
> > structure. The 'pr' is gathered from the acpi_processor_get_info
> > function which does the job of finding the C-states and figuring out
> > PBLK address. 
> > 
> > The 'processors->pr' is then later used by xen-acpi-processor.c (the
> > one that uploads C and P states to the hypervisor). Since it is NULL,
> > we end 
> > skip the gathering of _PSD, _PSS, _PCT, etc and never upload the power
> > management data.
> > 
> > The end result is that enabling the CONFIG_XEN_STUB in the build
> > means that xen-acpi-processor is not working anymore.
> > 
> > This temporary patch fixes it by marking the XEN_STUB driver as
> > BROKEN until this can be properly fixed.
> > 
> > CC: jinsong.liu@intel.com
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/xen/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> > index 5a32232..67af155 100644
> > --- a/drivers/xen/Kconfig
> > +++ b/drivers/xen/Kconfig
> > @@ -182,7 +182,7 @@ config XEN_PRIVCMD
> > 
> >  config XEN_STUB
> >  	bool "Xen stub drivers"
> > -	depends on XEN && X86_64
> > +	depends on XEN && X86_64 && BROKEN
> >  	default n
> >  	help
> >  	  Allow kernel to install stub drivers, to reserve space for Xen
> > drivers, 
> 
> 
> Yes, exactly.
> 
> With xen-cpu-hotplug logic added, it's not proper to make xen Px/Cx rely on native processor_driver anymore.

Ahhh.
> Reasonable solution is, hooking Px/Cx logic into xen hotplug path (say, ops.add --> acpi_processor_add), like what native side does currently.

Right. That would require making acpi_processor_add an EXPORT symbol.

> 
> So at Xen dom0 side, there are 2 issues need to be solved:
> 1. currently xen dom0 defaultly set cpu_possible_map equal to cpu_present_map, we need adjust it so that when cpu hotplug it can handle 'pr' properly;

Kind of. The xen-acpi-processor dealt with that by copying the 'pr' for the present, but not-offline vCPUS
and figuring out which of them dom0 did not know about. Look in the 'get_max_acpi_id' and 'pr_backup'
in the code.

So it has the logic to handle dom0_max_vcpus=X, where X is less than physically present CPUs.


> 2. hook Px/Cx parsing logic into cpu hotadd or cpu online logic, like what native side did;
> 
> Attached is a patch to solve issue 1, basically it generates possible map according to MADT entries, not trims according to hypervisor online cpus. With it, dom0 cpu possible map reserves space for Xen cpu hotplug and corresponding Px/Cx, and dom0 also get a unified possible map view just like it runs under native platform.

Ah, didn't think of doing it that way! Thought look at cf405ae612b0f7e2358db7ff594c0e94846137aa
as the scheduler will now try to use those.
> 
> As for issue 2, it may be fixed later :-)
> (BTW, your patch to temporarily disable xen-stub is necessary even with my patch, only would be reverted after issue 2 got solved)

Right.
> 
> Thanks,
> Jinsong
> 
> ========================
> >From bb49caa523de46551c37de91754c49919bee4687 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Mon, 25 Mar 2013 21:31:36 +0800
> Subject: [PATCH] Xen/X86: adjust dom0 cpu possible map for sake of Xen Px/Cx
> 
> Currently dom0 cpu possible map defaultly equal to cpu
> present map. It works fine if not consider Xen cpu hotplug
> and corresponding Px/Cx. However, when cpu hotplug the
> possible map should reserve some space, considering it's
> static and per-cpu data-structures are allocated at init
> time, and do not expect to do this dynamically.
> 
> This patch adjusts Xen dom0 cpu possible map.
> Basically it generates possible map according to MADT entries,
> not trims according to hypervisor online cpus. With it, dom0
> cpu possible map reserves space for Xen cpu hotplug and
> corresponding Px/Cx, and dom0 also get a unified possible map
> view just like it runs under native platform.
> 
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/xen/enlighten.c |   13 +++++++++++--
>  arch/x86/xen/smp.c       |   30 +++++++-----------------------
>  2 files changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index c8e1c7b..f630956 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1089,8 +1089,17 @@ void xen_setup_vcpu_info_placement(void)
>  {
>  	int cpu;
>  
> -	for_each_possible_cpu(cpu)
> -		xen_vcpu_setup(cpu);
> +	/*
> +	 * Dom0 reserved more possible bits than present ones for the sake of
> +	 * Xen processor driver and hotplug logic. To avoid clamp_max_cpus,
> +	 * setup dom0 vcpus for present ones.
> +	 */
> +	if (xen_initial_domain())
> +		for_each_present_cpu(cpu)
> +			xen_vcpu_setup(cpu);
> +	else
> +		for_each_possible_cpu(cpu)
> +			xen_vcpu_setup(cpu);
>  
>  	/* xen_vcpu_setup managed to place the vcpu_info within the
>  	   percpu area for all cpus, so make use of it */
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 09ea61d..9b334b9 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -192,37 +192,23 @@ static void __init xen_fill_possible_map(void)
>  static void __init xen_filter_cpu_maps(void)
>  {
>  	int i, rc;
> -	unsigned int subtract = 0;
>  
>  	if (!xen_initial_domain())
>  		return;
>  
>  	num_processors = 0;
>  	disabled_cpus = 0;
> +
> +	/* all bits have been set possible at prefill_possible_map */
>  	for (i = 0; i < nr_cpu_ids; i++) {
>  		rc = HYPERVISOR_vcpu_op(VCPUOP_is_up, i, NULL);
> -		if (rc >= 0) {
> +		if (rc >= 0)
>  			num_processors++;
> -			set_cpu_possible(i, true);
> -		} else {
> -			set_cpu_possible(i, false);
> +		else {
> +			disabled_cpus++;
>  			set_cpu_present(i, false);
> -			subtract++;
>  		}
>  	}
> -#ifdef CONFIG_HOTPLUG_CPU
> -	/* This is akin to using 'nr_cpus' on the Linux command line.
> -	 * Which is OK as when we use 'dom0_max_vcpus=X' we can only
> -	 * have up to X, while nr_cpu_ids is greater than X. This
> -	 * normally is not a problem, except when CPU hotplugging
> -	 * is involved and then there might be more than X CPUs
> -	 * in the guest - which will not work as there is no
> -	 * hypercall to expand the max number of VCPUs an already
> -	 * running guest has. So cap it up to X. */
> -	if (subtract)
> -		nr_cpu_ids = nr_cpu_ids - subtract;
> -#endif
> -

This was a fix for
commit cf405ae612b0f7e2358db7ff594c0e94846137aa
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Thu Apr 26 13:50:03 2012 -0400

    xen/smp: Fix crash when booting with ACPI hotplug CPUs.

which I think your patch would expose again?

>  }
>  
>  static void __init xen_smp_prepare_boot_cpu(void)
> @@ -272,15 +258,13 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>  
>  	cpumask_copy(xen_cpu_initialized_map, cpumask_of(0));
>  
> -	/* Restrict the possible_map according to max_cpus. */
> +	/* Restrict the possible/present_map according to max_cpus. */
>  	while ((num_possible_cpus() > 1) && (num_possible_cpus() > max_cpus)) {
>  		for (cpu = nr_cpu_ids - 1; !cpu_possible(cpu); cpu--)
>  			continue;
>  		set_cpu_possible(cpu, false);
> +		set_cpu_present(cpu, false);
>  	}
> -
> -	for_each_possible_cpu(cpu)
> -		set_cpu_present(cpu, true);
>  }
>  
>  static int __cpuinit
> -- 
> 1.7.1


