Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652AbaHGJhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:37:00 -0400
Received: from acledge1.advantech.com.tw ([61.58.41.197]:38950 "EHLO
	acledge1.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633AbaHGJg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:36:58 -0400
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2014 05:36:58 EDT
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Guenter Roeck <linux@roeck-us.net>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@the-dreams.de>,
        "Louis.Lu" <Louis.Lu@advantech.com.tw>,
        "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 1/3] imanager2: rename io functions and remove no used functions
Date: Thu, 7 Aug 2014 02:20:11 -0700
Message-ID: <1407403213-3546-1-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
---
 drivers/hwmon/imanager2_hwm.c    | 27 +++++------
 drivers/mfd/imanager2_core.c     | 64 +++++++++++---------------
 drivers/mfd/imanager2_ec.c       | 99 ++++++++--------------------------------
 include/linux/mfd/imanager2_ec.h | 24 ++++------
 4 files changed, 67 insertions(+), 147 deletions(-)

diff --git a/drivers/hwmon/imanager2_hwm.c b/drivers/hwmon/imanager2_hwm.c
index 335bffb..ab63296 100644
--- a/drivers/hwmon/imanager2_hwm.c
+++ b/drivers/hwmon/imanager2_hwm.c
@@ -119,17 +119,17 @@ static int imanager2_volt_get_value_by_io(struct imanager2 *ec, int index,
 	u8 portnum;
 	int ret;
 
-	ret = imanager2_mbox_io_read(EC_CMD_ADC_INDEX, pin, &portnum, 1);
+	ret = imanager2_io_read_data(EC_CMD_ADC_INDEX, pin, &portnum, 1);
 	if (ret)
 		return ret;
 	if (portnum == EC_ERROR)
 		return -ENXIO;
 
-	ret = imanager2_mbox_io_simple_read(EC_CMD_ADC_READ_LSB, &buf[1]);
+	ret = imanager2_io_nooffset_readbyte(EC_CMD_ADC_READ_LSB, &buf[1]);
 	if (ret)
 		return ret;
 
-	return imanager2_mbox_io_simple_read(EC_CMD_ADC_READ_MSB, &buf[0]);
+	return imanager2_io_nooffset_readbyte(EC_CMD_ADC_READ_MSB, &buf[0]);
 }
 
 static int imanager2_volt_get_value(struct imanager2 *ec, int index,
@@ -468,7 +468,7 @@ static void imanager2_temp_init(struct imanager2 *ec)
 							      (u8 *)&zone,
 							      &len);
 		} else {
-			ret = imanager2_mbox_io_read(
+			ret = imanager2_io_read_data(
 				EC_CMD_HWRAM_READ,
 				EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_STATUS(thm),
 				&zone.status, 1);
@@ -566,20 +566,17 @@ static struct fan_item ec_fan_table[] = {
 	{
 		.did = tacho0,
 		.name = "Fan CPU",
-		.fspeed_acpireg = 0,
-		.visible = false
+		.visible = false,
 	},
 	{
 		.did = tacho1,
 		.name = "Fan SYS",
-		.fspeed_acpireg = 0,
-		.visible = false
+		.visible = false,
 	},
 	{
 		.did = tacho2,
 		.name = "Fan SYS2",
-		.fspeed_acpireg = 0,
-		.visible = false
+		.visible = false,
 	},
 };
 
@@ -596,7 +593,7 @@ static int imanager2_fan_get_value(struct imanager2 *ec, int index,
 					       EC_CMD_MAILBOX_READ_HW_PIN,
 					       ec_fan_table[index].did, tmp, 2);
 	else
-		ret = imanager2_mbox_io_read(EC_CMD_ACPIRAM_READ,
+		ret = imanager2_io_read_data(EC_CMD_ACPIRAM_READ,
 					     ec_fan_table[index].fspeed_acpireg,
 					     tmp, 2);
 
@@ -605,11 +602,11 @@ static int imanager2_fan_get_value(struct imanager2 *ec, int index,
 	if (ret)
 		return ret;
 
-	if (tmp[0] == 0xFF && tmp[1] == 0xFF)
-		return -ENODEV;
-
 	*speed_rpm = (tmp[0] << 8) | tmp[1];
 
+	if (*speed_rpm == 0xFFFF)
+		*speed_rpm = 0;
+
 	return 0;
 }
 
@@ -621,7 +618,7 @@ static int imanager2_fan_item_init_by_io(struct imanager2 *ec, int fnum)
 	u8 tmp;
 
 	mutex_lock(&ec->lock);
-	ret = imanager2_mbox_io_read(EC_CMD_HWRAM_READ,
+	ret = imanager2_io_read_data(EC_CMD_HWRAM_READ,
 				     EC_HWRAM_ADDR_FAN_CONTROL(fnum), &tmp, 1);
 	mutex_unlock(&ec->lock);
 
diff --git a/drivers/mfd/imanager2_core.c b/drivers/mfd/imanager2_core.c
index 2264d29..a978d96 100644
--- a/drivers/mfd/imanager2_core.c
+++ b/drivers/mfd/imanager2_core.c
@@ -38,7 +38,7 @@ enum chips {
 	it8528 = 0x8528,
 };
 
-#define EC_CMD_AUTHENTICATION	0x30
+#define EC_EBRAIN_CODE		0x95
 
 static int imanager2_authentication(struct imanager2 *ec)
 {
@@ -52,28 +52,24 @@ static int imanager2_authentication(struct imanager2 *ec)
 		goto unlock;
 	}
 
-	if (inb(EC_IO_PORT_CMD) & IO_FLAG_OBF)
-		inb(EC_IO_PORT_DATA);	/* initial OBF */
-
-	if (ec_outb_after_ibc0(EC_IO_PORT_CMD, EC_CMD_AUTHENTICATION)) {
-		ret = -ENODEV;
-		goto unlock;
-	}
-
-	ret = ec_inb_after_obf1(&tmp);
+	ec_clear_obf();
 
+	ret = imanager2_io_nooffset_readbyte(EC_CMD_AUTHENTICATION, &tmp);
 unlock:
 	mutex_unlock(&ec->lock);
 
 	if (ret)
 		return ret;
 
-	if (tmp != 0x95)
+	if (tmp != EC_EBRAIN_CODE)
 		return -ENODEV;
 
 	return 0;
 }
 
+#define EC_SIO_CMD		0x29C
+#define EC_SIO_DATA		0x29D
+
 #define EC_ITE_CHIPID_H8	0x20
 #define EC_ITE_CHIPID_L8	0x21
 
@@ -94,6 +90,7 @@ static int imanager2_get_chip_type(struct imanager2 *ec)
 		ec->flag = EC_FLAG_IO;
 		break;
 	case it8528:
+		ec->flag = EC_FLAG_IO;
 		ec->flag |= EC_FLAG_IO_MAILBOX;
 		break;
 	default:
@@ -106,45 +103,38 @@ static int imanager2_get_chip_type(struct imanager2 *ec)
 /*
  * EC provides IO channel and ITE mailbox ways to access mailbox. IO channel is
  * a common way to access mailbox, but IET mailbox way is much faster than IO
- * channel. We prefer ITE mailbox if firmware supports. Source kernel code
- * X11_05 the first firmware version that supports ITE mailbox.
+ * channel. We prefer ITE mailbox if firmware supports. Source code of X11_05
+ * kernel is the first firmware version that supports ITE mailbox.
  */
 #define EC_CHIPFW_SUPP_ITEMAILBOX	0x1105
 
-static int imanager2_get_info(struct imanager2 *ec)
+static int imanager2_is_support_mailbox(struct imanager2 *ec)
 {
 	int ret;
 	u8 *tmp = (u8 *)&ec->version.kernel_ver;
 
+	ec->flag = EC_FLAG_IO;
+
 	mutex_lock(&ec->lock);
 
-	ret = imanager2_mbox_io_read(EC_CMD_ACPIRAM_READ,
+	ret = imanager2_io_read_data(EC_CMD_ACPIRAM_READ,
 				     EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION,
 				     &tmp[0], 2);
 
+	mutex_unlock(&ec->lock);
+
 	if (ret)
-		goto unlock;
+		return ret;
 
-	if (ec->version.kernel_ver >= EC_CHIPFW_SUPP_ITEMAILBOX) {
+	if (ec->version.kernel_ver >= EC_CHIPFW_SUPP_ITEMAILBOX)
 		ec->flag |= EC_FLAG_MAILBOX;
-		ret = imanager2_mbox_get_project_information(
-			ec->flag, ec->prj_name,
-			&ec->version.kernel_ver, &ec->version.chip_code,
-			&ec->version.prj_id, &ec->version.prj_ver);
-	} else {
+	else
 		ec->flag &= ~EC_FLAG_MAILBOX;
-		ret = imanager2_mbox_io_read(
-			EC_CMD_ACPIRAM_READ,
-			EC_ACPIRAM_ADDR_KERNEL_MAJOR_VERSION,
-			&tmp[0], sizeof(struct ec_version));
-	}
-unlock:
-	mutex_unlock(&ec->lock);
 
-	return ret;
+	return 0;
 }
 
-static int imanager2_device_initial_by_ite(struct imanager2 *ec)
+static int imanager2_device_initial_by_mbox(struct imanager2 *ec)
 {
 	int i, ret;
 
@@ -181,19 +171,19 @@ static int imanager2_device_initial_by_io(struct imanager2 *ec)
 	mutex_lock(&ec->lock);
 
 	for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
-		ret = imanager2_mbox_io_read
+		ret = imanager2_io_read_data
 		      (EC_CMD_HWCTRLTABLE_INDEX, i, &tmp, 1);
 		if (ret)
 			break;
 		if (tmp == EC_TABLE_NOITEM)
 			break;
 
-		ret = imanager2_mbox_io_simple_read(
+		ret = imanager2_io_nooffset_readbyte(
 			EC_CMD_HWCTRLTABLE_GET_PIN_NUM, &ec->table.pinnum[i]);
 		if (ret)
 			break;
 
-		ret = imanager2_mbox_io_simple_read(
+		ret = imanager2_io_nooffset_readbyte(
 			EC_CMD_HWCTRLTABLE_GET_DEVICE_ID, &ec->table.devid[i]);
 		if (ret)
 			break;
@@ -225,7 +215,7 @@ static int imanager2_build_device_table(struct imanager2 *ec)
 	       ARRAY_SIZE(ec->table.devid2itemnum));
 
 	if (ec->flag & EC_FLAG_MAILBOX)
-		return imanager2_device_initial_by_ite(ec);
+		return imanager2_device_initial_by_mbox(ec);
 	else
 		return imanager2_device_initial_by_io(ec);
 }
@@ -234,7 +224,7 @@ static struct platform_device *ec_pdev;
 
 static int __init imanager2_mfd_device_init(void)
 {
-	struct imanager2 ec = { 0 };
+	struct imanager2 ec = {0};
 	int ret;
 
 	mutex_init(&ec.lock);
@@ -247,7 +237,7 @@ static int __init imanager2_mfd_device_init(void)
 	if (ret)
 		return ret;
 
-	ret = imanager2_get_info(&ec);
+	ret = imanager2_is_support_mailbox(&ec);
 	if (ret)
 		return ret;
 
diff --git a/drivers/mfd/imanager2_ec.c b/drivers/mfd/imanager2_ec.c
index f7a0003..ad6c3cd 100644
--- a/drivers/mfd/imanager2_ec.c
+++ b/drivers/mfd/imanager2_ec.c
@@ -23,6 +23,16 @@
 #define EC_UDELAY_TIME		50
 #define EC_MAX_TIMEOUT_COUNT	1000
 
+#define IO_FLAG_OBF	(1 << 0)	/* output buffer full */
+#define IO_FLAG_IBF	(1 << 1)	/* input buffer full  */
+
+void ec_clear_obf(void)
+{
+	if (inb(EC_IO_PORT_CMD) & IO_FLAG_OBF)
+		inb(EC_IO_PORT_DATA);
+}
+EXPORT_SYMBOL(ec_clear_obf);
+
 static int ec_wait_obf1(void)
 {
 	int i = EC_MAX_TIMEOUT_COUNT;
@@ -428,81 +438,8 @@ int imanager2_mbox_read_thermalzone(u32 ecflag, u8 zone, u8 *smbid, u8 *fanid,
 }
 EXPORT_SYMBOL(imanager2_mbox_read_thermalzone);
 
-int imanager2_mbox_get_project_information(u32 ecflag, u8 *prj_name,
-					   u16 *kernel_ver, u16 *chip_code,
-					   u16 *prj_id, u16 *prj_ver)
-{
-	int ret, i;
-
-	if (!prj_name && !kernel_ver && !chip_code && !prj_id && !prj_ver)
-		return -EINVAL;
-
-	ret = imanager2_wait_mailbox_command0(ecflag);
-	if (ret)
-		return ret;
-
-	ret = imanager2_write_mailbox(
-		ecflag, EC_MAILBOX_OFFSET_CMD,
-		EC_CMD_MAILBOX_GET_FIRMWARE_VERSION_AND_PROJECT_NAME);
-
-	ret = imanager2_wait_mailbox_command0(ecflag);
-	if (ret)
-		return ret;
-
-	if (prj_name) {
-		/* projection name length must be 9 bytes */
-		for (i = 0; i < EC_MAX_LEN_PROJECT_NAME; i++) {
-			ret = imanager2_read_mailbox(ecflag,
-						     EC_MAILBOX_OFFSET_DAT(i),
-						     &prj_name[i]);
-			if (ret)
-				return ret;
-		}
-		prj_name[EC_MAX_LEN_PROJECT_NAME] = '\0';
-	}
-
-	if (kernel_ver)
-		for (i = 0; i < sizeof(*kernel_ver); i++) {
-			ret = imanager2_read_mailbox(
-				ecflag, EC_MAILBOX_OFFSET_DAT(0x09 + i),
-				(u8 *)kernel_ver + i);
-			if (ret)
-				return ret;
-		}
-
-	if (chip_code)
-		for (i = 0; i < sizeof(*chip_code); i++) {
-			ret = imanager2_read_mailbox(
-				ecflag, EC_MAILBOX_OFFSET_DAT(0x0B + i),
-				(u8 *)chip_code + i);
-			if (ret)
-				return ret;
-		}
-
-	if (prj_id)
-		for (i = 0; i < sizeof(*prj_id); i++) {
-			ret = imanager2_read_mailbox(
-				ecflag, EC_MAILBOX_OFFSET_DAT(0x0D + i),
-				(u8 *)prj_id + i);
-			if (ret)
-				return ret;
-		}
-
-	if (prj_ver)
-		for (i = 0; i < sizeof(*prj_ver); i++) {
-			ret = imanager2_read_mailbox(
-				ecflag, EC_MAILBOX_OFFSET_DAT(0x0F + i),
-				(u8 *)prj_ver + i);
-			if (ret)
-				return ret;
-		}
-
-	return 0;
-}
-EXPORT_SYMBOL(imanager2_mbox_get_project_information);
-
 /* IO chennel access */
-int imanager2_mbox_io_read(u8 command, u8 offset, u8 *buf, u8 len)
+int imanager2_io_read_data(u8 command, u8 offset, u8 *buf, u8 len)
 {
 	int ret, i;
 
@@ -528,9 +465,9 @@ int imanager2_mbox_io_read(u8 command, u8 offset, u8 *buf, u8 len)
 
 	return 0;
 }
-EXPORT_SYMBOL(imanager2_mbox_io_read);
+EXPORT_SYMBOL(imanager2_io_read_data);
 
-int imanager2_mbox_io_write(u8 command, u8 offset, u8 *buf, u8 len)
+int imanager2_io_write_data(u8 command, u8 offset, u8 *buf, u8 len)
 {
 	int ret, i;
 
@@ -553,9 +490,9 @@ int imanager2_mbox_io_write(u8 command, u8 offset, u8 *buf, u8 len)
 
 	return 0;
 }
-EXPORT_SYMBOL(imanager2_mbox_io_write);
+EXPORT_SYMBOL(imanager2_io_write_data);
 
-int imanager2_mbox_io_simple_read(u8 command, u8 *value)
+int imanager2_io_nooffset_readbyte(u8 command, u8 *value)
 {
 	int ret;
 
@@ -568,7 +505,7 @@ int imanager2_mbox_io_simple_read(u8 command, u8 *value)
 
 	return ec_inb_after_obf1(value);
 }
-EXPORT_SYMBOL(imanager2_mbox_io_simple_read);
+EXPORT_SYMBOL(imanager2_io_nooffset_readbyte);
 
 /* ITE Mailbox & IO chennel access*/
 int imanager2_mbox_read_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
@@ -588,7 +525,7 @@ int imanager2_mbox_read_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
 		else
 			return -EINVAL;
 
-		return imanager2_mbox_io_read(iocmd, addr, buf, len);
+		return imanager2_io_read_data(iocmd, addr, buf, len);
 	}
 }
 EXPORT_SYMBOL(imanager2_mbox_read_ram_support_io);
@@ -610,6 +547,6 @@ int imanager2_mbox_write_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
 	else
 		return -EINVAL;
 
-	return imanager2_mbox_io_write(iocmd, addr, buf, len);
+	return imanager2_io_write_data(iocmd, addr, buf, len);
 }
 EXPORT_SYMBOL(imanager2_mbox_write_ram_support_io);
diff --git a/include/linux/mfd/imanager2_ec.h b/include/linux/mfd/imanager2_ec.h
index bf7d70e..47baa6e 100644
--- a/include/linux/mfd/imanager2_ec.h
+++ b/include/linux/mfd/imanager2_ec.h
@@ -22,8 +22,8 @@
 #include <linux/mutex.h>
 
 #define EC_FLAG_IO		0
-#define EC_FLAG_IO_MAILBOX	(1 << 0)
-#define EC_FLAG_MAILBOX		(1 << 1)
+#define EC_FLAG_MAILBOX		(1 << 0)
+#define EC_FLAG_IO_MAILBOX	(1 << 1)
 
 #define EC_MAX_DEVICE_ID_NUM	0xFF
 #define EC_MAX_ITEM_NUM		32
@@ -65,9 +65,6 @@ struct imanager2 {
 #define EC_RAM_BANK_SIZE	32	/* 32 bytes size for each bank. */
 #define EC_RAM_BUFFER_SIZE	256	/* 32 bytes * 8 banks = 256 bytes */
 
-#define EC_SIO_CMD		0x29C
-#define EC_SIO_DATA		0x29D
-
 /* Access Mailbox */
 #define EC_IO_PORT_CMD		0x29A
 #define EC_IO_PORT_DATA		0x299
@@ -90,6 +87,8 @@ struct imanager2 {
 #define EC_CMD_HWCTRLTABLE_GET_PIN_NUM			0x21
 #define EC_CMD_HWCTRLTABLE_GET_DEVICE_ID		0x22
 #define EC_CMD_HWCTRLTABLE_GET_PIN_ACTIVE_POLARITY	0x23
+/* Authentication */
+#define EC_CMD_AUTHENTICATION				0x30
 /* ACPI RAM */
 #define EC_CMD_ACPIRAM_READ				0x80
 #define EC_CMD_ACPIRAM_WRITE				0x81
@@ -217,28 +216,25 @@ int imanager2_mbox_read_ram_across_banks(u32 ecflag, u8 *data, int len);
 int imanager2_mbox_read_ram(u32 ecflag, u8 bank, u8 offset, u8 *buf, u8 len);
 /* command = 0x1F */
 int imanager2_mbox_write_ram(u32 ecflag, u8 bank, u8 offset, u8 *buf, u8 len);
-/* command = 0xF0 */
-int imanager2_mbox_get_project_information(u32 ecflag, u8 *prj_name,
-					   u16 *kernel_ver, u16 *chip_code,
-					   u16 *prj_id, u16 *prj_ver);
 
 /*
  * Functions - basic
  */
-#define IO_FLAG_OBF	(1 << 0)	/* output buffer full */
-#define IO_FLAG_IBF	(1 << 1)	/* input buffer full  */
+void ec_clear_obf(void);
 int ec_inb_after_obf1(u8 *data);
 int ec_outb_after_ibc0(u16 port, u8 data);
 /* ITE mailbox access */
 int imanager2_mbox_read_data(u32 ecflag, u8 cmd, u8 para, u8 *data, int len);
 int imanager2_mbox_write_data(u32 ecflag, u8 cmd, u8 para, u8 *data, int len);
 /* only IO access */
-int imanager2_mbox_io_read(u8 command, u8 offset, u8 *buf, u8 len);
-int imanager2_mbox_io_write(u8 command, u8 offset, u8 *buf, u8 len);
-int imanager2_mbox_io_simple_read(u8 command, u8 *value);
+int imanager2_io_read_data(u8 command, u8 offset, u8 *buf, u8 len);
+int imanager2_io_write_data(u8 command, u8 offset, u8 *buf, u8 len);
+int imanager2_io_nooffset_readbyte(u8 command, u8 *value);
 /* ITE Mailbox & IO access */
 int imanager2_mbox_read_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
 				       u8 len);
+int imanager2_mbox_write_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
+					u8 len);
 
 /*
  * Device ID
-- 
1.9.1

