Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967455Ab3E3DGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:06:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:36341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967357Ab3E3DDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312644"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com
Subject: [PATCH v1 08/13] intel_mid: Added custom handler for ipc devices
Date: Wed, 29 May 2013 19:45:18 -0700
Message-Id: <1369881923-27067-9-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a custom handler for medfield based ipc devices and
moved devs_id structure defintion to header file.

Change-Id: Ib34d12e0f70da9b0890972d286072369bebf349d
Signed-off-by: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
---
 arch/x86/include/asm/intel-mid.h        |   15 ++++++
 arch/x86/platform/intel-mid/intel-mid.c |   87 ++++++++++++++++++++-----------
 2 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index beb7a5f..ad236ae 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -19,6 +19,21 @@ extern int sfi_mrtc_num;
 extern struct sfi_rtc_table_entry sfi_mrtc_array[];
 
 /*
+ * Here defines the array of devices platform data that IAFW would export
+ * through SFI "DEVS" table, we use name and type to match the device and
+ * its platform data.
+ */
+struct devs_id {
+	char name[SFI_NAME_LEN + 1];
+	u8 type;
+	u8 delay;
+	void *(*get_platform_data)(void *info);
+	/* Custom handler for devices */
+	void (*device_handler)(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev);
+};
+
+/*
  * Medfield is the follow-up of Moorestown, it combines two chip solution into
  * one. Other than that it also added always-on and constant tsc and lapic
  * timers. Medfield is the platform name, and the chip name is called Penwell
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index f3abd75..1018ee8 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -78,6 +78,8 @@ int sfi_mtimer_num;
 struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
 EXPORT_SYMBOL_GPL(sfi_mrtc_array);
 int sfi_mrtc_num;
+static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
+			struct devs_id *dev);
 
 static void intel_mid_power_off(void)
 {
@@ -386,21 +388,6 @@ static int get_gpio_by_name(const char *name)
 	return -1;
 }
 
-/*
- * Here defines the array of devices platform data that IAFW would export
- * through SFI "DEVS" table, we use name and type to match the device and
- * its platform data.
- */
-struct devs_id {
-	char name[SFI_NAME_LEN + 1];
-	u8 type;
-	u8 delay;
-	void *(*get_platform_data)(void *info);
-	/* Custom handler for devices */
-	void (*device_handler)(struct sfi_device_table_entry *pentry,
-				struct devs_id *dev);
-};
-
 /* the offset for the mapping of global gpio pin to irq */
 #define INTEL_MID_IRQ_OFFSET 0x100
 
@@ -695,27 +682,32 @@ static void *tc35876x_platform_data(void *data)
 static const struct devs_id __initconst device_ids[] = {
 	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data, NULL},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data, NULL},
-	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data, NULL},
+	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data,
+					&ipc_device_handler},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data, NULL},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
 	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
 	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data, NULL},
 	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data, NULL},
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data, NULL},
-	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data, NULL},
+	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data,
+					&ipc_device_handler},
 	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data, NULL},
 	{"i2c_disp_brig", SFI_DEV_TYPE_I2C, 0, &tc35876x_platform_data, NULL},
 
 	/* MSIC subdevices */
 	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data,
-					NULL},
-	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, NULL},
-	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, NULL},
+					&ipc_device_handler},
+	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data,
+					&ipc_device_handler},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data,
+					&ipc_device_handler},
 	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data,
-					NULL},
-	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, NULL},
+					&ipc_device_handler},
+	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data,
+					&ipc_device_handler},
 	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data,
-					NULL},
+					&ipc_device_handler},
 	{},
 };
 
@@ -846,13 +838,6 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
 		pentry->name, pentry->irq);
 	pdata = dev->get_platform_data(pentry);
 
-	/*
-	 * On Medfield the platform device creation is handled by the MSIC
-	 * MFD driver so we don't need to do it here.
-	 */
-	if (intel_mid_has_msic())
-		return;
-
 	pdev = platform_device_alloc(pentry->name, 0);
 	if (pdev == NULL) {
 		pr_err("out of memory for SFI platform device '%s'.\n",
@@ -862,7 +847,7 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
 	install_irq_resource(pdev, pentry->irq);
 
 	pdev->dev.platform_data = pdata;
-	intel_scu_device_register(pdev);
+	platform_device_add(pdev);
 }
 
 static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
@@ -917,6 +902,46 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
 }
 
+static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev)
+{
+	struct platform_device *pdev;
+	void *pdata = NULL;
+	static struct resource __initdata res = {
+		.name = "IRQ",
+		.flags = IORESOURCE_IRQ,
+	};
+
+	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
+		pentry->name, pentry->irq);
+
+	/*
+	 * We need to call platform init of IPC devices to fill misc_pdata
+	 * structure. It will be used in msic_init for initialization.
+	 */
+	if (dev != NULL)
+		pdata = dev->get_platform_data(pentry);
+
+	/*
+	 * On Medfield the platform device creation is handled by the MSIC
+	 * MFD driver so we don't need to do it here.
+	 */
+	if (intel_mid_has_msic())
+		return;
+
+	pdev = platform_device_alloc(pentry->name, 0);
+	if (pdev == NULL) {
+		pr_err("out of memory for SFI platform device '%s'.\n",
+			pentry->name);
+		return;
+	}
+	res.start = pentry->irq;
+	platform_device_add_resources(pdev, &res, 1);
+
+	pdev->dev.platform_data = pdata;
+	intel_scu_device_register(pdev);
+}
+
 static struct devs_id __init *get_device_id(u8 type, char *name)
 {
 	struct devs_id *dev = device_ids;
-- 
1.7.9.5

