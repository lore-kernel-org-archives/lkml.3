Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AVCWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:22:55 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49000 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab3AVCWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:22:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH 1/4] ACPI / PM: Expose power states of ACPI devices to user space
Date: Tue, 22 Jan 2013 03:25:15 +0100
Message-ID: <4706454.hY2fLkUfhN@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2760421.6nE3tkh92K@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <4247313.2G7Z3nCgM0@vostro.rjw.lan> <2760421.6nE3tkh92K@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make it possible to retrieve the current power state of a device with
ACPI power management from user space via sysfs by adding two new
attributes, power_state and real_power_state, to the sysfs directory
associated with the struct acpi_device object representing the
device's ACPI node.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-power_state      |   20 ++++++
 Documentation/ABI/testing/sysfs-devices-real_power_state |   23 +++++++
 drivers/acpi/scan.c                                      |   49 ++++++++++++++-
 3 files changed, 91 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -178,6 +178,32 @@ err_out:
 }
 EXPORT_SYMBOL(acpi_bus_hot_remove_device);
 
+static ssize_t real_power_state_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(dev);
+	int state;
+	int ret;
+
+	ret = acpi_device_get_power(adev, &state);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%s\n", acpi_power_state_string(state));
+}
+
+static DEVICE_ATTR(real_power_state, 0444, real_power_state_show, NULL);
+
+static ssize_t power_state_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(dev);
+
+	return sprintf(buf, "%s\n", acpi_power_state_string(adev->power.state));
+}
+
+static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
+
 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
 		const char *buf, size_t count)
@@ -369,8 +395,22 @@ static int acpi_device_setup_files(struc
          * hot-removal function from userland.
          */
 	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
-	if (ACPI_SUCCESS(status))
+	if (ACPI_SUCCESS(status)) {
 		result = device_create_file(&dev->dev, &dev_attr_eject);
+		if (result)
+			return result;
+	}
+
+	if (dev->flags.power_manageable) {
+		result = device_create_file(&dev->dev, &dev_attr_power_state);
+		if (result)
+			return result;
+
+		if (dev->power.flags.power_resources)
+			result = device_create_file(&dev->dev,
+						    &dev_attr_real_power_state);
+	}
+
 end:
 	return result;
 }
@@ -380,6 +420,13 @@ static void acpi_device_remove_files(str
 	acpi_status status;
 	acpi_handle temp;
 
+	if (dev->flags.power_manageable) {
+		device_remove_file(&dev->dev, &dev_attr_power_state);
+		if (dev->power.flags.power_resources)
+			device_remove_file(&dev->dev,
+					   &dev_attr_real_power_state);
+	}
+
 	/*
 	 * If device has _STR, remove 'description' file
 	 */
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power_state
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power_state
@@ -0,0 +1,20 @@
+What:		/sys/devices/.../power_state
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../power_state attribute is only present for
+		device objects representing ACPI device nodes that provide power
+		management methods.
+
+		If present, it contains a string representing the current ACPI
+		power state of the given device node.  Its possible values,
+		"D0", "D1", "D2", "D3hot", and "D3cold", reflect the power state
+		names defined by the ACPI specification (ACPI 4 and above).
+
+		If the device node uses shared ACPI power resources, this state
+		determines a list of power resources required not to be turned
+		off.  However, some power resources needed by the device node in
+		higher-power (lower-number) states may also be ON because of
+		some other devices using them at the moment.
+
+		This attribute is read-only.
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-real_power_state
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-real_power_state
@@ -0,0 +1,23 @@
+What:		/sys/devices/.../real_power_state
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../real_power_state attribute is only present
+		for device objects representing ACPI device nodes that provide
+		power management methods and use ACPI power resources for power
+		management.
+
+		If present, it contains a string representing the real ACPI
+		power state of the given device node as returned by the _PSC
+		control method or inferred from the configuration of power
+		resources.  Its possible values, "D0", "D1", "D2", "D3hot", and
+		"D3cold", reflect the power state names defined by the ACPI
+		specification (ACPI 4 and above).
+
+		In some situations the value of this attribute may be different
+		from the value of the /sys/devices/.../power_state attribute for
+		the same device object.  If that happens, some shared power
+		resources used by the device node are only ON because of some
+		other devices using them at the moment.
+
+		This attribute is read-only.

