Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaFWI6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:58:07 -0400
Received: from acledge3.advantech.com.tw ([219.90.3.242]:49011 "EHLO
	acledge3.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaFWI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:58:04 -0400
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 1/5] mfd: imanager2: Add defines support for IT8516/18/28
Date: Mon, 23 Jun 2014 01:39:48 -0700
Message-ID: <1403512792-19100-1-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
---
 include/linux/mfd/advantech/imanager2.h    |  59 +++++
 include/linux/mfd/advantech/imanager2_ec.h | 391 +++++++++++++++++++++++++++++
 2 files changed, 450 insertions(+)
 create mode 100644 include/linux/mfd/advantech/imanager2.h
 create mode 100644 include/linux/mfd/advantech/imanager2_ec.h

diff --git a/include/linux/mfd/advantech/imanager2.h b/include/linux/mfd/advantech/imanager2.h
new file mode 100644
index 0000000..80808d1
--- /dev/null
+++ b/include/linux/mfd/advantech/imanager2.h
@@ -0,0 +1,59 @@
+/*
+ * imanager2.h - MFD chip information defines of Advantech EC IT8516/18/28
+ * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __IMANAGER2_H__
+#define __IMANAGER2_H__
+
+#include <linux/mutex.h>
+#include "imanager2_ec.h"
+
+#define EC_FLAG_IO		0
+#define EC_FLAG_IO_MAILBOX	(1 << 0)
+#define EC_FLAG_MAILBOX		(1 << 1)
+
+enum chips {
+	it8516 = 0x8516,
+	it8518 = 0x8518,
+	it8528 = 0x8528,
+};
+
+struct ec_table {
+	u8 devid2itemnum[EC_MAX_DEVICE_ID_NUM];
+	u8 pinnum[EC_MAX_ITEM_NUM];
+	u8 devid[EC_MAX_ITEM_NUM];
+	u8 active_polarity[EC_MAX_ITEM_NUM];
+};
+
+struct ec_version {
+	u16 kernel_ver, chip_code, proj_id, proj_ver;
+};
+
+struct ec_version_info {
+	char prj_name[EC_MAX_LEN_PROJECT_NAME + 1];	/* strlen + '\0' */
+	struct ec_version version;
+};
+
+struct imanager2 {
+	u16 id;
+	u32 flag;
+	struct mutex lock;	/* protects io */
+	struct ec_version_info info;
+	struct ec_table table;
+};
+
+#endif /* __IMANAGER2_H__ */
diff --git a/include/linux/mfd/advantech/imanager2_ec.h b/include/linux/mfd/advantech/imanager2_ec.h
new file mode 100644
index 0000000..fd03de5
--- /dev/null
+++ b/include/linux/mfd/advantech/imanager2_ec.h
@@ -0,0 +1,391 @@
+/*
+ * imanager2_ec.h - MFD driver defines of Advantech EC IT8516/18/28
+ * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __IMANAGER2_EC_H__
+#define __IMANAGER2_EC_H__
+
+/*
+ * Definition
+ */
+#define EC_SIO_CMD		0x29C
+#define EC_SIO_DATA		0x29D
+
+/* Access Mailbox */
+#define EC_IO_PORT_CMD		0x29A
+#define EC_IO_PORT_DATA		0x299
+
+#define EC_IO_CMD_READ_OFFSET	0xA0
+#define EC_IO_CMD_WRITE_OFFSET	0x50
+
+#define EC_ITE_PORT_OFS		0x29E
+#define EC_ITE_PORT_DATA	0x29F
+
+#define EC_TABLE_ITEM_UNUSED	0xFF
+#define EC_TABLE_DID_NODEV	0x00
+#define EC_TABLE_HWP_NODEV	0xFF
+#define EC_TABLE_NOITEM		0xFF
+
+#define EC_ERROR		0xFF
+
+#define EC_RAM_BANK_SIZE	32	/* 32 bytes size for each bank. */
+#define EC_RAM_BUFFER_SIZE	256	/* 32 bytes * 8 banks = 256 bytes */
+
+#define EC_CMD_AUTHENTICATION	0x30
+#define EC_MAX_ITEM_NUM		32
+#define EC_MAX_DEVICE_ID_NUM	0xFF
+#define EC_MAX_LEN_PROJECT_NAME	8
+#define EC_MAX_LEN_FW_VERSION	9
+
+/*
+ * CMD - IO
+ */
+/* ADC */
+#define EC_CMD_ADC_INDEX				0x15
+#define EC_CMD_ADC_READ_LSB				0x16
+#define EC_CMD_ADC_READ_MSB				0x1F
+/* HW Control Table */
+#define EC_CMD_HWCTRLTABLE_INDEX			0x20
+#define EC_CMD_HWCTRLTABLE_GET_PIN_NUM			0x21
+#define EC_CMD_HWCTRLTABLE_GET_DEVICE_ID		0x22
+#define EC_CMD_HWCTRLTABLE_GET_PIN_ACTIVE_POLARITY	0x23
+/* ACPI RAM */
+#define EC_CMD_ACPIRAM_READ				0x80
+#define EC_CMD_ACPIRAM_WRITE				0x81
+/* Extend RAM */
+#define EC_CMD_EXTRAM_READ				0x86
+#define EC_CMD_EXTRAM_WRITE				0x87
+/* HW RAM */
+#define EC_CMD_HWRAM_READ				0x88
+#define EC_CMD_HWRAM_WRITE				0x89
+/* SMB I2C */
+#define EC_CMD_SMB_INDEX				0x8A
+#define EC_CMD_SMB_DEVICE_ADDR				0x8B
+#define EC_CMD_ENABLE_CHANNEL_I2C			0x8C
+#define EC_CMD_DISABLE_CHANNEL_I2C			0x8D
+#define EC_CMD_SETUP_SMBUS_FREQUENCY			0x8E
+
+/*
+ * ACPI RAM Address Table
+ */
+/* n = 1 ~ 2 */
+#define EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n)	(0x60 + 3 * ((n) - 1))
+#define	EC_ACPIRAM_ADDR_LOCAL_TEMPERATURE(n) \
+				EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n)
+#define	EC_ACPIRAM_ADDR_REMOTE_TEMPERATURE(n) \
+				(EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n) + 1)
+#define	EC_ACPIRAM_ADDR_WARNING_TEMPERATURE(n)\
+				(EC_ACPIRAM_ADDR_TEMPERATURE_BASE(n) + 2)
+
+/* N = 0 ~ 2 */
+#define EC_ACPIRAM_ADDR_FAN_SPEED_BASE(N)	(0x70 + 2 * (N))
+
+#define EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION	0xF8
+#define EC_ACPIRAM_ADDR_CHIP_VENDOR_CODE	0xFA
+#define EC_ACPIRAM_ADDR_PROJECT_NAME_CODE	0xFC
+#define EC_ACPIRAM_ADDR_FIRMWARE_MAJOR_VERSION	0xFE
+
+/*
+ * HW RAM Address Table
+ */
+/* SMBus Control RAM */
+#define EC_HWRAM_ADDR_SMB_PROTOCOL	0x00
+#define EC_HWRAM_ADDR_SMB_STATUS	0x01
+#define EC_HWRAM_ADDR_SMB_ADDRESS	0x02
+#define EC_HWRAM_ADDR_SMB_CMD		0x03
+#define EC_HWRAM_ADDR_SMB_DATA(N)	(0x04 + (N))	/* N: 0 ~ 31 */
+#define EC_HWRAM_ADDR_SMB_BLOCKCNT	0x24
+#define EC_HWRAM_ADDR_SMB_SELECTOR	0x2B
+#define EC_HWRAM_ADDR_SMB_I2CCTL	0x2C
+/* Thermal Source Control RAM 0xB0-0xC7 (N: 0 ~ 3) */
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N)	(0xB0 + 6 * (N))
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_CHANNEL(N) \
+				EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_ADDR(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 1)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_CMD(N)	 \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 2)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_STATUS(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 3)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_FAN_CODE(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 4)
+#define EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_TEMPERATURE(N) \
+				(EC_HWRAM_ADDR_THERMAL_SOURCE_BASE_ADDR(N) + 5)
+/* Fan Control 0xD0-0xEF (N: 0 ~ 3) */
+#define EC_HWRAM_ADDR_FAN_BASE_ADDR(N)	(0xD0 + 0x10 * (N))
+#define EC_HWRAM_ADDR_FAN_CODE(N)	EC_HWRAM_ADDR_FAN_BASE_ADDR(N)
+#define EC_HWRAM_ADDR_FAN_STATUS(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 1)
+#define EC_HWRAM_ADDR_FAN_CONTROL(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 2)
+#define EC_HWRAM_ADDR_FAN_TEMP_HI(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 3)
+#define EC_HWRAM_ADDR_FAN_TEMP_LO(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 4)
+#define EC_HWRAM_ADDR_FAN_TEMP_LOSTOP(N) \
+					(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 5)
+#define EC_HWRAM_ADDR_FAN_PWM_HI(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 6)
+#define EC_HWRAM_ADDR_FAN_PWM_LO(N)	(EC_HWRAM_ADDR_FAN_BASE_ADDR(N) + 7)
+
+/*
+ * OFS - Mailbox
+ */
+/* Mailbox Structure */
+#define EC_MAILBOX_OFFSET_CMD		0x00
+#define EC_MAILBOX_OFFSET_STATUS	0x01
+#define EC_MAILBOX_OFFSET_PARA		0x02
+#define EC_MAILBOX_OFFSET_DAT(N)	(0x03 + (N))	/* N = 0x00 ~ 0x2C */
+/* SMBus & I2C */
+#define EC_MAILBOX_OFFSET_SMBI2C_ADDR	EC_MAILBOX_OFFSET_DAT(0x00)
+#define EC_MAILBOX_OFFSET_SMBI2C_CMD	EC_MAILBOX_OFFSET_DAT(0x01)
+#define EC_MAILBOX_OFFSET_SMBI2C_RLEN	EC_MAILBOX_OFFSET_DAT(0x02)
+#define EC_MAILBOX_OFFSET_SMBI2C_WLEN	EC_MAILBOX_OFFSET_DAT(0x03)
+#define EC_MAILBOX_OFFSET_SMBI2C_DAT(N)	EC_MAILBOX_OFFSET_DAT(0x04 + (N))
+#define EC_MAILBOX_SMBI2C_DATA_LENGTH	41	/* 0x04 ~ 0x2C */
+
+/*
+ * CMD - Mailbox
+ */
+/* SMBus/I2C */
+#define EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER		0x01
+#define EC_CMD_MALLBOX_SMBUS_WRITE_QUICK			0x02
+#define EC_CMD_MALLBOX_SMBUS_READ_QUICK				0x03
+#define EC_CMD_MALLBOX_SMBUS_SEND_BYTE				0x04
+#define EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE			0x05
+#define EC_CMD_MALLBOX_SMBUS_WRITE_BYTE				0x06
+#define EC_CMD_MALLBOX_SMBUS_READ_BYTE				0x07
+#define EC_CMD_MALLBOX_SMBUS_WRITE_WORD				0x08
+#define EC_CMD_MALLBOX_SMBUS_READ_WORD				0x09
+#define EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK			0x0A
+#define EC_CMD_MALLBOX_SMBUS_READ_BLOCK				0x0B
+#define EC_CMD_MALLBOX_I2C_READ_WRITE				0x0E
+#define EC_CMD_MALLBOX_I2C_WRITE_READ				0x0F
+/* GPIO */
+#define EC_CMD_MAILBOX_READ_HW_PIN				0x11
+#define EC_CMD_MAILBOX_WRITE_HW_PIN				0x12
+/* Storage */
+#define EC_CMD_MAILBOX_ENABLE_ALL_EC_ACCESS			0x1D
+#define EC_CMD_MAILBOX_READ_EC_RAM				0x1E
+#define EC_CMD_MAILBOX_WRITE_EC_RAM				0x1F
+/* OTHERS */
+#define EC_CMD_MAILBOX_READ_NYNAMIC_TABLE			0x20
+/* SMBus */
+#define EC_CMD_MAILBOX_GET_SMBUS_FREQUENCY			0x34
+#define EC_CMD_MAILBOX_SET_SMBUS_FREQUENCY			0x35
+/* FAN */
+#define EC_CMD_MAILBOX_READ_FAN_CONTROL				0x40
+#define EC_CMD_MAILBOX_WRITE_FAN_CONTROL			0x41
+/* Thermal Protect */
+#define EC_CMD_MAILBOX_READ_THERMAL_SOURCE			0x42
+#define EC_CMD_MAILBOX_WRITE_THERMAL_SOURCE			0x43
+/* Storage */
+#define EC_CMD_MALLBOX_CLEAR_256_BYTES_BUFFER			0xC0
+#define EC_CMD_MALLBOX_READ_256_BYTES_BUFFER			0xC1
+#define EC_CMD_MALLBOX_WRITE_256_BYTES_BUFFER			0xC2
+#define EC_CMD_MALLBOX_READ_EEPROM_DATA_FROM_256_BYTES_BUFFER	0xC3
+#define EC_CMD_MALLBOX_WRITE_256_BYTES_BUFFER_INTO_EEPROM_DATA	0xC4
+/* General Mailbox Command */
+#define EC_CMD_MAILBOX_GET_FIRMWARE_VERSION_AND_PROJECT_NAME	0xF0
+#define EC_CMD_MAILBOX_CLEAR_ALL				0xFF
+
+/*
+ * Status - Mailbox
+ */
+#define EC_MAILBOX_STATUS_FAIL		0x00
+#define EC_MAILBOX_STATUS_SUCCESS	0x01
+
+/*
+ * PARA - Mailbox
+ */
+/* RAM Type */
+#define EC_RAM_BANK_ACPI	0x01
+#define EC_RAM_BANK_HW		0x02
+#define EC_RAM_BANK_EXT		0x03
+#define EC_RAM_BANK_BUFFER	0x06
+/* Dynamic Type */
+#define EC_DYNAMIC_DEVICE_ID	0x00
+#define EC_DYNAMIC_HW_PIN	0x01
+#define EC_DYNAMIC_POLARITY	0x02
+
+/*
+ * Functions - Mailbox
+ */
+struct imanager2;
+
+/* command = 0x20 */
+int imanager2_get_dynamic_table(struct imanager2 *ec, u8 *did, u8 *hwpin,
+				u8 *pol);
+/* command = 0x42 */
+int imanager2_read_thermalzone(struct imanager2 *ec, u8 zone, u8 *smbid,
+			       u8 *fanid, u8 *buf, int *len);
+/* command = 0xC0 */
+int imanager2_clear_buffer_ram(struct imanager2 *ec);
+/* command = 0xC1 */
+int imanager2_read_buffer_ram(struct imanager2 *ec, u8 *data, int len);
+/* command = 0x1E */
+int imanager2_read_ram(struct imanager2 *ec, u8 bank, u8 offset, u8 *buf,
+		       u8 len);
+/* command = 0x1F */
+int imanager2_write_ram(struct imanager2 *ec, u8 bank, u8 offset, u8 *buf,
+			u8 len);
+/* command = 0xF0 */
+int imanager2_get_firmware_version_and_project_name(struct imanager2 *ec,
+						    u8 *prj_name,
+						    u16 *kernel_ver,
+						    u16 *chip_code,
+						    u16 *proj_id,
+						    u16 *proj_ver);
+/* command = 0xFF */
+int imanager2_clear_mailbox(struct imanager2 *ec);
+
+/*
+ * Functions - basic
+ */
+/* ITE mailbox available */
+#define OBF_MASK	(1 << 0)
+#define IBF_MASK	(1 << 1)
+int inb_after_obf(u8 *data);
+int outb_after_ibc(u16 port, u8 data);
+int imanager2_read_mailbox_buffer(struct imanager2 *ec, u8 cmd, u8 para,
+				  u8 *data, int len);
+int imanager2_write_mailbox_buffer(struct imanager2 *ec, u8 cmd, u8 para,
+				   u8 *data, int len);
+/* only IO chennel available */
+int imanager2_io_read(u8 command, u8 offset, u8 *buf, u8 len);
+int imanager2_io_write(u8 command, u8 offset, u8 *buf, u8 len);
+int imanager2_io_read_byte_without_offset(u8 command, u8 *value);
+/* ITE Mailbox & IO chennel */
+int imanager2_acpiram_read_byte(struct imanager2 *ec, u8 addr, u8 *value);
+int imanager2_acpiram_write_byte(struct imanager2 *ec, u8 addr, u8 value);
+int imanager2_hwram_read_byte(struct imanager2 *ec, u8 addr, u8 *value);
+int imanager2_hwram_write_byte(struct imanager2 *ec, u8 addr, u8 value);
+int imanager2_smbus_transmit_routine(struct imanager2 *ec, u8 did, u8 protocol,
+				     u8 addr, u8 cmd, u8 *wdata, u8 wlen,
+				     u8 *rdata, u8 *rlen);
+
+/*
+ * Device ID
+ */
+enum ec_device_id {
+	/* GPIO */
+	altgpio0 = 0x10,	/* 0x10 */
+	altgpio1,
+	altgpio2,
+	altgpio3,
+	altgpio4,
+	altgpio5,
+	altgpio6,
+	altgpio7,
+	/* GPIO - Button */
+	btn0,
+	btn1,
+	btn2,
+	btn3,
+	btn4,
+	btn5,
+	btn6,
+	btn7,
+	/* PWM - Fan */
+	cpufan_2p,		/* 0x20 */
+	cpufan_4p,
+	sysfan1_2p,
+	sysfan1_4p,
+	sysfan2_2p,
+	sysfan2_4p,
+	/* PWM - Brightness Control */
+	pwmbrightness,
+	/* PWM - System Speaker */
+	pwmbeep,
+	/* SMBus */
+	smboem0,
+	smboem1,
+	smboem2,
+	smbeeprom,
+	smbthermal0,
+	smbthermal1,
+	smbsecurityeep,
+	i2coem,
+	/* DAC - Speaker */
+	dacspeaker,		/* 0x30 */
+	/* SMBus */
+	smbeep2k = 0x38,
+	oemeep,
+	oemeep2k,
+	peci,
+	smboem3,
+	smblink,
+	smbslv,
+	/* GPIO - LED */
+	powerled = 0x40,	/* 0x40 */
+	batledg,
+	oemled0,
+	oemled1,
+	oemled2,
+	batledr,
+	/* SMBus - Smart Battery */
+	smartbat1 = 0x48,
+	smartbat2,
+	/* ADC */
+	adcmosbat = 0x50,	/* 0x50 */
+	adcmosbatx2,
+	adcmosbatx10,
+	adcbat,
+	adcbatx2,
+	adcbatx10,
+	adc5vs0,
+	adc5vs0x2,
+	adc5vs0x10,
+	adv5vs5,
+	adv5vs5x2,
+	adv5vs5x10,
+	adc33vs0,
+	adc33vs0x2,
+	adc33vs0x10,
+	adc33vs5,
+	adc33vs5x2,		/* 0x60 */
+	adc33vs5x10,
+	adv12vs0,
+	adv12vs0x2,
+	adv12vs0x10,
+	adcvcorea,
+	adcvcoreax2,
+	adcvcoreax10,
+	adcvcoreb,
+	adcvcorebx2,
+	adcvcorebx10,
+	adcdc,
+	adcdcx2,
+	adcdcx10,
+	adcdcstby,
+	adcdcstbyx2,
+	adcdcstbyx10,		/* 0x70 */
+	adcdcother,
+	adcdcotherx2,
+	adcdcotherx10,
+	adccurrent,
+	/* IRQ - Watchdog */
+	wdirq = 0x78,
+	/* GPIO - Watchdog */
+	wdnmi,
+	/* Tacho - Fan */
+	tacho0 = 0x80,		/* 0x80 */
+	tacho1,
+	tacho2,
+	/* PWM - Brightness Control */
+	pwmbrightness2 = 0x88,
+	/* GPIO - Backlight Control */
+	brionoff1,
+	brionoff2,
+};
+
+#endif /* __IMANAGER2_EC_H__ */
-- 
1.9.1

