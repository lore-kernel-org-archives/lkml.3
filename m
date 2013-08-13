Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab3HMQMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:12:53 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:53998 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758448Ab3HMQMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:12:50 -0400
Message-ID: <520A5B01.2010207@tilera.com>
Date: Tue, 13 Aug 2013 12:12:49 -0400
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
References: <CAErSpo6SzUF44pk3HVyR5UUN0BJUHUz+Z5egWKCoGG70VuB6wg@mail.gmail.com>
In-Reply-To: <CAErSpo6SzUF44pk3HVyR5UUN0BJUHUz+Z5egWKCoGG70VuB6wg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Trimming the quoted material a little to try to keep this email under control.)

On 8/12/2013 4:42 PM, Bjorn Helgaas wrote:
> On Mon, Aug 12, 2013 at 1:42 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> On 8/9/2013 6:42 PM, Bjorn Helgaas wrote:
>>> OK, so physical memory in the [3GB,4GB] range is unreachable via DMA
>>> as you describe.  And even if DMA *could* reach it, the CPU couldn't
>>> see it because CPU accesses to that range would go to PCI for the
>>> memory-mapped BAR space, not to memory.
>> Right.  Unreachability is only a problem if the DMA window overlaps [3G, 4G], and since the 64-bit DMA window is [1TB,2TB], the whole PA space can be reached by 64-bit capable devices.
> So the [0-1TB] memory range (including [3GB-4GB]) is reachable by
> 64-bit DMA to bus addresses [1TB-2TB].  But if the CPU can't see
> physical memory from [3GB-4GB], how is it useful to DMA there?

Sorry, looking back I can see that the thread is a little confusing.
The CPU can see the whole PA space. The confusion comes from the BAR space
in [3GB, 4GB].

On Tile, we define the CPU memory space as follows:

[0, 1TB]: PA
[1TB + 3GB, 1TB + 4GB]: BAR space for RC port 0, in [3GB, 4GB]
[1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB]: BAR space for RC port N, in [3GB, 4GB]

The mapping from [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB] to [3GB, 4GB] is done by a
hardware PIO region, which generates PCI bus addresses in [3GB, 4GB] for MMIOs to
the BAR space.

>> Unfortunately, the Megaraid driver doesn’t even call pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)).
> If the Megaraid driver needs that call, but it's missing, why wouldn't
> we just add it?

The Megaraid driver doesn’t strictly need that call on other platforms, because
by default the device coherent_dma_mask is DMA_BIT_MASK(32) and the consistent
memory pool doesn’t come from the bounce buffers on most other platforms.

Of course, for the sake of correctness, this call should be added across all platforms.

>> More generally, your proposed DMA space suggestion isn't optimal because then the PA in [3GB, 4GB] can’t be reached by 64-bit capable devices.
> True.  I assumed it wasn't useful to DMA there because the CPU
> couldn't see that memory anyway.  But apparently that assumption was
> wrong?

Correct.

>>>> Given all of that, does this change make sense? I can certainly
>>>> amend the commit description to include more commentary.
>>> Obviously, I'm missing something.  I guess it really doesn't matter
>>> because this is all arch code and I don't need to understand it, but
>>> it does niggle at me somehow.
>> I will add the following comment to <asm/pci.h> in hopes of making it a bit clearer:
>>
>>  /*
>>  [...]
>> + * This design lets us avoid the "PCI hole" problem where the host bridge
>> + * won't pass DMA traffic with target addresses that happen to fall within the
>> + * BAR space. This enables us to use all the physical memory for DMA, instead
>> + * of wasting the same amount of physical memory as the BAR window size.
> By "target addresses", I guess you mean the bus address, not the CPU
> address, right?

Correct.

> The whole reason I'm interested in this is to figure out whether this
> change is really specific to Tile, or whether other architectures need
> similar changes.  I think host bridges on other arches behave the same
> way (they don't allow DMA to addresses in the PCI hole), so I still
> haven't figured out what is truly Tile-specific.

What is unique about Tile is that the PCI drivers must explicitly declare
its DMA capability by calling pci_set_dma_mask() and pci_set_consistent_dma_mask().

This is why we must patch those drivers that don’t call pci_set_consistent_dma_mask(),
as is the case in the Megaraid driver.

> I guess the ability for 64-bit DMA to reach the PCI hole (3GB-4GB)
> might be unique, but it doesn't sound useful.

It seems like other architectures might benefit from the approach we've taken
with tile, but it's certainly disruptive enough that it might not be worth it.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

