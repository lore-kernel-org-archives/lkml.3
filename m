Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3KSQH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:07:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49253 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962Ab3KSQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:05:19 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: lgirdwood@gmail.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mfd: wm5110: Make DSP memories readable
Date: Tue, 19 Nov 2013 16:04:00 +0000
Message-Id: <1384877043-5640-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384877043-5640-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the memory regions used by the DSP cores on WM5110 as readable
and volatile.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c |   69 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 3113e39..4430404 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -14,6 +14,7 @@
 
 #include <linux/mfd/arizona/core.h>
 #include <linux/mfd/arizona/registers.h>
+#include <linux/device.h>
 
 #include "arizona.h"
 
@@ -1336,6 +1337,64 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00001404, 0x0000 },    /* R5124  - DSP4 Status 1 */
 };
 
+static bool wm5110_is_rev_b_adsp_memory(unsigned int reg)
+{
+	if ((reg >= 0x100000 && reg < 0x103000) ||
+	    (reg >= 0x180000 && reg < 0x181000) ||
+	    (reg >= 0x190000 && reg < 0x192000) ||
+	    (reg >= 0x1a8000 && reg < 0x1a9000) ||
+	    (reg >= 0x200000 && reg < 0x209000) ||
+	    (reg >= 0x280000 && reg < 0x281000) ||
+	    (reg >= 0x290000 && reg < 0x29a000) ||
+	    (reg >= 0x2a8000 && reg < 0x2aa000) ||
+	    (reg >= 0x300000 && reg < 0x30f000) ||
+	    (reg >= 0x380000 && reg < 0x382000) ||
+	    (reg >= 0x390000 && reg < 0x39e000) ||
+	    (reg >= 0x3a8000 && reg < 0x3b6000) ||
+	    (reg >= 0x400000 && reg < 0x403000) ||
+	    (reg >= 0x480000 && reg < 0x481000) ||
+	    (reg >= 0x490000 && reg < 0x492000) ||
+	    (reg >= 0x4a8000 && reg < 0x4a9000))
+		return true;
+	else
+		return false;
+}
+
+static bool wm5110_is_rev_d_adsp_memory(unsigned int reg)
+{
+	if ((reg >= 0x100000 && reg < 0x106000) ||
+	    (reg >= 0x180000 && reg < 0x182000) ||
+	    (reg >= 0x190000 && reg < 0x198000) ||
+	    (reg >= 0x1a8000 && reg < 0x1aa000) ||
+	    (reg >= 0x200000 && reg < 0x20f000) ||
+	    (reg >= 0x280000 && reg < 0x282000) ||
+	    (reg >= 0x290000 && reg < 0x29c000) ||
+	    (reg >= 0x2a6000 && reg < 0x2b4000) ||
+	    (reg >= 0x300000 && reg < 0x30f000) ||
+	    (reg >= 0x380000 && reg < 0x382000) ||
+	    (reg >= 0x390000 && reg < 0x3a2000) ||
+	    (reg >= 0x3a6000 && reg < 0x3b4000) ||
+	    (reg >= 0x400000 && reg < 0x406000) ||
+	    (reg >= 0x480000 && reg < 0x482000) ||
+	    (reg >= 0x490000 && reg < 0x498000) ||
+	    (reg >= 0x4a8000 && reg < 0x4aa000))
+		return true;
+	else
+		return false;
+}
+
+static bool wm5110_is_adsp_memory(struct device *dev, unsigned int reg)
+{
+	struct arizona *arizona = dev_get_drvdata(dev);
+
+	switch (arizona->rev) {
+	case 0 ... 2:
+		return wm5110_is_rev_b_adsp_memory(reg);
+	default:
+		return wm5110_is_rev_d_adsp_memory(reg);
+	}
+}
+
 static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -2308,7 +2367,7 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP4_STATUS_3:
 		return true;
 	default:
-		return false;
+		return wm5110_is_adsp_memory(dev, reg);
 	}
 }
 
@@ -2368,16 +2427,18 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP4_STATUS_3:
 		return true;
 	default:
-		return false;
+		return wm5110_is_adsp_memory(dev, reg);
 	}
 }
 
+#define WM5110_MAX_REGISTER 0x4a9fff
+
 const struct regmap_config wm5110_spi_regmap = {
 	.reg_bits = 32,
 	.pad_bits = 16,
 	.val_bits = 16,
 
-	.max_register = ARIZONA_DSP1_STATUS_2,
+	.max_register = WM5110_MAX_REGISTER,
 	.readable_reg = wm5110_readable_register,
 	.volatile_reg = wm5110_volatile_register,
 
@@ -2391,7 +2452,7 @@ const struct regmap_config wm5110_i2c_regmap = {
 	.reg_bits = 32,
 	.val_bits = 16,
 
-	.max_register = ARIZONA_DSP1_STATUS_2,
+	.max_register = WM5110_MAX_REGISTER,
 	.readable_reg = wm5110_readable_register,
 	.volatile_reg = wm5110_volatile_register,
 
-- 
1.7.2.5

