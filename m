Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaKUUSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:18:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37437 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaKUUSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:18:34 -0500
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-mips@linux-mips.org, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, xen-devel@lists.xensource.com,
        linux@arm.linux.org.uk, vinod.koul@intel.com, deller@gmx.de,
        jejb@parisc-linux.org, dwmw2@infradead.org,
        Ian Campbell <Ian.Campbell@citrix.com>, alexander.deucher@amd.com,
        bhelgaas@google.com, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        iommu@lists.linux-foundation.org,
        David Vrabel <david.vrabel@citrix.com>, dmaengine@vger.kernel.org,
        torvalds@linux-foundation.org, christian.koenig@amd.com
Subject: Re: [RFC] add a struct page* parameter to dma_map_ops.unmap_page
References: <alpine.DEB.2.02.1411111644490.26318@kaball.uk.xensource.com>
	<alpine.DEB.2.02.1411211147450.12596@kaball.uk.xensource.com>
Date: Fri, 21 Nov 2014 12:18:32 -0800
In-Reply-To: <alpine.DEB.2.02.1411211147450.12596@kaball.uk.xensource.com>
	(Stefano Stabellini's message of "Fri, 21 Nov 2014 11:48:33 +0000")
Message-ID: <vnkwh9xs2tpj.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21 2014 at 03:48:33 AM, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 17 Nov 2014, Stefano Stabellini wrote:
>> Hi all,
>> I am writing this email to ask for your advice.
>> 
>> On architectures where dma addresses are different from physical
>> addresses, it can be difficult to retrieve the physical address of a
>> page from its dma address.
>> 
>> Specifically this is the case for Xen on arm and arm64 but I think that
>> other architectures might have the same issue.
>> 
>> Knowing the physical address is necessary to be able to issue any
>> required cache maintenance operations when unmap_page,
>> sync_single_for_cpu and sync_single_for_device are called.
>> 
>> Adding a struct page* parameter to unmap_page, sync_single_for_cpu and
>> sync_single_for_device would make Linux dma handling on Xen on arm and
>> arm64 much easier and quicker.
>> 
>> I think that other drivers have similar problems, such as the Intel
>> IOMMU driver having to call find_iova and walking down an rbtree to get
>> the physical address in its implementation of unmap_page.
>> 
>> Callers have the struct page* in their hands already from the previous
>> map_page call so it shouldn't be an issue for them.  A problem does
>> exist however: there are about 280 callers of dma_unmap_page and
>> pci_unmap_page. We have even more callers of the dma_sync_single_for_*
>> functions.
>> 
>> 
>> 
>> Is such a change even conceivable? How would one go about it?
>> 
>> I think that Xen would not be the only one to gain from it, but I would
>> like to have a confirmation from others: given the magnitude of the
>> changes involved I would actually prefer to avoid them unless multiple
>> drivers/archs/subsystems could really benefit from them.
>
> Given the lack of interest from the community, I am going to drop this
> idea.

Actually it sounds like the right API design to me.  As a bonus it
should help performance a bit as well.  For example, the current
implementations of dma_sync_single_for_{cpu,device} and dma_unmap_page
on ARM while using the IOMMU mapper
(arm_iommu_sync_single_for_{cpu,device}, arm_iommu_unmap_page) all call
iommu_iova_to_phys which generally results in a page table walk or a
hardware register write/poll/read.

The problem, as you mentioned, is that there are a ton of callers of the
existing APIs.  I think David Vrabel had a good suggestion for dealing
with this:

On Mon, Nov 17 2014 at 06:43:46 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> You may need to consider a parallel set of map/unmap API calls that
> return/accept a handle, and then converting drivers one-by-one as
> required, instead of trying to convert every single driver at once.

However, I'm not sure whether the costs of having a parallel set of APIs
outweigh the benefits of a cleaner API and a slight performance boost...
But I hope the idea isn't completely abandoned without some profiling or
other evidence of its benefits (e.g. patches showing how drivers could
be simplified with the new APIs).


-Mitch

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
