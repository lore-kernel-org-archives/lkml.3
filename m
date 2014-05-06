Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaEFUXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:23:15 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:39916 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaEFUXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140506085957.GQ4750@e106497-lin.cambridge.arm.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <1398953290.2313.15.camel@dabdike.int.hansenpartnership.com>
 <CAErSpo7zjXg8xrV7=q36rNp_g573P93HiXTB72Z1cZfjGeeBmg@mail.gmail.com>
 <20140502111807.GL4750@e106497-lin.cambridge.arm.com> <20140505224240.GA8883@google.com>
 <20140506085957.GQ4750@e106497-lin.cambridge.arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 May 2014 14:22:50 -0600
Message-ID: <CAErSpo5wrHFv1c3dnKrGdVKbjM6WqqSocKbYA_zHc35Uc=x3gw@mail.gmail.com>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU address
 to phys_addr_t
To: Bjorn Helgaas <bhelgaas@google.com>,
        James Bottomley <jbottomley@parallels.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 2:59 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Mon, May 05, 2014 at 11:42:40PM +0100, Bjorn Helgaas wrote:
>> On Fri, May 02, 2014 at 12:18:07PM +0100, Liviu Dudau wrote:
>> > On Thu, May 01, 2014 at 08:05:04PM +0100, Bjorn Helgaas wrote:

>> > > I'm not a CPU
>> > > person, so I don't understand the usefulness of dma_addr_t as a
>> > > separate type to hold CPU addresses at which memory-mapped devices can
>> > > appear.  If that's all it is, why not just use phys_addr_t everywhere
>> > > and get rid of dma_addr_t altogether?
>> >
>> > Because dma_addr_t imposes further restrictions based on what the DMA engine
>> > can access. You could have a DMA engine that can only access 32bit addresses
>> > in a 40+ bit CPU addresses system.
>>
>> Yes; this is an argument for having separate types for bus addresses
>> and CPU addresses.  I think dma_addr_t *is* for bus addresses.  I
>> thought James was suggesting that it was a subset of CPU physical
>> address space, and that any valid dma_addr_t is also a valid
>> phys_addr_t.  That doesn't seem right to me.
>
> I'm actually more inclined towards James' view. To me the DMA engine is a very
> specialised CPU that does memcpy(). You can pair it with an IOMMU engine and
> you can have address translation into virtual space of any size you want, or
> you can have the engine sitting behind a bus in which case it will use bus
> addresses. But its uses of addresses is similar to a CPU (whenever you want to
> call them phys_addr_t or not is a different discussion).
>
> ARM has a PL330 DMA engine. It's a SoC component and usually doesn't get attached
> to any PCI bus. It uses a system bus called AXI in the same way a CPU would. So
> for that having a *bus* address does not fit with the way hardware is connected.
>
> My mental picture for this discussion is a hypotetical DMA engine that sits on
> a PCI bus but has access to the system memory that the CPU can see (sort of like
> a DMA engine inside a host bridge). Would you use a phys_addr_t when programming
> the device or a bus address? I would say the former, because you know how to
> translate that into bus addresses and back in the host bridge.

I don't think the physical location of the DMA engine is important.  I
think what matters is how you program it.  If it fully participates in
the single shared virtual address space used by the main CPUs, i.e.,
it uses the same page tables and TLB management and is cache-coherent
with them, then you'd probably give it virtual source and destination
addresses.  But my guess is the DMA engine operates on some flavor of
physical address and is outside the coherency domain.  In that case,
you probably have to allocate wired buffers to avoid faults, and you
probably have to use the DMA API (DMA_TO_DEVICE, DMA_FROM_DEVICE,
etc.) to manage cache coherency.  The DMA API gives you back a bus
address just like it does for ordinary devices, even if the value of
that address happens to be identical to the CPU physical address.

Should that bus address be a phys_addr_t instead of a dma_addr_t?  I
dunno.  We have a pretty long history of using dma_addr_t to hold bus
addresses, and I don't see a compelling reason to change, and the
separate type does help me understand the code.

I'll write some text about dma_addr_t in the docs when I repost these
patches and maybe we can converge on something.

Bjorn
