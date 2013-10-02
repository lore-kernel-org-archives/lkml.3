Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3JBHIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 03:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3JBHIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:08:07 -0400
Date: Wed, 2 Oct 2013 09:10:00 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20131002071000.GA29860@dhcp-26-207.brq.redhat.com>
References: <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20131001075133.GJ17966@concordia>
 <20131001103526.GA5053@dhcp-26-207.brq.redhat.com>
 <20131002024324.GC22748@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002024324.GC22748@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:43:24PM +1000, Michael Ellerman wrote:
> On Tue, Oct 01, 2013 at 12:35:27PM +0200, Alexander Gordeev wrote:
> > On Tue, Oct 01, 2013 at 05:51:33PM +1000, Michael Ellerman wrote:
> > > The disadvantage is that any restriction imposed on us above the quota
> > > can only be reported as an error from pci_enable_msix().
> > > 
> > > The quota code, called from pci_get_msix_limit(), can only do so much to
> > > interogate firmware about the limitations. The ultimate way to check if
> > > firmware will give us enough MSIs is to try and allocate them. But we
> > > can't do that from pci_get_msix_limit() because the driver is not asking
> > > us to enable MSIs, just query them.
> > 
> > If things are this way then pci_enable_msix() already exposed to this
> > problem internally on pSeries.
> > 
> > I see that even successful quota checks in rtas_msi_check_device() and
> > rtas_setup_msi_irqs() do not guarantee (as you say) that firmware will
> > give enough MSIs. Hence, pci_enable_msix() might fail even though the
> > its quota checks succeeded.
> 
> Yes, but it can report that failure to the caller, which can then retry.

If a driver wants to retry after a failure it is up to the driver (but why?).
The current guidlines state:

"If this function returns a negative number, it indicates an error and
the driver should not attempt to allocate any more MSI-X interrupts for
this device."

Anyway, what number could the driver retry with after it got a negative errno?

> > Therefore, nothing will really change if we make pci_get_msix_limit() check
> > quota and hope the follow-up call to pci_enable_msix() succeeded.
> 
> No that's not equivalent. Under your scheme if pci_enable_msix() fails
> then the caller just bails, it will never try again with a lower number.

Currently under the very same circumstances (the quota check within
rtas_setup_msi_irqs() returned Q vectors while the firmware has only F
vectors to allocate and Q > F) rtas_setup_msi_irqs() fails, pci_enable_msix()
fails, the caller bails and never try again with a lower number.

Am I missing something here?

> cheers

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
