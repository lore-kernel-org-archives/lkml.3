Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3KWTDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 14:03:36 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54294 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KWTDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 14:03:30 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3/5] compal-laptop: Use devm_kzalloc to allocate local data structure
Date: Sat, 23 Nov 2013 11:03:19 -0800
Message-Id: <1385233401-21517-4-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
References: <1385233401-21517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce code size and simplify error path.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/platform/x86/compal-laptop.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 8b119a7..9deb035 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -1026,24 +1026,21 @@ static int compal_probe(struct platform_device *pdev)
 		return 0;
 
 	/* Fan control */
-	data = kzalloc(sizeof(struct compal_data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(struct compal_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
 	initialize_fan_control_data(data);
 
 	err = sysfs_create_group(&pdev->dev.kobj, &compal_attribute_group);
-	if (err) {
-		kfree(data);
+	if (err)
 		return err;
-	}
 
 	data->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(data->hwmon_dev)) {
 		err = PTR_ERR(data->hwmon_dev);
 		sysfs_remove_group(&pdev->dev.kobj,
 				&compal_attribute_group);
-		kfree(data);
 		return err;
 	}
 
@@ -1083,8 +1080,6 @@ static int compal_remove(struct platform_device *pdev)
 	hwmon_device_unregister(data->hwmon_dev);
 	power_supply_unregister(&data->psy);
 
-	kfree(data);
-
 	sysfs_remove_group(&pdev->dev.kobj, &compal_attribute_group);
 
 	return 0;
-- 
1.7.9.7

