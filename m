Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbbAWLXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:23:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:34799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbbAWLXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:23:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,453,1418112000"; 
   d="scan'208,223";a="641540103"
Date: Fri, 23 Jan 2015 13:21:22 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
Message-ID: <20150123112122.GD30522@kuha.fi.intel.com>
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
 <4078818.ecVtLF3hjd@vostro.rjw.lan>
 <CAAVeFuJjMDfz7TZexkYnYrCGkAmRwubs32UhSPO-4qZWbMJjuQ@mail.gmail.com>
 <1564228.rcRekIyDUd@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564228.rcRekIyDUd@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi guys,

On Thu, Jan 22, 2015 at 05:14:22PM +0100, Rafael J. Wysocki wrote:
> On Thursday, January 22, 2015 11:57:55 AM Alexandre Courbot wrote:
> > If we decide to go ahead with the solution proposed by this patch for
> > practical reasons (which are good reasons indeed), I still have one
> > problem with its current form.
> > 
> > As the discussion highlighted, this is an ACPI problem, so I'd very
> > much like it to be confined to the ACPI GPIO code, to be enabled only
> > when ACPI is, and to use function names that start with acpi_gpio.
> 
> I can agree with that.
> 
> > The current implementation leverages platform lookup, making said lookup
> > less efficient in the process and bringing confusion about its
> > purpose. Although the two processes are indeed similar, they are
> > separate things: one is a legitimate way to map GPIOs, the other is a
> > fixup for broken firmware.
> > 
> > I suppose we all agree this is a hackish fix, so let's confine it as
> > much as we can.
> 
> OK
> 
> Heikki, any comments?

I'm fine with that.

That actually makes me think that we could then drop the lookup tables
completely and use device properties instead with the help of "generic
property" (attached):

We would just need to agree on the format how to describe a gpio
property, document it and of course convert the current users as
usual. The format could be something like this as an example (I'm
writing this out of my head so don't shoot me if you can see it would
not work. Just an example):

static const u32 example_gpio[] = { <gpio>, <flags>, };

static struct dev_gen_prop example_prop[] =
        {
                .type = DEV_PROP_U32,
                .name = "gpio,<con_id>",
                .nval = 2,
                .num = &example_gpio,
        },
        { },
};

static struct platform_device example_pdev = {
        ...
        .dev = {
                .gen_prop = &example_prop,
        },
}


In gpiolib.c we would then, instead of going through the lookups,
simply ask for that property:

        ...
        sprintf(propname, "gpio,%s", con_id);
        device_property_read_u32_array(dev, propname, &val, 2);
        ...
        desc = gpio_to_desc(val[0]);
        flags = val[1];
        ...


So this is just and idea. I think it would be relatively easy to
implement. What do you guys think?


Cheers,

-- 
heikki

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-driver-core-property-support-for-generic-property.patch"

>From bb1146d8ca7c39386dfc53043051d389cba49cbe Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 7 Jan 2015 10:57:44 +0200
Subject: [PATCH] driver core: property: support for generic property

This extends the unified device property interface by adding
"Generic Property" to it for cases where device tree or ACPI
are not being used.

That makes the unified device property interface cover also
most of the cases where information is extracted from custom
platform_data in the drivers. So if before we had to check
separately is there custom platform_data for a driver:

	if (pdata)
		bar = pdata->bar;
	else
		device_property_read_u32(dev, "foo", &bar);

we can now drop that check and simply always use the unified
device property interface.

That makes it possible to drop a lot of boiler plate from
the drivers, plus quite a few header files under
include/linux/ describing those driver specific platform
data structures can be removed.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/base/property.c  | 135 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/device.h   |   3 ++
 include/linux/property.h |  17 ++++++
 3 files changed, 143 insertions(+), 12 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index c458458..4ea6d27 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -15,6 +15,108 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 
+static struct dev_gen_prop *dev_prop_get(struct device *dev, const char *name)
+{
+	struct dev_gen_prop *prop;
+
+	if (!dev->gen_prop)
+		return NULL;
+
+	for (prop = dev->gen_prop; prop->name; prop++)
+		if (!strcmp(name, prop->name))
+			return prop;
+	return NULL;
+}
+
+static int dev_prop_copy_array_u8(u8 *src, u8 *val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++)
+		val[i] = src[i];
+	return 0;
+}
+
+static int dev_prop_copy_array_u16(u16 *src, u16 *val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++)
+		val[i] = src[i];
+	return 0;
+}
+
+static int dev_prop_copy_array_u32(u32 *src, u32 *val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++)
+		val[i] = src[i];
+	return 0;
+}
+
+static int dev_prop_copy_array_u64(u64 *src, u64 *val, size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++)
+		val[i] = src[i];
+	return 0;
+}
+
+static int dev_prop_copy_array_string(const char **src, const char **val,
+				      size_t nval)
+{
+	int i;
+
+	for (i = 0; i < nval; i++)
+		val[i] = src[i];
+	return 0;
+}
+
+static int dev_prop_read_array(struct device *dev, const char *name,
+			       enum dev_prop_type type, void *val, size_t nval)
+{
+	struct dev_gen_prop *prop;
+	int ret = 0;
+
+	prop = dev_prop_get(dev, name);
+	if (!prop)
+		return -ENODATA;
+
+	if (prop->type != type)
+		return -EPROTO;
+
+	if (prop->nval < nval)
+		return -EOVERFLOW;
+
+	switch (prop->type) {
+	case DEV_PROP_U8:
+		ret = dev_prop_copy_array_u8((u8 *)prop->num, (u8 *)val,
+					     nval);
+		break;
+	case DEV_PROP_U16:
+		ret = dev_prop_copy_array_u16((u16 *)prop->num, (u16 *)val,
+					      nval);
+		break;
+	case DEV_PROP_U32:
+		ret = dev_prop_copy_array_u32((u32 *)prop->num, (u32 *)val,
+					      nval);
+		break;
+	case DEV_PROP_U64:
+		ret = dev_prop_copy_array_u64(prop->num, (u64 *)val, nval);
+		break;
+	case DEV_PROP_STRING:
+		ret = dev_prop_copy_array_string(prop->str,
+						 (const char **)val, nval);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
 /**
  * device_property_present - check if a property of a device is present
  * @dev: Device whose property is being checked
@@ -26,8 +128,9 @@ bool device_property_present(struct device *dev, const char *propname)
 {
 	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
 		return of_property_read_bool(dev->of_node, propname);
-
-	return !acpi_dev_prop_get(ACPI_COMPANION(dev), propname, NULL);
+	if (ACPI_HANDLE(dev))
+		return !acpi_dev_prop_get(ACPI_COMPANION(dev), propname, NULL);
+	return !!dev_prop_get(dev, propname);
 }
 EXPORT_SYMBOL_GPL(device_property_present);
 
@@ -55,8 +158,11 @@ EXPORT_SYMBOL_GPL(fwnode_property_present);
 	IS_ENABLED(CONFIG_OF) && _dev_->of_node ? \
 		(OF_DEV_PROP_READ_ARRAY(_dev_->of_node, _propname_, _type_, \
 					_val_, _nval_)) : \
-		acpi_dev_prop_read(ACPI_COMPANION(_dev_), _propname_, \
-				   _proptype_, _val_, _nval_)
+		ACPI_HANDLE(_dev_) ? \
+			acpi_dev_prop_read(ACPI_COMPANION(_dev_), _propname_, \
+					   _proptype_, _val_, _nval_) : \
+			dev_prop_read_array(_dev_, _propname_, _proptype_, \
+					   _val_, _nval_)
 
 /**
  * device_property_read_u8_array - return a u8 array property of a device
@@ -169,10 +275,13 @@ EXPORT_SYMBOL_GPL(device_property_read_u64_array);
 int device_property_read_string_array(struct device *dev, const char *propname,
 				      const char **val, size_t nval)
 {
-	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
-		of_property_read_string_array(dev->of_node, propname, val, nval) :
-		acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
-				   DEV_PROP_STRING, val, nval);
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_property_read_string_array(dev->of_node, propname,
+						     val, nval);
+	if (ACPI_HANDLE(dev))
+		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
+					  DEV_PROP_STRING, val, nval);
+	return dev_prop_read_array(dev, propname, DEV_PROP_STRING, val, nval);
 }
 EXPORT_SYMBOL_GPL(device_property_read_string_array);
 
@@ -193,10 +302,12 @@ EXPORT_SYMBOL_GPL(device_property_read_string_array);
 int device_property_read_string(struct device *dev, const char *propname,
 				const char **val)
 {
-	return IS_ENABLED(CONFIG_OF) && dev->of_node ?
-		of_property_read_string(dev->of_node, propname, val) :
-		acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
-				   DEV_PROP_STRING, val, 1);
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		return of_property_read_string(dev->of_node, propname, val);
+	if (ACPI_HANDLE(dev))
+		return acpi_dev_prop_read(ACPI_COMPANION(dev), propname,
+					  DEV_PROP_STRING, val, 1);
+	return dev_prop_read_array(dev, propname, DEV_PROP_STRING, val, 1);
 }
 EXPORT_SYMBOL_GPL(device_property_read_string);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index fb50673..738dc25 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -27,6 +27,7 @@
 #include <linux/ratelimit.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/property.h>
 #include <asm/device.h>
 
 struct device;
@@ -704,6 +705,7 @@ struct acpi_dev_node {
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
  * @acpi_node:	Associated ACPI device node.
+ * @gen_prop:	Generic device property
  * @devt:	For creating the sysfs "dev".
  * @id:		device instance
  * @devres_lock: Spinlock to protect the resource of the device.
@@ -780,6 +782,7 @@ struct device {
 
 	struct device_node	*of_node; /* associated device tree node */
 	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
+	struct dev_gen_prop	*gen_prop; /* generic device property */
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	u32			id;	/* device instance */
diff --git a/include/linux/property.h b/include/linux/property.h
index a6a3d98..44e875f 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -26,6 +26,23 @@ enum dev_prop_type {
 	DEV_PROP_MAX,
 };
 
+/**
+ * struct dev_gen_prop - Generic Device Property
+ * @name: property name
+ * @nval: number of elements in the array
+ * @str: value array of strings
+ * @num: value array of numbers
+ *
+ * Used when of_node and acpi_node are missing.
+ */
+struct dev_gen_prop {
+	enum dev_prop_type type;
+	const char *name;
+	size_t nval;
+	const char **str;
+	u64 *num;
+};
+
 bool device_property_present(struct device *dev, const char *propname);
 int device_property_read_u8_array(struct device *dev, const char *propname,
 				  u8 *val, size_t nval);
-- 
2.1.4


--Nq2Wo0NMKNjxTN9z--
