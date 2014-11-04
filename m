Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaKDWd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:33:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58238 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751129AbaKDWd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:33:57 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index() when using properties
Date: Tue, 04 Nov 2014 23:54:41 +0100
Message-ID: <3196606.Sy6xFg88zg@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2107668.8toVpPDgB1@vostro.rjw.lan>
References: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com> <CACxGe6uXogQaT9m_Zysb+daSHCz2B97OdMBHuCzJvNYj9oNWfQ@mail.gmail.com> <2107668.8toVpPDgB1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 05:06:40 PM Rafael J. Wysocki wrote:
> On Tuesday, November 04, 2014 02:48:40 PM Grant Likely wrote:
> > On Mon, Nov 3, 2014 at 9:52 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > On Monday, November 03, 2014 04:25:08 PM Rafael J. Wysocki wrote:
> > >> On Sunday, November 02, 2014 08:49:37 PM Darren Hart wrote:
> > >> >
> > >> > On 11/1/14 4:11, Grant Likely wrote:
> > >> > > On Tue, 28 Oct 2014 22:59:57 +0100
> > >> > > , "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > >> > >  wrote:
> > >> > >> On Tuesday, October 28, 2014 01:15:27 PM Mika Westerberg wrote:
> > >> > >>> acpi_dev_add_driver_gpios() makes it possible to set up mapping between
> > >> > >>> properties and ACPI GpioIo resources in a driver, so we can take index
> > >> > >>> parameter in acpi_find_gpio() into use with _DSD device properties now.
> > >> > >>>
> > >> > >>> This index can be used to select a GPIO from a property with multiple
> > >> > >>> GPIOs:
> > >> > >>>
> > >> > >>>   Package () {
> > >> > >>>         "data-gpios",
> > >> > >>>         Package () {
> > >> > >>>                 \_SB.GPIO, 0, 0, 0,
> > >> > >>>                 \_SB.GPIO, 1, 0, 0,
> > >> > >>>                 \_SB.GPIO, 2, 0, 1,
> > >> > >>>         }
> > >> > >>>   }
> > >> > >>>
> > >> > >>> In order to retrieve the last GPIO from a driver we can simply do:
> > >> > >>>
> > >> > >>>   desc = devm_gpiod_get_index(dev, "data", 2);
> > >> > >>>
> > >> > >>> and so on.
> > >> > >>>
> > >> > >>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > >> > >>
> > >> > >> Cool. :-)
> > >> > >>
> > >> > >> Any objections anyone?
> > >> > >
> > >> > > Actually, I do. Not in the idea, but in the implementation. The way this gets encoded:
> > >> > >
> > >> > >   Package () {
> > >> > >           \_SB.GPIO, 0, 0, 0,
> > >> > >           \_SB.GPIO, 1, 0, 0,
> > >> > >           \_SB.GPIO, 2, 0, 1,
> > >> > >   }
> > >> > >
> > >> > > Means that decoding each GPIO tuple requires the length of a tuple to be
> > >> > > fixed, or to implement a DT-like #gpio-cells. If it is fixed, then there
> > >> > > is no way to expand the binding later. Can this be done in the following
> > >> > > way instead?
> > >> > >
> > >> > >   Package () {
> > >> > >           Package () { \_SB.GPIO, 0, 0, 0 },
> > >> > >           Package () { \_SB.GPIO, 1, 0, 0 },
> > >> > >           Package () { \_SB.GPIO, 2, 0, 1 },
> > >> > >   }
> > >> > >
> > >> > > This is one of the biggest pains in device tree. We don't have any way
> > >> > > to group tuples so it requires looking up stuff across the tree to
> > >> > > figure out how to parse each multi-item property.
> > >> > >
> > >> > > I know that last year we talked about how bios vendors would get
> > >> > > complicated properties wrong, but I think there is little risk in this
> > >> > > case. If the property is encoded wrong, the driver simply won't work and
> > >> > > it is unlikely to get shipped before being fixed.
> > >> >
> > >> > This particular nesting of Packages is expressly prohibited by the
> > >> > Device Properties UUID for the reasons you mention.
> > >> >
> > >> > http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> > >>
> > >> Also we don't use properties where single name is assigned to multiple GPIOs
> > >> anywhere in the current device-properties patchset, so this is not relevant at
> > >> the moment.
> > >>
> > >> Moreover, even if we were to use them, we would need to ensure that this:
> > >>
> > >>       Package () {
> > >>               \_SB.GPIO, 0, 0, 0
> > >>       }
> > >>
> > >> was equivalent to
> > >>
> > >>       Package () {
> > >>               Package () { \_SB.GPIO, 0, 0, 0 }
> > >>       }
> > >>
> > >> This is not impossible to do and I suppose we could even explain that in the
> > >> implementation guide document in a sensible way, but that would require the
> > >> document linked above to be changed first and *then* we can think about writing
> > >> kernel code to it.  Not the other way around, please.
> > >>
> > >> So Grant, do you want us to proceed with that?
> > >
> > > Before you reply, one more observation that seems to be relevant.
> > >
> > > In ACPI, both this:
> > >
> > >         Package () {
> > >                 \_SB.GPIO, 0, 0, 0,
> > >                 \_SB.GPIO, 1, 0, 0,
> > >                 \_SB.GPIO, 2, 0, 1,
> > >         }
> > >
> > > and this:
> > >
> > >         Package () {
> > >                 Package () { \_SB.GPIO, 0, 0, 0 },
> > >                 Package () { \_SB.GPIO, 1, 0, 0 },
> > >                 Package () { \_SB.GPIO, 2, 0, 1 },
> > >         }
> > >
> > > carry the same information, because every element of a package has a type,
> > > so there is no danger of confusing an ACPI_TYPE_LOCAL_REFERENCE with
> > > ACPI_TYPE_INTEGER.  Thus one can easily count the number of GPIOs represented
> > > by the first package by counting the number of reference elements in it.
> > > The second one has more structure which in this particular case is arguably
> > > redundant.
> > 
> > Okay, this make sense. I'm okay with this approach, and I would
> > recommend making that the only valid method for parsing in
> > acpi_dev_get_property_reference(). Get rid of the *size_prop argument
> > so that it always behaves the same way and users aren't tempted to do
> > something clever.
> 
> OK, I'll send a followup patch to remove the size_prop arg from
> acpi_dev_get_property_reference().

This:

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / property: Drop size_prop from acpi_dev_get_property_reference()

The size_prop argument of the recently added function
acpi_dev_get_property_reference() is not used by the only current
caller of that function and is very unlikely to be used at any time
going forward.

Namely, for a property whose value is a list of items each containing
a references to a device object possibly accompanied by some integers,
the number of items in the list can always be computed as the number
of elements of type ACPI_TYPE_LOCAL_REFERENCE in the property package.
Thus it should never be necessary to provide an additional "cells"
property with a value equal to the number of items in that list.

For this reason, drop the size_prop argument from
acpi_dev_get_property_reference() and update its caller accordingly.

Link: http://marc.info/?l=linux-kernel&m=141511255610556&w=2
Suggested-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

On top of

http://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/log/?h=device-properties

---
 drivers/acpi/property.c     |   62 +++++++++++---------------------------------
 drivers/gpio/gpiolib-acpi.c |    2 -
 include/linux/acpi.h        |    4 +-
 3 files changed, 19 insertions(+), 49 deletions(-)

Index: linux-pm/drivers/acpi/property.c
===================================================================
--- linux-pm.orig/drivers/acpi/property.c
+++ linux-pm/drivers/acpi/property.c
@@ -273,25 +273,21 @@ EXPORT_SYMBOL_GPL(acpi_dev_get_property_
  * acpi_dev_get_property_reference - returns handle to the referenced object
  * @adev: ACPI device to get property
  * @name: Name of the property
- * @size_prop: Name of the "size" property in referenced object
  * @index: Index of the reference to return
  * @args: Location to store the returned reference with optional arguments
  *
  * Find property with @name, verifify that it is a package containing at least
  * one object reference and if so, store the ACPI device object pointer to the
- * target object in @args->adev.
+ * target object in @args->adev.  If the reference includes arguments, store
+ * them in the @args->args[] array.
  *
- * If the reference includes arguments (@size_prop is not %NULL) follow the
- * reference and check whether or not there is an integer property @size_prop
- * under the target object and if so, whether or not its value matches the
- * number of arguments that follow the reference.  If there's more than one
- * reference in the property value package, @index is used to select the one to
- * return.
+ * If there's more than one reference in the property value package, @index is
+ * used to select the one to return.
  *
  * Return: %0 on success, negative error code on failure.
  */
-int acpi_dev_get_property_reference(struct acpi_device *adev, const char *name,
-				    const char *size_prop, size_t index,
+int acpi_dev_get_property_reference(struct acpi_device *adev,
+				    const char *name, size_t index,
 				    struct acpi_reference_args *args)
 {
 	const union acpi_object *element, *end;
@@ -308,7 +304,7 @@ int acpi_dev_get_property_reference(stru
 	 * return that reference then.
 	 */
 	if (obj->type == ACPI_TYPE_LOCAL_REFERENCE) {
-		if (size_prop || index)
+		if (index)
 			return -EINVAL;
 
 		ret = acpi_bus_get_device(obj->reference.handle, &device);
@@ -348,42 +344,16 @@ int acpi_dev_get_property_reference(stru
 		element++;
 		nargs = 0;
 
-		if (size_prop) {
-			const union acpi_object *prop;
-
-			/*
-			 * Find out how many arguments the refenced object
-			 * expects by reading its size_prop property.
-			 */
-			ret = acpi_dev_get_property(device, size_prop,
-						    ACPI_TYPE_INTEGER, &prop);
-			if (ret)
-				return ret;
-
-			nargs = prop->integer.value;
-			if (nargs > MAX_ACPI_REFERENCE_ARGS
-			    || element + nargs > end)
+		/* assume following integer elements are all args */
+		for (i = 0; element + i < end; i++) {
+			int type = element[i].type;
+
+			if (type == ACPI_TYPE_INTEGER)
+				nargs++;
+			else if (type == ACPI_TYPE_LOCAL_REFERENCE)
+				break;
+			else
 				return -EPROTO;
-
-			/*
-			 * Skip to the start of the arguments and verify
-			 * that they all are in fact integers.
-			 */
-			for (i = 0; i < nargs; i++)
-				if (element[i].type != ACPI_TYPE_INTEGER)
-					return -EPROTO;
-		} else {
-			/* assume following integer elements are all args */
-			for (i = 0; element + i < end; i++) {
-				int type = element[i].type;
-
-				if (type == ACPI_TYPE_INTEGER)
-					nargs++;
-				else if (type == ACPI_TYPE_LOCAL_REFERENCE)
-					break;
-				else
-					return -EPROTO;
-			}
 		}
 
 		if (idx++ == index) {
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -718,8 +718,8 @@ int acpi_dev_get_property(struct acpi_de
 int acpi_dev_get_property_array(struct acpi_device *adev, const char *name,
 				acpi_object_type type,
 				const union acpi_object **obj);
-int acpi_dev_get_property_reference(struct acpi_device *adev, const char *name,
-				    const char *cells_name, size_t index,
+int acpi_dev_get_property_reference(struct acpi_device *adev,
+				    const char *name, size_t index,
 				    struct acpi_reference_args *args);
 
 int acpi_dev_prop_get(struct acpi_device *adev, const char *propname,
Index: linux-pm/drivers/gpio/gpiolib-acpi.c
===================================================================
--- linux-pm.orig/drivers/gpio/gpiolib-acpi.c
+++ linux-pm/drivers/gpio/gpiolib-acpi.c
@@ -405,7 +405,7 @@ struct gpio_desc *acpi_get_gpiod_by_inde
 		dev_dbg(&adev->dev, "GPIO: looking up %s\n", propname);
 
 		memset(&args, 0, sizeof(args));
-		ret = acpi_dev_get_property_reference(adev, propname, NULL,
+		ret = acpi_dev_get_property_reference(adev, propname,
 						      index, &args);
 		if (ret) {
 			bool found = acpi_get_driver_gpio_data(adev, propname,

