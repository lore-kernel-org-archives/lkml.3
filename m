Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaD2Xlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:41:37 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34647 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaD2Xld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:41:33 -0400
Date: Tue, 29 Apr 2014 17:41:30 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Bandan Das <bsd@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PCI: rework new_id interface for known vendor/device
 values
Message-ID: <20140429234130.GC9912@google.com>
References: <jpgbnwkplbo.fsf@nelium.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jpgbnwkplbo.fsf@nelium.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 09:32:59PM -0400, Bandan Das wrote:
> 
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
> This change returns an error if the user attempts to add a dynid for
> a vendor/device combination for which a static entry already exists.
> However, if the user intentionally wants a different set of values,
> she must provide all the 7 fields and that will be accepted.
> 
> In KVM/device assignment scenario, the user might want 
> to bind a device back to the host driver by writing to new_id
> and trip on a possible null pointer dereference.
> 
> Signed-off-by: Bandan Das <bsd@redhat.com>

Applied with Alex's ack to pci/misc for v3.16, thanks!

> ---
> v3:
> relocate pdev decl
> v2:
> 1. Return error if there is a matching static entry
> and change commit message to reflect this behavior
> 3. Fill in a pdev and call pci_match_id instead of creating
> a new matching function
> 4. Change commit message to reflect that libvirt does not
> depend on this behavior
> 
>  drivers/pci/pci-driver.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 25f0bc6..a65a014 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -107,7 +107,7 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
>  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
>  	unsigned long driver_data=0;
>  	int fields=0;
> -	int retval;
> +	int retval = 0;
>  
>  	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
>  			&vendor, &device, &subvendor, &subdevice,
> @@ -115,6 +115,26 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
>  	if (fields < 2)
>  		return -EINVAL;
>  
> +	if (fields != 7) {
> +		struct pci_dev *pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
> +		if (!pdev)
> +			return -ENOMEM;
> +
> +		pdev->vendor = vendor;
> +		pdev->device = device;
> +		pdev->subsystem_vendor = subvendor;
> +		pdev->subsystem_device = subdevice;
> +		pdev->class = class;
> +
> +		if (pci_match_id(pdrv->id_table, pdev))
> +			retval = -EEXIST;
> +
> +		kfree(pdev);
> +
> +		if (retval)
> +			return retval;
> +	}
> +
>  	/* Only accept driver_data values that match an existing id_table
>  	   entry */
>  	if (ids) {
> -- 
> 1.8.3.1
> 
