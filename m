Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaHBWLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:11:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47879 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385AbaHBWLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:11:38 -0400
Date: Sun, 3 Aug 2014 03:41:35 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Archana Patni <archana.patni@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] HID: hid-sensor-hub: use devm_ functions consistently
Message-ID: <20140802221135.GA18239@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc for all calls to kzalloc and not just the first.  Use
devm functions for other allocations as well. The calls to free the
allocated memory in the probe and remove functions are done away with
and a label is removed in the probe function.

The semantic match that finds the inconsistency is as follows:

// <smpl>
@@
@@

*devm_kzalloc(...)
...
*kzalloc(...)
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/hid/hid-sensor-hub.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index e244e44..2ac2576 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -604,9 +604,9 @@ static int sensor_hub_probe(struct hid_device *hdev,
 		ret = -EINVAL;
 		goto err_stop_hw;
 	}
-	sd->hid_sensor_hub_client_devs = kzalloc(dev_cnt *
-						sizeof(struct mfd_cell),
-						GFP_KERNEL);
+	sd->hid_sensor_hub_client_devs = devm_kzalloc(&hdev->dev, dev_cnt *
+						      sizeof(struct mfd_cell),
+						      GFP_KERNEL);
 	if (sd->hid_sensor_hub_client_devs == NULL) {
 		hid_err(hdev, "Failed to allocate memory for mfd cells\n");
 			ret = -ENOMEM;
@@ -618,11 +618,12 @@ static int sensor_hub_probe(struct hid_device *hdev,
 
 		if (collection->type == HID_COLLECTION_PHYSICAL) {
 
-			hsdev = kzalloc(sizeof(*hsdev), GFP_KERNEL);
+			hsdev = devm_kzalloc(&hdev->dev, sizeof(*hsdev),
+					     GFP_KERNEL);
 			if (!hsdev) {
 				hid_err(hdev, "cannot allocate hid_sensor_hub_device\n");
 				ret = -ENOMEM;
-				goto err_no_mem;
+				goto err_stop_hw;
 			}
 			hsdev->hdev = hdev;
 			hsdev->vendor_id = hdev->vendor;
@@ -631,13 +632,13 @@ static int sensor_hub_probe(struct hid_device *hdev,
 			if (last_hsdev)
 				last_hsdev->end_collection_index = i;
 			last_hsdev = hsdev;
-			name = kasprintf(GFP_KERNEL, "HID-SENSOR-%x",
-					collection->usage);
+			name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
+					      "HID-SENSOR-%x",
+					      collection->usage);
 			if (name == NULL) {
 				hid_err(hdev, "Failed MFD device name\n");
 					ret = -ENOMEM;
-					kfree(hsdev);
-					goto err_no_mem;
+					goto err_stop_hw;
 			}
 			sd->hid_sensor_hub_client_devs[
 				sd->hid_sensor_client_cnt].id =
@@ -661,16 +662,10 @@ static int sensor_hub_probe(struct hid_device *hdev,
 	ret = mfd_add_devices(&hdev->dev, 0, sd->hid_sensor_hub_client_devs,
 		sd->hid_sensor_client_cnt, NULL, 0, NULL);
 	if (ret < 0)
-		goto err_no_mem;
+		goto err_stop_hw;
 
 	return ret;
 
-err_no_mem:
-	for (i = 0; i < sd->hid_sensor_client_cnt; ++i) {
-		kfree(sd->hid_sensor_hub_client_devs[i].name);
-		kfree(sd->hid_sensor_hub_client_devs[i].platform_data);
-	}
-	kfree(sd->hid_sensor_hub_client_devs);
 err_stop_hw:
 	hid_hw_stop(hdev);
 
@@ -681,7 +676,6 @@ static void sensor_hub_remove(struct hid_device *hdev)
 {
 	struct sensor_hub_data *data = hid_get_drvdata(hdev);
 	unsigned long flags;
-	int i;
 
 	hid_dbg(hdev, " hardware removed\n");
 	hid_hw_close(hdev);
@@ -691,11 +685,6 @@ static void sensor_hub_remove(struct hid_device *hdev)
 		complete(&data->pending.ready);
 	spin_unlock_irqrestore(&data->lock, flags);
 	mfd_remove_devices(&hdev->dev);
-	for (i = 0; i < data->hid_sensor_client_cnt; ++i) {
-		kfree(data->hid_sensor_hub_client_devs[i].name);
-		kfree(data->hid_sensor_hub_client_devs[i].platform_data);
-	}
-	kfree(data->hid_sensor_hub_client_devs);
 	hid_set_drvdata(hdev, NULL);
 	mutex_destroy(&data->mutex);
 }
-- 
1.9.1

