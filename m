Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3HVN3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:29:09 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39205 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3HVN3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:29:06 -0400
MIME-Version: 1.0
In-Reply-To: <1376189294-32022-29-git-send-email-yinghai@kernel.org>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
	<1376189294-32022-29-git-send-email-yinghai@kernel.org>
Date: Thu, 22 Aug 2013 21:29:04 +0800
Message-ID: <CANVTcTYhSfU+Su9s1B+mTTBfgsZgqvQxHiTsLck1zT_vg1Cs4g@mail.gmail.com>
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

On 8/11/13, Yinghai Lu <yinghai@kernel.org> wrote:
> Some ioapic controllers do not show up on pci config space,
> or pci device is there but no bar is used and is set by firmware in
> other non standard registers.
>
> We can get ioapic address from ACPI0009's _CRS.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/ioapic.c | 86
> +++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 71 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> index 60351b2..41f7c69 100644
> --- a/drivers/pci/ioapic.c
> +++ b/drivers/pci/ioapic.c
> @@ -32,6 +32,36 @@ struct acpi_pci_ioapic {
>  static LIST_HEAD(ioapic_list);
>  static DEFINE_MUTEX(ioapic_list_lock);
>
> +static acpi_status setup_res(struct acpi_resource *acpi_res, void *data)
> +{
> +	struct resource *res;
> +	struct acpi_resource_address64 addr;
> +	acpi_status status;
> +	unsigned long flags;
> +	u64 start, end;
> +
> +	status = acpi_resource_to_address64(acpi_res, &addr);

The above function fails on my machine because it does not handle
Memory32Fixed resources. Is the following _CRS declaration allowed for
IOAPIC?

            Device (APIC)
            {
                Name (_HID, "ACPI0009")  // _HID: Hardware ID
                Name (_CRS, ResourceTemplate ()  // _CRS: Current
Resource Settings
                {
                    Memory32Fixed (ReadOnly,
                        0xFEC01000,         // Address Base
                        0x00001000,         // Address Length
                        )
                })
                Method(_GSB) {
                        return (0x18)
                }
            }


Thanks
Rui

> +	if (!ACPI_SUCCESS(status))
> +		return AE_OK;
> +
> +	if (addr.resource_type == ACPI_MEMORY_RANGE) {
> +		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
> +			return AE_OK;
> +		flags = IORESOURCE_MEM;
> +	} else
> +		return AE_OK;
> +
> +	start = addr.minimum + addr.translation_offset;
> +	end = addr.maximum + addr.translation_offset;
> +
> +	res = data;
> +	res->flags = flags;
> +	res->start = start;
> +	res->end = end;
> +
> +	return AE_OK;
> +}
> +
>  static void handle_ioapic_add(acpi_handle handle, struct pci_dev **pdev,
>  				 u32 *pgsi_base)
>  {
> @@ -54,33 +84,56 @@ static void handle_ioapic_add(acpi_handle handle, struct
> pci_dev **pdev,
>  		return;
>
>  	dev = acpi_get_pci_dev(handle);
> -	if (!dev)
> -		return;
> +	if (!dev || !pci_resource_len(dev, 0)) {
> +		struct acpi_device_info *info;
> +		char *hid = NULL;
> +
> +		status = acpi_get_object_info(handle, &info);
> +		if (ACPI_FAILURE(status))
> +			goto exit_put;
> +		if (info->valid & ACPI_VALID_HID)
> +			hid = info->hardware_id.string;
> +		if (!hid || strcmp(hid, "ACPI0009")) {
> +			kfree(info);
> +			goto exit_put;
> +		}
> +		kfree(info);
> +		memset(res, 0, sizeof(*res));
> +		acpi_walk_resources(handle, METHOD_NAME__CRS, setup_res, res);
> +		if (!res->flags)
> +			goto exit_put;
> +	}
>
>  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>
>  	gsi_base = gsb;
>  	type = "IOxAPIC";
> +	if (dev) {
> +		ret = pci_enable_device(dev);
> +		if (ret < 0)
> +			goto exit_put;
>
> -	ret = pci_enable_device(dev);
> -	if (ret < 0)
> -		goto exit_put;
> -
> -	pci_set_master(dev);
> +		pci_set_master(dev);
>
> -	if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
> -		type = "IOAPIC";
> +		if (dev->class == PCI_CLASS_SYSTEM_PIC_IOAPIC)
> +			type = "IOAPIC";
>
> -	if (pci_request_region(dev, 0, type))
> -		goto exit_disable;
> +		if (pci_resource_len(dev, 0)) {
> +			if (pci_request_region(dev, 0, type))
> +				goto exit_disable;
>
> -	res = &dev->resource[0];
> +			res = &dev->resource[0];
> +		}
> +	}
>
> -	if (acpi_register_ioapic(handle, res->start, gsi_base))
> -		goto exit_release;
> +	if (acpi_register_ioapic(handle, res->start, gsi_base)) {
> +		if (dev)
> +			goto exit_release;
> +		return;
> +	}
>
>  	pr_info("%s %s %s at %pR, GSI %u\n",
> -		dev_name(&dev->dev), objname, type,
> +		dev ? dev_name(&dev->dev) : "", objname, type,
>  		res, gsi_base);
>
>  	*pdev = dev;
> @@ -100,6 +153,9 @@ static void handle_ioapic_remove(acpi_handle handle,
> struct pci_dev *dev,
>  {
>  	acpi_unregister_ioapic(handle, gsi_base);
>
> +	if (!dev)
> +		return;
> +
>  	pci_release_region(dev, 0);
>  	pci_disable_device(dev);
>  	pci_dev_put(dev);
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
