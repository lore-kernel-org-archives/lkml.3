Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaGGT1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:27:10 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35366 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaGGT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140704085816.GB12247@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com> <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com> <063D6719AE5E284EB5DD2968C1650D6D1726BF4E@AcuExch.aculab.com>
 <20140704085816.GB12247@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Jul 2014 13:26:43 -0600
Message-ID: <CAErSpo7QWc35seoMhJA+H1_=MkKWYMdeYG=hT=i1v=iz8d5ezA@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: David Laight <David.Laight@aculab.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 2:58 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Thu, Jul 03, 2014 at 09:20:52AM +0000, David Laight wrote:
>> From: Bjorn Helgaas
>> > On Tue, Jun 10, 2014 at 03:10:30PM +0200, Alexander Gordeev wrote:
>> > > There are PCI devices that require a particular value written
>> > > to the Multiple Message Enable (MME) register while aligned on
>> > > power of 2 boundary value of actually used MSI vectors 'nvec'
>> > > is a lesser of that MME value:
>> > >
>> > >   roundup_pow_of_two(nvec) < 'Multiple Message Enable'
>> > >
>> > > However the existing pci_enable_msi_block() interface is not
>> > > able to configure such devices, since the value written to the
>> > > MME register is calculated from the number of requested MSIs
>> > > 'nvec':
>> > >
>> > >   'Multiple Message Enable' = roundup_pow_of_two(nvec)
>> >
>> > For MSI, software learns how many vectors a device requests by reading
>> > the Multiple Message Capable (MMC) field.  This field is encoded, so a
>> > device can only request 1, 2, 4, 8, etc., vectors.  It's impossible
>> > for a device to request 3 vectors; it would have to round up that up
>> > to a power of two and request 4 vectors.
>> >
>> > Software writes similarly encoded values to MME to tell the device how
>> > many vectors have been allocated for its use.  For example, it's
>> > impossible to tell the device that it can use 3 vectors; the OS has to
>> > round that up and tell the device it can use 4 vectors.
>> >
>> > So if I understand correctly, the point of this series is to take
>> > advantage of device-specific knowledge, e.g., the device requests 4
>> > vectors via MMC, but we "know" the device is only capable of using 3.
>> > Moreover, we tell the device via MME that 4 vectors are available, but
>> > we've only actually set up 3 of them.
>> ...
>>
>> Even if you do that, you ought to write valid interrupt information
>> into the 4th slot (maybe replicating one of the earlier interrupts).
>> Then, if the device does raise the 'unexpected' interrupt you don't
>> get a write to a random kernel location.
>
> I might be missing something, but we are talking of MSI address space
> here, aren't we? I am not getting how we could end up with a 'write'
> to a random kernel location when a unclaimed MSI vector sent. We could
> only expect a spurious interrupt at worst, which is handled and reported.

Yes, that's how I understand it.  With MSI, the OS specifies the a
single Message Address, e.g., a LAPIC address, and a single Message
Data value, e.g., a vector number that will be written to the LAPIC.
The device is permitted to modify some low-order bits of the Message
Data to send one of several vector numbers (the MME value tells the
device how many bits it can modify).

Bottom line, I think a spurious interrupt is the failure we'd expect
if a device used more vectors than the OS expects it to.

Bjorn
