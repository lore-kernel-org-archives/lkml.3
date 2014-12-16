Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaLPBpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:45:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:9230 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaLPBpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:45:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="499250510"
Message-ID: <548F8EAA.80700@linux.intel.com>
Date: Tue, 16 Dec 2014 09:45:14 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/5] Fix Intel IRQ remapping initialization order
References: <1418656404-28575-1-git-send-email-joro@8bytes.org> <548EFE88.3000307@linux.intel.com> <alpine.DEB.2.11.1412152012000.17382@nanos>
In-Reply-To: <alpine.DEB.2.11.1412152012000.17382@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/12/16 3:54, Thomas Gleixner wrote:
> On Mon, 15 Dec 2014, Jiang Liu wrote:
>> On 2014/12/15 23:13, Joerg Roedel wrote:
>>> Hi,
>>>
>>> here is a patch-set against tip/x86/apic to fix an initialization order
>>> problem with the IRQ remapping code.  The problem is in the ordering of
>>> the irq_remapping_prepare and irq_remapping_supported functions.
>>>
>>> Currently the call-order is irq_remapping_prepare ->
>>> irq_remapping_supported, so that 'prepare' can succeed but 'supported'
>>> fails, so that interrupt remapping gets initialized but not enabled.
>>> This causes a broken interrupt setup on affected systems (machines with
>>> an Intel IOMMU without, or broken, IRQ remapping support). The result
>>> are lost interrupts and a non-bootable system.
>>>
>>> Both functions do checks whether IRQ remapping can be enabled on the
>>> machine.  The reason for this is that some checks rely on
>>> dmar_table_init() and thus have to be done in irq_remapping_prepare().
>>>
>>> This patch-set moves all these checks into the irq_remapping_prepare()
>>> path with the right ordering and removes the irq_remapping_supported()
>>> function and its call-backs. This fixes the initializion order problem
>>> and simplifies the exported API from the IOMMU code.
>>>
>>> Please review.
>> Hi Joerg,
>> 	I have posted a patch set for the same purpose at:
>> https://lkml.org/lkml/2014/12/10/20
>> 	Seems we need to combine these two patch sets:)
> 
> Actually you want to combine it also with these patches:
> 
> 326c2bb2c526: iommu/vt-d: Convert allocations to GFP_KERNEL
> e9220e591375: iommu/vt-d: Move iommu preparatory allocations to irq_remap_ops.prepare
> e88edbd316ea: iommu, x86: Restructure setup of the irq remapping feature
> dd60143c04f2: x86, smpboot: Remove pointless preempt_disable() in native_smp_prepare_cpus()
> 
> against 3.19 independent of the irqdomain stuff.
> 
> So that would be a clean base to put the rest of the irqdomain and
> hotplug stuff on top.
> 
> So the ordering of the patches for 3.20 would become:
> 
>    iommu cleanup (init and allocations)
>    acpi cleanup and parser extensions
>    ioapic hotplug
>    irqdomain conversion
> 
> I will route dd60143c04f2 "x86, smpboot: Remove pointless
> preempt_disable() in native_smp_prepare_cpus()" into -rc1.  I'm going
> to do so for a few other cherry-picks from x86/apic.
> 
> So can you please create a combined series, which just deals with the
> init cleanup and the allocation conversion (ATOMIC -> GFP) based on
> current Linus tree should be fine.
Hi Thomas,
	I will work on that, hope we will have something after Christmas Holiday:)
Regards!
Gerry
> 
> Thanks,
> 
> 	tglx
> 
