Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaFWJNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:13:19 -0400
Received: from acledge1.advantech.com.tw ([61.58.41.197]:54578 "EHLO
	acledge1.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaFWJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:13:16 -0400
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2014 05:13:16 EDT
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 2/5] mfd: imanager2: Add Advantech EC APIs support for IT8516/18/28
Date: Mon, 23 Jun 2014 01:39:49 -0700
Message-ID: <1403512792-19100-2-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403512792-19100-1-git-send-email-weichun.pan@advantech.com.tw>
References: <1403512792-19100-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wei-Chun Pan <weichun.pan@advantech.com.tw>
---
 drivers/mfd/imanager2_ec.c | 1219 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 1219 insertions(+)
 create mode 100644 drivers/mfd/imanager2_ec.c

diff --git a/drivers/mfd/imanager2_ec.c b/drivers/mfd/imanager2_ec.c
new file mode 100644
index 0000000..ec0bcbf
--- /dev/null
+++ b/drivers/mfd/imanager2_ec.c
@@ -0,0 +1,1219 @@
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
+#include <linux/mfd/advantech/imanager2.h>
+
+#define EC_UDELAY_TIME		50
+#define EC_MAX_TIMEOUT_COUNT	1000
+
+static int wait_obf(void)
+{
+	int i;
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		/* wait output buffer full flag set */
+		if (inb(EC_IO_PORT_CMD) & OBF_MASK)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -EBUSY;
+}
+
+int inb_after_obf(u8 *data)
+{
+	int ret = wait_obf();
+	if (ret)
+		return ret;
+	*data = inb(EC_IO_PORT_DATA);
+	return 0;
+}
+EXPORT_SYMBOL(inb_after_obf);
+
+static int wait_ibc(void)
+{
+	int i;
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		/* wait input buffer full flag clear */
+		if (!(inb(EC_IO_PORT_CMD) & IBF_MASK))
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -EBUSY;
+}
+
+int outb_after_ibc(u16 port, u8 data)
+{
+	int ret = wait_ibc();
+	if (ret)
+		return ret;
+	outb(data, port);
+	return 0;
+}
+EXPORT_SYMBOL(outb_after_ibc);
+
+static int imanager2_read_mailbox(struct imanager2 *ec, u8 offset, u8 *data)
+{
+	if (ec->flag & EC_FLAG_IO_MAILBOX) {
+		int ret = wait_ibc();
+		if (ret)
+			return ret;
+		inb(EC_IO_PORT_DATA);
+		outb(offset + EC_IO_CMD_READ_OFFSET, EC_IO_PORT_CMD);
+
+		return inb_after_obf(data);
+	} else {
+		outb(offset, EC_ITE_PORT_OFS);
+		*data = inb(EC_ITE_PORT_DATA);
+	}
+
+	return 0;
+}
+
+static int imanager2_write_mailbox(struct imanager2 *ec, u8 offset, u8 data)
+{
+	if (ec->flag & EC_FLAG_IO_MAILBOX) {
+		int ret = outb_after_ibc(EC_IO_PORT_CMD,
+					 offset + EC_IO_CMD_WRITE_OFFSET);
+		if (ret)
+			return ret;
+
+		return outb_after_ibc(EC_IO_PORT_DATA, data);
+	} else {
+		outb(offset, EC_ITE_PORT_OFS);
+		outb(data, EC_ITE_PORT_DATA);
+	}
+
+	return 0;
+}
+
+static int imanager2_wait_cmd_clear(struct imanager2 *ec)
+{
+	u8 cmd;
+	int i, ret;
+
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_CMD, &cmd);
+		if (ret)
+			return ret;
+		if (cmd == 0x00)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -EBUSY;
+}
+
+int imanager2_clear_mailbox(struct imanager2 *ec)
+{
+	int ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	return imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				       EC_CMD_MAILBOX_CLEAR_ALL);
+}
+EXPORT_SYMBOL(imanager2_clear_mailbox);
+
+int imanager2_read_mailbox_buffer(struct imanager2 *ec, u8 cmd, u8 para,
+				  u8 *data, int len)
+{
+	int ret, i;
+	u8 status;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, para);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, cmd);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	for (i = 0; i < len; i++) {
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i),
+					     &data[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_read_mailbox_buffer);
+
+int imanager2_write_mailbox_buffer(struct imanager2 *ec, u8 cmd, u8 para,
+				   u8 *data, int len)
+{
+	int ret, i;
+	u8 status;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, para);
+	for (i = 0; i < len; i++) {
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(i),
+					      data[i]);
+		if (ret)
+			return ret;
+	}
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, cmd);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_write_mailbox_buffer);
+
+/**
+ * imanager2_clear_buffer_ram() - clear buffer ram
+ * @ec:		EC device sturcture
+ *
+ * The bank size is 256 bytes EC memory. This function can clear 256 bytes
+ * buffer ram to 0xFF.
+ *
+ * Advantech EC command is 0xC0.
+ */
+int imanager2_clear_buffer_ram(struct imanager2 *ec)
+{
+	int ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	return imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				       EC_CMD_MALLBOX_CLEAR_256_BYTES_BUFFER);
+}
+EXPORT_SYMBOL(imanager2_clear_buffer_ram);
+
+/**
+ * imanager2_read_ram() - read ec ram
+ * @ec:		EC device sturcture
+ * @bank:	memory bank
+ * @offset:	memory offset
+ * @buf:	data buffer pointer
+ * @len:	data length
+ *
+ * System can read EC memory to control EC function or get information data.
+ * There are 4 banks are always public to system access. These four banks are
+ * ACPI ram, HW ram, EXT ram, and buffer ram. Besides these four banks, other
+ * memory access is designed for OEM project*
+ *
+ * Advantech EC command is 0x1E.
+ */
+int imanager2_read_ram(struct imanager2 *ec, u8 bank, u8 offset, u8 *buf,
+		       u8 len)
+{
+	int i, ret;
+	u8 status;
+
+	if (len && !buf)
+		return -EINVAL;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, bank);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x00), offset);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x2C), len);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				      EC_CMD_MAILBOX_READ_EC_RAM);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	for (i = 0; i < len; i++) {
+		/* range: DATA01~DATA2B */
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(1 + i),
+					     &buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_read_ram);
+
+/**
+ * imanager2_write_ram() - write ec ram
+ * @ec:		EC device sturcture
+ * @bank:	memory bank
+ * @offset:	memory offset
+ * @buf:	data buffer pointer
+ * @len:	data length
+ *
+ * System can write EC memory to control EC function or get information data.
+ * There are 4 banks are always public to system access. These four banks are
+ * ACPI ram, HW ram, EXT ram, and buffer ram. Besides these four banks, other
+ * memory access is designed for OEM project*
+ *
+ * Advantech EC command is 0x1F.
+ */
+int imanager2_write_ram(struct imanager2 *ec, u8 bank, u8 offset, u8 *buf,
+			u8 len)
+{
+	int i, ret;
+	u8 status;
+
+	if (len && !buf)
+		return -EINVAL;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, bank);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x00), offset);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x2C), len);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < len; i++) {
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_DAT(1 + i),
+					      buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				      EC_CMD_MAILBOX_WRITE_EC_RAM);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_write_ram);
+
+/**
+ * imanager2_read_buffer_ram() - read data from buffer ram
+ * @ec:		EC device sturcture
+ *
+ * The bank size is 256 bytes EC memory. This function can read buffer ram and
+ * cross banks.
+ *
+ * Advantech EC command is 0xC1.
+ */
+int imanager2_read_buffer_ram(struct imanager2 *ec, u8 *data, int len)
+{
+	int i, j, ret;
+	int banknum, addition;
+	u8 status;
+
+	if (len > EC_RAM_BUFFER_SIZE)
+		len = EC_RAM_BUFFER_SIZE;
+	else if (!len)
+		return -EINVAL;
+
+	banknum = len / EC_RAM_BANK_SIZE;
+	addition = len % EC_RAM_BANK_SIZE;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < banknum || (i == banknum && addition > 0); i++) {
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, i);
+		if (ret)
+			return ret;
+
+		ret = imanager2_write_mailbox(
+					ec, EC_MAILBOX_OFFSET_CMD,
+					EC_CMD_MALLBOX_READ_256_BYTES_BUFFER);
+		if (ret)
+			return ret;
+
+		ret = imanager2_wait_cmd_clear(ec);
+		if (ret)
+			return ret;
+
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS,
+					     &status);
+		if (ret)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -ENXIO;
+
+		for (j = 0; j < addition; j++) {
+			ret = imanager2_read_mailbox(
+					ec, EC_MAILBOX_OFFSET_DAT(j),
+					&data[i * EC_RAM_BANK_SIZE + j]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_read_buffer_ram);
+
+static int imanager2_smbus_i2c_set(struct imanager2 *ec, u8 protocol, u8 addr,
+				   u8 cmd, u8 *wdata, u8 wlen, u8 *rdata,
+				   u8 *rlen)
+{
+	u32 i, ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_ADDR, addr);
+	if (ret)
+		return ret;
+
+	switch (protocol & 0x7F) {
+	/* I2C */
+	case EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER:
+		if (!rlen)
+			return -EINVAL;
+
+		ret = imanager2_clear_buffer_ram(ec);
+		if (ret)
+			return ret;
+
+		if (wlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			return -EINVAL;
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_WLEN,
+					      wlen);
+		if (ret)
+			return ret;
+
+		/* (u8) *rlen is always less than EC_RAM_BUFFER_SIZE */
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+					      *rlen);
+		if (ret)
+			return ret;
+		break;
+	case EC_CMD_MALLBOX_I2C_READ_WRITE:
+	case EC_CMD_MALLBOX_I2C_WRITE_READ:
+		if (!rlen)
+			return -EINVAL;
+
+		if (wlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			return -EINVAL;
+
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_WLEN,
+					      wlen);
+		if (ret)
+			return ret;
+
+		if (*rlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			ret = imanager2_write_mailbox(
+				ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+				EC_MAILBOX_SMBI2C_DATA_LENGTH);
+		else
+			ret = imanager2_write_mailbox(
+				ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN, *rlen);
+		if (ret)
+			return ret;
+		break;
+	/* SMBus Write */
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK:
+		if (wlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			return -EINVAL;
+
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_WLEN,
+					      wlen);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_WORD:
+		ret =
+		    imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_CMD,
+					    cmd);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_SEND_BYTE:
+		break;
+	/* SMBus Read */
+	case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+		if (!rlen)
+			return -EINVAL;
+
+		if (*rlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			ret = imanager2_write_mailbox(
+				ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+				EC_MAILBOX_SMBI2C_DATA_LENGTH);
+		else
+			ret = imanager2_write_mailbox(
+				ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN, *rlen);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_CMD,
+					      cmd);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+	default:
+		return 0;
+	}
+
+	if (wlen && !wdata)
+		return -EINVAL;
+
+	for (i = 0; i < wlen; i++) {
+		ret = imanager2_write_mailbox(ec,
+					      EC_MAILBOX_OFFSET_SMBI2C_DAT(i),
+					      wdata[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int imanager2_smbus_i2c_get(struct imanager2 *ec, u8 cmd, u8 *rdata,
+				   u8 *rlen)
+{
+	int tmp_rlen = 0, ret = 0, ret2, i;
+
+	switch (cmd & 0x7F) {
+	case EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER:
+		if (!rlen)
+			return -EINVAL;
+
+		return imanager2_read_buffer_ram(ec, rdata, (int)((u32)*rlen));
+	case EC_CMD_MALLBOX_I2C_READ_WRITE:
+	case EC_CMD_MALLBOX_I2C_WRITE_READ:
+		if (!rlen)
+			return -EINVAL;
+
+		if (*rlen > EC_MAILBOX_SMBI2C_DATA_LENGTH)
+			*rlen = EC_MAILBOX_SMBI2C_DATA_LENGTH;
+		break;
+	/* SMBus Read */
+	case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+		if (!rlen)
+			return -EINVAL;
+
+		tmp_rlen = *rlen;
+		ret =
+		    imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_SMBI2C_RLEN,
+					   rlen);
+		if (ret)
+			return ret;
+
+		if (tmp_rlen > *rlen)
+			ret = -EINVAL;
+		break;
+	case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+	case EC_CMD_MALLBOX_SMBUS_SEND_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+		break;
+	default:
+		return 0;
+	}
+
+	if (*rlen && !rdata)
+		return -EINVAL;
+
+	for (i = 0; i < *rlen; i++) {
+		ret2 = imanager2_read_mailbox(ec,
+					      EC_MAILBOX_OFFSET_SMBI2C_DAT(i),
+					      &rdata[i]);
+		if (ret2)
+			return ret2;
+	}
+
+	return ret;
+}
+
+static int imanager2_i2c_smbus(struct imanager2 *ec, u8 did, u8 protocol,
+			       u8 addr, u8 cmd, u8 *wdata, u8 wlen, u8 *rdata,
+			       u8 *rlen)
+{
+	int ret = 0;
+	u8 status;
+
+	if (cmd == 0xFF)
+		return -EINVAL;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, did);
+	if (ret)
+		return ret;
+
+	ret = imanager2_smbus_i2c_set(ec, protocol, addr, cmd, wdata, wlen,
+				      rdata, rlen);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD, protocol);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != 0x80)
+		return -ENXIO;
+
+	return imanager2_smbus_i2c_get(ec, protocol, rdata, rlen);
+}
+
+/**
+ * imanager2_get_dynamic_table() - get dynamic table
+ * @ec:		EC device sturcture
+ * @did:	32 bytes array pointer, device id
+ * @hwpin:	32 bytes array pointer, HW pin
+ * @pol:	32 bytes array pointer, polarity
+ *
+ * In different project, EC has different hardware pin routing and control
+ * devices. To unite the control method in different project, we need a
+ * handshake method to translate mailbox command to hardware control. This
+ * handshake method is Dynamic Table method.
+ *
+ * Dynamic table is ec function list table in the project. This table can tell
+ * user how many functions on this EC and how to control. EC also uses this
+ * table to recognize the control function exists or not. Dynamic table contains
+ * 32 items. Each item has 3 byte data, device id, HW pin code, and polarity.
+ *
+ * Advantech EC command is 0x20.
+ */
+int imanager2_get_dynamic_table(struct imanager2 *ec, u8 *did, u8 *hwpin,
+				u8 *pol)
+{
+	int i, ret;
+	u8 status;
+
+	if (!did && !hwpin && !pol)
+		return -EINVAL;
+
+	if (did) {
+		ret = imanager2_wait_cmd_clear(ec);
+		if (ret)
+			return ret;
+
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA,
+					      EC_DYNAMIC_DEVICE_ID);
+		if (ret)
+			return ret;
+		ret =
+		    imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+					    EC_CMD_MAILBOX_READ_NYNAMIC_TABLE);
+		if (ret)
+			return ret;
+
+		ret = imanager2_wait_cmd_clear(ec);
+		if (ret)
+			return ret;
+
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS,
+					     &status);
+		if (ret)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -ENXIO;
+
+		for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+			ret = imanager2_read_mailbox(ec,
+						     EC_MAILBOX_OFFSET_DAT(i),
+						     &did[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (hwpin) {
+		ret = imanager2_wait_cmd_clear(ec);
+		if (ret != 0)
+			return ret;
+
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA,
+					      EC_DYNAMIC_HW_PIN);
+		if (ret)
+			return ret;
+
+		ret =
+		    imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+					    EC_CMD_MAILBOX_READ_NYNAMIC_TABLE);
+		if (ret)
+			return ret;
+
+		ret = imanager2_wait_cmd_clear(ec);
+		if (ret)
+			return ret;
+
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS,
+					     &status);
+		if (ret)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -ENXIO;
+
+		for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+			ret = imanager2_read_mailbox(ec,
+						     EC_MAILBOX_OFFSET_DAT(i),
+						     &hwpin[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (pol) {
+		ret = imanager2_wait_cmd_clear(ec);
+		if (ret)
+			return ret;
+
+		ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA,
+					      EC_DYNAMIC_POLARITY);
+		if (ret)
+			return ret;
+
+		ret = imanager2_write_mailbox(
+					ec, EC_MAILBOX_OFFSET_CMD,
+					EC_CMD_MAILBOX_READ_NYNAMIC_TABLE);
+		if (ret)
+			return ret;
+
+		ret = imanager2_wait_cmd_clear(ec);
+		if (ret)
+			return ret;
+
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS,
+					     &status);
+		if (ret)
+			return ret;
+		if (status != EC_MAILBOX_STATUS_SUCCESS)
+			return -ENXIO;
+
+		for (i = 0; i < EC_MAX_ITEM_NUM; i++) {
+			ret = imanager2_read_mailbox(ec,
+						     EC_MAILBOX_OFFSET_DAT(i),
+						     &pol[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_get_dynamic_table);
+
+/**
+ * imanager2_read_thermalzone() - read thermal zone data
+ * @ec:		EC device sturcture
+ * @zone:	zone number
+ * @smbid:	smbus device id
+ * @fanid:	related fan device id
+ * @buf:	thermal zone structure,
+ *		must bigger than structure length (more than 6 bytes).
+ * @len:	structure length
+ *
+ * EC has 4 thermal zones. User can define protocol, zone type, and related fan
+ * in each zone. There are 3 types protocols supported, I2C/SMBUS, SMLINK, and
+ * PECI 3.0. User can search dynamic table to get smbus device id to setup oem
+ * thermal zone protocol channel.
+ *
+ * User also can setup thermal zone related fan. The related fan will get the
+ * temperature from the zone to control speed. The thermal zone can be setup its
+ * zone type, like CPU temperature, system temperature, etc... This can help
+ * system to identify the temperature source and put the temperature into
+ * corresponding ACPI ram.
+ *
+ * Advantech EC command is 0x42.
+ */
+int imanager2_read_thermalzone(struct imanager2 *ec, u8 zone, u8 *smbid,
+			       u8 *fanid, u8 *buf, int *len)
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
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_PARA, zone);
+	if (ret)
+		return ret;
+	ret = imanager2_write_mailbox(ec, EC_MAILBOX_OFFSET_CMD,
+				      EC_CMD_MAILBOX_READ_THERMAL_SOURCE);
+	if (ret)
+		return ret;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_STATUS, &status);
+	if (ret)
+		return ret;
+	if (status != EC_MAILBOX_STATUS_SUCCESS)
+		return -ENXIO;
+
+	if (smbid) {
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x00),
+					     smbid);
+		if (ret)
+			return ret;
+	}
+
+	if (fanid) {
+		ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x01),
+					     fanid);
+		if (ret)
+			return ret;
+	}
+
+	if (!len)
+		return 0;
+
+	ret = imanager2_read_mailbox(ec, EC_MAILBOX_OFFSET_DAT(0x2C),
+				     &getlength);
+	if (ret)
+		return ret;
+
+	if (*len > getlength)
+		*len = getlength;
+
+	for (i = 0; i < *len; i++) {
+		ret = imanager2_read_mailbox(ec,
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
+EXPORT_SYMBOL(imanager2_read_thermalzone);
+
+/**
+ * imanager2_get_firmware_version_and_project_name() - get project name
+ * @ec:		EC device sturcture
+ * @prj_name:	EC project name array, size is 9 bytes (8 string length)
+ * @kernel_ver:	EC kernel version
+ * @chip_code:	EC chip Vendor code and chip code
+ * @proj_id:	EC project ID and type
+ * @proj_ver:	EC project version
+ *
+ * Get all EC firmware version and project name.
+ *
+ * Advantech EC command is 0xF0.
+ */
+int imanager2_get_firmware_version_and_project_name(struct imanager2 *ec,
+						    u8 *prj_name,
+						    u16 *kernel_ver,
+						    u16 *chip_code,
+						    u16 *proj_id,
+						    u16 *proj_ver)
+{
+	int ret, i;
+
+	if (!prj_name && !kernel_ver && !chip_code && !proj_id && !proj_ver)
+		return -EINVAL;
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	ret = imanager2_write_mailbox(
+			ec, EC_MAILBOX_OFFSET_CMD,
+			EC_CMD_MAILBOX_GET_FIRMWARE_VERSION_AND_PROJECT_NAME);
+
+	ret = imanager2_wait_cmd_clear(ec);
+	if (ret)
+		return ret;
+
+	if (prj_name) {
+		for (i = 0; i < EC_MAX_LEN_PROJECT_NAME; i++) {
+			ret = imanager2_read_mailbox(ec,
+						     EC_MAILBOX_OFFSET_DAT(i),
+						     &prj_name[i]);
+			if (ret)
+				return ret;
+		}
+		prj_name[EC_MAX_LEN_PROJECT_NAME] = '\0';
+	}
+
+	if (kernel_ver) {
+		u8 *tmp = (u8 *)kernel_ver;
+		for (i = 0; i < 2; i++) {
+			ret = imanager2_read_mailbox(
+				ec,
+				EC_MAILBOX_OFFSET_DAT(0x09 + i),
+				&tmp[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (chip_code) {
+		u8 *tmp = (u8 *)chip_code;
+		for (i = 0; i < 2; i++) {
+			ret = imanager2_read_mailbox(
+				ec,
+				EC_MAILBOX_OFFSET_DAT(0x0B + i),
+				&tmp[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (proj_id) {
+		u8 *tmp = (u8 *)proj_id;
+		for (i = 0; i < 2; i++) {
+			ret = imanager2_read_mailbox(
+				ec,
+				EC_MAILBOX_OFFSET_DAT(0x0D + i),
+				&tmp[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	if (proj_ver) {
+		u8 *tmp = (u8 *)proj_ver;
+		for (i = 0; i < 2; i++) {
+			ret = imanager2_read_mailbox(
+				ec,
+				EC_MAILBOX_OFFSET_DAT(0x0F + i),
+				&tmp[i]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_get_firmware_version_and_project_name);
+
+/* IO chennel access */
+int imanager2_io_read(u8 command, u8 offset, u8 *buf, u8 len)
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
+		ret = outb_after_ibc(EC_IO_PORT_CMD, command);
+		if (ret)
+			return ret;
+
+		ret = outb_after_ibc(EC_IO_PORT_DATA, offset + i);
+		if (ret)
+			return ret;
+
+		ret = inb_after_obf(&buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_io_read);
+
+int imanager2_io_write(u8 command, u8 offset, u8 *buf, u8 len)
+{
+	int ret, i;
+
+	if (!buf && len)
+		return -EINVAL;
+
+	for (i = 0; i < len; i++) {
+		ret = outb_after_ibc(EC_IO_PORT_CMD, command);
+		if (ret)
+			return ret;
+
+		ret = outb_after_ibc(EC_IO_PORT_DATA, offset + i);
+		if (ret)
+			return ret;
+
+		ret = outb_after_ibc(EC_IO_PORT_DATA, buf[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(imanager2_io_write);
+
+int imanager2_io_read_byte_without_offset(u8 command, u8 *value)
+{
+	int ret;
+
+	if (!value)
+		return -EINVAL;
+
+	ret = outb_after_ibc(EC_IO_PORT_CMD, command);
+	if (ret)
+		return ret;
+
+	return inb_after_obf(value);
+}
+EXPORT_SYMBOL(imanager2_io_read_byte_without_offset);
+
+static int imanager2_io_i2c_wait_protocol_clear(void)
+{
+	int i, ret;
+	u8 tmp;
+
+	for (i = 0; i < EC_MAX_TIMEOUT_COUNT; i++) {
+		ret =
+		    imanager2_io_read(EC_CMD_HWRAM_READ,
+				      EC_HWRAM_ADDR_SMB_PROTOCOL, &tmp, 1);
+		if (ret)
+			return ret;
+		if (tmp == 0x00)
+			return 0;
+
+		udelay(EC_UDELAY_TIME);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int imanager2_io_i2c_smbus(u8 pin, u8 protocol, u8 addr, u8 cmd,
+				  u8 *wdata, u8 wlen, u8 *rdata, u8 *rlen)
+{
+	int ret;
+	u8 tmp;
+
+	if (wlen && !wdata)
+		return -EINVAL;
+
+	switch (protocol) {
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BLOCK:
+		ret = imanager2_io_write(EC_CMD_HWRAM_WRITE,
+					 EC_HWRAM_ADDR_SMB_BLOCKCNT,
+					 (u8 *)&wlen, 1);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_WRITE_WORD:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_BYTE:
+		ret =
+		    imanager2_io_write(EC_CMD_HWRAM_WRITE,
+				       EC_HWRAM_ADDR_SMB_CMD, &cmd, 1);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_SEND_BYTE:
+		ret = imanager2_io_write(EC_CMD_HWRAM_WRITE,
+					 EC_HWRAM_ADDR_SMB_DATA(0), &wdata[0],
+					 wlen);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+	case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+	case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+		ret =
+		    imanager2_io_write(EC_CMD_HWRAM_WRITE,
+				       EC_HWRAM_ADDR_SMB_CMD, &cmd, 1);
+		if (ret)
+			return ret;
+	case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+	case EC_CMD_MALLBOX_SMBUS_READ_QUICK:
+	case EC_CMD_MALLBOX_SMBUS_WRITE_QUICK:
+		break;
+	case EC_CMD_MALLBOX_I2C_WRITEREAD_WITH_READ_BUFFER:
+	case EC_CMD_MALLBOX_I2C_READ_WRITE:
+	case EC_CMD_MALLBOX_I2C_WRITE_READ:
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	ret = imanager2_io_read(EC_CMD_SMB_INDEX, pin, &tmp, 1);
+	if (ret)
+		return ret;
+	if (tmp != pin)
+		return -ENXIO;
+
+	ret = imanager2_io_write(EC_CMD_HWRAM_WRITE, EC_HWRAM_ADDR_SMB_ADDRESS,
+				 &addr, 1);
+	if (ret)
+		return ret;
+
+	ret = imanager2_io_write(EC_CMD_HWRAM_WRITE, EC_HWRAM_ADDR_SMB_PROTOCOL,
+				 &protocol, 1);
+	if (ret)
+		return ret;
+
+	ret = imanager2_io_i2c_wait_protocol_clear();
+	if (ret)
+		return ret;
+
+	ret = imanager2_io_read(EC_CMD_HWRAM_READ, EC_HWRAM_ADDR_SMB_STATUS,
+				&tmp, 1);
+	if (ret)
+		return ret;
+	if (tmp != 0x80)
+		return -ENXIO;
+
+	if (rlen && *rlen) {
+		if (!rdata)
+			return -EINVAL;
+
+		switch (protocol) {
+		case EC_CMD_MALLBOX_SMBUS_READ_BLOCK:
+			ret = imanager2_io_read(EC_CMD_HWRAM_READ,
+						EC_HWRAM_ADDR_SMB_BLOCKCNT,
+						rlen, 1);
+			if (ret)
+				return ret;
+		case EC_CMD_MALLBOX_SMBUS_RECEIVE_BYTE:
+		case EC_CMD_MALLBOX_SMBUS_READ_BYTE:
+		case EC_CMD_MALLBOX_SMBUS_READ_WORD:
+			ret = imanager2_io_read(EC_CMD_HWRAM_READ,
+						EC_HWRAM_ADDR_SMB_DATA(0),
+						&rdata[0], *rlen);
+			if (ret)
+				return ret;
+		case EC_CMD_MALLBOX_SMBUS_READ_QUICK:
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/* ITE Mailbox & IO chennel access*/
+int imanager2_acpiram_read_byte(struct imanager2 *ec, u8 addr, u8 *value)
+{
+	if (ec->flag & EC_FLAG_MAILBOX)
+		return imanager2_read_ram(ec, EC_RAM_BANK_ACPI, addr, value, 1);
+	else
+		return imanager2_io_read(EC_CMD_ACPIRAM_READ, addr, value, 1);
+}
+EXPORT_SYMBOL(imanager2_acpiram_read_byte);
+
+int imanager2_acpiram_write_byte(struct imanager2 *ec, u8 addr, u8 value)
+{
+	if (ec->flag & EC_FLAG_MAILBOX)
+		return imanager2_write_ram(ec, EC_RAM_BANK_ACPI, addr, &value,
+					   1);
+	else
+		return imanager2_io_write(EC_CMD_ACPIRAM_WRITE, addr, &value,
+					  1);
+}
+EXPORT_SYMBOL(imanager2_acpiram_write_byte);
+
+int imanager2_hwram_read_byte(struct imanager2 *ec, u8 addr, u8 *value)
+{
+	if (ec->flag & EC_FLAG_MAILBOX)
+		return imanager2_read_ram(ec, EC_RAM_BANK_HW, addr, value, 1);
+	else
+		return imanager2_io_read(EC_CMD_HWRAM_READ, addr, value, 1);
+}
+EXPORT_SYMBOL(imanager2_hwram_read_byte);
+
+int imanager2_hwram_write_byte(struct imanager2 *ec, u8 addr, u8 value)
+{
+	if (ec->flag & EC_FLAG_MAILBOX)
+		return imanager2_write_ram(ec, EC_RAM_BANK_HW, addr, &value, 1);
+	else
+		return imanager2_io_write(EC_CMD_HWRAM_WRITE, addr, &value, 1);
+}
+EXPORT_SYMBOL(imanager2_hwram_write_byte);
+
+int imanager2_smbus_transmit_routine(struct imanager2 *ec, u8 did, u8 protocol,
+				     u8 addr, u8 cmd, u8 *wdata, u8 wlen,
+				     u8 *rdata, u8 *rlen)
+{
+	if (ec->flag & EC_FLAG_MAILBOX) {
+		return imanager2_i2c_smbus(ec, did, protocol, addr, cmd,
+					   wdata, wlen, rdata, rlen);
+	} else {
+		u8 pin = ec->table.pinnum[ec->table.devid2itemnum[did]];
+		return imanager2_io_i2c_smbus(pin, protocol, addr, cmd, wdata,
+					      wlen, rdata, rlen);
+	}
+}
+EXPORT_SYMBOL(imanager2_smbus_transmit_routine);
-- 
1.9.1

