Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbaCPREx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 13:04:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:56398 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108AbaCPREL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 13:04:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,665,1389772800"; 
   d="scan'208";a="501094245"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V3 09/11] ACPI: introduce acpi platform exclude id list
Date: Mon, 17 Mar 2014 01:03:15 +0800
Message-Id: <1394989397-2733-10-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394989397-2733-1-git-send-email-rui.zhang@intel.com>
References: <1394989397-2733-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ACPI PIC (PNP0000) and Timer (PNP0100) device objects, although
they have _HID control method, but they should not be enumerated to
platform bus, because there will never be any platform drivers for them.

Thus an exclude id list is introduced in this patch to prevent
those platform device nodes from being created.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_platform.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index 33376a9..0cf291e 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -22,6 +22,17 @@
 
 ACPI_MODULE_NAME("platform");
 
+static const struct acpi_device_id excluded_id_list[] = {
+	{"PNP0000", 0},	/* PIC */
+	{"PNP0100", 0},	/* Timer */
+	{"", 0},
+};
+
+static bool is_exclusive_device(struct acpi_device *dev)
+{
+	return (!acpi_match_device_ids(dev, excluded_id_list));
+}
+
 /**
  * acpi_create_platform_device - Create platform device for ACPI device node
  * @adev: ACPI device node to create a platform device for.
@@ -48,6 +59,9 @@ int acpi_create_platform_device(struct acpi_device *adev,
 	if (adev->physical_node_count)
 		return 0;
 
+	if (is_exclusive_device(adev))
+		return 0;
+
 	INIT_LIST_HEAD(&resource_list);
 	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
 	if (count < 0) {
-- 
1.7.9.5

