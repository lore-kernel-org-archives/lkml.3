Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3AKJ2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:28:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49501 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3AKJ2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:28:11 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/4] input: twl6040-vibra: Use system workqueue
Date: Fri, 11 Jan 2013 10:28:03 +0100
Message-ID: <1357896483-20764-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357896483-20764-1-git-send-email-peter.ujfalusi@ti.com>
References: <1357896483-20764-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is time to switch to system wq instead creating a queue for the driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index f6c0f58..160f0a2 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -45,7 +45,6 @@
 struct vibra_info {
 	struct device *dev;
 	struct input_dev *input_dev;
-	struct workqueue_struct *workqueue;
 	struct work_struct play_work;
 	struct mutex mutex;
 	int irq;
@@ -213,7 +212,7 @@ static int vibra_play(struct input_dev *input, void *data,
 	info->strong_speed = effect->u.rumble.strong_magnitude;
 	info->direction = effect->direction < EFFECT_DIR_180_DEG ? 1 : -1;
 
-	ret = queue_work(info->workqueue, &info->play_work);
+	ret = schedule_work(&info->play_work);
 	if (!ret) {
 		dev_info(&input->dev, "work is already on queue\n");
 		return ret;
@@ -361,19 +360,13 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 		}
 	}
 
-	info->workqueue = alloc_workqueue("twl6040-vibra", 0, 0);
-	if (info->workqueue == NULL) {
-		dev_err(info->dev, "couldn't create workqueue\n");
-		ret = -ENOMEM;
-		goto err_regulator;
-	}
 	INIT_WORK(&info->play_work, vibra_play_work);
 
 	info->input_dev = devm_input_allocate_device(&pdev->dev);
 	if (info->input_dev == NULL) {
 		dev_err(info->dev, "couldn't allocate input device\n");
 		ret = -ENOMEM;
-		goto err_wq;
+		goto err_regulator;
 	}
 
 	input_set_drvdata(info->input_dev, info);
@@ -387,7 +380,7 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 	ret = input_ff_create_memless(info->input_dev, NULL, vibra_play);
 	if (ret < 0) {
 		dev_err(info->dev, "couldn't register vibrator to FF\n");
-		goto err_wq;
+		goto err_regulator;
 	}
 
 	ret = input_register_device(info->input_dev);
@@ -402,8 +395,6 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 
 err_iff:
 	input_ff_destroy(info->input_dev);
-err_wq:
-	destroy_workqueue(info->workqueue);
 err_regulator:
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
 	return ret;
@@ -414,7 +405,6 @@ static int twl6040_vibra_remove(struct platform_device *pdev)
 	struct vibra_info *info = platform_get_drvdata(pdev);
 
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
-	destroy_workqueue(info->workqueue);
 
 	return 0;
 }
-- 
1.8.1

