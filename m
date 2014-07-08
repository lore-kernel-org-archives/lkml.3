Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaGHMZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbaGHMZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:25:30 -0400
Date: Tue, 8 Jul 2014 14:26:07 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        xen-devel@lists.xenproject.org,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/3] PCI/MSI: Add pci_enable_msi_partial()
Message-ID: <20140708122606.GB6270@dhcp-26-207.brq.redhat.com>
References: <cover.1402405331.git.agordeev@redhat.com>
 <4fef62a2e647a7c38e9f2a1ea4244b3506a85e2b.1402405331.git.agordeev@redhat.com>
 <20140702202201.GA28852@google.com>
 <20140704085741.GA12247@dhcp-26-207.brq.redhat.com>
 <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6f6RXWv0DEtLBZX0jXoSUYJeWrSm7mubSJ_F-O7tQp6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 01:40:48PM -0600, Bjorn Helgaas wrote:
> >> Can you quantify the benefit of this?  Can't a device already use
> >> MSI-X to request exactly the number of vectors it can use?  (I know
> >
> > A Intel AHCI chipset requires 16 vectors written to MME while advertises
> > (via AHCI registers) and uses only 6. Even attempt to init 8 vectors results
> > in device's fallback to 1 (!).
> 
> Is the fact that it uses only 6 vectors documented in the public spec?

Yes, it is documented in ICH specs.

> Is this a chipset erratum?  Are there newer versions of the chipset
> that fix this, e.g., by requesting 8 vectors and using 6, or by also
> supporting MSI-X?

No, this is not an erratum. The value of 8 vectors is reserved and could
cause undefined results if used.

> I know this conserves vector numbers.  What does that mean in real
> user-visible terms?  Are there systems that won't boot because of this
> issue, and this patch fixes them?  Does it enable bigger
> configurations, e.g., more I/O devices, than before?

Visibly, it ceases logging messages ('ahci 0000:00:1f.2: irq 107 for
MSI/MSI-X') for IRQs that are not shown in /proc/interrupts later.

No, it does not enable/fix any existing hardware issue I am aware of.
It just saves a couple of interrupt vectors, as Michael put it (10/16
to be precise). However, interrupt vectors space is pretty much scarce
resource on x86 and a risk of exhausting the vectors (and introducing
quota i.e) has already been raised AFAIR.

> Do you know how Windows handles this?  Does it have a similar interface?

Have no clue, TBH. Can try to investigate if you see it helpful.

> As you can tell, I'm a little skeptical about this.  It's a fairly big
> change, it affects the arch interface, it seems to be targeted for
> only a single chipset (though it's widely used), and we already
> support a standard solution (MSI-X, reducing the number of vectors
> requested, or even operating with 1 vector).

I also do not like the fact the arch interface is getting complicated,
so I happily leave it to your judgement ;) Well, it is low-level and
hidden from drivers at least.

Thanks!

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
