Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3CJNcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:32:47 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1076 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3CJNci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:32:38 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5425
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Minkyu Kang <mk7.kang@samsung.com>
Subject: [PATCH 2/5] power: max17040_battery: Use dev_pm_ops
Date: Sun, 10 Mar 2013 14:34:06 +0100
Message-Id: <1362922449-27531-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362922449-27531-1-git-send-email-lars@metafoo.de>
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Cc: Minkyu Kang <mk7.kang@samsung.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/max17040_battery.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 74a0bd9..4e698d8 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -246,31 +246,34 @@ static int max17040_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
-static int max17040_suspend(struct i2c_client *client,
-		pm_message_t state)
+static int max17040_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct max17040_chip *chip = i2c_get_clientdata(client);
 
 	cancel_delayed_work(&chip->work);
 	return 0;
 }
 
-static int max17040_resume(struct i2c_client *client)
+static int max17040_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct max17040_chip *chip = i2c_get_clientdata(client);
 
 	schedule_delayed_work(&chip->work, MAX17040_DELAY);
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
+#define MAX17040_PM_OPS (&max17040_pm_ops)
+
 #else
 
-#define max17040_suspend NULL
-#define max17040_resume NULL
+#define MAX17040_PM_OPS NULL
 
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
@@ -278,14 +281,14 @@ static const struct i2c_device_id max17040_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
 
+
 static struct i2c_driver max17040_i2c_driver = {
 	.driver	= {
 		.name	= "max17040",
+		.pm	= MAX17040_PM_OPS,
 	},
 	.probe		= max17040_probe,
 	.remove		= max17040_remove,
-	.suspend	= max17040_suspend,
-	.resume		= max17040_resume,
 	.id_table	= max17040_id,
 };
 module_i2c_driver(max17040_i2c_driver);
-- 
1.8.0

