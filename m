Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbaE3Vqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:46:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52203 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaE3Vqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:46:53 -0400
Date: Fri, 30 May 2014 23:46:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Doug Thompson <dougthompson@xmission.com>,
        linux-pci@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI, EDAC: fix ordering assign resource and bus_add
Message-ID: <20140530214643.GL28131@pd.tnic>
References: <1367969371-27414-1-git-send-email-yinghai@kernel.org>
 <20140530170103.GE4607@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140530170103.GE4607@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:01:03AM -0600, Bjorn Helgaas wrote:
> On Tue, May 07, 2013 at 04:29:31PM -0700, Yinghai Lu wrote:
> > We should assign unassigned resource before pci_bus_add_device.
> > 
> > as late one will enable driver and create sysfs file that will need
> > pci io resources from assign unassigned code.
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Applied to pci/resource for v3.16, thanks!

This is touching drivers/edac/ and I guess I'm fine with it,

Acked-by: Borislav Petkov <bp@suse.de>

> > ---
> >  drivers/edac/i82875p_edac.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/drivers/edac/i82875p_edac.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/edac/i82875p_edac.c
> > +++ linux-2.6/drivers/edac/i82875p_edac.c
> > @@ -293,13 +293,14 @@ static int i82875p_setup_overfl_dev(stru
> >  		if (dev == NULL)
> >  			return 1;
> >  
> > +		pci_bus_assign_resources(dev->bus);
> > +
> >  		err = pci_bus_add_device(dev);
> >  		if (err) {
> >  			i82875p_printk(KERN_ERR,
> >  				"%s(): pci_bus_add_device() Failed\n",
> >  				__func__);
> >  		}
> > -		pci_bus_assign_resources(dev->bus);a


... one question though: how are people using those pci_bus*
functions supposed to know that pci_bus_assign_resources needs to
go before pci_bus_add_device? The comment in pci_bus_add_device()
mentions something about it but wouldn't it be possible to call
pci_bus_assign_resources() in pci_bus_add_device() when resources are
not assigned?

Sorry if my question is completely dumb - I have no presumption of
knowing pci and haven't looked either. Just asking with my user hat on.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
