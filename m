Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbaJHBqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:46:19 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:49509 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaJHBqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:46:18 -0400
Message-ID: <5434975C.9000709@hp.com>
Date: Wed, 08 Oct 2014 09:46:04 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexander Duyck <alexander.duyck@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        linda.knippers@hp.com
Subject: Re: [PATCH 1/1] pci/quirks: fix a dmar fault for intel 82599 card
References: <1412057394-7186-1-git-send-email-zhen-hual@hp.com> <542A4A99.4030204@hp.com> <CAErSpo56yKZgP3KLbZWRH78PXc8i2nrnN2aN-12j9HR+R5bhUA@mail.gmail.com> <542EB2A2.3050005@gmail.com>
In-Reply-To: <542EB2A2.3050005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

well,  then I will create a patch for ALL pcie devices.
On 10/03/2014 10:28 PM, Alexander Duyck wrote:
> On 10/02/2014 08:09 AM, Bjorn Helgaas wrote:
>> On Tue, Sep 30, 2014 at 12:15 AM, Li, ZhenHua <zhen-hual@hp.com> wrote:
>>> Add Joerg to CC list. For it is also related to iommu module.
>>>
>>> Joerg,
>>> There was a try for this dmar fault,
>>>          https://lkml.org/lkml/2014/8/18/118
>>>
>>> This patch is trying to fix the same thing.
>>>
>>>
>>> Zhenhua
>>>
>>> On 09/30/2014 02:09 PM, Li, Zhen-Hua wrote:
>>>> On a HP system with Intel Corporation 82599 ethernet adapter, when kernel
>>>> crashed and the kdump kernel boots with intel_iommu=on, there may be some
>>>> unexpected DMA requests on this adapter, which will cause DMA Remapping
>>>> faults like:
>>>>       dmar: DRHD: handling fault status reg 102
>>>>       dmar: DMAR:[DMA Read] Request device [41:00.0] fault addr fff81000
>>>>       DMAR:[fault reason 01] Present bit in root entry is clear
>>>>
>>>> Analysis for this bug:
>>>>
>>>> The present bit is set in this function:
>>>>
>>>> static struct context_entry * device_to_context_entry(
>>>>                  struct intel_iommu *iommu, u8 bus, u8 devfn)
>>>> {
>>>>       ......
>>>>                   set_root_present(root);
>>>>       ......
>>>> }
>>>>
>>>> Calling tree:
>>>> ixgbe_open
>>>>       ixgbe_setup_tx_resources
>>>>           intel_alloc_coherent
>>>>               __intel_map_single
>>>>                   domain_context_mapping
>>>>                       domain_context_mapping_one
>>>>                           device_to_context_entry
>>>>
>>>> This means, the present bit in root entry will not be set until the device
>>>>    driver is loaded.
>>>>
>>>> But in the kdump kernel, some hardware device does not know the OS is the
>>>>    second kernel and the drivers should be loaded again, this causes there
>>>> are
>>>>    some unexpected DMA requsts on this device when it has not been
>>>> initialized,
>>>>    and then the DMA Remapping errors come.
>>>>
>>>> To fix this DMAR fault, we need to reset the bus that this device on.
>>>> Reset
>>>>    the device itself does not work.
>> This seems like something that could happen with *any* device, not
>> just the 82599 NIC.  Or is there something in the "kernel crash ->
>> kexec -> kdump kernel" path that stops DMA for most devices, but not
>> for the 82599?lex
>>
>
> This is an *any* device problem.  Specifically any device that is doing
> active DMA when a kdump kernel is triggered will cause this issue since
> the IOMMU will not have valid mappings for the DMA events until the
> device driver itself is loaded and resets the device.
>
> Thanks,
>
> Alex
>

