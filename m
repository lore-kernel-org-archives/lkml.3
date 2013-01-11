Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3AKJ2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:28:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47436 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab3AKJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:28:09 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] input: twl4030-vibra: Use system workqueue
Date: Fri, 11 Jan 2013 10:28:01 +0100
Message-ID: <1357896483-20764-3-git-send-email-peter.ujfalusi@ti.com>
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
 drivers/input/misc/twl4030-vibra.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index e2e2a26..68a5f33 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -43,7 +43,6 @@ struct vibra_info {
 	struct device		*dev;
 	struct input_dev	*input_dev;
 
-	struct workqueue_struct *workqueue;
 	struct work_struct	play_work;
 
 	bool			enabled;
@@ -143,19 +142,7 @@ static int vibra_play(struct input_dev *input, void *data,
 	if (!info->speed)
 		info->speed = effect->u.rumble.weak_magnitude >> 9;
 	info->direction = effect->direction < EFFECT_DIR_180_DEG ? 0 : 1;
-	queue_work(info->workqueue, &info->play_work);
-	return 0;
-}
-
-static int twl4030_vibra_open(struct input_dev *input)
-{
-	struct vibra_info *info = input_get_drvdata(input);
-
-	info->workqueue = create_singlethread_workqueue("vibra");
-	if (info->workqueue == NULL) {
-		dev_err(&input->dev, "couldn't create workqueue\n");
-		return -ENOMEM;
-	}
+	schedule_work(&info->play_work);
 	return 0;
 }
 
@@ -164,9 +151,6 @@ static void twl4030_vibra_close(struct input_dev *input)
 	struct vibra_info *info = input_get_drvdata(input);
 
 	cancel_work_sync(&info->play_work);
-	INIT_WORK(&info->play_work, vibra_play_work); /* cleanup */
-	destroy_workqueue(info->workqueue);
-	info->workqueue = NULL;
 
 	if (info->enabled)
 		vibra_disable(info);
@@ -238,7 +222,6 @@ static int twl4030_vibra_probe(struct platform_device *pdev)
 	info->input_dev->name = "twl4030:vibrator";
 	info->input_dev->id.version = 1;
 	info->input_dev->dev.parent = pdev->dev.parent;
-	info->input_dev->open = twl4030_vibra_open;
 	info->input_dev->close = twl4030_vibra_close;
 	__set_bit(FF_RUMBLE, info->input_dev->ffbit);
 
-- 
1.8.1

