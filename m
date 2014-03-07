Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaCGPAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:00:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39194 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751570AbaCGPAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:00:03 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux@arm.linux.org.uk,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] i2c: mv64xxx: Fix compilation breakage
Date: Fri,  7 Mar 2014 15:59:30 +0100
Message-Id: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 370136bc67c3 ("i2c: mv64xxx: Add reset deassert call"), introduced a
recursive dependency, which was fixed by commit 80c69915e5fb ("i2c: mv64xxx:
fix circular Kconfig dependency", that in turn, by dropping the dependency on
RESET_CONTROLLER, introduced a compilation breakage whenever this option wasn't
set.

drivers/i2c/busses/i2c-mv64xxx.c:924: undefined reference to `reset_control_assert'
drivers/i2c/busses/i2c-mv64xxx.c:904: undefined reference to `reset_control_assert'
drivers/i2c/busses/i2c-mv64xxx.c:771: undefined reference to `devm_reset_control_get'
drivers/i2c/busses/i2c-mv64xxx.c:778: undefined reference to `reset_control_deassert'

Since the reset framework doesn't define dummy stubs whenever
CONFIG_RESET_CONTROLLER is not defined, protect the reset framework calls by
IS_ENABLED tests to make sure it won't be compiled in.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/i2c/busses/i2c-mv64xxx.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 203a548..a1dc99b 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -768,14 +768,16 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	}
 	drv_data->irq = irq_of_parse_and_map(np, 0);
 
-	drv_data->rstc = devm_reset_control_get(dev, NULL);
-	if (IS_ERR(drv_data->rstc)) {
-		if (PTR_ERR(drv_data->rstc) == -EPROBE_DEFER) {
-			rc = -EPROBE_DEFER;
-			goto out;
+	if (IS_ENABLED(CONFIG_RESET_CONTROLLER)) {
+		drv_data->rstc = devm_reset_control_get(dev, NULL);
+		if (IS_ERR(drv_data->rstc)) {
+			if (PTR_ERR(drv_data->rstc) == -EPROBE_DEFER) {
+				rc = -EPROBE_DEFER;
+				goto out;
+			}
+		} else {
+			reset_control_deassert(drv_data->rstc);
 		}
-	} else {
-		reset_control_deassert(drv_data->rstc);
 	}
 
 	/* Its not yet defined how timeouts will be specified in device tree.
@@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 exit_free_irq:
 	free_irq(drv_data->irq, drv_data);
 exit_reset:
-	if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
+	if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
+	    !IS_ERR(drv_data->rstc))
 		reset_control_assert(drv_data->rstc);
 exit_clk:
 #if defined(CONFIG_HAVE_CLK)
@@ -920,7 +923,8 @@ mv64xxx_i2c_remove(struct platform_device *dev)
 
 	i2c_del_adapter(&drv_data->adapter);
 	free_irq(drv_data->irq, drv_data);
-	if (dev->dev.of_node && !IS_ERR(drv_data->rstc))
+	if (dev->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
+	    !IS_ERR(drv_data->rstc))
 		reset_control_assert(drv_data->rstc);
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
-- 
1.9.0

