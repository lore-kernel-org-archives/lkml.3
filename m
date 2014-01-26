Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaAZGlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 01:41:11 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49856 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaAZGlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 01:41:09 -0500
Date: Sat, 25 Jan 2014 22:41:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabled APICs being counted as processors ?
In-Reply-To: <20140125153048.GA8536@redhat.com>
Message-ID: <alpine.DEB.2.02.1401252223460.1723@chino.kir.corp.google.com>
References: <20140123221316.GA23367@redhat.com> <20140125074107.GA10565@gmail.com> <20140125153048.GA8536@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014, Dave Jones wrote:

>  > > it looks like this is because..
>  > > 
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0xff] disabled)
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0xff] disabled)
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0xff] disabled)
>  > > [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0xff] disabled)
>  > > 
>  > > Should the CPU counting code be ignoring those disabled APICs ?
>  > 
>  > Hm, so to the kernel it looks like as if those were 'possible CPUs', 
>  > in theory hotpluggable. Not sure what they are - disabled cores in an 
>  > 8-core system? Or BIOS reporting crap?
>  > 
>  > But perhaps the boot message could be improved to say something like:
>  > 
>  > > [    0.000000] smpboot: 8 possible processors exceeds NR_CPUS limit of 4
> 
> It's not possible though. It's an i5-4670T, in a single socket board.
> It doesn't even have hyperthreading. http://ark.intel.com/products/75050/Intel-Core-i5-4670T-Processor-6M-Cache-up-to-3_30-GHz
> 

I don't think the "ACPI: LAPIC (... disabled)" lines are problematic, they 
are simply reporting the acpi processor id and apic id for processors that 
do not have their enabled flag set.  The acpi spec allows for these to 
exist without the enabled flag set when the processor isn't present at all 
because the kernel will make no attempt to use it.

That said, I think the "smpboot: 8 Processors exceeds NR_CPUS limit of 4" 
line is unnecessary since, as you said, these processors don't physically 
exist.  I betcha that's because you have CONFIG_HOTPLUG_CPU enabled and 
it's counting the disabled cpus that were found when acpi_register_lapic() 
was done.  The warning is only really meaningful for cpus in 
cpu_possible_map, which aren't set for your disabled four, in the hotplug 
case where NR_CPUS is too small.
