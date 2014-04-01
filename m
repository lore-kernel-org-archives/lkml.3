Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaDAQx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaDAQx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:53:27 -0400
Message-ID: <1396371204.476.156.camel@ul30vt.home>
Subject: Re: [PATCH] PCI: rework new_id interface for known vendor/device
 values
From: Alex Williamson <alex.williamson@redhat.com>
To: Bandan Das <bsd@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 01 Apr 2014 10:53:24 -0600
In-Reply-To: <jpgsipz3sbs.fsf@nelium.bos.redhat.com>
References: <jpgsipz3sbs.fsf@nelium.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 00:28 -0400, Bandan Das wrote:
> While using the new_id interface, the user can unintentionally feed
> incorrect values if the driver static table has a matching entry.
> This is possible since only the device and vendor fields are
> mandatory and the rest are optional. As a result, store_new_id
> will fill in default values that are then passed on to the driver
> and can have unintended consequences.
> 
> As an example, consider the ixgbe driver and the 82599EB network card :
> echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id
> 
> This will pass a driver_data value of 0 to the driver whereas
> the index 0 in ixgbe actually points to a different set of card
> operations.
> 
> This change automatically selects the matching static entry if there
> is one for the newly created dynid. However, if the user intentionally
> wants a different set of values, she must provide all the 7 fields
> and the static entry will be ignored.
> 
> In most cases, this use case seems unnecessary, however, this
> is a common libvirt/KVM/device assignment scenario where the
> user might want to bind a device back to the host driver.
> 
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  drivers/pci/pci-driver.c | 42 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 25f0bc6..187e572 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -90,6 +90,24 @@ static void pci_free_dynids(struct pci_driver *drv)
>  	spin_unlock(&drv->dynids.lock);
>  }
>  
> +static const struct
> +pci_device_id *match_id_table_entry(struct device_driver *driver,
> +				    __u32 vendor, __u32 device)
> +{
> +	struct pci_driver *pdrv = to_pci_driver(driver);
> +	const struct pci_device_id *ids = pdrv->id_table;
> +
> +	if (ids) {
> +		while (ids->vendor || ids->subvendor || ids->class_mask) {
> +			if ((ids->vendor == vendor) && (ids->device == device))
> +				return ids;
> +			ids++;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
>  /**
>   * store_new_id - sysfs frontend to pci_add_dynid()
>   * @driver: target device driver
> @@ -102,7 +120,8 @@ static ssize_t
>  store_new_id(struct device_driver *driver, const char *buf, size_t count)
>  {
>  	struct pci_driver *pdrv = to_pci_driver(driver);
> -	const struct pci_device_id *ids = pdrv->id_table;
> +	const struct pci_device_id *ids = pdrv->id_table,
> +		*tids = NULL;
>  	__u32 vendor, device, subvendor=PCI_ANY_ID,
>  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
>  	unsigned long driver_data=0;
> @@ -115,9 +134,24 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
>  	if (fields < 2)
>  		return -EINVAL;
>  
> -	/* Only accept driver_data values that match an existing id_table
> -	   entry */
> -	if (ids) {
> +	tids = match_id_table_entry(driver, vendor, device);
> +

Would it make more sense to construct a pci_dev, ex:

if (fields != 7) {
	struct pci_dev dev = { .subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID };

	dev.vendor = vendor;
	dev.device = device;
	if (fields > 2)
		dev.subvendor = subvendor;
	if (fields > 3)
		dev.subdevice = subdevice;
	...

	if (pci_match_id(drv->id_table, &dev))
		return -EEXIST;
}


> +	if (tids && (fields != 7)) {
> +
> +		subvendor = tids->subvendor;
> +		subdevice = tids->subdevice;
> +		class = tids->class;
> +		class_mask = tids->class_mask;
> +		driver_data = tids->driver_data;

This doesn't look right.  First, we're potentially overwriting user
stored data for fields >2 but <7.  Second, we only matched on vendor &
device and could be filling the rest with data that isn't the best match
(and is guaranteed to just be a duplicate of a static table ID).

> +
> +		pr_warn("pci: Using driver (%s) static DeviceID table entry for vendor 0x%04x and device 0x%04x",
> +			driver->name, vendor, device);

I think we should be error'ing rather than inventing a duplicate ID to
insert.  How would a user ever know how to use remove_id to clean out
this new_id?  Thanks,

Alex

> +
> +	} else if (ids) {
> +
> +		/* Only accept driver_data values that match an existing
> +		   id_table entry */
> +
>  		retval = -EINVAL;
>  		while (ids->vendor || ids->subvendor || ids->class_mask) {
>  			if (driver_data == ids->driver_data) {



