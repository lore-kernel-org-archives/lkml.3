Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbaJXNfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:35:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56797 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756656AbaJXNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:35:05 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Darren Hart <dvhart@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Use ACPI companion to match only the first physical device
Date: Fri, 24 Oct 2014 15:55:34 +0200
Message-ID: <2356721.6lgfg38MC8@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414141950-228930-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1414141950-228930-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 24, 2014 12:12:30 PM Mika Westerberg wrote:
> Commit 6ab3430129e2 ("mfd: Add ACPI support") made the MFD subdevices to
> share the parent MFD ACPI companion device if no _HID/_CID is specified for
> the subdevice in mfd_cell description. However, since all the subdevices
> share the ACPI companion, the match and modalias generation logic started
> to use the ACPI companion as well resulting this:
> 
>   # cat /sys/bus/platform/devices/HID-SENSOR-200041.6.auto/modalias
>   acpi:INT33D1:PNP0C50:
> 
> instead of the expected one
> 
>   # cat /sys/bus/platform/devices/HID-SENSOR-200041.6.auto/modalias
>   platform:HID-SENSOR-200041
> 
> In other words the subdevice modalias is overwritten by the one taken from
> ACPI companion. This causes udev not to load the driver anymore.
> 
> It is useful to be able to share the ACPI companion so that MFD subdevices
> (and possibly other devices as well) can access the ACPI resources even if
> they do not have ACPI representation in the namespace themselves.
> 
> An example where this is used is Minnowboard LPC driver that creates GPIO
> as a subdevice among other things. Without the ACPI companion gpiolib is
> not is not able to lookup the corresponding GPIO controller from ACPI
> GpioIo resource.
> 
> To fix this we restrict the match and modalias logic to be limited to the
> first physical device. The secondary devices will still be able to access
> the ACPI companion but they will be matched using traditional way.
> 
> Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

So I've applied it, although it didn't make it to the mailing lists for an
unknown reason, but I modified it slightly.  My version is below for
completness (it's in bleeding-edge for now).

I'm a bit concerned that it will break something obscure I can't recall
ATM, but since I can't recall it may not be that important (or even non-existent
at all).  In any case, we may need to go back all the way to reverting the
MFD commit if that happens.

Rafael


---
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI: Use ACPI companion to match only the first physical device

Commit 6ab3430129e2 ("mfd: Add ACPI support") made the MFD subdevices
share the parent MFD ACPI companion if no _HID/_CID is specified for
the subdevice in mfd_cell description. However, since all the subdevices
share the ACPI companion, the match and modalias generation logic started
to use the ACPI companion as well resulting this:

  # cat /sys/bus/platform/devices/HID-SENSOR-200041.6.auto/modalias
  acpi:INT33D1:PNP0C50:

instead of the expected one

  # cat /sys/bus/platform/devices/HID-SENSOR-200041.6.auto/modalias
  platform:HID-SENSOR-200041

In other words the subdevice modalias is overwritten by the one taken from
ACPI companion. This causes udev not to load the driver anymore.

It is useful to be able to share the ACPI companion so that MFD subdevices
(and possibly other devices as well) can access the ACPI resources even if
they do not have ACPI representation in the namespace themselves.

An example where this is used is Minnowboard LPC driver that creates GPIO
as a subdevice among other things. Without the ACPI companion gpiolib is
not able to lookup the corresponding GPIO controller from ACPI GpioIo
resource.

To fix this, restrict the match and modalias logic to be limited to the
first (primary) physical device associated with the given ACPI comapnion.
The secondary devices will still be able to access the ACPI companion,
but they will be matched in a different way.

Fixes: 6ab3430129e2 (mfd: Add ACPI support)
Reported-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
[ rjw: Change the name of the new function to acpi_companion_match()
  and modify the kerneldoc comment for it, changelog fixups. ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -181,6 +181,53 @@ static int create_modalias(struct acpi_d
 }
 
 /*
+ * acpi_companion_match() - Can we match via ACPI companion device
+ * @dev: Device in question
+ *
+ * Check if the given device has an ACPI companion and if that companion has
+ * a valid list of PNP IDs, and if the device is the first (primary) physical
+ * device associated with it.
+ *
+ * If multiple physical devices are attached to a single ACPI companion, we need
+ * to be careful.  The usage scenario for this kind of relationship is that all
+ * of the physical devices in question use resources provided by the ACPI
+ * companion.  A typical case is an MFD device where all the sub-devices share
+ * the parent's ACPI companion.  In such cases we can only allow the primary
+ * (first) physical device to be matched with the help of the companion's PNP
+ * IDs.
+ *
+ * Additional physical devices sharing the ACPI companion can still use
+ * resources available from it but they will be matched normally using functions
+ * provided by their bus types (and analogously for their modalias).
+ */
+static bool acpi_companion_match(const struct device *dev)
+{
+	struct acpi_device *adev;
+	bool ret;
+
+	adev = ACPI_COMPANION(dev);
+	if (!adev)
+		return false;
+
+	if (list_empty(&adev->pnp.ids))
+		return false;
+
+	ret = true;
+	mutex_lock(&adev->physical_node_lock);
+	if (!list_empty(&adev->physical_node_list)) {
+		const struct acpi_device_physical_node *node;
+
+		node = list_first_entry(&adev->physical_node_list,
+					struct acpi_device_physical_node, node);
+		if (node->dev != dev)
+			ret = false;
+	}
+	mutex_unlock(&adev->physical_node_lock);
+
+	return ret;
+}
+
+/*
  * Creates uevent modalias field for ACPI enumerated devices.
  * Because the other buses does not support ACPI HIDs & CIDs.
  * e.g. for a device with hid:IBM0001 and cid:ACPI0001 you get:
@@ -188,20 +235,14 @@ static int create_modalias(struct acpi_d
  */
 int acpi_device_uevent_modalias(struct device *dev, struct kobj_uevent_env *env)
 {
-	struct acpi_device *acpi_dev;
 	int len;
 
-	acpi_dev = ACPI_COMPANION(dev);
-	if (!acpi_dev)
-		return -ENODEV;
-
-	/* Fall back to bus specific way of modalias exporting */
-	if (list_empty(&acpi_dev->pnp.ids))
+	if (!acpi_companion_match(dev))
 		return -ENODEV;
 
 	if (add_uevent_var(env, "MODALIAS="))
 		return -ENOMEM;
-	len = create_modalias(acpi_dev, &env->buf[env->buflen - 1],
+	len = create_modalias(ACPI_COMPANION(dev), &env->buf[env->buflen - 1],
 				sizeof(env->buf) - env->buflen);
 	if (len <= 0)
 		return len;
@@ -218,18 +259,12 @@ EXPORT_SYMBOL_GPL(acpi_device_uevent_mod
  */
 int acpi_device_modalias(struct device *dev, char *buf, int size)
 {
-	struct acpi_device *acpi_dev;
 	int len;
 
-	acpi_dev = ACPI_COMPANION(dev);
-	if (!acpi_dev)
-		return -ENODEV;
-
-	/* Fall back to bus specific way of modalias exporting */
-	if (list_empty(&acpi_dev->pnp.ids))
+	if (!acpi_companion_match(dev))
 		return -ENODEV;
 
-	len = create_modalias(acpi_dev, buf, size -1);
+	len = create_modalias(ACPI_COMPANION(dev), buf, size -1);
 	if (len <= 0)
 		return len;
 	buf[len++] = '\n';
@@ -892,6 +927,9 @@ const struct acpi_device_id *acpi_match_
 	if (!ids || !handle || acpi_bus_get_device(handle, &adev))
 		return NULL;
 
+	if (!acpi_companion_match(dev))
+		return NULL;
+
 	return __acpi_match_device(adev, ids);
 }
 EXPORT_SYMBOL_GPL(acpi_match_device);

