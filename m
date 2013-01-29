Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3A2CVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:21:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57228 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3A2CVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:21:16 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <510731FC.9040402@jp.fujitsu.com>
Date: Tue, 29 Jan 2013 11:20:44 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ACPI / platform: Use struct acpi_scan_handler for
 creating devices
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <4311642.nDd2RCVeDc@vostro.rjw.lan> <1540645.4oLGJ3spZ3@vostro.rjw.lan>
In-Reply-To: <1540645.4oLGJ3spZ3@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

2013/01/28 22:01, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> Currently, the ACPI namespace scanning code creates platform device
> objects for ACPI device nodes whose IDs match the contents of the
> acpi_platform_device_ids[] table.  However, this adds a superfluous
> special case into acpi_bus_device_attach() and makes it more
> difficult to follow than it has to be.  It also will make it more
> difficult to implement removal code for those platform device objects
> in the future.
>
> For the above reasons, introduce a struct acpi_scan_handler object
> for creating platform devices and move the code related to that from
> acpi_bus_device_attach() to the .attach() callback of that object.
> Also move the acpi_platform_device_ids[] table to acpi_platform.c.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>   drivers/acpi/acpi_platform.c |   55 +++++++++++++++++++++++++++++++++++--------
>   drivers/acpi/internal.h      |    7 -----
>   drivers/acpi/scan.c          |   30 -----------------------
>   3 files changed, 47 insertions(+), 45 deletions(-)
>
> Index: test/drivers/acpi/acpi_platform.c
> ===================================================================
> --- test.orig/drivers/acpi/acpi_platform.c
> +++ test/drivers/acpi/acpi_platform.c
> @@ -22,6 +22,30 @@
>
>   ACPI_MODULE_NAME("platform");
>
> +/* Flags for acpi_create_platform_device */
> +#define ACPI_PLATFORM_CLK	BIT(0)
> +
> +/*
> + * The following ACPI IDs are known to be suitable for representing as
> + * platform devices.
> + */
> +static const struct acpi_device_id acpi_platform_device_ids[] = {
> +
> +	{ "PNP0D40" },
> +
> +	/* Haswell LPSS devices */
> +	{ "INT33C0", ACPI_PLATFORM_CLK },
> +	{ "INT33C1", ACPI_PLATFORM_CLK },
> +	{ "INT33C2", ACPI_PLATFORM_CLK },
> +	{ "INT33C3", ACPI_PLATFORM_CLK },
> +	{ "INT33C4", ACPI_PLATFORM_CLK },
> +	{ "INT33C5", ACPI_PLATFORM_CLK },
> +	{ "INT33C6", ACPI_PLATFORM_CLK },
> +	{ "INT33C7", ACPI_PLATFORM_CLK },
> +
> +	{ }
> +};
> +
>   static int acpi_create_platform_clks(struct acpi_device *adev)
>   {
>   	static struct platform_device *pdev;
> @@ -39,8 +63,7 @@ static int acpi_create_platform_clks(str
>   /**
>    * acpi_create_platform_device - Create platform device for ACPI device node
>    * @adev: ACPI device node to create a platform device for.
> - * @flags: ACPI_PLATFORM_* flags that affect the creation of the platform
> - *	   devices.
> + * @id: ACPI device ID used to match @adev.
>    *
>    * Check if the given @adev can be represented as a platform device and, if
>    * that's the case, create and register a platform device, populate its common
> @@ -48,9 +71,10 @@ static int acpi_create_platform_clks(str
>    *
>    * Name of the platform device will be the same as @adev's.
>    */
> -struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
> -						    unsigned long flags)
> +static int acpi_create_platform_device(struct acpi_device *adev,
> +				       const struct acpi_device_id *id)
>   {
> +	unsigned long flags = id->driver_data;
>   	struct platform_device *pdev = NULL;
>   	struct acpi_device *acpi_parent;
>   	struct platform_device_info pdevinfo;
> @@ -59,25 +83,26 @@ struct platform_device *acpi_create_plat
>   	struct resource *resources;
>   	int count;
>

> -	if ((flags & ACPI_PLATFORM_CLK) && acpi_create_platform_clks(adev)) {
> +	if (flags & ACPI_PLATFORM_CLK) {
> +		int ret = acpi_create_platform_clks(adev);
>   		dev_err(&adev->dev, "failed to create clocks\n");
> -		return NULL;
> +		return ret;
>   	}

If (flag & ACPI_PLATFORM_CLK) is true, the acpi_create_platform_device()
always retruns with dev_err() messages. Why?

Thanks,
Yasuaki Ishimatsu

>
>   	/* If the ACPI node already has a physical device attached, skip it. */
>   	if (adev->physical_node_count)
> -		return NULL;
> +		return 0;
>
>   	INIT_LIST_HEAD(&resource_list);
>   	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
>   	if (count <= 0)
> -		return NULL;
> +		return 0;
>
>   	resources = kmalloc(count * sizeof(struct resource), GFP_KERNEL);
>   	if (!resources) {
>   		dev_err(&adev->dev, "No memory for resources\n");
>   		acpi_dev_free_resource_list(&resource_list);
> -		return NULL;
> +		return -ENOMEM;
>   	}
>   	count = 0;
>   	list_for_each_entry(rentry, &resource_list, node)
> @@ -123,5 +148,15 @@ struct platform_device *acpi_create_plat
>   	}
>
>   	kfree(resources);
> -	return pdev;
> +	return 1;
> +}
> +
> +static struct acpi_scan_handler platform_handler = {
> +	.ids = acpi_platform_device_ids,
> +	.attach = acpi_create_platform_device,
> +};
> +
> +void __init acpi_platform_init(void)
> +{
> +	acpi_scan_add_handler(&platform_handler);
>   }
> Index: test/drivers/acpi/internal.h
> ===================================================================
> --- test.orig/drivers/acpi/internal.h
> +++ test/drivers/acpi/internal.h
> @@ -27,6 +27,7 @@ int init_acpi_device_notify(void);
>   int acpi_scan_init(void);
>   void acpi_pci_root_init(void);
>   void acpi_pci_link_init(void);
> +void acpi_platform_init(void);
>   int acpi_sysfs_init(void);
>   void acpi_csrt_init(void);
>
> @@ -119,10 +120,4 @@ static inline void suspend_nvs_restore(v
>     -------------------------------------------------------------------------- */
>   struct platform_device;
>
> -/* Flags for acpi_create_platform_device */
> -#define ACPI_PLATFORM_CLK	BIT(0)
> -
> -struct platform_device *acpi_create_platform_device(struct acpi_device *adev,
> -						    unsigned long flags);
> -
>   #endif /* _ACPI_INTERNAL_H_ */
> Index: test/drivers/acpi/scan.c
> ===================================================================
> --- test.orig/drivers/acpi/scan.c
> +++ test/drivers/acpi/scan.c
> @@ -29,27 +29,6 @@ extern struct acpi_device *acpi_root;
>
>   static const char *dummy_hid = "device";
>
> -/*
> - * The following ACPI IDs are known to be suitable for representing as
> - * platform devices.
> - */
> -static const struct acpi_device_id acpi_platform_device_ids[] = {
> -
> -	{ "PNP0D40" },
> -
> -	/* Haswell LPSS devices */
> -	{ "INT33C0", ACPI_PLATFORM_CLK },
> -	{ "INT33C1", ACPI_PLATFORM_CLK },
> -	{ "INT33C2", ACPI_PLATFORM_CLK },
> -	{ "INT33C3", ACPI_PLATFORM_CLK },
> -	{ "INT33C4", ACPI_PLATFORM_CLK },
> -	{ "INT33C5", ACPI_PLATFORM_CLK },
> -	{ "INT33C6", ACPI_PLATFORM_CLK },
> -	{ "INT33C7", ACPI_PLATFORM_CLK },
> -
> -	{ }
> -};
> -
>   static LIST_HEAD(acpi_device_list);
>   static LIST_HEAD(acpi_bus_id_list);
>   static DEFINE_MUTEX(acpi_scan_lock);
> @@ -1606,7 +1585,6 @@ static int acpi_scan_attach_handler(stru
>   static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
>   					  void *not_used, void **ret_not_used)
>   {
> -	const struct acpi_device_id *id;
>   	struct acpi_device *device;
>   	unsigned long long sta_not_used;
>   	int ret;
> @@ -1621,13 +1599,6 @@ static acpi_status acpi_bus_device_attac
>   	if (acpi_bus_get_device(handle, &device))
>   		return AE_CTRL_DEPTH;
>
> -	id = __acpi_match_device(device, acpi_platform_device_ids);
> -	if (id) {
> -		/* This is a known good platform device. */
> -		acpi_create_platform_device(device, id->driver_data);
> -		return AE_OK;
> -	}
> -
>   	ret = acpi_scan_attach_handler(device);
>   	if (ret)
>   		return ret > 0 ? AE_OK : AE_CTRL_DEPTH;
> @@ -1775,6 +1746,7 @@ int __init acpi_scan_init(void)
>
>   	acpi_pci_root_init();
>   	acpi_pci_link_init();
> +	acpi_platform_init();
>   	acpi_csrt_init();
>
>   	/*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


