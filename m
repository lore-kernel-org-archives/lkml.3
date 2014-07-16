Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbaGPNic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:38:32 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:59409 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996AbaGPNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:38:29 -0400
Subject: Re: [PATCH] misc/GenWQE: fix pci_enable_msi usage
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.11.1407091340420.1590@denkbrett>
References: <alpine.LFD.2.11.1407091237030.1590@denkbrett>
	 <20140709113452.GA30650@dhcp-26-207.brq.redhat.com>
	 <alpine.LFD.2.11.1407091340420.1590@denkbrett>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 16 Jul 2014 15:38:24 +0200
Message-ID: <1405517904.23857.7.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071613-3548-0000-0000-00000096C2E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

Am Mittwoch, den 09.07.2014, 13:44 +0200 schrieb Sebastian Ott:
> On Wed, 9 Jul 2014, Alexander Gordeev wrote:
> 
> > On Wed, Jul 09, 2014 at 12:46:39PM +0200, Sebastian Ott wrote:
> > > GenWQE used to call pci_enable_msi_block to allocate a desired number
> > > of MSI's. If that was not possible pci_enable_msi_block returned with a
> > > smaller number which might be possible to allocate. GenWQE then called
> > > pci_enable_msi_block with that number.
> > > 
> > > Since commit a30d0108b
> > > "GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()"
> > > pci_enable_msi_exact is used which fails if the desired number of MSI's
> > > was not possible to allocate. Change GenWQE to use pci_enable_msi_range
> > > to restore the old behavior.
> > > 
> > > Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
> > > ---
> > >  drivers/misc/genwqe/card_ddcb.c  |  4 +---
> > >  drivers/misc/genwqe/card_utils.c | 10 ++++++----
> > >  2 files changed, 7 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
> > > index c8046db..f66d43d 100644
> > > --- a/drivers/misc/genwqe/card_ddcb.c
> > > +++ b/drivers/misc/genwqe/card_ddcb.c
> > > @@ -1237,9 +1237,7 @@ int genwqe_setup_service_layer(struct genwqe_dev *cd)
> > >  	}
> > >  
> > >  	rc = genwqe_set_interrupt_capability(cd, GENWQE_MSI_IRQS);
> > > -	if (rc > 0)
> > > -		rc = genwqe_set_interrupt_capability(cd, rc);
> > > -	if (rc != 0) {
> > > +	if (rc) {
> > >  		rc = -ENODEV;
> > >  		goto stop_kthread;
> > >  	}
> > > diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
> > > index 62cc6bb..6abc437 100644
> > > --- a/drivers/misc/genwqe/card_utils.c
> > > +++ b/drivers/misc/genwqe/card_utils.c
> > > @@ -718,10 +718,12 @@ int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
> > >  	int rc;
> > >  	struct pci_dev *pci_dev = cd->pci_dev;
> > >  
> > > -	rc = pci_enable_msi_exact(pci_dev, count);
> > > -	if (rc == 0)
> > > -		cd->flags |= GENWQE_FLAG_MSI_ENABLED;
> > > -	return rc;
> > > +	rc = pci_enable_msi_range(pci_dev, 1, count);
> > > +	if (rc < 0)
> > > +		return rc;
> > > +
> > > +	cd->flags |= GENWQE_FLAG_MSI_ENABLED;
> > > +	return 0;
> > >  }
> > >  
> > >  /**
> > > -- 
> > > 1.9.3
> > > 
> > 
> > Reviewed-by: Alexander Gordeev <agordeev@redhat.com>
> > 

thanks for the fix and Alexander for reviewing it.

> > I am curious though why would you need convert error code to -ENODEV here
> > (and throughout the code in general)?
> 
> Yes, I thought about that too but decided to just fix the bug and not
> change this (since it's more or less unrelated).
> 
> Regards,
> Sebastian

You are probably right, converting the return code into -ENODEV is not
really needed.

Reviewed-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

