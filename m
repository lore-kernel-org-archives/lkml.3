Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab3HNTK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:10:29 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:22805 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab3HNTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:10:25 -0400
Message-ID: <520BD61F.9080907@tilera.com>
Date: Wed, 14 Aug 2013 15:10:23 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        adam radford <aradford@gmail.com>
Subject: Re: [PATCH v2] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
References: <CAErSpo6SzUF44pk3HVyR5UUN0BJUHUz+Z5egWKCoGG70VuB6wg@mail.gmail.com> <520A5B01.2010207@tilera.com> <CAErSpo4sFPiuPLboJ_wsg2cketUaciP7EgmufJmuEEryJmDW7Q@mail.gmail.com>
In-Reply-To: <CAErSpo4sFPiuPLboJ_wsg2cketUaciP7EgmufJmuEEryJmDW7Q@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2013 4:30 PM, Bjorn Helgaas wrote:
> [+cc James in case he has opinions on the DMA mask question]
>
> On Tue, Aug 13, 2013 at 10:12 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> (Trimming the quoted material a little to try to keep this email under control.)
>>
>> On 8/12/2013 4:42 PM, Bjorn Helgaas wrote:
>>> On Mon, Aug 12, 2013 at 1:42 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>>> On 8/9/2013 6:42 PM, Bjorn Helgaas wrote:
>>>>> OK, so physical memory in the [3GB,4GB] range is unreachable via DMA
>>>>> as you describe.  And even if DMA *could* reach it, the CPU couldn't
>>>>> see it because CPU accesses to that range would go to PCI for the
>>>>> memory-mapped BAR space, not to memory.
>>>> Right.  Unreachability is only a problem if the DMA window overlaps [3G, 4G], and since the 64-bit DMA window is [1TB,2TB], the whole PA space can be reached by 64-bit capable devices.
>>> So the [0-1TB] memory range (including [3GB-4GB]) is reachable by
>>> 64-bit DMA to bus addresses [1TB-2TB].  But if the CPU can't see
>>> physical memory from [3GB-4GB], how is it useful to DMA there?
>> Sorry, looking back I can see that the thread is a little confusing.
>> The CPU can see the whole PA space. The confusion comes from the BAR space
>> in [3GB, 4GB].
>>
>> On Tile, we define the CPU memory space as follows:
>>
>> [0, 1TB]: PA
>> [1TB + 3GB, 1TB + 4GB]: BAR space for RC port 0, in [3GB, 4GB]
>> [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB]: BAR space for RC port N, in [3GB, 4GB]
>>
>> The mapping from [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB] to [3GB, 4GB] is done by a
>> hardware PIO region, which generates PCI bus addresses in [3GB, 4GB] for MMIOs to
>> the BAR space.
> OK, I think I get it now.  CPU address space:
>   [0, 1TB]: physical memory
>   [1TB + 3GB, 1TB + 4GB]: translated to bus address [3GB, 4GB] under RC port 0
>   [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB]: translated to bus address
> [3GB, 4GB] under RC port N
>
> Bus address space:
>   [0, 3GB]: 32-bit DMA reaches physical memory [0, 3GB]
>   [3GB, 4GB]: 32-bit DMA (peer-to-peer DMA under local RC port, I guess?)

Correct.

>   [1TB, 2TB]: 64-bit DMA mapped via IOMMU to physical memory [0, 1TB]
>
> I guess the problem is that 32-bit DMA can't reach physical memory
> [3GB, 4GB], so you're using bounce buffers so the bus address is in
> [0, 3GB].  That makes sense, and I don't see another possibility other
> than just throwing away the [3GB, 4GB] range by leaving it out of the
> kernel allocator altogether, or using  hardware (which tilegx probably
> doesn't have) to remap it somewhere else.
>
> So it seems like just a question of how you wrap this all up in
> dma_ops, and *that* is all arch stuff that I don't have an opinion on.
>
>>>> Unfortunately, the Megaraid driver doesn’t even call pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)).
>>> If the Megaraid driver needs that call, but it's missing, why wouldn't
>>> we just add it?
>> The Megaraid driver doesn’t strictly need that call on other platforms, because
>> by default the device coherent_dma_mask is DMA_BIT_MASK(32) and the consistent
>> memory pool doesn’t come from the bounce buffers on most other platforms.
>>
>> Of course, for the sake of correctness, this call should be added across all platforms.
>> ...
>> What is unique about Tile is that the PCI drivers must explicitly declare
>> its DMA capability by calling pci_set_dma_mask() and pci_set_consistent_dma_mask().
> It looks like the reason you need drivers to explicitly call
> pci_set_dma_mask() and pci_set_consistent_dma_mask() is because you
> have hooks in those functions to tweak the dma_ops, even though the
> mask itself might not be changed.
>
> That doesn't sound like a robust solution: we have well-known defaults
> for the mask sizes, and I don't think it's reasonable to expect
> drivers to explicitly set the mask even if they are happy with the
> defaults (though Documentation/DMA-API-HOWTO.txt does say that being
> explicit is good style).  I'm afraid you'll just keep tripping over
> drivers that don't work on tilegx because they don't set the mask.

Yes, I think you (and James) are right.  We will look at changing to a DMA_MASK(32) default and do some testing and see what that ends up looking like.

James also wrote:
> What you have is
> two different classes of memory: 0-3GB which is usable for I/O and 3-4GB
> which isn't.  Surely what you need to do is implement ZONE_DMA32? which
> stretches from 0-3GB, which means all kmallocs in the driver will be in
> the right range.  Then you need a bounce pfn at 3GB which means that
> user space which gets the 3-4GB is bounced.  There's a magic pfn in
> BLK_BOUNCE_HIGH that was designed for this, but I'm not sure the design
> contemplated BLK_BOUNCE_HIGH being different for 64 and 32 bit.

Well, we do have ZONE_DMA already, for PAs 0-4GB.  This is a sort of generally reasonable definition, and works well for 32-bit USB devices, for example.  But you're right that it does mean that sometimes something like swiotlb_alloc_coherent() might try to allocate memory for 32-bit PCI and get something that falls in the 3-4GB hole, and it then throws it away and uses map_single().  So arguably we should just shift our ZONE_DMA ceiling down to 3GB to make PCI more likely to get a usable page, though that penalizes 32-bit USB, and if we ever thought about expanding the size of the PCI BAR there, it would penalize it more.

Bottom line, though, it does seem like in general the 32-bit devices (both PCI and USB) that we see in practice are pretty low performance, so it's hard to worry too much about it, as long as they work.

I don't know that we've looked at the BLK_BOUNCE_xxx stuff much; I'm personally not very familiar with it, except that as you say, it seems to be hard-wired to -1ULL for 64-bit systems.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

