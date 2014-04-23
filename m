Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaDWOlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbaDWOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:41:01 -0400
Date: Wed, 23 Apr 2014 22:40:53 +0800
From: Baoquan He <bhe@redhat.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        jiang.liu@linux.intel.com, vgoyal@redhat.com
Subject: Re: [PATCH] acpi: try to trust cpu_index from x86_cpu_to_apicid
Message-ID: <20140423144053.GA1711@dhcp-17-102.nay.redhat.com>
References: <1397519754-10205-1-git-send-email-bhe@redhat.com>
 <11963454.DotWb00OAa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11963454.DotWb00OAa@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/14 at 10:51pm, Rafael J. Wysocki wrote:
> On Tuesday, April 15, 2014 07:55:54 AM Baoquan He wrote:
> > In smp with multi cpus, when enter into kdump kernel with only 1 cpu,
> > a warning message is printed out:
> > 
> > acpi LNXCPU:0a: BIOS reported wrong ACPI id 0 for the processor
> > 
> > In this case kdump kernel use the same ACPI tables as 1st kernel,
> > means lapic information is got from MADT. The acpi_id related to
> > this cpu index and lapic_id may not be 0, so the code to assign
> > value to cpu_index is not correct in this case per cpu0_initialized.
> > cpu index stored in x86_cpu_to_apicid need be respected.
> > 
> > Now fix it in this patch per boot_cpu_physical_apicid. When cpu index
> > related to boot_cpu_physical_apicid is not stored in x86_cpu_to_apicid,
> > then we can say this is UP system running SMP kernel with no LAPIC in MADT
> 
> Why don't you fix the warning message instead to cover this case too? 


Hi Rafael,

Thanks for replying.

In kdump case, that warning message is printed out just because the
assignation is not correct. 

E.g on that machine where this bug was reported, there are 16 cpus. In
normal kernel their information is stored in acpi MADT, and all of them
is present in system. However when crash happened, the cpu which crash
happened on will reboot. That reboot is a warm one, skip BIOS step.
And currently "nr_cpus=1" is need be  added into cmdline of kdump
kernel. The restriction of only 1 cpu is a long story for kdump, since
if crash happend on AP, if multi-cpu is not disabled, that AP will
reboot and send INIT IPI to BSP of 1st kernel, that will cause a
immediate reboot to BIOS which is a cpu hw behavior.

So when kdump kernel startup with "nr_cpus=1", it will use ACPI
information stored by BIOS step of 1st kernel, there are 16 lapic.
Below are message printed by acpi_register_lapic() when acpi handle MADT
table related to cpu and lapic. From these printed message, the present
cpu in kdump kernel has a acpi_id=0x0c and lapic_id=0x24. 

Then when scan acpi device, all cpus detected by acpi will be handled by
acpi_processor_add(). So the old code will directly assign the
cpu_index as 0 per the variable cpu0_initialized though
x86_cpu_to_apicid stored cpu 0 and its related apicid which is 0x24.
This will cause two acpi_device (acpi_id 0 and acpi_id 0x0c) have the
same cpu_index 0, then that warning message will be printed out since a
check found  per_cpu(processor_device_array, 0) has been assigned.

So I think it's a code bug, sould be fixed by correct checking.


[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x10] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cpu.  Processor 0/0x10 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x20] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cpu.  Processor 1/0x20 ig.
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x11] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cpu.  Processor 2/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x21] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cpu.  Processor 3/0x21 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x12] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cp
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x22] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cpu.  Processor 5/0x22 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cpu.  Processor 6/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x23] enabled)
[    0.000000] ACPICPUS/possible_cpus limit of 1 almost reached. Keeping
one slot for boot cpu.  Processor 7/0x23 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x14] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 almost reached.
Keeping one slot for boot cpu.  Processor 8/0x14 ignored.

[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x24] enabled)

[    0.000000] ACPI: LAPIC (acpi_id[ lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 10/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x25] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 11/0x25 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x06] l 0.000000] ACPI:
NR_CPUS/possible_cpus limit of 1 reached.  Processor 12/0x16 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x26] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 13/0x26 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x17] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 14/0x17 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x27] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit ofached.  Processor
15/0x27 ignored.

Thanks
Baoquan

