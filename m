Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3FFTwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:52:17 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47166 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab3FFTwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:52:15 -0400
Date: Thu, 6 Jun 2013 21:51:18 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130606195118.GA6508@breakpoint.cc>
References: <cover.1368431413.git.agordeev@redhat.com>
 <8575dc590b819892f366852fe50835efaf579f4f.1368431413.git.agordeev@redhat.com>
 <20130605205638.GA5816@breakpoint.cc>
 <20130606083019.GA28569@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606083019.GA28569@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:30:20AM +0200, Alexander Gordeev wrote:
> Sebastian,
Hi Alexander,

> I re-read my comment few times and I admit it might be confusing. You are
> right - 'multiple' is set by rounding up only. The part '...not necessarily
> the closest power-of-two value...' implied an abstract PCI device rather than
> the described code, but the wording is less than perfect, indeed. 

Good, so it is not just me :)

> In fact, at the moment of writing I kept in mind a follow-up patch that could
> help with aforementioned devices. That would be a new interface:
> 
> 	int pci_enable_msi_block_partial(struct pci_dev *dev,
> 					 unsigned int nvec_use,
> 					 unsigned int nvec_init);
> 
> In this case 'nvec_use' would go to 'msi_desc::nvec_used' and 'nvec_init'
> would translate to 'msi_desc::multiple' in case 'nvec_init' is not zero.
> In case 'nvec_init' is zero, 'msi_desc::multiple' would be initialized
> with the maximum possible value for the device (the way it is done now for
> pci_enable_msi_block_auto() interface). So, for the AHCI device (Bjorn
> mentioned) such a call would conserve on 10 of 16 vectors:
> 
> 	pci_enable_msi_block_partial(pdev, 6, 0);

Ah okay. that makes sense.

> 
> What I am not sure is whether we need to read out the maximum possible
> number of vectors like pci_enable_msi_block_auto() does:
> 
> 	int pci_enable_msi_block_partial(struct pci_dev *dev,
> 					 unsigned int nvec_use,
> 					 unsigned int nvec_init,
> 					 unsigned int *maxvec);
> 
> I can not think of any use of 'maxvec' with this interface, but the second
> variant completes the whole picture about a device...
The user of pci_enable_msi_block_auto() does not know how many it will get
so argument seems essential. Your new function on the other hand says exactly
how many it requires. Anything less should be an error.

Sebastian
