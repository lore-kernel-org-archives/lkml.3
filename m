Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaFJULx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:11:53 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63422 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaFJULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:11:50 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jkosina@suse.cz, linux-input@vger.kernel.org
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH] HID: hid-sensor-hub: Make all locks of dyn_callback_lock disable interrupts.
Date: Tue, 10 Jun 2014 15:11:37 -0500
Message-Id: <1402431097-3883-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic callback lock (dyn_callback_lock) must not be interrupted
when locked because the lock is used in the interrupt handler function sensor_hub_raw_event().

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/hid/hid-sensor-hub.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index a8d5c8f..6547138 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -133,10 +133,11 @@ static struct hid_sensor_hub_callbacks *sensor_hub_get_callback(
 					struct hid_sensor_hub_device **hsdev,
 					void **priv)
 {
+	unsigned long flags;
 	struct hid_sensor_hub_callbacks_list *callback;
 	struct sensor_hub_data *pdata = hid_get_drvdata(hdev);
 
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list)
 		if (callback->usage_id == usage_id &&
 			(collection_index >=
@@ -145,10 +146,10 @@ static struct hid_sensor_hub_callbacks *sensor_hub_get_callback(
 				callback->hsdev->end_collection_index)) {
 			*priv = callback->priv;
 			*hsdev = callback->hsdev;
-			spin_unlock(&pdata->dyn_callback_lock);
+			spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 			return callback->usage_callback;
 		}
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return NULL;
 }
@@ -157,19 +158,20 @@ int sensor_hub_register_callback(struct hid_sensor_hub_device *hsdev,
 			u32 usage_id,
 			struct hid_sensor_hub_callbacks *usage_callback)
 {
+	unsigned long flags;
 	struct hid_sensor_hub_callbacks_list *callback;
 	struct sensor_hub_data *pdata = hid_get_drvdata(hsdev->hdev);
 
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list)
 		if (callback->usage_id == usage_id &&
 						callback->hsdev == hsdev) {
-			spin_unlock(&pdata->dyn_callback_lock);
+			spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 			return -EINVAL;
 		}
 	callback = kzalloc(sizeof(*callback), GFP_ATOMIC);
 	if (!callback) {
-		spin_unlock(&pdata->dyn_callback_lock);
+		spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 		return -ENOMEM;
 	}
 	callback->hsdev = hsdev;
@@ -177,7 +179,7 @@ int sensor_hub_register_callback(struct hid_sensor_hub_device *hsdev,
 	callback->usage_id = usage_id;
 	callback->priv = NULL;
 	list_add_tail(&callback->list, &pdata->dyn_callback_list);
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }
@@ -186,10 +188,11 @@ EXPORT_SYMBOL_GPL(sensor_hub_register_callback);
 int sensor_hub_remove_callback(struct hid_sensor_hub_device *hsdev,
 				u32 usage_id)
 {
+	unsigned long flags;
 	struct hid_sensor_hub_callbacks_list *callback;
 	struct sensor_hub_data *pdata = hid_get_drvdata(hsdev->hdev);
 
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list)
 		if (callback->usage_id == usage_id &&
 						callback->hsdev == hsdev) {
@@ -197,7 +200,7 @@ int sensor_hub_remove_callback(struct hid_sensor_hub_device *hsdev,
 			kfree(callback);
 			break;
 		}
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }
@@ -376,34 +379,36 @@ EXPORT_SYMBOL_GPL(sensor_hub_input_get_attribute_info);
 #ifdef CONFIG_PM
 static int sensor_hub_suspend(struct hid_device *hdev, pm_message_t message)
 {
+	unsigned long flags;
 	struct sensor_hub_data *pdata = hid_get_drvdata(hdev);
 	struct hid_sensor_hub_callbacks_list *callback;
 
 	hid_dbg(hdev, " sensor_hub_suspend\n");
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list) {
 		if (callback->usage_callback->suspend)
 			callback->usage_callback->suspend(
 					callback->hsdev, callback->priv);
 	}
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }
 
 static int sensor_hub_resume(struct hid_device *hdev)
 {
+	unsigned long flags;
 	struct sensor_hub_data *pdata = hid_get_drvdata(hdev);
 	struct hid_sensor_hub_callbacks_list *callback;
 
 	hid_dbg(hdev, " sensor_hub_resume\n");
-	spin_lock(&pdata->dyn_callback_lock);
+	spin_lock_irqsave(&pdata->dyn_callback_lock, flags);
 	list_for_each_entry(callback, &pdata->dyn_callback_list, list) {
 		if (callback->usage_callback->resume)
 			callback->usage_callback->resume(
 					callback->hsdev, callback->priv);
 	}
-	spin_unlock(&pdata->dyn_callback_lock);
+	spin_unlock_irqrestore(&pdata->dyn_callback_lock, flags);
 
 	return 0;
 }
-- 
1.9.3

