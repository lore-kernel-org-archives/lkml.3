Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaGGTlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:41:13 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:45817 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaGGTlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:41:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140704085741.GA12247@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com> <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com> <20140704085741.GA12247@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Jul 2014 13:40:48 -0600
Message-ID: <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        xen-devel@lists.xenproject.org,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 2:57 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Wed, Jul 02, 2014 at 02:22:01PM -0600, Bjorn Helgaas wrote:
>> On Tue, Jun 10, 2014 at 03:10:30PM +0200, Alexander Gordeev wrote:
>> > There are PCI devices that require a particular value written
>> > to the Multiple Message Enable (MME) register while aligned on
>> > power of 2 boundary value of actually used MSI vectors 'nvec'
>> > is a lesser of that MME value:
>> >
>> >     roundup_pow_of_two(nvec) < 'Multiple Message Enable'
>> >
>> > However the existing pci_enable_msi_block() interface is not
>> > able to configure such devices, since the value written to the
>> > MME register is calculated from the number of requested MSIs
>> > 'nvec':
>> >
>> >     'Multiple Message Enable' = roundup_pow_of_two(nvec)
>>
>> For MSI, software learns how many vectors a device requests by reading
>> the Multiple Message Capable (MMC) field.  This field is encoded, so a
>> device can only request 1, 2, 4, 8, etc., vectors.  It's impossible
>> for a device to request 3 vectors; it would have to round up that up
>> to a power of two and request 4 vectors.
>>
>> Software writes similarly encoded values to MME to tell the device how
>> many vectors have been allocated for its use.  For example, it's
>> impossible to tell the device that it can use 3 vectors; the OS has to
>> round that up and tell the device it can use 4 vectors.
>
> Nod.
>
>> So if I understand correctly, the point of this series is to take
>> advantage of device-specific knowledge, e.g., the device requests 4
>> vectors via MMC, but we "know" the device is only capable of using 3.
>> Moreover, we tell the device via MME that 4 vectors are available, but
>> we've only actually set up 3 of them.
>
> Exactly.
>
>> This makes me uneasy because we're lying to the device, and the device
>> is perfectly within spec to use all 4 of those vectors.  If anything
>> changes the number of vectors the device uses (new device revision,
>> firmware upgrade, etc.), this is liable to break.
>
> If a device committed via non-MSI specific means to send only 3 vectors
> out of 4 available why should we expect it to send 4? The probability of
> a firmware sending 4/4 vectors in this case is equal to the probability
> of sending 5/4 or 16/4, with the very same reason - a bug in the firmware.
> Moreover, even vector 4/4 would be unexpected by the device driver, though
> it is perfectly within the spec.
>
> As of new device revision or firmware update etc. - it is just yet another
> case of device driver vs the firmware match/mismatch. Not including this
> change does not help here at all IMHO.
>
>> Can you quantify the benefit of this?  Can't a device already use
>> MSI-X to request exactly the number of vectors it can use?  (I know
>
> A Intel AHCI chipset requires 16 vectors written to MME while advertises
> (via AHCI registers) and uses only 6. Even attempt to init 8 vectors results
> in device's fallback to 1 (!).

Is the fact that it uses only 6 vectors documented in the public spec?

Is this a chipset erratum?  Are there newer versions of the chipset
that fix this, e.g., by requesting 8 vectors and using 6, or by also
supporting MSI-X?

I know this conserves vector numbers.  What does that mean in real
user-visible terms?  Are there systems that won't boot because of this
issue, and this patch fixes them?  Does it enable bigger
configurations, e.g., more I/O devices, than before?

Do you know how Windows handles this?  Does it have a similar interface?

As you can tell, I'm a little skeptical about this.  It's a fairly big
change, it affects the arch interface, it seems to be targeted for
only a single chipset (though it's widely used), and we already
support a standard solution (MSI-X, reducing the number of vectors
requested, or even operating with 1 vector).

Bjorn
