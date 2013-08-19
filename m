Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265Ab3HSLBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:01:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:3441 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab3HSLBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:01:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,912,1367996400"; 
   d="scan'208";a="383020254"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] HID: i2c-hid: use correct type for ACPI _DSM parameter
Date: Mon, 19 Aug 2013 14:01:17 +0300
Message-Id: <1376910077-24433-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI 5.0 specification requires the fourth parameter to the _DSM (Device
Specific Method) to be of type package instead of integer. Failing to do
that we get following warning on the console:

  ACPI Warning: \_SB_.PCI0.I2C1.TPL0._DSM: Argument #4 type mismatch - Found [Integer],
                ACPI requires [Package] (20130517/nsarguments-95)

Fix this by passing an empty package to the _DSM method. The HID over I2C
specification doesn't require any specific values to be passed with this
parameter.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 879b0ed..d2e0eea 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -897,8 +897,9 @@ static int i2c_hid_acpi_pdata(struct i2c_client *client,
 	params[1].integer.value = 1;
 	params[2].type = ACPI_TYPE_INTEGER;
 	params[2].integer.value = 1; /* HID function */
-	params[3].type = ACPI_TYPE_INTEGER;
-	params[3].integer.value = 0;
+	params[3].type = ACPI_TYPE_PACKAGE;
+	params[3].package.count = 0;
+	params[3].package.elements = NULL;
 
 	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DSM", &input, &buf))) {
 		dev_err(&client->dev, "device _DSM execution failed\n");
-- 
1.8.4.rc2

