Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaJGAAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:00:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49482 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752548AbaJFX7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 19:59:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 03/13] ACPI: Allow drivers to match using Device Tree compatible property
Date: Tue, 07 Oct 2014 02:13:29 +0200
Message-ID: <2116772.Bh1c7fVdla@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2660541.BycO7TFnA2@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
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
compatible property using driver's .of_match_table instead if the driver
is missing .acpi_match_table.

If there is a need to distinguish from where the device is enumerated
(DT/ACPI) driver can check dev->of_node or ACPI_COMPATION(dev).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/property.c | 34 +++++++++++++++++
 drivers/acpi/scan.c     | 97 +++++++++++++++++++++++++++++++++++++++++++------
 include/acpi/acpi_bus.h |  1 +
 include/linux/acpi.h    |  8 +---
 4 files changed, 123 insertions(+), 17 deletions(-)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 680f7f1..ff53eb8 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -76,6 +76,37 @@ static bool acpi_properties_format_valid(const union acpi_object *properties)
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
@@ -119,6 +150,8 @@ void acpi_init_properties(struct acpi_device *adev)
 
 		adev->data.pointer = buf.pointer;
 		adev->data.properties = properties;
+
+		acpi_init_of_compatible(adev);
 		return;
 	}
 
@@ -130,6 +163,7 @@ void acpi_init_properties(struct acpi_device *adev)
 void acpi_free_properties(struct acpi_device *adev)
 {
 	ACPI_FREE((void *)adev->data.pointer);
+	adev->data.of_compatible = NULL;
 	adev->data.pointer = NULL;
 	adev->data.properties = NULL;
 }
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 1979ab3..bc999f1 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -124,17 +124,51 @@ static int create_modalias(struct acpi_device *acpi_dev, char *modalias,
 	if (list_empty(&acpi_dev->pnp.ids))
 		return 0;
 
-	len = snprintf(modalias, size, "acpi:");
-	size -= len;
-
-	list_for_each_entry(id, &acpi_dev->pnp.ids, list) {
-		count = snprintf(&modalias[len], size, "%s:", id->id);
-		if (count < 0)
-			return -EINVAL;
-		if (count >= size)
-			return -ENOMEM;
-		len += count;
-		size -= count;
+	/*
+	 * If the device has PRP0001 we expose DT compatible modalias
+	 * instead in form of of:NnameTCcompatible.
+	 */
+	if (acpi_dev->data.of_compatible) {
+		struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
+		const union acpi_object *of_compatible, *obj;
+		char *c;
+		int i;
+
+		acpi_get_name(acpi_dev->handle, ACPI_SINGLE_NAME, &buf);
+		/* DT strings are all in lower case */
+		for (c = buf.pointer; *c != '\0'; c++)
+			*c = tolower(*c);
+
+		len = snprintf(modalias, size, "of:N%sT", (char *)buf.pointer);
+		ACPI_FREE(buf.pointer);
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
+
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
@@ -864,6 +898,47 @@ int acpi_match_device_ids(struct acpi_device *device,
 }
 EXPORT_SYMBOL(acpi_match_device_ids);
 
+/* Performs match against special "PRP0001" shoehorn ACPI ID */
+static bool acpi_of_driver_match_device(struct device *dev,
+					const struct device_driver *drv)
+{
+	const union acpi_object *of_compatible;
+	struct acpi_device *adev;
+	int i;
+
+	adev = ACPI_COMPANION(dev);
+	if (!adev)
+		return false;
+
+	of_compatible = adev->data.of_compatible;
+	if (!drv->of_match_table || !of_compatible)
+		return false;
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
+	if (!drv->acpi_match_table)
+		return acpi_of_driver_match_device(dev, drv);
+
+	return !!acpi_match_device(drv->acpi_match_table, dev);
+}
+EXPORT_SYMBOL_GPL(acpi_driver_match_device);
+
 static void acpi_free_power_resources_lists(struct acpi_device *device)
 {
 	int i;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index f9734fa..98cd723 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -341,6 +341,7 @@ struct acpi_device_physical_node {
 struct acpi_device_data {
 	const union acpi_object *pointer;
 	const union acpi_object *properties;
+	const union acpi_object *of_compatible;
 };
 
 /* Device */
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 18c1bc3..11aa6b8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -424,12 +424,8 @@ extern int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
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
 
-- 
1.9.3


