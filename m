Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbaEEN6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:58:22 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:41599 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbaEEN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:57:45 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] clk: bcm281xx: define a bus clock
Date: Mon,  5 May 2014 08:57:35 -0500
Message-Id: <1399298256-10965-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399298256-10965-1-git-send-email-elder@linaro.org>
References: <1399298256-10965-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the bus clock "bsc3_apb".  This bus clock has to be managed
using the CCU policy mechanism, so add the definitions required for
that to the clock and its CCU.

This one bus clock in particular is defined because it is needed
by peripheral clock "bsc3".  Our boot loader does not properly
activate "bsc3_apb", and as a result, "bsc3" isn't able to function
properly.  With "bsc3_apb" specified as a prerequisite clock for
"bsc3", the latter works correctly.

For now only this one bus clock is defined, because it allows
correct operation of "bsc3".  Others can be added later as needed
(and this patch serves to show how that's done).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-bcm281xx.c       | 13 ++++++++++++-
 include/dt-bindings/clock/bcm281xx.h |  3 ++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm281xx.c b/drivers/clk/bcm/clk-bcm281xx.c
index 502a487..b937fc9 100644
--- a/drivers/clk/bcm/clk-bcm281xx.c
+++ b/drivers/clk/bcm/clk-bcm281xx.c
@@ -309,8 +309,17 @@ static struct peri_clk_data pwm_data = {
 	.trig		= TRIGGER(0x0afc, 15),
 };
 
+static struct bus_clk_data bsc3_apb_data = {
+	.policy		= POLICY(0x0048, 4),
+	.gate		= HW_SW_GATE(0x0484, 16, 0, 1),
+};
+
 static struct ccu_data slave_ccu_data = {
 	BCM281XX_CCU_COMMON(slave, SLAVE),
+	.policy		= {
+		.enable		= CCU_LVM_EN(0x0034, 0),
+		.control	= CCU_POLICY_CTL(0x000c, 0, 1, 2),
+	},
 	.kona_clks	= {
 		[BCM281XX_SLAVE_CCU_UARTB] =
 			KONA_CLK(slave, uartb, peri),
@@ -329,9 +338,11 @@ static struct ccu_data slave_ccu_data = {
 		[BCM281XX_SLAVE_CCU_BSC2] =
 			KONA_CLK(slave, bsc2, peri),
 		[BCM281XX_SLAVE_CCU_BSC3] =
-			KONA_CLK(slave, bsc3, peri),
+			KONA_CLK_PREREQ(slave, bsc3, peri, bsc3_apb),
 		[BCM281XX_SLAVE_CCU_PWM] =
 			KONA_CLK(slave, pwm, peri),
+		[BCM281XX_SLAVE_CCU_BSC3_APB] =
+			KONA_CLK(slave, bsc3_apb, bus),
 		[BCM281XX_SLAVE_CCU_CLOCK_COUNT] = LAST_KONA_CLK,
 	},
 };
diff --git a/include/dt-bindings/clock/bcm281xx.h b/include/dt-bindings/clock/bcm281xx.h
index a763460..99f4aad 100644
--- a/include/dt-bindings/clock/bcm281xx.h
+++ b/include/dt-bindings/clock/bcm281xx.h
@@ -72,6 +72,7 @@
 #define BCM281XX_SLAVE_CCU_BSC2			7
 #define BCM281XX_SLAVE_CCU_BSC3			8
 #define BCM281XX_SLAVE_CCU_PWM			9
-#define BCM281XX_SLAVE_CCU_CLOCK_COUNT		10
+#define BCM281XX_SLAVE_CCU_BSC3_APB		10
+#define BCM281XX_SLAVE_CCU_CLOCK_COUNT		11
 
 #endif /* _CLOCK_BCM281XX_H */
-- 
1.9.1

