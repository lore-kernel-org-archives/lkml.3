Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaCXGvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:51:42 -0400
Received: from cpanel21.proisp.no ([213.162.240.27]:42376 "EHLO
	cpanel21.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaCXGvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:51:40 -0400
X-Greylist: delayed 2901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2014 02:51:40 EDT
Message-ID: <532FCA9B.7080707@1degreenorth.com>
Date: Mon, 24 Mar 2014 14:03:07 +0800
From: Daniel J Blueman <daniel@1degreenorth.com>
Organization: 1degreenorth Pte Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kim.naru@amd.com,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
References: <1394710981-3596-1-git-send-email-daniel@numascale.com> <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com> <532BB431.7020501@numascale.com> <CAErSpo4x+=EQ5h8DuzoRznZ_d8Roy4LHer7ELEVeHxDsKwDhzA@mail.gmail.com>
In-Reply-To: <CAErSpo4x+=EQ5h8DuzoRznZ_d8Roy4LHer7ELEVeHxDsKwDhzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1degreenorth.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2014 12:11 AM, Bjorn Helgaas wrote:
> [+cc Rafael, linux-acpi for _PXM questions]
>
> On Thu, Mar 20, 2014 at 9:38 PM, Daniel J Blueman <daniel@numascale.com> wrote:
>> On 21/03/2014 06:07, Bjorn Helgaas wrote:
>>> On Thu, Mar 13, 2014 at 5:43 AM, Daniel J Blueman <daniel@numascale.com>
>>> wrote:
>>>>
>>>> For systems with multiple servers and routed fabric, all northbridges get
>>>> assigned to the first server. Fix this by also using the node reported
>>>> from
>>>> the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
>>>> by definition, which are on NUMA node 0 by definition, so this is
>>>> invarient
>>>> on most systems.
>>>>
>>>> Tested on fam10h and fam15h single and multi-fabric systems and candidate
>>>> for stable.
>
>>> So I suspect the problem is more complicated, and maybe _PXM is
>>> insufficient to describe the topology?  Are there subtrees that should
>>> have nodes different from the host bridge?
>>
>> Yes; see below.
>> ...
>> The _PXM method associates each northbridge with the first NUMA node, 0 in
>> single-fabric systems, and eg 4 for the second server in a multi-fabric
>> system with 2 dual-module Opterons (with 2 NUMA nodes internally) etc, since
>> the northbridges appear in the PCI tree, under the host bridge, not above it
>> [1].
>>
>> With _PXM, the rest of the PCI bus hierarchy has the right NUMA node
>> associated, but the northbridge PCI devices should be associated with their
>> actual NUMA node, 0, 1, 2, 3 for the first server in this example. The quirk
>> fixes this up; irqbalance at least uses this NUMA data exposed in /sys.
>
> I'm confused about which devices we're talking about.  We currently
> look at _PXM for PNP0A08 (and PNP0A03) ACPI devices.  The resulting
> node is associated with every PCI device we enumerate below the
> PNP0A08 bridge.  This association is made in pci_device_add().
>
> When you say "northbridge PCI devices should be associated with their
> actual NUMA node," I assume you mean the 00:18.x and 00:19.x devices
> ("AMD Family 10h Processor ..."), since those seem to be what the
> quirk applies to.  You are *not* talking about 00:00.0 ("ATI RD890
> Northbridge"), right?

Yes, on bus 0, devices 0x18 to 0x20 decode to the (up to) eight 
Hypertransport devices in the processor fabric, normally all processor 
northbridges.

> You mention irqbalance; is the NUMA node information for the 00:18.x
> and 00:19.x devices important because you get a lot of interrupts from
> those devices?  Or is the issue with actual I/O devices (NICs, SCSI
> adapters, etc.)?  If so, I don't see how this quirk would affect
> those, because the node information for them comes from the PNP0A08
> bridge (in pci_device_add()), not from the 00:00.0, 00:18.x, or
> 00:19.x devices.

I need to investigate the lockups irqbalance was causing on a customer 
system, and am not sure what interrupt source that was rewritten which 
causing hangs; disabling the daemon prevented the hangs.

>> The alternative to the quirk may be to explicitly express the northbridge
>> PCI devices in the AML with their own _PXM methods. If it's valid, it may be
>> the honest approach, though the quirk may be needed for most BIOSs; I can
>> check the AML on a few servers to confirm if helpful.
>
> ACPI allows _PXM for any device, so this might be a possible approach.
>   However, it looks like Linux only pays attention to _PXM for
> PNP0A08/03, CPUs, memory and IOAPICs (which seems like a Linux defect
> to me).

> I'm really worried about the approach here:
>
>          pci_read_config_dword(nb_ht, 0x60, &val);
>          node = pcibus_to_node(dev->bus) | (val & 7);
>
> because the pcibus_to_node() information comes indirectly from _PXM,
> and the "val" part comes from the hardware, and I don't think these
> are the same node number space.  If I understand correctly, the BIOS
> can synthesize whatever numbers it wants for _PXM, which returns a
> "proximity domain," and then Linux can make up its own mapping of
> "proximity domain" to "logical Linux node."  So I don't see why we can
> assume that it's valid to OR in the bits from a PCI config register to
> this logical Linux node number.

pcibus_to_node uses the proximity domain values in the ACPI SRAT table, 
which is thus correctly mapped to the linux NUMA node ID, so my oneliner 
is still progress.

Linux allocates NUMA node ids using the ordering of PXM values seen in 
the SRAT table, ie first_unset_node(nodes_found_map). The APIC ids are 
initialised using the HyperTransport NodeId [1, p263 and p465], but the 
NodeId can be reprogrammed after the APIC ids are set (which also 
changes the PCI configuration device id from 0x18 on bus 0 it responds 
to), and the SRAT table needn't be emitted in order, perhaps except for 
the bootstrap core.

I guess fixing the original quirk depends on how important these cases 
really are.

Thanks,
   Daniel

[1] http://support.amd.com/TechDocs/42301_15h_Mod_00h-0Fh_BKDG.pdf
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
