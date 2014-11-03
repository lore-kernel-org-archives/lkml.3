Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaKCPkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:40:32 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56216 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaKCPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <2127128.VT1Iq03xz1@vostro.rjw.lan>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan> <2127128.VT1Iq03xz1@vostro.rjw.lan>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 3 Nov 2014 15:40:08 +0000
X-Google-Sender-Auth: pCvhsuWokywiePdQH1Kw6H6jHJE
Message-ID: <CACxGe6tvz8MiXnNGJ3XtrofxFr=o87yOB6kUKm57fXvQ0fL8jw@mail.gmail.com>
Subject: Re: [PATCH v6 02/12] Driver core: Unified device properties interface
 for platform firmware
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

While reviewing and testing these patches I ran into serious bugs in
the string parsers (in both the existing code and the new functions
here). It took me a number of days, but I've got a fix now which I'll
be posting shortly and I want to get into mainline right away. I'll cc
you when I post it.

The fix will conflict with this patch. Mostly as a side effect of the
fix, the of_property_*string* function changes will no longer be
needed in this patch. It will either need to be respun, or we'll need
to give Linus some guidance on resolving the conflicts when merging.

Other comments below...

On Tue, Oct 21, 2014 at 10:15 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>
> Add a uniform interface by which device drivers can request device
> properties from the platform firmware by providing a property name
> and the corresponding data type.  The purpose of it is to help to
> write portable code that won't depend on any particular platform
> firmware interface.
>
> The following general helper functions are added:
[...]
> +/**
> + * device_property_read_u8_array - return a u8 array property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The values are stored here
> + * @nval: Size of the @val array
> + *
> + * Function reads an array of u8 properties with @propname from the device
> + * firmware description and stores them to @val if found.
> + *
> + * Return: %0 if the property was found (success),
> + *        %-EINVAL if given arguments are not valid,
> + *        %-ENODATA if the property does not have a value,
> + *        %-EPROTO if the property is not an array of numbers,
> + *        %-EOVERFLOW if the size of the property is not as expected.
> + */
> +int device_property_read_u8_array(struct device *dev, const char *propname,
> +                                 u8 *val, size_t nval)
> +{
> +       return DEV_PROP_READ_ARRAY(dev, propname, u8, DEV_PROP_U8, val, nval);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u8_array);

Yup, I'm a lot happier with this approach. :-)

> +
> +/**
> + * device_property_read_u16_array - return a u16 array property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The values are stored here
> + * @nval: Size of the @val array
> + *
> + * Function reads an array of u16 properties with @propname from the device
> + * firmware description and stores them to @val if found.
> + *
> + * Return: %0 if the property was found (success),
> + *        %-EINVAL if given arguments are not valid,
> + *        %-ENODATA if the property does not have a value,
> + *        %-EPROTO if the property is not an array of numbers,
> + *        %-EOVERFLOW if the size of the property is not as expected.
> + */
> +int device_property_read_u16_array(struct device *dev, const char *propname,
> +                                  u16 *val, size_t nval)
> +{
> +       return DEV_PROP_READ_ARRAY(dev, propname, u16, DEV_PROP_U16, val, nval);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u16_array);
> +
> +/**
> + * device_property_read_u32_array - return a u32 array property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The values are stored here
> + * @nval: Size of the @val array
> + *
> + * Function reads an array of u32 properties with @propname from the device
> + * firmware description and stores them to @val if found.
> + *
> + * Return: %0 if the property was found (success),
> + *        %-EINVAL if given arguments are not valid,
> + *        %-ENODATA if the property does not have a value,
> + *        %-EPROTO if the property is not an array of numbers,
> + *        %-EOVERFLOW if the size of the property is not as expected.
> + */
> +int device_property_read_u32_array(struct device *dev, const char *propname,
> +                                  u32 *val, size_t nval)
> +{
> +       return DEV_PROP_READ_ARRAY(dev, propname, u32, DEV_PROP_U32, val, nval);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u32_array);
> +
> +/**
> + * device_property_read_u64_array - return a u64 array property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The values are stored here
> + * @nval: Size of the @val array
> + *
> + * Function reads an array of u64 properties with @propname from the device
> + * firmware description and stores them to @val if found.
> + *
> + * Return: %0 if the property was found (success),
> + *        %-EINVAL if given arguments are not valid,
> + *        %-ENODATA if the property does not have a value,
> + *        %-EPROTO if the property is not an array of numbers,
> + *        %-EOVERFLOW if the size of the property is not as expected.
> + */
> +int device_property_read_u64_array(struct device *dev, const char *propname,
> +                                  u64 *val, size_t nval)
> +{
> +       return DEV_PROP_READ_ARRAY(dev, propname, u64, DEV_PROP_U64, val, nval);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u64_array);
> +
> +/**
> + * device_property_read_string_array - return a string array property of device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The values are stored here
> + * @nval: Size of the @val array
> + *
> + * Function reads an array of string properties with @propname from the device
> + * firmware description and stores them to @val if found.
> + *
> + * Return: %0 if the property was found (success),
> + *        %-EINVAL if given arguments are not valid,
> + *        %-ENODATA if the property does not have a value,
> + *        %-EPROTO or %-EILSEQ if the property is not an array of strings,
> + *        %-EOVERFLOW if the size of the property is not as expected.
> + */
> +int device_property_read_string_array(struct device *dev, const char *propname,
> +                                     char **val, size_t nval)
> +{
> +       return IS_ENABLED(CONFIG_OF) && dev->of_node ?
> +               of_property_read_string_array(dev->of_node, propname, val, nval) :
> +               acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> +                                  DEV_PROP_STRING, val, nval);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_string_array);
> +
> +/**
> + * device_property_read_u8 - return a u8 property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The value is stored here
> + */
> +int device_property_read_u8(struct device *dev, const char *propname, u8 *val)
> +{
> +       return device_property_read_u8_array(dev, propname, val, 1);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u8);
> +
> +/**
> + * device_property_read_u16 - return a u16 property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The value is stored here
> + */
> +int device_property_read_u16(struct device *dev, const char *propname, u16 *val)
> +{
> +       return device_property_read_u16_array(dev, propname, val, 1);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u16);
> +
> +/**
> + * device_property_read_u32 - return a u32 property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The value is stored here
> + */
> +int device_property_read_u32(struct device *dev, const char *propname, u32 *val)
> +{
> +       return device_property_read_u32_array(dev, propname, val, 1);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u32);
> +
> +/**
> + * device_property_read_u64 - return a u64 property of a device
> + * @dev: Device to get the property of
> + * @propname: Name of the property
> + * @val: The value is stored here
> + */
> +int device_property_read_u64(struct device *dev, const char *propname, u64 *val)
> +{
> +       return device_property_read_u64_array(dev, propname, val, 1);
> +}
> +EXPORT_SYMBOL_GPL(device_property_read_u64);

Instead of exporting, can these be static inline wrappers in the header file?

> ===================================================================
> --- linux-pm.orig/drivers/of/base.c
> +++ linux-pm/drivers/of/base.c
> @@ -1250,6 +1250,39 @@ int of_property_read_u64(const struct de
>  EXPORT_SYMBOL_GPL(of_property_read_u64);
>
>  /**
> + * of_property_read_u64_array - Find and read an array of 64 bit integers
> + * from a property.
> + *
> + * @np:                device node from which the property value is to be read.
> + * @propname:  name of the property to be searched.
> + * @out_values:        pointer to return value, modified only if return value is 0.
> + * @sz:                number of array elements to read
> + *
> + * Search for a property in a device node and read 64-bit value(s) from
> + * it. Returns 0 on success, -EINVAL if the property does not exist,
> + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> + * property data isn't large enough.
> + *
> + * The out_values is modified only if a valid u64 value can be decoded.
> + */
> +int of_property_read_u64_array(const struct device_node *np,
> +                              const char *propname, u64 *out_values,
> +                              size_t sz)
> +{
> +       const __be32 *val = of_find_property_value_of_size(np, propname,
> +                                               (sz * sizeof(*out_values)));
> +
> +       if (IS_ERR(val))
> +               return PTR_ERR(val);
> +
> +       while (sz--) {
> +               *out_values++ = of_read_number(val, 2);
> +               val += 2;
> +       }
> +       return 0;
> +}
> +
> +/**
>   * of_property_read_string - Find and read a string from a property
>   * @np:                device node from which the property value is to be read.
>   * @propname:  name of the property to be searched.
> @@ -1362,24 +1395,11 @@ int of_property_match_string(struct devi
>  }
>  EXPORT_SYMBOL_GPL(of_property_match_string);
>
> -/**
> - * of_property_count_strings - Find and return the number of strings from a
> - * multiple strings property.
> - * @np:                device node from which the property value is to be read.
> - * @propname:  name of the property to be searched.
> - *
> - * Search for a property in a device tree node and retrieve the number of null
> - * terminated string contain in it. Returns the number of strings on
> - * success, -EINVAL if the property does not exist, -ENODATA if property
> - * does not have a value, and -EILSEQ if the string is not null-terminated
> - * within the length of the property data.
> - */
> -int of_property_count_strings(struct device_node *np, const char *propname)
> +static int property_count_strings(struct property *prop)
>  {
> -       struct property *prop = of_find_property(np, propname, NULL);
> -       int i = 0;
> -       size_t l = 0, total = 0;
>         const char *p;
> +       size_t l = 0, total = 0;
> +       int i = 0;
>
>         if (!prop)
>                 return -EINVAL;
> @@ -1395,8 +1415,62 @@ int of_property_count_strings(struct dev
>
>         return i;
>  }
> +
> +/**
> + * of_property_count_strings - Find and return the number of strings from a
> + * multiple strings property.
> + * @np:                device node from which the property value is to be read.
> + * @propname:  name of the property to be searched.
> + *
> + * Search for a property in a device tree node and retrieve the number of null
> + * terminated string contain in it. Returns the number of strings on
> + * success, -EINVAL if the property does not exist, -ENODATA if property
> + * does not have a value, and -EILSEQ if the string is not null-terminated
> + * within the length of the property data.
> + */
> +int of_property_count_strings(struct device_node *np, const char *propname)
> +{
> +       return property_count_strings(of_find_property(np, propname, NULL));
> +}
>  EXPORT_SYMBOL_GPL(of_property_count_strings);
>
> +/**
> + * of_property_read_string_array - Read an array of strings from a multiple
> + * strings property.
> + * @np:                device node from which the property value is to be read.
> + * @propname:  name of the property to be searched.
> + * @out_strs:  output array of string pointers.
> + * @sz:                number of array elements to read.
> + *
> + * Search for a property in a device tree node and retrieve a list of
> + * terminated string values (pointer to data, not a copy) in that property.
> + *
> + * If @out_strs is NULL, the number of strings in the property is returned.
> + */
> +int of_property_read_string_array(struct device_node *np, const char *propname,
> +                                 char **out_strs, size_t sz)

should be const char **out_strs. All the other string parsers use const char

> +{
> +       struct property *prop = of_find_property(np, propname, NULL);
> +       char *p = prop->value;
> +       size_t total = 0;
> +       int i;
> +
> +       i = property_count_strings(prop);
> +       if (!out_strs || i < 0)
> +               return i;
> +
> +       if (i < sz)
> +               return -EOVERFLOW;
> +
> +       while (total < prop->length && i < sz) {
> +               size_t l = strlen(p) + 1;
> +
> +               out_strs[i++] = p;
> +               total += l;
> +               p += l;
> +       }
> +}
> +

drivers/of/base.c: In function 'of_property_read_string_array':
drivers/of/base.c:1481:1: warning: control reaches end of non-void
function [-Wreturn-type]

I also found that this parser code doesn't correctly handle malformed
(unterminated) string properties. It will overflow. The existing
functions have the same problem, so it isn't something that you've
added. I've got a fix, and as a side effect the fix creates the _array
version basically for free as part of reworking
of_property_count_strings() and of_property_read_string_index()

g.

>  void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
>  {
>         int i;
> Index: linux-pm/drivers/acpi/property.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/property.c
> +++ linux-pm/drivers/acpi/property.c
> @@ -362,3 +362,181 @@ int acpi_dev_get_property_reference(stru
>         return -EPROTO;
>  }
>  EXPORT_SYMBOL_GPL(acpi_dev_get_property_reference);
> +
> +int acpi_dev_prop_get(struct acpi_device *adev, const char *propname,
> +                     void **valptr)
> +{
> +       return acpi_dev_get_property(adev, propname, ACPI_TYPE_ANY,
> +                                    (const union acpi_object **)valptr);
> +}
> +
> +int acpi_dev_prop_read_single(struct acpi_device *adev, const char *propname,
> +                             enum dev_prop_type proptype, void *val)
> +{
> +       const union acpi_object *obj;
> +       int ret;
> +
> +       if (!val)
> +               return -EINVAL;
> +
> +       if (proptype >= DEV_PROP_U8 && proptype <= DEV_PROP_U64) {
> +               ret = acpi_dev_get_property(adev, propname, ACPI_TYPE_INTEGER, &obj);
> +               if (ret)
> +                       return ret;
> +
> +               switch (proptype) {
> +               case DEV_PROP_U8:
> +                       if (obj->integer.value > U8_MAX)
> +                               return -EOVERFLOW;
> +                       *(u8 *)val = obj->integer.value;
> +                       break;
> +               case DEV_PROP_U16:
> +                       if (obj->integer.value > U16_MAX)
> +                               return -EOVERFLOW;
> +                       *(u16 *)val = obj->integer.value;
> +                       break;
> +               case DEV_PROP_U32:
> +                       if (obj->integer.value > U32_MAX)
> +                               return -EOVERFLOW;
> +                       *(u32 *)val = obj->integer.value;
> +                       break;
> +               default:
> +                       *(u64 *)val = obj->integer.value;
> +                       break;
> +               }
> +       } else if (proptype == DEV_PROP_STRING) {
> +               ret = acpi_dev_get_property(adev, propname, ACPI_TYPE_STRING, &obj);
> +               if (ret)
> +                       return ret;
> +
> +               *(char **)val = obj->string.pointer;
> +       } else {
> +               ret = -EINVAL;
> +       }
> +       return ret;
> +}
> +
> +static int acpi_copy_property_array_u8(const union acpi_object *items, u8 *val,
> +                                      size_t nval)
> +{
> +       int i;
> +
> +       for (i = 0; i < nval; i++) {
> +               if (items[i].type != ACPI_TYPE_INTEGER)
> +                       return -EPROTO;
> +               if (items[i].integer.value > U8_MAX)
> +                       return -EOVERFLOW;
> +
> +               val[i] = items[i].integer.value;
> +       }
> +       return 0;
> +}
> +
> +static int acpi_copy_property_array_u16(const union acpi_object *items,
> +                                       u16 *val, size_t nval)
> +{
> +       int i;
> +
> +       for (i = 0; i < nval; i++) {
> +               if (items[i].type != ACPI_TYPE_INTEGER)
> +                       return -EPROTO;
> +               if (items[i].integer.value > U16_MAX)
> +                       return -EOVERFLOW;
> +
> +               val[i] = items[i].integer.value;
> +       }
> +       return 0;
> +}
> +
> +static int acpi_copy_property_array_u32(const union acpi_object *items,
> +                                       u32 *val, size_t nval)
> +{
> +       int i;
> +
> +       for (i = 0; i < nval; i++) {
> +               if (items[i].type != ACPI_TYPE_INTEGER)
> +                       return -EPROTO;
> +               if (items[i].integer.value > U32_MAX)
> +                       return -EOVERFLOW;
> +
> +               val[i] = items[i].integer.value;
> +       }
> +       return 0;
> +}
> +
> +static int acpi_copy_property_array_u64(const union acpi_object *items,
> +                                       u64 *val, size_t nval)
> +{
> +       int i;
> +
> +       for (i = 0; i < nval; i++) {
> +               if (items[i].type != ACPI_TYPE_INTEGER)
> +                       return -EPROTO;
> +
> +               val[i] = items[i].integer.value;
> +       }
> +       return 0;
> +}
> +
> +static int acpi_copy_property_array_string(const union acpi_object *items,
> +                                          char **val, size_t nval)
> +{
> +       int i;
> +
> +       for (i = 0; i < nval; i++) {
> +               if (items[i].type != ACPI_TYPE_STRING)
> +                       return -EPROTO;
> +
> +               val[i] = items[i].string.pointer;
> +       }
> +       return 0;
> +}
> +
> +int acpi_dev_prop_read(struct acpi_device *adev, const char *propname,
> +                      enum dev_prop_type proptype, void *val, size_t nval)
> +{
> +       const union acpi_object *obj;
> +       const union acpi_object *items;
> +       int ret;
> +
> +       if (val && nval == 1) {
> +               ret = acpi_dev_prop_read_single(adev, propname, proptype, val);
> +               if (!ret)
> +                       return ret;
> +       }
> +
> +       ret = acpi_dev_get_property_array(adev, propname, ACPI_TYPE_ANY, &obj);
> +       if (ret)
> +               return ret;
> +
> +       if (!val)
> +               return obj->package.count;
> +       else if (nval <= 0)
> +               return -EINVAL;
> +
> +       if (nval > obj->package.count)
> +               return -EOVERFLOW;
> +
> +       items = obj->package.elements;
> +       switch (proptype) {
> +       case DEV_PROP_U8:
> +               ret = acpi_copy_property_array_u8(items, (u8 *)val, nval);
> +               break;
> +       case DEV_PROP_U16:
> +               ret = acpi_copy_property_array_u16(items, (u16 *)val, nval);
> +               break;
> +       case DEV_PROP_U32:
> +               ret = acpi_copy_property_array_u32(items, (u32 *)val, nval);
> +               break;
> +       case DEV_PROP_U64:
> +               ret = acpi_copy_property_array_u64(items, (u64 *)val, nval);
> +               break;
> +       case DEV_PROP_STRING:
> +               ret = acpi_copy_property_array_string(items, (char **)val, nval);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +               break;
> +       }
> +       return ret;
> +}
>
