Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbbAMJhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:37:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:8650 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbbAMJha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,748,1413270000"; 
   d="scan'208";a="650316787"
Date: Tue, 13 Jan 2015 11:37:24 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd.bergmann@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] driver core: property: support for generic property
Message-ID: <20150113093724.GA1856@kuha.fi.intel.com>
References: <1421061344-195095-1-git-send-email-heikki.krogerus@linux.intel.com>
 <3315410.c1hB71JUOk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3315410.c1hB71JUOk@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 10:35:09AM +0100, Rafael J. Wysocki wrote:
> On Monday, January 12, 2015 01:15:44 PM Heikki Krogerus wrote:
> > This extends the Unified Property Interface by adding
> > "Generic Property" to it for cases where device tree or ACPI
> > are not being used.
> > 
> > That makes the Unified Property Interface cover most of the
> > cases where information is extracted from custom
> > platform_data in the drivers, i.e. removing also the need
> > for them to handle custom platform data separately.
> 
> I'm not sure I understand that correctly.  Do you mean that it is possible to
> reduce code duplication between drivers this way?

I wan't to replace platform_data with unified device properties. So I
wan't to replace this kind of code in the drivers:

        if (pdata)
                val = pdata->val;
        else
                device_property_read_u32(dev, "magic", &val);

With just:

        device_property_read_u32(dev, "magic", &val);

> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > ---
> >  drivers/base/property.c  | 188 +++++++++++++++++++++++++++++++++++++++++------
> >  include/linux/device.h   |   2 +
> >  include/linux/property.h |  13 ++++
> >  3 files changed, 182 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/base/property.c b/drivers/base/property.c
> > index c458458..99990e2 100644
> > --- a/drivers/base/property.c
> > +++ b/drivers/base/property.c
> > @@ -15,6 +15,129 @@
> >  #include <linux/acpi.h>
> >  #include <linux/of.h>
> >  
> > +static struct dev_gen_prop *dev_prop_get(struct device *dev, const char *name)
> > +{
> > +	struct dev_gen_prop *prop;
> > +
> > +	if (!dev->gen_prop)
> > +		return NULL;
> > +
> > +	for (prop = dev->gen_prop; prop->name; prop++)
> > +		if (!strcmp(name, prop->name))
> > +			return prop;
> > +	return NULL;
> > +}
> > +
> > +static int dev_prop_copy_array_u8(const char **src, u8 *val, size_t nval)
> > +{
> > +	int ret;
> > +	int i;
> > +
> > +	for (i = 0; i < nval; i++) {
> > +		if (!src[i])
> > +			return -EOVERFLOW;
> > +		ret = kstrtou8(src[i], 0, &val[i]);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int dev_prop_copy_array_u16(const char **src, u16 *val, size_t nval)
> > +{
> > +	int ret;
> > +	int i;
> > +
> > +	for (i = 0; i < nval; i++) {
> > +		if (!src[i])
> > +			return -EOVERFLOW;
> > +		ret = kstrtou16(src[i], 0, &val[i]);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int dev_prop_copy_array_u32(const char **src, u32 *val, size_t nval)
> > +{
> > +	int ret;
> > +	int i;
> > +
> > +	for (i = 0; i < nval; i++) {
> > +		if (!src[i])
> > +			return -EOVERFLOW;
> > +		ret = kstrtou32(src[i], 0, &val[i]);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int dev_prop_copy_array_u64(const char **src, u64 *val, size_t nval)
> > +{
> > +	int ret;
> > +	int i;
> > +
> > +	for (i = 0; i < nval; i++) {
> > +		if (!src[i])
> > +			return -EOVERFLOW;
> > +		ret = kstrtou64(src[i], 0, &val[i]);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int dev_prop_copy_array_string(const char **src, const char **val,
> > +				      size_t nval)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < nval; i++) {
> > +		if (!src[i])
> > +			return -EOVERFLOW;
> > +		val[i] = src[i];
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int dev_prop_read_array(struct device *dev, const char *name,
> > +			       enum dev_prop_type type, void *val, size_t nval)
> > +{
> > +	struct dev_gen_prop *prop;
> > +	int ret = 0;
> > +
> > +	prop = dev_prop_get(dev, name);
> > +	if (!prop)
> > +		return -ENODATA;
> > +
> > +	if (prop->type != type)
> > +		return -EPROTO;
> > +
> > +	switch (prop->type) {
> > +	case DEV_PROP_U8:
> > +		ret = dev_prop_copy_array_u8(prop->val, (u8 *)val, nval);
> > +		break;
> > +	case DEV_PROP_U16:
> > +		ret = dev_prop_copy_array_u16(prop->val, (u16 *)val, nval);
> > +		break;
> > +	case DEV_PROP_U32:
> > +		ret = dev_prop_copy_array_u32(prop->val, (u32 *)val, nval);
> > +		break;
> > +	case DEV_PROP_U64:
> > +		ret = dev_prop_copy_array_u64(prop->val, (u64 *)val, nval);
> > +		break;
> > +	case DEV_PROP_STRING:
> > +		ret = dev_prop_copy_array_string(prop->val, (const char **)val,
> > +						 nval);
> > +		break;
> > +	default:
> > +		ret = -EINVAL;
> > +		break;
> > +	}
> > +	return ret;
> > +}
> > +
> >  /**
> >   * device_property_present - check if a property of a device is present
> >   * @dev: Device whose property is being checked
> > @@ -26,8 +149,9 @@ bool device_property_present(struct device *dev, const char *propname)
> >  {
> >  	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> >  		return of_property_read_bool(dev->of_node, propname);
> > -
> > -	return !acpi_dev_prop_get(ACPI_COMPANION(dev), propname, NULL);
> > +	if (ACPI_HANDLE(dev))
> > +		return !acpi_dev_prop_get(ACPI_COMPANION(dev), propname, NULL);
> > +	return !!dev_prop_get(dev, propname);
> >  }
> >  EXPORT_SYMBOL_GPL(device_property_present);
> >  
> > @@ -51,13 +175,6 @@ EXPORT_SYMBOL_GPL(fwnode_property_present);
> >  	(val) ? of_property_read_##type##_array((node), (propname), (val), (nval)) \
> >  	      : of_property_count_elems_of_size((node), (propname), sizeof(type))
> >  
> > -#define DEV_PROP_READ_ARRAY(_dev_, _propname_, _type_, _proptype_, _val_, _nval_) \
> > -	IS_ENABLED(CONFIG_OF) && _dev_->of_node ? \
> > -		(OF_DEV_PROP_READ_ARRAY(_dev_->of_node, _propname_, _type_, \
> > -					_val_, _nval_)) : \
> > -		acpi_dev_prop_read(ACPI_COMPANION(_dev_), _propname_, \
> > -				   _proptype_, _val_, _nval_)
> > -
> 
> The macro was used here for a reason.  Can't you replace it with an extended
> macro instead?
> 
> >  /**
> >   * device_property_read_u8_array - return a u8 array property of a device
> >   * @dev: Device to get the property of
> > @@ -77,7 +194,13 @@ EXPORT_SYMBOL_GPL(fwnode_property_present);
> >  int device_property_read_u8_array(struct device *dev, const char *propname,
> >  				  u8 *val, size_t nval)
> >  {
> > -	return DEV_PROP_READ_ARRAY(dev, propname, u8, DEV_PROP_U8, val, nval);
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > +		return OF_DEV_PROP_READ_ARRAY(dev->of_node, propname, u8,
> > +					      val, nval);
> > +	if (ACPI_HANDLE(dev))
> > +		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > +					  DEV_PROP_U8, val, nval);
> > +	return dev_prop_read_array(dev, propname, DEV_PROP_U8, val, nval);
> >  }
> >  EXPORT_SYMBOL_GPL(device_property_read_u8_array);
> >  
> > @@ -100,7 +223,13 @@ EXPORT_SYMBOL_GPL(device_property_read_u8_array);
> >  int device_property_read_u16_array(struct device *dev, const char *propname,
> >  				   u16 *val, size_t nval)
> >  {
> > -	return DEV_PROP_READ_ARRAY(dev, propname, u16, DEV_PROP_U16, val, nval);
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > +		return OF_DEV_PROP_READ_ARRAY(dev->of_node, propname, u16, val,
> > +					      nval);
> > +	if (ACPI_HANDLE(dev))
> > +		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > +					  DEV_PROP_U16, val, nval);
> > +	return dev_prop_read_array(dev, propname, DEV_PROP_U16, val, nval);
> >  }
> >  EXPORT_SYMBOL_GPL(device_property_read_u16_array);
> >  
> > @@ -123,7 +252,13 @@ EXPORT_SYMBOL_GPL(device_property_read_u16_array);
> >  int device_property_read_u32_array(struct device *dev, const char *propname,
> >  				   u32 *val, size_t nval)
> >  {
> > -	return DEV_PROP_READ_ARRAY(dev, propname, u32, DEV_PROP_U32, val, nval);
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > +		return OF_DEV_PROP_READ_ARRAY(dev->of_node, propname, u32, val,
> > +					      nval);
> > +	if (ACPI_HANDLE(dev))
> > +		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > +					  DEV_PROP_U32, val, nval);
> > +	return dev_prop_read_array(dev, propname, DEV_PROP_U32, val, nval);
> >  }
> >  EXPORT_SYMBOL_GPL(device_property_read_u32_array);
> >  
> > @@ -146,7 +281,13 @@ EXPORT_SYMBOL_GPL(device_property_read_u32_array);
> >  int device_property_read_u64_array(struct device *dev, const char *propname,
> >  				   u64 *val, size_t nval)
> >  {
> > -	return DEV_PROP_READ_ARRAY(dev, propname, u64, DEV_PROP_U64, val, nval);
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > +		return OF_DEV_PROP_READ_ARRAY(dev->of_node, propname, u64, val,
> > +					      nval);
> > +	if (ACPI_HANDLE(dev))
> > +		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > +					  DEV_PROP_U64, val, nval);
> > +	return dev_prop_read_array(dev, propname, DEV_PROP_U64, val, nval);
> >  }
> >  EXPORT_SYMBOL_GPL(device_property_read_u64_array);
> >  
> > @@ -169,10 +310,13 @@ EXPORT_SYMBOL_GPL(device_property_read_u64_array);
> >  int device_property_read_string_array(struct device *dev, const char *propname,
> >  				      const char **val, size_t nval)
> >  {
> > -	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
> > -		of_property_read_string_array(dev->of_node, propname, val, nval) :
> > -		acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > -				   DEV_PROP_STRING, val, nval);
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > +		return of_property_read_string_array(dev->of_node, propname,
> > +						     val, nval);
> > +	if (ACPI_HANDLE(dev))
> > +		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > +					  DEV_PROP_STRING, val, nval);
> > +	return dev_prop_read_array(dev, propname, DEV_PROP_STRING, val, nval);
> >  }
> >  EXPORT_SYMBOL_GPL(device_property_read_string_array);
> >  
> > @@ -193,10 +337,12 @@ EXPORT_SYMBOL_GPL(device_property_read_string_array);
> >  int device_property_read_string(struct device *dev, const char *propname,
> >  				const char **val)
> >  {
> > -	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
> > -		of_property_read_string(dev->of_node, propname, val) :
> > -		acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > -				   DEV_PROP_STRING, val, 1);
> > +	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> > +		return of_property_read_string(dev->of_node, propname, val);
> > +	if (ACPI_HANDLE(dev))
> > +		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > +					  DEV_PROP_STRING, val, 1);
> > +	return dev_prop_read_array(dev, propname, DEV_PROP_STRING, val, 1);
> >  }
> >  EXPORT_SYMBOL_GPL(device_property_read_string);
> >  
> > diff --git a/include/linux/device.h b/include/linux/device.h
> > index fb50673..bd1e292 100644
> > --- a/include/linux/device.h
> > +++ b/include/linux/device.h
> > @@ -27,6 +27,7 @@
> >  #include <linux/ratelimit.h>
> >  #include <linux/uidgid.h>
> >  #include <linux/gfp.h>
> > +#include <linux/property.h>
> >  #include <asm/device.h>
> >  
> >  struct device;
> > @@ -780,6 +781,7 @@ struct device {
> >  
> >  	struct device_node	*of_node; /* associated device tree node */
> >  	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
> > +	struct dev_gen_prop	*gen_prop;
> >  
> >  	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
> >  	u32			id;	/* device instance */
> > diff --git a/include/linux/property.h b/include/linux/property.h
> > index a6a3d98..6ac8e508 100644
> > --- a/include/linux/property.h
> > +++ b/include/linux/property.h
> > @@ -26,6 +26,19 @@ enum dev_prop_type {
> >  	DEV_PROP_MAX,
> >  };
> >  
> > +/**
> > + * struct dev_gen_prop - Generic Device Property
> > + * @name: property name
> > + * @val: value array
> > + *
> > + * Used when of_node and acpi_node are missing.
> > + */
> > +struct dev_gen_prop {
> > +	enum dev_prop_type type;
> > +	const char *name;
> > +	const char **val;
> > +};
> > +
> >  bool device_property_present(struct device *dev, const char *propname);
> >  int device_property_read_u8_array(struct device *dev, const char *propname,
> >  				  u8 *val, size_t nval);
> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

-- 
heikki
