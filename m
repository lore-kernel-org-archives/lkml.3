Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaDVTPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:15:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbaDVTPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:15:13 -0400
Date: Tue, 22 Apr 2014 09:32:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.13 08/32] PCI: Enable INTx in pci_reenable_device()
 only when MSI/MSI-X not enabled
Message-ID: <20140422163223.GA29085@kroah.com>
References: <20140421021133.865086647@linuxfoundation.org>
 <20140421021135.009538358@linuxfoundation.org>
 <1398090269.3624.116.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398090269.3624.116.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 03:24:29PM +0100, Ben Hutchings wrote:
> On Sun, 2014-04-20 at 19:13 -0700, Greg Kroah-Hartman wrote:
> > 3.13-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Bjorn Helgaas <bhelgaas@google.com>
> > 
> > commit 866d54177b4e671cd52bed1fb487d140d7b691f5 upstream.
> > 
> > Andreas reported that after 1f42db786b14 ("PCI: Enable INTx if BIOS left
> > them disabled"), pciehp surprise removal stopped working.
> > 
> > This happens because pci_reenable_device() on the hotplug bridge (used in
> > the pciehp_configure_device() path) clears the Interrupt Disable bit, which
> > apparently breaks the bridge's MSI hotplug event reporting.
> > 
> > Previously we cleared the Interrupt Disable bit in do_pci_enable_device(),
> > which is used by both pci_enable_device() and pci_reenable_device().  But
> > we use pci_reenable_device() after the driver may have enabled MSI or
> > MSI-X, and we *set* Interrupt Disable as part of enabling MSI/MSI-X.
> > 
> > This patch clears Interrupt Disable only when MSI/MSI-X has not been
> > enabled.
> > 
> > Fixes: 1f42db786b14 PCI: Enable INTx if BIOS left them disabled
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=71691
> > Reported-and-tested-by: Andreas Noever <andreas.noever@gmail.com>
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/pci/pci.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -1134,6 +1134,9 @@ static int do_pci_enable_device(struct p
> >  	if (dev->msi_enabled || dev->msix_enabled)
> >  		return 0;
> >  
> > +	if (dev->msi_enabled || dev->msix_enabled)
> > +		return 0;
> > +
> 
> This fix seems to have been applied to two upstream branches and you
> have already applied one instance.

Good catch, I've now removed it, thanks.

greg k-h
