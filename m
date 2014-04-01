Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaDAWpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:45:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaDAWpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:45:02 -0400
Message-ID: <1396392298.476.226.camel@ul30vt.home>
Subject: Re: [PATCH v2] PCI: rework new_id interface for known vendor/device
 values
From: Alex Williamson <alex.williamson@redhat.com>
To: Bandan Das <bsd@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 01 Apr 2014 16:44:58 -0600
In-Reply-To: <jpgr45gk8wn.fsf@nelium.bos.redhat.com>
References: <jpgeh1gpwwo.fsf@nelium.bos.redhat.com>
	 <1396388707.476.188.camel@ul30vt.home>
	 <jpgr45gk8wn.fsf@nelium.bos.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 18:00 -0400, Bandan Das wrote:
> Alex Williamson <alex.williamson@redhat.com> writes:
> 
> > On Tue, 2014-04-01 at 17:22 -0400, Bandan Das wrote:
> >> While using the new_id interface, the user can unintentionally feed
> >> incorrect values if the driver static table has a matching entry.
> >> This is possible since only the device and vendor fields are
> >> mandatory and the rest are optional. As a result, store_new_id
> >> will fill in default values that are then passed on to the driver
> >> and can have unintended consequences.
> >> 
> >> As an example, consider the ixgbe driver and the 82599EB network card :
> >> echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id
> >> 
> >> This will pass a driver_data value of 0 to the driver whereas
> >> the index 0 in ixgbe actually points to a different set of card
> >> operations.
> >> 
> >> This change returns an error if the user attempts to add a dynid for
> >> a vendor/device combination for which a static entry already exists.
> >> However, if the user intentionally wants a different set of values,
> >> she must provide all the 7 fields and that will be accepted.
> >> 
> >> In KVM/device assignment scenario, the user might want 
> >> to bind a device back to the host driver by writing to new_id
> >> and trip on a possible null pointer dereference.
> >> 
> >> Signed-off-by: Bandan Das <bsd@redhat.com>
> >> ---
> >> v2:
> >> 1. Return error if there is a matching static entry
> >> and change commit message to reflect this behavior
> >> 3. Fill in a pdev and call pci_match_id instead of creating
> >> a new matching function
> >> 4. Change commit message to reflect that libvirt does not
> >> depend on this behavior
> >> 
> >>  drivers/pci/pci-driver.c | 23 ++++++++++++++++++++++-
> >>  1 file changed, 22 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> >> index 25f0bc6..493514e 100644
> >> --- a/drivers/pci/pci-driver.c
> >> +++ b/drivers/pci/pci-driver.c
> >> @@ -103,11 +103,12 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
> >>  {
> >>  	struct pci_driver *pdrv = to_pci_driver(driver);
> >>  	const struct pci_device_id *ids = pdrv->id_table;
> >> +	struct pci_dev *pdev;
> >>  	__u32 vendor, device, subvendor=PCI_ANY_ID,
> >>  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
> >>  	unsigned long driver_data=0;
> >>  	int fields=0;
> >> -	int retval;
> >> +	int retval = 0;
> >>  
> >>  	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
> >>  			&vendor, &device, &subvendor, &subdevice,
> >> @@ -115,6 +116,26 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
> >>  	if (fields < 2)
> >>  		return -EINVAL;
> >>  
> >> +	if (fields != 7) {
> >
> > nit, pdev could be declared within this scope.
> 
> Ok, will spin a new one.
> 
> >> +		pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
> >> +		if (!pdev)
> >> +			return -ENOMEM;
> >> +
> >> +		pdev->vendor = vendor;
> >> +		pdev->device = device;
> >> +		pdev->subsystem_vendor = subvendor;
> >> +		pdev->subsystem_device = subdevice;
> >> +		pdev->class = class;
> >
> > Why not class_mask?
> pdev->class_mask isn't used anywhere.

Ah, you're right.  Ok.  Thanks,

Alex

> >> +
> >> +		if (pci_match_id(pdrv->id_table, pdev))
> >> +			retval = -EEXIST;
> >> +
> >> +		kfree(pdev);
> >> +
> >> +		if (retval)
> >> +			return retval;
> >> +	}
> >> +
> >>  	/* Only accept driver_data values that match an existing id_table
> >>  	   entry */
> >>  	if (ids) {



