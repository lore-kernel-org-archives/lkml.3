Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBOAii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:38:38 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59287 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752440AbaBOAih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:38:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / dock: Make 'docked' sysfs attribute work as documented
Date: Sat, 15 Feb 2014 01:53:20 +0100
Message-ID: <2379022.bUy4KDZIf7@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After recent ACPI core changes acpi_bus_get_device() will always
succeed for dock station ACPI device objects, so show_docked()
should not use that function's return value as an indicator of
whether or not the dock device is present.

Make it use acpi_device_enumerated() for this purpose.

Fixes: 202317a573b2 (ACPI / scan: Add acpi_device objects for all device nodes in the namespace)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

3.14 material overlooked previously.

And I actually was able to test this one some. :-)

Thanks,
Rafael

---
 drivers/acpi/dock.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -713,13 +713,11 @@ static acpi_status __init find_dock_devi
 static ssize_t show_docked(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
-	struct acpi_device *tmp;
-
 	struct dock_station *dock_station = dev->platform_data;
+	struct acpi_device *adev = NULL;
 
-	if (!acpi_bus_get_device(dock_station->handle, &tmp))
-		return snprintf(buf, PAGE_SIZE, "1\n");
-	return snprintf(buf, PAGE_SIZE, "0\n");
+	acpi_bus_get_device(dock_station->handle, &adev);
+	return snprintf(buf, PAGE_SIZE, "%u\n", acpi_device_enumerated(adev));
 }
 static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 

