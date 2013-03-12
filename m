Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3CLUGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:06:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33185 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3CLUGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:06:43 -0400
Date: Tue, 12 Mar 2013 16:06:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen-pciback: notify hypervisor about devices
 intended to be assigned to guests
Message-ID: <20130312200634.GA23081@phenom.dumpdata.com>
References: <513F527F02000078000C4EE7@nat28.tlf.novell.com>
 <513F6CF602000078000C509D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513F6CF602000078000C509D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 04:59:18PM +0000, Jan Beulich wrote:
> >>> On 12.03.13 at 16:06, "Jan Beulich" <JBeulich@suse.com> wrote:
> > For MSI-X capable devices the hypervisor wants to write protect the
> > MSI-X table and PBA, yet it can't assume that resources have been
> > assigned to their final values at device enumeration time. Thus have
> > pciback do that notification, as having the device controlled by it is
> > a prerequisite to assigning the device to guests anyway.
> > 
> > This is the kernel part of hypervisor side commit 4245d33 ("x86/MSI:
> > add mechanism to fully protect MSI-X table from PV guest accesses") on
> > the master branch of git://xenbits.xen.org/xen.git.
> > 
> > Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> Just noticed that once again I forgot to Cc stable@ - could you
> please add this as you commit it to your tree?
> 

Naturally.
> I'm sorry about this, Jan

That is OK. I keep on doing it myself as well.

> 
> > ---
> >  arch/x86/include/asm/xen/hypercall.h |    4 +-
> >  drivers/xen/fallback.c               |    3 +
> >  drivers/xen/xen-pciback/pci_stub.c   |   59 ++++++++++++++++++++++++++---------
> >  include/xen/interface/physdev.h      |    6 +++
> >  4 files changed, 54 insertions(+), 18 deletions(-)
> > 
> > --- 3.9-rc2/arch/x86/include/asm/xen/hypercall.h
> > +++ 3.9-rc2-xen-pciback-MSI-X-prepare/arch/x86/include/asm/xen/hypercall.h
> > @@ -382,14 +382,14 @@ HYPERVISOR_console_io(int cmd, int count
> >  	return _hypercall3(int, console_io, cmd, count, str);
> >  }
> >  
> > -extern int __must_check HYPERVISOR_physdev_op_compat(int, void *);
> > +extern int __must_check xen_physdev_op_compat(int, void *);
> >  
> >  static inline int
> >  HYPERVISOR_physdev_op(int cmd, void *arg)
> >  {
> >  	int rc = _hypercall2(int, physdev_op, cmd, arg);
> >  	if (unlikely(rc == -ENOSYS))
> > -		rc = HYPERVISOR_physdev_op_compat(cmd, arg);
> > +		rc = xen_physdev_op_compat(cmd, arg);
> >  	return rc;
> >  }
> >  
> > --- 3.9-rc2/drivers/xen/fallback.c
> > +++ 3.9-rc2-xen-pciback-MSI-X-prepare/drivers/xen/fallback.c
> > @@ -44,7 +44,7 @@ int xen_event_channel_op_compat(int cmd,
> >  }
> >  EXPORT_SYMBOL_GPL(xen_event_channel_op_compat);
> >  
> > -int HYPERVISOR_physdev_op_compat(int cmd, void *arg)
> > +int xen_physdev_op_compat(int cmd, void *arg)
> >  {
> >  	struct physdev_op op;
> >  	int rc;
> > @@ -78,3 +78,4 @@ int HYPERVISOR_physdev_op_compat(int cmd
> >  
> >  	return rc;
> >  }
> > +EXPORT_SYMBOL_GPL(xen_physdev_op_compat);
> > --- 3.9-rc2/drivers/xen/xen-pciback/pci_stub.c
> > +++ 3.9-rc2-xen-pciback-MSI-X-prepare/drivers/xen/xen-pciback/pci_stub.c
> > @@ -17,6 +17,7 @@
> >  #include <xen/events.h>
> >  #include <asm/xen/pci.h>
> >  #include <asm/xen/hypervisor.h>
> > +#include <xen/interface/physdev.h>
> >  #include "pciback.h"
> >  #include "conf_space.h"
> >  #include "conf_space_quirks.h"
> > @@ -85,37 +86,52 @@ static struct pcistub_device *pcistub_de
> >  static void pcistub_device_release(struct kref *kref)
> >  {
> >  	struct pcistub_device *psdev;
> > +	struct pci_dev *dev;
> >  	struct xen_pcibk_dev_data *dev_data;
> >  
> >  	psdev = container_of(kref, struct pcistub_device, kref);
> > -	dev_data = pci_get_drvdata(psdev->dev);
> > +	dev = psdev->dev;
> > +	dev_data = pci_get_drvdata(dev);
> >  
> > -	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");
> > +	dev_dbg(&dev->dev, "pcistub_device_release\n");
> >  
> > -	xen_unregister_device_domain_owner(psdev->dev);
> > +	xen_unregister_device_domain_owner(dev);
> >  
> >  	/* Call the reset function which does not take lock as this
> >  	 * is called from "unbind" which takes a device_lock mutex.
> >  	 */
> > -	__pci_reset_function_locked(psdev->dev);
> > -	if (pci_load_and_free_saved_state(psdev->dev,
> > -					  &dev_data->pci_saved_state)) {
> > -		dev_dbg(&psdev->dev->dev, "Could not reload PCI state\n");
> > -	} else
> > -		pci_restore_state(psdev->dev);
> > +	__pci_reset_function_locked(dev);
> > +	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> > +		dev_dbg(&dev->dev, "Could not reload PCI state\n");
> > +	else
> > +		pci_restore_state(dev);
> > +
> > +	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> > +		struct physdev_pci_device ppdev = {
> > +			.seg = pci_domain_nr(dev->bus),
> > +			.bus = dev->bus->number,
> > +			.devfn = dev->devfn
> > +		};
> > +		int err = HYPERVISOR_physdev_op(PHYSDEVOP_release_msix,
> > +						&ppdev);
> > +
> > +		if (err)
> > +			dev_warn(&dev->dev, "MSI-X release failed (%d)\n",
> > +				 err);
> > +	}
> >  
> >  	/* Disable the device */
> > -	xen_pcibk_reset_device(psdev->dev);
> > +	xen_pcibk_reset_device(dev);
> >  
> >  	kfree(dev_data);
> > -	pci_set_drvdata(psdev->dev, NULL);
> > +	pci_set_drvdata(dev, NULL);
> >  
> >  	/* Clean-up the device */
> > -	xen_pcibk_config_free_dyn_fields(psdev->dev);
> > -	xen_pcibk_config_free_dev(psdev->dev);
> > +	xen_pcibk_config_free_dyn_fields(dev);
> > +	xen_pcibk_config_free_dev(dev);
> >  
> > -	psdev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> > -	pci_dev_put(psdev->dev);
> > +	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> > +	pci_dev_put(dev);
> >  
> >  	kfree(psdev);
> >  }
> > @@ -355,6 +371,19 @@ static int pcistub_init_device(struct pc
> >  	if (err)
> >  		goto config_release;
> >  
> > +	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> > +		struct physdev_pci_device ppdev = {
> > +			.seg = pci_domain_nr(dev->bus),
> > +			.bus = dev->bus->number,
> > +			.devfn = dev->devfn
> > +		};
> > +
> > +		err = HYPERVISOR_physdev_op(PHYSDEVOP_prepare_msix, &ppdev);
> > +		if (err)
> > +			dev_err(&dev->dev, "MSI-X preparation failed (%d)\n",
> > +				err);
> > +	}
> > +
> >  	/* We need the device active to save the state. */
> >  	dev_dbg(&dev->dev, "save state of device\n");
> >  	pci_save_state(dev);
> > --- 3.9-rc2/include/xen/interface/physdev.h
> > +++ 3.9-rc2-xen-pciback-MSI-X-prepare/include/xen/interface/physdev.h
> > @@ -251,6 +251,12 @@ struct physdev_pci_device_add {
> >  
> >  #define PHYSDEVOP_pci_device_remove     26
> >  #define PHYSDEVOP_restore_msi_ext       27
> > +/*
> > + * Dom0 should use these two to announce MMIO resources assigned to
> > + * MSI-X capable devices won't (prepare) or may (release) change.
> > + */
> > +#define PHYSDEVOP_prepare_msix          30
> > +#define PHYSDEVOP_release_msix          31
> >  struct physdev_pci_device {
> >      /* IN */
> >      uint16_t seg;
> 
> 
