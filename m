Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab3FFIbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab3FFIbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:31:43 -0400
Date: Thu, 6 Jun 2013 10:30:20 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130606083019.GA28569@dhcp-26-207.brq.redhat.com>
References: <cover.1368431413.git.agordeev@redhat.com>
 <8575dc590b819892f366852fe50835efaf579f4f.1368431413.git.agordeev@redhat.com>
 <20130605205638.GA5816@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605205638.GA5816@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:56:38PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, May 13, 2013 at 11:05:48AM +0200, Alexander Gordeev wrote:
> > Note, although the existing 'msi_desc::multiple' field might seem
> > redundant, in fact in does not. In general case the number of MSIs a
> > PCI device is initialized with is not necessarily the closest power-
> > of-two value of the number of MSIs the device will send. Thus, in
> > theory it would not be always possible to derive the former from the
> > latter and we need to keep them both, to stress this corner case.
> > Besides, since 'msi_desc::multiple' is a bitfield, throwing it out
> > would not save us any space.
> 
> The last paragraph makes me curious. The only place where 'multiple' is set is
> in do_setup_msi_irqs() and this uses the next power of two for it. And since a
> device is not enabled twice, it is not overridden.
> So it should be possible to compute 'multiple' out of 'nvec' but it saves
> cycles not do to so. I agree to keep 'multiple' but your argument does not
> seem to make sense.
> While nitpicking, 'nvec' might deserve a better comment than 'number of
> messages' since it holds the number of allocated interrupts. :)

Sebastian,

I re-read my comment few times and I admit it might be confusing. You are
right - 'multiple' is set by rounding up only. The part '...not necessarily
the closest power-of-two value...' implied an abstract PCI device rather than
the described code, but the wording is less than perfect, indeed. 

In fact, at the moment of writing I kept in mind a follow-up patch that could
help with aforementioned devices. That would be a new interface:

	int pci_enable_msi_block_partial(struct pci_dev *dev,
					 unsigned int nvec_use,
					 unsigned int nvec_init);

In this case 'nvec_use' would go to 'msi_desc::nvec_used' and 'nvec_init'
would translate to 'msi_desc::multiple' in case 'nvec_init' is not zero.
In case 'nvec_init' is zero, 'msi_desc::multiple' would be initialized
with the maximum possible value for the device (the way it is done now for
pci_enable_msi_block_auto() interface). So, for the AHCI device (Bjorn
mentioned) such a call would conserve on 10 of 16 vectors:

	pci_enable_msi_block_partial(pdev, 6, 0);

What I am not sure is whether we need to read out the maximum possible
number of vectors like pci_enable_msi_block_auto() does:

	int pci_enable_msi_block_partial(struct pci_dev *dev,
					 unsigned int nvec_use,
					 unsigned int nvec_init,
					 unsigned int *maxvec);

I can not think of any use of 'maxvec' with this interface, but the second
variant completes the whole picture about a device...

> Sebastian

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
