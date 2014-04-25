Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaDYRjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaDYRji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:39:38 -0400
Message-ID: <1398447576.24318.129.camel@ul30vt.home>
Subject: Re: [PATCH v3] PCI: rework new_id interface for known vendor/device
 values
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Bandan Das <bsd@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 25 Apr 2014 11:39:36 -0600
In-Reply-To: <20140424224555.GK29593@google.com>
References: <jpgbnwkplbo.fsf@nelium.bos.redhat.com>
	 <20140424224555.GK29593@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 16:45 -0600, Bjorn Helgaas wrote:
> On Tue, Apr 01, 2014 at 09:32:59PM -0400, Bandan Das wrote:
> > 
> > While using the new_id interface, the user can unintentionally feed
> > incorrect values if the driver static table has a matching entry.
> > This is possible since only the device and vendor fields are
> > mandatory and the rest are optional. As a result, store_new_id
> > will fill in default values that are then passed on to the driver
> > and can have unintended consequences.
> > 
> > As an example, consider the ixgbe driver and the 82599EB network card :
> > echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id
> > 
> > This will pass a driver_data value of 0 to the driver whereas
> > the index 0 in ixgbe actually points to a different set of card
> > operations.
> > 
> > This change returns an error if the user attempts to add a dynid for
> > a vendor/device combination for which a static entry already exists.
> > However, if the user intentionally wants a different set of values,
> > she must provide all the 7 fields and that will be accepted.
> > 
> > In KVM/device assignment scenario, the user might want 
> > to bind a device back to the host driver by writing to new_id
> > and trip on a possible null pointer dereference.
> 
> I don't understand this last KVM comment.  If this patch fixes a null
> pointer dereference, it must be because we return -EEXIST instead of
> calling the driver's probe method.

Right, the NULL pointer dereference is because drivers implicitly trust
the driver_data field supplied to their probe function.  This patch
prevents the user from supplying a "shorthand" vendor/device new_id that
would conflict with an existing static ID by returning -EEXIST on the
new_id update.  This is not really a KVM problem, but prevention of a
user error for the new_id interface; there is no reason for the user to
add a new_id that duplicates an existing ID unless they want to modify
the extended fields.

> Can you outline the sequence of events and the drivers involved?  Did we
> start with a device that was claimed by vfio, and now we're trying to get
> ixgbe to claim it by writing to /sys/bus/pci/drivers/ixgbe/new_id?  If so,
> does that mean the user has to know what driver_data value to supply?

I believe the driver is ixgbe, the device starts out bound to ixgbe, the
user adds the vendor/device IDs to the new_id of a different driver
(which could be pci-stub or vfio-pci or even some alternate host drive
for the device).  They then finish with the alternate driver, use
remove_id, and attempt to rebind back to ixgbe by writing vendor/device
to ixgbe new_id.  This is clearly wrong, the driver already handles this
device and the user should have used drivers_probe or even the ixgbe
bind interface.  However, as it works now, ixgbe now has a new dynamic
"shorthand" match for the device and since dynamic IDs are matched
before static IDs, the device_data from that match (NULL) is passed to
the driver probe() function.  Chaos follows since the driver implicitly
trusts that device_data as something provided by the driver. 

> I know you didn't add the new_id mechanism, and this patch makes it safer
> than it was before, but I'm uneasy about it in general.  Most drivers do
> not validate the driver_data value.  They assume it came out of the
> id_table supplied by the driver and is therefore trustworthy.  But new_id
> is a loophole that allows a user (hopefully only root) to pass arbitrary
> junk to the driver.

The sysfs files are only accessible to root by default.  Your uneasiness
seems to be the new_id mechanism in general.  It is a gap that drivers
implicitly trust a field that can be supplied by the user.  I believe
there's a test in the code somewhere that verifies that device_data at
least matches an existing device_data as a small sanity check.  This
patch closes another gap by disallowing new_ids that are not fully
specified to supersede an existing entry. 

> I wonder if the device assignment machinery should be more integrated into
> the PCI core instead of trying to be "just another driver."  It seems like
> we're doing a lot of work to try to get the driver binding mechanism to do
> what we need for device assignment.

This problem is only tangentially related to device assignment, any PCI
driver can hit this.  Maybe in practice the reason for touching these
files is often device assignment, but this interface pre-dates KVM.  Do
you have suggestions how device assignment could be more integrated to
PCI core?  Note that vfio is intentionally device agnostic and support
for assignment of platform devices using vfio is being actively
developed.  We do have a new binding mechanism awaiting review that
tries to avoid some of the faults with the new_id/remove_id interface.
In this case the user would not need to add a new_id and would use
drivers_probe on both sides of the attach/re-attach.  This is not a
replacement for Bandan's patch, but you can find it on the list here:

              Subject:
[PATCH] PCI: Introduce new device
binding path using
pci_dev.driver_override
               Date:
Fri, 04 Apr 2014 14:19:20 -0600

Thanks,
Alex 

> > Signed-off-by: Bandan Das <bsd@redhat.com>
> > ---
> > v3:
> > relocate pdev decl
> > v2:
> > 1. Return error if there is a matching static entry
> > and change commit message to reflect this behavior
> > 3. Fill in a pdev and call pci_match_id instead of creating
> > a new matching function
> > 4. Change commit message to reflect that libvirt does not
> > depend on this behavior
> > 
> >  drivers/pci/pci-driver.c | 22 +++++++++++++++++++++-
> >  1 file changed, 21 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> > index 25f0bc6..a65a014 100644
> > --- a/drivers/pci/pci-driver.c
> > +++ b/drivers/pci/pci-driver.c
> > @@ -107,7 +107,7 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
> >  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
> >  	unsigned long driver_data=0;
> >  	int fields=0;
> > -	int retval;
> > +	int retval = 0;
> >  
> >  	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
> >  			&vendor, &device, &subvendor, &subdevice,
> > @@ -115,6 +115,26 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
> >  	if (fields < 2)
> >  		return -EINVAL;
> >  
> > +	if (fields != 7) {
> > +		struct pci_dev *pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
> > +		if (!pdev)
> > +			return -ENOMEM;
> > +
> > +		pdev->vendor = vendor;
> > +		pdev->device = device;
> > +		pdev->subsystem_vendor = subvendor;
> > +		pdev->subsystem_device = subdevice;
> > +		pdev->class = class;
> > +
> > +		if (pci_match_id(pdrv->id_table, pdev))
> > +			retval = -EEXIST;
> > +
> > +		kfree(pdev);
> > +
> > +		if (retval)
> > +			return retval;
> > +	}
> > +
> >  	/* Only accept driver_data values that match an existing id_table
> >  	   entry */
> >  	if (ids) {
> > -- 
> > 1.8.3.1
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



