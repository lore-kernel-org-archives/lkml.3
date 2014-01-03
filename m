Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaACWj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:39:59 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36851 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaACWj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:39:56 -0500
Date: Fri, 3 Jan 2014 15:39:53 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 30/33] PCI, x86, ACPI: Enable ioapic hotplug support
 with acpi host bridge.
Message-ID: <20140103223953.GB18987@google.com>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
 <1388707565-16535-31-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388707565-16535-31-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 04:06:02PM -0800, Yinghai Lu wrote:
> We need to have ioapic setup before normal pci drivers.
> otherwise other pci driver can not setup irq.
> 
> So we should not treat them as normal pci devices.
> Also we will need to support ioapic hotplug without pci device around.
> 
> We need to call ioapic add/remove during host-bridge add/remove.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/acpi/pci_root.c  |   4 ++
>  drivers/pci/ioapic.c     | 147 ++++++++++++++++++++++++++++++-----------------
>  include/linux/pci-acpi.h |   8 +++
>  3 files changed, 106 insertions(+), 53 deletions(-)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 20360e4..e666be3 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -599,6 +599,8 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  		pci_assign_unassigned_root_bus_resources(root->bus);
>  	}
>  
> +	acpi_pci_ioapic_add(root);
> +
>  	pci_bus_add_devices(root->bus);
>  	return 1;
>  
> @@ -613,6 +615,8 @@ static void acpi_pci_root_remove(struct acpi_device *device)
>  
>  	pci_stop_root_bus(root->bus);
>  
> +	acpi_pci_ioapic_remove(root);
> +
>  	device_set_run_wake(root->bus->bridge, false);
>  	pci_acpi_remove_bus_pm_notifier(device);
>  
> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> index 2c2930e..60351b2 100644
> --- a/drivers/pci/ioapic.c
> +++ b/drivers/pci/ioapic.c

The file comment:

 * This driver manages PCI I/O APICs added by hotplug after boot.  We try to
 * claim all I/O APIC PCI devices, but those present at boot were registered
 * when we parsed the ACPI MADT, so we'll fail when we try to re-register
 * them.

is now incorrect because this no longer claims all PCI I/O APICs.  As far
as I can tell, it now claims every ACPI Device below the host bridge that
has a _GSB method and an associated PCI device.  If there is a PCI I/O APIC
that does not appear in the namespace, this driver will not claim it.

I don't have a problem with that, but the comment needs to be updated to
reflect the change.

> @@ -22,101 +22,142 @@
>  #include <linux/slab.h>
>  #include <acpi/acpi_bus.h>
>  
> -struct ioapic {
> -	acpi_handle	handle;
> +struct acpi_pci_ioapic {
> +	acpi_handle	root_handle;
>  	u32		gsi_base;
> +	struct pci_dev *pdev;
> +	struct list_head list;
>  };
>  
> -static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
> +static LIST_HEAD(ioapic_list);
> +static DEFINE_MUTEX(ioapic_list_lock);
> +
> +static void handle_ioapic_add(acpi_handle handle, struct pci_dev **pdev,
> +				 u32 *pgsi_base)
>  {
> -	acpi_handle handle;
>  	acpi_status status;
>  	unsigned long long gsb;
> -	struct ioapic *ioapic;
> +	struct pci_dev *dev;
> +	u32 gsi_base;
>  	int ret;
>  	char *type;
> -	struct resource *res;
> +	struct resource r;
> +	struct resource *res = &r;
> +	char objname[64];
> +	struct acpi_buffer buffer = {sizeof(objname), objname};

You can avoid the hard-coded 64-byte buffer with:

    struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};

And of course the corresponding kfree in the exit path.  The
acpi_get_name() could be done after all possible error exits, so you'd only
need the kfree in the success path.

> -	handle = ACPI_HANDLE(&dev->dev);
> -	if (!handle)
> -		return -EINVAL;
> +	*pdev = NULL;
> +	*pgsi_base = 0;
>  
>  	status = acpi_evaluate_integer(handle, "_GSB", NULL, &gsb);
> -	if (ACPI_FAILURE(status))
> -		return -EINVAL;
> -
> -	/*
> -	 * The previous code in acpiphp evaluated _MAT if _GSB failed, but
> -	 * ACPI spec 4.0 sec 6.2.2 requires _GSB for hot-pluggable I/O APICs.
> -	 */
> +	if (ACPI_FAILURE(status) || !gsb)
> +		return;
>  
> -	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
> -	if (!ioapic)
> -		return -ENOMEM;
> +	dev = acpi_get_pci_dev(handle);
> +	if (!dev)
> +		return;
>  
> -	ioapic->handle = handle;
> -	ioapic->gsi_base = (u32) gsb;
> +	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>  
> -	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
> -		type = "IOAPIC";
> -	else
> -		type = "IOxAPIC";
> +	gsi_base = gsb;
> +	type = "IOxAPIC";
>  
>  	ret = pci_enable_device(dev);
>  	if (ret < 0)
> -		goto exit_free;
> +		goto exit_put;
>  
>  	pci_set_master(dev);
>  
> +	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
> +		type = "IOAPIC";

Why not keep the 'type = "IOxAPIC"' assignment here as it was before?  Then
all the "type" manipulation is in one place.

>  	if (pci_request_region(dev, 0, type))
>  		goto exit_disable;
>  
>  	res = &dev->resource[0];
> -	if (acpi_register_ioapic(ioapic->handle, res->start, ioapic->gsi_base))
> +
> +	if (acpi_register_ioapic(handle, res->start, gsi_base))
>  		goto exit_release;
>  
> -	pci_set_drvdata(dev, ioapic);
> -	dev_info(&dev->dev, "%s at %pR, GSI %u\n", type, res, ioapic->gsi_base);
> -	return 0;
> +	pr_info("%s %s %s at %pR, GSI %u\n",
> +		dev_name(&dev->dev), objname, type,
> +		res, gsi_base);

Why did you change the dev_info() to pr_info()?  They look equivalent for
what you're doing here.

> +	*pdev = dev;
> +	*pgsi_base = gsi_base;
> +	return;
>  
>  exit_release:
>  	pci_release_region(dev, 0);
>  exit_disable:
>  	pci_disable_device(dev);
> -exit_free:
> -	kfree(ioapic);
> -	return -ENODEV;
> +exit_put:
> +	pci_dev_put(dev);
>  }
>  
> -static void ioapic_remove(struct pci_dev *dev)
> +static void handle_ioapic_remove(acpi_handle handle, struct pci_dev *dev,
> +				  u32 gsi_base)
>  {
> -	struct ioapic *ioapic = pci_get_drvdata(dev);
> +	acpi_unregister_ioapic(handle, gsi_base);
>  
> -	acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
>  	pci_release_region(dev, 0);
>  	pci_disable_device(dev);
> -	kfree(ioapic);
> +	pci_dev_put(dev);
>  }
>  
> +static acpi_status register_ioapic(acpi_handle handle, u32 lvl,
> +					void *context, void **rv)
> +{
> +	acpi_handle root_handle = context;
> +	struct pci_dev *pdev;
> +	u32 gsi_base;
> +	struct acpi_pci_ioapic *ioapic;
>  
> -static DEFINE_PCI_DEVICE_TABLE(ioapic_devices) = {
> -	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
> -	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(pci, ioapic_devices);
> +	handle_ioapic_add(handle, &pdev, &gsi_base);
> +	if (!gsi_base)
> +		return AE_OK;
>  
> -static struct pci_driver ioapic_driver = {
> -	.name		= "ioapic",
> -	.id_table	= ioapic_devices,
> -	.probe		= ioapic_probe,
> -	.remove		= ioapic_remove,
> -};
> +	ioapic = kzalloc(sizeof(*ioapic), GFP_KERNEL);
> +	if (!ioapic) {
> +		pr_err("%s: cannot allocate memory\n", __func__);

I don't know if this message is necessary, but if it is, please include
device identification, e.g., with dev_info() on the struct pci_dev.

> +		handle_ioapic_remove(root_handle, pdev, gsi_base);
> +		return AE_OK;
> +	}
> +	ioapic->root_handle = root_handle;
> +	ioapic->pdev = pdev;
> +	ioapic->gsi_base = gsi_base;
> +
> +	mutex_lock(&ioapic_list_lock);
> +	list_add(&ioapic->list, &ioapic_list);
> +	mutex_unlock(&ioapic_list_lock);
> +
> +	return AE_OK;
> +}
>  
> -static int __init ioapic_init(void)
> +void acpi_pci_ioapic_add(struct acpi_pci_root *root)
>  {
> -	return pci_register_driver(&ioapic_driver);
> +	acpi_status status;
> +
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, root->device->handle,
> +				     (u32)1, register_ioapic, NULL,
> +				     root->device->handle,
> +				     NULL);
> +	if (ACPI_FAILURE(status))
> +		pr_err("%s: register_ioapic failure - %d", __func__, status);

This message should include the part of the namespace where we had the
problem, e.g., the pathname of the host bridge device.

>  }
> -module_init(ioapic_init);
>  
> -MODULE_LICENSE("GPL");
> +void acpi_pci_ioapic_remove(struct acpi_pci_root *root)
> +{
> +	struct acpi_pci_ioapic *ioapic, *tmp;
> +
> +	mutex_lock(&ioapic_list_lock);
> +	list_for_each_entry_safe(ioapic, tmp, &ioapic_list, list) {
> +		if (root->device->handle != ioapic->root_handle)
> +			continue;
> +		list_del(&ioapic->list);
> +		handle_ioapic_remove(ioapic->root_handle, ioapic->pdev,
> +					ioapic->gsi_base);
> +		kfree(ioapic);
> +	}
> +	mutex_unlock(&ioapic_list_lock);
> +}
> diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
> index 5a462c4..d2a976a 100644
> --- a/include/linux/pci-acpi.h
> +++ b/include/linux/pci-acpi.h
> @@ -67,6 +67,14 @@ static inline void acpiphp_remove_slots(struct pci_bus *bus) { }
>  static inline void acpiphp_check_host_bridge(acpi_handle handle) { }
>  #endif
>  
> +#ifdef CONFIG_PCI_IOAPIC
> +void acpi_pci_ioapic_add(struct acpi_pci_root *root);
> +void acpi_pci_ioapic_remove(struct acpi_pci_root *root);
> +#else
> +static inline void acpi_pci_ioapic_add(struct acpi_pci_root *root) { }
> +static inline void acpi_pci_ioapic_remove(struct acpi_pci_root *root) { }
> +#endif
> +
>  #else	/* CONFIG_ACPI */
>  static inline void acpi_pci_add_bus(struct pci_bus *bus) { }
>  static inline void acpi_pci_remove_bus(struct pci_bus *bus) { }
> -- 
> 1.8.4
> 
