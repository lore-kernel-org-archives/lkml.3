Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbaAKACn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 19:02:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:27945 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaAKACi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 19:02:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,640,1384329600"; 
   d="scan'208";a="464957610"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: rafael.j.wysocki@intel.com
Cc: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [PATCH] ACPI/SCAN: _STA status read
Date: Fri, 10 Jan 2014 16:00:05 -0800
Message-Id: <1389398405-1970-1-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a "status" attribute for an acpi device. This status
attribute shows the value of _STA object. The _STA object returns
current status of an ACPI device to show enabled, disabled or removed.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/acpi/scan.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index fd39459..a5f4a60 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -567,6 +567,20 @@ acpi_device_sun_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(sun, 0444, acpi_device_sun_show, NULL);
 
+static ssize_t status_show(struct device *dev, struct device_attribute *attr,
+				char *buf) {
+	struct acpi_device *acpi_dev = to_acpi_device(dev);
+	acpi_status status;
+	unsigned long long sta;
+
+	status = acpi_evaluate_integer(acpi_dev->handle, "_STA", NULL, &sta);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	return sprintf(buf, "%llu\n", sta);
+}
+static DEVICE_ATTR_RO(status);
+
 static int acpi_device_setup_files(struct acpi_device *dev)
 {
 	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
@@ -622,6 +636,12 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 		dev->pnp.sun = (unsigned long)-1;
 	}
 
+	if (acpi_has_method(dev->handle, "_STA")) {
+		result = device_create_file(&dev->dev, &dev_attr_status);
+		if (result)
+			goto end;
+	}
+
         /*
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
@@ -677,6 +697,8 @@ static void acpi_device_remove_files(struct acpi_device *dev)
 		device_remove_file(&dev->dev, &dev_attr_adr);
 	device_remove_file(&dev->dev, &dev_attr_modalias);
 	device_remove_file(&dev->dev, &dev_attr_hid);
+	if (acpi_has_method(dev->handle, "_STA"))
+		device_remove_file(&dev->dev, &dev_attr_status);
 	if (dev->handle)
 		device_remove_file(&dev->dev, &dev_attr_path);
 }
-- 
1.8.3.1

