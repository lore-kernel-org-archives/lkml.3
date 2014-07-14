Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbaGNMzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:55:17 -0400
Received: from acledge3.advantech.com.tw ([219.90.3.242]:45987 "EHLO
	acledge3.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaGNMzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:55:11 -0400
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 2/4] mfd: imanager2: Add Advantech EC APIs support for IT8516/18/28
Date: Mon, 14 Jul 2014 05:54:44 -0700
Message-ID: <1405342486-17031-2-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405342486-17031-1-git-send-email-weichun.pan@advantech.com.tw>
References: <1405342486-17031-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
---
 drivers/mfd/imanager2_ec.c | 615 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 615 insertions(+)
 create mode 100644 drivers/mfd/imanager2_ec.c

diff --git a/drivers/mfd/imanager2_ec.c b/drivers/mfd/imanager2_ec.c
new file mode 100644
index 0000000..f7a0003
--- /dev/null
+++ b/drivers/mfd/imanager2_ec.c
@@ -0,0 +1,615 @@
+/*
+ * imanager2_ec.c - MFD accessing driver of Advantech EC IT8516/18/28
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
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/mfd/imanager2_ec.h>
+
+#define EC_UDELAY_TIME		50
+#define EC_MAX_TIMEOUT_COUNT	1000
+
+static int ec_wait_obf1(void)
+{
+	int i = EC_MAX_TIMEOUT_COUNT;
+	while (i--) {
+		if (inb(EC_IO_PORT_CMD) & IO_FLAG_OBF)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	};
+
+	return -EBUSY;
+}
+
+int ec_inb_after_obf1(u8 *data)
+{
+	int ret = ec_wait_obf1();
+	if (ret)
+		return ret;
+	*data = inb(EC_IO_PORT_DATA);
+	return 0;
+}
+EXPORT_SYMBOL(ec_inb_after_obf1);
+
+static int ec_wait_ibc0(void)
+{
+	int i = EC_MAX_TIMEOUT_COUNT;
+	while (i--) {
+		if (!(inb(EC_IO_PORT_CMD) & IO_FLAG_IBF))
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	};
+
+	return -EBUSY;
+}
+
+int ec_outb_after_ibc0(u16 port, u8 data)
+{
+	int ret = ec_wait_ibc0();
+	if (ret)
+		return ret;
+	outb(data, port);
+	return 0;
+}
+EXPORT_SYMBOL(ec_outb_after_ibc0);
+
+static int imanager2_read_mailbox(u32 ecflag, u8 offset, u8 *data)
+{
+	if (ecflag & EC_FLAG_IO_MAILBOX) {
+		int ret = ec_wait_ibc0();
+		if (ret)
+			return ret;
+		inb(EC_IO_PORT_DATA);
+		outb(offset + EC_IO_CMD_READ_OFFSET, EC_IO_PORT_CMD);
+
+		return ec_inb_after_obf1(data);
+	} else {
+		outb(offset, EC_ITE_PORT_OFS);
+		*data = inb(EC_ITE_PORT_DATA);
+	}
+
+	return 0;
+}
+
+static int imanager2_write_mailbox(u32 ecflag, u8 offset, u8 data)
+{
+	if (ecflag & EC_FLAG_IO_MAILBOX) {
+		int ret = ec_outb_after_ibc0(EC_IO_PORT_CMD,
+					     offset + EC_IO_CMD_WRITE_OFFSET);
+		if (ret)
+			return ret;
+
+		return ec_outb_after_ibc0(EC_IO_PORT_DATA, data);
+	} else {
+		outb(offset, EC_ITE_PORT_OFS);
+		outb(data, EC_ITE_PORT_DATA);
+	}
+
+	return 0;
+}
+
+static int imanager2_wait_mailbox_command0(u32 ecflag)
+{
+	u8 cmd;
+	int i, ret;
+
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_CMD,
+					     &cmd);
+		if (ret)
+			return ret;
+		if (!cmd)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -EBUSY;
+}
+
+int imanager2_mbox_read_data(u32 ecflag, u8 cmd, u8 para, u8 *data, int len)
+{
+	int ret, i;
+	u8 status;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_PARA, para);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_CMD, cmd);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	for (i = 0; i < len; i++) {
+		ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(i),
+					     &data[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_read_data);
+
+int imanager2_mbox_write_data(u32 ecflag, u8 cmd, u8 para, u8 *data, int len)
+{
+	int ret, i;
+	u8 status;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_PARA, para);
+	for (i = 0; i < len; i++) {
+		ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(i),
+					      data[i]);
+		if (ret)
+			return ret;
+	}
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_CMD, cmd);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_write_data);
+
+int imanager2_mbox_read_ram(u32 ecflag, u8 bank, u8 offset, u8 *buf, u8 len)
+{
+	int i, ret;
+	u8 status;
+
+	if (len && !buf)
+		return -EINVAL;
+
+	if (len > 0x2B)
+		return -EINVAL;	/* range: DATA01~DATA2B */
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_PARA, bank);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(0x00),
+				      offset);
+	if (ret)
+		return ret;
+
+	if (len > 0x2B)
+		len = 0x2B;	/* range: DATA01~DATA2B */
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(0x2C), len);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_CMD,
+				      EC_CMD_MAILBOX_READ_EC_RAM);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	for (i = 0; i < len; i++) {
+		ret = imanager2_read_mailbox(ecflag,
+					     EC_MAILBOX_OFFSET_DAT(1 + i),
+					     &buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_read_ram);
+
+int imanager2_mbox_write_ram(u32 ecflag, u8 bank, u8 offset, u8 *buf, u8 len)
+{
+	int i, ret;
+	u8 status;
+
+	if (len && !buf)
+		return -EINVAL;
+
+	if (len > 0x2B)
+		return -EINVAL;	/* range: DATA01~DATA2B */
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_PARA, bank);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(0x00),
+				      offset);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(0x2C), len);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < len; i++) {
+		ret = imanager2_write_mailbox(ecflag,
+					      EC_MAILBOX_OFFSET_DAT(1 + i),
+					      buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_CMD,
+				      EC_CMD_MAILBOX_WRITE_EC_RAM);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_write_ram);
+
+int imanager2_mbox_get_dynamic_table(u32 ecflag, u8 type, u8 *table)
+{
+	int i, ret;
+	u8 status;
+
+	if (!table)
+		return -EINVAL;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_PARA, type);
+	if (ret)
+		return ret;
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_CMD,
+				      EC_CMD_MAILBOX_READ_DYNAMIC_TABLE);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	/* table size must be EC_MAX_ITEM_NUM (32 bytes) */
+	for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+		ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(i),
+					     &table[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_get_dynamic_table);
+
+int imanager2_mbox_read_thermalzone(u32 ecflag, u8 zone, u8 *smbid, u8 *fanid,
+				    u8 *buf, int *len)
+{
+	int ret, i;
+	u8 status, getlength;
+
+	if (!smbid && !fanid && !len)
+		return -EINVAL;
+
+	if (*len && !buf)
+		return -EINVAL;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_PARA, zone);
+	if (ret)
+		return ret;
+	ret = imanager2_write_mailbox(ecflag, EC_MAILBOX_OFFSET_CMD,
+				      EC_CMD_MAILBOX_READ_THERMAL_SOURCE);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	if (smbid) {
+		ret = imanager2_read_mailbox(ecflag,
+					     EC_MAILBOX_OFFSET_DAT(0x00),
+					     smbid);
+		if (ret)
+			return ret;
+	}
+
+	if (fanid) {
+		ret = imanager2_read_mailbox(ecflag,
+					     EC_MAILBOX_OFFSET_DAT(0x01),
+					     fanid);
+		if (ret)
+			return ret;
+	}
+
+	if (!len)
+		return 0;
+
+	ret = imanager2_read_mailbox(ecflag, EC_MAILBOX_OFFSET_DAT(0x2C),
+				     &getlength);
+	if (ret)
+		return ret;
+
+	if (*len > getlength)
+		*len = getlength;
+
+	for (i = 0; i < *len; i++) {
+		ret = imanager2_read_mailbox(ecflag,
+					     EC_MAILBOX_OFFSET_DAT(0x02 + i),
+					     &buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	if (*len < getlength) {
+		*len = getlength;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_read_thermalzone);
+
+int imanager2_mbox_get_project_information(u32 ecflag, u8 *prj_name,
+					   u16 *kernel_ver, u16 *chip_code,
+					   u16 *prj_id, u16 *prj_ver)
+{
+	int ret, i;
+
+	if (!prj_name && !kernel_ver && !chip_code && !prj_id && !prj_ver)
+		return -EINVAL;
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(
+		ecflag, EC_MAILBOX_OFFSET_CMD,
+		EC_CMD_MAILBOX_GET_FIRMWARE_VERSION_AND_PROJECT_NAME);
+
+	ret = imanager2_wait_mailbox_command0(ecflag);
+	if (ret)
+		return ret;
+
+	if (prj_name) {
+		/* projection name length must be 9 bytes */
+		for (i = 0; i < EC_MAX_LEN_PROJECT_NAME; i++) {
+			ret = imanager2_read_mailbox(ecflag,
+						     EC_MAILBOX_OFFSET_DAT(i),
+						     &prj_name[i]);
+			if (ret)
+				return ret;
+		}
+		prj_name[EC_MAX_LEN_PROJECT_NAME] = '\0';
+	}
+
+	if (kernel_ver)
+		for (i = 0; i < sizeof(*kernel_ver); i++) {
+			ret = imanager2_read_mailbox(
+				ecflag, EC_MAILBOX_OFFSET_DAT(0x09 + i),
+				(u8 *)kernel_ver + i);
+			if (ret)
+				return ret;
+		}
+
+	if (chip_code)
+		for (i = 0; i < sizeof(*chip_code); i++) {
+			ret = imanager2_read_mailbox(
+				ecflag, EC_MAILBOX_OFFSET_DAT(0x0B + i),
+				(u8 *)chip_code + i);
+			if (ret)
+				return ret;
+		}
+
+	if (prj_id)
+		for (i = 0; i < sizeof(*prj_id); i++) {
+			ret = imanager2_read_mailbox(
+				ecflag, EC_MAILBOX_OFFSET_DAT(0x0D + i),
+				(u8 *)prj_id + i);
+			if (ret)
+				return ret;
+		}
+
+	if (prj_ver)
+		for (i = 0; i < sizeof(*prj_ver); i++) {
+			ret = imanager2_read_mailbox(
+				ecflag, EC_MAILBOX_OFFSET_DAT(0x0F + i),
+				(u8 *)prj_ver + i);
+			if (ret)
+				return ret;
+		}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_get_project_information);
+
+/* IO chennel access */
+int imanager2_mbox_io_read(u8 command, u8 offset, u8 *buf, u8 len)
+{
+	int ret, i;
+
+	if (!len)
+		return 0;
+
+	if (!buf)
+		return -EINVAL;
+
+	for (i = 0; i < len; i++) {
+		ret = ec_outb_after_ibc0(EC_IO_PORT_CMD, command);
+		if (ret)
+			return ret;
+
+		ret = ec_outb_after_ibc0(EC_IO_PORT_DATA, offset + i);
+		if (ret)
+			return ret;
+
+		ret = ec_inb_after_obf1(&buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_io_read);
+
+int imanager2_mbox_io_write(u8 command, u8 offset, u8 *buf, u8 len)
+{
+	int ret, i;
+
+	if (!buf && len)
+		return -EINVAL;
+
+	for (i = 0; i < len; i++) {
+		ret = ec_outb_after_ibc0(EC_IO_PORT_CMD, command);
+		if (ret)
+			return ret;
+
+		ret = ec_outb_after_ibc0(EC_IO_PORT_DATA, offset + i);
+		if (ret)
+			return ret;
+
+		ret = ec_outb_after_ibc0(EC_IO_PORT_DATA, buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_mbox_io_write);
+
+int imanager2_mbox_io_simple_read(u8 command, u8 *value)
+{
+	int ret;
+
+	if (!value)
+		return -EINVAL;
+
+	ret = ec_outb_after_ibc0(EC_IO_PORT_CMD, command);
+	if (ret)
+		return ret;
+
+	return ec_inb_after_obf1(value);
+}
+EXPORT_SYMBOL(imanager2_mbox_io_simple_read);
+
+/* ITE Mailbox & IO chennel access*/
+int imanager2_mbox_read_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
+				       u8 len)
+{
+	if (ecflag & EC_FLAG_MAILBOX) {
+		return imanager2_mbox_read_ram(ecflag, bank, addr, buf, len);
+	} else {
+		u8 iocmd;
+
+		if (bank == EC_RAM_BANK_ACPI)
+			iocmd = EC_CMD_ACPIRAM_READ;
+		else if (bank == EC_RAM_BANK_HW)
+			iocmd = EC_CMD_HWRAM_READ;
+		else if (bank == EC_RAM_BANK_EXT)
+			iocmd = EC_CMD_EXTRAM_READ;
+		else
+			return -EINVAL;
+
+		return imanager2_mbox_io_read(iocmd, addr, buf, len);
+	}
+}
+EXPORT_SYMBOL(imanager2_mbox_read_ram_support_io);
+
+int imanager2_mbox_write_ram_support_io(u32 ecflag, u8 bank, u8 addr, u8 *buf,
+					u8 len)
+{
+	u8 iocmd;
+
+	if (ecflag & EC_FLAG_MAILBOX)
+		return imanager2_mbox_write_ram(ecflag, bank, addr, buf, len);
+
+	if (bank == EC_RAM_BANK_ACPI)
+		iocmd = EC_CMD_ACPIRAM_WRITE;
+	else if (bank == EC_RAM_BANK_HW)
+		iocmd = EC_CMD_HWRAM_WRITE;
+	else if (bank == EC_RAM_BANK_EXT)
+		iocmd = EC_CMD_EXTRAM_WRITE;
+	else
+		return -EINVAL;
+
+	return imanager2_mbox_io_write(iocmd, addr, buf, len);
+}
+EXPORT_SYMBOL(imanager2_mbox_write_ram_support_io);
-- 
1.9.1

