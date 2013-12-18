Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3LRJX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:23:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40344 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab3LRJXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:23:09 -0500
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 9/9] Input: pixcir_i2c_ts: Implement wakeup from suspend
Date: Wed, 18 Dec 2013 14:51:20 +0530
Message-ID: <1387358480-8313-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387358480-8313-1-git-send-email-rogerq@ti.com>
References: <1387358480-8313-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the suspend and resume handlers to allow the device
to wakeup the system from suspend.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 drivers/input/touchscreen/pixcir_i2c_ts.c | 89 ++++++++++++++++++++++---------
 1 file changed, 63 insertions(+), 26 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 3575eab..a7725b9 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -347,32 +347,6 @@ static void pixcir_input_close(struct input_dev *dev)
 	return;
 }
 
-
-#ifdef CONFIG_PM_SLEEP
-static int pixcir_i2c_ts_suspend(struct device *dev)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-
-	if (device_may_wakeup(&client->dev))
-		enable_irq_wake(client->irq);
-
-	return 0;
-}
-
-static int pixcir_i2c_ts_resume(struct device *dev)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-
-	if (device_may_wakeup(&client->dev))
-		disable_irq_wake(client->irq);
-
-	return 0;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(pixcir_dev_pm_ops,
-			 pixcir_i2c_ts_suspend, pixcir_i2c_ts_resume);
-
 #if defined(CONFIG_OF)
 static const struct of_device_id pixcir_of_match[];
 
@@ -547,6 +521,69 @@ static int pixcir_i2c_ts_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int pixcir_i2c_ts_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
+	struct input_dev *input = ts->input;
+	int ret = 0;
+
+	mutex_lock(&input->mutex);
+
+	if (device_may_wakeup(&client->dev)) {
+		/* need to start device if not open, to be wakeup source */
+		if (!input->users) {
+			ret = pixcir_start(ts);
+			if (ret)
+				goto unlock;
+		}
+
+		enable_irq_wake(client->irq);
+
+	} else if (input->users) {
+		ret = pixcir_stop(ts);
+	}
+
+unlock:
+	mutex_unlock(&input->mutex);
+
+	return ret;
+}
+
+static int pixcir_i2c_ts_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
+	struct input_dev *input = ts->input;
+	int ret = 0;
+
+	mutex_lock(&input->mutex);
+
+	if (device_may_wakeup(&client->dev)) {
+		disable_irq_wake(client->irq);
+
+		/* need to stop device if it was not open on suspend */
+		if (!input->users) {
+			ret = pixcir_stop(ts);
+			if (ret)
+				goto unlock;
+		}
+
+	} else if (input->users) {
+		ret = pixcir_start(ts);
+	}
+
+unlock:
+	mutex_unlock(&input->mutex);
+
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(pixcir_dev_pm_ops,
+				pixcir_i2c_ts_suspend, pixcir_i2c_ts_resume);
+
 static const struct i2c_device_id pixcir_i2c_ts_id[] = {
 	{ "pixcir_ts", 0 },
 	{ "pixcir_tangoc", 0},
-- 
1.8.3.2

