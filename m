Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaGIQHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:07:12 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:51674 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaGIQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140708122606.GB6270@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com> <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com> <20140704085741.GA12247@dhcp-26-207.brq.redhat.com>
 <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com> <20140708122606.GB6270@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Jul 2014 10:06:48 -0600
Message-ID: <CAErSpo4oiabgoOjsGdWZpCMPnmopK4xRzB2f3tM0AiUFrdhFww@mail.gmail.com>
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 6:26 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Mon, Jul 07, 2014 at 01:40:48PM -0600, Bjorn Helgaas wrote:
>> >> Can you quantify the benefit of this?  Can't a device already use
>> >> MSI-X to request exactly the number of vectors it can use?  (I know
>> >
>> > A Intel AHCI chipset requires 16 vectors written to MME while advertises
>> > (via AHCI registers) and uses only 6. Even attempt to init 8 vectors results
>> > in device's fallback to 1 (!).
>>
>> Is the fact that it uses only 6 vectors documented in the public spec?
>
> Yes, it is documented in ICH specs.

Out of curiosity, do you have a pointer to this?  It looks like it
uses one vector per port, and I'm wondering if the reason it requests
16 is because there's some possibility of a part with more than 8
ports.

>> Is this a chipset erratum?  Are there newer versions of the chipset
>> that fix this, e.g., by requesting 8 vectors and using 6, or by also
>> supporting MSI-X?
>
> No, this is not an erratum. The value of 8 vectors is reserved and could
> cause undefined results if used.

As I read the spec (PCI 3.0, sec 6.8.1.3), if MMC contains 0b100
(requesting 16 vectors), the OS is allowed to allocate 1, 2, 4, 8, or
16 vectors.  If allocating 8 vectors and writing 0b011 to MME causes
undefined results, I'd say that's a chipset defect.

>> I know this conserves vector numbers.  What does that mean in real
>> user-visible terms?  Are there systems that won't boot because of this
>> issue, and this patch fixes them?  Does it enable bigger
>> configurations, e.g., more I/O devices, than before?
>
> Visibly, it ceases logging messages ('ahci 0000:00:1f.2: irq 107 for
> MSI/MSI-X') for IRQs that are not shown in /proc/interrupts later.
>
> No, it does not enable/fix any existing hardware issue I am aware of.
> It just saves a couple of interrupt vectors, as Michael put it (10/16
> to be precise). However, interrupt vectors space is pretty much scarce
> resource on x86 and a risk of exhausting the vectors (and introducing
> quota i.e) has already been raised AFAIR.

I'm not too concerned about the logging issue.  If necessary, we could
tweak that message somehow.

Interrupt vector space is the issue I would worry about, but I think
I'm going to put this on the back burner until it actually becomes a
problem.

>> Do you know how Windows handles this?  Does it have a similar interface?
>
> Have no clue, TBH. Can try to investigate if you see it helpful.

No, don't worry about investigating.  I was just curious because if
Windows *did* support something like this, that would be an indication
that there's a significant problem here and we might need to solve it,
too.  But it sounds like we can safely ignore it for now.

Bjorn
