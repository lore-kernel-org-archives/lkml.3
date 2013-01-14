Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3ANPeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:34:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54427 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab3ANPeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:34:44 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] input: twl6040-vibra: Use system workqueue
Date: Mon, 14 Jan 2013 16:34:38 +0100
Message-ID: <1358177678-16509-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1358177678-16509-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358177678-16509-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is time to switch to system wq instead creating a queue for the driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index d1e31b8..0c2dfc8 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -361,19 +361,13 @@ static int twl6040_vibra_probe(struct platform_device *pdev)
 		}
 	}
 
-	info->workqueue = alloc_workqueue("twl6040-vibra", 0, 0);
-	if (info->workqueue == NULL) {
-		dev_err(info->dev, "couldn't create workqueue\n");
-		ret = -ENOMEM;
-		goto err_regulator;
-	}
 	INIT_WORK(&info->play_work, vibra_play_work);
 
 	info->input_dev = input_allocate_device();
 	if (info->input_dev == NULL) {
 		dev_err(info->dev, "couldn't allocate input device\n");
 		ret = -ENOMEM;
-		goto err_wq;
+		goto err_regulator;
 	}
 
 	input_set_drvdata(info->input_dev, info);
@@ -404,8 +398,6 @@ err_iff:
 	input_ff_destroy(info->input_dev);
 err_ialloc:
 	input_free_device(info->input_dev);
-err_wq:
-	destroy_workqueue(info->workqueue);
 err_regulator:
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
 	return ret;
@@ -417,7 +409,6 @@ static int twl6040_vibra_remove(struct platform_device *pdev)
 
 	input_unregister_device(info->input_dev);
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
-	destroy_workqueue(info->workqueue);
 
 	return 0;
 }
-- 
1.8.1

