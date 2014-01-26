Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaAZJX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:23:29 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:59672 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaAZJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:23:27 -0500
Date: Sun, 26 Jan 2014 01:23:20 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>
cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: disabled APICs being counted as processors ?
In-Reply-To: <20140126083631.GA29339@gmail.com>
Message-ID: <alpine.DEB.2.02.1401260038510.15844@chino.kir.corp.google.com>
References: <20140123221316.GA23367@redhat.com> <20140125074107.GA10565@gmail.com> <20140125153048.GA8536@redhat.com> <alpine.DEB.2.02.1401252223460.1723@chino.kir.corp.google.com> <20140126083631.GA29339@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014, Ingo Molnar wrote:

> > I don't think the "ACPI: LAPIC (... disabled)" lines are problematic, they 
> > are simply reporting the acpi processor id and apic id for processors that 
> > do not have their enabled flag set.  The acpi spec allows for these to 
> > exist without the enabled flag set when the processor isn't present at all 
> > because the kernel will make no attempt to use it.
> > 
> > That said, I think the "smpboot: 8 Processors exceeds NR_CPUS limit 
> > of 4" line is unnecessary since, as you said, these processors don't 
> > physically exist.  I betcha that's because you have 
> > CONFIG_HOTPLUG_CPU enabled and it's counting the disabled cpus that 
> > were found when acpi_register_lapic() was done.  The warning is only 
> > really meaningful for cpus in cpu_possible_map, which aren't set for 
> > your disabled four, in the hotplug case where NR_CPUS is too small.
> 
> No, this message is printed in prefill_possible_map() which 
> _generates_ cpu_possible_map, so '8' is the number of bits in 
> cpu_possible_map.
> 

Yeah, because I bet Dave has CONFIG_HOTPLUG_CPU enabled and it's adding 
this to the number of possible cpus when in reality, per the spec, these 
cpus aren't possible at all because their enable bit isn't set in their 
lapic flags.

> So the problem is that the counting of disabled but hotpluggable CPUs 
> is over-eager.

In the kernel, yeah, and we don't distinguish between physically absent 
processors that have lapic entries and physically present but disabled 
processors.

> Since I haven't actually seen _true_ hotplug CPU 
> hardware yet, I'd argue we do the change below - allocating space for 
> never-present CPUs is stupid. If there's true hot-plug CPUs around 
> that could come online after we've booted, then we want to know about 
> them explicitly.
> 
> Thoughts?
> 
> Thanks,
> 
> 	Ingo
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a32da80..75a351a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1223,10 +1223,7 @@ __init void prefill_possible_map(void)
>  	i = setup_max_cpus ?: 1;
>  	if (setup_possible_cpus == -1) {
>  		possible = num_processors;
> -#ifdef CONFIG_HOTPLUG_CPU
> -		if (setup_max_cpus)
> -			possible += disabled_cpus;
> -#else
> +#ifndef CONFIG_HOTPLUG_CPU
>  		if (possible > i)
>  			possible = i;
>  #endif

Yeah, this should suppress the warning for Dave.  This way, the only way 
the log reports the number of "hotplug CPUs" is because we used 
possible_cpus.

I think you should also just do "total_cpus = possible" though and forget 
about disabled_cpus or /sys/devices/system/cpu/offline is still going to 
show him 4-7.

This function could benefit from a cleanup at the same time, it's not 
looking good:

 - "i" is a horribly named variable that stores the value so at least
   one cpu is possible when "nosmp" is used,

 - what's with the

   #ifdef CONFIG_HOTPLUG_CPU
	if (!setup_max_cpus)
   #endif ?

   if I do "maxcpus=4 nr_cpus=6 possible_cpus=8" what's the expected
   behavior?  We're not only testing for "nosmp" use here, "possible"
   should still be 4, and

 - the warning references "max_cpus" but the kernel command line option
   is "maxcpus"
