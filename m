Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbaCUDij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 23:38:39 -0400
Received: from numascale.com ([213.162.240.84]:54568 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146AbaCUDih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 23:38:37 -0400
Message-ID: <532BB431.7020501@numascale.com>
Date: Fri, 21 Mar 2014 11:38:25 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH] Fix northbridge quirk to assign correct NUMA node
References: <1394710981-3596-1-git-send-email-daniel@numascale.com> <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com>
In-Reply-To: <CAErSpo6psgDr3XYh6m+vYcAOix2Vttrwz1jK7bS47Liy2Lw-=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
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

On 21/03/2014 06:07, Bjorn Helgaas wrote:
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

> I wish this had been cc'd to linux-pci.  We're talking about a related
> change by Suravee there.  In fact, we were hoping this quirk could be
> removed altogether.

Noted.

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

Yes; see below.

> I know this patch is already in v3.14-rc7, but I'd still like to
> understand it so we can do the right thing with Suravee's patch.

The _PXM method associates each northbridge with the first NUMA node, 0 
in single-fabric systems, and eg 4 for the second server in a 
multi-fabric system with 2 dual-module Opterons (with 2 NUMA nodes 
internally) etc, since the northbridges appear in the PCI tree, under 
the host bridge, not above it [1].

With _PXM, the rest of the PCI bus hierarchy has the right NUMA node 
associated, but the northbridge PCI devices should be associated with 
their actual NUMA node, 0, 1, 2, 3 for the first server in this example. 
The quirk fixes this up; irqbalance at least uses this NUMA data exposed 
in /sys.

The alternative to the quirk may be to explicitly express the 
northbridge PCI devices in the AML with their own _PXM methods. If it's 
valid, it may be the honest approach, though the quirk may be needed for 
most BIOSs; I can check the AML on a few servers to confirm if helpful.

Thanks,
   Daniel

[1] http://quora.org/2014/lspci.txt
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
