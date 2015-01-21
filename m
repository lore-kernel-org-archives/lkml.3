Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbbAUWSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:18:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61964 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751702AbbAUWRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:17:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: lenb@kernel.org, hdegoede@redhat.com, tj@kernel.org, arnd@arndb.de,
        mjg59@srcf.ucam.org, grant.likely@linaro.org, hanjun.guo@linaro.org,
        al.stone@linaro.org, graeme.gregory@linaro.org, leo.duran@amd.com,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [V2 PATCH 1/2] ACPI / scan: Add support for ACPI _CLS device matching
Date: Wed, 21 Jan 2015 23:40:30 +0100
Message-ID: <5683234.1DZkid7LZL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420492275-6878-2-git-send-email-Suravee.Suthikulpanit@amd.com>
References: <1420492275-6878-1-git-send-email-Suravee.Suthikulpanit@amd.com> <1420492275-6878-2-git-send-email-Suravee.Suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 05, 2015 03:11:14 PM Suravee Suthikulpanit wrote:
> Device drivers typically use ACPI _HIDs/_CIDs listed in struct device_driver
> acpi_match_table to match devices. However, for generic drivers, we do
> not want to list _HID for all supported devices, and some device classes
> do not have _CID (e.g. SATA, USB). Instead, we can leverage ACPI _CLS,
> which specifies PCI-defined class code (i.e. base-class, subclass and
> programming interface).
> 
> This patch adds support for matching ACPI devices using the _CLS method.
> 
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> ---
>  drivers/acpi/scan.c             | 79 +++++++++++++++++++++++++++++++++++++++--
>  include/acpi/acnames.h          |  1 +
>  include/linux/acpi.h            | 10 ++++++
>  include/linux/device.h          |  1 +
>  include/linux/mod_devicetable.h |  6 ++++
>  5 files changed, 94 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 16914cc..7b25221 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -987,13 +987,86 @@ static bool acpi_of_driver_match_device(struct device *dev,
>  bool acpi_driver_match_device(struct device *dev,
>  			      const struct device_driver *drv)
>  {
> -	if (!drv->acpi_match_table)
> -		return acpi_of_driver_match_device(dev, drv);
> +	bool ret = false;
>  
> -	return !!acpi_match_device(drv->acpi_match_table, dev);
> +	if (drv->acpi_match_table)
> +		ret = !!acpi_match_device(drv->acpi_match_table, dev);
> +
> +	/* Next, try to match with special "PRP0001" _HID */
> +	if (!ret && drv->of_match_table)
> +		ret = acpi_of_driver_match_device(dev, drv);
> +
> +	/* Next, try to match with PCI-defined class-code */
> +	if (!ret && drv->acpi_match_cls)
> +		ret = acpi_match_device_cls(drv->acpi_match_cls, dev);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(acpi_driver_match_device);
>  
> +/**
> + * acpi_match_device_cls - Match a struct device against a ACPI _CLS method
> + * @dev_cls: A pointer to struct acpi_device_cls object to match against.
> + * @dev: The ACPI device structure to match.
> + *
> + * Check if @dev has a valid ACPI and _CLS handle. If there is a
> + * struct acpi_device_cls object for that handle, use that object to match
> + * against the given struct acpi_device_cls object.
> + *
> + * Return true on success or false on failure.
> + */
> +bool acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
> +			  const struct device *dev)
> +{
> +	bool ret = false;
> +	acpi_status status;
> +	union acpi_object *pkg;
> +	struct acpi_device_cls cls;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	struct acpi_buffer format = { sizeof("NNN"), "NNN" };
> +	struct acpi_buffer state = { 0, NULL };
> +	struct acpi_device *adev = ACPI_COMPANION(dev);
> +	acpi_handle handle = ACPI_HANDLE(dev);

That must be equal to adev->handle, so it is not necessary to use ACPI_HANDLE() here.

> +
> +	if (!handle || !adev || !adev->status.present || !dev_cls)
> +		return ret;

		return false;

and set 'ret' later.  And if you check 'adev', you don't need to check 'handle'.
And you can use adev->handle directly below, so the 'handle' variable is not
necessary.

> +
> +	status = acpi_evaluate_object(handle, METHOD_NAME__CLS, NULL, &buffer);
> +	if (ACPI_FAILURE(status))
> +		return ret;

		return false;

> +
> +	/**
> +	 * Note:
> +	 * ACPIv5.1 defines the package to contain 3 integers for
> +	 * Base-Class code, Sub-Class code, and Programming Interface code.
> +	 */
> +	pkg = buffer.pointer;
> +	if (!pkg ||
> +	    (pkg->type != ACPI_TYPE_PACKAGE) ||
> +	    (pkg->package.count != 3)) {
> +		dev_err(&adev->dev, "Invalid _CLS data\n");

dev_dbg() here, please.

> +		goto out;
> +	}
> +
> +	state.length = sizeof(struct acpi_device_cls);
> +	state.pointer = &cls;
> +
> +	status = acpi_extract_package(pkg, &format, &state);
> +	if (ACPI_FAILURE(status)) {
> +		ACPI_EXCEPTION((AE_INFO, status, "Invalid data"));

I'm not sure how useful that message is going to be to be honest.

> +		goto out;
> +	}
> +
> +	if ((dev_cls->base_class == cls.base_class) &&
> +	    (dev_cls->sub_class == cls.sub_class) &&
> +	    (dev_cls->prog_interface == cls.prog_interface))
> +		ret = true;

	ret = dev_cls->base_class == cls.base_class &&
		dev_cls->sub_class == cls.sub_class &&
		dev_cls->prog_interface == cls.prog_interface;

> +out:
> +	kfree(buffer.pointer);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(acpi_match_device_cls);
> +
>  static void acpi_free_power_resources_lists(struct acpi_device *device)
>  {
>  	int i;
> diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
> index 7461327..22332a6 100644
> --- a/include/acpi/acnames.h
> +++ b/include/acpi/acnames.h
> @@ -51,6 +51,7 @@
>  #define METHOD_NAME__BBN        "_BBN"
>  #define METHOD_NAME__CBA        "_CBA"
>  #define METHOD_NAME__CID        "_CID"
> +#define METHOD_NAME__CLS        "_CLS"
>  #define METHOD_NAME__CRS        "_CRS"
>  #define METHOD_NAME__DDN        "_DDN"
>  #define METHOD_NAME__HID        "_HID"
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 87f365e..2f2b8ce 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -432,6 +432,10 @@ const struct acpi_device_id *acpi_match_device(const struct acpi_device_id *ids,
>  
>  extern bool acpi_driver_match_device(struct device *dev,
>  				     const struct device_driver *drv);
> +
> +bool acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
> +			   const struct device *dev);
> +
>  int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
>  int acpi_device_modalias(struct device *, char *, int);
>  void acpi_walk_dep_device_list(acpi_handle handle);
> @@ -527,6 +531,12 @@ static inline const struct acpi_device_id *acpi_match_device(
>  	return NULL;
>  }
>  
> +static inline bool acpi_match_device_cls(const struct acpi_device_cls *dev_cls,
> +					 const struct device *dev)
> +{
> +	return false;
> +}
> +
>  static inline bool acpi_driver_match_device(struct device *dev,
>  					    const struct device_driver *drv)
>  {
> diff --git a/include/linux/device.h b/include/linux/device.h
> index fb50673..8e259c5c 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -237,6 +237,7 @@ struct device_driver {
>  
>  	const struct of_device_id	*of_match_table;
>  	const struct acpi_device_id	*acpi_match_table;
> +	const struct acpi_device_cls	*acpi_match_cls;
>  
>  	int (*probe) (struct device *dev);
>  	int (*remove) (struct device *dev);
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 745def8..00e94ec 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -186,6 +186,12 @@ struct css_device_id {
>  
>  #define ACPI_ID_LEN	9
>  
> +struct acpi_device_cls {
> +	kernel_ulong_t base_class;
> +	kernel_ulong_t sub_class;
> +	kernel_ulong_t prog_interface;
> +};
> +

Move that below the struct acpi_device_id definition.

>  struct acpi_device_id {
>  	__u8 id[ACPI_ID_LEN];
>  	kernel_ulong_t driver_data;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
