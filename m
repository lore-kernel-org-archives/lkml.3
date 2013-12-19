Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3LSIlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:41:20 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49091 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3LSIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:41:19 -0500
Date: Thu, 19 Dec 2013 14:11:10 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shawn Guo <shawn.guo@linaro.org>, josh@joshtriplett.org
Subject: [PATCH v2] drivers: reset: Mark function as static and remove unused
 function in core.c
Message-ID: <20131219084110.GA14098@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function of_reset_simple_xlate() as static in core.c
because it is not used outside this file.
Also, remove functions devm_reset_control_put() and
devm_reset_control_match() because they are unused.

This eliminates the following warnings in core.c:
drivers/reset/core.c:46:5: warning: no previous prototype for ‘of_reset_simple_xlate’ [-Wmissing-prototypes]
drivers/reset/core.c:262:6: warning: no previous prototype for ‘devm_reset_control_put’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---

Changes since v1:
Incorrect Fix

 drivers/reset/core.c |   30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index d1b6089..129bb85 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -43,7 +43,7 @@ struct reset_control {
  * This simple translation function should be used for reset controllers
  * with 1:1 mapping, where reset lines can be indexed by number without gaps.
  */
-int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
+static int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
 			  const struct of_phandle_args *reset_spec)
 {
 	if (WARN_ON(reset_spec->args_count != rcdev->of_reset_n_cells))
@@ -54,7 +54,6 @@ int of_reset_simple_xlate(struct reset_controller_dev *rcdev,
 
 	return reset_spec->args[0];
 }
-EXPORT_SYMBOL_GPL(of_reset_simple_xlate);
 
 /**
  * reset_controller_register - register a reset controller device
@@ -243,33 +242,6 @@ struct reset_control *devm_reset_control_get(struct device *dev, const char *id)
 }
 EXPORT_SYMBOL_GPL(devm_reset_control_get);
 
-static int devm_reset_control_match(struct device *dev, void *res, void *data)
-{
-	struct reset_control **rstc = res;
-	if (WARN_ON(!rstc || !*rstc))
-		return 0;
-	return *rstc == data;
-}
-
-/**
- * devm_reset_control_put - resource managed reset_control_put()
- * @rstc: reset controller to free
- *
- * Deallocate a reset control allocated withd devm_reset_control_get().
- * This function will not need to be called normally, as devres will take
- * care of freeing the resource.
- */
-void devm_reset_control_put(struct reset_control *rstc)
-{
-	int ret;
-
-	ret = devres_release(rstc->dev, devm_reset_control_release,
-			     devm_reset_control_match, rstc);
-	if (ret)
-		WARN_ON(ret);
-}
-EXPORT_SYMBOL_GPL(devm_reset_control_put);
-
 /**
  * device_reset - find reset controller associated with the device
  *                and perform reset
-- 
1.7.9.5

