Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935363Ab3DKJ0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:26:18 -0400
Received: from smtp-out-204.synserver.de ([212.40.185.204]:1034 "EHLO
	smtp-out-204.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765434Ab3DKJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:25:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10881
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Hong Liu <hong.liu@intel.com>
Subject: [PATCH 1/4] misc: apds9802als: Fix suspend/resume
Date: Thu, 11 Apr 2013 11:24:39 +0200
Message-Id: <1365672282-10449-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The apds9802als driver implements runtime pm and at the same time uses the
legacy pm callbacks for suspend and resume. This does not work since the i2c
core wont look at the legacy pm callbacks if a driver has the 'pm' field set.
This patch fixes it by moving over to dev_pm_ops for suspend/resume as well.
Since both runtime pm and suspend/resume behave the same way this can easily be
done using the UNIVERSAL_DEV_PM_OPS macro.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Hong Liu <hong.liu@intel.com>
---
 drivers/misc/apds9802als.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index d648b08..5b5fd84 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -272,19 +272,8 @@ static int apds9802als_remove(struct i2c_client *client)
 }
 
 #ifdef CONFIG_PM
-static int apds9802als_suspend(struct i2c_client *client, pm_message_t mesg)
-{
-	als_set_power_state(client, false);
-	return 0;
-}
-
-static int apds9802als_resume(struct i2c_client *client)
-{
-	als_set_default_config(client);
-	return 0;
-}
 
-static int apds9802als_runtime_suspend(struct device *dev)
+static int apds9802als_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 
@@ -292,7 +281,7 @@ static int apds9802als_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int apds9802als_runtime_resume(struct device *dev)
+static int apds9802als_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 
@@ -300,16 +289,12 @@ static int apds9802als_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static const struct dev_pm_ops apds9802als_pm_ops = {
-	.runtime_suspend = apds9802als_runtime_suspend,
-	.runtime_resume = apds9802als_runtime_resume,
-};
+static UNIVERSAL_DEV_PM_OPS(apds9802als_pm_ops, apds9802als_suspend,
+	apds9802als_resume, NULL);
 
 #define APDS9802ALS_PM_OPS (&apds9802als_pm_ops)
 
 #else	/* CONFIG_PM */
-#define apds9802als_suspend NULL
-#define apds9802als_resume NULL
 #define APDS9802ALS_PM_OPS NULL
 #endif	/* CONFIG_PM */
 
@@ -327,8 +312,6 @@ static struct i2c_driver apds9802als_driver = {
 	},
 	.probe = apds9802als_probe,
 	.remove = apds9802als_remove,
-	.suspend = apds9802als_suspend,
-	.resume = apds9802als_resume,
 	.id_table = apds9802als_id,
 };
 
-- 
1.8.0

