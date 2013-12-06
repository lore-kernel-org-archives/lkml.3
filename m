Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3LFIdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:33:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:3378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab3LFIdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:33:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="447864750"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Update PATCH] ACPI/Button: Fix enable Button GPEs twice
Date: Fri,  6 Dec 2013 16:32:40 +0800
Message-Id: <1386318760-5887-1-git-send-email-tianyu.lan@intel.com>
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
Update:
	fix a typo, sorry for noise.

 drivers/acpi/button.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 9e3a6cb..6643f2d 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -406,15 +406,9 @@ static int acpi_button_add(struct acpi_device *device)
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
+	/* Button GPEs have been enabled in the acpi_wakeup_device_list()*/
+	if (device->wakeup.flags.valid)
+		button->wakeup_enabled = true;
 
 	printk(KERN_INFO PREFIX "%s [%s]\n", name, acpi_device_bid(device));
 	return 0;
-- 
1.8.2.1

