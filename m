Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaDYRvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaDYRvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:51:52 -0400
From: Bandan Das <bsd@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PCI: rework new_id interface for known vendor/device values
References: <jpgbnwkplbo.fsf@nelium.bos.redhat.com>
	<20140424224555.GK29593@google.com>
Date: Fri, 25 Apr 2014 13:51:50 -0400
In-Reply-To: <20140424224555.GK29593@google.com> (Bjorn Helgaas's message of
	"Thu, 24 Apr 2014 16:45:55 -0600")
Message-ID: <jpgtx9h9u15.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> On Tue, Apr 01, 2014 at 09:32:59PM -0400, Bandan Das wrote:
>> 
>> While using the new_id interface, the user can unintentionally feed
>> incorrect values if the driver static table has a matching entry.
>> This is possible since only the device and vendor fields are
>> mandatory and the rest are optional. As a result, store_new_id
>> will fill in default values that are then passed on to the driver
>> and can have unintended consequences.
>> 
>> As an example, consider the ixgbe driver and the 82599EB network card :
>> echo "8086 10fb" > /sys/bus/pci/drivers/ixgbe/new_id
>> 
>> This will pass a driver_data value of 0 to the driver whereas
>> the index 0 in ixgbe actually points to a different set of card
>> operations.
>> 
>> This change returns an error if the user attempts to add a dynid for
>> a vendor/device combination for which a static entry already exists.
>> However, if the user intentionally wants a different set of values,
>> she must provide all the 7 fields and that will be accepted.
>> 
>> In KVM/device assignment scenario, the user might want 
>> to bind a device back to the host driver by writing to new_id
>> and trip on a possible null pointer dereference.
>
> I don't understand this last KVM comment.  If this patch fixes a null
> pointer dereference, it must be because we return -EEXIST instead of
> calling the driver's probe method.

A null pointer dereference in the ixgbe driver's struct ixgbe_info
that points to operations for a card model. In this case, when the user 
uses the new_id interface (without specifying driver_data), it defaults
to 0. So, ixgbe_info points to ixgbe_82598_info with mac_ops set to 
mac_ops_82598 while the card in question is a 82599.

> Can you outline the sequence of events and the drivers involved?  Did we

Something like this is enough to trigger this -
echo "b:f:d" > /sys/bus/.../driver/unbind
echo "b:f:d" > /sys/bus/pci/drives/ixgbe/new_id
echo 16 > /sys/bus/pci/devices/b:f:d/sriov_numvfs

> start with a device that was claimed by vfio, and now we're trying to get
> ixgbe to claim it by writing to /sys/bus/pci/drivers/ixgbe/new_id?  If so,
> does that mean the user has to know what driver_data value to supply?

Yes, but isn't it better than defaulting to 0 ?

> I know you didn't add the new_id mechanism, and this patch makes it safer
> than it was before, but I'm uneasy about it in general.  Most drivers do
> not validate the driver_data value.  They assume it came out of the
> id_table supplied by the driver and is therefore trustworthy.  But new_id
> is a loophole that allows a user (hopefully only root) to pass arbitrary
> junk to the driver.

I think this is what this patch does. If the user intends to, let her
pass arbitrary junk, let's not assume values on behalf of the user.

> I wonder if the device assignment machinery should be more integrated into
> the PCI core instead of trying to be "just another driver."  It seems like
> we're doing a lot of work to try to get the driver binding mechanism to do
> what we need for device assignment.

Agreed, the example I mentioned above is something likely to be
attempted by someone doing device assignment. But I still think
that if the user wants to use new_id, she (or the driver) provides
the value of driver_data. Why should pci assume 0 on behalf of the
user ?

Another option could be that if we do want to keep the driver_data
field optional, maybe the default is -1 (rather than 0). That way,
drivers can fail probe or do something else if they have 
use of it's value. 

> Bjorn
>
>> Signed-off-by: Bandan Das <bsd@redhat.com>
>> ---
>> v3:
>> relocate pdev decl
>> v2:
>> 1. Return error if there is a matching static entry
>> and change commit message to reflect this behavior
>> 3. Fill in a pdev and call pci_match_id instead of creating
>> a new matching function
>> 4. Change commit message to reflect that libvirt does not
>> depend on this behavior
>> 
>>  drivers/pci/pci-driver.c | 22 +++++++++++++++++++++-
>>  1 file changed, 21 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> index 25f0bc6..a65a014 100644
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -107,7 +107,7 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
>>  		subdevice=PCI_ANY_ID, class=0, class_mask=0;
>>  	unsigned long driver_data=0;
>>  	int fields=0;
>> -	int retval;
>> +	int retval = 0;
>>  
>>  	fields = sscanf(buf, "%x %x %x %x %x %x %lx",
>>  			&vendor, &device, &subvendor, &subdevice,
>> @@ -115,6 +115,26 @@ store_new_id(struct device_driver *driver, const char *buf, size_t count)
>>  	if (fields < 2)
>>  		return -EINVAL;
>>  
>> +	if (fields != 7) {
>> +		struct pci_dev *pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
>> +		if (!pdev)
>> +			return -ENOMEM;
>> +
>> +		pdev->vendor = vendor;
>> +		pdev->device = device;
>> +		pdev->subsystem_vendor = subvendor;
>> +		pdev->subsystem_device = subdevice;
>> +		pdev->class = class;
>> +
>> +		if (pci_match_id(pdrv->id_table, pdev))
>> +			retval = -EEXIST;
>> +
>> +		kfree(pdev);
>> +
>> +		if (retval)
>> +			return retval;
>> +	}
>> +
>>  	/* Only accept driver_data values that match an existing id_table
>>  	   entry */
>>  	if (ids) {
>> -- 
>> 1.8.3.1
>> 
