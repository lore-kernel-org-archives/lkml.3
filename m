Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaKCVnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:43:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50430 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751865AbaKCVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:43:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@linaro.org>
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
Subject: Re: [PATCH v6 02/12] Driver core: Unified device properties interface for platform firmware
Date: Mon, 03 Nov 2014 23:04:04 +0100
Message-ID: <3645687.BsyGDrJDrU@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACxGe6tvz8MiXnNGJ3XtrofxFr=o87yOB6kUKm57fXvQ0fL8jw@mail.gmail.com>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan> <2127128.VT1Iq03xz1@vostro.rjw.lan> <CACxGe6tvz8MiXnNGJ3XtrofxFr=o87yOB6kUKm57fXvQ0fL8jw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 03, 2014 03:40:08 PM Grant Likely wrote:
> Hi Rafael,

Hi,

> While reviewing and testing these patches I ran into serious bugs in
> the string parsers (in both the existing code and the new functions
> here). It took me a number of days, but I've got a fix now which I'll
> be posting shortly and I want to get into mainline right away. I'll cc
> you when I post it.

OK

> The fix will conflict with this patch. Mostly as a side effect of the
> fix, the of_property_*string* function changes will no longer be
> needed in this patch. It will either need to be respun, or we'll need
> to give Linus some guidance on resolving the conflicts when merging.

Respin might be better, we still have a number of -rcs before final 3.18.

> Other comments below...
> 
> On Tue, Oct 21, 2014 at 10:15 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> >
> > Add a uniform interface by which device drivers can request device
> > properties from the platform firmware by providing a property name
> > and the corresponding data type.  The purpose of it is to help to
> > write portable code that won't depend on any particular platform
> > firmware interface.
> >
> > The following general helper functions are added:
> [...]
> > +/**
> > + * device_property_read_u8_array - return a u8 array property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The values are stored here
> > + * @nval: Size of the @val array
> > + *
> > + * Function reads an array of u8 properties with @propname from the device
> > + * firmware description and stores them to @val if found.
> > + *
> > + * Return: %0 if the property was found (success),
> > + *        %-EINVAL if given arguments are not valid,
> > + *        %-ENODATA if the property does not have a value,
> > + *        %-EPROTO if the property is not an array of numbers,
> > + *        %-EOVERFLOW if the size of the property is not as expected.
> > + */
> > +int device_property_read_u8_array(struct device *dev, const char *propname,
> > +                                 u8 *val, size_t nval)
> > +{
> > +       return DEV_PROP_READ_ARRAY(dev, propname, u8, DEV_PROP_U8, val, nval);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u8_array);
> 
> Yup, I'm a lot happier with this approach. :-)
> 
> > +
> > +/**
> > + * device_property_read_u16_array - return a u16 array property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The values are stored here
> > + * @nval: Size of the @val array
> > + *
> > + * Function reads an array of u16 properties with @propname from the device
> > + * firmware description and stores them to @val if found.
> > + *
> > + * Return: %0 if the property was found (success),
> > + *        %-EINVAL if given arguments are not valid,
> > + *        %-ENODATA if the property does not have a value,
> > + *        %-EPROTO if the property is not an array of numbers,
> > + *        %-EOVERFLOW if the size of the property is not as expected.
> > + */
> > +int device_property_read_u16_array(struct device *dev, const char *propname,
> > +                                  u16 *val, size_t nval)
> > +{
> > +       return DEV_PROP_READ_ARRAY(dev, propname, u16, DEV_PROP_U16, val, nval);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u16_array);
> > +
> > +/**
> > + * device_property_read_u32_array - return a u32 array property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The values are stored here
> > + * @nval: Size of the @val array
> > + *
> > + * Function reads an array of u32 properties with @propname from the device
> > + * firmware description and stores them to @val if found.
> > + *
> > + * Return: %0 if the property was found (success),
> > + *        %-EINVAL if given arguments are not valid,
> > + *        %-ENODATA if the property does not have a value,
> > + *        %-EPROTO if the property is not an array of numbers,
> > + *        %-EOVERFLOW if the size of the property is not as expected.
> > + */
> > +int device_property_read_u32_array(struct device *dev, const char *propname,
> > +                                  u32 *val, size_t nval)
> > +{
> > +       return DEV_PROP_READ_ARRAY(dev, propname, u32, DEV_PROP_U32, val, nval);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u32_array);
> > +
> > +/**
> > + * device_property_read_u64_array - return a u64 array property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The values are stored here
> > + * @nval: Size of the @val array
> > + *
> > + * Function reads an array of u64 properties with @propname from the device
> > + * firmware description and stores them to @val if found.
> > + *
> > + * Return: %0 if the property was found (success),
> > + *        %-EINVAL if given arguments are not valid,
> > + *        %-ENODATA if the property does not have a value,
> > + *        %-EPROTO if the property is not an array of numbers,
> > + *        %-EOVERFLOW if the size of the property is not as expected.
> > + */
> > +int device_property_read_u64_array(struct device *dev, const char *propname,
> > +                                  u64 *val, size_t nval)
> > +{
> > +       return DEV_PROP_READ_ARRAY(dev, propname, u64, DEV_PROP_U64, val, nval);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u64_array);
> > +
> > +/**
> > + * device_property_read_string_array - return a string array property of device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The values are stored here
> > + * @nval: Size of the @val array
> > + *
> > + * Function reads an array of string properties with @propname from the device
> > + * firmware description and stores them to @val if found.
> > + *
> > + * Return: %0 if the property was found (success),
> > + *        %-EINVAL if given arguments are not valid,
> > + *        %-ENODATA if the property does not have a value,
> > + *        %-EPROTO or %-EILSEQ if the property is not an array of strings,
> > + *        %-EOVERFLOW if the size of the property is not as expected.
> > + */
> > +int device_property_read_string_array(struct device *dev, const char *propname,
> > +                                     char **val, size_t nval)
> > +{
> > +       return IS_ENABLED(CONFIG_OF) && dev->of_node ?
> > +               of_property_read_string_array(dev->of_node, propname, val, nval) :
> > +               acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> > +                                  DEV_PROP_STRING, val, nval);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_string_array);
> > +
> > +/**
> > + * device_property_read_u8 - return a u8 property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The value is stored here
> > + */
> > +int device_property_read_u8(struct device *dev, const char *propname, u8 *val)
> > +{
> > +       return device_property_read_u8_array(dev, propname, val, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u8);
> > +
> > +/**
> > + * device_property_read_u16 - return a u16 property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The value is stored here
> > + */
> > +int device_property_read_u16(struct device *dev, const char *propname, u16 *val)
> > +{
> > +       return device_property_read_u16_array(dev, propname, val, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u16);
> > +
> > +/**
> > + * device_property_read_u32 - return a u32 property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The value is stored here
> > + */
> > +int device_property_read_u32(struct device *dev, const char *propname, u32 *val)
> > +{
> > +       return device_property_read_u32_array(dev, propname, val, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u32);
> > +
> > +/**
> > + * device_property_read_u64 - return a u64 property of a device
> > + * @dev: Device to get the property of
> > + * @propname: Name of the property
> > + * @val: The value is stored here
> > + */
> > +int device_property_read_u64(struct device *dev, const char *propname, u64 *val)
> > +{
> > +       return device_property_read_u64_array(dev, propname, val, 1);
> > +}
> > +EXPORT_SYMBOL_GPL(device_property_read_u64);
> 
> Instead of exporting, can these be static inline wrappers in the header file?

Yes, they can.

The reason why I've done it this way is because I'm expecting the single value
reads to be the most common case and each one costs us a constant if that's
static inline.

> > ===================================================================
> > --- linux-pm.orig/drivers/of/base.c
> > +++ linux-pm/drivers/of/base.c
> > @@ -1250,6 +1250,39 @@ int of_property_read_u64(const struct de
> >  EXPORT_SYMBOL_GPL(of_property_read_u64);
> >
> >  /**
> > + * of_property_read_u64_array - Find and read an array of 64 bit integers
> > + * from a property.
> > + *
> > + * @np:                device node from which the property value is to be read.
> > + * @propname:  name of the property to be searched.
> > + * @out_values:        pointer to return value, modified only if return value is 0.
> > + * @sz:                number of array elements to read
> > + *
> > + * Search for a property in a device node and read 64-bit value(s) from
> > + * it. Returns 0 on success, -EINVAL if the property does not exist,
> > + * -ENODATA if property does not have a value, and -EOVERFLOW if the
> > + * property data isn't large enough.
> > + *
> > + * The out_values is modified only if a valid u64 value can be decoded.
> > + */
> > +int of_property_read_u64_array(const struct device_node *np,
> > +                              const char *propname, u64 *out_values,
> > +                              size_t sz)
> > +{
> > +       const __be32 *val = of_find_property_value_of_size(np, propname,
> > +                                               (sz * sizeof(*out_values)));
> > +
> > +       if (IS_ERR(val))
> > +               return PTR_ERR(val);
> > +
> > +       while (sz--) {
> > +               *out_values++ = of_read_number(val, 2);
> > +               val += 2;
> > +       }
> > +       return 0;
> > +}
> > +
> > +/**
> >   * of_property_read_string - Find and read a string from a property
> >   * @np:                device node from which the property value is to be read.
> >   * @propname:  name of the property to be searched.
> > @@ -1362,24 +1395,11 @@ int of_property_match_string(struct devi
> >  }
> >  EXPORT_SYMBOL_GPL(of_property_match_string);
> >
> > -/**
> > - * of_property_count_strings - Find and return the number of strings from a
> > - * multiple strings property.
> > - * @np:                device node from which the property value is to be read.
> > - * @propname:  name of the property to be searched.
> > - *
> > - * Search for a property in a device tree node and retrieve the number of null
> > - * terminated string contain in it. Returns the number of strings on
> > - * success, -EINVAL if the property does not exist, -ENODATA if property
> > - * does not have a value, and -EILSEQ if the string is not null-terminated
> > - * within the length of the property data.
> > - */
> > -int of_property_count_strings(struct device_node *np, const char *propname)
> > +static int property_count_strings(struct property *prop)
> >  {
> > -       struct property *prop = of_find_property(np, propname, NULL);
> > -       int i = 0;
> > -       size_t l = 0, total = 0;
> >         const char *p;
> > +       size_t l = 0, total = 0;
> > +       int i = 0;
> >
> >         if (!prop)
> >                 return -EINVAL;
> > @@ -1395,8 +1415,62 @@ int of_property_count_strings(struct dev
> >
> >         return i;
> >  }
> > +
> > +/**
> > + * of_property_count_strings - Find and return the number of strings from a
> > + * multiple strings property.
> > + * @np:                device node from which the property value is to be read.
> > + * @propname:  name of the property to be searched.
> > + *
> > + * Search for a property in a device tree node and retrieve the number of null
> > + * terminated string contain in it. Returns the number of strings on
> > + * success, -EINVAL if the property does not exist, -ENODATA if property
> > + * does not have a value, and -EILSEQ if the string is not null-terminated
> > + * within the length of the property data.
> > + */
> > +int of_property_count_strings(struct device_node *np, const char *propname)
> > +{
> > +       return property_count_strings(of_find_property(np, propname, NULL));
> > +}
> >  EXPORT_SYMBOL_GPL(of_property_count_strings);
> >
> > +/**
> > + * of_property_read_string_array - Read an array of strings from a multiple
> > + * strings property.
> > + * @np:                device node from which the property value is to be read.
> > + * @propname:  name of the property to be searched.
> > + * @out_strs:  output array of string pointers.
> > + * @sz:                number of array elements to read.
> > + *
> > + * Search for a property in a device tree node and retrieve a list of
> > + * terminated string values (pointer to data, not a copy) in that property.
> > + *
> > + * If @out_strs is NULL, the number of strings in the property is returned.
> > + */
> > +int of_property_read_string_array(struct device_node *np, const char *propname,
> > +                                 char **out_strs, size_t sz)
> 
> should be const char **out_strs. All the other string parsers use const char

OK

> > +{
> > +       struct property *prop = of_find_property(np, propname, NULL);
> > +       char *p = prop->value;
> > +       size_t total = 0;
> > +       int i;
> > +
> > +       i = property_count_strings(prop);
> > +       if (!out_strs || i < 0)
> > +               return i;
> > +
> > +       if (i < sz)
> > +               return -EOVERFLOW;
> > +
> > +       while (total < prop->length && i < sz) {
> > +               size_t l = strlen(p) + 1;
> > +
> > +               out_strs[i++] = p;
> > +               total += l;
> > +               p += l;
> > +       }
> > +}
> > +
> 
> drivers/of/base.c: In function 'of_property_read_string_array':
> drivers/of/base.c:1481:1: warning: control reaches end of non-void
> function [-Wreturn-type]

That's already fixed in linux-next.

> I also found that this parser code doesn't correctly handle malformed
> (unterminated) string properties. It will overflow. The existing
> functions have the same problem, so it isn't something that you've
> added. I've got a fix, and as a side effect the fix creates the _array
> version basically for free as part of reworking
> of_property_count_strings() and of_property_read_string_index()

OK

So can you please point me to a git branch containing the fix?  I'll rebase the
patch on top of that then and everything should merge just fine.

Rafael

