Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaANHqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:46:40 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:41175 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaANHpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:45:44 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s0E7j04b007522, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
CC: <rogerable@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: [PATCH 1/3] mfd: Add realtek USB card reader driver
Date: Tue, 14 Jan 2014 15:47:34 +0800
Message-ID: <1389685656-880-2-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1389685656-880-1-git-send-email-rogerable@realtek.com>
References: <1389685656-880-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

Realtek USB card reader provides a channel to transfer command or data to flash
memory cards. This driver exports host instances for mmc and memstick subsystems
and handles basic works.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mfd/Kconfig          |  10 +
 drivers/mfd/Makefile         |   1 +
 drivers/mfd/rtsx_usb.c       | 788 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/rtsx_usb.h | 619 +++++++++++++++++++++++++++++++++
 4 files changed, 1418 insertions(+)
 create mode 100644 drivers/mfd/rtsx_usb.c
 create mode 100644 include/linux/mfd/rtsx_usb.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b7c74a7..4c99ebd 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -507,6 +507,16 @@ config MFD_RTSX_PCI
 	  types of memory cards, such as Memory Stick, Memory Stick Pro,
 	  Secure Digital and MultiMediaCard.
 
+config MFD_RTSX_USB
+	tristate "Realtek USB card reader"
+	depends on USB
+	select MFD_CORE
+	help
+	Select this option to get support for Realtek USB 2.0 card readers
+	including RTS5129, RTS5139, RTS5179 and RTS5170.
+	Realtek card reader supports access to many types of memory cards,
+	such as Memory Stick Pro, Secure Digital and MultiMediaCard.
+
 config MFD_RC5T583
 	bool "Ricoh RC5T583 Power Management system device"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8a28dc9..33b8de6 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
 
 rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
+obj-$(CONFIG_MFD_RTSX_USB)	+= rtsx_usb.o
 
 obj-$(CONFIG_HTC_EGPIO)		+= htc-egpio.o
 obj-$(CONFIG_HTC_PASIC3)	+= htc-pasic3.o
diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
new file mode 100644
index 0000000..905ec8d
--- /dev/null
+++ b/drivers/mfd/rtsx_usb.c
@@ -0,0 +1,788 @@
+/* Driver for Realtek USB card reader
+ *
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author:
+ *   Roger Tseng <rogerable@realtek.com>
+ */
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/usb.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <asm/unaligned.h>
+#include <linux/mfd/rtsx_usb.h>
+
+static int polling_pipe = 1;
+module_param(polling_pipe, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(polling_pipe, "polling pipe (0: ctl, 1: bulk)");
+static struct mfd_cell rtsx_usb_cells[] = {
+	[RTSX_USB_SD_CARD] = {
+		.name = DRV_NAME_RTSX_USB_SDMMC,
+	},
+	[RTSX_USB_MS_CARD] = {
+		.name = DRV_NAME_RTSX_USB_MS,
+	},
+};
+
+static void rtsx_usb_sg_timed_out(unsigned long data)
+{
+	struct rtsx_ucr *ucr = (struct rtsx_ucr *)data;
+
+	dev_dbg(&ucr->pusb_intf->dev, "%s: sg transfer timed out", __func__);
+	usb_sg_cancel(&ucr->current_sg);
+
+	/* we know the cancellation is caused by time-out */
+	ucr->current_sg.status = -ETIMEDOUT;
+}
+
+static int rtsx_usb_bulk_transfer_sglist(struct rtsx_ucr *ucr,
+		unsigned int pipe, struct scatterlist *sg, int num_sg,
+		unsigned int length, unsigned int *act_len, int timeout)
+{
+	int ret;
+
+	dev_dbg(&ucr->pusb_intf->dev, "%s: xfer %u bytes, %d entries\n",
+			__func__, length, num_sg);
+	ret = usb_sg_init(&ucr->current_sg, ucr->pusb_dev, pipe, 0,
+			sg, num_sg, length, GFP_NOIO);
+	if (ret)
+		return ret;
+
+	ucr->sg_timer.expires = jiffies + msecs_to_jiffies(timeout);
+	add_timer(&ucr->sg_timer);
+	usb_sg_wait(&ucr->current_sg);
+	del_timer(&ucr->sg_timer);
+
+	if (act_len)
+		*act_len = ucr->current_sg.bytes;
+
+	return ucr->current_sg.status;
+}
+
+int rtsx_usb_transfer_data(struct rtsx_ucr *ucr, unsigned int pipe,
+			      void *buf, unsigned int len, int num_sg,
+			      unsigned int *act_len, int timeout)
+{
+	if (timeout < 600)
+		timeout = 600;
+
+	if (num_sg)
+		return rtsx_usb_bulk_transfer_sglist(ucr, pipe,
+				(struct scatterlist *)buf, num_sg, len, act_len,
+				timeout);
+	else
+		return usb_bulk_msg(ucr->pusb_dev, pipe, buf, len, act_len,
+				timeout);
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_transfer_data);
+
+static int rtsx_usb_seq_write_register(struct rtsx_ucr *ucr,
+		u16 addr, u16 len, u8 *data)
+{
+	u16 cmd_len = len + 12;
+
+	if (data == NULL)
+		return -EINVAL;
+
+	if (cmd_len > IOBUF_SIZE)
+		return -EINVAL;
+
+	if (cmd_len % 4)
+		cmd_len += (4 - cmd_len % 4);
+
+
+	ucr->cmd_buf[0] = 'R';
+	ucr->cmd_buf[1] = 'T';
+	ucr->cmd_buf[2] = 'C';
+	ucr->cmd_buf[3] = 'R';
+	ucr->cmd_buf[PACKET_TYPE] = SEQ_WRITE;
+	ucr->cmd_buf[5] = (u8)(len >> 8);
+	ucr->cmd_buf[6] = (u8)len;
+	ucr->cmd_buf[STAGE_FLAG] = 0;
+	ucr->cmd_buf[8] = (u8)(addr >> 8);
+	ucr->cmd_buf[9] = (u8)addr;
+
+	memcpy(ucr->cmd_buf + 12, data, len);
+
+	return rtsx_usb_transfer_data(ucr,
+			usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT),
+			ucr->cmd_buf, cmd_len, 0, NULL, 100);
+}
+
+static int rtsx_usb_seq_read_register(struct rtsx_ucr *ucr,
+		u16 addr, u16 len, u8 *data)
+{
+	int i, ret;
+	u16 rsp_len, res_len;
+
+	if (data == NULL)
+		return -EINVAL;
+
+	res_len = len % 4;
+	rsp_len = len - res_len;
+
+	/* 4-byte aligned part */
+	if (rsp_len) {
+		ucr->cmd_buf[0] = 'R';
+		ucr->cmd_buf[1] = 'T';
+		ucr->cmd_buf[2] = 'C';
+		ucr->cmd_buf[3] = 'R';
+		ucr->cmd_buf[PACKET_TYPE] = SEQ_READ;
+		ucr->cmd_buf[5] = (u8)(rsp_len >> 8);
+		ucr->cmd_buf[6] = (u8)rsp_len;
+		ucr->cmd_buf[STAGE_FLAG] = STAGE_R;
+		ucr->cmd_buf[8] = (u8)(addr >> 8);
+		ucr->cmd_buf[9] = (u8)addr;
+
+		ret = rtsx_usb_transfer_data(ucr,
+				usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT),
+				ucr->cmd_buf, 12, 0, NULL, 100);
+		if (ret)
+			return ret;
+
+		ret = rtsx_usb_transfer_data(ucr,
+				usb_rcvbulkpipe(ucr->pusb_dev, EP_BULK_IN),
+				data, rsp_len, 0, NULL, 100);
+		if (ret)
+			return ret;
+	}
+
+	/* unaligned part */
+	for (i = 0; i < res_len; i++) {
+		ret = rtsx_usb_read_register(ucr, addr + rsp_len + i,
+				data + rsp_len + i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+int rtsx_usb_read_ppbuf(struct rtsx_ucr *ucr, u8 *buf, int buf_len)
+{
+	return rtsx_usb_seq_read_register(ucr, PPBUF_BASE2, (u16)buf_len, buf);
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_read_ppbuf);
+
+int rtsx_usb_write_ppbuf(struct rtsx_ucr *ucr, u8 *buf, int buf_len)
+{
+	return rtsx_usb_seq_write_register(ucr, PPBUF_BASE2, (u16)buf_len, buf);
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_write_ppbuf);
+
+int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr,
+		u8 mask, u8 data)
+{
+	u16 value = 0, index = 0;
+
+	value |= 0x03 << 14;
+	value |= addr & 0x3FFF;
+	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);
+	index |= (u16)mask;
+	index |= (u16)data << 8;
+
+	return usb_control_msg(ucr->pusb_dev,
+			usb_sndctrlpipe(ucr->pusb_dev, 0), 0, 0x40,
+			value, index, NULL, 0, 100);
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_ep0_write_register);
+
+int rtsx_usb_ep0_read_register(struct rtsx_ucr *ucr, u16 addr, u8 *data)
+{
+	u16 value = 0;
+
+	if (data == NULL)
+		return -EINVAL;
+	*data = 0;
+
+	value |= 0x02 << 14;
+	value |= addr & 0x3FFF;
+	value = ((value << 8) & 0xFF00) | ((value >> 8) & 0x00FF);
+
+	return usb_control_msg(ucr->pusb_dev,
+			usb_rcvctrlpipe(ucr->pusb_dev, 0), 0, 0xC0,
+			value, 0, data, 1, 100);
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_ep0_read_register);
+
+void rtsx_usb_add_cmd(struct rtsx_ucr *ucr,
+		    u8 cmd_type,
+		    u16 reg_addr,
+		    u8 mask,
+		    u8 data)
+{
+	int i;
+
+	if (ucr->cmd_idx < ((IOBUF_SIZE - CMD_OFFSET) / 4)) {
+		i = CMD_OFFSET + ucr->cmd_idx * 4;
+
+		ucr->cmd_buf[i++] = ((cmd_type & 0x03) << 6) |
+			(u8)((reg_addr >> 8) & 0x3F);
+		ucr->cmd_buf[i++] = (u8)reg_addr;
+		ucr->cmd_buf[i++] = mask;
+		ucr->cmd_buf[i++] = data;
+
+		ucr->cmd_idx++;
+	}
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_add_cmd);
+
+int rtsx_usb_send_cmd(struct rtsx_ucr *ucr, u8 flag, int timeout)
+{
+	int ret;
+
+	ucr->cmd_buf[CNT_H] = (u8)(ucr->cmd_idx >> 8);
+	ucr->cmd_buf[CNT_L] = (u8)(ucr->cmd_idx);
+	ucr->cmd_buf[STAGE_FLAG] = flag;
+
+	ret = rtsx_usb_transfer_data(ucr,
+			usb_sndbulkpipe(ucr->pusb_dev, EP_BULK_OUT),
+			ucr->cmd_buf, ucr->cmd_idx * 4 + CMD_OFFSET,
+			0, NULL, timeout);
+	if (ret) {
+		rtsx_usb_clear_fsm_err(ucr);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_send_cmd);
+
+int rtsx_usb_get_rsp(struct rtsx_ucr *ucr, int rsp_len, int timeout)
+{
+	if (rsp_len <= 0)
+		return -EINVAL;
+
+	if (rsp_len % 4)
+		rsp_len += (4 - rsp_len % 4);
+
+	return rtsx_usb_transfer_data(ucr,
+			usb_rcvbulkpipe(ucr->pusb_dev, EP_BULK_IN),
+			ucr->rsp_buf, rsp_len, 0, NULL, timeout);
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_get_rsp);
+
+static int rtsx_usb_get_status_with_bulk(struct rtsx_ucr *ucr, u16 *status)
+{
+	int ret;
+
+	rtsx_usb_init_cmd(ucr);
+	rtsx_usb_add_cmd(ucr, READ_REG_CMD, CARD_EXIST, 0x00, 0x00);
+	rtsx_usb_add_cmd(ucr, READ_REG_CMD, OCPSTAT, 0x00, 0x00);
+	ret = rtsx_usb_send_cmd(ucr, MODE_CR, 100);
+	if (ret)
+		return ret;
+
+	ret = rtsx_usb_get_rsp(ucr, 2, 100);
+	if (ret)
+		return ret;
+
+	*status = ((ucr->rsp_buf[0] >> 2) & 0x0f) |
+		  ((ucr->rsp_buf[1] & 0x03) << 4);
+
+	return 0;
+}
+
+int rtsx_usb_get_card_status(struct rtsx_ucr *ucr, u16 *status)
+{
+	int ret;
+
+	if (status == NULL)
+		return -EINVAL;
+
+	if (polling_pipe == 0)
+		ret = usb_control_msg(ucr->pusb_dev,
+				usb_rcvctrlpipe(ucr->pusb_dev, 0),
+				0x02, 0xC0, 0, 0, status, 2, 100);
+	else
+		ret = rtsx_usb_get_status_with_bulk(ucr, status);
+
+	/* usb_control_msg may return positive when success */
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_get_card_status);
+
+static int rtsx_usb_write_phy_register(struct rtsx_ucr *ucr, u8 addr, u8 val)
+{
+	dev_dbg(&ucr->pusb_intf->dev, "Write 0x%x to phy register 0x%x\n",
+			val, addr);
+
+	rtsx_usb_init_cmd(ucr);
+
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VSTAIN, 0xFF, val);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VCONTROL, 0xFF, addr & 0x0F);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x01);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VCONTROL,
+			0xFF, (addr >> 4) & 0x0F);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x00);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, HS_VLOADM, 0xFF, 0x01);
+
+	return rtsx_usb_send_cmd(ucr, MODE_C, 100);
+}
+
+int rtsx_usb_write_register(struct rtsx_ucr *ucr, u16 addr, u8 mask, u8 data)
+{
+	rtsx_usb_init_cmd(ucr);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, addr, mask, data);
+	return rtsx_usb_send_cmd(ucr, MODE_C, 100);
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_write_register);
+
+int rtsx_usb_read_register(struct rtsx_ucr *ucr, u16 addr, u8 *data)
+{
+	int ret;
+
+	if (data != NULL)
+		*data = 0;
+
+	rtsx_usb_init_cmd(ucr);
+	rtsx_usb_add_cmd(ucr, READ_REG_CMD, addr, 0, 0);
+	ret = rtsx_usb_send_cmd(ucr, MODE_CR, 100);
+	if (ret)
+		return ret;
+
+	ret = rtsx_usb_get_rsp(ucr, 1, 100);
+	if (ret)
+		return ret;
+
+	if (data != NULL)
+		*data = ucr->rsp_buf[0];
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_read_register);
+
+static inline u8 double_ssc_depth(u8 depth)
+{
+	return ((depth > 1) ? (depth - 1) : depth);
+}
+
+static u8 revise_ssc_depth(u8 ssc_depth, u8 div)
+{
+	if (div > CLK_DIV_1) {
+		if (ssc_depth > (div - 1))
+			ssc_depth -= (div - 1);
+		else
+			ssc_depth = SSC_DEPTH_2M;
+	}
+
+	return ssc_depth;
+}
+
+int rtsx_usb_switch_clock(struct rtsx_ucr *ucr, unsigned int card_clock,
+		u8 ssc_depth, bool initial_mode, bool double_clk, bool vpclk)
+{
+	int ret;
+	u8 n, clk_divider, mcu_cnt, div;
+
+	if (!card_clock) {
+		ucr->cur_clk = 0;
+		return 0;
+	}
+
+	if (initial_mode) {
+		/* We use 250k(around) here, in initial stage */
+		clk_divider = SD_CLK_DIVIDE_128;
+		card_clock = 30000000;
+	} else {
+		clk_divider = SD_CLK_DIVIDE_0;
+	}
+
+	ret = rtsx_usb_write_register(ucr, SD_CFG1,
+			SD_CLK_DIVIDE_MASK, clk_divider);
+	if (ret < 0)
+		return ret;
+
+	card_clock /= 1000000;
+	dev_dbg(&ucr->pusb_intf->dev,
+			"Switch card clock to %dMHz\n", card_clock);
+
+	if (!initial_mode && double_clk)
+		card_clock *= 2;
+	dev_dbg(&ucr->pusb_intf->dev,
+			"Internal SSC clock: %dMHz (cur_clk = %d)\n",
+			card_clock, ucr->cur_clk);
+
+	if (card_clock == ucr->cur_clk)
+		return 0;
+
+	/* Converting clock value into internal settings: n and div */
+	n = card_clock - 2;
+	if ((card_clock <= 2) || (n > MAX_DIV_N))
+		return -EINVAL;
+
+	mcu_cnt = 60/card_clock + 3;
+	if (mcu_cnt > 15)
+		mcu_cnt = 15;
+
+	/* Make sure that the SSC clock div_n is not less than MIN_DIV_N */
+
+	div = CLK_DIV_1;
+	while (n < MIN_DIV_N && div < CLK_DIV_4) {
+		n = (n + 2) * 2 - 2;
+		div++;
+	}
+	dev_dbg(&ucr->pusb_intf->dev, "n = %d, div = %d\n", n, div);
+
+	if (double_clk)
+		ssc_depth = double_ssc_depth(ssc_depth);
+
+	ssc_depth = revise_ssc_depth(ssc_depth, div);
+	dev_dbg(&ucr->pusb_intf->dev, "ssc_depth = %d\n", ssc_depth);
+
+	rtsx_usb_init_cmd(ucr);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CLK_DIV, CLK_CHANGE, CLK_CHANGE);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CLK_DIV,
+			0x3F, (div << 4) | mcu_cnt);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_CTL1, SSC_RSTB, 0);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_CTL2,
+			SSC_DEPTH_MASK, ssc_depth);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_DIV_N_0, 0xFF, n);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SSC_CTL1, SSC_RSTB, SSC_RSTB);
+	if (vpclk) {
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SD_VPCLK0_CTL,
+				PHASE_NOT_RESET, 0);
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SD_VPCLK0_CTL,
+				PHASE_NOT_RESET, PHASE_NOT_RESET);
+	}
+
+	ret = rtsx_usb_send_cmd(ucr, MODE_C, 2000);
+	if (ret < 0)
+		return ret;
+
+	ret = rtsx_usb_write_register(ucr, SSC_CTL1, 0xff,
+			SSC_RSTB | SSC_8X_EN | SSC_SEL_4M);
+	if (ret < 0)
+		return ret;
+
+	/* Wait SSC clock stable */
+	usleep_range(100, 1000);
+
+	ret = rtsx_usb_write_register(ucr, CLK_DIV, CLK_CHANGE, 0);
+	if (ret < 0)
+		return ret;
+
+	ucr->cur_clk = card_clock;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_switch_clock);
+
+int rtsx_usb_card_exclusive_check(struct rtsx_ucr *ucr, int card)
+{
+	int ret;
+	u16 val;
+	u16 cd_mask[] = {
+		[RTSX_USB_SD_CARD] = (CD_MASK & ~SD_CD),
+		[RTSX_USB_MS_CARD] = (CD_MASK & ~MS_CD)
+	};
+
+	ret = rtsx_usb_get_card_status(ucr, &val);
+	/*
+	 * If get status fails, return 0 (ok) for the exclusive check
+	 * and let the flow fail at somewhere else.
+	 */
+	if (ret)
+		return 0;
+
+	if (val & cd_mask[card])
+		return -EIO;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rtsx_usb_card_exclusive_check);
+
+static int rtsx_usb_reset_chip(struct rtsx_ucr *ucr)
+{
+	int ret;
+	u8 val;
+
+	rtsx_usb_init_cmd(ucr);
+
+	if (CHECK_PKG(ucr, LQFP48)) {
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PWR_CTL,
+				LDO3318_PWR_MASK, LDO_SUSPEND);
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PWR_CTL,
+				FORCE_LDO_POWERB, FORCE_LDO_POWERB);
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL1,
+				0x30, 0x10);
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL5,
+				0x03, 0x01);
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_PULL_CTL6,
+				0x0C, 0x04);
+	}
+
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SYS_DUMMY0, NYET_MSAK, NYET_EN);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CD_DEGLITCH_WIDTH, 0xFF, 0x08);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
+			CD_DEGLITCH_EN, XD_CD_DEGLITCH_EN, 0x0);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, SD30_DRIVE_SEL,
+			SD30_DRIVE_MASK, DRIVER_TYPE_D);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
+			CARD_DRIVE_SEL, SD20_DRIVE_MASK, 0x0);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, LDO_POWER_CFG, 0xE0, 0x0);
+
+	if (ucr->is_rts5179)
+		rtsx_usb_add_cmd(ucr, WRITE_REG_CMD,
+				CARD_PULL_CTL5, 0x03, 0x01);
+
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_DMA1_CTL,
+		       EXTEND_DMA1_ASYNC_SIGNAL, EXTEND_DMA1_ASYNC_SIGNAL);
+	rtsx_usb_add_cmd(ucr, WRITE_REG_CMD, CARD_INT_PEND,
+			XD_INT | MS_INT | SD_INT,
+			XD_INT | MS_INT | SD_INT);
+
+	ret = rtsx_usb_send_cmd(ucr, MODE_C, 100);
+	if (ret)
+		return ret;
+
+	/* config non-crystal mode */
+	rtsx_usb_read_register(ucr, CFG_MODE, &val);
+	if ((val & XTAL_FREE) || ((val & CLK_MODE_MASK) == CLK_MODE_NON_XTAL)) {
+		ret = rtsx_usb_write_phy_register(ucr, 0xC2, 0x7C);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int rtsx_usb_init_chip(struct rtsx_ucr *ucr)
+{
+	int ret;
+	u8 val;
+
+	rtsx_usb_clear_fsm_err(ucr);
+
+	/* power on SSC*/
+	ret = rtsx_usb_write_register(ucr,
+			FPDCTL, SSC_POWER_MASK, SSC_POWER_ON);
+	if (ret)
+		return ret;
+
+	usleep_range(100, 1000);
+	ret = rtsx_usb_write_register(ucr, CLK_DIV, CLK_CHANGE, 0x00);
+	if (ret)
+		return ret;
+
+	/* determine IC version */
+	ret = rtsx_usb_read_register(ucr, HW_VERSION, &val);
+	if (ret)
+		return ret;
+
+	ucr->ic_version = val & HW_VER_MASK;
+
+	/* determine package */
+	ret = rtsx_usb_read_register(ucr, CARD_SHARE_MODE, &val);
+	if (ret)
+		return ret;
+	if (val & CARD_SHARE_LQFP_SEL) {
+		ucr->package = LQFP48;
+		dev_dbg(&ucr->pusb_intf->dev, "Package: LQFP48\n");
+	} else {
+		ucr->package = QFN24;
+		dev_dbg(&ucr->pusb_intf->dev, "Package: QFN24\n");
+	}
+
+	/* determine IC variations */
+	rtsx_usb_read_register(ucr, CFG_MODE_1, &val);
+	if (val & RTS5179) {
+		ucr->is_rts5179 = 1;
+		dev_dbg(&ucr->pusb_intf->dev, "Device is rts5179\n");
+	} else {
+		ucr->is_rts5179 = 0;
+	}
+
+	ret = rtsx_usb_reset_chip(ucr);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int rtsx_usb_probe(struct usb_interface *intf,
+			 const struct usb_device_id *id)
+{
+	struct usb_device *usb_dev = interface_to_usbdev(intf);
+	struct rtsx_ucr *ucr;
+	int i;
+	int ret;
+
+	dev_dbg(&intf->dev,
+		": Realtek USB Card Reader found at bus %03d address %03d\n",
+		 usb_dev->bus->busnum, usb_dev->devnum);
+
+	ucr = kzalloc(sizeof(struct rtsx_ucr), GFP_KERNEL);
+	if (!ucr)
+		return -ENOMEM;
+
+	ucr->pusb_dev = usb_dev;
+
+	/* alloc coherent buffer */
+	ucr->iobuf = usb_alloc_coherent(ucr->pusb_dev, IOBUF_SIZE,
+			GFP_KERNEL, &ucr->iobuf_dma);
+	if (!ucr->iobuf) {
+		ret = -ENOMEM;
+		goto out_free_chip;
+	}
+
+	/* set USB interface data */
+	usb_set_intfdata(intf, ucr);
+
+	ucr->vendor_id = id->idVendor;
+	ucr->product_id = id->idProduct;
+	ucr->cmd_buf = ucr->rsp_buf = ucr->iobuf;
+
+	mutex_init(&ucr->dev_mutex);
+
+	ucr->pusb_intf = intf;
+
+	/* initialize */
+	ret = rtsx_usb_init_chip(ucr);
+	if (ret)
+		goto out_init_fail;
+
+	for (i = 0; i < ARRAY_SIZE(rtsx_usb_cells); i++) {
+		rtsx_usb_cells[i].platform_data = &ucr;
+		rtsx_usb_cells[i].pdata_size = sizeof(*ucr);
+	}
+	ret = mfd_add_devices(&intf->dev, usb_dev->devnum, rtsx_usb_cells,
+			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);
+	if (ret)
+		goto out_init_fail;
+	/* initialize USB SG transfer timer */
+	init_timer(&ucr->sg_timer);
+	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
+#ifdef CONFIG_PM
+	intf->needs_remote_wakeup = 1;
+	usb_enable_autosuspend(usb_dev);
+#endif
+
+	return 0;
+
+out_init_fail:
+	usb_set_intfdata(ucr->pusb_intf, NULL);
+	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
+			ucr->iobuf_dma);
+
+out_free_chip:
+	kfree(ucr);
+	dev_err(&intf->dev, "%s failed\n", __func__);
+	return ret;
+}
+
+static void rtsx_usb_disconnect(struct usb_interface *intf)
+{
+	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
+
+	dev_dbg(&intf->dev, "%s called\n", __func__);
+
+	mfd_remove_devices(&intf->dev);
+
+	usb_set_intfdata(ucr->pusb_intf, NULL);
+	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
+			ucr->iobuf_dma);
+
+	kfree(ucr);
+}
+
+#ifdef CONFIG_PM
+static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct rtsx_ucr *ucr =
+		(struct rtsx_ucr *)usb_get_intfdata(intf);
+
+	dev_dbg(&intf->dev, "%s called with pm message 0x%04u\n",
+			__func__, message.event);
+
+	mutex_lock(&ucr->dev_mutex);
+	rtsx_usb_turn_off_led(ucr);
+	mutex_unlock(&ucr->dev_mutex);
+	return 0;
+}
+
+static int rtsx_usb_resume(struct usb_interface *intf)
+{
+	return 0;
+}
+
+static int rtsx_usb_reset_resume(struct usb_interface *intf)
+{
+	struct rtsx_ucr *ucr =
+		(struct rtsx_ucr *)usb_get_intfdata(intf);
+
+	rtsx_usb_reset_chip(ucr);
+	return 0;
+}
+
+#else /* CONFIG_PM */
+
+#define rtsx_usb_suspend NULL
+#define rtsx_usb_resume NULL
+#define rtsx_usb_reset_resume NULL
+
+#endif /* CONFIG_PM */
+
+
+static int rtsx_usb_pre_reset(struct usb_interface *intf)
+{
+	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
+
+	mutex_lock(&ucr->dev_mutex);
+	return 0;
+}
+
+static int rtsx_usb_post_reset(struct usb_interface *intf)
+{
+	struct rtsx_ucr *ucr = (struct rtsx_ucr *)usb_get_intfdata(intf);
+
+	mutex_unlock(&ucr->dev_mutex);
+	return 0;
+}
+
+static struct usb_device_id rtsx_usb_usb_ids[] = {
+	{ USB_DEVICE(0x0BDA, 0x0129) },
+	{ USB_DEVICE(0x0BDA, 0x0139) },
+	{ USB_DEVICE(0x0BDA, 0x0140) },
+	{ }
+};
+
+static struct usb_driver rtsx_usb_driver = {
+	.name =		DRV_NAME_RTSX_USB,
+	.probe =	rtsx_usb_probe,
+	.disconnect =	rtsx_usb_disconnect,
+	.suspend =	rtsx_usb_suspend,
+	.resume =	rtsx_usb_resume,
+	.reset_resume =	rtsx_usb_reset_resume,
+	.pre_reset =	rtsx_usb_pre_reset,
+	.post_reset =	rtsx_usb_post_reset,
+	.id_table =	rtsx_usb_usb_ids,
+	.supports_autosuspend = 1,
+	.soft_unbind =	1,
+};
+
+module_usb_driver(rtsx_usb_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Roger Tseng <rogerable@realtek.com>");
+MODULE_DESCRIPTION("Realtek USB Card Reader Driver");
diff --git a/include/linux/mfd/rtsx_usb.h b/include/linux/mfd/rtsx_usb.h
new file mode 100644
index 0000000..7c72cbf
--- /dev/null
+++ b/include/linux/mfd/rtsx_usb.h
@@ -0,0 +1,619 @@
+/* Driver for Realtek RTS5139 USB card reader
+ *
+ * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author:
+ *   Roger Tseng <rogerable@realtek.com>
+ */
+
+#ifndef __RTSX_USB_H
+#define __RTSX_USB_H
+
+#include <linux/usb.h>
+
+/* related module names */
+#define RTSX_USB_SD_CARD		0
+#define RTSX_USB_MS_CARD		1
+
+#define DRV_NAME_RTSX_USB		"rtsx_usb"
+#define DRV_NAME_RTSX_USB_SDMMC		"rtsx_usb_sdmmc"
+#define DRV_NAME_RTSX_USB_MS		"rtsx_usb_ms"
+
+/* endpoint numbers */
+#define EP_BULK_OUT		1
+#define EP_BULK_IN		2
+#define EP_INTR_IN		3
+
+/* miscellaneous parameters */
+#define MIN_DIV_N		60
+#define MAX_DIV_N		120
+
+#define MAX_PHASE		15
+#define RX_TUNING_CNT		3
+
+/* data structures */
+struct rtsx_ucr {
+	u16			vendor_id;
+	u16			product_id;
+
+	int			package;
+#define QFN24			0
+#define LQFP48			1
+#define CHECK_PKG(ucr, pkg)	((ucr)->package == (pkg))
+
+	u8			ic_version;
+	u8			is_rts5179;
+
+	unsigned int		cur_clk;
+
+	u8			*cmd_buf;
+	unsigned int		cmd_idx;
+	u8			*rsp_buf;
+
+	struct usb_device	*pusb_dev;
+	struct usb_interface	*pusb_intf;
+	struct usb_sg_request	current_sg;
+	unsigned char		*iobuf;
+	dma_addr_t		iobuf_dma;
+
+	struct timer_list	sg_timer;
+	struct mutex		dev_mutex;
+};
+
+/* buffer size */
+#define IOBUF_SIZE		1024
+
+/* prototypes of exported functions */
+extern int rtsx_usb_get_card_status(struct rtsx_ucr *ucr, u16 *status);
+
+extern int rtsx_usb_read_register(struct rtsx_ucr *ucr, u16 addr, u8 *data);
+extern int rtsx_usb_write_register(struct rtsx_ucr *ucr, u16 addr, u8 mask,
+		u8 data);
+
+extern int rtsx_usb_ep0_write_register(struct rtsx_ucr *ucr, u16 addr, u8 mask,
+		u8 data);
+extern int rtsx_usb_ep0_read_register(struct rtsx_ucr *ucr, u16 addr,
+		u8 *data);
+
+extern void rtsx_usb_add_cmd(struct rtsx_ucr *ucr, u8 cmd_type,
+		u16 reg_addr, u8 mask, u8 data);
+extern int rtsx_usb_send_cmd(struct rtsx_ucr *ucr, u8 flag, int timeout);
+extern int rtsx_usb_get_rsp(struct rtsx_ucr *ucr, int rsp_len, int timeout);
+extern int rtsx_usb_transfer_data(struct rtsx_ucr *ucr, unsigned int pipe,
+			      void *buf, unsigned int len, int use_sg,
+			      unsigned int *act_len, int timeout);
+
+extern int rtsx_usb_read_ppbuf(struct rtsx_ucr *ucr, u8 *buf, int buf_len);
+extern int rtsx_usb_write_ppbuf(struct rtsx_ucr *ucr, u8 *buf, int buf_len);
+extern int rtsx_usb_switch_clock(struct rtsx_ucr *ucr, unsigned int card_clock,
+		u8 ssc_depth, bool initial_mode, bool double_clk, bool vpclk);
+extern int rtsx_usb_card_exclusive_check(struct rtsx_ucr *ucr, int card);
+
+/* card status */
+#define SD_CD		0x01
+#define MS_CD		0x02
+#define XD_CD		0x04
+#define CD_MASK		(SD_CD | MS_CD | XD_CD)
+#define SD_WP		0x08
+
+/* reader command field offset & parameters */
+#define READ_REG_CMD		0
+#define WRITE_REG_CMD		1
+#define CHECK_REG_CMD		2
+
+#define PACKET_TYPE		4
+#define CNT_H			5
+#define CNT_L			6
+#define STAGE_FLAG		7
+#define CMD_OFFSET		8
+
+#define BATCH_CMD		0
+#define SEQ_READ		1
+#define SEQ_WRITE		2
+
+#define STAGE_R			0x01
+#define STAGE_DI		0x02
+#define STAGE_DO		0x04
+#define STAGE_MS_STATUS		0x08
+#define STAGE_XD_STATUS		0x10
+#define MODE_C			0x00
+#define MODE_CR			(STAGE_R)
+#define MODE_CDIR		(STAGE_R | STAGE_DI)
+#define MODE_CDOR		(STAGE_R | STAGE_DO)
+
+static inline void rtsx_usb_init_cmd(struct rtsx_ucr *ucr)
+{
+	ucr->cmd_idx = 0;
+	ucr->cmd_buf[0] = 'R';
+	ucr->cmd_buf[1] = 'T';
+	ucr->cmd_buf[2] = 'C';
+	ucr->cmd_buf[3] = 'R';
+	ucr->cmd_buf[PACKET_TYPE] = BATCH_CMD;
+}
+
+/* internal register address */
+#define FPDCTL				0xFC00
+#define SSC_DIV_N_0			0xFC07
+#define SSC_CTL1			0xFC09
+#define SSC_CTL2			0xFC0A
+#define CFG_MODE			0xFC0E
+#define CFG_MODE_1			0xFC0F
+#define RCCTL				0xFC14
+#define SOF_WDOG			0xFC28
+#define SYS_DUMMY0			0xFC30
+
+#define MS_BLKEND			0xFD30
+#define MS_READ_START			0xFD31
+#define MS_READ_COUNT			0xFD32
+#define MS_WRITE_START			0xFD33
+#define MS_WRITE_COUNT			0xFD34
+#define MS_COMMAND			0xFD35
+#define MS_OLD_BLOCK_0			0xFD36
+#define MS_OLD_BLOCK_1			0xFD37
+#define MS_NEW_BLOCK_0			0xFD38
+#define MS_NEW_BLOCK_1			0xFD39
+#define MS_LOG_BLOCK_0			0xFD3A
+#define MS_LOG_BLOCK_1			0xFD3B
+#define MS_BUS_WIDTH			0xFD3C
+#define MS_PAGE_START			0xFD3D
+#define MS_PAGE_LENGTH			0xFD3E
+#define MS_CFG				0xFD40
+#define MS_TPC				0xFD41
+#define MS_TRANS_CFG			0xFD42
+#define MS_TRANSFER			0xFD43
+#define MS_INT_REG			0xFD44
+#define MS_BYTE_CNT			0xFD45
+#define MS_SECTOR_CNT_L			0xFD46
+#define MS_SECTOR_CNT_H			0xFD47
+#define MS_DBUS_H			0xFD48
+
+#define CARD_DMA1_CTL			0xFD5C
+#define CARD_PULL_CTL1			0xFD60
+#define CARD_PULL_CTL2			0xFD61
+#define CARD_PULL_CTL3			0xFD62
+#define CARD_PULL_CTL4			0xFD63
+#define CARD_PULL_CTL5			0xFD64
+#define CARD_PULL_CTL6			0xFD65
+#define CARD_EXIST			0xFD6F
+#define CARD_INT_PEND			0xFD71
+
+#define LDO_POWER_CFG			0xFD7B
+
+#define SD_CFG1				0xFDA0
+#define SD_CFG2				0xFDA1
+#define SD_CFG3				0xFDA2
+#define SD_STAT1			0xFDA3
+#define SD_STAT2			0xFDA4
+#define SD_BUS_STAT			0xFDA5
+#define SD_PAD_CTL			0xFDA6
+#define SD_SAMPLE_POINT_CTL		0xFDA7
+#define SD_PUSH_POINT_CTL		0xFDA8
+#define SD_CMD0				0xFDA9
+#define SD_CMD1				0xFDAA
+#define SD_CMD2				0xFDAB
+#define SD_CMD3				0xFDAC
+#define SD_CMD4				0xFDAD
+#define SD_CMD5				0xFDAE
+#define SD_BYTE_CNT_L			0xFDAF
+#define SD_BYTE_CNT_H			0xFDB0
+#define SD_BLOCK_CNT_L			0xFDB1
+#define SD_BLOCK_CNT_H			0xFDB2
+#define SD_TRANSFER			0xFDB3
+#define SD_CMD_STATE			0xFDB5
+#define SD_DATA_STATE			0xFDB6
+#define SD_VPCLK0_CTL			0xFC2A
+#define SD_VPCLK1_CTL			0xFC2B
+#define SD_DCMPS0_CTL			0xFC2C
+#define SD_DCMPS1_CTL			0xFC2D
+
+#define CARD_DMA1_CTL			0xFD5C
+
+#define HW_VERSION			0xFC01
+
+#define SSC_CLK_FPGA_SEL		0xFC02
+#define CLK_DIV				0xFC03
+#define SFSM_ED				0xFC04
+
+#define CD_DEGLITCH_WIDTH		0xFC20
+#define CD_DEGLITCH_EN			0xFC21
+#define AUTO_DELINK_EN			0xFC23
+
+#define FPGA_PULL_CTL			0xFC1D
+#define CARD_CLK_SOURCE			0xFC2E
+
+#define CARD_SHARE_MODE			0xFD51
+#define CARD_DRIVE_SEL			0xFD52
+#define CARD_STOP			0xFD53
+#define CARD_OE				0xFD54
+#define CARD_AUTO_BLINK			0xFD55
+#define CARD_GPIO			0xFD56
+#define SD30_DRIVE_SEL			0xFD57
+
+#define CARD_DATA_SOURCE		0xFD5D
+#define CARD_SELECT			0xFD5E
+
+#define CARD_CLK_EN			0xFD79
+#define CARD_PWR_CTL			0xFD7A
+
+#define OCPCTL				0xFD80
+#define OCPPARA1			0xFD81
+#define OCPPARA2			0xFD82
+#define OCPSTAT				0xFD83
+
+#define HS_USB_STAT			0xFE01
+#define HS_VCONTROL			0xFE26
+#define HS_VSTAIN			0xFE27
+#define HS_VLOADM			0xFE28
+#define HS_VSTAOUT			0xFE29
+
+#define MC_IRQ				0xFF00
+#define MC_IRQEN			0xFF01
+#define MC_FIFO_CTL			0xFF02
+#define MC_FIFO_BC0			0xFF03
+#define MC_FIFO_BC1			0xFF04
+#define MC_FIFO_STAT			0xFF05
+#define MC_FIFO_MODE			0xFF06
+#define MC_FIFO_RD_PTR0			0xFF07
+#define MC_FIFO_RD_PTR1			0xFF08
+#define MC_DMA_CTL			0xFF10
+#define MC_DMA_TC0			0xFF11
+#define MC_DMA_TC1			0xFF12
+#define MC_DMA_TC2			0xFF13
+#define MC_DMA_TC3			0xFF14
+#define MC_DMA_RST			0xFF15
+
+#define RBUF_SIZE_MASK			0xFBFF
+#define RBUF_BASE			0xF000
+#define PPBUF_BASE1			0xF800
+#define PPBUF_BASE2			0xFA00
+
+/* internal register value macros */
+#define POWER_OFF			0x03
+#define PARTIAL_POWER_ON		0x02
+#define POWER_ON			0x00
+#define POWER_MASK			0x03
+#define LDO3318_PWR_MASK		0x0C
+#define LDO_ON				0x00
+#define LDO_SUSPEND			0x08
+#define LDO_OFF				0x0C
+#define DV3318_AUTO_PWR_OFF		0x10
+#define FORCE_LDO_POWERB		0x60
+
+/* LDO_POWER_CFG */
+#define TUNE_SD18_MASK			0x1C
+#define TUNE_SD18_1V7			0x00
+#define TUNE_SD18_1V8			(0x01 << 2)
+#define TUNE_SD18_1V9			(0x02 << 2)
+#define TUNE_SD18_2V0			(0x03 << 2)
+#define TUNE_SD18_2V7			(0x04 << 2)
+#define TUNE_SD18_2V8			(0x05 << 2)
+#define TUNE_SD18_2V9			(0x06 << 2)
+#define TUNE_SD18_3V3			(0x07 << 2)
+
+/* CLK_DIV */
+#define CLK_CHANGE			0x80
+#define CLK_DIV_1			0x00
+#define CLK_DIV_2			0x01
+#define CLK_DIV_4			0x02
+#define CLK_DIV_8			0x03
+
+#define SSC_POWER_MASK			0x01
+#define SSC_POWER_DOWN			0x01
+#define SSC_POWER_ON			0x00
+
+#define FPGA_VER			0x80
+#define HW_VER_MASK			0x0F
+
+#define EXTEND_DMA1_ASYNC_SIGNAL	0x02
+
+/* CFG_MODE*/
+#define XTAL_FREE			0x80
+#define CLK_MODE_MASK			0x03
+#define CLK_MODE_12M_XTAL		0x00
+#define CLK_MODE_NON_XTAL		0x01
+#define CLK_MODE_24M_OSC		0x02
+#define CLK_MODE_48M_OSC		0x03
+
+/* CFG_MODE_1*/
+#define RTS5179				0x02
+
+#define NYET_EN				0x01
+#define NYET_MSAK			0x01
+
+#define SD30_DRIVE_MASK			0x07
+#define SD20_DRIVE_MASK			0x03
+
+#define DISABLE_SD_CD			0x08
+#define DISABLE_MS_CD			0x10
+#define DISABLE_XD_CD			0x20
+#define SD_CD_DEGLITCH_EN		0x01
+#define MS_CD_DEGLITCH_EN		0x02
+#define XD_CD_DEGLITCH_EN		0x04
+
+#define	CARD_SHARE_LQFP48		0x04
+#define	CARD_SHARE_QFN24		0x00
+#define CARD_SHARE_LQFP_SEL		0x04
+#define	CARD_SHARE_XD			0x00
+#define	CARD_SHARE_SD			0x01
+#define	CARD_SHARE_MS			0x02
+#define CARD_SHARE_MASK			0x03
+
+
+/* SD30_DRIVE_SEL */
+#define DRIVER_TYPE_A			0x05
+#define DRIVER_TYPE_B			0x03
+#define DRIVER_TYPE_C			0x02
+#define DRIVER_TYPE_D			0x01
+
+/* SD_BUS_STAT */
+#define	SD_CLK_TOGGLE_EN		0x80
+#define	SD_CLK_FORCE_STOP	        0x40
+#define	SD_DAT3_STATUS		        0x10
+#define	SD_DAT2_STATUS		        0x08
+#define	SD_DAT1_STATUS		        0x04
+#define	SD_DAT0_STATUS		        0x02
+#define	SD_CMD_STATUS			0x01
+
+/* SD_PAD_CTL */
+#define	SD_IO_USING_1V8		        0x80
+#define	SD_IO_USING_3V3		        0x7F
+#define	TYPE_A_DRIVING		        0x00
+#define	TYPE_B_DRIVING			0x01
+#define	TYPE_C_DRIVING			0x02
+#define	TYPE_D_DRIVING		        0x03
+
+/* CARD_CLK_EN */
+#define SD_CLK_EN			0x04
+#define MS_CLK_EN			0x08
+
+/* CARD_SELECT */
+#define SD_MOD_SEL			2
+#define MS_MOD_SEL			3
+
+/* CARD_SHARE_MODE */
+#define	CARD_SHARE_LQFP48		0x04
+#define	CARD_SHARE_QFN24		0x00
+#define CARD_SHARE_LQFP_SEL		0x04
+#define	CARD_SHARE_XD			0x00
+#define	CARD_SHARE_SD			0x01
+#define	CARD_SHARE_MS			0x02
+#define CARD_SHARE_MASK			0x03
+
+/* SSC_CTL1 */
+#define SSC_RSTB			0x80
+#define SSC_8X_EN			0x40
+#define SSC_FIX_FRAC			0x20
+#define SSC_SEL_1M			0x00
+#define SSC_SEL_2M			0x08
+#define SSC_SEL_4M			0x10
+#define SSC_SEL_8M			0x18
+
+/* SSC_CTL2 */
+#define SSC_DEPTH_MASK			0x03
+#define SSC_DEPTH_DISALBE		0x00
+#define SSC_DEPTH_2M			0x01
+#define SSC_DEPTH_1M			0x02
+#define SSC_DEPTH_512K			0x03
+
+/* SD_VPCLK0_CTL */
+#define PHASE_CHANGE			0x80
+#define PHASE_NOT_RESET			0x40
+
+/* SD_TRANSFER */
+#define	SD_TRANSFER_START		0x80
+#define	SD_TRANSFER_END			0x40
+#define SD_STAT_IDLE			0x20
+#define	SD_TRANSFER_ERR			0x10
+#define	SD_TM_NORMAL_WRITE		0x00
+#define	SD_TM_AUTO_WRITE_3		0x01
+#define	SD_TM_AUTO_WRITE_4		0x02
+#define	SD_TM_AUTO_READ_3		0x05
+#define	SD_TM_AUTO_READ_4		0x06
+#define	SD_TM_CMD_RSP			0x08
+#define	SD_TM_AUTO_WRITE_1		0x09
+#define	SD_TM_AUTO_WRITE_2		0x0A
+#define	SD_TM_NORMAL_READ		0x0C
+#define	SD_TM_AUTO_READ_1		0x0D
+#define	SD_TM_AUTO_READ_2		0x0E
+#define	SD_TM_AUTO_TUNING		0x0F
+
+/* SD_CFG1 */
+#define SD_CLK_DIVIDE_0			0x00
+#define	SD_CLK_DIVIDE_256		0xC0
+#define	SD_CLK_DIVIDE_128		0x80
+#define SD_CLK_DIVIDE_MASK		0xC0
+#define	SD_BUS_WIDTH_1BIT		0x00
+#define	SD_BUS_WIDTH_4BIT		0x01
+#define	SD_BUS_WIDTH_8BIT		0x02
+#define	SD_ASYNC_FIFO_RST		0x10
+#define	SD_20_MODE			0x00
+#define	SD_DDR_MODE			0x04
+#define	SD_30_MODE			0x08
+
+/* SD_CFG2 */
+#define	SD_CALCULATE_CRC7		0x00
+#define	SD_NO_CALCULATE_CRC7		0x80
+#define	SD_CHECK_CRC16			0x00
+#define	SD_NO_CHECK_CRC16		0x40
+#define SD_WAIT_CRC_TO_EN		0x20
+#define	SD_WAIT_BUSY_END		0x08
+#define	SD_NO_WAIT_BUSY_END		0x00
+#define	SD_CHECK_CRC7			0x00
+#define	SD_NO_CHECK_CRC7		0x04
+#define	SD_RSP_LEN_0			0x00
+#define	SD_RSP_LEN_6			0x01
+#define	SD_RSP_LEN_17			0x02
+#define	SD_RSP_TYPE_R0			0x04
+#define	SD_RSP_TYPE_R1			0x01
+#define	SD_RSP_TYPE_R1b			0x09
+#define	SD_RSP_TYPE_R2			0x02
+#define	SD_RSP_TYPE_R3			0x05
+#define	SD_RSP_TYPE_R4			0x05
+#define	SD_RSP_TYPE_R5			0x01
+#define	SD_RSP_TYPE_R6			0x01
+#define	SD_RSP_TYPE_R7			0x01
+
+/* SD_STAT1 */
+#define	SD_CRC7_ERR			0x80
+#define	SD_CRC16_ERR			0x40
+#define	SD_CRC_WRITE_ERR		0x20
+#define	SD_CRC_WRITE_ERR_MASK		0x1C
+#define	GET_CRC_TIME_OUT		0x02
+#define	SD_TUNING_COMPARE_ERR		0x01
+
+/* SD_DATA_STATE */
+#define SD_DATA_IDLE			0x80
+
+/* CARD_DATA_SOURCE */
+#define PINGPONG_BUFFER			0x01
+#define RING_BUFFER			0x00
+
+/* CARD_OE */
+#define SD_OUTPUT_EN			0x04
+#define MS_OUTPUT_EN			0x08
+
+/* CARD_STOP */
+#define SD_STOP				0x04
+#define MS_STOP				0x08
+#define SD_CLR_ERR			0x40
+#define MS_CLR_ERR			0x80
+
+/* CARD_CLK_SOURCE */
+#define CRC_FIX_CLK			(0x00 << 0)
+#define CRC_VAR_CLK0			(0x01 << 0)
+#define CRC_VAR_CLK1			(0x02 << 0)
+#define SD30_FIX_CLK			(0x00 << 2)
+#define SD30_VAR_CLK0			(0x01 << 2)
+#define SD30_VAR_CLK1			(0x02 << 2)
+#define SAMPLE_FIX_CLK			(0x00 << 4)
+#define SAMPLE_VAR_CLK0			(0x01 << 4)
+#define SAMPLE_VAR_CLK1			(0x02 << 4)
+
+/* SD_SAMPLE_POINT_CTL */
+#define	DDR_FIX_RX_DAT			0x00
+#define	DDR_VAR_RX_DAT			0x80
+#define	DDR_FIX_RX_DAT_EDGE		0x00
+#define	DDR_FIX_RX_DAT_14_DELAY		0x40
+#define	DDR_FIX_RX_CMD			0x00
+#define	DDR_VAR_RX_CMD			0x20
+#define	DDR_FIX_RX_CMD_POS_EDGE		0x00
+#define	DDR_FIX_RX_CMD_14_DELAY		0x10
+#define	SD20_RX_POS_EDGE		0x00
+#define	SD20_RX_14_DELAY		0x08
+#define SD20_RX_SEL_MASK		0x08
+
+/* SD_PUSH_POINT_CTL */
+#define	DDR_FIX_TX_CMD_DAT		0x00
+#define	DDR_VAR_TX_CMD_DAT		0x80
+#define	DDR_FIX_TX_DAT_14_TSU		0x00
+#define	DDR_FIX_TX_DAT_12_TSU		0x40
+#define	DDR_FIX_TX_CMD_NEG_EDGE		0x00
+#define	DDR_FIX_TX_CMD_14_AHEAD		0x20
+#define	SD20_TX_NEG_EDGE		0x00
+#define	SD20_TX_14_AHEAD		0x10
+#define SD20_TX_SEL_MASK		0x10
+#define	DDR_VAR_SDCLK_POL_SWAP		0x01
+
+/* MS_CFG */
+#define	SAMPLE_TIME_RISING		0x00
+#define	SAMPLE_TIME_FALLING		0x80
+#define	PUSH_TIME_DEFAULT		0x00
+#define	PUSH_TIME_ODD			0x40
+#define	NO_EXTEND_TOGGLE		0x00
+#define	EXTEND_TOGGLE_CHK		0x20
+#define	MS_BUS_WIDTH_1			0x00
+#define	MS_BUS_WIDTH_4			0x10
+#define	MS_BUS_WIDTH_8			0x18
+#define	MS_2K_SECTOR_MODE		0x04
+#define	MS_512_SECTOR_MODE		0x00
+#define	MS_TOGGLE_TIMEOUT_EN		0x00
+#define	MS_TOGGLE_TIMEOUT_DISEN		0x01
+#define MS_NO_CHECK_INT			0x02
+
+/* MS_TRANS_CFG */
+#define	WAIT_INT			0x80
+#define	NO_WAIT_INT			0x00
+#define	NO_AUTO_READ_INT_REG		0x00
+#define	AUTO_READ_INT_REG		0x40
+#define	MS_CRC16_ERR			0x20
+#define	MS_RDY_TIMEOUT			0x10
+#define	MS_INT_CMDNK			0x08
+#define	MS_INT_BREQ			0x04
+#define	MS_INT_ERR			0x02
+#define	MS_INT_CED			0x01
+
+/* MS_TRANSFER */
+#define	MS_TRANSFER_START		0x80
+#define	MS_TRANSFER_END			0x40
+#define	MS_TRANSFER_ERR			0x20
+#define	MS_BS_STATE			0x10
+#define	MS_TM_READ_BYTES		0x00
+#define	MS_TM_NORMAL_READ		0x01
+#define	MS_TM_WRITE_BYTES		0x04
+#define	MS_TM_NORMAL_WRITE		0x05
+#define	MS_TM_AUTO_READ			0x08
+#define	MS_TM_AUTO_WRITE		0x0C
+#define MS_TM_SET_CMD			0x06
+#define MS_TM_COPY_PAGE			0x07
+#define MS_TM_MULTI_READ		0x02
+#define MS_TM_MULTI_WRITE		0x03
+
+/* MC_FIFO_CTL */
+#define FIFO_FLUSH			0x01
+
+/* MC_DMA_RST */
+#define DMA_RESET  0x01
+
+/* MC_DMA_CTL */
+#define DMA_TC_EQ_0			0x80
+#define DMA_DIR_TO_CARD			0x00
+#define DMA_DIR_FROM_CARD		0x02
+#define DMA_EN				0x01
+#define DMA_128				(0 << 2)
+#define DMA_256				(1 << 2)
+#define DMA_512				(2 << 2)
+#define DMA_1024			(3 << 2)
+#define DMA_PACK_SIZE_MASK		0x0C
+
+/* CARD_INT_PEND */
+#define XD_INT				0x10
+#define MS_INT				0x08
+#define SD_INT				0x04
+
+/* LED operations*/
+static inline int rtsx_usb_turn_on_led(struct rtsx_ucr *ucr)
+{
+	return  rtsx_usb_ep0_write_register(ucr, CARD_GPIO, 0x03, 0x02);
+}
+
+static inline int rtsx_usb_turn_off_led(struct rtsx_ucr *ucr)
+{
+	return rtsx_usb_ep0_write_register(ucr, CARD_GPIO, 0x03, 0x03);
+}
+
+/* HW error clearing */
+static inline void rtsx_usb_clear_fsm_err(struct rtsx_ucr *ucr)
+{
+	rtsx_usb_ep0_write_register(ucr, SFSM_ED, 0xf8, 0xf8);
+}
+
+static inline void rtsx_usb_clear_dma_err(struct rtsx_ucr *ucr)
+{
+	rtsx_usb_ep0_write_register(ucr, MC_FIFO_CTL,
+			FIFO_FLUSH, FIFO_FLUSH);
+	rtsx_usb_ep0_write_register(ucr, MC_DMA_RST, DMA_RESET, DMA_RESET);
+}
+#endif /* __RTS51139_H */
-- 
1.8.2

