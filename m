Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaGJRCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:02:48 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:40563 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaGJRCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140710101151.GA21629@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com> <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com> <20140704085741.GA12247@dhcp-26-207.brq.redhat.com>
 <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com>
 <20140708122606.GB6270@dhcp-26-207.brq.redhat.com> <CAErSpo4oiabgoOjsGdWZpCMPnmopK4xRzB2f3tM0AiUFrdhFww@mail.gmail.com>
 <20140710101151.GA21629@dhcp-26-207.brq.redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 10 Jul 2014 11:02:24 -0600
Message-ID: <CAErSpo6p=teHx+ZG9yritgcBvOer-FNtug4-WQQQkHhPhTLjZw@mail.gmail.com>
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

On Thu, Jul 10, 2014 at 4:11 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> On Wed, Jul 09, 2014 at 10:06:48AM -0600, Bjorn Helgaas wrote:
>> Out of curiosity, do you have a pointer to this?  It looks like it
>
> I.e. ICH8 chapter 12.1.30 or ICH10 chapter 14.1.27
>
>> uses one vector per port, and I'm wondering if the reason it requests
>> 16 is because there's some possibility of a part with more than 8
>> ports.
>
> I doubt that is the reason. The only allowed MME values (powers of two)
> are 0b000, 0b001, 0b010 and 0b100. As you can see, only one bit is used -
> I would speculate it suits nicely to some hardware logic.
>
> BTW, apart from AHCI, it seems the reason MSI is not going to disappear
> (in a decade at least) is it is way cheaper to implement than MSI-X.
>
>> > No, this is not an erratum. The value of 8 vectors is reserved and could
>> > cause undefined results if used.
>>
>> As I read the spec (PCI 3.0, sec 6.8.1.3), if MMC contains 0b100
>> (requesting 16 vectors), the OS is allowed to allocate 1, 2, 4, 8, or
>> 16 vectors.  If allocating 8 vectors and writing 0b011 to MME causes
>> undefined results, I'd say that's a chipset defect.
>
> Well, the PCI spec does not prevent devices to have their own specs on top
> of it. Undefined results are meant on the device side here. On the MSI side
> these results are likely perfectly within the PCI spec. I feel speaking as
> a lawer here ;)

I disagree about this part.  The reason MSI is in the PCI spec is so
the OS can have generic support for it without having to put
device-specific support in every driver.  The PCI spec is clear that
the OS can allocate any number of vectors less than or equal to the
number requested via MMC.  The SATA device requests 16, and it should
be perfectly legal for the OS to give it 8.

It's interesting that the ICH10 spec (sec 14.1.27, thanks for the
reference) says MMC 100b means "8 MSI Capable".  That smells like a
hardware bug.  The PCI spec says:

  000 => 1 vector
  001 => 2 vectors
  010 => 4 vectors
  011 => 8 vectors
  100 => 16 vectors

The ICH10 spec seems to think 100 means 8 vectors (not 16 as the PCI
spec says), and that would fit with the rest of the ICH10 MME info.
If ICH10 was built assuming this table:

  000 => 1 vector
  001 => 2 vectors
  010 => 4 vectors
  100 => 8 vectors

then everything makes sense: the device requests 8 vectors, and the
behavior is defined in all possible MME cases (1, 2, 4, or 8 vectors
assigned).  The "Values '011b' to '111b' are reserved" part is still
slightly wrong, because the 100b value is in that range but is not
reserved, but that's a tangent.

So my guess (speculation, I admit) is that the intent was for ICH SATA
to request only 8 vectors, but because of this error, it requests 16.
Maybe some early MSI proposal used a different encoding for MMC and
MME, and ICH was originally designed using that.

>> Interrupt vector space is the issue I would worry about, but I think
>> I'm going to put this on the back burner until it actually becomes a
>> problem.
>
> I plan to try get rid of arch_msi_check_device() hook. Should I repost
> this series afterwards?

Honestly, I'm still not inclined to pursue this because of the API
complication and lack of concrete benefit.

Bjorn
