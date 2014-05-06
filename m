Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936AbaEFLGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:06:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36978 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934895AbaEFLGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:06:43 -0400
From: Roger Quadros <rogerq@ti.com>
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v5 6/7] Input: pixcir_i2c_ts: Implement wakeup from suspend
Date: Tue, 6 May 2014 14:06:11 +0300
Message-ID: <1399374372-29123-7-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399374372-29123-1-git-send-email-rogerq@ti.com>
References: <1399374372-29123-1-git-send-email-rogerq@ti.com>
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
 drivers/input/touchscreen/pixcir_i2c_ts.c | 47 ++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index 0728c04..b0f7680 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -348,21 +348,59 @@ static void pixcir_input_close(struct input_dev *dev)
 static int pixcir_i2c_ts_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct pixcir_i2c_ts_data *ts = i2c_get_clientdata(client);
+	struct input_dev *input = ts->input;
+	int ret = 0;
+
+	mutex_lock(&input->mutex);
+
+	if (device_may_wakeup(&client->dev)) {
+		if (!input->users) {
+			ret = pixcir_start(ts);
+			if (ret) {
+				dev_err(dev, "Failed to start\n");
+				goto unlock;
+			}
+		}
 
-	if (device_may_wakeup(&client->dev))
 		enable_irq_wake(client->irq);
+	} else if (input->users) {
+		ret = pixcir_stop(ts);
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
+
+	mutex_lock(&input->mutex);
 
-	if (device_may_wakeup(&client->dev))
+	if (device_may_wakeup(&client->dev)) {
 		disable_irq_wake(client->irq);
 
-	return 0;
+		if (!input->users) {
+			ret = pixcir_stop(ts);
+			if (ret) {
+				dev_err(dev, "Failed to stop\n");
+				goto unlock;
+			}
+		}
+	} else if (input->users) {
+		ret = pixcir_start(ts);
+	}
+
+unlock:
+	mutex_unlock(&input->mutex);
+
+	return ret;
 }
 #endif
 
@@ -469,6 +507,7 @@ static int pixcir_i2c_ts_probe(struct i2c_client *client,
 	if (error)
 		return error;
 
+	i2c_set_clientdata(client, tsdata);
 	device_init_wakeup(&client->dev, 1);
 
 	return 0;
-- 
1.8.3.2

