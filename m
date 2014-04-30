Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422670AbaD3MhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:37:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54802 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624AbaD3Mg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:36:59 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v3 6/7] Input: pixcir_i2c_ts: Implement wakeup from suspend
Date: Wed, 30 Apr 2014 15:36:31 +0300
Message-ID: <1398861392-8959-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398861392-8959-1-git-send-email-rogerq@ti.com>
References: <1398861392-8959-1-git-send-email-rogerq@ti.com>
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
index b3ff62c..ea31e20 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -352,21 +352,66 @@ static void pixcir_input_close(struct input_dev *dev)
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

