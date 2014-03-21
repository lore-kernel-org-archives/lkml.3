Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaCURQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:16:21 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:6428 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbaCURQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:16:18 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h177df4h17326ah8275bh8275dh1de097h186068hz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
X-WSS-ID: 0N2SQMW-08-34X-02
X-M-MSG: 
Message-ID: <532C73DA.7060008@amd.com>
Date: Fri, 21 Mar 2014 12:16:10 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Daniel J Blueman <daniel@numascale.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        <kim.naru@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
References: <1394710981-3596-1-git-send-email-daniel@numascale.com> <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com> <532BB431.7020501@numascale.com>
In-Reply-To: <532BB431.7020501@numascale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/2014 10:38 PM, Daniel J Blueman wrote:
> On 21/03/2014 06:07, Bjorn Helgaas wrote:
>> [+cc linux-pci, Myron, Suravee, Kim, Aravind]
>>
>> On Thu, Mar 13, 2014 at 5:43 AM, Daniel J Blueman <daniel@numascale.com> wrote:
>>> For systems with multiple servers and routed fabric, all northbridges get
>>> assigned to the first server. Fix this by also using the node reported from
>>> the PCI bus. For single-fabric systems, the northbriges are on PCI bus 0
>>> by definition, which are on NUMA node 0 by definition, so this is invarient
>>> on most systems.
>>>
>>> Tested on fam10h and fam15h single and multi-fabric systems and candidate
>>> for stable.
>
>> I wish this had been cc'd to linux-pci.  We're talking about a related
>> change by Suravee there.  In fact, we were hoping this quirk could be
>> removed altogether.
>
> Noted.
>
>> I don't understand what this quirk is doing.  Normally we discover the
>> NUMA node for a PCI host bridge via the ACPI _PXM method.  The way
>> _PXM works is that every PCI device in the hierarchy below the bridge
>> inherits the same node number as the host bridge.  I first thought
>> this might be a workaround for a system that lacks _PXM, but I don't
>> think that can be right, because you're only changing the node for a
>> few devices, not the whole hierarchy.
>  >
>> So I suspect the problem is more complicated, and maybe _PXM is
>> insufficient to describe the topology?  Are there subtrees that should
>> have nodes different from the host bridge?
>
> Yes; see below.
>
>> I know this patch is already in v3.14-rc7, but I'd still like to
>> understand it so we can do the right thing with Suravee's patch.
>
> The _PXM method associates each northbridge with the first NUMA node, 0 in single-fabric systems, and eg 4 for the second server in a multi-fabric system with 2 dual-module Opterons (with 2 NUMA nodes internally) etc, since the northbridges appear in the
> PCI tree, under the host bridge, not above it [1].
Daniel,

That lspci looks interesting, what is the value returned from pci_bus_to_node() on your system for each fabric?

Suravee

>
> With _PXM, the rest of the PCI bus hierarchy has the right NUMA node associated, but the northbridge PCI devices should be associated with their actual NUMA node, 0, 1, 2, 3 for the first server in this example. The quirk fixes this up; irqbalance at least
> uses this NUMA data exposed in /sys.
>
> The alternative to the quirk may be to explicitly express the northbridge PCI devices in the AML with their own _PXM methods. If it's valid, it may be the honest approach, though the quirk may be needed for most BIOSs; I can check the AML on a few servers
> to confirm if helpful.
>
> Thanks,
>    Daniel
>
> [1] http://quora.org/2014/lspci.txt


