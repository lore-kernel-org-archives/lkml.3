Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602Ab3DHH5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:57:16 -0400
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1147 "EHLO
	smtp-out-079.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934587Ab3DHH5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:57:13 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 7532
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] staging: cptm1217: Use dev_pm_ops
Date: Mon,  8 Apr 2013 09:56:07 +0200
Message-Id: <1365407767-16095-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/staging/cptm1217/clearpad_tm1217.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cptm1217/clearpad_tm1217.c b/drivers/staging/cptm1217/clearpad_tm1217.c
index 31fb5d3..e96eee3 100644
--- a/drivers/staging/cptm1217/clearpad_tm1217.c
+++ b/drivers/staging/cptm1217/clearpad_tm1217.c
@@ -557,12 +557,15 @@ fail:
 
 }
 
+#ifdef CONFIG_PM_SLEEP
+
 /*
  * cp_tm1217 suspend
  *
  */
-static int cp_tm1217_suspend(struct i2c_client *client, pm_message_t mesg)
+static int cp_tm1217_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct cp_tm1217_device *ts = i2c_get_clientdata(client);
 	u8 req[2];
 	int retval;
@@ -583,8 +586,9 @@ static int cp_tm1217_suspend(struct i2c_client *client, pm_message_t mesg)
  * cp_tm1217_resume
  *
  */
-static int cp_tm1217_resume(struct i2c_client *client)
+static int cp_tm1217_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct cp_tm1217_device *ts = i2c_get_clientdata(client);
 	u8 req[2];
 	int retval;
@@ -618,6 +622,11 @@ static int cp_tm1217_resume(struct i2c_client *client)
 	return 0;
 }
 
+#endif
+
+static SIMPLE_DEV_PM_OPS(cp_tm1217_pm_ops, cp_tm1217_suspend,
+	cp_tm1217_resume);
+
 /*
  * cp_tm1217_remove
  *
@@ -647,12 +656,11 @@ static struct i2c_driver cp_tm1217_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= CPTM1217_DRIVER_NAME,
+		.pm	= &cp_tm1217_pm_ops,
 	},
 	.id_table	= cp_tm1217_idtable,
 	.probe		= cp_tm1217_probe,
 	.remove		= cp_tm1217_remove,
-	.suspend    = cp_tm1217_suspend,
-	.resume     = cp_tm1217_resume,
 };
 
 module_i2c_driver(cp_tm1217_driver);
-- 
1.8.0

