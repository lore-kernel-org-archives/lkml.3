Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaCUEO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 00:14:59 -0400
Received: from numascale.com ([213.162.240.84]:50997 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbaCUEO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 00:14:58 -0400
X-Greylist: delayed 2180 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2014 00:14:57 EDT
Message-ID: <532BBCB4.4070107@numascale.com>
Date: Fri, 21 Mar 2014 12:14:44 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        kim.naru@amd.com,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Hurwitz, Sherry" <sherry.hurwitz@amd.com>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
References: <1394710981-3596-1-git-send-email-daniel@numascale.com> <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com> <532BB75E.90301@amd.com>
In-Reply-To: <532BB75E.90301@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2014 11:51, Suravee Suthikulpanit wrote:
> Bjorn,
>
> On a typical AMD system, there are two types of host bridges:
> * PCI Root Complex Host bridge (e.g. RD890, SR56xx, etc.)
> * CPU Host bridge
>
> Here is an example from a 2 sockets system:
>
> $ lspci
[]

> The host bridge 00:00.0 is basically the PCI root complex which connects
> to the actual PCI bus with
> PCI devices hanging off of it.  However, the host bridge 00:[18,19].x
> are the CPU host bridges,
> each of which represents a CPU node within the system. In system with
> single root complex,
> the root complex is normally connected to node 0 (i.e. 00:18.0) via
> non-coherent HT (I/O) link.

> Even though the CPU host bridge 00:[18,19].x is on the same bus as the
> PCI root complex, it should
> not be using the NUMA information from the PCI root complex host bridge.

This is unavoidable unless we special-case it via another mechanism (ie 
not quirks), since the northbridges/CPU host bridges are logically under 
the _PXM method.

> Therefore, I don't think we should be using the pcibus_to_node(dev->bus)
> here.
> Only the "val" from pci_read_config_dword(nb_ht, 0x60, &val), should be
> used here.

Using only effectively the NUMA node ID (HT node ID here) would 
associate all the northbridges with the first fabric, which is false 
information. If there was no quirk, they'd all be associated with the 
first NUMA node in each fabric, as you'd expect.

This was the only safe and defensible one-liner approach I could 
prepare; if you find it introduces a regression or you can find a better 
approach, do tell. If not, we can decouple this fix from an overall new 
approach, since it's unlikely that'll get backported to stable kernels.

Thanks,
   Daniel

> On 3/20/2014 5:07 PM, Bjorn Helgaas wrote:
>> [+cc linux-pci, Myron, Suravee, Kim, Aravind]
>>
>> On Thu, Mar 13, 2014 at 5:43 AM, Daniel J Blueman
>> <daniel@numascale.com> wrote:
>>> For systems with multiple servers and routed fabric, all northbridges
>>> get
>>> assigned to the first server. Fix this by also using the node
>>> reported from
>>> the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
>>> by definition, which are on NUMA node 0 by definition, so this is
>>> invarient
>>> on most systems.
>>>
>>> Tested on fam10h and fam15h single and multi-fabric systems and
>>> candidate
>>> for stable.
>>
>> I wish this had been cc'd to linux-pci.  We're talking about a related
>> change by Suravee there.  In fact, we were hoping this quirk could be
>> removed altogether.
>>
>> I don't understand what this quirk is doing.  Normally we discover the
>> NUMA node for a PCI host bridge via the ACPI _PXM method.  The way
>> _PXM works is that every PCI device in the hierarchy below the bridge
>> inherits the same node number as the host bridge.  I first thought
>> this might be a workaround for a system that lacks _PXM, but I don't
>> think that can be right, because you're only changing the node for a
>> few devices, not the whole hierarchy.
>>
>> So I suspect the problem is more complicated, and maybe _PXM is
>> insufficient to describe the topology?  Are there subtrees that should
>> have nodes different from the host bridge?
>>
>> I know this patch is already in v3.14-rc7, but I'd still like to
>> understand it so we can do the right thing with Suravee's patch.
>>
>> Bjorn
>>
>>> Signed-off-by: Daniel J Blueman <daniel@numascale.com>
>>> Acked-by: Steffen Persvold <sp@numascale.com>
>>> ---
>>>   arch/x86/kernel/quirks.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
>>> index 04ee1e2..52dbf1e 100644
>>> --- a/arch/x86/kernel/quirks.c
>>> +++ b/arch/x86/kernel/quirks.c
>>> @@ -529,7 +529,7 @@ static void quirk_amd_nb_node(struct pci_dev *dev)
>>>                  return;
>>>
>>>          pci_read_config_dword(nb_ht, 0x60, &val);
>>> -       node = val & 7;
>>> +       node = pcibus_to_node(dev->bus) | (val & 7);
>>>          /*
>>>           * Some hardware may return an invalid node ID,
>>>           * so check it first:
>>> --
>>> 1.8.3.2
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>


-- 
Daniel J Blueman
Principal Software Engineer, Numascale
