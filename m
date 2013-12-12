Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3LLKI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 05:08:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:37252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3LLKI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 05:08:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,877,1378882800"; 
   d="scan'208";a="448864383"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, aaron.lu@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2] ACPI/Button: Fix enable Button GPEs twice
Date: Thu, 12 Dec 2013 18:08:17 +0800
Message-Id: <1386842897-7954-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Button GPEs have been enabled in the acpi_wake_device_init() during
boot and Button driver enables these GPEs second time. This causes
disabling these gpes via sysfs interface requires twice "echo disable
> /sys/firmware/acpi/interrupts/gpeXXX". This patch is to remove
related code in the Button driver.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
Change since V1:
	Remove wakeup_enabled flag and disable gpe operation
in the acpi_button_remove().

 drivers/acpi/button.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 9e3a6cb..11c11f6 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -100,7 +100,6 @@ struct acpi_button {
 	struct input_dev *input;
 	char phys[32];			/* for input device */
 	unsigned long pushed;
-	bool wakeup_enabled;
 };
 
 static BLOCKING_NOTIFIER_HEAD(acpi_lid_notifier);
@@ -406,16 +405,6 @@ static int acpi_button_add(struct acpi_device *device)
 		lid_device = device;
 	}
 
-	if (device->wakeup.flags.valid) {
-		/* Button's GPE is run-wake GPE */
-		acpi_enable_gpe(device->wakeup.gpe_device,
-				device->wakeup.gpe_number);
-		if (!device_may_wakeup(&device->dev)) {
-			device_set_wakeup_enable(&device->dev, true);
-			button->wakeup_enabled = true;
-		}
-	}
-
 	printk(KERN_INFO PREFIX "%s [%s]\n", name, acpi_device_bid(device));
 	return 0;
 
@@ -432,13 +421,6 @@ static int acpi_button_remove(struct acpi_device *device)
 {
 	struct acpi_button *button = acpi_driver_data(device);
 
-	if (device->wakeup.flags.valid) {
-		acpi_disable_gpe(device->wakeup.gpe_device,
-				device->wakeup.gpe_number);
-		if (button->wakeup_enabled)
-			device_set_wakeup_enable(&device->dev, false);
-	}
-
 	acpi_button_remove_fs(device);
 	input_unregister_device(button->input);
 	kfree(button);
-- 
1.8.2.1

