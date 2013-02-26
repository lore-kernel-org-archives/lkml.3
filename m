Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759772Ab3BZW4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:56:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54700 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758595Ab3BZW4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:56:13 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 06/15] staging: omap-thermal: introduce new features of OMAP54xx
Date: Tue, 26 Feb 2013 18:53:29 -0400
Message-ID: <1361919218-9788-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP54xx ES2.0 there are new features inside the bandgap
device. This patch introduces the registers definition
to access these features and adapts the data structures
to map these new registers. The new features are:

. SIDLE mode
. Cumulative register
. History buffer.
. Buffer freeze bit
. Buffer clear bit

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.h  |   65 +++++++++++++++++++++++++-
 drivers/staging/omap-thermal/omap5-thermal.c |   48 +++++++++++++++++--
 2 files changed, 106 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index ef342d8..5994ebb 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -118,6 +118,26 @@
 #define OMAP5430_MASK_HOT_MPU_MASK			(1 << 1)
 #define OMAP5430_MASK_COLD_MPU_SHIFT			0
 #define OMAP5430_MASK_COLD_MPU_MASK			(1 << 0)
+#define OMAP5430_MASK_SIDLEMODE_SHIFT			30
+#define OMAP5430_MASK_SIDLEMODE_MASK			(0x3 << 30)
+#define OMAP5430_MASK_FREEZE_CORE_SHIFT			23
+#define OMAP5430_MASK_FREEZE_CORE_MASK			(1 << 23)
+#define OMAP5430_MASK_FREEZE_GPU_SHIFT			22
+#define OMAP5430_MASK_FREEZE_GPU_MASK			(1 << 22)
+#define OMAP5430_MASK_FREEZE_MPU_SHIFT			21
+#define OMAP5430_MASK_FREEZE_MPU_MASK			(1 << 21)
+#define OMAP5430_MASK_CLEAR_CORE_SHIFT			20
+#define OMAP5430_MASK_CLEAR_CORE_MASK			(1 << 20)
+#define OMAP5430_MASK_CLEAR_GPU_SHIFT			19
+#define OMAP5430_MASK_CLEAR_GPU_MASK			(1 << 19)
+#define OMAP5430_MASK_CLEAR_MPU_SHIFT			18
+#define OMAP5430_MASK_CLEAR_MPU_MASK			(1 << 18)
+#define OMAP5430_MASK_CLEAR_ACCUM_CORE_SHIFT		17
+#define OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK		(1 << 17)
+#define OMAP5430_MASK_CLEAR_ACCUM_GPU_SHIFT		16
+#define OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK		(1 << 16)
+#define OMAP5430_MASK_CLEAR_ACCUM_MPU_SHIFT		15
+#define OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK		(1 << 15)
 
 /* BANDGAP_COUNTER */
 #define OMAP5430_REPEAT_MODE_SHIFT			31
@@ -137,6 +157,18 @@
 #define OMAP5430_TSHUT_COLD_SHIFT			0
 #define OMAP5430_TSHUT_COLD_MASK			(0x3ff << 0)
 
+/* BANDGAP_CUMUL_DTEMP_MPU */
+#define OMAP5430_CUMUL_DTEMP_MPU_SHIFT			0
+#define OMAP5430_CUMUL_DTEMP_MPU_MASK			(0xffffffff << 0)
+
+/* BANDGAP_CUMUL_DTEMP_GPU */
+#define OMAP5430_CUMUL_DTEMP_GPU_SHIFT			0
+#define OMAP5430_CUMUL_DTEMP_GPU_MASK			(0xffffffff << 0)
+
+/* BANDGAP_CUMUL_DTEMP_CORE */
+#define OMAP5430_CUMUL_DTEMP_CORE_SHIFT			0
+#define OMAP5430_CUMUL_DTEMP_CORE_MASK			(0xffffffff << 0)
+
 /* BANDGAP_STATUS */
 #define OMAP5430_BGAP_ALERT_SHIFT			31
 #define OMAP5430_BGAP_ALERT_MASK			(1 << 31)
@@ -174,6 +206,12 @@
 #define OMAP5430_BGAP_COUNTER_GPU_OFFSET		0x1C0
 #define OMAP5430_BGAP_THRESHOLD_GPU_OFFSET		0x1A8
 #define OMAP5430_BGAP_TSHUT_GPU_OFFSET			0x1B4
+#define OMAP5430_BGAP_CUMUL_DTEMP_GPU_OFFSET		0x1C0
+#define OMAP5430_BGAP_DTEMP_GPU_0_OFFSET		0x1F4
+#define OMAP5430_BGAP_DTEMP_GPU_1_OFFSET		0x1F8
+#define OMAP5430_BGAP_DTEMP_GPU_2_OFFSET		0x1FC
+#define OMAP5430_BGAP_DTEMP_GPU_3_OFFSET		0x200
+#define OMAP5430_BGAP_DTEMP_GPU_4_OFFSET		0x204
 
 #define OMAP5430_FUSE_OPP_BGAP_MPU			0x4
 #define OMAP5430_TEMP_SENSOR_MPU_OFFSET			0x14C
@@ -181,13 +219,26 @@
 #define OMAP5430_BGAP_COUNTER_MPU_OFFSET		0x1BC
 #define OMAP5430_BGAP_THRESHOLD_MPU_OFFSET		0x1A4
 #define OMAP5430_BGAP_TSHUT_MPU_OFFSET			0x1B0
-#define OMAP5430_BGAP_STATUS_OFFSET			0x1C8
+#define OMAP5430_BGAP_CUMUL_DTEMP_MPU_OFFSET		0x1BC
+#define OMAP5430_BGAP_DTEMP_MPU_0_OFFSET		0x1E0
+#define OMAP5430_BGAP_DTEMP_MPU_1_OFFSET		0x1E4
+#define OMAP5430_BGAP_DTEMP_MPU_2_OFFSET		0x1E8
+#define OMAP5430_BGAP_DTEMP_MPU_3_OFFSET		0x1EC
+#define OMAP5430_BGAP_DTEMP_MPU_4_OFFSET		0x1F0
 
 #define OMAP5430_FUSE_OPP_BGAP_CORE			0x8
 #define OMAP5430_TEMP_SENSOR_CORE_OFFSET		0x154
 #define OMAP5430_BGAP_COUNTER_CORE_OFFSET		0x1C4
 #define OMAP5430_BGAP_THRESHOLD_CORE_OFFSET		0x1AC
 #define OMAP5430_BGAP_TSHUT_CORE_OFFSET			0x1B8
+#define OMAP5430_BGAP_CUMUL_DTEMP_CORE_OFFSET		0x1C4
+#define OMAP5430_BGAP_DTEMP_CORE_0_OFFSET		0x208
+#define OMAP5430_BGAP_DTEMP_CORE_1_OFFSET		0x20C
+#define OMAP5430_BGAP_DTEMP_CORE_2_OFFSET		0x210
+#define OMAP5430_BGAP_DTEMP_CORE_3_OFFSET		0x214
+#define OMAP5430_BGAP_DTEMP_CORE_4_OFFSET		0x218
+
+#define OMAP5430_BGAP_STATUS_OFFSET			0x1C8
 
 #define OMAP4460_TSHUT_HOT				900	/* 122 deg C */
 #define OMAP4460_TSHUT_COLD				895	/* 100 deg C */
@@ -248,6 +299,10 @@ struct temp_sensor_registers {
 	u32	bgap_mask_ctrl;
 	u32	mask_hot_mask;
 	u32	mask_cold_mask;
+	u32	mask_sidlemode_mask;
+	u32	mask_freeze_mask;
+	u32	mask_clear_mask;
+	u32	mask_clear_accum_mask;
 
 	u32	bgap_mode_ctrl;
 	u32	mode_ctrl_mask;
@@ -260,6 +315,8 @@ struct temp_sensor_registers {
 	u32	threshold_tcold_mask;
 
 	u32	tshut_threshold;
+	u32	tshut_efuse_mask;
+	u32	tshut_efuse_shift;
 	u32	tshut_hot_mask;
 	u32	tshut_cold_mask;
 
@@ -269,6 +326,12 @@ struct temp_sensor_registers {
 	u32	status_hot_mask;
 	u32	status_cold_mask;
 
+	u32	bgap_cumul_dtemp;
+	u32	ctrl_dtemp_0;
+	u32	ctrl_dtemp_1;
+	u32	ctrl_dtemp_2;
+	u32	ctrl_dtemp_3;
+	u32	ctrl_dtemp_4;
 	u32	bgap_efuse;
 };
 
diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index 32d3f878..91618fd 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -20,8 +20,12 @@
 #include "omap-thermal.h"
 
 /*
- * omap5430 has one instance of thermal sensor for MPU
- * need to describe the individual bit fields
+ * OMAP5430 has three instances of thermal sensor for MPU, GPU & CORE,
+ * need to describe the individual registers and bit fields.
+ */
+
+/*
+ * OMAP5430 MPU thermal sensor register offset and bit-fields
  */
 static struct temp_sensor_registers
 omap5430_mpu_temp_sensor_registers = {
@@ -33,6 +37,10 @@ omap5430_mpu_temp_sensor_registers = {
 	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
 	.mask_hot_mask = OMAP5430_MASK_HOT_MPU_MASK,
 	.mask_cold_mask = OMAP5430_MASK_COLD_MPU_MASK,
+	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
+	.mask_freeze_mask = OMAP5430_MASK_FREEZE_MPU_MASK,
+	.mask_clear_mask = OMAP5430_MASK_CLEAR_MPU_MASK,
+	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK,
 
 
 	.bgap_counter = OMAP5430_BGAP_COUNTER_MPU_OFFSET,
@@ -52,12 +60,17 @@ omap5430_mpu_temp_sensor_registers = {
 	.status_hot_mask = OMAP5430_HOT_MPU_FLAG_MASK,
 	.status_cold_mask = OMAP5430_COLD_MPU_FLAG_MASK,
 
+	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_MPU_OFFSET,
+	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_MPU_0_OFFSET,
+	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_MPU_1_OFFSET,
+	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_MPU_2_OFFSET,
+	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_MPU_3_OFFSET,
+	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_MPU_4_OFFSET,
 	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_MPU,
 };
 
 /*
- * omap5430 has one instance of thermal sensor for GPU
- * need to describe the individual bit fields
+ * OMAP5430 GPU thermal sensor register offset and bit-fields
  */
 static struct temp_sensor_registers
 omap5430_gpu_temp_sensor_registers = {
@@ -69,6 +82,10 @@ omap5430_gpu_temp_sensor_registers = {
 	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
 	.mask_hot_mask = OMAP5430_MASK_HOT_GPU_MASK,
 	.mask_cold_mask = OMAP5430_MASK_COLD_GPU_MASK,
+	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
+	.mask_freeze_mask = OMAP5430_MASK_FREEZE_GPU_MASK,
+	.mask_clear_mask = OMAP5430_MASK_CLEAR_GPU_MASK,
+	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK,
 
 	.bgap_counter = OMAP5430_BGAP_COUNTER_GPU_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
@@ -87,12 +104,18 @@ omap5430_gpu_temp_sensor_registers = {
 	.status_hot_mask = OMAP5430_HOT_GPU_FLAG_MASK,
 	.status_cold_mask = OMAP5430_COLD_GPU_FLAG_MASK,
 
+	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_GPU_OFFSET,
+	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_GPU_0_OFFSET,
+	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_GPU_1_OFFSET,
+	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_GPU_2_OFFSET,
+	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_GPU_3_OFFSET,
+	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_GPU_4_OFFSET,
+
 	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_GPU,
 };
 
 /*
- * omap5430 has one instance of thermal sensor for CORE
- * need to describe the individual bit fields
+ * OMAP5430 CORE thermal sensor register offset and bit-fields
  */
 static struct temp_sensor_registers
 omap5430_core_temp_sensor_registers = {
@@ -104,6 +127,10 @@ omap5430_core_temp_sensor_registers = {
 	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
 	.mask_hot_mask = OMAP5430_MASK_HOT_CORE_MASK,
 	.mask_cold_mask = OMAP5430_MASK_COLD_CORE_MASK,
+	.mask_sidlemode_mask = OMAP5430_MASK_SIDLEMODE_MASK,
+	.mask_freeze_mask = OMAP5430_MASK_FREEZE_CORE_MASK,
+	.mask_clear_mask = OMAP5430_MASK_CLEAR_CORE_MASK,
+	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK,
 
 	.bgap_counter = OMAP5430_BGAP_COUNTER_CORE_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
@@ -122,6 +149,13 @@ omap5430_core_temp_sensor_registers = {
 	.status_hot_mask = OMAP5430_HOT_CORE_FLAG_MASK,
 	.status_cold_mask = OMAP5430_COLD_CORE_FLAG_MASK,
 
+	.bgap_cumul_dtemp = OMAP5430_BGAP_CUMUL_DTEMP_CORE_OFFSET,
+	.ctrl_dtemp_0 = OMAP5430_BGAP_DTEMP_CORE_0_OFFSET,
+	.ctrl_dtemp_1 = OMAP5430_BGAP_DTEMP_CORE_1_OFFSET,
+	.ctrl_dtemp_2 = OMAP5430_BGAP_DTEMP_CORE_2_OFFSET,
+	.ctrl_dtemp_3 = OMAP5430_BGAP_DTEMP_CORE_3_OFFSET,
+	.ctrl_dtemp_4 = OMAP5430_BGAP_DTEMP_CORE_4_OFFSET,
+
 	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_CORE,
 };
 
@@ -281,6 +315,8 @@ omap5430_adc_to_temp[
 	123800, 1242000, 124600, 124900, 125000, 125000,
 };
 
+/* OMAP54xx ES2.0 data */
+/* TODO : Need to update the slope/constant for ES2.0 silicon */
 const struct omap_bandgap_data omap5430_data = {
 	.features = OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
 			OMAP_BANDGAP_FEATURE_TALERT |
-- 
1.7.7.1.488.ge8e1c

