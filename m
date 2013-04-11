Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935177Ab3DKJZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:25:49 -0400
Received: from smtp-out-204.synserver.de ([212.40.185.204]:1096 "EHLO
	smtp-out-204.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765270Ab3DKJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:25:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10881
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Mack <daniel@caiaq.de>
Subject: [PATCH 3/4] misc: isl29003: Use dev_pm_ops
Date: Thu, 11 Apr 2013 11:24:41 +0200
Message-Id: <1365672282-10449-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1365672282-10449-1-git-send-email-lars@metafoo.de>
References: <1365672282-10449-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Daniel Mack <daniel@caiaq.de>
---
 drivers/misc/isl29003.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index 29b306c..c5145b3 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -409,18 +409,20 @@ static int isl29003_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int isl29003_suspend(struct i2c_client *client, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+static int isl29003_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct isl29003_data *data = i2c_get_clientdata(client);
 
 	data->power_state_before_suspend = isl29003_get_power_state(client);
 	return isl29003_set_power_state(client, 0);
 }
 
-static int isl29003_resume(struct i2c_client *client)
+static int isl29003_resume(struct device *dev)
 {
 	int i;
+	struct i2c_client *client = to_i2c_client(dev);
 	struct isl29003_data *data = i2c_get_clientdata(client);
 
 	/* restore registers from cache */
@@ -432,10 +434,12 @@ static int isl29003_resume(struct i2c_client *client)
 		data->power_state_before_suspend);
 }
 
+static SIMPLE_DEV_PM_OPS(isl29003_pm_ops, isl29003_suspend, isl29003_resume);
+#define ISL29003_PM_OPS (&isl29003_pm_ops)
+
 #else
-#define isl29003_suspend	NULL
-#define isl29003_resume		NULL
-#endif /* CONFIG_PM */
+#define ISL29003_PM_OPS NULL
+#endif /* CONFIG_PM_SLEEP */
 
 static const struct i2c_device_id isl29003_id[] = {
 	{ "isl29003", 0 },
@@ -447,9 +451,8 @@ static struct i2c_driver isl29003_driver = {
 	.driver = {
 		.name	= ISL29003_DRV_NAME,
 		.owner	= THIS_MODULE,
+		.pm	= ISL29003_PM_OPS,
 	},
-	.suspend = isl29003_suspend,
-	.resume	= isl29003_resume,
 	.probe	= isl29003_probe,
 	.remove	= isl29003_remove,
 	.id_table = isl29003_id,
-- 
1.8.0

