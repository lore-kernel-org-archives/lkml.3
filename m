Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab3C1QML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:12:11 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59354 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab3C1QMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/33] ARM: ux500: Turn off external regulator #1 when early HREFs suspend
Date: Thu, 28 Mar 2013 16:11:04 +0000
Message-Id: <1364487093-19551-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When older variants of the HREF (earlier than v22) development
platform enter suspend mode, power down EXT_SUPPLY1.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   17 +++++++++++++++++
 arch/arm/mach-ux500/board-mop500-regulators.h |    2 ++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 22dfaf3..2a2751e 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/ab8500.h>
+#include <mach/id.h> /* to identify older boards for fixes */
 #include "board-mop500-regulators.h"
 
 static struct regulator_consumer_supply gpio_en_3v3_consumers[] = {
@@ -494,3 +495,19 @@ static void ab8500_modify_reg_init(int id, u8 mask, u8 value)
 
 	BUG_ON(1);
 }
+
+void mop500_regulator_init(void)
+{
+	struct regulator_init_data *regulator;
+
+	/*
+	 * Handle VextSupply1 on older boards than HREFP_V22_V1x
+	 * (turn off in suspend)
+	 */
+	if (cpu_is_u8500v20() || cpu_is_u8500v21()) {
+		/* disable VextSupply1 in suspend */
+		regulator = &ab8500_ext_regulators[AB8500_EXT_SUPPLY1];
+		regulator->constraints.state_mem.disabled = 1;
+		regulator->constraints.state_standby.disabled = 1;
+	}
+}
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.h b/arch/arm/mach-ux500/board-mop500-regulators.h
index 9ca4869..3d4c412 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.h
+++ b/arch/arm/mach-ux500/board-mop500-regulators.h
@@ -18,4 +18,6 @@ extern struct ab8500_regulator_platform_data ab8500_regulator_plat_data;
 extern struct regulator_init_data tps61052_regulator;
 extern struct regulator_init_data gpio_en_3v3_regulator;
 
+void mop500_regulator_init(void);
+
 #endif
-- 
1.7.10.4

