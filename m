Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452AbaCUDwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 23:52:10 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:2347 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbaCUDwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 23:52:06 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N2RPEK-08-7MI-02
X-M-MSG: 
Message-ID: <532BB75E.90301@amd.com>
Date: Thu, 20 Mar 2014 22:51:58 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Daniel J Blueman <daniel@numascale.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
References: <1394710981-3596-1-git-send-email-daniel@numascale.com> <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com>
In-Reply-To: <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

On a typical AMD system, there are two types of host bridges:
* PCI Root Complex Host bridge (e.g. RD890, SR56xx, etc.)
* CPU Host bridge

Here is an example from a 2 sockets system:

$ lspci
00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (external gfx0 port A) (rev 02)
00:00.2 IOMMU: Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory Management Unit (IOMMU)
00:04.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port D)
00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.1 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0 USB OHCI1 Controller
00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.1 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0 USB OHCI1 Controller
00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 3d)
00:14.1 IDE interface: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 IDE Controller
00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC host controller
00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge
00:14.5 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 0
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 1
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 2
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 3
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 4
00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 5
00:19.0 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 0
00:19.1 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 1
00:19.2 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 2
00:19.3 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 3
00:19.4 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 4
00:19.5 Host bridge: Advanced Micro Devices [AMD] Family 15h Processor Function 5
01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
02:06.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI ES1000 (rev 02)

The host bridge 00:00.0 is basically the PCI root complex which connects to the actual PCI bus with
PCI devices hanging off of it.  However, the host bridge 00:[18,19].x are the CPU host bridges,
each of which represents a CPU node within the system. In system with single root complex,
the root complex is normally connected to node 0 (i.e. 00:18.0) via non-coherent HT (I/O) link.

Even though the CPU host bridge 00:[18,19].x is on the same bus as the PCI root complex, it should
not be using the NUMA information from the PCI root complex host bridge.
Therefore, I don't think we should be using the pcibus_to_node(dev->bus) here.
Only the "val" from pci_read_config_dword(nb_ht, 0x60, &val), should be used here.

Please see section 2.2 of the BIOS and Kernel development guide here for more info.
(http://support.amd.com/TechDocs/42301_15h_Mod_00h-0Fh_BKDG.pdf)

Suravee

On 3/20/2014 5:07 PM, Bjorn Helgaas wrote:
> [+cc linux-pci, Myron, Suravee, Kim, Aravind]
>
> On Thu, Mar 13, 2014 at 5:43 AM, Daniel J Blueman <daniel@numascale.com> wrote:
>> For systems with multiple servers and routed fabric, all northbridges get
>> assigned to the first server. Fix this by also using the node reported from
>> the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
>> by definition, which are on NUMA node 0 by definition, so this is invarient
>> on most systems.
>>
>> Tested on fam10h and fam15h single and multi-fabric systems and candidate
>> for stable.
>
> I wish this had been cc'd to linux-pci.  We're talking about a related
> change by Suravee there.  In fact, we were hoping this quirk could be
> removed altogether.
>
> I don't understand what this quirk is doing.  Normally we discover the
> NUMA node for a PCI host bridge via the ACPI _PXM method.  The way
> _PXM works is that every PCI device in the hierarchy below the bridge
> inherits the same node number as the host bridge.  I first thought
> this might be a workaround for a system that lacks _PXM, but I don't
> think that can be right, because you're only changing the node for a
> few devices, not the whole hierarchy.
>
> So I suspect the problem is more complicated, and maybe _PXM is
> insufficient to describe the topology?  Are there subtrees that should
> have nodes different from the host bridge?
>
> I know this patch is already in v3.14-rc7, but I'd still like to
> understand it so we can do the right thing with Suravee's patch.
>
> Bjorn
>
>> Signed-off-by: Daniel J Blueman <daniel@numascale.com>
>> Acked-by: Steffen Persvold <sp@numascale.com>
>> ---
>>   arch/x86/kernel/quirks.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
>> index 04ee1e2..52dbf1e 100644
>> --- a/arch/x86/kernel/quirks.c
>> +++ b/arch/x86/kernel/quirks.c
>> @@ -529,7 +529,7 @@ static void quirk_amd_nb_node(struct pci_dev *dev)
>>                  return;
>>
>>          pci_read_config_dword(nb_ht, 0x60, &val);
>> -       node = val & 7;
>> +       node = pcibus_to_node(dev->bus) | (val & 7);
>>          /*
>>           * Some hardware may return an invalid node ID,
>>           * so check it first:
>> --
>> 1.8.3.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>


