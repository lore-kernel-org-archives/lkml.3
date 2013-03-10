Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3CJNc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 09:32:57 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1028 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3CJNcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 09:32:39 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5425
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 3/5] power: sbs-battery: Use dev_pm_ops
Date: Sun, 10 Mar 2013 14:34:07 +0100
Message-Id: <1362922449-27531-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362922449-27531-1-git-send-email-lars@metafoo.de>
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Cc: Rhyland Klein <rklein@nvidia.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/sbs-battery.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 3960f0b..6a2e335 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -820,10 +820,11 @@ static int sbs_remove(struct i2c_client *client)
 	return 0;
 }
 
-#if defined CONFIG_PM
-static int sbs_suspend(struct i2c_client *client,
-	pm_message_t state)
+#if defined CONFIG_PM_SLEEP
+
+static int sbs_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct sbs_info *chip = i2c_get_clientdata(client);
 	s32 ret;
 
@@ -838,11 +839,13 @@ static int sbs_suspend(struct i2c_client *client,
 
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(sbs_pm_ops, sbs_suspend, NULL);
+#define SBS_PM_OPS (&sbs_pm_ops)
+
 #else
-#define sbs_suspend		NULL
+#define SBS_PM_OPS NULL
 #endif
-/* any smbus transaction will wake up sbs */
-#define sbs_resume		NULL
 
 static const struct i2c_device_id sbs_id[] = {
 	{ "bq20z75", 0 },
@@ -854,12 +857,11 @@ MODULE_DEVICE_TABLE(i2c, sbs_id);
 static struct i2c_driver sbs_battery_driver = {
 	.probe		= sbs_probe,
 	.remove		= sbs_remove,
-	.suspend	= sbs_suspend,
-	.resume		= sbs_resume,
 	.id_table	= sbs_id,
 	.driver = {
 		.name	= "sbs-battery",
 		.of_match_table = sbs_dt_ids,
+		.pm	= SBS_PM_OPS,
 	},
 };
 module_i2c_driver(sbs_battery_driver);
-- 
1.8.0

