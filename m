Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab3GVXmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:42:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:8346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3GVXmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:42:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,722,1367996400"; 
   d="scan'208";a="369385915"
From: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, linux-kernel@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH v1 1/1] ACPI: Allow platform device creation without any IO resource
Date: Mon, 22 Jul 2013 16:51:20 -0700
Message-Id: <91404e863a8ce7bc9a757a085dea0c2a8a9b7986.1374536906.git.sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ACPI platform device creation is aborted when there
are no valid IO resources. This approach will not work if the
device has only GPIO as its resource or some custom resources.
So this patch removes zero resource check and allows platform
device creation even without any valid IO resource.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 drivers/acpi/acpi_platform.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index fafec5d..32136b8 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -52,7 +52,7 @@ int acpi_create_platform_device(struct acpi_device *adev,
 	struct platform_device_info pdevinfo;
 	struct resource_list_entry *rentry;
 	struct list_head resource_list;
-	struct resource *resources;
+	struct resource *resources = NULL;
 	int count;
 
 	/* If the ACPI node already has a physical device attached, skip it. */
@@ -61,9 +61,12 @@ int acpi_create_platform_device(struct acpi_device *adev,
 
 	INIT_LIST_HEAD(&resource_list);
 	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
-	if (count <= 0)
+	if (count < 0)
 		return 0;
 
+	if (!count)
+		goto create_dev;
+
 	resources = kmalloc(count * sizeof(struct resource), GFP_KERNEL);
 	if (!resources) {
 		dev_err(&adev->dev, "No memory for resources\n");
@@ -76,6 +79,7 @@ int acpi_create_platform_device(struct acpi_device *adev,
 
 	acpi_dev_free_resource_list(&resource_list);
 
+create_dev:
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
 	/*
 	 * If the ACPI node has a parent and that parent has a physical device
-- 
1.7.9.5

