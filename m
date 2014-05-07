Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaEGEoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 00:44:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52885 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaEGEoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 00:44:23 -0400
Date: Wed, 7 May 2014 10:14:18 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] timblogiw: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140507044418.GA3414@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions.The label err_register is removed as it is no longer required.

The following Coccinelle semantic patch was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

@rem depends on prb@
identifier platform.removefn;
expression e;
@@
removefn(...) {
  <...
- kfree(e);
  ...>
}


Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 drivers/media/platform/timblogiw.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index ccdadd6..fbfdada 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -800,7 +800,7 @@ static int timblogiw_probe(struct platform_device *pdev)
 	if (!pdata->encoder.module_name)
 		dev_info(&pdev->dev, "Running without decoder\n");
 
-	lw = kzalloc(sizeof(*lw), GFP_KERNEL);
+	lw = devm_kzalloc(&pdev->dev, sizeof(*lw), GFP_KERNEL);
 	if (!lw) {
 		err = -ENOMEM;
 		goto err;
@@ -820,7 +820,7 @@ static int timblogiw_probe(struct platform_device *pdev)
 	strlcpy(lw->v4l2_dev.name, DRIVER_NAME, sizeof(lw->v4l2_dev.name));
 	err = v4l2_device_register(NULL, &lw->v4l2_dev);
 	if (err)
-		goto err_register;
+		goto err;
 
 	lw->video_dev.v4l2_dev = &lw->v4l2_dev;
 
@@ -837,8 +837,6 @@ static int timblogiw_probe(struct platform_device *pdev)
 
 err_request:
 	v4l2_device_unregister(&lw->v4l2_dev);
-err_register:
-	kfree(lw);
 err:
 	dev_err(&pdev->dev, "Failed to register: %d\n", err);
 
@@ -853,8 +851,6 @@ static int timblogiw_remove(struct platform_device *pdev)
 
 	v4l2_device_unregister(&lw->v4l2_dev);
 
-	kfree(lw);
-
 	return 0;
 }
 
-- 
1.9.1

