Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3IWJ47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:56:59 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:37912 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3IWJ45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:56:57 -0400
MIME-Version: 1.0
Date: Mon, 23 Sep 2013 17:56:56 +0800
Message-ID: <CAPgLHd_sVSo04e4Su0sUm7h7wgM6xP=XVb+sWFT-e-VZP7FJXQ@mail.gmail.com>
Subject: [PATCH] i2o: add missing destroy_workqueue() on error in i2o_driver_register()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org, keescook@chromium.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing destroy_workqueue() before return from
i2o_driver_register() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/message/i2o/driver.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/message/i2o/driver.c b/drivers/message/i2o/driver.c
index 813eaa3..c3d8462 100644
--- a/drivers/message/i2o/driver.c
+++ b/drivers/message/i2o/driver.c
@@ -105,7 +105,8 @@ int i2o_driver_register(struct i2o_driver *drv)
 			osm_err("too many drivers registered, increase "
 				"max_drivers\n");
 			spin_unlock_irqrestore(&i2o_drivers_lock, flags);
-			return -EFAULT;
+			rc = -EFAULT;
+			goto out;
 		}
 
 	drv->context = i;
@@ -124,11 +125,14 @@ int i2o_driver_register(struct i2o_driver *drv)
 	}
 
 	rc = driver_register(&drv->driver);
-	if (rc) {
-		if (drv->event) {
-			destroy_workqueue(drv->event_queue);
-			drv->event_queue = NULL;
-		}
+	if (rc)
+		goto out;
+
+	return 0;
+out:
+	if (drv->event_queue) {
+		destroy_workqueue(drv->event_queue);
+		drv->event_queue = NULL;
 	}
 
 	return rc;

