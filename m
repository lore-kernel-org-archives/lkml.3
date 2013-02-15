Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161727Ab3BOM5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:35 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:60152 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161361Ab3BOM5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:32 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/35] mfd: ab8500-core: APE Interrupts are not cleared
Date: Fri, 15 Feb 2013 12:56:36 +0000
Message-Id: <1360933026-30325-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcus Cooper <marcus.xm.cooper@stericsson.com>

There are missing register descriptions from the AB8505 user manual
and these need to be masked so that the APEINT line can toggle.
This patch also affects the behaviour of AB9540.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
Reviewed-by: Alexandre TORGUE <alexandre.torgue@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-core.c         |    5 +++--
 include/linux/mfd/abx500/ab8500.h |   38 +++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 05a7af4..7c20728 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -94,6 +94,7 @@
 #define AB8500_IT_MASK22_REG		0x55
 #define AB8500_IT_MASK23_REG		0x56
 #define AB8500_IT_MASK24_REG		0x57
+#define AB8500_IT_MASK25_REG		0x58
 
 /*
  * latch hierarchy registers
@@ -129,9 +130,9 @@ static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
 	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21,
 };
 
-/* AB9540 support */
+/* AB9540 / AB8505 support */
 static const int ab9540_irq_regoffset[AB9540_NUM_IRQ_REGS] = {
-	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21, 12, 13, 24,
+	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21, 12, 13, 24, 5, 22, 23
 };
 
 static const char ab8500_version_str[][7] = {
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index fa7173d..f24df87 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -165,12 +165,12 @@ enum ab8500_version {
 #define AB8500_INT_ID_DET_R3R		94
 #define AB8500_INT_ID_DET_R4R		95
 /* ab8500_irq_regoffset[12] -> IT[Source|Latch|Mask]21 */
-#define AB8500_INT_ID_WAKEUP_F		96
-#define AB8500_INT_ID_DET_R1F		98
-#define AB8500_INT_ID_DET_R2F		99
-#define AB8500_INT_ID_DET_R3F		100
-#define AB8500_INT_ID_DET_R4F		101
-#define AB8500_INT_CHAUTORESTARTAFTSEC  102
+#define AB8500_INT_ID_WAKEUP_F		96 /* not 8505/9540 */
+#define AB8500_INT_ID_DET_R1F		98 /* not 8505/9540 */
+#define AB8500_INT_ID_DET_R2F		99 /* not 8505/9540 */
+#define AB8500_INT_ID_DET_R3F		100 /* not 8505/9540 */
+#define AB8500_INT_ID_DET_R4F		101 /* not 8505/9540 */
+#define AB8500_INT_CHAUTORESTARTAFTSEC	102 /* not 8505/9540 */
 #define AB8500_INT_CHSTOPBYSEC		103
 /* ab8500_irq_regoffset[13] -> IT[Source|Latch|Mask]22 */
 #define AB8500_INT_USB_CH_TH_PROT_F	104
@@ -181,7 +181,7 @@ enum ab8500_version {
 #define AB8500_INT_CHCURLIMHSCHIRP	110
 #define AB8500_INT_XTAL32K_KO		111
 
-/* Definitions for AB9540 */
+/* Definitions for AB9540 / AB8505 */
 /* ab8500_irq_regoffset[14] -> IT[Source|Latch|Mask]13 */
 #define AB9540_INT_GPIO50R		113
 #define AB9540_INT_GPIO51R		114 /* not 8505 */
@@ -204,6 +204,24 @@ enum ab8500_version {
 #define AB8505_INT_KEYDEGLITCH		132
 #define AB8505_INT_MODPWRSTATUSF	134
 #define AB8505_INT_MODPWRSTATUSR	135
+/* ab8500_irq_regoffset[17] -> IT[Source|Latch|Mask]6 */
+#define AB8500_INT_HOOK_DET_NEG_F	138
+#define AB8500_INT_HOOK_DET_NEG_R	139
+#define AB8500_INT_HOOK_DET_POS_F	140
+#define AB8500_INT_HOOK_DET_POS_R	141
+#define AB8500_INT_PLUG_DET_COMP_F	142
+#define AB8500_INT_PLUG_DET_COMP_R	143
+/* ab8500_irq_regoffset[18] -> IT[Source|Latch|Mask]23 */
+#define AB8505_INT_COLL			144
+#define AB8505_INT_RESERR		145
+#define AB8505_INT_FRAERR		146
+#define AB8505_INT_COMERR		147
+#define AB8505_INT_SPDSET		148
+#define AB8505_INT_DSENT		149
+#define AB8505_INT_DREC			150
+#define AB8505_INT_ACC_INT		151
+/* ab8500_irq_regoffset[19] -> IT[Source|Latch|Mask]24 */
+#define AB8505_INT_NOPINT		152
 
 /*
  * AB8500_AB9540_NR_IRQS is used when configuring the IRQ numbers for the
@@ -213,13 +231,13 @@ enum ab8500_version {
  * which is larger.
  */
 #define AB8500_NR_IRQS			112
-#define AB8505_NR_IRQS			136
-#define AB9540_NR_IRQS			136
+#define AB8505_NR_IRQS			153
+#define AB9540_NR_IRQS			153
 /* This is set to the roof of any AB8500 chip variant IRQ counts */
 #define AB8500_MAX_NR_IRQS		AB9540_NR_IRQS
 
 #define AB8500_NUM_IRQ_REGS		14
-#define AB9540_NUM_IRQ_REGS		17
+#define AB9540_NUM_IRQ_REGS		20
 
 /**
  * struct ab8500 - ab8500 internal structure
-- 
1.7.10.4

