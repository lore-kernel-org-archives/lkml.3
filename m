Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762340Ab3JQSTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:19:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45996 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762311Ab3JQSTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:19:34 -0400
Date: Thu, 17 Oct 2013 11:19:23 -0700
From: tip-bot for Kuppuswamy Sathyanarayanan <tipbot@zytor.com>
Message-ID: <tip-2f34908ca11015254dd318ec05d602e162b884f9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381896701-23476-8-git-send-email-david.a.cohen@linux.intel.com>
References: <1381896701-23476-8-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] intel_mid:
  Added custom device_handler support
Git-Commit-ID: 2f34908ca11015254dd318ec05d602e162b884f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 11:19:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f34908ca11015254dd318ec05d602e162b884f9
Gitweb:     http://git.kernel.org/tip/2f34908ca11015254dd318ec05d602e162b884f9
Author:     Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
AuthorDate: Tue, 15 Oct 2013 21:11:36 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 Oct 2013 17:16:43 -0700

intel_mid: Added custom device_handler support

This patch provides a means to add custom handler for
SFI devices. If you set device_handler as NULL in
device_id table standard SFI device handler will be used.
If its not NULL custom handler will be called.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: http://lkml.kernel.org/r/1381896701-23476-8-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/intel-mid/intel-mid.c | 74 ++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index f9c4be8..7bfd784 100644
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
@@ -690,28 +693,27 @@ static void *tc35876x_platform_data(void *data)
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
-	{},
+	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data, NULL},
+	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data, NULL},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data, NULL},
+	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data, NULL},
+	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data, NULL},
+	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data, NULL},
+	{ 0 }
 };
 
 #define MAX_IPCDEVS	24
@@ -965,20 +967,24 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
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
