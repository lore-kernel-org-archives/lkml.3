Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaJSXZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:25:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59229 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751747AbaJSXZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:25:37 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 09/12] Driver core: Unified interface for firmware node properties
Date: Mon, 20 Oct 2014 01:46 +0200
Message-ID: <7821406.D7i8JfDpzX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141018145520.6039FC40591@trevor.secretlab.ca>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <1628104.Ek1EGbdVha@vostro.rjw.lan> <20141018145520.6039FC40591@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 18, 2014 04:55:20 PM Grant Likely wrote:
> On Fri, 17 Oct 2014 14:14:53 +0200
> , "Rafael J. Wysocki" <rjw@rjwysocki.net>
>  wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Add new generic routines are provided for retrieving properties from
> > device description objects in the platform firmware in case there are
> > no struct device objects for them (either those objects have not been
> > created yet or they do not exist at all).
> > 
> > The following functions are provided:
> > 
> > fwnode_property_present()
> > fwnode_property_read_u8()
> > fwnode_property_read_u16()
> > fwnode_property_read_u32()
> > fwnode_property_read_u64()
> > fwnode_property_read_string()
> > fwnode_property_read_u8_array()
> > fwnode_property_read_u16_array()
> > fwnode_property_read_u32_array()
> > fwnode_property_read_u64_array()
> > fwnode_property_read_string_array()
> > 
> > in analogy with the corresponding functions for struct device added
> > previously.  For all of them, the first argument is a pointer to struct
> > fwnode_handle (new type) that allows a device description object
> > (depending on what platform firmware interface is in use) to be
> > obtained.
> > 
> > Add a new macro device_for_each_child_node() for iterating over the
> > children of the device description object associated with a given
> > device and a new function device_get_child_node_count() returning the
> > number of a given device's child nodes.
> > 
> > The interface covers both ACPI and Device Trees.
> 
> This is all *so much* better. I'm a lot happier.
> 
> I was about to make the comment that the implementation for
> device_property_read_*() should merely be wrappers around
> fwnode_property_read_*(), but when when I actually looked at it, I saw
> this:
> 
> In patch 2:
> int device_property_read_u8(struct device *dev, const char *propname, u8 *val)
> {
> 	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> 		return of_property_read_u8(dev->of_node, propname, val);
> 
> 	return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
> 				  DEV_PROP_U8, val);
> }
> 
> And in this patch:
> int fwnode_property_read_u8(struct fwnode_handle *fwnode, const char *propname,
> 			    u8 *val)
> {
> 	if (is_of_node(fwnode))
> 		return of_property_read_u8(of_node(fwnode), propname, val);
> 	else if (is_acpi_node(fwnode))
> 		return acpi_dev_prop_read(acpi_node(fwnode), propname,
> 					  DEV_PROP_U8, val);
> 
> 	return -ENXIO;
> }
> 
> Making the device_property functions wrappers around fwnode_property_*
> wouldn't actually be great since it would need to decode the fwnode
> pointer twice.

Indeed.

> I do still think the functions above should be macro generated, just in
> terms of keeping the line count down, and I would suggest merging patches #2
> and #9.

Well, the changes in those patches are almost completely independent and patch
#9 is only actually needed for #11 and #12, so I'm not sure if that would be
better.  I certainly prefer splitting longer patches into pieces if that makes
sense and it does make sense to do so in this particular case IMHO.

> Something like:
> 
> #define define_fwnode_accessors(__type, __devprop_type) \
> int device_property_read_##__type(struct device *dev, \
> 				const char *propname, __type *val) \
> { \
> 	if (IS_ENABLED(CONFIG_OF) && dev->of_node) \
> 		return of_property_read_##__type(dev->of_node, propname, val); \
> 	return acpi_dev_prop_read(ACPI_COMPANION(dev), propname, \
> 				  __devprop_type, val); \
> } \
> int fwnode_property_read_##__type(struct fwnode_handle *fwnode, \
> 				const char *propname, __type *val) \
> { \
> 	if (IS_ENABLED(CONFIG_OF) && is_of_node(fwnode)) \
> 		return of_property_read_##__type(of_node(fwnode), propname, val); \
> 	else if (IS_ENABLED(CONFIG_ACPI) && is_acpi_node(fwnode)) \
> 		return acpi_dev_prop_read(acpi_node(fwnode), propname, \
> 					  __devprop_type, val); \
> 	return -ENXIO; \
> }
> 
> define_fwnode_accessors(u8, DEV_PROP_U8);
> define_fwnode_accessors(u16, DEV_PROP_U16);
> define_fwnode_accessors(u32, DEV_PROP_U32);
> define_fwnode_accessors(u64, DEV_PROP_U64);
> 
> That significantly reduces the code size for these things.

So I was considering to do that, but eventually decided not to, because (1)
adding kerneldoc comments to such things looks odd and (2) (which IMO is
more important) this breaks LXR (for example, the thing at lxr.free-electrons.com
that some people, including me in particular, occasionally use to check how things
are defined).  And even if you used the old good grep to look for a definition of
fwnode_property_read_u8, say, this wouldn't work exactly as expected I'm afraid. ;-)

I would very much like to retain the headers at least for this reason, if that's
not a big deal.

What I can do, however, is to use macros for generating the bodies of those
functions.

I'm going to send updates of patches #2 and #9 with that modification shortly,
please have a look at them.

> Also, can the non-array versions be implemented as a wrapper around the
> array versions? That also will reduce the sheer number of lines of code
> a lot.
> 
> Maybe this:
> 
> #define define_fwnode_accessors(__type, __devprop_type) \
> int device_property_read_##__type##_array(struct device *dev, \
> 				const char *propname, __type *val, \
> 				size_t nval) \
> { \
> 	if (IS_ENABLED(CONFIG_OF) && dev->of_node) \
> 		return of_property_read_##__type##_array(dev->of_node, \
> 		propname, val, nval); \
> 	return acpi_dev_prop_read_array(ACPI_COMPANION(dev), propname, \
> 				  __devprop_type, val, nval); \
> } \
> static inline int device_property_read_##__type(struct device *dev, \
> 				const char *propname, __type *val) \
> { \
> 	return device_property_read_##__type##_array(dev, propname, val, 1) \
> } \
> int fwnode_property_read_##__type##_array(struct fwnode_handle *fwnode, \
> 				const char *propname, __type *val, \
> 				size_t nval) \
> { \
> 	if (IS_ENABLED(CONFIG_OF) && is_of_node(fwnode)) \
> 		return of_property_read_##__type(of_node(fwnode), propname, val, nval); \
> 	else if (IS_ENABLED(CONFIG_ACPI) && is_acpi_node(fwnode)) \
> 		return acpi_dev_prop_read(acpi_node(fwnode), propname, \
> 					  __devprop_type, val, nval); \
> 	return -ENXIO; \
> } \
> static inline int fwnode_property_read_##__type(struct fwnode_handle *fwnode, \
> 				const char *propname, __type *val) \
> { \
> 	return fwnode_property_read_##__type##_array(fwnode, propname, val, 1) \
> }
> define_fwnode_accessors(u8, DEV_PROP_U8);
> define_fwnode_accessors(u16, DEV_PROP_U16);
> define_fwnode_accessors(u32, DEV_PROP_U32);
> define_fwnode_accessors(u64, DEV_PROP_U64);

No, that wouldn't work for ACPI (if I understand your idea correctly), because
acpi_dev_prop_read(adev, propname, DEV_PROP_U8, val) will look for a single-value
int property, whereas acpi_dev_prop_read_array(adev, propname, DEV_PROP_U8, val, 1)
will look for a list (package) property and will attempt to retrieve the first
element of that.

Rafael

