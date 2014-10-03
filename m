Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaJCNnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:43:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64376 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbaJCNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:43:08 -0400
Date: Fri, 3 Oct 2014 14:43:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 03/15] ACPI: Allow drivers to match using Device Tree
 compatible property
Message-ID: <20141003134303.GK26643@leverpostej>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1852462.V1jlbi8OPt@vostro.rjw.lan>
 <3582127.hCPY12ZqpT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3582127.hCPY12ZqpT@vostro.rjw.lan>
Thread-Topic: [PATCH v3 03/15] ACPI: Allow drivers to match using Device Tree
 compatible property
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, Oct 01, 2014 at 03:10:40AM +0100, Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> We have lots of existing Device Tree enabled drivers and allocating
> separate _HID for each is not feasible. Instead we allocate special
> _HID "PRP0001" that means that the match should be done using Device
> Tree compatible property using driver's .of_match_table instead.

That's hopefully not the precise meaning of "PRP0001" unless we're
attempting no semblance of OS independence here?

I'm still of the opinion that marrying ACPI to existing (and often
ill-defined) DT bindings is a bad idea. While it's expedient, I believe
this is going to be a long-term maintenance nightmare.

I'm very concerned with the prospect of model mismatch between the two
(e.g. DT clocks properties where ACPI has traditionally been in charge
of clock management). I've not seen any high-level guidelines w.r.t.
what should live in _DSD properties and what should not (at least not in
the ACPI spec itself). There are almost certainly properties that only
make sense if !ACPI, and likely there will be some that only make sense
if ACPI.

So I think that in its current level of standardisation, _DSD only makes
sense for simple device properties, and not relationships between
devices, except where ACPI already has some kind of a model (which
currently seems to cover interrupts and GPIOs). I'd also hope that we
could expose a 'clean' subset of DT bidnings (i.e. those which aren't
known to be kept around only for compatibility with legacy DTBs).

I do not believe it makes sense to share such a low-level interface.
Given the aforementioned model differences, and the fact that we don't
need to support _every_ device tree binding, I don't see why this can't
be handled with separate probe paths in the drivers we care about (as we
already do for DT vs platform data).

Mark.

> If there is a need to distinguish from where the device is enumerated
> (DT/ACPI) driver can check dev->of_node or ACPI_COMPATION(dev).
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/property.c |   34 +++++++++++++++++
>  drivers/acpi/scan.c     |   91 ++++++++++++++++++++++++++++++++++++++++++------
>  include/acpi/acpi_bus.h |    1 
>  include/linux/acpi.h    |    8 +---
>  4 files changed, 118 insertions(+), 16 deletions(-)
> 
> Index: linux-pm/drivers/acpi/property.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/property.c
> +++ linux-pm/drivers/acpi/property.c
> @@ -76,6 +76,37 @@ static bool acpi_properties_format_valid
>  	return true;
>  }
>  
> +static void acpi_init_of_compatible(struct acpi_device *adev)
> +{
> +	const union acpi_object *of_compatible;
> +	struct acpi_hardware_id *hwid;
> +	bool acpi_of = false;
> +
> +	/*
> +	 * Check if the special PRP0001 ACPI ID is present and in that
> +	 * case we fill in Device Tree compatible properties for this
> +	 * device.
> +	 */
> +	list_for_each_entry(hwid, &adev->pnp.ids, list) {
> +		if (!strcmp(hwid->id, "PRP0001")) {
> +			acpi_of = true;
> +			break;
> +		}
> +	}
> +
> +	if (!acpi_of)
> +		return;
> +
> +	if (acpi_dev_get_property_array(adev, "compatible", ACPI_TYPE_STRING,
> +					&of_compatible)) {
> +		acpi_handle_warn(adev->handle,
> +				 "PRP0001 requires compatible property\n");
> +		return;
> +	}
> +
> +	adev->data.of_compatible = of_compatible;
> +}
> +
>  void acpi_init_properties(struct acpi_device *adev)
>  {
>  	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
> @@ -119,6 +150,8 @@ void acpi_init_properties(struct acpi_de
>  
>  		adev->data.pointer = buf.pointer;
>  		adev->data.properties = properties;
> +
> +		acpi_init_of_compatible(adev);
>  		return;
>  	}
>  
> @@ -130,6 +163,7 @@ void acpi_init_properties(struct acpi_de
>  void acpi_free_properties(struct acpi_device *adev)
>  {
>  	ACPI_FREE((void *)adev->data.pointer);
> +	adev->data.of_compatible = NULL;
>  	adev->data.pointer = NULL;
>  	adev->data.properties = NULL;
>  }
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -124,17 +124,43 @@ static int create_modalias(struct acpi_d
>  	if (list_empty(&acpi_dev->pnp.ids))
>  		return 0;
>  
> -	len = snprintf(modalias, size, "acpi:");
> -	size -= len;
> +	/*
> +	 * If the device has PRP0001 we expose DT compatible modalias
> +	 * instead.
> +	 */
> +	if (acpi_dev->data.of_compatible) {
> +		const union acpi_object *of_compatible, *obj;
> +		int i;
> +
> +		len = snprintf(modalias, size, "of:Nprp0001Tacpi");
> +
> +		of_compatible = acpi_dev->data.of_compatible;
> +		for (i = 0; i < of_compatible->package.count; i++) {
> +			obj = &of_compatible->package.elements[i];
> +
> +			count = snprintf(&modalias[len], size, "C%s",
> +					 obj->string.pointer);
> +			if (count < 0)
> +				return -EINVAL;
> +			if (count >= size)
> +				return -ENOMEM;
> +
> +			len += count;
> +			size -= count;
> +		}
> +	} else {
> +		len = snprintf(modalias, size, "acpi:");
> +		size -= len;
>  
> -	list_for_each_entry(id, &acpi_dev->pnp.ids, list) {
> -		count = snprintf(&modalias[len], size, "%s:", id->id);
> -		if (count < 0)
> -			return -EINVAL;
> -		if (count >= size)
> -			return -ENOMEM;
> -		len += count;
> -		size -= count;
> +		list_for_each_entry(id, &acpi_dev->pnp.ids, list) {
> +			count = snprintf(&modalias[len], size, "%s:", id->id);
> +			if (count < 0)
> +				return -EINVAL;
> +			if (count >= size)
> +				return -ENOMEM;
> +			len += count;
> +			size -= count;
> +		}
>  	}
>  
>  	modalias[len] = '\0';
> @@ -864,6 +890,51 @@ int acpi_match_device_ids(struct acpi_de
>  }
>  EXPORT_SYMBOL(acpi_match_device_ids);
>  
> +/* Performs match for special "PRP0001" shoehorn ACPI ID */
> +static bool acpi_of_driver_match_device(struct device *dev,
> +					const struct device_driver *drv)
> +{
> +	struct acpi_device *adev = ACPI_COMPANION(dev);
> +	const union acpi_object *of_compatible;
> +	int i;
> +
> +	/*
> +	 * If the ACPI device does not have corresponding compatible
> +	 * property or the driver in question does not have DT matching
> +	 * table we consider the match succesful (matches the ACPI ID).
> +	 */
> +	of_compatible = adev->data.of_compatible;
> +	if (!drv->of_match_table || !of_compatible)
> +		return true;
> +
> +	/* Now we can look for the driver DT compatible strings */
> +	for (i = 0; i < of_compatible->package.count; i++) {
> +		const struct of_device_id *id;
> +		const union acpi_object *obj;
> +
> +		obj = &of_compatible->package.elements[i];
> +
> +		for (id = drv->of_match_table; id->compatible[0]; id++)
> +			if (!strcasecmp(obj->string.pointer, id->compatible))
> +				return true;
> +	}
> +
> +	return false;
> +}
> +
> +bool acpi_driver_match_device(struct device *dev,
> +			      const struct device_driver *drv)
> +{
> +	const struct acpi_device_id *id;
> +
> +	id = acpi_match_device(drv->acpi_match_table, dev);
> +	if (!id)
> +		return false;
> +
> +	return acpi_of_driver_match_device(dev, drv);
> +}
> +EXPORT_SYMBOL_GPL(acpi_driver_match_device);
> +
>  static void acpi_free_power_resources_lists(struct acpi_device *device)
>  {
>  	int i;
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -341,6 +341,7 @@ struct acpi_device_physical_node {
>  struct acpi_device_data {
>  	const union acpi_object *pointer;
>  	const union acpi_object *properties;
> +	const union acpi_object *of_compatible;
>  };
>  
>  /* Device */
> Index: linux-pm/include/linux/acpi.h
> ===================================================================
> --- linux-pm.orig/include/linux/acpi.h
> +++ linux-pm/include/linux/acpi.h
> @@ -424,12 +424,8 @@ extern int acpi_nvs_for_each_region(int
>  const struct acpi_device_id *acpi_match_device(const struct acpi_device_id *ids,
>  					       const struct device *dev);
>  
> -static inline bool acpi_driver_match_device(struct device *dev,
> -					    const struct device_driver *drv)
> -{
> -	return !!acpi_match_device(drv->acpi_match_table, dev);
> -}
> -
> +extern bool acpi_driver_match_device(struct device *dev,
> +				     const struct device_driver *drv);
>  int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
>  int acpi_device_modalias(struct device *, char *, int);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
