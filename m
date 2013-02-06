Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3BFRNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:13:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46357 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3BFRNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:13:06 -0500
Date: Wed, 6 Feb 2013 12:12:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen-pciback: notify hypervisor about devices intended to
 be assigned to guests
Message-ID: <20130206171254.GE24458@konrad-lan.dumpdata.com>
References: <511299A902000078000BC944@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511299A902000078000BC944@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 04:58:01PM +0000, Jan Beulich wrote:
> For MSI-X capable devices the hypervisor wants to write protect the
> MSI-X table and PBA, yet it can't assume that resources have been
> assigned to their final values at device enumeration time. Thus have
> pciback do that notification, as having the device controlled by it is
> a prerequisite to assigning the device to guests anyway.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  arch/x86/include/asm/xen/hypercall.h |    4 +-
>  drivers/xen/fallback.c               |    3 +
>  drivers/xen/xen-pciback/pci_stub.c   |   59 ++++++++++++++++++++++++++---------
>  include/xen/interface/physdev.h      |    6 +++
>  4 files changed, 54 insertions(+), 18 deletions(-)
> 
> --- 3.8-rc6/arch/x86/include/asm/xen/hypercall.h
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/arch/x86/include/asm/xen/hypercall.h
> @@ -382,14 +382,14 @@ HYPERVISOR_console_io(int cmd, int count
>  	return _hypercall3(int, console_io, cmd, count, str);
>  }
>  
> -extern int __must_check HYPERVISOR_physdev_op_compat(int, void *);
> +extern int __must_check xen_physdev_op_compat(int, void *);
>  
>  static inline int
>  HYPERVISOR_physdev_op(int cmd, void *arg)
>  {
>  	int rc = _hypercall2(int, physdev_op, cmd, arg);
>  	if (unlikely(rc == -ENOSYS))
> -		rc = HYPERVISOR_physdev_op_compat(cmd, arg);
> +		rc = xen_physdev_op_compat(cmd, arg);
>  	return rc;
>  }
>  
> --- 3.8-rc6/drivers/xen/fallback.c
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/fallback.c
> @@ -44,7 +44,7 @@ int xen_event_channel_op_compat(int cmd,
>  }
>  EXPORT_SYMBOL_GPL(xen_event_channel_op_compat);
>  
> -int HYPERVISOR_physdev_op_compat(int cmd, void *arg)
> +int xen_physdev_op_compat(int cmd, void *arg)
>  {
>  	struct physdev_op op;
>  	int rc;
> @@ -78,3 +78,4 @@ int HYPERVISOR_physdev_op_compat(int cmd
>  
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(xen_physdev_op_compat);
> --- 3.8-rc6/drivers/xen/xen-pciback/pci_stub.c
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/xen-pciback/pci_stub.c
> @@ -17,6 +17,7 @@
>  #include <xen/events.h>
>  #include <asm/xen/pci.h>
>  #include <asm/xen/hypervisor.h>
> +#include <xen/interface/physdev.h>
>  #include "pciback.h"
>  #include "conf_space.h"
>  #include "conf_space_quirks.h"
> @@ -85,37 +86,52 @@ static struct pcistub_device *pcistub_de
>  static void pcistub_device_release(struct kref *kref)
>  {
>  	struct pcistub_device *psdev;
> +	struct pci_dev *dev;
>  	struct xen_pcibk_dev_data *dev_data;
>  
>  	psdev = container_of(kref, struct pcistub_device, kref);
> -	dev_data = pci_get_drvdata(psdev->dev);
> +	dev = psdev->dev;
> +	dev_data = pci_get_drvdata(dev);
>  
> -	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");
> +	dev_dbg(&dev->dev, "pcistub_device_release\n");
>  
> -	xen_unregister_device_domain_owner(psdev->dev);
> +	xen_unregister_device_domain_owner(dev);
>  
>  	/* Call the reset function which does not take lock as this
>  	 * is called from "unbind" which takes a device_lock mutex.
>  	 */
> -	__pci_reset_function_locked(psdev->dev);
> -	if (pci_load_and_free_saved_state(psdev->dev,
> -					  &dev_data->pci_saved_state)) {
> -		dev_dbg(&psdev->dev->dev, "Could not reload PCI state\n");
> -	} else
> -		pci_restore_state(psdev->dev);
> +	__pci_reset_function_locked(dev);
> +	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> +		dev_dbg(&dev->dev, "Could not reload PCI state\n");
> +	else
> +		pci_restore_state(dev);
> +
> +	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> +		struct physdev_pci_device ppdev = {
> +			.seg = pci_domain_nr(dev->bus),
> +			.bus = dev->bus->number,
> +			.devfn = dev->devfn
> +		};
> +		int err = HYPERVISOR_physdev_op(PHYSDEVOP_release_msix,
> +						&ppdev);
> +
> +		if (err)
> +			dev_warn(&dev->dev, "MSI-X release failed (%d)\n",
> +				 err);
> +	}
>  
>  	/* Disable the device */
> -	xen_pcibk_reset_device(psdev->dev);
> +	xen_pcibk_reset_device(dev);
>  
>  	kfree(dev_data);
> -	pci_set_drvdata(psdev->dev, NULL);
> +	pci_set_drvdata(dev, NULL);
>  
>  	/* Clean-up the device */
> -	xen_pcibk_config_free_dyn_fields(psdev->dev);
> -	xen_pcibk_config_free_dev(psdev->dev);
> +	xen_pcibk_config_free_dyn_fields(dev);
> +	xen_pcibk_config_free_dev(dev);
>  
> -	psdev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> -	pci_dev_put(psdev->dev);
> +	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +	pci_dev_put(dev);
>  
>  	kfree(psdev);
>  }
> @@ -355,6 +371,19 @@ static int pcistub_init_device(struct pc
>  	if (err)
>  		goto config_release;
>  
> +	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> +		struct physdev_pci_device ppdev = {
> +			.seg = pci_domain_nr(dev->bus),
> +			.bus = dev->bus->number,
> +			.devfn = dev->devfn
> +		};
> +
> +		err = HYPERVISOR_physdev_op(PHYSDEVOP_prepare_msix, &ppdev);
> +		if (err)
> +			dev_err(&dev->dev, "MSI-X preparation failed (%d)\n",
> +				err);
> +	}
> +
>  	/* We need the device active to save the state. */
>  	dev_dbg(&dev->dev, "save state of device\n");
>  	pci_save_state(dev);
> --- 3.8-rc6/include/xen/interface/physdev.h
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/include/xen/interface/physdev.h
> @@ -251,6 +251,12 @@ struct physdev_pci_device_add {
>  
>  #define PHYSDEVOP_pci_device_remove     26
>  #define PHYSDEVOP_restore_msi_ext       27
> +/*
> + * Dom0 should use these two to announce MMIO resources assigned to
> + * MSI-X capable devices won't (prepare) or may (release) change.
> + */
> +#define PHYSDEVOP_prepare_msix          30
> +#define PHYSDEVOP_release_msix          31
>  struct physdev_pci_device {
>      /* IN */
>      uint16_t seg;
> 
> 

> xen-pciback: notify hypervisor about devices intended to be assigned to guests
> 
> For MSI-X capable devices the hypervisor wants to write protect the
> MSI-X table and PBA, yet it can't assume that resources have been
> assigned to their final values at device enumeration time. Thus have
> pciback do that notification, as having the device controlled by it is
> a prerequisite to assigning the device to guests anyway.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  arch/x86/include/asm/xen/hypercall.h |    4 +-
>  drivers/xen/fallback.c               |    3 +
>  drivers/xen/xen-pciback/pci_stub.c   |   59 ++++++++++++++++++++++++++---------
>  include/xen/interface/physdev.h      |    6 +++
>  4 files changed, 54 insertions(+), 18 deletions(-)
> 
> --- 3.8-rc6/arch/x86/include/asm/xen/hypercall.h
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/arch/x86/include/asm/xen/hypercall.h
> @@ -382,14 +382,14 @@ HYPERVISOR_console_io(int cmd, int count
>  	return _hypercall3(int, console_io, cmd, count, str);
>  }
>  
> -extern int __must_check HYPERVISOR_physdev_op_compat(int, void *);
> +extern int __must_check xen_physdev_op_compat(int, void *);
>  
>  static inline int
>  HYPERVISOR_physdev_op(int cmd, void *arg)
>  {
>  	int rc = _hypercall2(int, physdev_op, cmd, arg);
>  	if (unlikely(rc == -ENOSYS))
> -		rc = HYPERVISOR_physdev_op_compat(cmd, arg);
> +		rc = xen_physdev_op_compat(cmd, arg);
>  	return rc;
>  }
>  
> --- 3.8-rc6/drivers/xen/fallback.c
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/fallback.c
> @@ -44,7 +44,7 @@ int xen_event_channel_op_compat(int cmd,
>  }
>  EXPORT_SYMBOL_GPL(xen_event_channel_op_compat);
>  
> -int HYPERVISOR_physdev_op_compat(int cmd, void *arg)
> +int xen_physdev_op_compat(int cmd, void *arg)
>  {
>  	struct physdev_op op;
>  	int rc;
> @@ -78,3 +78,4 @@ int HYPERVISOR_physdev_op_compat(int cmd
>  
>  	return rc;
>  }
> +EXPORT_SYMBOL_GPL(xen_physdev_op_compat);
> --- 3.8-rc6/drivers/xen/xen-pciback/pci_stub.c
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/drivers/xen/xen-pciback/pci_stub.c
> @@ -17,6 +17,7 @@
>  #include <xen/events.h>
>  #include <asm/xen/pci.h>
>  #include <asm/xen/hypervisor.h>
> +#include <xen/interface/physdev.h>
>  #include "pciback.h"
>  #include "conf_space.h"
>  #include "conf_space_quirks.h"
> @@ -85,37 +86,52 @@ static struct pcistub_device *pcistub_de
>  static void pcistub_device_release(struct kref *kref)
>  {
>  	struct pcistub_device *psdev;
> +	struct pci_dev *dev;
>  	struct xen_pcibk_dev_data *dev_data;
>  
>  	psdev = container_of(kref, struct pcistub_device, kref);
> -	dev_data = pci_get_drvdata(psdev->dev);
> +	dev = psdev->dev;
> +	dev_data = pci_get_drvdata(dev);
>  
> -	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");
> +	dev_dbg(&dev->dev, "pcistub_device_release\n");
>  
> -	xen_unregister_device_domain_owner(psdev->dev);
> +	xen_unregister_device_domain_owner(dev);
>  
>  	/* Call the reset function which does not take lock as this
>  	 * is called from "unbind" which takes a device_lock mutex.
>  	 */
> -	__pci_reset_function_locked(psdev->dev);
> -	if (pci_load_and_free_saved_state(psdev->dev,
> -					  &dev_data->pci_saved_state)) {
> -		dev_dbg(&psdev->dev->dev, "Could not reload PCI state\n");
> -	} else
> -		pci_restore_state(psdev->dev);
> +	__pci_reset_function_locked(dev);
> +	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
> +		dev_dbg(&dev->dev, "Could not reload PCI state\n");
> +	else
> +		pci_restore_state(dev);
> +
> +	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> +		struct physdev_pci_device ppdev = {
> +			.seg = pci_domain_nr(dev->bus),
> +			.bus = dev->bus->number,
> +			.devfn = dev->devfn
> +		};
> +		int err = HYPERVISOR_physdev_op(PHYSDEVOP_release_msix,
> +						&ppdev);
> +
> +		if (err)
> +			dev_warn(&dev->dev, "MSI-X release failed (%d)\n",
> +				 err);
> +	}

Perhaps it should be more off:

		if (err) {
			if (err == -ENOSYS)
				dev_info(&dev->dev,"MSI-X release
hypercall not supported.");
			else
				dev_warn(&dev->dev, "MSI-X release failed (%d)\n",
					 err);
				
>  
>  	/* Disable the device */
> -	xen_pcibk_reset_device(psdev->dev);
> +	xen_pcibk_reset_device(dev);
>  
>  	kfree(dev_data);
> -	pci_set_drvdata(psdev->dev, NULL);
> +	pci_set_drvdata(dev, NULL);
>  
>  	/* Clean-up the device */
> -	xen_pcibk_config_free_dyn_fields(psdev->dev);
> -	xen_pcibk_config_free_dev(psdev->dev);
> +	xen_pcibk_config_free_dyn_fields(dev);
> +	xen_pcibk_config_free_dev(dev);
>  
> -	psdev->dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> -	pci_dev_put(psdev->dev);
> +	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> +	pci_dev_put(dev);
>  
>  	kfree(psdev);
>  }
> @@ -355,6 +371,19 @@ static int pcistub_init_device(struct pc
>  	if (err)
>  		goto config_release;
>  
> +	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> +		struct physdev_pci_device ppdev = {
> +			.seg = pci_domain_nr(dev->bus),
> +			.bus = dev->bus->number,
> +			.devfn = dev->devfn
> +		};
> +
> +		err = HYPERVISOR_physdev_op(PHYSDEVOP_prepare_msix, &ppdev);
> +		if (err)
> +			dev_err(&dev->dev, "MSI-X preparation failed (%d)\n",
> +				err);
> +	}
> +
>  	/* We need the device active to save the state. */
>  	dev_dbg(&dev->dev, "save state of device\n");
>  	pci_save_state(dev);
> --- 3.8-rc6/include/xen/interface/physdev.h
> +++ 3.8-rc6-xen-pciback-MSI-X-prepare/include/xen/interface/physdev.h
> @@ -251,6 +251,12 @@ struct physdev_pci_device_add {
>  
>  #define PHYSDEVOP_pci_device_remove     26
>  #define PHYSDEVOP_restore_msi_ext       27
> +/*
> + * Dom0 should use these two to announce MMIO resources assigned to
> + * MSI-X capable devices won't (prepare) or may (release) change.
> + */
> +#define PHYSDEVOP_prepare_msix          30
> +#define PHYSDEVOP_release_msix          31
>  struct physdev_pci_device {
>      /* IN */
>      uint16_t seg;

