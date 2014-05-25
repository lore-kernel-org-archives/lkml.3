Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaEYKkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 06:40:45 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59246 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaEYKkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 06:40:43 -0400
Date: Sun, 25 May 2014 16:10:35 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] video: Introduce the use of the managed version of kzalloc
Message-ID: <20140525104035.GA3187@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, linux/device.h is added to make sure the devm_*()
routine declarations are unambiguously available. The function
mddi_dummy_remove is removed as it is no longer required after
removing the kfree. The variable ret is also done away with.

The following Coccinelle semantic patch was used for making a part of
the change:

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
 drivers/video/fbdev/msm/mddi_client_dummy.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/video/fbdev/msm/mddi_client_dummy.c b/drivers/video/fbdev/msm/mddi_client_dummy.c
index f1b0dfc..cdb8f69 100644
--- a/drivers/video/fbdev/msm/mddi_client_dummy.c
+++ b/drivers/video/fbdev/msm/mddi_client_dummy.c
@@ -15,6 +15,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -51,8 +52,7 @@ static int mddi_dummy_probe(struct platform_device *pdev)
 {
 	struct msm_mddi_client_data *client_data = pdev->dev.platform_data;
 	struct panel_info *panel =
-		kzalloc(sizeof(struct panel_info), GFP_KERNEL);
-	int ret;
+		devm_kzalloc(&pdev->dev, sizeof(struct panel_info), GFP_KERNEL);
 	if (!panel)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, panel);
@@ -67,24 +67,11 @@ static int mddi_dummy_probe(struct platform_device *pdev)
 				      client_data->fb_resource, 1);
 	panel->panel_data.fb_data = client_data->private_client_data;
 	panel->pdev.dev.platform_data = &panel->panel_data;
-	ret = platform_device_register(&panel->pdev);
-	if (ret) {
-		kfree(panel);
-		return ret;
-	}
-	return 0;
-}
-
-static int mddi_dummy_remove(struct platform_device *pdev)
-{
-	struct panel_info *panel = platform_get_drvdata(pdev);
-	kfree(panel);
-	return 0;
+	return platform_device_register(&panel->pdev);
 }
 
 static struct platform_driver mddi_client_dummy = {
 	.probe = mddi_dummy_probe,
-	.remove = mddi_dummy_remove,
 	.driver = { .name = "mddi_c_dummy" },
 };
 
-- 
1.9.1

