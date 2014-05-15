Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaEOGpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:45:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:40282 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbaEOGpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="532238488"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V6 11/11] ACPI: introduce acpi platform exclude id list
Date: Thu, 15 May 2014 14:44:16 +0800
Message-Id: <1400136256-2218-12-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For ACPI PIC (PNP0000), Timer (PNP0100) and DMA controller (PNP0200)
device objects, although they have _HID control method, but they
should not be enumerated to platform bus, because there will never be
any platform drivers for them.

Thus an exclude id list is introduced in this patch to prevent
those platform device nodes from being created.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_platform.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index 33376a9..db89480 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -22,6 +22,18 @@
 
 ACPI_MODULE_NAME("platform");
 
+static const struct acpi_device_id excluded_id_list[] = {
+	{"PNP0000", 0},	/* PIC */
+	{"PNP0100", 0},	/* Timer */
+	{"PNP0200", 0}, /* AT DMA Controller */
+	{"", 0},
+};
+
+static bool is_exclusive_device(struct acpi_device *dev)
+{
+	return !acpi_match_device_ids(dev, excluded_id_list);
+}
+
 /**
  * acpi_create_platform_device - Create platform device for ACPI device node
  * @adev: ACPI device node to create a platform device for.
@@ -48,6 +60,9 @@ int acpi_create_platform_device(struct acpi_device *adev,
 	if (adev->physical_node_count)
 		return 0;
 
+	if (is_exclusive_device(adev))
+		return 0;
+
 	INIT_LIST_HEAD(&resource_list);
 	count = acpi_dev_get_resources(adev, &resource_list, NULL, NULL);
 	if (count < 0) {
-- 
1.8.3.2

