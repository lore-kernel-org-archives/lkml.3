Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3JJF5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:57:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:25163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab3JJF4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1069,1371106800"; 
   d="scan'208";a="417008919"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2 07/10] intel_mid: Added custom device_handler support
Date: Wed,  9 Oct 2013 23:00:04 -0700
Message-Id: <1381384807-14146-8-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

This patch provides a means to add custom handler for
SFI devices. If you set device_handler as NULL in
device_id table standard SFI device handler will be used.
If its not NULL custom handler will be called.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/intel-mid/intel-mid.c |   75 +++++++++++++++++--------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index f9c4be8..65c7bca 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -396,6 +396,9 @@ struct devs_id {
 	u8 type;
 	u8 delay;
 	void *(*get_platform_data)(void *info);
+	/* Custom handler for devices */
+	void (*device_handler)(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev);
 };
 
 /* the offset for the mapping of global gpio pin to irq */
@@ -690,27 +693,29 @@ static void *tc35876x_platform_data(void *data)
 }
 
 static const struct devs_id __initconst device_ids[] = {
-	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data},
-	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data},
-	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data},
-	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data},
-	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
-	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data},
-	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data},
-	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data},
-	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data},
-	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data},
-	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data},
-	{"i2c_disp_brig", SFI_DEV_TYPE_I2C, 0, &tc35876x_platform_data},
+	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data, NULL},
+	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data, NULL},
+	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data, NULL},
+	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data, NULL},
+	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
+	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
+	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data, NULL},
+	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data, NULL},
+	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data, NULL},
+	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data, NULL},
+	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data, NULL},
+	{"i2c_disp_brig", SFI_DEV_TYPE_I2C, 0, &tc35876x_platform_data, NULL},
 
 	/* MSIC subdevices */
-	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data},
-	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data},
-	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data},
-	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data},
-	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data},
-	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data},
-
+	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data,
+					NULL},
+	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, NULL},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, NULL},
+	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data,
+					NULL},
+	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, NULL},
+	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data,
+					NULL},
 	{},
 };
 
@@ -965,20 +970,24 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 		if ((dev == NULL) || (dev->get_platform_data == NULL))
 			continue;
 
-		switch (pentry->type) {
-		case SFI_DEV_TYPE_IPC:
-			sfi_handle_ipc_dev(pentry, dev);
-			break;
-		case SFI_DEV_TYPE_SPI:
-			sfi_handle_spi_dev(pentry, dev);
-			break;
-		case SFI_DEV_TYPE_I2C:
-			sfi_handle_i2c_dev(pentry, dev);
-			break;
-		case SFI_DEV_TYPE_UART:
-		case SFI_DEV_TYPE_HSI:
-		default:
-			break;
+		if (dev->device_handler) {
+			dev->device_handler(pentry, dev);
+		} else {
+			switch (pentry->type) {
+			case SFI_DEV_TYPE_IPC:
+				sfi_handle_ipc_dev(pentry, dev);
+				break;
+			case SFI_DEV_TYPE_SPI:
+				sfi_handle_spi_dev(pentry, dev);
+				break;
+			case SFI_DEV_TYPE_I2C:
+				sfi_handle_i2c_dev(pentry, dev);
+				break;
+			case SFI_DEV_TYPE_UART:
+			case SFI_DEV_TYPE_HSI:
+			default:
+				break;
+			}
 		}
 	}
 	return 0;
-- 
1.7.9.5

