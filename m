Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3HLToN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:44:13 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27157 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab3HLToK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:44:10 -0400
Message-ID: <52093B09.7030301@tilera.com>
Date: Mon, 12 Aug 2013 15:44:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        adam radford <aradford@gmail.com>
Subject: Re: [PATCH v2] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
References: <52012B96.9000207@tilera.com> <201308061702.r76H2ORe011248@farm-0021.internal.tilera.com> <CAErSpo57cmg2ynLLLZw0yXH5Q1B0MZBdqSgFXUu2NpS=8W6Y2g@mail.gmail.com> <5203CB8E.60509@tilera.com> <20130809224228.GA31372@google.com>
In-Reply-To: <20130809224228.GA31372@google.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Oops, resending without the helpful [SPAM] marker that our
mail system appears to have injected into the subject line.)

On 8/9/2013 6:42 PM, Bjorn Helgaas wrote:
> On Thu, Aug 08, 2013 at 12:47:10PM -0400, Chris Metcalf wrote:
>> On 8/6/2013 1:48 PM, Bjorn Helgaas wrote:
>>> [+cc Myron, Adam]
>>>
>>> On Fri, Aug 2, 2013 at 10:24 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>>> According to LSI,
>>>> the firmware is not fully functional yet. This change implements a
>>>> kind of hybrid dma_ops to support this.
>>>>
>>>> Note that on most other platforms, the 64-bit DMA addressing space is the
>>>> same as the 32-bit DMA space and they overlap the physical memory space.
>>>> No special arrangement is needed to support this kind of mixed DMA
>>>> capability.  On TILE-Gx, the 64-bit DMA space is completely separate
>>>> from the 32-bit DMA space.
>>> Help me understand what's going on here.  My understanding is that on
>>> typical systems, the 32-bit DMA space is a subset of the 64-bit DMA
>>> space.  In conventional PCI, "a master that supports 64-bit addressing
>>> must generate a SAC, instead of a DAC, when the upper 32 bits of the
>>> address are zero" (PCI spec r3.0, sec 3.9).  PCIe doesn't have
>>> SAC/DAC, but it has both 32-bit and 64-bit address headers and has a
>>> similar requirement: "For Addresses below 4GB, Requesters must use the
>>> 32-bit format" (PCIe spec r3.0, sec 2.2.4.1).
>>>
>>> Those imply to me that the 0-4GB region of the 64-bit DMA space must
>>> be identical to the 0-4GB 32-bit DMA space, and in fact, the receiver
>>> of a transaction shouldn't be able to distinguish them.
>>>
>>> But it sounds like something's different on TILE-Gx?  Does it
>>> translate bus addresses to physical memory addresses based on the type
>>> of the transaction (SAC vs DAC, or 32-bit vs 64-bit header) in
>>> addition to the address?  Even if it does, the spec doesn't allow a
>>> DAC cycle or a 64-bit header where the 32 high-order bits are zero, so
>>> it shouldn't matter.
>> No, we don't translate based on the type of the transaction. Using
>> "DMA space" in the commit message was probably misleading. What's
>> really going on is different DMA windows. 32-bit DMA has the
>> obvious naive implementation where [0,4GB] in DMA space maps to
>> [0,4GB] in PA space.  However, for 64-bit DMA, we use DMA
>> addresses with a non-zero high 32 bits, in the [1TB,2TB] range,
>> but map the results down to PA [0,1TB] using our IOMMU.
> I guess this means devices can DMA to physical addresses [0,3GB]
> using either 32-bit bus addresses in the [0,3GB] range or 64-bit bus
> addresses in the [1TB,1TB+3GB] range, right?

True in general, but not true for any specific individual device.

64-bit capable devices won’t generate 32-bit bus addresses, because
the dma_ops makes sure that only bus/DMA addresses in [1TB,1TB+3GB]
are handed out to the devices.

32-bit only devices use bus addresses in [0,3GB] to access the PA [0,3GB].
PA in [3GB, 4GB] is not accessed by the 32-bit only devices because the
bounce buffers are allocated under 3GB limit.

>> We did consider having the 64-bit DMA window be [0,1TB] and map
>> directly to PA space, like the 32-bit window. But this design
>> suffers from the “PCI hole” problem. Basically, the BAR space is
>> usually under 4GB (it occupies the range [3GB, 4GB] on tilegx) and
>> the host bridge uses negative decoding in passing DMA traffic
>> upstream. That is, DMA traffic with target address in [3GB, 4GB]
>> are not passed to the host memory. This means that the same amount
>> of physical memory as the BAR space cannot be used for DMA
>> purpose. And because it is not easy avoid this region in
>> allocating DMA memory, the kernel is simply told to not use this
>> chunk of PA at all, so it is wasted.
> OK, so physical memory in the [3GB,4GB] range is unreachable via DMA
> as you describe.  And even if DMA *could* reach it, the CPU couldn't
> see it because CPU accesses to that range would go to PCI for the
> memory-mapped BAR space, not to memory.

Right.  Unreachability is only a problem if the DMA window overlaps
[3G, 4G], and since the 64-bit DMA window is [1TB,2TB], the whole PA
space can be reached by 64-bit capable devices.

> But I can't figure out why Tile needs to do something special.  I
> think other arches handle the PCI hole for MMIO space the same way.
>
> I don't know if other arches alias the [0,3GB] physical address
> range in both 32-bit and 64-bit DMA space like you do, but if that's
> part of the problem, it seems like you could easily avoid the
> aliasing by making the 64-bit DMA space [1TB+4GB,2TB] instead of
> [1TB,2TB].

Perhaps, but since 64-bit capable devices can't actually see the
aliasing (since they aren't offered the [0,4GB] address range) they
only see an un-aliased space.

>> For the LSI device, the way we manage it is to ensure that the
>> device’s streaming buffers and the consistent buffers come from
>> different pools, with the latter using the under-4GB bounce
>> buffers. Obviously, normal devices use the same buffer pool for
>> both streaming and consistent, either under 4GB or the whole PA.
> It seems like you could make your DMA space be the union of [0,3GB]
> and [1TB+4GB,2TB], then use pci_set_dma_mask(dev, DMA_BIT_MASK(64))
> and pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)) (I assume the
> driver already sets those masks correctly if it works on other
> arches).

Unfortunately, the Megaraid driver doesn’t even call
pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)).

More generally, your proposed DMA space suggestion isn't optimal because
then the PA in [3GB, 4GB] can’t be reached by 64-bit capable devices.

>> Given all of that, does this change make sense? I can certainly
>> amend the commit description to include more commentary.
> Obviously, I'm missing something.  I guess it really doesn't matter
> because this is all arch code and I don't need to understand it, but
> it does niggle at me somehow.

I will add the following comment to <asm/pci.h> in hopes of making it a
bit clearer:

 /*
 [...]
+ * This design lets us avoid the "PCI hole" problem where the host bridge
+ * won't pass DMA traffic with target addresses that happen to fall within the
+ * BAR space. This enables us to use all the physical memory for DMA, instead
+ * of wasting the same amount of physical memory as the BAR window size.
  */
 #define        TILE_PCI_MEM_MAP_BASE_OFFSET    (1ULL << CHIP_PA_WIDTH())

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

