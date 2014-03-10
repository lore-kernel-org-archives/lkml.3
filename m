Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaCJLPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:15:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48214 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752158AbaCJLPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:15:04 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux@arm.linux.org.uk,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] i2c: mv64xxx: Fix reset controller handling
Date: Mon, 10 Mar 2014 12:12:10 +0100
Message-Id: <1394449930-29696-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset framework recently gained optional stubs when CONFIG_RESET_CONTROLLER
is not selected. It also introduced a function reset_get_optional, that is also
dummy-defined whenever the framework isn't enabled, for drivers that needs an
optional reset controller.

Switch to this function, since the mv64xxx driver is in this case. This also
fixes a compilation breakage whenever the reset framework wasn't selected:

drivers/i2c/busses/i2c-mv64xxx.c:771:2: error: implicit declaration of function 'devm_reset_control_get'

While we're at it, remove the redundant test on dev.of_node surrounding the
calls to reset framework functions, since it will either be a valid pointer, an
error pointer in the case where we called reset_get_optional without an of_node
pointer or if it failed, or NULL if we're not loaded through DT.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---

Obviously, this patch depends on Philipp Zabel's "reset: Add optional resets
and stubs" patch that he merged and will send a pull request for.

 drivers/i2c/busses/i2c-mv64xxx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 203a5482a866..a09af20342ed 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -768,7 +768,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 	}
 	drv_data->irq = irq_of_parse_and_map(np, 0);
 
-	drv_data->rstc = devm_reset_control_get(dev, NULL);
+	drv_data->rstc = devm_reset_control_get_optional(dev, NULL);
 	if (IS_ERR(drv_data->rstc)) {
 		if (PTR_ERR(drv_data->rstc) == -EPROBE_DEFER) {
 			rc = -EPROBE_DEFER;
@@ -900,7 +900,7 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 exit_free_irq:
 	free_irq(drv_data->irq, drv_data);
 exit_reset:
-	if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
+	if (!IS_ERR_OR_NULL(drv_data->rstc))
 		reset_control_assert(drv_data->rstc);
 exit_clk:
 #if defined(CONFIG_HAVE_CLK)
@@ -920,7 +920,7 @@ mv64xxx_i2c_remove(struct platform_device *dev)
 
 	i2c_del_adapter(&drv_data->adapter);
 	free_irq(drv_data->irq, drv_data);
-	if (dev->dev.of_node && !IS_ERR(drv_data->rstc))
+	if (!IS_ERR_OR_NULL(drv_data->rstc))
 		reset_control_assert(drv_data->rstc);
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
-- 
1.9.0

