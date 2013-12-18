Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3LRG6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:58:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:23599 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3LRG6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:58:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666856"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 10/13] ACPI, i2c-hid: replace open-coded _DSM specific code with helper functions
Date: Wed, 18 Dec 2013 14:58:18 +0800
Message-Id: <1387349901-3391-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
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

