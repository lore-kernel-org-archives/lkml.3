Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaKXVpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:45:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaKXVpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:45:38 -0500
Message-ID: <1416865524.11825.89.camel@bling.home>
Subject: Re: [PATCH 1/3] PCI/MSI: Initial hook for archs to declare
 multivector MSI support
From: Alex Williamson <alex.williamson@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, iommu@lists.linux-foundation.org
Date: Mon, 24 Nov 2014 14:45:24 -0700
In-Reply-To: <alpine.DEB.2.11.1411232109140.6439@nanos>
References: <20141121213752.31095.30735.stgit@gimli.home>
	 <20141121220833.31095.12371.stgit@gimli.home>
	 <alpine.DEB.2.11.1411232109140.6439@nanos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-23 at 21:20 +0100, Thomas Gleixner wrote:
> On Fri, 21 Nov 2014, Alex Williamson wrote:
> > For the most part multivector MSI is not supported and drivers and
> > hardware wanting multiple vectors opt for MSI-X instead.  It seems
> > though that having the ability to query the arch/platform code to
> > determine whether allocating multiple MSI vectors will ever succeed
> > is a useful thing.  For instance, vfio-pci can use this to determine
> > whether to expose multiple MSI vectors to the user.  If we know we
> > cannot ever support more than one vector, we have a better shot at
> > the userspace driver working, especially if it's a guest OS, if we
> > only expose one vector as being available in the interface.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  drivers/pci/msi.c   |    5 +++++
> >  include/linux/msi.h |    1 +
> >  2 files changed, 6 insertions(+)
> > 
> > diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> > index 9fab30a..36b503a 100644
> > --- a/drivers/pci/msi.c
> > +++ b/drivers/pci/msi.c
> > @@ -79,6 +79,11 @@ int __weak arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> >  	return 0;
> >  }
> >  
> > +bool __weak arch_supports_multivector_msi(struct pci_dev *dev)
> 
> Please not another weak arch function. We are in the process to reduce
> them not to extend them.
> 
> arch_supports is pretty much wrong here anyway. We are moving away
> from arch MSI dependencies simply because it's not a arch property per
> se.
> 
> Multi MSI is a property of the underlying interrupt controllers and
> there might be several MSI interrupt domains on a given system. They
> can or cannot support multi MSI.
> 
> The current x86 implementation is a tangled maze and Jiang is in the
> process to distangle it completely. Until thats done x86 is not going
> to add new ad hoc interfaces.
> 
> Once we converted everything over to the new hierarchical irqdomains
> we can add such an interface to the code, but for now I'm not
> accepting anything like that into x86 msi related code.

Ok, I guess I can do some ugliness with associating the IOMMU IRQ
remapping capability with multivector MSI support within an #ifdef x86
block.  Gross, but I think that's as accurate as I can get w/o a hook
through the MSI code.  Is there any target for the refactoring you
mention?  Thanks,

Alex


