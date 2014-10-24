Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaJXOgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 10:36:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62904 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752127AbaJXOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 10:36:49 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Darren Hart <dvhart@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Use ACPI companion to match only the first physical device
Date: Fri, 24 Oct 2014 16:57:17 +0200
Message-ID: <6871118.LYO2moLKYB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141024141051.GT1484@lahna.fi.intel.com>
References: <1414141950-228930-1-git-send-email-mika.westerberg@linux.intel.com> <1442328.iYt6Cj5IOV@vostro.rjw.lan> <20141024141051.GT1484@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 24, 2014 05:10:51 PM Mika Westerberg wrote:
> On Fri, Oct 24, 2014 at 04:20:41PM +0200, Rafael J. Wysocki wrote:
> > > +static bool acpi_companion_match(const struct device *dev)
> > > +{
> > > +	struct acpi_device *adev;
> > > +	bool ret;
> > > +
> > > +	adev = ACPI_COMPANION(dev);
> > > +	if (!adev)
> > > +		return false;
> > > +
> > > +	if (list_empty(&adev->pnp.ids))
> > > +		return false;
> > > +
> > > +	ret = true;
> > 
> > On a second thought, should we return true if the list of physical devices is
> > empty?  That surely means ACPI_COMPANION(dev) lied to us?
> 
> I didn't consider that it is even possible but yes, in that case we
> should not return true here.

Well, that why did you check if the list is not empty at all? :-)

It is possible if someone sets the ACPI companion before calling acpi_bind_one()
(some pieces of code do that).  It may not be relevant here, but it won't hurt
to be on the safe side.

> > 
> > > +	mutex_lock(&adev->physical_node_lock);
> > > +	if (!list_empty(&adev->physical_node_list)) {
> > > +		const struct acpi_device_physical_node *node;
> > > +
> > > +		node = list_first_entry(&adev->physical_node_list,
> > > +					struct acpi_device_physical_node, node);
> > > +		if (node->dev != dev)
> > > +			ret = false;
> > 
> > And that may be simply
> > 
> > 		ret = node->dev == dev;
> 
> OK.

So what about the following modified version?

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
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   70 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 16 deletions(-)

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
+	mutex_lock(&adev->physical_node_lock);
+	if (list_empty(&adev->physical_node_list)) {
+		ret = false;
+	} else {
+		const struct acpi_device_physical_node *node;
+
+		node = list_first_entry(&adev->physical_node_list,
+					struct acpi_device_physical_node, node);
+		ret = node->dev == dev;
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

