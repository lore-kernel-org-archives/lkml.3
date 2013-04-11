Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461Ab3DKJ0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:26:20 -0400
Received: from smtp-out-204.synserver.de ([212.40.185.204]:1024 "EHLO
	smtp-out-204.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765335Ab3DKJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:25:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10881
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 4/4] misc: tsl2550: Use dev_pm_ops
Date: Thu, 11 Apr 2013 11:24:42 +0200
Message-Id: <1365672282-10449-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1365672282-10449-1-git-send-email-lars@metafoo.de>
References: <1365672282-10449-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Rodolfo Giometti <giometti@enneenne.com>
---
 drivers/misc/tsl2550.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/tsl2550.c b/drivers/misc/tsl2550.c
index 1e7bc0e..1dfde4d 100644
--- a/drivers/misc/tsl2550.c
+++ b/drivers/misc/tsl2550.c
@@ -417,24 +417,26 @@ static int tsl2550_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
-static int tsl2550_suspend(struct i2c_client *client, pm_message_t mesg)
+static int tsl2550_suspend(struct device *dev)
 {
-	return tsl2550_set_power_state(client, 0);
+	return tsl2550_set_power_state(to_i2c_client(dev), 0);
 }
 
-static int tsl2550_resume(struct i2c_client *client)
+static int tsl2550_resume(struct device *dev)
 {
-	return tsl2550_set_power_state(client, 1);
+	return tsl2550_set_power_state(to_i2c_client(dev), 1);
 }
 
+static SIMPLE_DEV_PM_OPS(tsl2550_pm_ops, tsl2550_suspend, tsl2550_resume);
+#define TSL2550_PM_OPS (&tsl2550_pm_ops)
+
 #else
 
-#define tsl2550_suspend		NULL
-#define tsl2550_resume		NULL
+#define TSL2550_PM_OPS NULL
 
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static const struct i2c_device_id tsl2550_id[] = {
 	{ "tsl2550", 0 },
@@ -446,9 +448,8 @@ static struct i2c_driver tsl2550_driver = {
 	.driver = {
 		.name	= TSL2550_DRV_NAME,
 		.owner	= THIS_MODULE,
+		.pm	= TSL2550_PM_OPS,
 	},
-	.suspend = tsl2550_suspend,
-	.resume	= tsl2550_resume,
 	.probe	= tsl2550_probe,
 	.remove	= tsl2550_remove,
 	.id_table = tsl2550_id,
-- 
1.8.0

