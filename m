Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBYCA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:00:57 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61983 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaBYCAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:00:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140225001748.GS21483@n2100.arm.linux.org.uk>
References: <201402241200.21944.arnd@arndb.de>
	<CANqRtoTLUfK7bjhmUbTdBi7r7OzrmwdAg_wnRbGHN7EUjGtouQ@mail.gmail.com>
	<20140225001748.GS21483@n2100.arm.linux.org.uk>
Date: Tue, 25 Feb 2014 11:00:52 +0900
Message-ID: <CANqRtoSsra-NQF_4dz1iBjzEvdaUco9o3gbPi_6rEgswV=maCw@mail.gmail.com>
Subject: Re: DMABOUNCE in pci-rcar
From: Magnus Damm <magnus.damm@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Magnus Damm <damm@opensource.se>,
        linux-pci@vger.kernel.org, Simon Horman <horms+renesas@verge.net.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Tue, Feb 25, 2014 at 9:17 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Feb 25, 2014 at 08:49:28AM +0900, Magnus Damm wrote:
>> On Mon, Feb 24, 2014 at 8:00 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> >From my point of view we need some kind of bounce buffer unless we
>> have IOMMU support. I understand that an IOMMU would be much better
>> than a software-based implementation. If it is possible to use an
>> IOMMU with these devices remain to be seen.
>>
>> I didn't know about the SWIOTLB code, neither did I know that
>> DMABOUNCE was supposed to be avoided. Now I do!
>
> The reason DMABOUNCE should be avoided is because it is a known source
> of OOMs, and that has never been investigated and fixed.  You can read
> about some of the kinds of problems this code creates here:
>
> http://webcache.googleusercontent.com/search?q=cache:jwl4g8hqWa8J:comments.gmane.org/gmane.linux.ports.arm.kernel/15850+&cd=2&hl=en&ct=clnk&gl=uk&client=firefox-a
>
> That was never got to the bottom of.  I could harp on about not having
> the hardware, the people with the hardware not being capable of debugging
> it, or not willing to litter their kernels with printks when they've
> found a reproducable way to trigger it, etc - but none of that really
> matters.
>
> What matters is the end result is nothing was ever done to investigate
> the causes, so it remains "unsafe" to use.

Thanks for the pointer! It is good to know.

>> I do realize that my following patches madly mix potential bus code
>> and actual device support, however..
>>
>> [PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support
>> [PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM
>>
>> .. without my patches the driver does not handle CONFIG_BOUNCE and
>> CONFIG_VMSPLIT_2G.
>
> Can we please kill the idea that CONFIG_VMSPLIT_* has something to do
> with DMA?  It doesn't.  VMSPLIT sets where the boundary between userspace
> and kernel space is placed in virtual memory.  It doesn't really change
> which memory is DMA-able.
>
> There is the BLK_BOUNCE_HIGH option, but that's more to do with drivers
> saying "I don't handle highmem pages because I'm old and no one's updated
> me".

Spot on! =)

>From my observations drivers saying that they don't support HIGHMEM
may actually mean that they have a certain physical address
limitation. For instance, if you want to misuse the zones then on a
32-bit system not supporting HIGHMEM will guarantee that your memory
is within 32-bits. I'm not saying anyone should do that, but I'm sure
that kind of stuff is all over the place. =)

> The same is true of highmem vs bouncing for DMA.  Highmem is purely a
> virtual memory concept and has /nothing/ to do with whether the memory
> can be DMA'd to.
>
> Let's take an extreme example.  Let's say I set a 3G VM split, so kernel
> memory starts at 0xc0000000.  I then set the vmalloc space to be 1024M -
> but the kernel strinks that down to the maximum that can be accomodated,
> which leaves something like 16MB of lowmem.  Let's say I have 512MB of
> RAM in the machine.
>
> Now let's consider I do the same thing, but with a 2G VM split.  Has the
> memory pages which can be DMA'd to changed at all?  Yes, the CPU's view
> of pages has changed, but the DMA engine's view hasn't changed /one/ /bit/.
>
> Now consider when vmalloc space isn't expanded to maximum and all that
> RAM is mapped into the kernel direct mapped region.  Again, any
> difference as far as the DMA engine goes?  No there isn't.
>
> So, the idea that highmem or vmsplit has any kind of impact on whether
> memory can be DMA'd to by the hardware is absolutely absurd.
>
> VMsplit and highmem are a CPU visible concept, and has very little to do
> with whether the memory is DMA-able.

I totally agree with what you are saying. If the memory is arranged as
DMA zone or lowmem or HIGHMEM does not matter much from a hardware
point or view. The hardware addressing limitation and the software
concepts of memory zones are often mixed together - I suppose the DMA
zone is the only case where they may have any relation.

The most basic hardware limitation we have with this particular PCI
bridge is that it can only do bus master memory access within the
lowest 32-bits of physical address space (no high LPAE memory banks).
And to make it more complicated, the hardware is even more restriced
than that - the physical address space where bus mastering can happen
is limited to 1 GiB. (The PCI bridge hardware itself can do 2 GiB
window but it must be mapped a 0x8... The on-board memory banks are
designed with 2 GiB memory starting from 0x4.. so out of that only
1GiB remains useful)

The reason why the VMSPLIT was brought up was that the existing
hard-coded 1GiB window happens to work with the common 3G VM split
because lowmem also happens to be within 1 GiB. I suppose the code was
written with "luck" so to say.

The issue is when VMSPLIT is changed to 2G then the 1GiB PCI bus
master limitation will be visible and things will bomb out. I solve
that by using DMABOUNCE to support any VMSPLIT configuration with 1GiB
of bus mastering ability.

And the DMABOUNCE code does not support HIGHMEM, so because of that
the block layer BOUNCE is also used.

Thanks for your help.

Cheers,

/ magnus
