Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3EaQUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:20:39 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63900 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab3EaQU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:20:29 -0400
Message-ID: <51A8CDC7.2050508@gmail.com>
Date: Sat, 01 Jun 2013 00:20:23 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 2/2] ACPI, pci_root: use acpi_handle_print() and pr_xxx()
 to print messages
References: <1368536439-19421-1-git-send-email-jiang.liu@huawei.com> <1368536439-19421-2-git-send-email-jiang.liu@huawei.com> <20130530173356.GA26075@google.com> <3828716.JNCrg8I1Kf@vostro.rjw.lan>
In-Reply-To: <3828716.JNCrg8I1Kf@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31 May 2013 03:51:51 AM CST, Rafael J. Wysocki wrote:
> On Thursday, May 30, 2013 11:33:56 AM Bjorn Helgaas wrote:
>> On Tue, May 14, 2013 at 09:00:39PM +0800, Jiang Liu wrote:
>>> Use acpi_handle_print() and pr_xxx() to print messages in pci_root.c.
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>> Cc: Len Brown <lenb@kernel.org>
>>> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
>>> Cc: linux-acpi@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  drivers/acpi/pci_root.c | 70 ++++++++++++++++++++++---------------------------
>>>  1 file changed, 32 insertions(+), 38 deletions(-)
>>>
>>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>>> index 91ddfd6..21dda5a 100644
>>> --- a/drivers/acpi/pci_root.c
>>> +++ b/drivers/acpi/pci_root.c
>>> @@ -379,23 +379,24 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>  	struct acpi_pci_root *root;
>>>  	u32 flags, base_flags;
>>>  	bool is_osc_granted = false;
>>> +	acpi_handle handle = device->handle;
>>>
>>>  	root = kzalloc(sizeof(struct acpi_pci_root), GFP_KERNEL);
>>>  	if (!root)
>>>  		return -ENOMEM;
>>>
>>>  	segment = 0;
>>> -	status = acpi_evaluate_integer(device->handle, METHOD_NAME__SEG, NULL,
>>> +	status = acpi_evaluate_integer(handle, METHOD_NAME__SEG, NULL,
>>>  				       &segment);
>>>  	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
>>> -		printk(KERN_ERR PREFIX "can't evaluate _SEG\n");
>>> +		acpi_handle_err(handle, "can't evaluate _SEG\n");
>>
>> I previously acked this, but I noticed that we are making a mix of
>> dev_printk() and acpi_handle_printk() here.  The difference is like this:
>>
>>   acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>>   ACPI: \_SB_.PCI0: ACPI _OSC support notification failed, disabling PCIe ASPM
>>
>> I'm not sure which direction we should go here, but I think we should
>> choose one or the other and use it consistently.  Personally, I think the
>> internal DSDT names should be available *somewhere*, but not necessarily
>> used in run-of-the-mill chit-chat.  For that reason, I prefer
>> dev_printk(), though I have the feeling that Rafael is moving toward
>> eliminating the struct acpi_device, so he might prefer
>> acpi_handle_printk().
>
> I really don't care that much, but I agree that they should be used
> consistently.
Hi Bjorn and Rafael,
     I will work on this tomorrow. In some cases, only handle is 
available, so we
could only use acpi_handle_printk(). So I think the directly may be: 
use dev_printk()
if possible, otherwise use acpi_handle_printk() instead. Is that the 
right way to go?
Regards!
Gerry

>
> Thanks,
> Rafael
>
>
>>>  		result = -ENODEV;
>>>  		goto end;
>>>  	}
>>>
>>>  	/* Check _CRS first, then _BBN.  If no _BBN, default to zero. */
>>>  	root->secondary.flags = IORESOURCE_BUS;
>>> -	status = try_get_root_bridge_busnr(device->handle, &root->secondary);
>>> +	status = try_get_root_bridge_busnr(handle, &root->secondary);
>>>  	if (ACPI_FAILURE(status)) {
>>>  		/*
>>>  		 * We need both the start and end of the downstream bus range
>>> @@ -404,16 +405,16 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>  		 * can do is assume [_BBN-0xFF] or [0-0xFF].
>>>  		 */
>>>  		root->secondary.end = 0xFF;
>>> -		printk(KERN_WARNING FW_BUG PREFIX
>>> -		       "no secondary bus range in _CRS\n");
>>> -		status = acpi_evaluate_integer(device->handle, METHOD_NAME__BBN,
>>> +		acpi_handle_warn(handle,
>>> +				 FW_BUG "no secondary bus range in _CRS\n");
>>> +		status = acpi_evaluate_integer(handle, METHOD_NAME__BBN,
>>>  					       NULL, &bus);
>>>  		if (ACPI_SUCCESS(status))
>>>  			root->secondary.start = bus;
>>>  		else if (status == AE_NOT_FOUND)
>>>  			root->secondary.start = 0;
>>>  		else {
>>> -			printk(KERN_ERR PREFIX "can't evaluate _BBN\n");
>>> +			acpi_handle_err(handle, "can't evaluate _BBN\n");
>>>  			result = -ENODEV;
>>>  			goto end;
>>>  		}
>>> @@ -425,11 +426,11 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>  	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>>>  	device->driver_data = root;
>>>
>>> -	printk(KERN_INFO PREFIX "%s [%s] (domain %04x %pR)\n",
>>> +	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
>>>  	       acpi_device_name(device), acpi_device_bid(device),
>>>  	       root->segment, &root->secondary);
>>>
>>> -	root->mcfg_addr = acpi_pci_root_get_mcfg_addr(device->handle);
>>> +	root->mcfg_addr = acpi_pci_root_get_mcfg_addr(handle);
>>>
>>>  	/*
>>>  	 * All supported architectures that use ACPI have support for
>>> @@ -473,7 +474,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>  		dev_info(&device->dev,
>>>  			"Requesting ACPI _OSC control (0x%02x)\n", flags);
>>>
>>> -		status = acpi_pci_osc_control_set(device->handle, &flags,
>>> +		status = acpi_pci_osc_control_set(handle, &flags,
>>>  				       OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
>>>  		if (ACPI_SUCCESS(status)) {
>>>  			is_osc_granted = true;
>>> @@ -505,9 +506,9 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>  	 */
>>>  	root->bus = pci_acpi_scan_root(root);
>>>  	if (!root->bus) {
>>> -		printk(KERN_ERR PREFIX
>>> -			    "Bus %04x:%02x not present in PCI namespace\n",
>>> -			    root->segment, (unsigned int)root->secondary.start);
>>> +		acpi_handle_err(handle,
>>> +			"Bus %04x:%02x not present in PCI namespace\n",
>>> +			root->segment, (unsigned int)root->secondary.start);
>>>  		result = -ENODEV;
>>>  		goto end;
>>>  	}
>>> @@ -517,8 +518,8 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>  		if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM)
>>>  			pcie_clear_aspm(root->bus);
>>>  	} else {
>>> -		pr_info("ACPI _OSC control for PCIe not granted, "
>>> -			"disabling ASPM\n");
>>> +		acpi_handle_info(handle,
>>> +			"ACPI _OSC control for PCIe not granted, disabling ASPM\n");
>>>  		pcie_no_aspm();
>>>  	}
>>>
>>> @@ -571,12 +572,13 @@ static void handle_root_bridge_insertion(acpi_handle handle)
>>>  	struct acpi_device *device;
>>>
>>>  	if (!acpi_bus_get_device(handle, &device)) {
>>> -		printk(KERN_DEBUG "acpi device exists...\n");
>>> +		acpi_handle_printk(KERN_DEBUG, handle,
>>> +				   "acpi device exists...\n");
>>>  		return;
>>>  	}
>>>
>>>  	if (acpi_bus_scan(handle))
>>> -		printk(KERN_ERR "cannot add bridge to acpi list\n");
>>> +		acpi_handle_err(handle, "cannot add bridge to acpi list\n");
>>>  }
>>>
>>>  static void handle_root_bridge_removal(struct acpi_device *device)
>>> @@ -602,7 +604,6 @@ static void handle_root_bridge_removal(struct acpi_device *device)
>>>  static void _handle_hotplug_event_root(struct work_struct *work)
>>>  {
>>>  	struct acpi_pci_root *root;
>>> -	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER };
>>>  	struct acpi_hp_work *hp_work;
>>>  	acpi_handle handle;
>>>  	u32 type;
>>> @@ -613,13 +614,11 @@ static void _handle_hotplug_event_root(struct work_struct *work)
>>>
>>>  	root = acpi_pci_find_root(handle);
>>>
>>> -	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>>> -
>>>  	switch (type) {
>>>  	case ACPI_NOTIFY_BUS_CHECK:
>>>  		/* bus enumerate */
>>> -		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
>>> -				 (char *)buffer.pointer);
>>> +		acpi_handle_printk(KERN_DEBUG, handle,
>>> +				   "Bus check notify on %s\n", __func__);
>>>  		if (!root)
>>>  			handle_root_bridge_insertion(handle);
>>>
>>> @@ -627,27 +626,26 @@ static void _handle_hotplug_event_root(struct work_struct *work)
>>>
>>>  	case ACPI_NOTIFY_DEVICE_CHECK:
>>>  		/* device check */
>>> -		printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
>>> -				 (char *)buffer.pointer);
>>> +		acpi_handle_printk(KERN_DEBUG, handle,
>>> +				   "Device check notify on %s\n", __func__);
>>>  		if (!root)
>>>  			handle_root_bridge_insertion(handle);
>>>  		break;
>>>
>>>  	case ACPI_NOTIFY_EJECT_REQUEST:
>>>  		/* request device eject */
>>> -		printk(KERN_DEBUG "%s: Device eject notify on %s\n", __func__,
>>> -				 (char *)buffer.pointer);
>>> +		acpi_handle_printk(KERN_DEBUG, handle,
>>> +				   "Device eject notify on %s\n", __func__);
>>>  		if (root)
>>>  			handle_root_bridge_removal(root->device);
>>>  		break;
>>>  	default:
>>> -		printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
>>> -				 type, (char *)buffer.pointer);
>>> +		acpi_handle_warn(handle,
>>> +			 "notify_handler: unknown event type 0x%x\n", type);
>>>  		break;
>>>  	}
>>>
>>>  	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
>>> -	kfree(buffer.pointer);
>>>  }
>>>
>>>  static void handle_hotplug_event_root(acpi_handle handle, u32 type,
>>> @@ -661,9 +659,6 @@ static acpi_status __init
>>>  find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>>>  {
>>>  	acpi_status status;
>>> -	char objname[64];
>>> -	struct acpi_buffer buffer = { .length = sizeof(objname),
>>> -				      .pointer = objname };
>>>  	int *count = (int *)context;
>>>
>>>  	if (!acpi_is_root_bridge(handle))
>>> @@ -671,16 +666,15 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>>>
>>>  	(*count)++;
>>>
>>> -	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>>> -
>>>  	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
>>>  					handle_hotplug_event_root, NULL);
>>>  	if (ACPI_FAILURE(status))
>>> -		printk(KERN_DEBUG "acpi root: %s notify handler is not installed, exit status: %u\n",
>>> -				  objname, (unsigned int)status);
>>> +		acpi_handle_printk(KERN_DEBUG, handle,
>>> +			"notify handler is not installed, exit status: %u\n",
>>> +			 (unsigned int)status);
>>>  	else
>>> -		printk(KERN_DEBUG "acpi root: %s notify handler is installed\n",
>>> -				 objname);
>>> +		acpi_handle_printk(KERN_DEBUG, handle,
>>> +				   "notify handler is installed\n");
>>>
>>>  	return AE_OK;
>>>  }
>>


