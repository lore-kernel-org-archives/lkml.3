Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab3HMUay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:30:54 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:57222 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab3HMUaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:30:52 -0400
MIME-Version: 1.0
In-Reply-To: <520A5B01.2010207@tilera.com>
References: <CAErSpo6SzUF44pk3HVyR5UUN0BJUHUz+Z5egWKCoGG70VuB6wg@mail.gmail.com>
 <520A5B01.2010207@tilera.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Aug 2013 14:30:31 -0600
Message-ID: <CAErSpo4sFPiuPLboJ_wsg2cketUaciP7EgmufJmuEEryJmDW7Q@mail.gmail.com>
Subject: Re: [PATCH v2] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        adam radford <aradford@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc James in case he has opinions on the DMA mask question]

On Tue, Aug 13, 2013 at 10:12 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> (Trimming the quoted material a little to try to keep this email under control.)
>
> On 8/12/2013 4:42 PM, Bjorn Helgaas wrote:
>> On Mon, Aug 12, 2013 at 1:42 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>>> On 8/9/2013 6:42 PM, Bjorn Helgaas wrote:
>>>> OK, so physical memory in the [3GB,4GB] range is unreachable via DMA
>>>> as you describe.  And even if DMA *could* reach it, the CPU couldn't
>>>> see it because CPU accesses to that range would go to PCI for the
>>>> memory-mapped BAR space, not to memory.
>>> Right.  Unreachability is only a problem if the DMA window overlaps [3G, 4G], and since the 64-bit DMA window is [1TB,2TB], the whole PA space can be reached by 64-bit capable devices.
>> So the [0-1TB] memory range (including [3GB-4GB]) is reachable by
>> 64-bit DMA to bus addresses [1TB-2TB].  But if the CPU can't see
>> physical memory from [3GB-4GB], how is it useful to DMA there?
>
> Sorry, looking back I can see that the thread is a little confusing.
> The CPU can see the whole PA space. The confusion comes from the BAR space
> in [3GB, 4GB].
>
> On Tile, we define the CPU memory space as follows:
>
> [0, 1TB]: PA
> [1TB + 3GB, 1TB + 4GB]: BAR space for RC port 0, in [3GB, 4GB]
> [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB]: BAR space for RC port N, in [3GB, 4GB]
>
> The mapping from [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB] to [3GB, 4GB] is done by a
> hardware PIO region, which generates PCI bus addresses in [3GB, 4GB] for MMIOs to
> the BAR space.

OK, I think I get it now.  CPU address space:
  [0, 1TB]: physical memory
  [1TB + 3GB, 1TB + 4GB]: translated to bus address [3GB, 4GB] under RC port 0
  [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB]: translated to bus address
[3GB, 4GB] under RC port N

Bus address space:
  [0, 3GB]: 32-bit DMA reaches physical memory [0, 3GB]
  [3GB, 4GB]: 32-bit DMA (peer-to-peer DMA under local RC port, I guess?)
  [1TB, 2TB]: 64-bit DMA mapped via IOMMU to physical memory [0, 1TB]

I guess the problem is that 32-bit DMA can't reach physical memory
[3GB, 4GB], so you're using bounce buffers so the bus address is in
[0, 3GB].  That makes sense, and I don't see another possibility other
than just throwing away the [3GB, 4GB] range by leaving it out of the
kernel allocator altogether, or using  hardware (which tilegx probably
doesn't have) to remap it somewhere else.

So it seems like just a question of how you wrap this all up in
dma_ops, and *that* is all arch stuff that I don't have an opinion on.

>>> Unfortunately, the Megaraid driver doesn’t even call pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)).
>> If the Megaraid driver needs that call, but it's missing, why wouldn't
>> we just add it?
>
> The Megaraid driver doesn’t strictly need that call on other platforms, because
> by default the device coherent_dma_mask is DMA_BIT_MASK(32) and the consistent
> memory pool doesn’t come from the bounce buffers on most other platforms.
>
> Of course, for the sake of correctness, this call should be added across all platforms.
> ...

> What is unique about Tile is that the PCI drivers must explicitly declare
> its DMA capability by calling pci_set_dma_mask() and pci_set_consistent_dma_mask().

It looks like the reason you need drivers to explicitly call
pci_set_dma_mask() and pci_set_consistent_dma_mask() is because you
have hooks in those functions to tweak the dma_ops, even though the
mask itself might not be changed.

That doesn't sound like a robust solution: we have well-known defaults
for the mask sizes, and I don't think it's reasonable to expect
drivers to explicitly set the mask even if they are happy with the
defaults (though Documentation/DMA-API-HOWTO.txt does say that being
explicit is good style).  I'm afraid you'll just keep tripping over
drivers that don't work on tilegx because they don't set the mask.

Bjorn
