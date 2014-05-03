Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaECSCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 14:02:03 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:36494 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaECSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 14:01:09 -0400
From: Peter Feuerer <peter@piie.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Andreas Mohr <andi@lisas.de>,
        Borislav Petkov <bp@suse.de>, Javi Merino <javi.merino@arm.com>
Subject: [PATCH v3 4/6] acerhdf: Use bang-bang thermal governor
Date: Sat,  3 May 2014 19:59:24 +0200
Message-Id: <1399139966-10625-5-git-send-email-peter@piie.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399139966-10625-1-git-send-email-peter@piie.net>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1399139966-10625-1-git-send-email-peter@piie.net>
X-Df-Sender: cGV0ZXJAcGlpZS5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acerhdf has been doing an on-off fan control using hysteresis by
post-manipulating the outcome of thermal subsystem trip point handling.
This patch enables acerhdf to use the bang-bang governor, which is
intended for on-off controlled fans.

Cc: Andrew Morton <akpm@linux-foundation.org>
CC: Zhang Rui <rui.zhang@intel.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Javi Merino <javi.merino@arm.com>
Signed-off-by: Peter Feuerer <peter@piie.net>
---
 drivers/platform/x86/Kconfig   |  2 +-
 drivers/platform/x86/acerhdf.c | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 27df2c5..0c15d89 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -38,7 +38,7 @@ config ACER_WMI
 
 config ACERHDF
 	tristate "Acer Aspire One temperature and fan driver"
-	depends on THERMAL && ACPI
+	depends on ACPI && THERMAL_GOV_BANG_BANG
 	---help---
 	  This is a driver for Acer Aspire One netbooks. It allows to access
 	  the temperature sensor and to control the fan.
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 176edbd..afaa849 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -50,7 +50,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.30"
+#define DRV_VER "0.5.31"
 
 /*
  * According to the Atom N270 datasheet,
@@ -259,6 +259,14 @@ static const struct bios_settings_t bios_tbl[] = {
 
 static const struct bios_settings_t *bios_cfg __read_mostly;
 
+/*
+ * this struct is used to instruct thermal layer to use bang_bang instead of
+ * default governor for acerhdf
+ */
+static struct thermal_zone_params acerhdf_zone_params = {
+	.governor_name = "bang_bang",
+};
+
 static int acerhdf_get_temp(int *temp)
 {
 	u8 read_temp;
@@ -440,6 +448,15 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
 	return 0;
 }
 
+static int acerhdf_get_trip_hyst(struct thermal_zone_device *thermal, int trip,
+				 unsigned long *temp)
+{
+	if (trip == 0)
+		*temp = fanon - fanoff;
+
+	return 0;
+}
+
 static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 				 unsigned long *temp)
 {
@@ -464,6 +481,7 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
 	.get_mode = acerhdf_get_mode,
 	.set_mode = acerhdf_set_mode,
 	.get_trip_type = acerhdf_get_trip_type,
+	.get_trip_hyst = acerhdf_get_trip_hyst,
 	.get_trip_temp = acerhdf_get_trip_temp,
 	.get_crit_temp = acerhdf_get_crit_temp,
 };
@@ -516,9 +534,7 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
 	}
 
 	if (state == 0) {
-		/* turn fan off only if below fanoff temperature */
-		if ((cur_state == ACERHDF_FAN_AUTO) &&
-		    (cur_temp < fanoff))
+		if (cur_state == ACERHDF_FAN_AUTO)
 			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
 	} else {
 		if (cur_state == ACERHDF_FAN_OFF)
@@ -697,11 +713,19 @@ static int acerhdf_register_thermal(void)
 		return -EINVAL;
 
 	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
-					      &acerhdf_dev_ops, NULL, 0,
+					      &acerhdf_dev_ops,
+					      &acerhdf_zone_params, 0,
 					      (kernelmode) ? interval*1000 : 0);
 	if (IS_ERR(thz_dev))
 		return -EINVAL;
 
+	if (strcmp(thz_dev->governor->name,
+				acerhdf_zone_params.governor_name)) {
+		pr_err("Didn't get thermal governor %s, perhaps not compiled into thermal subsystem.\n",
+				acerhdf_zone_params.governor_name);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.9.2

