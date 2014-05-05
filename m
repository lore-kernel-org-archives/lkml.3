Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaEEJFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:05:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48038 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602AbaEEJFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:05:03 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 6/7] Input: pixcir_i2c_ts: Implement wakeup from suspend
Date: Mon, 5 May 2014 12:04:37 +0300
Message-ID: <1399280678-23925-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399280678-23925-1-git-send-email-rogerq@ti.com>
References: <1399280678-23925-1-git-send-email-rogerq@ti.com>
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
 drivers/input/touchscreen/pixcir_i2c_ts.c | 53 ++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 927aed1..5f6a27e 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -348,21 +348,66 @@ static void pixcir_input_close(struct input_dev *dev)
 static int pixcir_i2c_ts_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
+	struct input_dev *input = ts->input;
+	int ret = 0;
+
+	mutex_lock(&input->mutex);
+
+	if (input->users) {
+		ret = pixcir_stop(ts);
+		if (ret)
+			goto unlock;
+	}
+
+	/*
+	 * If wakeup is enabled we need to enable interrupt generation
+	 * but don't need to process any reports i.e. ts->exiting must be true.
+	 */
+	if (device_may_wakeup(&client->dev)) {
+		/* enable wakeup interrupt generation */
+		ret = pixcir_int_enable(ts, 1);
+		if (ret) {
+			dev_err(dev, "Failed to enable interrupt generation\n");
+			goto unlock;
+		}
 
-	if (device_may_wakeup(&client->dev))
 		enable_irq_wake(client->irq);
+	}
 
-	return 0;
+unlock:
+	mutex_unlock(&input->mutex);
+
+	return ret;
 }
 
 static int pixcir_i2c_ts_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
+	struct input_dev *input = ts->input;
+	int ret = 0;
 
-	if (device_may_wakeup(&client->dev))
+	mutex_lock(&input->mutex);
+
+	if (device_may_wakeup(&client->dev)) {
 		disable_irq_wake(client->irq);
 
-	return 0;
+		/* disable wakeup interrupt generation */
+		ret = pixcir_int_enable(ts, 0);
+		if (ret) {
+			dev_err(dev, "Failed to disable interrupt generation\n");
+			goto unlock;
+		}
+	}
+
+	if (input->users)
+		ret = pixcir_start(ts);
+
+unlock:
+	mutex_unlock(&input->mutex);
+
+	return ret;
 }
 #endif
 
-- 
1.8.3.2

