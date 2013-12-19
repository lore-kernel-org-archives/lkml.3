Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3LSMoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:44:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:26542 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab3LSMoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:44:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="427188136"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [Patch v2 10/13] ACPI, i2c-hid: replace open-coded _DSM specific code with helper functions
Date: Thu, 19 Dec 2013 20:38:19 +0800
Message-Id: <1387456702-4709-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper functions to simplify _DSM related code in i2c-hid driver.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/hid/i2c-hid/i2c-hid.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 5f7e55f..d22668f 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -850,37 +850,23 @@ static int i2c_hid_acpi_pdata(struct i2c_client *client,
 		0xF7, 0xF6, 0xDF, 0x3C, 0x67, 0x42, 0x55, 0x45,
 		0xAD, 0x05, 0xB3, 0x0A, 0x3D, 0x89, 0x38, 0xDE,
 	};
-	union acpi_object params[4];
-	struct acpi_object_list input;
+	union acpi_object *obj;
 	struct acpi_device *adev;
-	unsigned long long value;
 	acpi_handle handle;
 
 	handle = ACPI_HANDLE(&client->dev);
 	if (!handle || acpi_bus_get_device(handle, &adev))
 		return -ENODEV;
 
-	input.count = ARRAY_SIZE(params);
-	input.pointer = params;
-
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = sizeof(i2c_hid_guid);
-	params[0].buffer.pointer = i2c_hid_guid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = 1;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = 1; /* HID function */
-	params[3].type = ACPI_TYPE_PACKAGE;
-	params[3].package.count = 0;
-	params[3].package.elements = NULL;
-
-	if (ACPI_FAILURE(acpi_evaluate_integer(handle, "_DSM", &input,
-								&value))) {
+	obj = acpi_evaluate_dsm_typed(handle, i2c_hid_guid, 1, 1, NULL,
+				      ACPI_TYPE_INTEGER);
+	if (!obj) {
 		dev_err(&client->dev, "device _DSM execution failed\n");
 		return -ENODEV;
 	}
 
-	pdata->hid_descriptor_address = value;
+	pdata->hid_descriptor_address = obj->integer.value;
+	ACPI_FREE(obj);
 
 	return 0;
 }
-- 
1.7.10.4

