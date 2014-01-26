Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaAZIgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 03:36:36 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64836 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaAZIgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 03:36:35 -0500
Date: Sun, 26 Jan 2014 09:36:31 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: disabled APICs being counted as processors ?
Message-ID: <20140126083631.GA29339@gmail.com>
References: <20140123221316.GA23367@redhat.com>
 <20140125074107.GA10565@gmail.com>
 <20140125153048.GA8536@redhat.com>
 <alpine.DEB.2.02.1401252223460.1723@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401252223460.1723@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Rientjes <rientjes@google.com> wrote:

> On Sat, 25 Jan 2014, Dave Jones wrote:
> 
> >  > > it looks like this is because..
> >  > > 
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
> >  > > [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
> >  > > 
> >  > > Should the CPU counting code be ignoring those disabled APICs ?
> >  > 
> >  > Hm, so to the kernel it looks like as if those were 'possible CPUs', 
> >  > in theory hotpluggable. Not sure what they are - disabled cores in an 
> >  > 8-core system? Or BIOS reporting crap?
> >  > 
> >  > But perhaps the boot message could be improved to say something like:
> >  > 
> >  > > [    0.000000] smpboot: 8 possible processors exceeds NR_CPUS limit of 4
> > 
> > It's not possible though. It's an i5-4670T, in a single socket board.
> > It doesn't even have hyperthreading. http://ark.intel.com/products/75050/Intel-Core-i5-4670T-Processor-6M-Cache-up-to-3_30-GHz
> > 
> 
> I don't think the "ACPI: LAPIC (... disabled)" lines are problematic, they 
> are simply reporting the acpi processor id and apic id for processors that 
> do not have their enabled flag set.  The acpi spec allows for these to 
> exist without the enabled flag set when the processor isn't present at all 
> because the kernel will make no attempt to use it.
> 
> That said, I think the "smpboot: 8 Processors exceeds NR_CPUS limit 
> of 4" line is unnecessary since, as you said, these processors don't 
> physically exist.  I betcha that's because you have 
> CONFIG_HOTPLUG_CPU enabled and it's counting the disabled cpus that 
> were found when acpi_register_lapic() was done.  The warning is only 
> really meaningful for cpus in cpu_possible_map, which aren't set for 
> your disabled four, in the hotplug case where NR_CPUS is too small.

No, this message is printed in prefill_possible_map() which 
_generates_ cpu_possible_map, so '8' is the number of bits in 
cpu_possible_map.

So the problem is that the counting of disabled but hotpluggable CPUs 
is over-eager. Since I haven't actually seen _true_ hotplug CPU 
hardware yet, I'd argue we do the change below - allocating space for 
never-present CPUs is stupid. If there's true hot-plug CPUs around 
that could come online after we've booted, then we want to know about 
them explicitly.

Thoughts?

Thanks,

	Ingo

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..75a351a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1223,10 +1223,7 @@ __init void prefill_possible_map(void)
 	i = setup_max_cpus ?: 1;
 	if (setup_possible_cpus == -1) {
 		possible = num_processors;
-#ifdef CONFIG_HOTPLUG_CPU
-		if (setup_max_cpus)
-			possible += disabled_cpus;
-#else
+#ifndef CONFIG_HOTPLUG_CPU
 		if (possible > i)
 			possible = i;
 #endif
