Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaJACEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 22:04:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53033 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751904AbaJACDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 22:03:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: linux-kernel@vger.kernel.org
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH v3 03/15] ACPI: Allow drivers to match using Device Tree compatible property
Date: Wed, 01 Oct 2014 04:10:40 +0200
Message-ID: <3582127.hCPY12ZqpT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1852462.V1jlbi8OPt@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

We have lots of existing Device Tree enabled drivers and allocating
separate _HID for each is not feasible. Instead we allocate special _HID
"PRP0001" that means that the match should be done using Device Tree
compatible property using driver's .of_match_table instead.

If there is a need to distinguish from where the device is enumerated
(DT/ACPI) driver can check dev->of_node or ACPI_COMPATION(dev).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/property.c |   34 +++++++++++++++++
 drivers/acpi/scan.c     |   91 ++++++++++++++++++++++++++++++++++++++++++------
 include/acpi/acpi_bus.h |    1 
 include/linux/acpi.h    |    8 +---
 4 files changed, 118 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/acpi/property.c
===================================================================
--- linux-pm.orig/drivers/acpi/property.c
+++ linux-pm/drivers/acpi/property.c
@@ -76,6 +76,37 @@ static bool acpi_properties_format_valid
 	return true;
 }
 
+static void acpi_init_of_compatible(struct acpi_device *adev)
+{
+	const union acpi_object *of_compatible;
+	struct acpi_hardware_id *hwid;
+	bool acpi_of = false;
+
+	/*
+	 * Check if the special PRP0001 ACPI ID is present and in that
+	 * case we fill in Device Tree compatible properties for this
+	 * device.
+	 */
+	list_for_each_entry(hwid, &adev->pnp.ids, list) {
+		if (!strcmp(hwid->id, "PRP0001")) {
+			acpi_of = true;
+			break;
+		}
+	}
+
+	if (!acpi_of)
+		return;
+
+	if (acpi_dev_get_property_array(adev, "compatible", ACPI_TYPE_STRING,
+					&of_compatible)) {
+		acpi_handle_warn(adev->handle,
+				 "PRP0001 requires compatible property\n");
+		return;
+	}
+
+	adev->data.of_compatible = of_compatible;
+}
+
 void acpi_init_properties(struct acpi_device *adev)
 {
 	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
@@ -119,6 +150,8 @@ void acpi_init_properties(struct acpi_de
 
 		adev->data.pointer = buf.pointer;
 		adev->data.properties = properties;
+
+		acpi_init_of_compatible(adev);
 		return;
 	}
 
@@ -130,6 +163,7 @@ void acpi_init_properties(struct acpi_de
 void acpi_free_properties(struct acpi_device *adev)
 {
 	ACPI_FREE((void *)adev->data.pointer);
+	adev->data.of_compatible = NULL;
 	adev->data.pointer = NULL;
 	adev->data.properties = NULL;
 }
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -124,17 +124,43 @@ static int create_modalias(struct acpi_d
 	if (list_empty(&acpi_dev->pnp.ids))
 		return 0;
 
-	len = snprintf(modalias, size, "acpi:");
-	size -= len;
+	/*
+	 * If the device has PRP0001 we expose DT compatible modalias
+	 * instead.
+	 */
+	if (acpi_dev->data.of_compatible) {
+		const union acpi_object *of_compatible, *obj;
+		int i;
+
+		len = snprintf(modalias, size, "of:Nprp0001Tacpi");
+
+		of_compatible = acpi_dev->data.of_compatible;
+		for (i = 0; i < of_compatible->package.count; i++) {
+			obj = &of_compatible->package.elements[i];
+
+			count = snprintf(&modalias[len], size, "C%s",
+					 obj->string.pointer);
+			if (count < 0)
+				return -EINVAL;
+			if (count >= size)
+				return -ENOMEM;
+
+			len += count;
+			size -= count;
+		}
+	} else {
+		len = snprintf(modalias, size, "acpi:");
+		size -= len;
 
-	list_for_each_entry(id, &acpi_dev->pnp.ids, list) {
-		count = snprintf(&modalias[len], size, "%s:", id->id);
-		if (count < 0)
-			return -EINVAL;
-		if (count >= size)
-			return -ENOMEM;
-		len += count;
-		size -= count;
+		list_for_each_entry(id, &acpi_dev->pnp.ids, list) {
+			count = snprintf(&modalias[len], size, "%s:", id->id);
+			if (count < 0)
+				return -EINVAL;
+			if (count >= size)
+				return -ENOMEM;
+			len += count;
+			size -= count;
+		}
 	}
 
 	modalias[len] = '\0';
@@ -864,6 +890,51 @@ int acpi_match_device_ids(struct acpi_de
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
+/* Performs match for special "PRP0001" shoehorn ACPI ID */
+static bool acpi_of_driver_match_device(struct device *dev,
+					const struct device_driver *drv)
+{
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	const union acpi_object *of_compatible;
+	int i;
+
+	/*
+	 * If the ACPI device does not have corresponding compatible
+	 * property or the driver in question does not have DT matching
+	 * table we consider the match succesful (matches the ACPI ID).
+	 */
+	of_compatible = adev->data.of_compatible;
+	if (!drv->of_match_table || !of_compatible)
+		return true;
+
+	/* Now we can look for the driver DT compatible strings */
+	for (i = 0; i < of_compatible->package.count; i++) {
+		const struct of_device_id *id;
+		const union acpi_object *obj;
+
+		obj = &of_compatible->package.elements[i];
+
+		for (id = drv->of_match_table; id->compatible[0]; id++)
+			if (!strcasecmp(obj->string.pointer, id->compatible))
+				return true;
+	}
+
+	return false;
+}
+
+bool acpi_driver_match_device(struct device *dev,
+			      const struct device_driver *drv)
+{
+	const struct acpi_device_id *id;
+
+	id = acpi_match_device(drv->acpi_match_table, dev);
+	if (!id)
+		return false;
+
+	return acpi_of_driver_match_device(dev, drv);
+}
+EXPORT_SYMBOL_GPL(acpi_driver_match_device);
+
 static void acpi_free_power_resources_lists(struct acpi_device *device)
 {
 	int i;
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -341,6 +341,7 @@ struct acpi_device_physical_node {
 struct acpi_device_data {
 	const union acpi_object *pointer;
 	const union acpi_object *properties;
+	const union acpi_object *of_compatible;
 };
 
 /* Device */
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -424,12 +424,8 @@ extern int acpi_nvs_for_each_region(int
 const struct acpi_device_id *acpi_match_device(const struct acpi_device_id *ids,
 					       const struct device *dev);
 
-static inline bool acpi_driver_match_device(struct device *dev,
-					    const struct device_driver *drv)
-{
-	return !!acpi_match_device(drv->acpi_match_table, dev);
-}
-
+extern bool acpi_driver_match_device(struct device *dev,
+				     const struct device_driver *drv);
 int acpi_device_uevent_modalias(struct device *, struct kobj_uevent_env *);
 int acpi_device_modalias(struct device *, char *, int);
 

