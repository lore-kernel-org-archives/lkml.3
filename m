Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904Ab3DKJZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:25:48 -0400
Received: from smtp-out-204.synserver.de ([212.40.185.204]:1093 "EHLO
	smtp-out-204.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765002Ab3DKJZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:25:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10881
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: [PATCH 2/4] misc: fsa8480: Use dev_pm_ops
Date: Thu, 11 Apr 2013 11:24:40 +0200
Message-Id: <1365672282-10449-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1365672282-10449-1-git-send-email-lars@metafoo.de>
References: <1365672282-10449-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Donggeun Kim <dg77.kim@samsung.com>
---
 drivers/misc/fsa9480.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index e8cbb1c..a725c79 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -474,10 +474,11 @@ static int fsa9480_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
-static int fsa9480_suspend(struct i2c_client *client, pm_message_t state)
+static int fsa9480_suspend(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
 	struct fsa9480_platform_data *pdata = usbsw->pdata;
 
@@ -490,8 +491,9 @@ static int fsa9480_suspend(struct i2c_client *client, pm_message_t state)
 	return 0;
 }
 
-static int fsa9480_resume(struct i2c_client *client)
+static int fsa9480_resume(struct device *dev)
 {
+	struct i2c_client *client = to_i2c_client(dev);
 	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
 	int dev1, dev2;
 
@@ -515,12 +517,14 @@ static int fsa9480_resume(struct i2c_client *client)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(fsa9480_pm_ops, fsa9480_suspend, fsa9480_resume);
+#define FSA9480_PM_OPS (&fsa9480_pm_ops)
+
 #else
 
-#define fsa9480_suspend NULL
-#define fsa9480_resume NULL
+#define FSA9480_PM_OPS NULL
 
-#endif /* CONFIG_PM */
+#endif /* CONFIG_PM_SLEEP */
 
 static const struct i2c_device_id fsa9480_id[] = {
 	{"fsa9480", 0},
@@ -531,11 +535,10 @@ MODULE_DEVICE_TABLE(i2c, fsa9480_id);
 static struct i2c_driver fsa9480_i2c_driver = {
 	.driver = {
 		.name = "fsa9480",
+		.pm = FSA9480_PM_OPS,
 	},
 	.probe = fsa9480_probe,
 	.remove = fsa9480_remove,
-	.resume = fsa9480_resume,
-	.suspend = fsa9480_suspend,
 	.id_table = fsa9480_id,
 };
 
-- 
1.8.0

