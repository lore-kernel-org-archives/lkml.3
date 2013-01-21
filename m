Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3AUNDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:03:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48215 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab3AUNC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:02:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC][Update 2][PATCH 1/4] ACPI / PM: Export power states of ACPI devices via sysfs
Date: Mon, 21 Jan 2013 14:04:32 +0100
Message-ID: <1783611.vYsnfNDZr6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <4247313.2G7Z3nCgM0@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <2096792.ELJ8WGVaaz@vostro.rjw.lan> <4247313.2G7Z3nCgM0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make it possible to retrieve the current power state of a device with
ACPI power management from user space via sysfs by adding a new
attribute power_state to the sysfs directory associated with the
struct acpi_device object representing the device's ACPI node.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-power_state |   21 ++++++++++++++
 drivers/acpi/scan.c                                 |   29 +++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -178,6 +178,23 @@ err_out:
 }
 EXPORT_SYMBOL(acpi_bus_hot_remove_device);
 
+static ssize_t power_state_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct acpi_device *adev = to_acpi_device(dev);
+	int state;
+	int ret;
+
+	ret = acpi_device_get_power(adev, &state);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%s %s\n", acpi_power_state_string(state),
+		       acpi_power_state_string(adev->power.state));
+}
+
+static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
+
 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
 		const char *buf, size_t count)
@@ -369,8 +386,15 @@ static int acpi_device_setup_files(struc
          * hot-removal function from userland.
          */
 	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
-	if (ACPI_SUCCESS(status))
+	if (ACPI_SUCCESS(status)) {
 		result = device_create_file(&dev->dev, &dev_attr_eject);
+		if (result)
+			goto end;
+	}
+
+	if (dev->flags.power_manageable)
+		result = device_create_file(&dev->dev, &dev_attr_power_state);
+
 end:
 	return result;
 }
@@ -380,6 +404,9 @@ static void acpi_device_remove_files(str
 	acpi_status status;
 	acpi_handle temp;
 
+	if (dev->flags.power_manageable)
+		device_remove_file(&dev->dev, &dev_attr_power_state);
+
 	/*
 	 * If device has _STR, remove 'description' file
 	 */
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power_state
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power_state
@@ -0,0 +1,21 @@
+What:		/sys/devices/.../power_state
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../power_state attribute is only present for
+		device objects representing ACPI device nodes that provide power
+		management methods.
+
+		If present, it contains a pair of strings representing the
+		current ACPI power state of the given device node and the ACPI
+		power state the device node would be in if it did not share
+		power resources with other device nodes, respectively.  If the
+		given device node does not share power resources with other
+		device nodes or it does not use power resource objects for power
+		management, the strings are always the same.
+
+		For each of the strings the possible values are "D0", "D1",
+		"D2", "D3hot", and "D3cold" which reflect the power state names
+		defined by the ACPI specification (4.0 and above).
+
+		This attribute is read-only.

