Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab3HWKlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:41:19 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:41570 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3HWKlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:41:17 -0400
MIME-Version: 1.0
In-Reply-To: <CANVTcTYhSfU+Su9s1B+mTTBfgsZgqvQxHiTsLck1zT_vg1Cs4g@mail.gmail.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-29-git-send-email-yinghai@kernel.org>
	<CANVTcTYhSfU+Su9s1B+mTTBfgsZgqvQxHiTsLck1zT_vg1Cs4g@mail.gmail.com>
Date: Fri, 23 Aug 2013 18:41:15 +0800
Message-ID: <CANVTcTb2+qX6XMBqrzeLho9yFS55AnztVJ85JBMuxjoH11qzaQ@mail.gmail.com>
Subject: Re: [PATCH v4 28/28] PCI, x86, ACPI: get ioapic address from acpi device
From: rui wang <ruiv.wang@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/13, rui wang <ruiv.wang@gmail.com> wrote:
> On 8/11/13, Yinghai Lu <yinghai@kernel.org> wrote:
>> Some ioapic controllers do not show up on pci config space,
>> or pci device is there but no bar is used and is set by firmware in
>> other non standard registers.
>>
>> We can get ioapic address from ACPI0009's _CRS.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/ioapic.c | 86
>> +++++++++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 71 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
>> index 60351b2..41f7c69 100644
>> --- a/drivers/pci/ioapic.c
>> +++ b/drivers/pci/ioapic.c
>> @@ -32,6 +32,36 @@ struct acpi_pci_ioapic {
>>  static LIST_HEAD(ioapic_list);
>>  static DEFINE_MUTEX(ioapic_list_lock);
>>
>> +static acpi_status setup_res(struct acpi_resource *acpi_res, void *data)
>> +{
>> +	struct resource *res;
>> +	struct acpi_resource_address64 addr;
>> +	acpi_status status;
>> +	unsigned long flags;
>> +	u64 start, end;
>> +
>> +	status = acpi_resource_to_address64(acpi_res, &addr);

I worked around the problem by replacing acpi_resource_to_address64()
with resource_to_addr().  But resource_to_addr() is a static function
in arch/x86/pci/acpi.c, not very convenient to use. Here's what I did:

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index d641897..cb5940a 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -218,7 +218,7 @@ static void teardown_mcfg_map(struct pci_root_info *info)
 }
 #endif

-static acpi_status
+acpi_status
 resource_to_addr(struct acpi_resource *resource,
                        struct acpi_resource_address64 *addr)
 {
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 41f7c69..68d7395 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -40,7 +40,7 @@ static acpi_status setup_res(struct acpi_resource
*acpi_res, void *data)
        unsigned long flags;
        u64 start, end;

-       status = acpi_resource_to_address64(acpi_res, &addr);
+       status = resource_to_addr(acpi_res, &addr);
        if (!ACPI_SUCCESS(status))
                return AE_OK;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 94383a7..ae7f759 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -354,6 +354,10 @@ extern int unregister_acpi_notifier(struct
notifier_block *);

 extern int register_acpi_bus_notifier(struct notifier_block *nb);
 extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
+extern acpi_status
+resource_to_addr(struct acpi_resource *resource,
+                        struct acpi_resource_address64 *addr);
+

Thanks
Rui


>
> The above function fails on my machine because it does not handle
> Memory32Fixed resources. Is the following _CRS declaration allowed for
> IOAPIC?
>
>             Device (APIC)
>             {
>                 Name (_HID, "ACPI0009")  // _HID: Hardware ID
>                 Name (_CRS, ResourceTemplate ()  // _CRS: Current
> Resource Settings
>                 {
>                     Memory32Fixed (ReadOnly,
>                         0xFEC01000,         // Address Base
>                         0x00001000,         // Address Length
>                         )
>                 })
>                 Method(_GSB) {
>                         return (0x18)
>                 }
>             }
>
>
> Thanks
> Rui
>
>> +	if (!ACPI_SUCCESS(status))
>> +		return AE_OK;
>> +
>> +	if (addr.resource_type == ACPI_MEMORY_RANGE) {
>> +		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
>> +			return AE_OK;
>> +		flags = IORESOURCE_MEM;
>> +	} else
>> +		return AE_OK;
>> +
>> +	start = addr.minimum + addr.translation_offset;
>> +	end = addr.maximum + addr.translation_offset;
>> +
>> +	res = data;
>> +	res->flags = flags;
>> +	res->start = start;
>> +	res->end = end;
>> +
>> +	return AE_OK;
>> +}
>> +
>>  static void handle_ioapic_add(acpi_handle handle, struct pci_dev **pdev,
>>  				 u32 *pgsi_base)
>>  {
>> @@ -54,33 +84,56 @@ static void handle_ioapic_add(acpi_handle handle,
>> struct
>> pci_dev **pdev,
>>  		return;
>>
>>  	dev = acpi_get_pci_dev(handle);
>> -	if (!dev)
>> -		return;
>> +	if (!dev || !pci_resource_len(dev, 0)) {
>> +		struct acpi_device_info *info;
>> +		char *hid = NULL;
>> +
>> +		status = acpi_get_object_info(handle, &info);
>> +		if (ACPI_FAILURE(status))
>> +			goto exit_put;
>> +		if (info->valid & ACPI_VALID_HID)
>> +			hid = info->hardware_id.string;
>> +		if (!hid || strcmp(hid, "ACPI0009")) {
>> +			kfree(info);
>> +			goto exit_put;
>> +		}
>> +		kfree(info);
>> +		memset(res, 0, sizeof(*res));
>> +		acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
>> +		if (!res->flags)
>> +			goto exit_put;
>> +	}
>>
>>  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>>
>>  	gsi_base = gsb;
>>  	type = "IOxAPIC";
>> +	if (dev) {
>> +		ret = pci_enable_device(dev);
>> +		if (ret < 0)
>> +			goto exit_put;
>>
>> -	ret = pci_enable_device(dev);
>> -	if (ret < 0)
>> -		goto exit_put;
>> -
>> -	pci_set_master(dev);
>> +		pci_set_master(dev);
>>
>> -	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
>> -		type = "IOAPIC";
>> +		if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
>> +			type = "IOAPIC";
>>
>> -	if (pci_request_region(dev, 0, type))
>> -		goto exit_disable;
>> +		if (pci_resource_len(dev, 0)) {
>> +			if (pci_request_region(dev, 0, type))
>> +				goto exit_disable;
>>
>> -	res = &dev->resource[0];
>> +			res = &dev->resource[0];
>> +		}
>> +	}
>>
>> -	if (acpi_register_ioapic(handle, res->start, gsi_base))
>> -		goto exit_release;
>> +	if (acpi_register_ioapic(handle, res->start, gsi_base)) {
>> +		if (dev)
>> +			goto exit_release;
>> +		return;
>> +	}
>>
>>  	pr_info("%s %s %s at %pR, GSI %u\n",
>> -		dev_name(&dev->dev), objname, type,
>> +		dev ? dev_name(&dev->dev) : "", objname, type,
>>  		res, gsi_base);
>>
>>  	*pdev = dev;
>> @@ -100,6 +153,9 @@ static void handle_ioapic_remove(acpi_handle handle,
>> struct pci_dev *dev,
>>  {
>>  	acpi_unregister_ioapic(handle, gsi_base);
>>
>> +	if (!dev)
>> +		return;
>> +
>>  	pci_release_region(dev, 0);
>>  	pci_disable_device(dev);
>>  	pci_dev_put(dev);
>> --
>> 1.8.1.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
