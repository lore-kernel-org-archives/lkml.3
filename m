Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab3FQISB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:18:01 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:43244
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079Ab3FQIRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:17:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzd799h853kc8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH 3/5] drivers/misc: rf/ad9361: AD9361 device driver for Radio phy
Date: Mon, 17 Jun 2013 13:39:24 +0530
Message-ID: <1371456566-4934-4-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1371456566-4934-3-git-send-email-akhil.goyal@freescale.com>
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-2-git-send-email-akhil.goyal@freescale.com>
 <1371456566-4934-3-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

AD9361 is a radio phy(RFIC) for radio networks. This phy
can support LTE-FDD/LTE-TDD and WCDMA networks. The RFIC
can convert the analog radio signals from air to digital
IQ samples.

AD9361 is controlled via an SPI bus and all the register
read/ write can be performed via SPI transactions.

Driver provides various operations for configuring and
controlling the AD PHY. These can be controlled from the
user space via the rfdev framework.

Driver also binds itself to one of AIC lane using RF framework.
The combination of AIC lane and PHY connected to it works
as one RF device.

Signed-off-by: Shaveta Leekha <shaveta@freescale.com>
Signed-off-by: Pankaj Chauhan <pankaj.chauhan@freescale.com>
Signed-off-by: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>
Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
---
 drivers/misc/rf/Makefile     |    1 +
 drivers/misc/rf/phy/Makefile |    2 +
 drivers/misc/rf/phy/ad9361.c | 1918 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/rf/phy/ad9361.h |  353 ++++++++
 4 files changed, 2274 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/rf/phy/Makefile
 create mode 100644 drivers/misc/rf/phy/ad9361.c
 create mode 100644 drivers/misc/rf/phy/ad9361.h

diff --git a/drivers/misc/rf/Makefile b/drivers/misc/rf/Makefile
index 37dc442..61a0e7c 100644
--- a/drivers/misc/rf/Makefile
+++ b/drivers/misc/rf/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_RFDEVICES)		+= core/
 obj-$(CONFIG_RFDEVICES)		+= controllers/
+obj-$(CONFIG_RFDEVICES)		+= phy/
diff --git a/drivers/misc/rf/phy/Makefile b/drivers/misc/rf/phy/Makefile
new file mode 100644
index 0000000..4b1b54b
--- /dev/null
+++ b/drivers/misc/rf/phy/Makefile
@@ -0,0 +1,2 @@
+
+obj-$(CONFIG_ADI9361)		+= ad9361.o
diff --git a/drivers/misc/rf/phy/ad9361.c b/drivers/misc/rf/phy/ad9361.c
new file mode 100644
index 0000000..561fdba
--- /dev/null
+++ b/drivers/misc/rf/phy/ad9361.c
@@ -0,0 +1,1918 @@
+/*
+ *
+ * File: drivers/rf/phy/ad9361.c
+ *
+ * Freescale AD9361 Phy driver.
+ * AD9361 is a RF phy device connected to one of the AIC lane.
+ * Control path of AD9361 is through SPI interface whereas data path
+ * is through AIC. Its driver register it as a spi driver for the configuration
+ * of ad device via spi and also registers itself as rf_phy_dev that binds
+ * phy device to AIC lane, for data path(UL/DL).
+ *
+ * Author: Shaveta Leekha <shaveta@freescale.com>
+ *
+ * Copyright (C) 2011-2012 Freescale Semiconductor, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/param.h>
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/io.h>
+#include <linux/of_gpio.h>
+#include <linux/gpio.h>
+#include <linux/rfdev.h>
+#include <linux/string.h>
+#include "ad9361.h"
+
+#define DRV_DESC "FREESCALE DEVELOPED AD9361 PHY DRIVER"
+#define DRV_NAME "ad9361_phy"
+#define DEBUG
+
+int lna_table[] = {6, 17, 19, 25};
+int tia_table[] = {-6, 0};
+int mixer_table[] = {	0, 5, 11, 16,
+			17, 18, 19, 20,
+			21, 22, 23, 24,
+			25, 26,	27, 28};
+
+/* To check where reset gpio has been toggled to
+ * reset AD PHY device or not. */
+bool reset_status;
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION(DRV_DESC);
+
+static int ad_phy_run_cmds(struct rf_phy_dev *ad_phy, struct rif_phy_cmd *cmds,
+		int count);
+static int ad_phy_read(struct rf_phy_dev *ad_phy, u32 start, u32 count,
+		u32 *buff);
+static int ad_phy_write(struct rf_phy_dev *ad_phy, u32 reg, u32 data);
+static int ad_set_tx_atten(struct rf_phy_dev *ad_phy, u32 tx_if, u32 tx_atten);
+static int ad_en_dis_tx(struct rf_phy_dev *ad_phy, u32 tx_if, u32 cmd);
+static int ad_en_dis_rx(struct rf_phy_dev *ad_phy, u32 rx_if, u32 rx_cmd);
+static int ad_read_rssi(struct rf_phy_dev *ad_phy, struct rf_rssi *rssi);
+static int ad_phy_dac_correction(struct rf_phy_dev *ad_phy,
+					struct rif_dac_params *params);
+static int ad_phy_get_dac_value(struct rf_phy_dev *ad_phy,
+					u32 correction_type, u32 *buff);
+static int ad_phy_start(struct rf_phy_dev *ad_phy);
+static int ad_init(struct rf_phy_dev *phy, struct rf_init_params *params);
+static int ad_phy_stop(struct rf_phy_dev *phy);
+static int ad_get_rx_gain(struct rf_phy_dev *ad_phy,
+		struct rf_rx_gain *rx_gain);
+static int ad_set_rx_gain(struct rf_phy_dev *ad_phy,
+		struct rf_rx_gain *rx_gain);
+static int ad_config_sniff(struct rf_phy_dev *ad_phy,
+		struct rf_sniff_params *sniff_params);
+static int ad_set_gain_ctrl_mode(struct rf_phy_dev *ad_phy,
+		struct rf_gain_ctrl *gain_ctrl);
+static int ad_set_band(struct rf_phy_dev *ad_phy, unsigned int band);
+static int ad_save_synth_table(struct rf_phy_dev *ad_phy,
+		struct rf_synth_table *synth_table);
+static int ad_config_master_slave(unsigned int lane_id,
+		struct rf_phy_dev *ad_phy, enum rf_lane_mode mode);
+
+static struct rf_phy_ops ad_phy_ops = {
+	.init = ad_init,
+	.set_timer_correction = ad_phy_dac_correction,
+	.read_dac_value = ad_phy_get_dac_value,
+	.run_cmds = ad_phy_run_cmds,
+	.read_regs = ad_phy_read,
+	.write_reg = ad_phy_write,
+	.set_tx_atten = ad_set_tx_atten,
+	.en_dis_tx = ad_en_dis_tx,
+	.read_rssi = ad_read_rssi,
+	.start = ad_phy_start,
+	.stop = ad_phy_stop,
+	.get_rx_gain = ad_get_rx_gain,
+	.set_rx_gain = ad_set_rx_gain,
+	.config_sniff = ad_config_sniff,
+	.set_gain_ctrl_mode = ad_set_gain_ctrl_mode,
+	.save_synth_table = ad_save_synth_table,
+	.config_master_slave = ad_config_master_slave,
+};
+
+
+u16 create_ad_phy_cmd(u16 reg, int opcode, int bytes_transfer)
+{
+	u16 cmd_word = 0;
+
+	switch (opcode) {
+	case SPI_WRITE:
+		cmd_word = OPCODE_WRITE
+			|(((bytes_transfer - 1) << SHIFT_BYTES_TRANSFER)
+						& (BYTES_TRANSFER_MASK))
+			| (reg & REG_ADDRESS_MASK);
+		break;
+
+	case SPI_READ:
+		cmd_word = OPCODE_READ
+			|(((bytes_transfer - 1) << SHIFT_BYTES_TRANSFER)
+						& (BYTES_TRANSFER_MASK))
+			| (reg & REG_ADDRESS_MASK);
+		break;
+
+	}
+
+	return cmd_word;
+}
+
+static int spi_write_transaction(struct rf_phy_dev *ad_phy, u8 *buf, int len)
+{
+	u8 *tx_buf;
+	int status;
+	struct spi_message spi_msg;
+	struct spi_transfer ad_tx;
+	struct ad_dev_info *phy_info = ad_phy->priv;
+
+	spi_message_init(&spi_msg);
+	memset(&ad_tx, 0, sizeof(ad_tx));
+
+	tx_buf = buf;
+	ad_tx.len = len;
+	ad_tx.tx_buf = &tx_buf[0];
+	ad_tx.rx_buf = &(phy_info->rx_buf[0]);
+
+	spi_message_add_tail(&ad_tx, &spi_msg);
+	status = spi_sync(phy_info->ad_spi, &spi_msg);
+
+	return status;
+}
+
+static int spi_read_transaction(struct rf_phy_dev *ad_phy, u8 *buf, int len)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	u8 *tx_buf;
+	struct spi_message spi_msg;
+	struct spi_transfer ad_tx;
+	int status;
+
+	spi_message_init(&spi_msg);
+	memset(&ad_tx, 0, sizeof(ad_tx));
+
+	tx_buf = buf;
+	ad_tx.len = len;
+	ad_tx.tx_buf = &tx_buf[0];
+	ad_tx.rx_buf = &(phy_info->rx_buf[0]);
+
+	spi_message_add_tail(&ad_tx, &spi_msg);
+	status = spi_sync(phy_info->ad_spi, &spi_msg);
+
+	return status;
+}
+
+static int check_cal_done(struct rf_phy_dev *ad_phy, u32 reg, u32 mask,
+		u32 bitval)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	u32 val;
+	int rc = 0;
+	ad_phy_read(ad_phy, reg, 1, &val);
+	switch (bitval) {
+	case 0:
+		if (!(val & mask))
+			rc = 1;
+		break;
+	case 1:
+		if (val & mask)
+			rc = 1;
+		break;
+	default:
+		dev_err(dev, "Invalid bit value\n");
+		return -EINVAL;
+	}
+	return rc;
+}
+
+int save_tx_atten(struct rf_phy_dev *ad_phy)
+{
+	u32 buf[4];
+	u32 msb;
+	ad_phy_read(ad_phy, TX1_ATTEN0, sizeof(buf)/sizeof(u32), buf);
+	msb = buf[1] & ATTEN_MSB_BIT_MASK;
+	ad_phy->tx_atten[0] = (msb << MSB_SHIFT) + buf[0];
+	msb = buf[3] & ATTEN_MSB_BIT_MASK;
+	ad_phy->tx_atten[1] = (msb << MSB_SHIFT) + buf[2];
+	return 1;
+}
+
+int ad_phy_run_cmds(struct rf_phy_dev *ad_phy,
+		struct rif_phy_cmd *cmds, int count)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int i, elapsed_time;
+	u32 val;
+
+	for (i = 0; i < count; i++) {
+		switch (cmds[i].cmd) {
+		case SPI_WRITE:
+			if (cmds[i].param1 == REG_RX_CP_CONFIG) {
+				ad_phy_read(ad_phy, REG_RX_CAL_STATUS, 1, &val);
+				if (val & MASK_RX_CP_CAL_VALID)
+					break;
+			} else if (cmds[i].param1 == REG_TX_CP_CONFIG) {
+				ad_phy_read(ad_phy, REG_TX_CAL_STATUS, 1, &val);
+				if (val & MASK_TX_CP_CAL_VALID)
+					break;
+			}
+			ad_phy_write(ad_phy, cmds[i].param1, cmds[i].param2);
+
+			dev_dbg(dev, "Write: %x %x\n", cmds[i].param1,
+							cmds[i].param2);
+			break;
+
+		case SPI_READ:
+
+			/* XXX: This READ is not returnning anything from
+			 * here so can be removed safely. But not removing
+			 * it completely from here because these reads may
+			 * impact timing between reg updates up RFIC.
+			 *
+			 * This needs to be fixed, right way is to return
+			 * read values, and let user space decide what to
+			 * do this value.
+			 */
+			ad_phy_read(ad_phy, cmds[i].param1, 1, &val);
+			dev_dbg(dev, "Read from reg: %x, val %x\n",
+				cmds[i].param1, val);
+			break;
+
+		case SPI_WAIT:
+			msleep_interruptible(cmds[i].param3);
+			break;
+
+		case SPI_WAIT_BBPLL_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy, REG_CH1_OVERFLOW,
+							MASK_BBPLL_LOCK, 1))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_RXCP_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy, REG_RX_CAL_STATUS,
+						MASK_RX_CP_CAL_VALID, 1))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_TXCP_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy,
+						REG_TX_CAL_STATUS,
+						MASK_TX_CP_CAL_VALID, 1))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_RXFILTER_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy,
+						REG_CALIBRATION_CONTROL,
+						MASK_RX_BB_TUNE, 0))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_TXFILTER_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy,
+						REG_CALIBRATION_CONTROL,
+						MASK_TX_BB_TUNE, 0))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_BBDC_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy,
+						REG_CALIBRATION_CONTROL,
+						MASK_DC_CAL_BBSTART, 0))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_RFDC_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy,
+						REG_CALIBRATION_CONTROL,
+						MASK_DC_CAL_RFSTART, 0))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_TXQUAD_CAL:
+			for (elapsed_time = 1; elapsed_time < cmds[i].param3;
+					elapsed_time++) {
+				msleep_interruptible(1);
+				if (check_cal_done(ad_phy,
+						REG_CALIBRATION_CONTROL,
+						MASK_TXQUAD_CAL, 0))
+					break;
+			}
+			break;
+
+		case SPI_WAIT_CALDONE:
+			dev_info(dev, "Waiting for unknown CALDONE.\n");
+			msleep_interruptible(cmds[i].param3);
+			break;
+
+		default:
+			dev_dbg(dev, "Not a valid AD_PHY command\n");
+			return -EINVAL;
+		}
+	}
+
+	save_tx_atten(ad_phy);
+	return 0;
+}
+
+static int ad_save_synth_table(struct rf_phy_dev *ad_phy,
+		struct rf_synth_table *synth_table)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int size = sizeof(unsigned long long) * synth_table->count *
+					NUM_SYNTH_PARAMS;
+
+	kfree(phy_info->synth_table.params);
+	kfree(phy_info->synth_table.reg_vals);
+	phy_info->synth_table.params =
+		(unsigned long long (*)[NUM_SYNTH_PARAMS])kzalloc
+			(size, GFP_KERNEL);
+	if (!phy_info->synth_table.params) {
+		dev_dbg(dev, "Failed to allocate rf_synth_table\n");
+		return -ENOMEM;
+	}
+	memcpy(phy_info->synth_table.params, synth_table->params, size);
+
+	size = sizeof(u8) * synth_table->count * NUM_SYNTH_REGS;
+	phy_info->synth_table.reg_vals = (u8 (*)[NUM_SYNTH_REGS])kzalloc
+						(size, GFP_KERNEL);
+	if (!phy_info->synth_table.reg_vals) {
+		dev_dbg(dev, "Failed to allocate rf_synth_table\n");
+		kfree(phy_info->synth_table.params);
+		return -ENOMEM;
+	}
+	memcpy(phy_info->synth_table.reg_vals, synth_table->reg_vals, size);
+	phy_info->synth_table.count = synth_table->count;
+
+	return 0;
+}
+
+static int get_split_table_gain(struct rf_phy_dev *ad_phy, u32 idx_reg,
+		struct rf_rx_gain *rx_gain)
+{
+	u32 val, tbl_addr, lna_index, tia_index, mixer_index;
+	int rc = 0;
+
+	/* Read LMT index */
+	ad_phy_read(ad_phy, idx_reg, 1, &val);
+	rx_gain->lmt_index = val & FULL_TBL_IDX_MASK;
+	ad_phy_read(ad_phy, REG_GAIN_TBL_ADDR, 1, &tbl_addr);
+	ad_phy_write(ad_phy, REG_GAIN_TBL_ADDR, val);
+	ad_phy_read(ad_phy, REG_GAIN_TBL_READ_DATA1, 1, &val);
+	lna_index = (val & LNA_GAIN_MASK) >> LNA_SHIFT;
+	mixer_index = (val & MIXER_GAIN_MASK) >> MIXER_SHIFT;
+	ad_phy_read(ad_phy, REG_GAIN_TBL_READ_DATA2, 1, &val);
+	tia_index = (val & TIA_GAIN_MASK) >> TIA_SHIFT;
+	rx_gain->lmt_gain = lna_table[lna_index] +
+				mixer_table[mixer_index] +
+				tia_table[tia_index];
+	ad_phy_write(ad_phy, REG_GAIN_TBL_ADDR, tbl_addr);
+
+	/* Read LPF Index */
+	ad_phy_read(ad_phy, idx_reg + 1, 1, &val);
+	rx_gain->lpf_gain = val & LPF_IDX_MASK;
+
+	/* Read Digital Gain */
+	rc = ad_phy_read(ad_phy, idx_reg + 2, 1, &val);
+	rx_gain->digital_gain = val & DIGITAL_IDX_MASK;
+
+	rx_gain->gain_db = rx_gain->lmt_gain + rx_gain->lpf_gain +
+				rx_gain->digital_gain;
+	return rc;
+}
+
+static int get_full_table_gain(struct rf_phy_dev *ad_phy, u32 idx_reg,
+		struct rf_rx_gain *rx_gain)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	u32 val;
+	enum rx_gain_table_name tbl;
+	struct rx_gain_info *gain_info;
+	int rc = 0, rx_gain_db;
+
+	if (ad_phy->ul_carrier_freq > 1300000)
+		tbl = FULL_TBL_1300_4000_MHZ;
+	else
+		tbl = FULL_TBL_200_1300_MHZ;
+
+	rc = ad_phy_read(ad_phy, idx_reg, 1, &val);
+	if (rc) {
+		dev_err(dev, "Unable to read gain tbl idx reg: %d\n", idx_reg);
+		goto out;
+	}
+
+	val = val & FULL_TBL_IDX_MASK;
+	gain_info = &phy_info->rx_gain[tbl];
+	if (val > gain_info->idx_step_offset) {
+		val = val - gain_info->idx_step_offset;
+		rx_gain_db = gain_info->starting_gain_db +
+			((val) * gain_info->gain_step_db);
+	} else {
+		rx_gain_db = gain_info->starting_gain_db;
+	}
+
+	rx_gain->gain_db = rx_gain_db;
+out:
+	return rc;
+}
+static int ad_get_rx_gain(struct rf_phy_dev *ad_phy,
+		struct rf_rx_gain *rx_gain)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	u32 val, idx_reg;
+	u8 gain_ctl_shift, rx_enable_mask;
+	u8 fast_atk_shift;
+	int rc = 0;
+
+	if (rx_gain->ant == 1) {
+		gain_ctl_shift = RX1_GAIN_CTL_SHIFT;
+		idx_reg = REG_RX1_FULL_TBL_IDX;
+		rx_enable_mask = RX1_EN;
+		fast_atk_shift = RX1_FAST_ATK_SHIFT;
+
+	} else if (rx_gain->ant == 2) {
+		gain_ctl_shift = RX2_GAIN_CTL_SHIFT;
+		idx_reg = REG_RX2_FULL_TBL_IDX;
+		rx_enable_mask = RX2_EN;
+		fast_atk_shift = RX2_FAST_ATK_SHIFT;
+	} else {
+		dev_err(dev, "Unknown Rx path %d\n", rx_gain->ant);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = ad_phy_read(ad_phy, REG_RXEN_N_FILTER_CTRL, 1, &val);
+	if (rc) {
+		dev_err(dev, "Unable to read REG_RXEN_N_FILTER_CTRL\n");
+		goto out;
+	}
+
+	if (!(val & rx_enable_mask)) {
+		dev_err(dev, "Rx%d is not enabled\n", rx_gain->ant);
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	rc = ad_phy_read(ad_phy, REG_AGC_CONF1, 1, &val);
+	if (rc) {
+		dev_err(dev, "Unable to read AGC_CONF1\n");
+		goto out;
+	}
+
+	val = (val >> gain_ctl_shift) & RX_GAIN_CTL_MASK;
+
+	if (val == RX_GAIN_CTL_AGC_FAST_ATK) {
+		/* In fast attack mode check whether Fast attack state machine
+		 * has locked gain, if not then we can not read gain.
+		 */
+		rc = ad_phy_read(ad_phy, REG_FAST_ATK_STATE, 1, &val);
+		if (rc) {
+			dev_err(dev, "Unable to read REG_FAST_ATK_STATE\n");
+			goto out;
+		}
+
+		val = (val >> fast_atk_shift) & FAST_ATK_MASK;
+		if (val != FAST_ATK_GAIN_LOCKED) {
+			dev_err(dev, "Failed to read gain, state m/c at %x\n",
+				val);
+			rc = -EAGAIN;
+			goto out;
+		}
+	}
+
+	rc = ad_phy_read(ad_phy, REG_AGC_CONF2, 1, &val);
+	if (rc) {
+		dev_err(dev, "Unable to read AGC_CONF2\n");
+		goto out;
+	}
+
+	if (val & FULL_GAIN_TBL)
+		rc = get_full_table_gain(ad_phy, idx_reg, rx_gain);
+	else
+		rc = get_split_table_gain(ad_phy, idx_reg, rx_gain);
+
+out:
+	return rc;
+}
+
+static void ad_ensm_force_state(struct rf_phy_dev *ad_phy, u8 ensm_state)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	u8 dev_ensm_state;
+	int rc;
+	u32 val;
+
+	rc = ad_phy_read(ad_phy, REG_DEV_STATE, 1, &val);
+	if (rc)
+		goto out;
+
+	dev_ensm_state = (val & ENSM_STATE_MASK) >> ENSM_STATE_SHIFT;
+
+	if (dev_ensm_state == ensm_state) {
+		dev_info(dev, "Nothing to do, device is already in %d state\n",
+			ensm_state);
+		goto out;
+	}
+
+	phy_info->prev_ensm_state = dev_ensm_state;
+	dev_info(dev, "Device is in %x state, forcing to %x\n", dev_ensm_state,
+			ensm_state);
+
+	rc = ad_phy_read(ad_phy, REG_ENSM_CONF1, 1, &val);
+	if (rc)
+		goto out;
+
+	/* Enable control through SPI writes, and take out from
+	 * Alert
+	 */
+	if (val & ENSM_CONF1_ENSM_PIN_CTL_EN) {
+		val &= ~ENSM_CONF1_ENSM_PIN_CTL_EN;
+		phy_info->ensm_pin_ctl_en = 1;
+	} else {
+		phy_info->ensm_pin_ctl_en = 0;
+	}
+
+	if (dev_ensm_state & dev_ensm_state)
+		val &= ~(ENSM_CONF1_TO_ALERT);
+
+	switch (ensm_state) {
+
+	case ENSM_STATE_TX:
+		val |= ENSM_CONF1_FORCE_TX_ON;
+		break;
+	case ENSM_STATE_RX:
+		val |= ENSM_CONF1_FORCE_RX_ON;
+		break;
+	case ENSM_STATE_FDD:
+		val |= (ENSM_CONF1_FORCE_TX_ON | ENSM_CONF1_FORCE_RX_ON);
+		break;
+	default:
+		dev_err(dev, "No handleing for forcing %d ensm state\n",
+		ensm_state);
+		goto out;
+	}
+
+	rc = ad_phy_write(ad_phy, REG_ENSM_CONF1, val);
+	if (rc)
+		dev_err(dev, "Failed to restore state\n");
+
+out:
+	return;
+
+}
+
+static void ad_ensm_restore_prev_state(struct rf_phy_dev *ad_phy)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int rc;
+	u32 val;
+
+	rc = ad_phy_read(ad_phy, REG_ENSM_CONF1, 1, &val);
+	if (rc) {
+		dev_err(dev, "Read REG_ENSM_CONF1 Failed, restore failed\n");
+		goto out;
+	}
+
+	/* We are restoring state only, so clear State bits first
+	 * which might have set while forcing a particular state
+	 */
+	val &= ~(ENSM_CONF1_FORCE_TX_ON | ENSM_CONF1_FORCE_RX_ON |
+			ENSM_CONF1_TO_ALERT);
+
+	switch (phy_info->prev_ensm_state) {
+
+	case ENSM_STATE_TX:
+		val |= ENSM_CONF1_FORCE_TX_ON;
+		break;
+	case ENSM_STATE_RX:
+		val |= ENSM_CONF1_FORCE_RX_ON;
+		break;
+	case ENSM_STATE_FDD:
+		val |= (ENSM_CONF1_FORCE_TX_ON | ENSM_CONF1_FORCE_RX_ON);
+		break;
+	case ENSM_STATE_ALERT:
+		val |= ENSM_CONF1_TO_ALERT;
+		break;
+	case ENSM_STATE_INVALID:
+		dev_dbg(dev, "No need to restore, ENSM state wasn't saved\n");
+		goto out;
+	default:
+		dev_dbg(dev, "Could not restore to %d ENSM state\n",
+		phy_info->prev_ensm_state);
+		goto out;
+	}
+
+	rc = ad_phy_write(ad_phy, REG_ENSM_CONF1, val);
+	if (rc) {
+		dev_err(dev, "Failed to write REG_ENSM_CONF1");
+		goto out;
+	}
+
+	if (phy_info->ensm_pin_ctl_en) {
+		val |= ENSM_CONF1_ENSM_PIN_CTL_EN;
+		rc = ad_phy_write(ad_phy, REG_ENSM_CONF1, val);
+		if (rc)
+			dev_err(dev, "Failed to write REG_ENSM_CONF1");
+	}
+
+out:
+	return;
+}
+
+static int set_split_table_gain(struct rf_phy_dev *ad_phy, u32 idx_reg,
+		struct rf_rx_gain *rx_gain)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	u32 val;
+	int rc = 0;
+
+	if ((rx_gain->lmt_index > MAX_LMT_INDEX) ||
+			(rx_gain->lpf_gain > MAX_LPF_GAIN) ||
+			(rx_gain->digital_gain > MAX_DIG_GAIN)) {
+		dev_err(dev, "LMT_INDEX missing or greater than max value %d",
+				MAX_LMT_INDEX);
+		dev_err(dev, "LPF_GAIN missing or greater than max value %d",
+				MAX_LPF_GAIN);
+		dev_err(dev, "DIGITAL_GAIN cannot be more than %d",
+				MAX_DIG_GAIN);
+		rc = -EINVAL;
+		goto out;
+	}
+	if (rx_gain->gain_db > 0)
+		dev_info(dev, "Ignoring rx_gain value in split table mode.");
+	if (rx_gain->lmt_index == 0 && rx_gain->lpf_gain == 0 &&
+			rx_gain->digital_gain == 0) {
+		dev_err(dev,
+		"In split table mode, All LMT/LPF/digital gains cannot be 0");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	ad_phy_read(ad_phy, idx_reg, 1, &val);
+	val = val & ~FULL_TBL_IDX_MASK;
+	val |= rx_gain->lmt_index;
+	ad_phy_write(ad_phy, idx_reg, val);
+
+	ad_phy_read(ad_phy, idx_reg + 1, 1, &val);
+	val = val & ~LPF_IDX_MASK;
+	val |= rx_gain->lpf_gain;
+	ad_phy_write(ad_phy, idx_reg + 1, val);
+
+	ad_phy_read(ad_phy, REG_AGC_CONF2, 1, &val);
+	if (val & DIGITAL_GAIN_EN) {
+		ad_phy_read(ad_phy, idx_reg + 2, 1, &val);
+		val = val & ~DIGITAL_IDX_MASK;
+		val |= rx_gain->digital_gain;
+		ad_phy_write(ad_phy, idx_reg + 2, val);
+	} else if (rx_gain->digital_gain > 0) {
+		dev_err(dev, "Digital gain is disabled and cannot be set");
+	}
+out:
+	return rc;
+}
+
+static int set_full_table_gain(struct rf_phy_dev *ad_phy, u32 idx_reg,
+		struct rf_rx_gain *rx_gain)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	enum rx_gain_table_name tbl;
+	struct rx_gain_info *gain_info;
+	u32 val;
+	int rc = 0;
+
+	if (rx_gain->lmt_index != ~0 || rx_gain->lpf_gain != ~0 ||
+			rx_gain->digital_gain > 0)
+		dev_info(dev,
+			"Ignoring lmt/lpf/digital gains in Single Table mode");
+
+	if (ad_phy->ul_carrier_freq > 1300000)
+		tbl = FULL_TBL_1300_4000_MHZ;
+	else
+		tbl = FULL_TBL_200_1300_MHZ;
+
+	gain_info = &phy_info->rx_gain[tbl];
+	if ((rx_gain->gain_db < gain_info->starting_gain_db) ||
+		(rx_gain->gain_db > gain_info->max_gain_db)) {
+
+		dev_err(dev, "Invalid gain %d, supported range [%d - %d]\n",
+			rx_gain->gain_db, gain_info->starting_gain_db,
+			gain_info->max_gain_db);
+		rc = -EINVAL;
+		goto out;
+
+	}
+	rc = ad_phy_read(ad_phy, idx_reg, 1, &val);
+	if (rc) {
+		dev_err(dev, "Unable to read gain tbl idx reg: %d\n", idx_reg);
+		goto out;
+	}
+
+	val = val & ~FULL_TBL_IDX_MASK;
+	val |= ((rx_gain->gain_db - gain_info->starting_gain_db) /
+		gain_info->gain_step_db) + gain_info->idx_step_offset;
+	rc = ad_phy_write(ad_phy, idx_reg, val);
+out:
+	return rc;
+}
+
+static int ad_set_rx_gain(struct rf_phy_dev *ad_phy,
+		struct rf_rx_gain *rx_gain)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	u32 val, idx_reg;
+	u8 gain_ctl_shift, ensm_state;
+	int rc = 0;
+
+	if (rx_gain->ant == 1) {
+		gain_ctl_shift = RX1_GAIN_CTL_SHIFT;
+		idx_reg = REG_RX1_MGC_FULL_TBL_IDX;
+
+	} else if (rx_gain->ant == 2) {
+		gain_ctl_shift = RX2_GAIN_CTL_SHIFT;
+		idx_reg = REG_RX2_MGC_FULL_TBL_IDX;
+	} else {
+		dev_err(dev, "Unknown Rx path %d\n", rx_gain->ant);
+		rc = -EINVAL;
+		goto out;
+
+	}
+
+	rc = ad_phy_read(ad_phy, REG_AGC_CONF1, 1, &val);
+	if (rc) {
+		dev_err(dev, "Unable to read REG_AGC_CONF1\n");
+		goto out;
+	}
+
+	val = (val >> gain_ctl_shift) & RX_GAIN_CTL_MASK;
+
+	if (val != RX_GAIN_CTL_MGC) {
+		dev_err(dev, "Rx gain can be set in MGC mode only\n");
+		goto out;
+	}
+
+	if (phy_info->net_mode == LTE_FDD)
+		ensm_state = ENSM_STATE_FDD;
+	else
+		ensm_state = ENSM_STATE_RX;
+
+	/* RX must be enabled while changing Gain */
+	ad_ensm_force_state(ad_phy, ensm_state);
+
+	ad_phy_read(ad_phy, REG_AGC_CONF2, 1, &val);
+	if (val & FULL_GAIN_TBL)
+		rc = set_full_table_gain(ad_phy, idx_reg, rx_gain);
+	else
+		rc = set_split_table_gain(ad_phy, idx_reg, rx_gain);
+
+	/* Restore is done intentionally before checking rc, because
+	 * we need to restore PHY to previous state even if write failed
+	 */
+	ad_ensm_restore_prev_state(ad_phy);
+
+	if (rc) {
+		dev_err(dev, "Unable to write gain tbl idx reg: %d\n", idx_reg);
+		goto out;
+	}
+
+out:
+	return rc;
+
+}
+
+void ad_init_gain_info(struct rx_gain_info *rx_gain,
+	enum rx_gain_table_type type, int starting_gain,
+	int max_gain, int gain_step, int max_idx, int idx_offset)
+{
+	rx_gain->tbl_type = type;
+	rx_gain->starting_gain_db = starting_gain;
+	rx_gain->max_gain_db = max_gain;
+	rx_gain->gain_step_db = gain_step;
+	rx_gain->max_idx = max_idx;
+	rx_gain->idx_step_offset = idx_offset;
+}
+
+int ad_init_gain_tables(struct rf_phy_dev *ad_phy)
+{
+	struct rx_gain_info *rx_gain;
+	struct ad_dev_info *phy_info = ad_phy->priv;
+
+	/* Intialize Meta data according to default gain tables
+	 * of AD9631. Changing/Writing of gain tables is not
+	 * supported yet.
+	 */
+	rx_gain = &phy_info->rx_gain[FULL_TBL_200_1300_MHZ];
+	ad_init_gain_info(rx_gain, RXGAIN_FULL_TBL, 1, 77, 1,
+		RXGAIN_FULL_TBL_MAX_IDX, 0);
+
+	rx_gain = &phy_info->rx_gain[FULL_TBL_1300_4000_MHZ];
+	ad_init_gain_info(rx_gain, RXGAIN_FULL_TBL, -4, 71, 1,
+		RXGAIN_FULL_TBL_MAX_IDX, 1);
+
+	rx_gain = &phy_info->rx_gain[FULL_TBL_4000_6000_MHZ];
+	ad_init_gain_info(rx_gain, RXGAIN_FULL_TBL, -10, 62, 1,
+		RXGAIN_FULL_TBL_MAX_IDX, 4);
+
+	return 0;
+}
+
+int ad_config_master_slave(unsigned int lane_id, struct rf_phy_dev *ad_phy,
+			enum rf_lane_mode mode)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int rc = 0;
+	u32 val;
+
+	switch (mode) {
+	case RF_LANE_MASTER:
+		/* AD9361(RF Card) can act as Master clock/Slave clock source,
+		 * i.e it can either generate 19.2MHz or it can be configured
+		 * to receive 19.2MHz from other RF card. By default RF cards
+		 * comes up in Master mode
+		 *
+		 * By default in 9132, RF1 connector is used as the clock
+		 * source of 19.2MHz for AIC block.But when RF1 is not used
+		 * and RF card is inserted on RF2 conector, then RF2 should be
+		 * configured to act as clock source for 19.2MHz, that's why we
+		 * are specifically checking for LANE_TWO to configure it in
+		 * Master mode.
+		 *
+		 * In 9131, by default LANE3 is configured to act as the clock
+		 * source of 19.2MHz, so the below check is not valid for 9131
+		 */
+		if (lane_id == LANE_TWO) {
+			/* FIXME: for 9132 FPGA is used to select clock source
+			 * This shall be revisited after implementing FPGA
+			 * driver */
+			dev_err(dev, "Not implemented for 9132");
+			rc = -ENOSYS;
+		}
+		break;
+	case RF_LANE_SLAVE:
+		rc = ad_phy_read(ad_phy, REG_GPO_FORCE_INIT, 1, &val);
+		val |= GPO3_MANUAL_CONTROL;
+		ad_phy_write(ad_phy, REG_GPO_FORCE_INIT, val);
+		break;
+	default:
+		rc = -EINVAL;
+		goto out;
+	}
+
+out:
+	return rc;
+}
+
+int ad_set_gain_ctrl_mode(struct rf_phy_dev *ad_phy,
+		struct rf_gain_ctrl *gain_ctrl)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int rc = 0;
+	u32 val, gain_ctl_shift, mode;
+
+	rc = ad_phy_read(ad_phy, REG_AGC_CONF1, 1, &val);
+	if (rc) {
+		dev_err(dev, "Unable to read AGC config1 register: %x\n",
+				REG_AGC_CONF1);
+		goto out;
+	}
+
+	switch (gain_ctrl->mode) {
+	case RF_GAIN_MGC:
+		mode = RX_GAIN_CTL_MGC;
+		break;
+	case RF_GAIN_FASTATTACK_AGC:
+		mode = RX_GAIN_CTL_AGC_FAST_ATK;
+		break;
+	case RF_GAIN_SLOWATTACK_AGC:
+		mode = RX_GAIN_CTL_AGC_SLOW_ATK;
+		break;
+	case RF_GAIN_HYBRID_AGC:
+		mode = RX_GAIN_CTL_AGC_SLOW_ATK_HYBD;
+		break;
+	default:
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (gain_ctrl->ant == 1) {
+		gain_ctl_shift = RX1_GAIN_CTL_SHIFT;
+	} else if (gain_ctrl->ant == 2) {
+		gain_ctl_shift = RX2_GAIN_CTL_SHIFT;
+	} else {
+		dev_err(dev, "Unknown Rx path %d\n", gain_ctrl->ant);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = ad_en_dis_rx(ad_phy, gain_ctrl->ant, RX_DISABLE);
+	if (rc) {
+		dev_err(dev, "Unable to disable rx%d\n", gain_ctrl->ant);
+		goto out;
+	}
+
+	val &= ~(RX_GAIN_CTL_MASK << gain_ctl_shift);
+	val |= mode << gain_ctl_shift;
+	if (mode == RX_GAIN_CTL_AGC_SLOW_ATK_HYBD)
+		val |= SLOW_ATK_HYBD_BIT_EN;
+	else
+		val &= ~SLOW_ATK_HYBD_BIT_EN;
+	rc = ad_phy_write(ad_phy, REG_AGC_CONF1, val);
+	if (rc) {
+		dev_err(dev, "Unable to write AGC config1 register: %x\n",
+				REG_AGC_CONF1);
+		goto out;
+	}
+
+	rc = ad_en_dis_rx(ad_phy, gain_ctrl->ant, RX_ENABLE);
+out:
+	return rc;
+}
+
+int ad_program_synthesizer(struct rf_phy_dev *ad_phy,
+			unsigned long carrier_freq,
+			enum rf_synthesizer rf_synth)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int ret = 0, i = 1;
+	unsigned int block_scalar, vco_divider_shift, reg_offset;
+	unsigned long f_rfpll, f_ref, n_int, n_frac;
+	unsigned long freq = MAX_CARRIER_FREQ_KHZ;
+	unsigned long long f_rfpll_hz;
+	u8 divider_mask, vco_divider = i - 1;
+	u32 val[2], temp;
+
+	if (carrier_freq > MAX_CARRIER_FREQ_KHZ ||
+			carrier_freq < MIN_CARRIER_FREQ_KHZ) {
+		dev_err(dev, "Invalid carrier freq %lu KHz\n",
+			carrier_freq);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * RFPLL works in freq range of 6-12 Ghz, So to convert carrier freq
+	 * in this range vco divider is programmed accordingly.
+	 */
+	while (freq > MIN_CARRIER_FREQ_KHZ) {
+		if (carrier_freq > (freq >> 1)) {
+			vco_divider = (u8) i - 1;
+			break;
+		} else {
+			freq = freq >> 1;
+			i++;
+		}
+	}
+
+	/*
+	 * To get the f_rfpll from carrier freq and appropriate vco divider:
+	 * f_rfpll = carrier_freq * (2^(vco_divider + 1))
+	 */
+	f_rfpll = carrier_freq << (vco_divider + 1);
+
+	ad_phy_read(ad_phy, REG_REF_DIVIDE_CONFIG1, 2, val);
+	if (rf_synth == RF_RX) {
+		/* For RX synthesizer block scalar is represented by
+		 * REG_REF_DIVIDE_CONFIG1[D0] and REG_REF_DIVIDE_CONFIG2[D7] */
+		block_scalar = ((val[0] & RX_SCALER_MASK1) << 1) +
+				((val[1] & RX_SCALER_MASK2) >> 7);
+		reg_offset = RX_REG_OFFSET;
+		/* For RX synthesizer, VCO divider is programmed in
+		 * REG_RFPLL_DIVIDER[D3:D0] */
+		vco_divider_shift = 0;
+		divider_mask = 0xF0;
+	} else if (rf_synth == RF_TX) {
+		/* For TX synthesizer block scalar is represented by
+		 * REG_REF_DIVIDE_CONFIG2[D3:D2] */
+		block_scalar = (val[1] & TX_SCALER_MASK) >> 2;
+		reg_offset = TX_REG_OFFSET;
+		/* For TX synthesizer, VCO divider is programmed in
+		 * REG_RFPLL_DIVIDER[D7:D4] */
+		vco_divider_shift = 4;
+		divider_mask = 0x0F;
+	} else {
+		dev_err(dev, "RF_BBPLL synth programming not supported\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	switch (block_scalar) {
+	case 0:
+		f_ref = DEVICE_REF_FREQ_KHZ;
+		break;
+	case 1:
+		f_ref = DEVICE_REF_FREQ_KHZ / 2;
+		break;
+	case 2:
+		f_ref = DEVICE_REF_FREQ_KHZ / 4;
+		break;
+	case 3:
+		f_ref = DEVICE_REF_FREQ_KHZ * 2;
+		break;
+	default:
+		f_ref = DEVICE_REF_FREQ_KHZ * 2;
+	}
+
+	f_rfpll_hz = (unsigned long long)f_rfpll * 1000;
+	i = 0;
+	while (i < phy_info->synth_table.count &&
+		(phy_info->synth_table.params[i][VCO_Frequency] > f_rfpll_hz))
+		i++;
+
+	/* n_int = floor(f_rfpll / f_ref) */
+	n_int = f_rfpll / f_ref;
+
+	/* Divide f_rfpll and f_ref by 100 to avoid 64 bit operations */
+	f_rfpll /= 100;
+	f_ref /= 100;
+
+	/*
+	 * n_frac = Round(8388593 * ((f_rfpll/f_ref - n_int)))
+	 * 8388593 is a constant for RX and TX synthesizer
+	 * and it is denoted as rfpll modulus
+	 */
+	n_frac = (RFPLL_MODULUS * (f_rfpll - (n_int * f_ref)) +
+			(f_ref / 2)) / f_ref;
+
+	/* Program various registers according to the synthesizer look up
+	 * table and f_rfpll(vco frequency) */
+
+	ad_phy_read(ad_phy, REG_VCO_OUTPUT + reg_offset, 1, &temp);
+	temp = (temp & MASK_VCO_OUTPUT) |
+		phy_info->synth_table.reg_vals[i][VCO_Output_Level];
+	ad_phy_write(ad_phy, REG_VCO_OUTPUT + reg_offset, temp);
+
+	ad_phy_read(ad_phy, REG_VCO_VARACTOR + reg_offset, 1, &temp);
+	temp = (temp & MASK_VCO_VARACTOR) |
+		phy_info->synth_table.reg_vals[i][VCO_Varactor];
+	ad_phy_write(ad_phy, REG_VCO_VARACTOR + reg_offset, temp);
+
+	ad_phy_read(ad_phy, REG_VCO_BIAS1 + reg_offset, 1, &temp);
+	temp = (temp & MASK_VCO_BIAS1) |
+		phy_info->synth_table.reg_vals[i][VCO_Bias_Ref];
+	temp |= (phy_info->synth_table.reg_vals[i][VCO_Bias_Tcf] <<
+		SHIFT_VCO_BIAS_TCF);
+	ad_phy_write(ad_phy, REG_VCO_BIAS1 + reg_offset, temp);
+
+	ad_phy_read(ad_phy, REG_FORCE_VCO_TUNE1 + reg_offset, 1, &temp);
+	temp = (temp & MASK_FORCE_VCO_TUNE1) |
+		(phy_info->synth_table.reg_vals[i][VCO_Cal_Offset] <<
+		SHIFT_VCO_CAL_OFFSET);
+	ad_phy_write(ad_phy, REG_FORCE_VCO_TUNE1 + reg_offset, temp);
+
+	ad_phy_read(ad_phy, REG_VCO_VARACTOR_CONTROL1 + reg_offset, 1, &temp);
+	temp = (temp & MASK_VCO_VARACTOR_CONTROL1) |
+		phy_info->synth_table.reg_vals[i][VCO_Varactor_Reference];
+	ad_phy_write(ad_phy, REG_VCO_VARACTOR_CONTROL1 + reg_offset, temp);
+
+	ad_phy_read(ad_phy, REG_CP_CURRENT + reg_offset, 1, &temp);
+	temp = (temp & MASK_CP_CURRENT) |
+		phy_info->synth_table.reg_vals[i][Charge_Pump_Current];
+	ad_phy_write(ad_phy, REG_CP_CURRENT + reg_offset, temp);
+
+	temp =  (phy_info->synth_table.reg_vals[i][Loop_Filter_C2] <<
+			SHIFT_LOOP_FILTER_C2);
+	temp |= phy_info->synth_table.reg_vals[i][Loop_Filter_C1];
+	ad_phy_write(ad_phy, REG_LOOP_FILTER1 + reg_offset, temp);
+
+	temp =  (phy_info->synth_table.reg_vals[i][Loop_Filter_R1] <<
+			SHIFT_LOOP_FILTER_R1);
+	temp |= phy_info->synth_table.reg_vals[i][Loop_Filter_C3];
+	ad_phy_write(ad_phy, REG_LOOP_FILTER2 + reg_offset, temp);
+
+	ad_phy_read(ad_phy, REG_LOOP_FILTER3 + reg_offset, 1, &temp);
+	temp = (temp & MASK_LOOP_FILTER3) |
+		phy_info->synth_table.reg_vals[i][Loop_Filter_R3];
+	ad_phy_write(ad_phy, REG_LOOP_FILTER3 + reg_offset, temp);
+
+	temp = (n_frac & MASK_FRAC_B0) >> SHIFT_FRAC_B0;
+	ad_phy_write(ad_phy, REG_FRACTIONAL_BYTE0 + reg_offset, temp);
+	temp = (n_frac & MASK_FRAC_B1) >> SHIFT_FRAC_B1;
+	ad_phy_write(ad_phy, REG_FRACTIONAL_BYTE1 + reg_offset, temp);
+	temp = (n_frac & MASK_FRAC_B2) >> SHIFT_FRAC_B2;
+	ad_phy_write(ad_phy, REG_FRACTIONAL_BYTE2 + reg_offset, temp);
+
+	/* n_integer is programmed in the last so that calibration is
+	 * triggered*/
+	ad_phy_read(ad_phy, REG_INTEGER_BYTE1 + reg_offset, 1, &temp);
+	temp = (temp & MASK_INTEGER_REG1) |
+		((n_int & MASK_INT_B1) >> SHIFT_INT_B1);
+	ad_phy_write(ad_phy, REG_INTEGER_BYTE1 + reg_offset, temp);
+
+	temp = (n_int & MASK_INT_B0);
+	ad_phy_write(ad_phy, REG_INTEGER_BYTE0 + reg_offset, temp);
+
+	ad_phy_read(ad_phy, REG_RFPLL_DIVIDER, 1, &temp);
+	temp = (temp & divider_mask) | (vco_divider << vco_divider_shift);
+	ad_phy_write(ad_phy, REG_RFPLL_DIVIDER, temp);
+
+out:
+	return ret;
+}
+
+int ad_config_sniff(struct rf_phy_dev *ad_phy,
+	struct rf_sniff_params *sniff_params)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	struct rf_init_params *dev_params = &sniff_params->dev_params;
+	int ret = 0;
+	int i, j, band_found = 0;
+
+	if (phy_info->config_mode == GPIO_MODE ||
+		phy_info->config_mode == INVALID_MODE) {
+		if (phy_info->pa_en_gpio == GPIO_INVAL ||
+				phy_info->lna_en_gpio == GPIO_INVAL) {
+			dev_info(dev, "Control GPIOs not intialized in dtb\n");
+			goto skip;
+		}
+	}
+
+	for (i = 0; i < MAX_GPIO_CONFIGS; i++) {
+		for (j = 0; j < phy_info->band_grp_sniff_size[i]; j++) {
+			if (phy_info->band_grp_sniff[i][j] ==
+					dev_params->fq_band) {
+				band_found = 1;
+				break;
+			}
+		}
+		if (band_found)
+			break;
+	}
+	if (band_found) {
+		if (phy_info->config_mode == FPGA_MODE) {
+			dev_err(dev, "FPGA mode not implemented\n");
+			ret = -ENOSYS;
+		} else {
+			gpio_set_value(phy_info->pa_en_gpio,
+					phy_info->band_grp_cfg[i][0]);
+			gpio_set_value(phy_info->lna_en_gpio,
+					phy_info->band_grp_cfg[i][1]);
+		}
+	} else {
+		dev_err(dev, "band %d not found in band_group_sniff\n",
+				dev_params->fq_band);
+		ret = -EINVAL;
+		goto out;
+	}
+skip:
+	phy_info->freq_band = dev_params->fq_band;
+	phy_info->net_mode = dev_params->mode;
+	ret = ad_program_synthesizer(ad_phy, sniff_params->carrier_freq,
+					RF_RX);
+out:
+	return ret;
+}
+
+static int ad_set_band(struct rf_phy_dev *ad_phy, unsigned int band)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int i, j, rc = 0;
+	int band_found = 0;
+
+	if (phy_info->config_mode == GPIO_MODE ||
+		phy_info->config_mode == INVALID_MODE) {
+		if (phy_info->pa_en_gpio == GPIO_INVAL ||
+				phy_info->lna_en_gpio == GPIO_INVAL) {
+			dev_info(dev, "Control GPIOs not intialized in dtb\n");
+			goto skip;
+		}
+	}
+
+	for (i = 0; i < MAX_GPIO_CONFIGS; i++) {
+		for (j = 0; j < phy_info->band_grp_size[i]; j++) {
+			if (phy_info->band_grp[i][j] == band) {
+				band_found = 1;
+				break;
+			}
+		}
+		if (band_found)
+			break;
+	}
+
+	if (band_found) {
+		if (phy_info->config_mode == FPGA_MODE) {
+			dev_err(dev, "FPGA mode not implemented\n");
+			rc = -ENOSYS;
+		} else {
+			gpio_set_value(phy_info->pa_en_gpio,
+					phy_info->band_grp_cfg[i][0]);
+			gpio_set_value(phy_info->lna_en_gpio,
+					phy_info->band_grp_cfg[i][1]);
+		}
+	} else {
+		dev_err(dev, "band %d not found in band_groups\n", band);
+		rc = -EINVAL;
+		goto out;
+	}
+skip:
+	phy_info->freq_band = band;
+
+out:
+	return rc;
+}
+
+int ad_init(struct rf_phy_dev *ad_phy,
+		struct rf_init_params *params)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	int rc = 0;
+	u32 default_rssi_delay[4] = {RSSI_DELAY_5MHZ,
+					RSSI_DELAY_10MHZ,
+					RSSI_DELAY_15MHZ,
+					RSSI_DELAY_20MHZ};
+
+	rc = ad_set_band(ad_phy, params->fq_band);
+	if (rc) {
+		dev_err(dev, "Failed to set band %d\n", rc);
+		goto out;
+	}
+
+	rc = ad_program_synthesizer(ad_phy, params->ul_freq_khz,
+					RF_RX);
+	if (rc)
+		goto out;
+
+	rc = ad_program_synthesizer(ad_phy, params->dl_freq_khz,
+					RF_TX);
+	if (rc)
+		goto out;
+	ad_phy->ul_carrier_freq = params->ul_freq_khz;
+	ad_phy->dl_carrier_freq = params->dl_freq_khz;
+
+	rc = ad_phy_write(ad_phy, RSSI_DELAY_REG,
+			default_rssi_delay[params->bw]);
+	if (rc) {
+		dev_err(dev, "Unable to write rssi_delay reg: %d\n",
+				RSSI_DELAY_REG);
+		goto out;
+	}
+
+	phy_info->net_mode = params->mode;
+	phy_info->prev_ensm_state = ENSM_STATE_INVALID;
+
+out:
+	return rc;
+}
+
+int ad_phy_stop(struct rf_phy_dev *ad_phy)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+
+	ad_en_dis_tx(ad_phy, 1, TX_DISABLE);
+	ad_en_dis_tx(ad_phy, 2, TX_DISABLE);
+	ad_en_dis_rx(ad_phy, 1, RX_DISABLE);
+	ad_en_dis_rx(ad_phy, 2, RX_DISABLE);
+
+	ad_phy_write(ad_phy, REG_CALIBRATION_CONFIG1,
+			VAL_CAL_CONF1_TRACKOFF);
+
+	kfree(phy_info->synth_table.params);
+	kfree(phy_info->synth_table.reg_vals);
+	phy_info->synth_table.params = NULL;
+	phy_info->synth_table.reg_vals = NULL;
+
+	return 0;
+}
+
+int ad_phy_start(struct rf_phy_dev *ad_phy)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+
+	dev_dbg(dev, "Reading BBPLL locked status.\n");
+
+	if (check_cal_done(ad_phy, REG_CH1_OVERFLOW,
+			MASK_BBPLL_LOCK, 1))
+		return 0;
+	else {
+		dev_err(dev, "BBPLL not locked.\n");
+		return -EBUSY;
+	}
+}
+
+int ad_phy_read(struct rf_phy_dev *ad_phy, u32 start,
+		u32 count, u32 *buff)
+{
+	u32 data;
+	u16 rx_cmd, read_addr;
+	int i = 0, j = 0, rc;
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+
+	/* RFdev f/w provides start address as u32, but
+	 * ADI has only 12 bits regs, so downsize it to 16 bits
+	 */
+	read_addr =  (u16)(start + count - 1);
+	j = count - 1;
+
+	while (count > MAX_READ_TRANSACTION_SIZE) {
+		rx_cmd = create_ad_phy_cmd(read_addr, SPI_READ,
+			MAX_READ_TRANSACTION_SIZE);
+
+		rc = spi_read_transaction(ad_phy, (u8 *)&rx_cmd,
+				RXBUF_SIZE);
+		if (rc)
+			goto out;
+
+		for (i = 0; i < RXBUF_SIZE ; i++) {
+			data = phy_info->rx_buf[i];
+			buff[j--] = data;
+		}
+
+		count -= MAX_READ_TRANSACTION_SIZE;
+		read_addr = read_addr - MAX_READ_TRANSACTION_SIZE;
+	}
+
+	rx_cmd = create_ad_phy_cmd(read_addr, SPI_READ, count);
+
+	rc = spi_read_transaction(ad_phy, (u8 *)&rx_cmd,
+			(COMMAND_LEN + count - 1));
+	if (rc)
+		goto out;
+
+	for (i = 0; i < count; i++) {
+		data = phy_info->rx_buf[i];
+		buff[j--] = data;
+	}
+
+out:
+	dev_dbg(dev, "Failed to read %d regs, start addr %x\n",
+		count, start);
+	return rc;
+}
+
+int ad_phy_write(struct rf_phy_dev *ad_phy, u32 reg,
+		u32 data)
+{
+	int rc;
+	u32 cmd = 0;
+	u16 ad_reg;
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+
+	dev_dbg(dev, "AD's register write call.\n");
+	/* Rfdev f/w sends reg as 32 bit address, but ADI has
+	 * only 12 bit register addresses, thus downsize to
+	 * u16
+	 */
+	ad_reg = (u16) reg;
+	cmd = create_ad_phy_cmd(ad_reg, SPI_WRITE, 1);
+	cmd = (cmd << 16) & COMMAND_MASK;
+	cmd = cmd | (data << 8);
+	rc = spi_write_transaction(ad_phy, (u8 *)&cmd, TRANSACTION_BYTES);
+
+	return rc;
+}
+
+int ad_phy_get_dac_value(struct rf_phy_dev *ad_phy,
+			u32 correction_type , u32 *buff)
+{
+	u32 reg = 0;
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+
+	dev_dbg(dev, "DAC's register read call.\n");
+	switch (correction_type) {
+	case COARSE_CORRECTION:
+		reg = DAC1_CONFIG;
+		break;
+	case FINE_CORRECTION:
+		reg = DAC1_WORD;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ad_phy_read(ad_phy, reg, 1, buff);
+}
+
+int ad_phy_dac_correction(struct rf_phy_dev *ad_phy,
+			struct rif_dac_params *dac_params)
+{
+	u32 reg = 0;
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+
+	dev_dbg(dev, "DAC's register write call.\n");
+	switch (dac_params->correction_type) {
+	case COARSE_CORRECTION:
+		reg = DAC1_CONFIG;
+		break;
+	case FINE_CORRECTION:
+		reg = DAC1_WORD;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ad_phy_write(ad_phy, reg, dac_params->correction_value);
+}
+
+int ad_set_tx_atten(struct rf_phy_dev *ad_phy, u32 tx_if, u32 tx_atten)
+{
+	u32 reg_addr1, reg_addr2, reg_val;
+	int rc = 0;
+
+	if (tx_if == 1) {
+		reg_addr1 = TX1_ATTEN0;
+		reg_addr2 = TX1_ATTEN1;
+	} else if (tx_if == 2) {
+		reg_addr1 = TX2_ATTEN0;
+		reg_addr2 = TX2_ATTEN1;
+	} else {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	reg_val = tx_atten & ATTEN0_MASK;
+	ad_phy_write(ad_phy, reg_addr1, reg_val);
+	reg_val = tx_atten & ATTEN1_MASK;
+	reg_val = reg_val >> MSB_SHIFT;
+	ad_phy_write(ad_phy, reg_addr2, reg_val);
+	ad_phy->tx_atten[tx_if - 1] = tx_atten;
+
+out:
+	return rc;
+}
+
+int ad_en_dis_tx(struct rf_phy_dev *ad_phy, u32 tx_if, u32 tx_cmd)
+{
+	u32 mask, reg_val;
+	ad_phy_read(ad_phy, TX_ENABLE_REG, 1,  &reg_val);
+	if (tx_if == 1)
+		mask = TX1_ENABLE_MASK;
+	else if (tx_if == 2)
+		mask = TX2_ENABLE_MASK;
+	else
+		return -EFAULT;
+
+	if (tx_cmd == TX_ENABLE)
+		reg_val |= mask;
+	else if (tx_cmd == TX_DISABLE)
+		reg_val &= ~mask;
+	else
+		return -EFAULT;
+	return  ad_phy_write(ad_phy, TX_ENABLE_REG, reg_val);
+}
+
+int ad_en_dis_rx(struct rf_phy_dev *ad_phy, u32 rx_if, u32 rx_cmd)
+{
+	u32 mask, reg_val;
+	ad_phy_read(ad_phy, RX_ENABLE_REG, 1,  &reg_val);
+	if (rx_if == 1)
+		mask = RX1_ENABLE_MASK;
+	else if (rx_if == 2)
+		mask = RX2_ENABLE_MASK;
+	else
+		return -EFAULT;
+
+	if (rx_cmd == RX_ENABLE)
+		reg_val |= mask;
+	else if (rx_cmd == RX_DISABLE)
+		reg_val &= ~mask;
+	else
+		return -EFAULT;
+	return  ad_phy_write(ad_phy, RX_ENABLE_REG, reg_val);
+}
+
+static int ad_read_rssi(struct rf_phy_dev *ad_phy, struct rf_rssi *rssi)
+{
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &phy_info->ad_spi->dev;
+	u32 reg_val_buf[6], weight[4], total_dur, val, temp;
+	u32 subframe_size[4] = {SUBFRAME_SIZE_5MHZ,
+				SUBFRAME_SIZE_10MHZ,
+				SUBFRAME_SIZE_15MHZ,
+				SUBFRAME_SIZE_20MHZ};
+	u8 dur_buf[4] = {0}, i, j;
+	int rc;
+
+	if (rssi->duration > 1) {
+		dev_err(dev, "RSSI measurement duration > 1ms not supported\n");
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = ad_phy_read(ad_phy, RSSI_CONFIG_REG, 1, &val);
+	val &= RSSI_MEAS_MODE_MASK;
+	val |= RSSI_GAIN_CHANGE_EN_AGC_MODE;
+	rc |= ad_phy_write(ad_phy, RSSI_CONFIG_REG, val);
+	if (rc) {
+		dev_err(dev, "Unable to read/write rssi config reg\n");
+		goto out;
+	}
+
+	temp = subframe_size[ad_phy->ctrl_dev->bw] * rssi->duration;
+	for (i = 0, j = 0; temp != 0 && j < 4; i++) {
+		if (temp & 0x01)
+			dur_buf[j++] = i;
+		temp = temp >> 1;
+	}
+
+	total_dur = (1 << dur_buf[0]) + (1 << dur_buf[1]) +
+			(1 << dur_buf[2]) + (1 << dur_buf[3]);
+	weight[0] = RSSI_MAX_WEIGHT * (1 << dur_buf[0]) / total_dur;
+	weight[1] = RSSI_MAX_WEIGHT * (1 << dur_buf[1]) / total_dur;
+	weight[2] = RSSI_MAX_WEIGHT * (1 << dur_buf[2]) / total_dur;
+	weight[3] = RSSI_MAX_WEIGHT * (1 << dur_buf[3]) / total_dur;
+	rc = ad_phy_write(ad_phy, RSSI_MEAS_DUR_10_REG,
+			((dur_buf[1] << 4) | dur_buf[0])) ||
+		ad_phy_write(ad_phy, RSSI_MEAS_DUR_32_REG,
+			((dur_buf[3] << 4) | dur_buf[2])) ||
+		ad_phy_write(ad_phy, RSSI_WEIGHT0_REG, weight[0]) ||
+		ad_phy_write(ad_phy, RSSI_WEIGHT1_REG, weight[1]) ||
+		ad_phy_write(ad_phy, RSSI_WEIGHT2_REG, weight[2]) ||
+		ad_phy_write(ad_phy, RSSI_WEIGHT3_REG, weight[3]);
+	if (rc) {
+		dev_err(dev, "Unable to write rssi measurement duration\n");
+		goto out;
+	}
+
+	rc = ad_phy_read(ad_phy, RSSI_READBACK_REG,
+			sizeof(reg_val_buf) / sizeof(u32), reg_val_buf);
+
+	if (rssi->ant == 1) {
+		rssi->symbol = RSSI_RESOLUTION *
+				((reg_val_buf[0] << LSB_SHIFT) +
+				 (reg_val_buf[4] & RSSI_LSB_MASK1));
+		rssi->preamble = RSSI_RESOLUTION *
+				((reg_val_buf[1] << LSB_SHIFT) +
+				 (reg_val_buf[5] & RSSI_LSB_MASK1));
+	} else if (rssi->ant == 2) {
+		rssi->symbol = RSSI_RESOLUTION *
+				((reg_val_buf[2] << LSB_SHIFT) +
+				 ((reg_val_buf[4] & RSSI_LSB_MASK2) >> 1));
+		rssi->preamble = RSSI_RESOLUTION *
+				((reg_val_buf[3] << LSB_SHIFT) +
+				 ((reg_val_buf[5] & RSSI_LSB_MASK2) >> 1));
+	} else
+		rc = -EFAULT;
+
+	rssi->multiplier = RSSI_MULTIPLIER;
+
+out:
+	return rc;
+}
+
+static int ad_phy_remove(struct spi_device *spi)
+{
+	int i, ret = 0;
+	struct device *dev = &spi->dev;
+	struct rf_phy_dev *ad_phy = dev_get_drvdata(&spi->dev);
+	struct ad_dev_info *phy_info = ad_phy->priv;
+
+	dev_dbg(dev, "AD9361 PHY module uninstalled\n");
+
+	gpio_free(phy_info->reset_gpio);
+	gpio_free(phy_info->pa_en_gpio);
+	gpio_free(phy_info->lna_en_gpio);
+
+	ret = unregister_rf_phy_dev(ad_phy);
+	if (ret < 0) {
+		dev_dbg(dev, "unregister_rf_phy_dev failed.\n");
+		return ret;
+	}
+
+	for (i = 0; i < MAX_GPIO_CONFIGS; i++) {
+		kfree(phy_info->band_grp[i]);
+		kfree(phy_info->band_grp_sniff[i]);
+	}
+	ret = free_rf_phy_dev(ad_phy);
+
+	return ret;
+}
+
+static int check_revision(struct rf_phy_dev *ad_phy)
+{
+	u32 val;
+	u8 product_id, rev;
+	int rc = 0;
+	struct ad_dev_info *phy_info = ad_phy->priv;
+	struct device *dev = &(phy_info->ad_spi->dev);
+
+	ad_phy_read(ad_phy, PRODUCT_CODE_REG, 1, &val);
+
+	product_id = (u8) val & PRODUCT_ID_MASK;
+	if (product_id != PRODUCT_ID_9361) {
+		dev_err(dev, "Unsuported product id 0x%x\n", product_id);
+		rc = -ENODEV;
+		goto out;
+	}
+
+	rev = (u8) val & REV_MASK;
+	if (rev != 2) {
+		dev_err(dev, "Unsuported AD9361 revision 0x%x\n", rev);
+		rc = -ENODEV;
+		goto out;
+	}
+
+	dev_info(dev, "Detected AD9361 Rev 0x%x\n", rev);
+out:
+	return rc;
+}
+
+static int init_band_grps(struct device_node *child,
+		struct ad_dev_info *phy_info, int band_grp_idx)
+{
+	struct device *dev = &(phy_info->ad_spi->dev);
+	int j, rc = 0, size = 0;
+	const unsigned int *temp;
+
+	if (band_grp_idx >= MAX_GPIO_CONFIGS) {
+		dev_err(dev, "Number of Band Groups exceeded max value %d\n",
+				MAX_GPIO_CONFIGS);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	temp = (unsigned int *)of_get_property(child,
+			"fsl,ad9361-bands", &size);
+	size /= sizeof(unsigned int);
+	phy_info->band_grp[band_grp_idx] = kmalloc(size * sizeof(unsigned int),
+					GFP_KERNEL);
+	phy_info->band_grp_size[band_grp_idx] = size;
+	for (j = 0; j < size; j++)
+		phy_info->band_grp[band_grp_idx][j] = temp[j];
+
+	temp = (unsigned int *)of_get_property(child,
+			"fsl,ad9361-sniff-bands", &size);
+	size /= sizeof(unsigned int);
+	phy_info->band_grp_sniff[band_grp_idx] = kmalloc(size *
+				sizeof(unsigned int), GFP_KERNEL);
+	phy_info->band_grp_sniff_size[band_grp_idx] = size;
+	for (j = 0; j < size; j++)
+		phy_info->band_grp_sniff[band_grp_idx][j] = temp[j];
+
+	if (of_find_property(child, "fsl,ad9361-pa", NULL))
+		phy_info->band_grp_cfg[band_grp_idx][0] = 1;
+	else
+		phy_info->band_grp_cfg[band_grp_idx][0] = 0;
+
+	if (of_find_property(child, "fsl,ad9361-lna", NULL))
+		phy_info->band_grp_cfg[band_grp_idx][1] = 1;
+	else
+		phy_info->band_grp_cfg[band_grp_idx][1] = 0;
+out:
+	return rc;
+}
+
+static int get_band_control_mode(struct device_node *np,
+			struct ad_dev_info *phy_info)
+{
+	int rc = 0;
+
+	/* This function needs to be updated for BSC9132 where
+	 * bands will be controlled by FPGA and not by GPIO
+	 */
+	if (of_find_property(np, "fsl,ad9361-gpios", NULL)) {
+		phy_info->config_mode = GPIO_MODE;
+	} else {
+		phy_info->config_mode = INVALID_MODE;
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+static int ad_init_gpio(struct device_node *child, struct device *dev,
+			struct ad_dev_info *phy_info)
+{
+	char *gpio_name[] = {"reset", "pa_en", "lna_en"};
+	int gpio[AD9361_MAX_GPIO], ret = 0, i;
+	u32 flags;
+
+	for (i = 0; i < AD9361_MAX_GPIO; i++) {
+		gpio[i] = of_get_named_gpio_flags(child, "fsl,ad9361-gpios",
+				i, &flags);
+		if (gpio[i] < 0) {
+			dev_err(dev, "Could not get gpio for %s, err %d\n",
+				gpio_name[i], gpio[i]);
+			ret = gpio[i];
+			goto out;
+		}
+
+		ret = gpio_request(gpio[i], dev_name(dev));
+		if (ret) {
+			dev_dbg(dev, "gpio_request failed, gpio %s[%d]",
+					gpio_name[i], gpio[i]);
+			goto out;
+		}
+
+		ret = gpio_direction_output(gpio[i], 0);
+		if (ret) {
+			dev_dbg(dev,
+				"gpio_direction_output failed, gpio %s[%d]",
+				gpio_name[i], gpio[i]);
+			goto out;
+		}
+	}
+	phy_info->reset_gpio = gpio[0];
+	phy_info->pa_en_gpio = gpio[1];
+	phy_info->lna_en_gpio = gpio[2];
+
+out:
+	return ret;
+}
+
+static void ad_reset_phy(struct ad_dev_info *phy_info, struct device *dev)
+{
+	switch (phy_info->config_mode) {
+	case FPGA_MODE:
+		dev_err(dev, "FPGA mode not imlemented\n");
+		break;
+	case GPIO_MODE:
+		if ((phy_info->reset_gpio == GPIO_INVAL) ||
+			(phy_info->lna_en_gpio == GPIO_INVAL) ||
+			(phy_info->pa_en_gpio == GPIO_INVAL))
+			dev_info(dev, "Control GPIOs not intialized in dtb\n");
+
+		if ((!reset_status) && (phy_info->reset_gpio != GPIO_INVAL)) {
+			/* Toggle reset gpio to reset AD9361 */
+			gpio_set_value(phy_info->reset_gpio, 0);
+			gpio_set_value(phy_info->reset_gpio, 1);
+			reset_status = true;
+		}
+
+		break;
+	default:
+		dev_info(dev, "Invalid Band control mode\n");
+	}
+}
+
+static int ad_phy_probe(struct spi_device *spi)
+{
+	int i, ret = 0, band_grp_idx = 0;
+	static struct rf_phy_dev *ad_phy;
+	struct device *dev = &spi->dev;
+	struct ad_dev_info *phy_info;
+	struct device_node *np = spi->dev.of_node, *child;
+
+	ad_phy = allocate_rf_phy_dev(sizeof(struct ad_dev_info), GFP_KERNEL);
+	if (!ad_phy) {
+		dev_dbg(dev, "Failed to allocate rf_phy_dev\n");
+		return -ENOMEM;
+	}
+
+	phy_info = (struct ad_dev_info *) ad_phy->priv;
+
+	phy_info->ad_spi = spi;
+	spi->bits_per_word = 8;
+
+	ad_phy->ops = &ad_phy_ops;
+
+	strncpy(&ad_phy->name[0], "ad9361", sizeof(ad_phy->name));
+	ad_phy->phy_id = (u32) np;
+
+	phy_info->reset_gpio = GPIO_INVAL;
+	phy_info->pa_en_gpio = GPIO_INVAL;
+	phy_info->lna_en_gpio = GPIO_INVAL;
+
+	if (get_band_control_mode(np, phy_info))
+		dev_info(dev, "Undefined band-control mode detected\n");
+
+	if (GPIO_MODE == phy_info->config_mode)
+		if (ad_init_gpio(np, dev, phy_info))
+			goto out;
+
+	for_each_child_of_node(np, child) {
+		if (INVALID_MODE != phy_info->config_mode) {
+			ret = init_band_grps(child, phy_info, band_grp_idx);
+			if (ret)
+				goto out;
+			band_grp_idx++;
+		}
+	}
+
+	ad_reset_phy(phy_info, dev);
+
+	dev_set_drvdata(&spi->dev, ad_phy);
+
+	ret = check_revision(ad_phy);
+	if (ret)
+		goto out;
+
+	ad_init_gain_tables(ad_phy);
+
+	/* If revision code is correct, Registering phy as a rf phy device. */
+	ret = register_rf_phy_dev(ad_phy);
+	if (ret) {
+		dev_dbg(dev, "register_rf_phy_dev failed.\n");
+		goto out;
+	}
+
+	rf_update_master_slave_status();
+	return ret;
+
+out:
+	if (phy_info->reset_gpio != GPIO_INVAL)
+		gpio_free(phy_info->reset_gpio);
+
+	if (phy_info->pa_en_gpio != GPIO_INVAL)
+		gpio_free(phy_info->pa_en_gpio);
+
+	if (phy_info->lna_en_gpio != GPIO_INVAL)
+		gpio_free(phy_info->lna_en_gpio);
+
+	for (i = 0; i < MAX_GPIO_CONFIGS; i++) {
+		kfree(phy_info->band_grp[i]);
+		kfree(phy_info->band_grp_sniff[i]);
+	}
+	free_rf_phy_dev(ad_phy);
+	return ret;
+}
+
+static const struct spi_device_id ad9361_spi_id[] = {
+	{ "ad9361", 0 },
+	{},
+};
+
+static struct spi_driver ad_phy_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+		},
+	.id_table	= ad9361_spi_id,
+	.probe = ad_phy_probe,
+	.remove = ad_phy_remove,
+
+};
+
+static int __init ad_phy_init(void)
+{
+	int ret;
+
+
+	ret = spi_register_driver(&ad_phy_driver);
+	if (ret != 0) {
+		pr_err("%s spi_register_driver failed with err %x\n",
+			__func__, ret);
+	}
+
+	return ret;
+}
+
+static void __exit ad_phy_exit(void)
+{
+	spi_unregister_driver(&ad_phy_driver);
+}
+
+module_init(ad_phy_init);
+module_exit(ad_phy_exit);
diff --git a/drivers/misc/rf/phy/ad9361.h b/drivers/misc/rf/phy/ad9361.h
new file mode 100644
index 0000000..67eb65c
--- /dev/null
+++ b/drivers/misc/rf/phy/ad9361.h
@@ -0,0 +1,353 @@
+/*
+ * drivers/rf/phy/ad9361.h
+ *
+ * Copyright 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef AD_PHY_H
+#define AD_PHY_H
+
+#define AD9361_MAX_GPIO		3
+#define MAX_CARRIER_FREQ_KHZ	6000000
+#define MIN_CARRIER_FREQ_KHZ	47000
+
+/* For creating instruction word/command */
+#define OPCODE_WRITE 0x8000
+#define OPCODE_READ 0x0000
+#define BYTES_TRANSFER_MASK 0x7000
+#define SHIFT_BYTES_TRANSFER 12
+#define REG_ADDRESS_MASK 0x03FF
+#define COMMAND_MASK 0xFFFF0000
+#define COMMAND_LEN 2
+
+#define TRANSACTION_BYTES 3
+#define MAX_READ_TRANSACTION_SIZE 	8
+#define RXBUF_SIZE			10
+#define NUM_GPIOS			2
+#define MAX_GPIO_CONFIGS		(1 << NUM_GPIOS)
+#define GPIO_INVAL			(~0)
+
+#define BBPLL_LOCK_MASK 0x80
+#define PRODUCT_CODE_REG 0x37
+#define PRODUCT_ID_MASK 0x08
+#define PRODUCT_ID_9361 0x08
+#define REV_MASK	0x07
+
+/* Calibration status Registers */
+#define REG_CH1_OVERFLOW	0x05E
+#define REG_RX_CAL_STATUS	0x244
+#define REG_TX_CAL_STATUS	0x284
+#define REG_CALIBRATION_CONTROL	0x016
+#define REG_CALIBRATION_CONFIG1	0x169
+#define REG_RX_CP_CONFIG	0x23D
+#define REG_TX_CP_CONFIG	0x27D
+
+#define VAL_CAL_CONF1_TRACKOFF	0xC0
+
+/* Calibration status masks */
+#define MASK_BBPLL_LOCK		0x80
+#define MASK_RX_CP_CAL_VALID	0x80
+#define MASK_TX_CP_CAL_VALID	0x80
+#define MASK_RX_BB_TUNE		0x80
+#define MASK_TX_BB_TUNE		0x40
+#define MASK_DC_CAL_BBSTART	0x00
+#define MASK_DC_CAL_RFSTART	0x01
+#define MASK_TXQUAD_CAL		0x10
+
+/*
+ * 24 = 0x18 which is the AuxDAC1 word address
+ * 26 = 0x1A which is the AuxDAC1 config address
+ */
+#define DAC1_WORD 	24
+#define DAC1_CONFIG  	26
+
+/* TX Attenuation Registers */
+#define TX1_ATTEN0	0x073
+#define TX1_ATTEN1	0x074
+#define TX2_ATTEN0	0x075
+#define TX2_ATTEN1	0x076
+#define ATTEN0_MASK	0x000000FF
+#define ATTEN1_MASK	0x00000100
+#define ATTEN_MSB_BIT_MASK	0x01
+#define MSB_SHIFT	8
+
+#define TX_ENABLE	0x01
+#define TX_DISABLE	0x00
+#define TX_ENABLE_REG	0x002
+#define TX1_ENABLE_MASK	0x40
+#define TX2_ENABLE_MASK	0x80
+
+#define RX_ENABLE	0x01
+#define RX_DISABLE	0x00
+#define RX_ENABLE_REG	0x003
+#define RX1_ENABLE_MASK	0x40
+#define RX2_ENABLE_MASK	0x80
+
+#define RSSI_READBACK_REG 0x1A7
+#define RSSI_CONFIG_REG	0x158
+#define RSSI_DELAY_REG	0x156
+#define RSSI_MEAS_DUR_10_REG	0x150
+#define RSSI_MEAS_DUR_32_REG	0x151
+#define RSSI_WEIGHT0_REG	0x152
+#define RSSI_WEIGHT1_REG	0x153
+#define RSSI_WEIGHT2_REG	0x154
+#define RSSI_WEIGHT3_REG	0x155
+
+#define RSSI_MAX_WEIGHT		255
+#define RSSI_MEAS_MODE_MASK	0xE2
+#define RSSI_GAIN_CHANGE_EN_AGC_MODE	0x14
+/* RSSI delay reg value is decremented by RX sample rate divided by 8*/
+#define RSSI_DELAY_5MHZ		(256 / 8)
+#define RSSI_DELAY_10MHZ	(512 / 8)
+#define RSSI_DELAY_15MHZ	(768 / 8)
+#define RSSI_DELAY_20MHZ	(1024 / 8)
+
+#define SUBFRAME_SIZE_5MHZ	7680
+#define SUBFRAME_SIZE_10MHZ	15360
+#define SUBFRAME_SIZE_15MHZ	23040
+#define SUBFRAME_SIZE_20MHZ	30720
+
+/* For 9 bit RSSI symbol/preamble value RSSI is equivalent to 0.25dB/LSB.
+ * Since we can not do floating pt operations in kernel, we multiply
+ * Resolution with RSSI_MULTIPLER, and pass this multipler to user space
+ * which can convert rssi to floating pt again.
+ */
+#define RSSI_MULTIPLIER	100
+#define RSSI_RESOLUTION	((int) (0.25 * RSSI_MULTIPLIER))
+#define LSB_SHIFT	1
+#define RSSI_LSB_MASK1	0x01
+#define RSSI_LSB_MASK2	0x02
+
+#define REG_RXEN_N_FILTER_CTRL		0x003
+#define RX1_EN				0x40
+#define RX2_EN				0x80
+
+/* Gain index read/write register for MGC */
+#define REG_RX1_MGC_FULL_TBL_IDX	0x109
+#define REG_RX2_MGC_FULL_TBL_IDX	0x10c
+
+/* Gain Index read back registers. They are
+ * applicable for both AGC and MGC
+ */
+#define REG_RX1_FULL_TBL_IDX		0x2B0
+#define REG_RX1_LPF_GAIN_IDX		0x2B1
+#define REG_RX1_DIG_GAIN_IDX		0x2B2
+#define REG_RX2_FULL_TBL_IDX		0x2B5
+#define REG_RX2_LPF_GAIN_IDX		0x2B6
+#define REG_RX2_DIG_GAIN_IDX		0x2B7
+#define FULL_TBL_IDX_MASK		0x7f
+#define LPF_IDX_MASK			0x1f
+#define DIGITAL_IDX_MASK		0x1f
+#define MAX_LMT_INDEX			40
+#define MAX_LPF_GAIN			24
+#define MAX_DIG_GAIN			31
+
+#define REG_GAIN_TBL_ADDR		0x130
+#define REG_GAIN_TBL_READ_DATA1		0x134
+#define REG_GAIN_TBL_READ_DATA2		0x135
+#define REG_GAIN_TBL_READ_DATA3		0x136
+#define LNA_GAIN_MASK			0x60
+#define MIXER_GAIN_MASK			0x1F
+#define TIA_GAIN_MASK			0x20
+#define LNA_SHIFT			5
+#define MIXER_SHIFT			0
+#define TIA_SHIFT			5
+
+/*Fast attack state register*/
+#define REG_FAST_ATK_STATE		0x2B3
+#define FAST_ATK_MASK			0x7
+#define RX1_FAST_ATK_SHIFT		0
+#define RX2_FAST_ATK_SHIFT		4
+
+/*Fast attack state machine states*/
+#define FAST_ATK_RESET			0
+#define FAST_ATK_PEAK_DETECT		1
+#define FAST_ATK_PWR_MEASURE		2
+#define FAST_ATK_FINAL_SETTELING	3
+#define FAST_ATK_FINAL_OVER		4
+#define FAST_ATK_GAIN_LOCKED		5
+
+#define REG_AGC_CONF1			0x0FA
+
+#define RX_GAIN_CTL_MASK		0x03
+#define RX2_GAIN_CTL_SHIFT		2
+#define RX1_GAIN_CTL_SHIFT		0
+
+#define RX_GAIN_CTL_MGC				0x00
+#define RX_GAIN_CTL_AGC_FAST_ATK		0x01
+#define RX_GAIN_CTL_AGC_SLOW_ATK		0x02
+#define RX_GAIN_CTL_AGC_SLOW_ATK_HYBD		0x03
+#define SLOW_ATK_HYBD_BIT_EN			0x10
+
+#define REG_AGC_CONF2			0x0FB
+#define FULL_GAIN_TBL			0x08
+#define DIGITAL_GAIN_EN			0x04
+
+#define RXGAIN_FULL_TBL_MAX_IDX		90
+#define RXGAIN_SPLIT_TBL_MAX_IDX	40
+
+/*ENSM config1 register*/
+#define REG_ENSM_CONF1			0x014
+#define ENSM_CONF1_TO_ALERT		(1 << 0)
+#define ENSM_CONF1_AUTO_GAIN_LOCK	(1 << 1)
+#define ENSM_CONF1_FORCE_ALERT		(1 << 2)
+#define ENSM_CONF1_LEVEL_MODE		(1 << 3)
+#define ENSM_CONF1_ENSM_PIN_CTL_EN	(1 << 4)
+#define ENSM_CONF1_FORCE_TX_ON		(1 << 5)
+#define ENSM_CONF1_FORCE_RX_ON		(1 << 6)
+#define ENSM_CONF_RX_EN_CAL		(1 << 7)
+
+/*ENSM state - Read only*/
+#define REG_DEV_STATE			0x017
+#define ENSM_STATE_SHIFT		0x0
+#define ENSM_STATE_MASK			0x0f
+
+#define ENSM_STATE_SLEEP_WAIT		0x0
+#define ENSM_STATE_ALERT		0x5
+#define ENSM_STATE_TX			0x6
+#define ENSM_STATE_TX_FLUSH		0x7
+#define ENSM_STATE_RX			0x8
+#define ENSM_STATE_RX_FLUSH		0x9
+#define ENSM_STATE_FDD			0xA
+#define ENSM_STATE_FDD_FLUSH		0xB
+#define ENSM_STATE_INVALID		0xff
+
+/* Synthesizer Registers */
+#define REG_RFPLL_DIVIDER		0x005
+#define REG_VCO_OUTPUT			0x23A
+#define REG_VCO_VARACTOR		0x239
+#define REG_VCO_BIAS1			0x242
+#define REG_FORCE_VCO_TUNE1		0x238
+#define REG_VCO_VARACTOR_CONTROL1	0x251
+#define REG_CP_CURRENT			0x23B
+#define REG_LOOP_FILTER1		0x23E
+#define REG_LOOP_FILTER2		0x23F
+#define REG_LOOP_FILTER3		0x240
+#define REG_INTEGER_BYTE0		0X231
+#define REG_INTEGER_BYTE1		0X232
+#define REG_FRACTIONAL_BYTE0		0X233
+#define REG_FRACTIONAL_BYTE1		0X234
+#define REG_FRACTIONAL_BYTE2		0X235
+#define REG_REF_DIVIDE_CONFIG1		0x2AB
+#define REG_REF_DIVIDE_CONFIG2		0x2AC
+
+#define RX_REG_OFFSET			0x000
+#define TX_REG_OFFSET			0x040
+
+#define RX_SCALER_MASK1			0x01
+#define RX_SCALER_MASK2			0x80
+#define TX_SCALER_MASK			0x0C
+
+#define DEVICE_REF_FREQ_KHZ		19200
+#define RFPLL_MODULUS			8388593
+
+#define MASK_VCO_OUTPUT			0xF0
+#define MASK_VCO_VARACTOR		0xF0
+#define MASK_VCO_BIAS1			0xE0
+#define MASK_FORCE_VCO_TUNE1		0x87
+#define MASK_VCO_VARACTOR_CONTROL1	0xF0
+#define MASK_CP_CURRENT			0xC0
+#define MASK_LOOP_FILTER3		0xF0
+#define MASK_FRAC_B0			0xff
+#define MASK_FRAC_B1			0xff00
+#define MASK_FRAC_B2			0xff0000
+#define MASK_INT_B0			0xff
+#define MASK_INTEGER_REG1		0xf8
+#define MASK_INT_B1			0x700
+#define SHIFT_FRAC_B0			0
+#define SHIFT_FRAC_B1			8
+#define SHIFT_FRAC_B2			16
+#define SHIFT_INT_B1			8
+#define SHIFT_VCO_CAL_OFFSET		3
+#define SHIFT_VCO_BIAS_TCF		3
+#define SHIFT_LOOP_FILTER_C2		4
+#define SHIFT_LOOP_FILTER_R1		4
+
+/* Master/Slave configuartion register */
+#define REG_GPO_FORCE_INIT		0x027
+#define GPO3_MANUAL_CONTROL		0x80
+
+enum rx_gain_table_type {
+	RXGAIN_FULL_TBL,
+	RXGAIN_SPLIT_TBL,
+};
+
+enum rx_gain_table_name {
+	FULL_TBL_200_1300_MHZ,
+	FULL_TBL_1300_4000_MHZ,
+	FULL_TBL_4000_6000_MHZ,
+	RXGAIN_TBLS_END,
+};
+
+enum rf_synth_regs {
+	VCO_Output_Level,
+	VCO_Varactor,
+	VCO_Bias_Ref,
+	VCO_Bias_Tcf,
+	VCO_Cal_Offset,
+	VCO_Varactor_Reference,
+	Charge_Pump_Current,
+	Loop_Filter_C2,
+	Loop_Filter_C1,
+	Loop_Filter_R1,
+	Loop_Filter_C3,
+	Loop_Filter_R3
+};
+
+enum rf_synth_params {
+	Band,
+	Reference_Frequency,
+	Loop_Bandwidth,
+	Index,
+	VCO_Frequency,
+	VCO_Kv
+};
+
+enum rf_synthesizer {
+	RF_RX,
+	RF_TX,
+	RF_BBPLL
+};
+
+struct rx_gain_info {
+	enum rx_gain_table_type tbl_type;
+	int starting_gain_db;
+	int max_gain_db;
+	int gain_step_db;
+	int max_idx;
+	int idx_step_offset;
+};
+
+enum band_config_mode {
+	GPIO_MODE,
+	FPGA_MODE,
+	INVALID_MODE
+};
+
+struct ad_dev_info {
+	struct spi_device *ad_spi;
+	u8 rx_buf[10];
+	u8 prev_ensm_state;
+	int ensm_pin_ctl_en;
+	unsigned int freq_band;
+	enum rf_network_mode net_mode;
+	enum band_config_mode config_mode;
+	struct rx_gain_info rx_gain[RXGAIN_TBLS_END];
+	struct	rf_synth_table synth_table;
+	int reset_gpio;
+	int pa_en_gpio;
+	int lna_en_gpio;
+	int rf_num;
+	unsigned int *band_grp[MAX_GPIO_CONFIGS];
+	unsigned int band_grp_size[MAX_GPIO_CONFIGS];
+	unsigned int *band_grp_sniff[MAX_GPIO_CONFIGS];
+	unsigned int band_grp_sniff_size[MAX_GPIO_CONFIGS];
+	unsigned int band_grp_cfg[MAX_GPIO_CONFIGS][NUM_GPIOS];
+};
+
+#endif /* AD_PHY_H */
-- 
1.6.3.1



