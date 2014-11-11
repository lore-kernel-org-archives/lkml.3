Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaKKRTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:19:55 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:46111 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaKKRTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:19:52 -0500
MIME-Version: 1.0
In-Reply-To: <20141111155744.GB4419@red-moon>
References: <1414168089-8130-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1414168089-8130-2-git-send-email-lorenzo.pieralisi@arm.com>
 <20141110230454.GA21470@google.com> <20141111114825.GA4135@red-moon>
 <CAErSpo4nWpN0xDb3h7FCpExM-Q5fmr5oyuOLf6Y_w55HEQZP4w@mail.gmail.com> <20141111155744.GB4419@red-moon>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Nov 2014 10:19:31 -0700
Message-ID: <CAErSpo4bZn20LZjrayx=B51eHnNyrHHWFQMB3J_+EQF8ntg0Kw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/2] drivers: pci: fix pci_mmap_fits()
 implementation for procfs mmap
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <monstr@monstr.eu>,
        Martin Wilck <martin.wilck@ts.fujitsu.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 8:57 AM, Lorenzo Pieralisi
<lorenzo.pieralisi@arm.com> wrote:
> On Tue, Nov 11, 2014 at 02:20:31PM +0000, Bjorn Helgaas wrote:
>> On Tue, Nov 11, 2014 at 4:48 AM, Lorenzo Pieralisi
>> <lorenzo.pieralisi@arm.com> wrote:
>> > On Mon, Nov 10, 2014 at 11:04:54PM +0000, Bjorn Helgaas wrote:
>> >> ...
>> >> Here's what I think I understand so far:
>> >>
>> >>   Applications can mmap PCI memory space via either sysfs or procfs (the
>> >>   procfs method is deprecated but still supported):
>> >>
>> >>     - In sysfs, there's a separate /sys/devices/pci*/.../resource* file
>> >>       for each device BAR, and the application opens the appropriate
>> >>       file and supplies the offset from the beginning of the BAR as the
>> >>       mmap(2) offset.
>> >>
>> >>     - In procfs, the application opens the single /proc/bus/pci/... file
>> >>       for the device.  On most platforms, it supplies the CPU physical
>> >>       address as the mmap(2) offset.  On a few platforms, such as SPARC,
>> >>       it supplies the bus address, i.e., a BAR value, instead.
>> >>
>> >> But I'm not sure I have this right.  If the procfs offset is either the
>> >> CPU physical address or the BAR value, then pci_resource_to_user()
>> >> should be (depending on the arch) either a no-op or use
>> >> pci_resource_to_bus().
>> >
>> > Exactly (pcibios_resource_to_bus() ?).
>> >
>> >> But that's not how it's implemented.  Maybe it *could* be?  If
>> >> pci_resource_to_user() gives you something that's not a CPU physical
>> >> address and not a bus address, what *does* it give you, and why would we
>> >> need this third kind of thing?
>> >
>> > Well, you need a per arch function implementation where to define if
>> > the conversion from CPU physical address to PCI bus should take place
>> > or not right ? As you mentioned above, if that should be a per-arch
>> > decision, there has to be a per-arch function to filter the resource
>> > in question, I guess that's my understanding behind pci_resource_to_user(),
>> > but I am not sure either, and understanding that was the primary reason
>> > for this patchset so comments are welcome.
>>
>> I agree that we need pci_resource_to_user() because arches do
>> different things, so we can't just remove pci_resource_to_user() and
>> replace it with pci_resource_to_bus().  My point is that we have a
>> generic pci_resource_to_user() implementation that does nothing, and
>> if an arch *does* implement its own pci_resource_to_user(), it seems
>> like it should simply call pci_resource_to_user().
>
> to_bus() you mean.

Yes, exactly, sorry for my typo.  (And earlier, when I said
pci_resource_to_bus() instead of pcibios_resource_to_bus().
pcibios_resource_to_bus() *used* to be an arch-specific function with
many implementations, which is why it's named pcibios_*.  Now that the
PCI core supports address translation, it's no longer arch-specific.
We haven't changed the name to reflect that, but I don't think of it
along with the rest of the pcibios_*() functions anymore.  Hmm, and
now we have this pci_resource_to_user() thing, which *is*
arch-specific, but doesn't have a pcibios_* name.  No wonder this is
confusing :))

> Well, I agree, but I am not sure it would work on all
> arches that deviate from the generic implementation, I can't speak for other
> architectures since I do not have an in-depth knowledge of their PCI
> internal implementations, in particular in relation to CPU <-> PCI
> address map conversions/mappings.
>
> I read your comment as an agreement on the approach I took in my patch,
> except for the current pci_resource_to_user() implementation(s), which I did
> not touch.

Yes.  I have two things I'd like to clear up:

  1) Your patch changes behavior on platforms that implement their own
pci_resource_to_user().  So I'd like to mention the details of that in
the changelog, e.g., "procfs mmap on arches X, Y, Z has been broken
since commit C, and this change fixes them."  ARM doesn't implement
pci_resource_to_user(), so I don't think ARM is one of those arches.
But I'd really like to include specifics on what those arches are, and
what we think is currently broken, so their maintainers at least get a
heads-up and can look for that  breakage.

  2) I'd like to take this opportunity to analyze the current
pci_resource_to_user() implementations and see if we can reduce them
to calling pcibios_resource_to_bus().  This is obviously separable,
and I'll apply these patches anyway, but this does seem like a perfect
opportunity for someone (not necessarily you) to clean this stuff up,
since it's fresh in our minds.

Bjorn
