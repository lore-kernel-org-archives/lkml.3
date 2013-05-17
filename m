Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3EQMZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:25:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49409 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485Ab3EQMZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:25:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Reset device during probe
Date: Fri, 17 May 2013 13:25:21 +0100
Message-Id: <1368793521-30092-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the device is in a known good state. This should have little
practical impact as the runtime PM will reset the device shortly after
probe but it's neater.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 00e4fe2..ccdddf9 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -652,6 +652,17 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		return ret;
 	}
 
+	/* Explicitly put the device into reset in case regulators
+	 * don't get disabled in order to ensure we know the device
+	 * state.
+	 */
+	ret = wm8994_reg_write(wm8994, WM8994_SOFTWARE_RESET,
+			       wm8994_reg_read(wm8994, WM8994_SOFTWARE_RESET));
+	if (ret != 0) {
+		dev_err(wm8994->dev, "Failed to reset device: %d\n", ret);
+		return ret;
+	}
+
 	if (regmap_patch) {
 		ret = regmap_register_patch(wm8994->regmap, regmap_patch,
 					    patch_regs);
-- 
1.7.10.4

