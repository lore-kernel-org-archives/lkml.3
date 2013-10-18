Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab3JRAen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:34:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50196 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab3JRAek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:34:40 -0400
Date: Thu, 17 Oct 2013 17:34:29 -0700
From: tip-bot for Kuppuswamy Sathyanarayanan <tipbot@zytor.com>
Message-ID: <tip-49c72a0a8ad640fa6026962056eeaf85a4ce79fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1382049336-21316-9-git-send-email-david.a.cohen@linux.intel.com>
References: <1382049336-21316-9-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] intel_mid:
  Added custom handler for ipc devices
Git-Commit-ID: 49c72a0a8ad640fa6026962056eeaf85a4ce79fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 17:34:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49c72a0a8ad640fa6026962056eeaf85a4ce79fd
Gitweb:     http://git.kernel.org/tip/49c72a0a8ad640fa6026962056eeaf85a4ce79fd
Author:     Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
AuthorDate: Thu, 17 Oct 2013 15:35:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Oct 2013 16:40:50 -0700

intel_mid: Added custom handler for ipc devices

Added a custom handler for medfield based ipc devices and
moved devs_id structure defintion to header file.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: http://lkml.kernel.org/r/1382049336-21316-9-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/intel-mid.h        | 15 ++++++
 arch/x86/platform/intel-mid/intel-mid.c | 82 ++++++++++++++++++++-------------
 2 files changed, 66 insertions(+), 31 deletions(-)

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
index 7bfd784..40a3ff8 100644
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
 
@@ -695,24 +682,24 @@ static void *tc35876x_platform_data(void *data)
 static const struct devs_id __initconst device_ids[] = {
 	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data, NULL},
 	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data, NULL},
-	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data, NULL},
+	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data, &ipc_device_handler},
 	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data, NULL},
 	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
 	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
 	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data, NULL},
 	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data, NULL},
 	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data, NULL},
-	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data, NULL},
+	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data, &ipc_device_handler},
 	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data, NULL},
 	{"i2c_disp_brig", SFI_DEV_TYPE_I2C, 0, &tc35876x_platform_data, NULL},
 
 	/* MSIC subdevices */
-	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data, NULL},
-	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, NULL},
-	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, NULL},
-	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data, NULL},
-	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, NULL},
-	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data, NULL},
+	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data, &ipc_device_handler},
+	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, &ipc_device_handler},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, &ipc_device_handler},
+	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data, &ipc_device_handler},
+	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, &ipc_device_handler},
+	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data, &ipc_device_handler},
 	{ 0 }
 };
 
@@ -843,13 +830,6 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
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
@@ -859,7 +839,7 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
 	install_irq_resource(pdev, pentry->irq);
 
 	pdev->dev.platform_data = pdata;
-	intel_scu_device_register(pdev);
+	platform_device_add(pdev);
 }
 
 static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
@@ -914,6 +894,46 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
 }
 
+static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev)
+{
+	struct platform_device *pdev;
+	void *pdata = NULL;
+	static struct resource res __initdata = {
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
