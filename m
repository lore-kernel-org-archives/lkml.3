Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3HEOE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:04:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56612 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab3HEOE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:04:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / platform: Drop unnecessary label
Date: Mon, 05 Aug 2013 16:15:13 +0200
Message-ID: <1419437.ogYYmboGdh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The create_dev label in acpi_create_platform_device() is not
necessary, because the if statement causing the jump to it to
happen may be rearranged to avoid that jump.

Rework the code accordingly (no functional changes should result
from that).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

For 3.12, on top of linux-next.

Thanks,
Rafael

---
 drivers/acpi/acpi_platform.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

Index: linux-pm/drivers/acpi/acpi_platform.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_platform.c
+++ linux-pm/drivers/acpi/acpi_platform.c
@@ -61,25 +61,23 @@ int acpi_create_platform_device(struct a
 
 	INIT_LIST_HEAD(&resource_list);
 	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
-	if (count < 0)
+	if (count < 0) {
 		return 0;
+	} else if (count > 0) {
+		resources = kmalloc(count * sizeof(struct resource),
+				    GFP_KERNEL);
+		if (!resources) {
+			dev_err(&adev->dev, "No memory for resources\n");
+			acpi_dev_free_resource_list(&resource_list);
+			return -ENOMEM;
+		}
+		count = 0;
+		list_for_each_entry(rentry, &resource_list, node)
+			resources[count++] = rentry->res;
 
-	if (!count)
-		goto create_dev;
-
-	resources = kmalloc(count * sizeof(struct resource), GFP_KERNEL);
-	if (!resources) {
-		dev_err(&adev->dev, "No memory for resources\n");
 		acpi_dev_free_resource_list(&resource_list);
-		return -ENOMEM;
 	}
-	count = 0;
-	list_for_each_entry(rentry, &resource_list, node)
-		resources[count++] = rentry->res;
-
-	acpi_dev_free_resource_list(&resource_list);
 
-create_dev:
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	/*
 	 * If the ACPI node has a parent and that parent has a physical device

