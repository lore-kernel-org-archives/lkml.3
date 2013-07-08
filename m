Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3GHJu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:50:59 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:24289
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab3GHJus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:50:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zz853kc8kzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
From: <akhil.goyal@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <lars@metafoo.de>,
        <robin.getz@analog.com>, <Michael.Hennerich@analog.com>,
        <lars-peter.clausen@analog.com>
CC: <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>,
        Akhil Goyal <akhil.goyal@freescale.com>
Subject: [PATCH v2 2/4] drivers/misc/rf: AIC: Freescale Antenna Interface controller driver
Date: Mon, 8 Jul 2013 15:20:00 +0530
Message-ID: <1373277002-14009-3-git-send-email-akhil.goyal@freescale.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1373277002-14009-2-git-send-email-akhil.goyal@freescale.com>
References: <1373277002-14009-1-git-send-email-akhil.goyal@freescale.com>
 <1373277002-14009-2-git-send-email-akhil.goyal@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akhil Goyal <akhil.goyal@freescale.com>

AIC is the antenna interface controller found in heterogenous SOCs-
BSC9131 and BSC9132. It supports NCDMA, WCDMA-FDD, LTE-FDD, LTE-TDD
and SNIFF network modes.
AIC has 6 data lanes in BSC9131 and 4 in BSC9132 on which RFICs
can be connected. AIC supports at max 4 RFICs working simultaneously.

The address mapping of AIC is a part of DSP side of SOC. But according
to the architecture of the system, configuration of this driver shall
be done from PA side.

This patch support LTE-FDD, LTE-TDD and WCDMA configurations for AIC.
The data from RFIC through AIC goes directly to a hardware accelerator
from where it is taken out by DSP core in bsc913x.

This patch also support sniffing of LTE-FDD networks and it can also
handle the data path of the sniffing data.

Signed-off-by: Pankaj Chauhan <pankaj.chauhan@freescale.com>
Signed-off-by: Shilan Deng <r01207@freescale.com>
Signed-off-by: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>
Signed-off-by: Akhil Goyal <akhil.goyal@freescale.com>
---
 drivers/misc/rf/Kconfig               |   11 +
 drivers/misc/rf/Makefile              |    1 +
 drivers/misc/rf/controllers/Makefile  |    1 +
 drivers/misc/rf/controllers/fsl_aic.c | 1558 +++++++++++++++++++++++++++++++++
 drivers/misc/rf/controllers/fsl_aic.h |  450 ++++++++++
 5 files changed, 2021 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/rf/controllers/Makefile
 create mode 100644 drivers/misc/rf/controllers/fsl_aic.c
 create mode 100644 drivers/misc/rf/controllers/fsl_aic.h

diff --git a/drivers/misc/rf/Kconfig b/drivers/misc/rf/Kconfig
index 478cfd2..c14c200 100644
--- a/drivers/misc/rf/Kconfig
+++ b/drivers/misc/rf/Kconfig
@@ -17,3 +17,14 @@ menuconfig RFDEVICES
 
 	radio interface controller driver (Antenna controller) and RF PHY driver
 	connected to system must also be chosen.
+
+if RFDEVICES
+
+config FSL_AIC
+	default y
+	bool "Freescale Antenna Interface Controller (AIC)"
+	---help---
+	Freescale AIC controller (Antenna Interface Controller) is found
+	in bsc913x family of SOCs. AIC has six RF lanes and maximum four
+	RF PHYs can be connected and operated simultaneously.
+endif
diff --git a/drivers/misc/rf/Makefile b/drivers/misc/rf/Makefile
index 566585e..37dc442 100644
--- a/drivers/misc/rf/Makefile
+++ b/drivers/misc/rf/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_RFDEVICES)		+= core/
+obj-$(CONFIG_RFDEVICES)		+= controllers/
diff --git a/drivers/misc/rf/controllers/Makefile b/drivers/misc/rf/controllers/Makefile
new file mode 100644
index 0000000..6578c3c
--- /dev/null
+++ b/drivers/misc/rf/controllers/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_FSL_AIC)	+= fsl_aic.o
diff --git a/drivers/misc/rf/controllers/fsl_aic.c b/drivers/misc/rf/controllers/fsl_aic.c
new file mode 100644
index 0000000..cca6a7a
--- /dev/null
+++ b/drivers/misc/rf/controllers/fsl_aic.c
@@ -0,0 +1,1558 @@
+/*
+ * drivers/rf/controllers/fsl_aic.c
+ * Freescale AIC (Antenna Controller Interface) driver
+ *
+ * AIC is the antenna interface controller found in bsc913x
+ * family of SOCs. It supports NCDMA, WCDMA-FDD, LTE-FDD, LTE-TDD
+ * and GSM-SNIFF network modes. AIC has 6 lanes on which RFICs
+ * can be connected. And AIC supports 4 RFICs working simultaneously.
+ * This driver provides only configuration path for all other modes
+ * except SNIFF because data from RFIC through AIC goes directly
+ * to a hardware accelerator from where it is taken out by DSP core
+ * in bsc913x.
+ *
+ * Author: pankaj chauhan <pankaj.chauhan@freescale.com>
+ *
+ * Copyright 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/interrupt.h>
+#include <linux/rfdev.h>
+#include <linux/io.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/rf_channel.h>
+#include <linux/slab.h>
+#include "fsl_aic.h"
+
+static int aic_init(struct rf_ctrl_dev *rf_dev, struct rf_init_params *params);
+static int aic_timing_source(struct rf_ctrl_dev *rf_dev, unsigned int src);
+static int aic_read(struct rf_ctrl_dev *rf_dev, u32 addr, u32 count, u32 *buff);
+static int aic_write(struct rf_ctrl_dev *rf_dev, u32 offset, u32 data);
+static int aic_phy_detached(struct rf_ctrl_dev *rf_dev);
+static int aic_start(struct rf_ctrl_dev *rf_dev);
+static int aic_stop(struct rf_ctrl_dev *rf_dev);
+static int aic_config_sniff(struct rf_ctrl_dev *rf_dev,
+		struct rf_sniff_params *sniff_params);
+
+static int aic_start_sniffer(struct aic_sniffer *sniffer);
+static void aic_free_sniffer(struct aic_sniffer *sniffer);
+static irqreturn_t aic_isr(int irq, void *arg);
+static int aic_channel_open(struct rf_ctrl_dev *rf_dev,
+		struct rf_channel *chan);
+static int aic_channel_close(struct rf_ctrl_dev *rf_dev,
+		struct rf_channel *chan);
+
+static struct rf_ctrl_ops aic_rfops = {
+	.init = aic_init,
+	.set_timing_source = aic_timing_source,
+	.read_regs = aic_read,
+	.write_reg = aic_write,
+	.phy_detach = aic_phy_detached,
+	.start = aic_start,
+	.stop = aic_stop,
+	.config_sniff = aic_config_sniff,
+	.channel_open = aic_channel_open,
+	.channel_close = aic_channel_close,
+};
+
+int aic_get_lane_id(struct rf_ctrl_dev *rf_dev)
+{
+	struct aic_lane *lane = rf_dev->priv;
+
+	return lane->id;
+}
+EXPORT_SYMBOL(aic_get_lane_id);
+
+static int aic_phy_detached(struct rf_ctrl_dev *rf_dev)
+{
+	/*Currently we do not use phy detach notification*/
+	return 0;
+}
+
+static int aic_rftimer_start(struct rf_ctrl_dev *rf_dev)
+{
+	struct aic_lane_regs *lane_regs;
+	struct aic_lane *lane = rf_dev->priv;
+	struct aic_common_regs *common_regs;
+	struct device *dev = lane->aic->dev;
+	u32 val;
+	int i, rc = 0;
+
+	common_regs = lane->aic->regs;
+	lane_regs = lane->regs;
+
+
+	val = in_be32(&lane_regs->aic_lane_tmctrl);
+
+	if ((rf_dev->timing_src == RF_PPS_SRC_GPS) ||
+		(rf_dev->timing_src == RF_PPS_SRC_RAW_GPS) ||
+		(rf_dev->timing_src == RF_PPS_SRC_PTP)) {
+
+		val |= GPS_EN;
+
+		out_be32(&lane_regs->aic_lane_tmctrl, val);
+
+		for (i = 0; i < SYNC_WAIT; i++) {
+			val = in_be32(&lane_regs->aic_lane_tmctrl);
+			if (!(val & (GPS_EN))) {
+				dev_info(dev, "%s:GPS_EN cleared %x\n",
+						rf_dev->name, val);
+				break;
+			}
+			mdelay(100);
+		}
+
+		if (val & (GPS_EN)) {
+			dev_info(dev, "%s:GPS_EN did not clr %x\n",
+					rf_dev->name, val);
+			rc = -EAGAIN;
+			goto out;
+		}
+	}
+
+	val |= SYNC_EN;
+
+	out_be32(&lane_regs->aic_lane_tmctrl, val);
+	for (i = 0; i < SYNC_WAIT; i++) {
+		val = in_be32(&lane_regs->aic_lane_tmctrl);
+		if (!(val & (SYNC_EN))) {
+			dev_info(dev, "%s:sync cleared %x\n",
+					rf_dev->name, val);
+			break;
+		}
+		mdelay(100);
+	}
+
+	if (val & (SYNC_EN)) {
+		dev_info(dev, "%s:sync did not clr %x\n", rf_dev->name, val);
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	if ((rf_dev->net_mode == LTE_TDD) || (rf_dev->net_mode == LTE_FDD))
+		val |= LTE_EN;
+
+	out_be32(&lane_regs->aic_lane_tmctrl, val);
+
+	spin_lock(&lane->aic->lock);
+	val = in_be32(&common_regs->ppc_interrupt_ctrl_reg);
+	val |= (ADILANE0_DL_TTI << (lane->id * ADILANE_DL_TTI_SHIFT));
+	out_be32(&common_regs->ppc_interrupt_ctrl_reg, val);
+	spin_unlock(&lane->aic->lock);
+
+	rf_dev->rftimer_started = 1;
+out:
+	return rc;
+}
+
+static int aic_start(struct rf_ctrl_dev *rf_dev)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	int rc = 0;
+
+	if (!rf_dev->rftimer_started)
+		rc = aic_rftimer_start(rf_dev);
+
+	if (lane->sniffer) {
+		rc = aic_start_sniffer(lane->sniffer);
+		if (rc)
+			goto out;
+	}
+
+out:
+	return rc;
+}
+
+static int aic_stop(struct rf_ctrl_dev *rf_dev)
+{
+	struct aic_lane_regs *lane_regs;
+	struct aic_lane *lane = rf_dev->priv;
+	struct aic_common_regs *common_regs;
+	u32 val;
+	int i;
+
+	common_regs = lane->aic->regs;
+	lane_regs = lane->regs;
+
+	rf_dev->rftimer_started = 0;
+
+	/* Disable LTE for TDD and FDD modes */
+	val = in_be32(&lane_regs->aic_lane_tmctrl);
+	if ((rf_dev->net_mode == LTE_TDD) || (rf_dev->net_mode == LTE_FDD))
+		val &= ~LTE_EN;
+	out_be32(&lane_regs->aic_lane_tmctrl, val);
+
+	spin_lock(&lane->aic->lock);
+	/* Disable DL_TTI interrupt in ppc_interrupt_ctrl_reg */
+	val = in_be32(&common_regs->ppc_interrupt_ctrl_reg);
+	val &= ~(ADILANE0_DL_TTI << (lane->id * ADILANE_DL_TTI_SHIFT));
+	out_be32(&common_regs->ppc_interrupt_ctrl_reg, val);
+	spin_unlock(&lane->aic->lock);
+
+	wake_up_all(&rf_dev->wait_q);
+
+	if (rf_dev->data_chans_enabled) {
+		for (i = lane->num_chan - 1; i >= 0; i--) {
+			aic_channel_close(rf_dev, rf_dev->channels[i]);
+			rf_dev->channels[i] = NULL;
+		}
+	}
+
+	if (lane->sniffer)
+		aic_free_sniffer(lane->sniffer);
+
+	rf_dev->data_chans_enabled = 0;
+	rf_dev->sniff_enabled = 0;
+	rf_dev->net_mode = NET_MODE_END;
+	rf_dev->tx_rxmode = TXRX_MODE_END;
+	rf_dev->bw = BW_END;
+	memset(&rf_dev->dev_params, 0, sizeof(struct rf_dev_params));
+	memset(&rf_dev->stats, 0, sizeof(struct rf_stats));
+	rf_dev->frame_count0 = 0;
+	rf_dev->frame_count1 = 0;
+
+	return 0;
+}
+
+static int aic_write(struct rf_ctrl_dev *rf_dev, u32 offset, u32 data)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	struct aic_lane_regs *lane_regs;
+	struct aic_common_regs *aic_regs;
+	int is_common_reg = 1;
+	u32 *addr;
+
+	if (offset > (2 * sizeof(struct aic_lane_regs)))
+		return -EINVAL;
+
+	if (offset & LANE_REGDUMP_OFFSET) {
+		is_common_reg = 0;
+		offset -= LANE_REGDUMP_OFFSET;
+	}
+
+	if (is_common_reg) {
+		aic_regs = lane->aic->regs;
+		addr = (u32 *) ((u32) &aic_regs->aic_ip_version + offset);
+	} else {
+		lane_regs = lane->regs;
+		addr = (u32 *) ((u32) &lane_regs->aic_dma_riqmts + offset);
+	}
+
+	out_be32(addr, data);
+
+	return 0;
+}
+
+static int aic_read(struct rf_ctrl_dev *rf_dev, u32 start_offset,
+		u32 count, u32 *buff)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	struct aic_lane_regs *lane_regs;
+	struct aic_common_regs *aic_regs;
+	u32 *reg_addr, *start_addr;
+	int i, is_common_reg = 1;
+
+	if (start_offset > (2 * sizeof(struct aic_lane_regs)))
+		return -EINVAL;
+
+	if (start_offset & LANE_REGDUMP_OFFSET) {
+		is_common_reg = 0;
+		start_offset -= LANE_REGDUMP_OFFSET;
+	}
+	if (is_common_reg) {
+		aic_regs = lane->aic->regs;
+		start_addr = &aic_regs->aic_ip_version;
+		start_addr = (u32 *)((u32) start_addr + start_offset);
+		for (i = 0; i < count; i++) {
+			reg_addr = start_addr + i;
+			buff[i] = in_be32(reg_addr);
+		}
+	} else {
+		lane_regs = lane->regs;
+		start_addr = &lane_regs->aic_dma_riqmts;
+		start_addr = (u32 *)((u32)start_addr +  start_offset);
+		for (i = 0; i < count; i++) {
+			reg_addr = start_addr + i;
+			buff[i] = in_be32(reg_addr);
+		}
+	}
+
+	return 0;
+}
+
+static int aic_timing_source(struct rf_ctrl_dev *rf_dev, unsigned int src)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	struct aic_lane_regs *regs;
+	u32 val;
+	int rc = 0;
+
+	regs = lane->regs;
+	val = in_be32(&regs->aic_netw_conf1);
+	val &= ~PPS_TRIG_MASK;
+	switch (src) {
+	case RF_PPS_SRC_GPS:
+	case RF_PPS_SRC_PTP:
+		val |= PPS_TRIG_PTP;
+		break;
+	case RF_PPS_SRC_RAW_GPS:
+		val |= PPS_TRIG_RAW_PPS;
+		break;
+	case RF_PPS_SRC_NLM:
+		val |= PPS_TRIG_NLM;
+		break;
+	default:
+		rc = -EINVAL;
+	}
+
+	rf_dev->timing_src = src;
+	out_be32(&regs->aic_netw_conf1, val);
+
+	return rc;
+}
+
+static irqreturn_t aic_isr(int irq, void *arg)
+{
+	struct aic_lane *lane = (struct aic_lane *) arg;
+	struct aic_lane_stats *stats;
+	struct aic_common_regs *common_regs;
+	u32 val;
+
+	common_regs = lane->aic->regs;
+	stats = &lane->stats;
+	val = in_be32(&common_regs->ppc_interrupt_status_reg);
+	val &= (ADILANE0_DL_TTI << (ADILANE_DL_TTI_SHIFT * lane->id));
+	if (val) {
+		stats->dl_tti_count++;
+		rf_notify_dl_tti(lane->rf_dev);
+		out_be32(&common_regs->ppc_interrupt_status_reg, val);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t aic_sniffer_isr(int irq, void *arg)
+{
+	struct aic_dev *dev = (struct aic_dev *) arg;
+	struct aic_common_regs *common_regs;
+	struct aic_lane *lane;
+	struct aic_sniffer *sniffer = NULL;
+	struct aic_sniff_regs *sniff_regs;
+	u32 val;
+
+	common_regs = dev->regs;
+
+	val = in_be32(&common_regs->ppc_interrupt_status_reg);
+	if (!val)
+		return IRQ_NONE;
+	if (val & PPC_ISR_SNIFF0_CAPT_DONE_INT) {
+		/* Clear ppc interrupt status register */
+		out_be32(&common_regs->ppc_interrupt_status_reg,
+				PPC_ISR_SNIFF0_CAPT_DONE_INT);
+		sniffer = &dev->sniffers[0];
+	}
+	if (val & PPC_ISR_SNIFF1_CAPT_DONE_INT) {
+		/* Clear ppc interrupt status register */
+		out_be32(&common_regs->ppc_interrupt_status_reg,
+				PPC_ISR_SNIFF1_CAPT_DONE_INT);
+		sniffer = &dev->sniffers[1];
+	}
+
+	/* clear capture complete interrupt */
+	if (sniffer) {
+		sniff_regs = sniffer->regs;
+		lane = sniffer->lane;
+		out_be32(&sniff_regs->aic_sniff_int_stat, CAP_INT_STAT);
+		sniffer->capture_done = 1;
+		if (lane->rx_dma_done == lane->rx_dma_done_mask) {
+			rf_sniff_done(lane->rf_dev, 0);
+			lane->rf_dev->data_chans_enabled = 0;
+			val = in_be32(&lane->regs->aic_dma_dcr);
+			val &= ~RIQE;
+			out_be32(&lane->regs->aic_dma_dcr, val);
+			lane->rx_dma_done = 0;
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void aic_dma_isr(struct aic_lane *lane, u32 flag)
+{
+	struct aic_lane_regs *regs = lane->regs;
+	struct aic_sniffer *sniffer = lane->sniffer;
+	struct aic_lane_stats *stats = &lane->stats;
+	struct rf_frame frame;
+	u32 val, curr_disp, displacement, temp;
+
+	curr_disp = in_be32(&regs->aic_dma_riqbdr);
+	displacement = (curr_disp - stats->prev_disp) & RIQBDR_MASK;
+	val = in_be32(&regs->aic_dma_riqt);
+	temp = displacement % val;
+	displacement /= val;
+	stats->prev_disp = (curr_disp - temp) & RIQBDR_MASK;
+	if (flag & ANT0_RIQTI) {
+		frame.ant = 0;
+		frame.buf.buffer_idx = lane->rx_ant0_idx;
+		lane->rx_ant0_idx += displacement;
+		if (lane->rx_ant0_idx == sniffer->capt_dur_frms) {
+			stats->rx_ant0_frames += lane->rx_ant0_idx;
+			lane->rx_ant0_idx = 0;
+			lane->rx_dma_done |= (AIC_DMA_DONE << frame.ant);
+		}
+		rf_rx_frame(lane->rf_dev, &frame);
+		out_be32(&regs->aic_dma_isr, ANT0_RIQTI);
+	}
+
+	if (flag & ANT1_RIQTI) {
+		frame.ant = 1;
+		frame.buf.buffer_idx = lane->rx_ant1_idx;
+		lane->rx_ant1_idx += displacement;
+		if (lane->rx_ant1_idx == sniffer->capt_dur_frms) {
+			stats->rx_ant1_frames += lane->rx_ant1_idx;
+			lane->rx_ant1_idx = 0;
+			lane->rx_dma_done |= (AIC_DMA_DONE << frame.ant);
+		}
+		rf_rx_frame(lane->rf_dev, &frame);
+		out_be32(&regs->aic_dma_isr, ANT1_RIQTI);
+	}
+
+	if ((lane->rx_dma_done == lane->rx_dma_done_mask) &&
+		sniffer->capture_done) {
+		rf_sniff_done(lane->rf_dev, frame.ant);
+		lane->rf_dev->data_chans_enabled = 0;
+		val = in_be32(&regs->aic_dma_dcr);
+		val &= ~RIQE;
+		out_be32(&regs->aic_dma_dcr, val);
+		lane->rx_dma_done = 0;
+	}
+}
+
+static irqreturn_t aic_dsp_gen_isr(int irq, void *arg)
+{
+	struct aic_dev *dev = (struct aic_dev *) arg;
+	struct aic_lane *lane;
+	int i;
+	u32 val;
+
+	/* GIR_ANT register does not latch status bits,
+	 * it samples the interrupt line and reports status
+	 * thus there is no need to clear status bits which
+	 * are set in GIR_ANT
+	 */
+
+	val = in_be32(dev->gir_ant);
+	if (!(val & AIC_IRQ_ANT29))
+		return IRQ_HANDLED;
+
+	/* Traverse the 6 lanes of aic dev to find the lane on which
+	 * DMA threshold interrupts are coming */
+
+	for (i = 0; i < 6; i++) {
+		lane = dev->lanes[i];
+		if (!lane || lane->rf_dev->state < RF_INITIALIZED)
+			continue;
+		else {
+			val = in_be32(&lane->regs->aic_dma_isr);
+			val &= (ANT0_RIQTI | ANT1_RIQTI);
+			if (val)
+				aic_dma_isr(lane, val);
+		}
+	}
+
+	return IRQ_HANDLED;
+
+}
+
+static int aic_adilane_init(struct aic_lane *lane,
+	struct rf_init_params *params)
+{
+	struct aic_common_regs *common_regs;
+	struct device *dev = lane->aic->dev;
+	u32 val, temp;
+
+	common_regs = lane->aic->regs;
+	/*txrx mode*/
+	switch (params->tx_rxmode) {
+	case TXRX_1T1R:
+		val = TXRX_MODE_1T1R;
+		break;
+	case TXRX_1T2R:
+		val = TXRX_MODE_1T2R;
+		break;
+	case TXRX_2T2R:
+		val = TXRX_MODE_2T2R;
+		break;
+	default:
+		dev_err(dev, "Invalid tx_rx mode %d\n", params->tx_rxmode);
+		return -EINVAL;
+	}
+
+	val |= ADI_MCLK_EN;
+
+	/*XXX: If JESD_MODE_EN is not set then ADI does not move to
+	 * Tx ENSM state and it has to be manually moved to tx by
+	 * SPI writes, otherwise no data is transmitted. This  needs
+	 * to be debugged once info about probe points on ADI card is
+	 * available
+	 */
+	if (params->mode == LTE_TDD)
+		val |= (HALF_DUPLEX | SINGLE_PORT);
+
+	if (lane->id == 3)
+		temp = (u32)(u32 *)(&common_regs->jesd3_cntl);
+	else
+		temp = (u32)((u32 *)(&common_regs->jesd0_cntl) +
+			(2 * lane->id));
+	out_be32((u32 *)temp, val);
+
+	return 0;
+}
+
+int aic_get_dev_params(struct rf_ctrl_dev *rf_dev,
+	struct rf_init_params *init_params)
+{
+	struct rf_dev_params *params = &rf_dev->dev_params;
+	struct aic_lane *lane = rf_dev->priv;
+	struct device *dev = lane->aic->dev;
+
+	if ((init_params->mode == LTE_TDD) || (init_params->mode == LTE_FDD)) {
+		switch (init_params->bw) {
+
+		case BW_05_MHZ:
+			params->symbol_len = 512;
+			params->chips_per_slot = 3840;
+			if (init_params->long_cp) {
+				params->cp0_len = 128;
+				params->cp1_len = 128;
+			} else {
+				params->cp0_len = 40;
+				params->cp1_len = 36;
+			}
+			break;
+		case BW_10_MHZ:
+			params->symbol_len = 1024;
+			params->chips_per_slot = 7680;
+			if (init_params->long_cp) {
+				params->cp0_len = 256;
+				params->cp1_len = 256;
+			} else {
+				params->cp0_len = 80;
+				params->cp1_len = 72;
+			}
+			break;
+		case BW_15_MHZ:
+			params->symbol_len = 1536;
+			params->chips_per_slot = 11520;
+			if (init_params->long_cp) {
+				params->cp0_len = 384;
+				params->cp1_len = 384;
+			} else {
+				params->cp0_len = 120;
+				params->cp1_len = 108;
+			}
+			break;
+		case BW_20_MHZ:
+			params->symbol_len = 2048;
+			params->chips_per_slot = 15360;
+			if (init_params->long_cp) {
+				params->cp0_len = 512;
+				params->cp1_len = 512;
+			} else {
+				params->cp0_len = 160;
+				params->cp1_len = 144;
+			}
+			break;
+		default:
+			dev_dbg(dev, "%s: Bandwidth %d not supported\n",
+				rf_dev->name, init_params->bw);
+			return -EINVAL;
+		}
+		params->subfrm_per_frm = 10;
+		params->slots_per_subfrm = 2;
+		if (init_params->long_cp)
+			params->symbols_per_slot = 6;
+		else
+			params->symbols_per_slot = 7;
+	} else {
+		params->symbol_len = 16;
+		params->chips_per_slot = 256;
+		params->subfrm_per_frm = 15;
+		params->slots_per_subfrm = 10;
+		params->symbols_per_slot = 16;
+	}
+	params->long_cp = init_params->long_cp;
+	params->ants = init_params->ants;
+
+	return 0;
+}
+
+
+static int init_lte_tdd_frame_struct(struct rf_ctrl_dev *rf_dev,
+	struct rf_init_params *init_params)
+{
+	int rc = 0, i, sym_len_short, sym_len_long;
+	int short_syms, long_syms, chips_per_tti;
+	u32 subfrm_enable_mask, dl_slot_val = 0, ul_slot_val = 0;
+	u32 val, spl_slot_val = 0, uppts_len, dwpts_len;
+	struct aic_lane *lane = rf_dev->priv;
+	struct rf_dev_params *params = &rf_dev->dev_params;
+	struct aic_lane_regs *regs;
+	struct device *dev = lane->aic->dev;
+
+	regs = lane->regs;
+
+	/* aic_lane_dlslot/aic_lane_ulslot registers have 1 bit
+	 * per slot. But they are always enabled/disabled in pairs
+	 * i.e on subframe basis, thats why we have mask 0x3 (Enable
+	 * both slots of subframe 0)
+	 */
+	subfrm_enable_mask = 0x3;
+
+	for (i = 0; i < LTE_SUBFRM_PER_FRM; i++) {
+
+		switch (init_params->tdd_dl_ul_conf[i]) {
+		case RF_LTE_TDD_DL:
+			dl_slot_val |= subfrm_enable_mask << (i * 2);
+			break;
+
+		case RF_LTE_TDD_UL:
+			ul_slot_val |= subfrm_enable_mask << (i * 2);
+			break;
+
+		case RF_LTE_TDD_SPL:
+			spl_slot_val |= subfrm_enable_mask << (i * 2);
+			break;
+
+		default:
+			dev_err(dev, "Invalid tdd frame structure\n");
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
+	out_be32(&regs->aic_lane_dlslot, dl_slot_val);
+	out_be32(&regs->aic_lane_ulslot, ul_slot_val);
+	out_be32(&regs->aic_lane_spslot, spl_slot_val);
+
+	sym_len_short = params->symbol_len + params->cp1_len;
+	sym_len_long = params->symbol_len + params->cp0_len;
+
+	/*DWPTS/UPPTS is programmed in chips, where as from user space
+	 * they come in terms of symbols. Conversion also takes
+	 * case of using right symbol lengths, for example if
+	 * uppts is 3 symbols then we have 2 short symbols and
+	 * one long
+	 */
+	long_syms = (init_params->tdd_dwpts + params->symbols_per_slot)/
+			params->symbols_per_slot;
+	short_syms  = init_params->tdd_dwpts - long_syms;
+	dwpts_len = (sym_len_short * short_syms) + (sym_len_long * long_syms);
+
+	val = ((dwpts_len - 1) & DWPTS_MASK) << DWPTS_SHIFT;
+
+	uppts_len = sym_len_short * init_params->tdd_uppts;
+
+	val |= ((uppts_len - 1) & UPPTS_MASK) << UPPTS_SHIFT;
+
+	out_be32(&regs->aic_netw_conf2, val);
+
+	dev_dbg(dev, "dwpts %d, gp %d, uppts %d\n", init_params->tdd_dwpts,
+		init_params->tdd_gp, init_params->tdd_uppts);
+
+	dev_dbg(dev, "[chips] dwpts %d, uppts %d\n", dwpts_len, uppts_len);
+
+	chips_per_tti = params->chips_per_slot * params->slots_per_subfrm;
+	val = chips_per_tti - uppts_len;
+	val = val - 1;
+
+	out_be32(&regs->aic_netw_conf3, val);
+out:
+	return rc;
+}
+
+static int aic_init(struct rf_ctrl_dev *rf_dev,
+		struct rf_init_params *init_params)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	struct rf_dev_params *params = &rf_dev->dev_params;
+	struct aic_dev *aic = lane->aic;
+	struct aic_common_regs *common_regs;
+	struct aic_lane_regs *regs;
+	struct device *dev = lane->aic->dev;
+	u32 val, temp, sym0_len, rest_syms_len;
+	int rc = 0, agc_strobe_shift;
+
+	if (rf_dev->bw != init_params->bw ||
+		rf_dev->tx_rxmode != init_params->tx_rxmode ||
+		rf_dev->net_mode != init_params->mode ||
+		params->long_cp != init_params->long_cp)
+		rf_dev->rftimer_started = 0;
+
+	rc = aic_get_dev_params(rf_dev, init_params);
+	if (rc)
+		goto out;
+
+	common_regs = lane->aic->regs;
+	regs = lane->regs;
+
+	out_be32(&regs->rftimer_isr, 0x7f);
+
+	if (init_params->ul_delay)
+		temp = init_params->ul_delay & UL_DELAY_MASK;
+	else
+		temp = DEFAULT_UL_DELAY & UL_DELAY_MASK;
+
+	val = temp << UL_DELAY_SHIFT;
+
+	if (init_params->dl_delay)
+		temp = init_params->dl_delay & DL_DELAY_MASK;
+	else
+		temp = DEFAULT_DL_DELAY & DL_DELAY_MASK;
+
+	val |= temp << DL_DELAY_SHIFT;
+	out_be32(&regs->aic_dlul_delay, val);
+
+	rc = aic_adilane_init(lane, init_params);
+	if (rc)
+		goto out;
+
+	/*Frame structure*/
+	temp = ((params->subfrm_per_frm - 1) & SUBFRM_PER_FRM_MASK);
+	temp <<= SUBFRM_PER_FRM_SHIFT;
+	val = temp;
+	temp = ((params->slots_per_subfrm - 1) & SLOT_PER_SUBFRM_MASK);
+	temp = temp << SLOT_PER_SUBFRM_SHIFT;
+	val |= temp;
+
+	temp = ((params->chips_per_slot - 1) & CHIPS_PER_SLOT_MASK);
+	temp <<= CHIPS_PER_SLOT_SHIFT;
+	val |= temp;
+	out_be32(&regs->aic_frame_conf, val);
+
+	/*Network conf*/
+	temp = params->chips_per_slot * params->slots_per_subfrm;
+	val = in_be32(&regs->aic_netw_conf1);
+	val |= (temp & TOTAL_LEN_MASK) << TOTAL_LEN_SHIFT;
+	temp = ((params->symbols_per_slot - 1) & SYM_PER_SLOT_MASK);
+	temp <<= SYM_PER_SLOT_SHIFT;
+	val |= temp;
+	out_be32(&regs->aic_netw_conf1, val);
+
+	if ((init_params->mode == LTE_FDD) ||
+		(init_params->mode == WCDMA_FDD)) {
+		/*Enable transmission from slot0 - slot19*/
+		out_be32(&regs->aic_lane_dlslot, 0xfffff);
+		out_be32(&regs->aic_lane_ulslot, 0xfffff);
+	} else if (init_params->mode == LTE_TDD) {
+		rc = init_lte_tdd_frame_struct(rf_dev, init_params);
+		if (rc)
+			goto out;
+	}
+	sym0_len = params->symbol_len + params->cp0_len;
+	rest_syms_len = params->symbol_len + params->cp1_len;
+
+	/* AIC starts counting from 0, so program len - 1*/
+	sym0_len--;
+	rest_syms_len--;
+
+	out_be32(&regs->aic_symconf0, sym0_len);
+	out_be32(&regs->aic_symconf1, rest_syms_len);
+	out_be32(&regs->aic_symconf2, rest_syms_len);
+	out_be32(&regs->aic_symconf3, rest_syms_len);
+	out_be32(&regs->aic_symconf4, rest_syms_len);
+	out_be32(&regs->aic_symconf5, rest_syms_len);
+	if (!init_params->long_cp)
+		out_be32(&regs->aic_symconf6, rest_syms_len);
+	else
+		out_be32(&regs->aic_symconf6, 0);
+
+	if (init_params->mode == WCDMA_FDD) {
+		out_be32(&regs->aic_symconf6, rest_syms_len);
+		out_be32(&regs->aic_symconf7, 15);
+		temp = CHIPRATE_REFCLK_WCDMA - 1;
+	}
+
+	else
+		temp = CHIPRATE_REFCLK - 1;
+	out_be32(&regs->aic_ref_framconf, temp);
+
+	/* Connect AGC_STROBE of this lane. For lane 0, 1
+	 * AGC_STROBE_1 is used and for lne 2 AGC_STROBE_2
+	 * is used
+	 */
+	switch (lane->id) {
+	case 0:
+	case 1:
+		agc_strobe_shift = AGC_STROBE_1_SHIFT;
+		break;
+	case 2:
+		agc_strobe_shift = AGC_STROBE_2_SHIFT;
+		break;
+	default:
+		dev_err(dev, "Strobe for lane %d not defined\n", lane->id);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	spin_lock(&aic->lock);
+
+	val = in_be32(&common_regs->aic_interconnect);
+	val &= ~(AGC_STROBE_MASK << agc_strobe_shift);
+	val |=  (lane->id << agc_strobe_shift);
+	out_be32(&common_regs->aic_interconnect, val);
+
+	spin_unlock(&aic->lock);
+
+	/* Generate AGC_STROBE on RL delayed TTI */
+	val = in_be32(&regs->aic_lane_tmctrl);
+	val &= ~AGC_STRB_SEL_MASK;
+	val |= AGC_STRB_SEL_TTI_RLD;
+	out_be32(&regs->aic_lane_tmctrl, val);
+
+	rf_dev->net_mode = init_params->mode;
+	rf_dev->bw = init_params->bw;
+	rf_dev->tx_rxmode = init_params->tx_rxmode;
+
+	return rc;
+out:
+	rf_dev->data_chans_enabled = 0;
+	return rc;
+}
+
+static int aic_channel_open(struct rf_ctrl_dev *rf_dev,
+		struct rf_channel *chan)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	struct aic_lane_regs *regs = lane->regs;
+	struct device *dev = lane->aic->dev;
+	u32 val;
+
+	/* Currently DMA configuration is done only for receive path.*/
+	if (chan->flags & RF_CHAN_DIR_TX) {
+		dev_err(dev, "Channel open for TX not supported\n");
+		return -EINVAL;
+	}
+	if (lane->num_chan == AIC_MAX_NUM_CHANNELS) {
+		dev_err(dev, "AIC DMA channel more than %d not supported\n",
+				AIC_MAX_NUM_CHANNELS);
+		return -EINVAL;
+	}
+	if (lane->num_chan == 1) {
+		val = in_be32(&regs->aic_dma_riqbs);
+		if ((val & RIQBS_MASK) != chan->rx_buf_size) {
+			dev_err(dev, "Rx buffer size should be same "
+					"for both channels\n");
+			return -EINVAL;
+		}
+	}
+	lane->num_chan++;
+	/*
+	 * Lane specific configuration should be done only once for
+	 * multiple channels.
+	 */
+
+	if (lane->num_chan == 1) {
+
+		/* clear DMA registers to re-configure */
+		out_be32(&regs->aic_dma_dmsr, 0);
+		out_be32(&regs->aic_dma_dcr, 0);
+		out_be32(&regs->aic_dma_ier, 0);
+
+		val = in_be32(&regs->aic_dma_dmsr);
+
+		/* RDD for PA side DMA should be unicast to system memory */
+		val &= RDD_MASK;
+		val |= RDD_UNI_SYS_MEM;
+
+		if (chan->flags & RF_CHAN_XFER_MODE_SNIFF)
+			val &= ~DBL_BUF_MODE;
+		else if (chan->flags & RF_CHAN_XFER_MODE_LTE)
+			val |= DBL_BUF_MODE;
+
+		if (rf_dev->net_mode == WCDMA_FDD) {
+			/* oversampling is enabled for WCDMA. */
+			val &= RX_OVERSAMPLING;
+
+			/* Receive sample width is 8 bit for IQ samples */
+			val |= RSW_8B;
+		} else {
+			/* oversampling is disabled by default. */
+			val &= ~RX_OVERSAMPLING;
+
+			/* Receive sample width is 16 bit for IQ samples */
+			val |= RSW_16B;
+		}
+		out_be32(&regs->aic_dma_dmsr, val);
+
+		/* Set receive IQ buffer size */
+		val = chan->rx_buf_size & RIQBS_MASK;
+		out_be32(&regs->aic_dma_riqbs, val);
+	}
+	if (chan->ant == 0) {
+		/* Enable Receive IQ threshold interrupt for ANT0 */
+		val = in_be32(&regs->aic_dma_ier);
+		val |= (ANT0_RIQTIE | RIQOIE);
+		out_be32(&regs->aic_dma_ier, val);
+		if (chan->flags & RF_CHAN_MMAPED) {
+			val = chan->bufs.mmap_bufs.rx_base_phys
+					& RIQBA_MASK;
+			out_be32(&regs->aic_dma_riqba0, val);
+		}
+	} else {
+		/* Enable Receive IQ threshold interrupt for ANT1 */
+		val = in_be32(&regs->aic_dma_ier);
+		val |= (ANT1_RIQTIE | RIQOIE);
+		out_be32(&regs->aic_dma_ier, val);
+		if (chan->flags & RF_CHAN_MMAPED) {
+			val = chan->bufs.mmap_bufs.rx_base_phys
+					& RIQBA_MASK;
+			out_be32(&regs->aic_dma_riqba1, val);
+		}
+	}
+	/* Enable DSP general interrupt */
+	out_be32(lane->aic->gir_ant_en_mpic, AIC_IRQ_ANT29);
+
+	return 0;
+}
+
+static int aic_channel_close(struct rf_ctrl_dev *rf_dev,
+		struct rf_channel *chan)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	struct aic_common_regs *common_regs = lane->aic->regs;
+	struct aic_sniffer *sniffer = lane->sniffer;
+	struct aic_lane_regs *regs;
+	struct device *dev = lane->aic->dev;
+	u32 val;
+	int rc = 0, retries = 0;
+
+	regs = lane->regs;
+	lane->num_chan--;
+	if (lane->num_chan == 0) {
+		/* Disable DSP general interrupt */
+		val = in_be32(lane->aic->gir_ant_en_mpic);
+		val &= ~AIC_IRQ_ANT29;
+		out_be32(lane->aic->gir_ant_en_mpic, val);
+
+		/* Disable capture complete interrupt */
+		if (sniffer) {
+			val = in_be32(&sniffer->regs->aic_sniff_inten);
+			val &= ~CAP_INT_EN;
+			out_be32(&sniffer->regs->aic_sniff_inten, val);
+		}
+		/* Disable Receive DMA */
+		val = in_be32(&regs->aic_dma_dcr);
+		val &= ~RIQE;
+		out_be32(&regs->aic_dma_dcr, val);
+
+		val = in_be32(&regs->aic_dma_dsr);
+		while ((val & RIQS) && retries < DMA_STATUS_RETRIES) {
+			val = in_be32(&regs->aic_dma_dsr);
+			mdelay(1);
+			retries++;
+		}
+		if (val & RIQS) {
+			dev_err(dev, "RIQS did not clear \n");
+			rc = -EBUSY;
+			goto out;
+		}
+		/* Set Receive IQ Threshold as 0 */
+		out_be32(&regs->aic_dma_riqt, 0);
+
+		/* Set receive IQ buffer size as 0*/
+		out_be32(&regs->aic_dma_riqbs, 0);
+
+		if (sniffer) {
+			/* disable PPC sniff capt done interrupt */
+			spin_lock(&lane->aic->lock);
+			val = in_be32(&common_regs->ppc_interrupt_ctrl_reg);
+			if (sniffer->id == 0)
+				val &= ~IE_PPC_SNIFF0_CAPT_DONE_INT;
+			else if (sniffer->id == 1)
+				val &= ~IE_PPC_SNIFF1_CAPT_DONE_INT;
+			out_be32(&common_regs->ppc_interrupt_ctrl_reg, val);
+			spin_unlock(&lane->aic->lock);
+		}
+		/* clear DMA registers */
+		out_be32(&regs->aic_dma_dmsr, 0);
+		out_be32(&regs->aic_dma_dcr, 0);
+		out_be32(&regs->aic_dma_ier, 0);
+	}
+
+	/* Disable Receive IQ threshold interrupt */
+	if (chan->ant == 0) {
+		val = in_be32(&regs->aic_dma_ier);
+		val &= ~(ANT0_RIQTIE | RIQOIE);
+		out_be32(&regs->aic_dma_ier, val);
+		out_be32(&regs->aic_dma_riqba0, 0);
+	} else {
+		val = in_be32(&regs->aic_dma_ier);
+		val &= ~(ANT1_RIQTIE | RIQOIE);
+		out_be32(&regs->aic_dma_ier, val);
+		out_be32(&regs->aic_dma_riqba1, 0);
+	}
+
+out:
+	return rc;
+}
+
+static struct aic_sniffer *aic_get_sniffer(struct aic_lane *lane)
+{
+	struct aic_dev *aic = lane->aic;
+	struct aic_sniffer *sniffer = NULL;
+	int i;
+
+	/* Currently we search for available sniffer, and assign to the lane
+	 * If required we can give specific sniffer to a lane as well
+	 * that's why we take lane as parameter for this function
+	 */
+	for (i = 0; i < AIC_NUM_SNIFFER_BLKS; i++) {
+		sniffer = &aic->sniffers[i];
+		if (atomic_xchg(&sniffer->in_use, 1))
+			sniffer = NULL;
+		else
+			break;
+	}
+
+	if (sniffer) {
+		sniffer->lane = lane;
+		lane->sniffer = sniffer;
+		atomic_inc(&aic->sniffers_in_use);
+	}
+
+	return sniffer;
+}
+
+static void aic_free_sniffer(struct aic_sniffer *sniffer)
+{
+	struct aic_lane *lane;
+	struct aic_sniff_regs *sniff_regs = sniffer->regs;
+	u32 val;
+
+	spin_lock(&sniffer->lock);
+
+	atomic_set(&sniffer->in_use, 0);
+	val = in_be32(&sniff_regs->aic_sniff_ctrl);
+	val &= ~(REFCNT_EN | CHP_SEL_MASK | REF_SEL_MASK);
+	out_be32(&sniff_regs->aic_sniff_ctrl, val);
+	sniffer->intialized = 0;
+	sniffer->gps_synced = 0;
+	lane = sniffer->lane;
+	sniffer->lane = NULL;
+	if (lane) {
+		lane->sniffer = NULL;
+		if (!atomic_dec_and_test(&lane->aic->sniffers_in_use))
+			lane->aic->sniff_timing_src = RF_PPS_SRC_END;
+	}
+	spin_unlock(&sniffer->lock);
+}
+
+static int aic_start_sniffer(struct aic_sniffer *sniffer)
+{
+	struct aic_lane *lane = sniffer->lane;
+	struct aic_lane_stats *stats = &lane->stats;
+	struct rf_ctrl_dev *rf_dev = lane->rf_dev;
+	struct device *dev = lane->aic->dev;
+	struct aic_sniff_regs  *sniff_regs = sniffer->regs;
+	u32 val;
+	int rc = 0, i;
+
+	if (!sniffer->intialized) {
+		dev_err(dev, "Sniffer must be intialized before starting\n");
+		return -EAGAIN;
+	}
+
+	if (!sniffer->gps_synced) {
+		spin_lock(&sniffer->lock);
+		val = in_be32(&sniff_regs->aic_sniff_ctrl);
+		val |= GPS_SYNC;
+		out_be32(&sniff_regs->aic_sniff_ctrl, val);
+		spin_unlock(&sniffer->lock);
+
+		for (i = 0; i < SYNC_WAIT; i++) {
+			val = in_be32(&sniff_regs->aic_sniff_ctrl);
+			if (!(val & GPS_SYNC)) {
+				dev_info(dev, "%s:sniffer: GPS_SYNC cleared\n",
+						rf_dev->name);
+				break;
+			}
+			mdelay(100);
+		}
+
+		spin_lock(&sniffer->lock);
+		val = in_be32(&sniff_regs->aic_sniff_ctrl);
+		if (val & GPS_SYNC) {
+			dev_err(dev, "%s:sniffer: GPS_SYNC did not clear\n",
+				rf_dev->name);
+			rc = -EAGAIN;
+			spin_unlock(&sniffer->lock);
+			goto out;
+		}
+
+		sniffer->gps_synced = 1;
+		val |= REFCNT_EN;
+		out_be32(&sniff_regs->aic_sniff_ctrl, val);
+		spin_unlock(&sniffer->lock);
+	}
+
+	if (rf_dev->data_chans_enabled) {
+		/* Enable Receive DMA */
+		val = in_be32(&lane->regs->aic_dma_dcr);
+		val |= RIQE;
+		out_be32(&lane->regs->aic_dma_dcr, val);
+
+		mdelay(1);
+		/* start capture*/
+		spin_lock(&sniffer->lock);
+		val = in_be32(&sniff_regs->aic_sniff_ctrl);
+		val |= CAP_EN;
+		out_be32(&sniff_regs->aic_sniff_ctrl, val);
+		spin_unlock(&sniffer->lock);
+		stats->prev_disp = in_be32(&lane->regs->aic_dma_riqbdr);
+	}
+
+out:
+	return rc;
+}
+
+int aic_init_sniff_regs(struct aic_sniffer *sniffer,
+	       struct rf_sniff_params *sniff_params)
+{
+	struct aic_sniff_regs  *sniff_regs = sniffer->regs;
+	struct rf_init_params  *dev_params = &sniff_params->dev_params;
+	struct aic_lane *lane = sniffer->lane;
+	u32 val;
+
+	spin_lock(&sniffer->lock);
+
+	val = in_be32(&sniff_regs->aic_sniff_ctrl);
+	val &= ~(REF_SEL_MASK | CHP_SEL_MASK);
+
+	if (lane->type == AIC_LANE_ADI) {
+		val |= REF_SEL_ADI;
+		val |= (lane->id << CHP_SEL_SHIFT);
+	} else if (lane->type == AIC_LANE_MAXIM) {
+		val |= (REF_SEL_MAXPHY | CHP_SEL_MAXPHY);
+	}
+	val |= REFCNT_EN;
+
+	out_be32(&sniff_regs->aic_sniff_ctrl, val);
+
+	if (!lane->rf_dev->data_chans_enabled) {
+		spin_unlock(&sniffer->lock);
+		goto out;
+	}
+
+	val = DEFAULT_ROLLOVER;
+	out_be32(&sniff_regs->aic_sniff_refcnt, val);
+
+	val = in_be32(&sniff_regs->aic_sniff_ctrl);
+	val |= PRE_CAP_EN;
+	out_be32(&sniff_regs->aic_sniff_ctrl, val);
+
+	/* default capture offset is programmed as 0 */
+	val = DEFAULT_CAPT_OFF;
+	out_be32(&sniff_regs->aic_sniff_capt_off, val);
+
+	/* Set capture duration according to user space value
+	 * (user space value is in number of subframes).
+	 * capt_dur should be programmed in number of chips
+	 */
+
+	sniffer->capt_dur_frms = sniff_params->capture_duration;
+	val = sniff_params->capture_duration *
+		lane->rf_dev->dev_params.chips_per_slot *
+		lane->rf_dev->dev_params.slots_per_subfrm;
+
+	out_be32(&sniff_regs->aic_sniff_capt_dur, val);
+
+	/* Enable capture complete interrupt */
+	val = in_be32(&sniff_regs->aic_sniff_inten);
+	val |= CAP_INT_EN;
+	out_be32(&sniff_regs->aic_sniff_inten, val);
+
+	sniffer->capture_done = 0;
+	if ((dev_params->tx_rxmode == TXRX_2T2R) ||
+		(dev_params->tx_rxmode == TXRX_1T2R)) {
+		/*Set rx_dma_done_mask for ant 0 and 1*/
+		lane->rx_dma_done_mask = (AIC_DMA_DONE << 0) |
+						(AIC_DMA_DONE << 1);
+	} else {
+		/*Set rx_dma_done_mask for ant 0 */
+		lane->rx_dma_done_mask = (AIC_DMA_DONE << 0);
+	}
+	spin_unlock(&sniffer->lock);
+	udelay(150);
+out:
+	return 0;
+}
+
+int aic_init_sniffer(struct aic_sniffer *sniffer,
+		struct rf_sniff_params *sniff_params)
+{
+	struct aic_lane *lane = sniffer->lane;
+	struct aic_lane_regs *lane_regs;
+	struct device *dev;
+	struct aic_common_regs *common_regs;
+	struct aic_dev *aic;
+	struct rf_ctrl_dev *rf_dev;
+	struct rf_dev_params *params;
+	u32 val, sniffer_connectivity;
+	int rc = 0;
+
+	if (!lane)
+		return -EINVAL;
+
+	aic = lane->aic;
+	dev = aic->dev;
+	common_regs = aic->regs;
+	lane_regs = lane->regs;
+	rf_dev = lane->rf_dev;
+	params = &rf_dev->dev_params;
+
+	rc = aic_adilane_init(lane, &sniff_params->dev_params);
+	if (rc)
+		return rc;
+
+	spin_lock(&aic->lock);
+	/*Connect Sniffer to Lane*/
+	val = in_be32(&common_regs->aic_interconnect);
+	sniffer_connectivity = 1 << lane->id;
+
+	if (sniffer->id == 1)
+		val |= sniffer_connectivity;
+	else if (sniffer->id == 0)
+		val &= ~sniffer_connectivity;
+	else {
+		dev_err(dev, "sniffer id seems to be wrong %d\n", sniffer->id);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if ((aic->sniff_timing_src != RF_PPS_SRC_END) &&
+		(aic->sniff_timing_src != sniff_params->timing_src)) {
+
+		dev_err(dev, "sniffer GPS pulse is common for both sniffers\n");
+		dev_err(dev, "Currently active sniffer timing src %d,\
+			can not change it to %d\n", aic->sniff_timing_src,
+				sniff_params->timing_src);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	switch (sniff_params->timing_src) {
+	case RF_PPS_SRC_GPS:
+	case RF_PPS_SRC_PTP:
+		val |= GPS_SNIFF_GPS_ETSEC_PULSE;
+		break;
+	case RF_PPS_SRC_RAW_GPS:
+		val |= GPS_SNIFF_GPS_PPS_REFCLK_IN;
+		break;
+	default:
+		dev_err(dev, "Invalid time sync src [%x]for sniffer %d\n",
+				sniff_params->timing_src, sniffer->id);
+		rc = -EINVAL;
+		goto out;
+	}
+	aic->sniff_timing_src = sniff_params->timing_src;
+	out_be32(&common_regs->aic_interconnect, val);
+	spin_unlock(&aic->lock);
+
+	if (lane->rf_dev->data_chans_enabled) {
+		/* Disable uplink and downlink of AIC */
+		val = in_be32(&lane_regs->aic_netw_conf1);
+		val &= ~(DL_EN | UL_EN);
+		out_be32(&lane_regs->aic_netw_conf1, val);
+		mdelay(2);
+
+		val = in_be32(&lane_regs->aic_dma_dmsr);
+		val |= (RXENSEL_SNIFFER | RXNOACK);
+
+		/* Set number of receive antennas */
+		if (sniff_params->dev_params.tx_rxmode == TXRX_2T2R ||
+			sniff_params->dev_params.tx_rxmode == TXRX_1T2R)
+			val |= RNA_2ANT;
+		else
+			val &= ~RNA_2ANT;
+		out_be32(&lane_regs->aic_dma_dmsr, val);
+
+		/* Set Receive IQ Threshold as 1 sub frame in bytes
+		 * and 1 chip = 4B */
+		val = params->chips_per_slot * params->slots_per_subfrm * 4;
+		out_be32(&lane_regs->aic_dma_riqt, val);
+
+		spin_lock(&aic->lock);
+		/* Enable PPC sniff capt done interrupt */
+		val = in_be32(&common_regs->ppc_interrupt_ctrl_reg);
+		if (sniffer->id == 0)
+			val |= IE_PPC_SNIFF0_CAPT_DONE_INT;
+		else if (sniffer->id == 1)
+			val |= IE_PPC_SNIFF1_CAPT_DONE_INT;
+		out_be32(&common_regs->ppc_interrupt_ctrl_reg, val);
+		spin_unlock(&aic->lock);
+	}
+	rc = aic_init_sniff_regs(sniffer, sniff_params);
+
+	sniffer->intialized = 1;
+	return rc;
+out:
+	spin_unlock(&aic->lock);
+	return rc;
+}
+
+static int aic_config_sniff(struct rf_ctrl_dev *rf_dev,
+		struct rf_sniff_params *sniff_params)
+{
+	struct aic_lane *lane = rf_dev->priv;
+	struct device *dev = lane->aic->dev;
+	int rc = 0;
+
+	/* Get us a sniffer if we don't have one */
+	if (!lane->sniffer) {
+		if (!aic_get_sniffer(lane)) {
+			dev_err(dev, "Could not get sniffer for Lane %d\n",
+			lane->id);
+			rc = -EBUSY;
+			goto out;
+		}
+	}
+
+	if (sniff_params->dev_params.capture_enabled)
+		rf_dev->data_chans_enabled = 1;
+
+	/* We intialize RF timer also with same parameters as sniff
+	 * If RF timer has never been intialized before this
+	 * config_sniff request. Otherwise we don't touch RF timer
+	 * again, because user space is free to intialize RF timer
+	 * and sniffer differently
+	 */
+	if (rf_dev->old_state != RF_INITIALIZED) {
+		rc = aic_init(rf_dev, &sniff_params->dev_params);
+		if (rc) {
+			dev_err(dev, "sniff: Failed to init aic lane, err %d",
+					rc);
+			goto out;
+		}
+	}
+
+	rc = aic_init_sniffer(lane->sniffer, sniff_params);
+	if (rc)
+		goto out;
+
+	return rc;
+out:
+	if (lane->sniffer)
+		aic_free_sniffer(lane->sniffer);
+
+	rf_dev->data_chans_enabled = 0;
+	return rc;
+}
+
+static int aic_probe(struct platform_device *ofdev)
+{
+	int rc = 0, *lane_id, i;
+	struct device_node *np = ofdev->dev.of_node, *np1;
+	struct device *dev = &ofdev->dev;
+	struct device_node *child = NULL;
+	struct rf_ctrl_dev *rf_dev;
+	struct aic_lane *lane;
+	static struct aic_dev *aic_dev;
+	struct aic_sniffer *sniffer;
+	void *regs;
+	u32 *gcr_reg;
+
+	if (!np || !of_device_is_available(np))
+		return -ENODEV;
+
+	aic_dev = kzalloc(sizeof(struct aic_dev), GFP_KERNEL);
+	if (!aic_dev) {
+		dev_dbg(dev, "Failed to allocate aic_dev\n");
+		return -ENOMEM;
+	}
+	aic_dev->dev = dev;
+	spin_lock_init(&aic_dev->lock);
+	aic_dev->regs = of_iomap(np, 0);
+	if (!aic_dev->regs) {
+		dev_dbg(dev, "aic: aic_dev iomap failed\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	aic_dev->sniff_irq = irq_of_parse_and_map(np, 0);
+	aic_dev->dsp_general_irq = irq_of_parse_and_map(np, 1);
+
+	rc = request_irq(aic_dev->sniff_irq, aic_sniffer_isr, 0,
+				"rf_sniff", aic_dev);
+	if (rc) {
+		dev_dbg(dev, "sniffer request_irq failed lane \n");
+		goto out;
+	}
+
+	rc = request_irq(aic_dev->dsp_general_irq, aic_dsp_gen_isr,
+			0, "dsp_general", aic_dev);
+	if (rc) {
+		dev_dbg(dev, "dma_general request_irq failed lane \n");
+		goto out;
+	}
+
+	np1 = of_find_compatible_node(NULL, NULL, "fsl,bsc9131-gcr");
+	if (!np1) {
+		rc = -ENODEV;
+		goto out;
+	}
+	gcr_reg = of_iomap(np1, 0);
+	aic_dev->gir_ant_en_mpic = (u32 *)(((u32)gcr_reg) +
+				GIR_ANT_EN_MPIC_OFFSET);
+	aic_dev->gir_ant = (u32 *)(((u32)gcr_reg) + GIR_ANT_OFFSET);
+
+	/* By default dsp general interrupt should be disabled */
+	out_be32(aic_dev->gir_ant_en_mpic, 0);
+
+	for_each_child_of_node(np, child) {
+
+		lane_id = (int *) of_get_property(child, "lane_id", NULL);
+
+		if (!lane_id)
+			continue;
+
+		regs = of_iomap(child, 0);
+		if (!regs) {
+			dev_dbg(dev, "aic:[%d] iomap failed, \n", *lane_id);
+			continue;
+		}
+		rf_dev = allocate_rf_ctrl_dev(sizeof(struct aic_lane),
+					GFP_KERNEL);
+		if (!rf_dev) {
+			dev_dbg(dev, "aic:[%d] rf_dev allocation failure\n",
+					*lane_id);
+			continue;
+		}
+		lane = (struct aic_lane *) rf_dev->priv;
+
+		lane->aic = aic_dev;
+		lane->id = *lane_id;
+		lane->regs = regs;
+		lane->irq = irq_of_parse_and_map(child, 0);
+		spin_lock_init(&lane->lock);
+		if ((lane->id == 0) || (lane->id == 1) || (lane->id == 2))
+			lane->type = AIC_LANE_ADI;
+
+		if ((lane->id == 3) || (lane->id == 4) || (lane->id == 5))
+			lane->type = AIC_LANE_MAXIM;
+
+		rf_dev->phy_id = (u32) of_parse_phandle(child,
+						"rfphy-handle", 0);
+		lane->rf_dev = rf_dev;
+		rf_dev->ops = &aic_rfops;
+		rf_dev->mode = RF_LANE_MASTER;
+		rf_dev->dev_idx = lane->id;
+		rc = register_rf_ctrl_dev(rf_dev);
+		if (rc) {
+			dev_dbg(dev, "rf_dev registration failed, lane %d\n",
+					lane->id);
+			continue;
+		}
+		rc = request_irq(lane->irq, aic_isr, IRQF_NO_SUSPEND,
+				rf_dev->name, lane);
+		if (rc) {
+			dev_dbg(dev, "request_irq failed lane %d\n",
+					lane->id);
+			continue;
+		}
+
+		aic_dev->lanes[lane->id] = lane;
+	}
+
+	for (i = 0; i < AIC_NUM_SNIFFER_BLKS; i++) {
+
+		sniffer = &aic_dev->sniffers[i];
+		sniffer->id = i;
+		sniffer->lane = NULL;
+		regs = (void *) ((u32) &aic_dev->regs->aic_sniff0_refcnt +
+				(i * sizeof(struct aic_sniff_regs)));
+		sniffer->regs = (struct aic_sniff_regs *) regs;
+		atomic_set(&sniffer->in_use, 0);
+		spin_lock_init(&sniffer->lock);
+	}
+
+	dev_set_drvdata(dev, aic_dev);
+
+	/*Make sure all interrupts are gated*/
+	out_be32(&aic_dev->regs->ppc_interrupt_ctrl_reg, 0);
+	aic_dev->sniff_timing_src = RF_PPS_SRC_END;
+	atomic_set(&aic_dev->sniffers_in_use, 0);
+
+	return rc;
+out:
+	kfree(aic_dev);
+	return rc;
+}
+
+static int aic_remove(struct platform_device *ofdev)
+{
+	struct aic_dev *aic_dev;
+	struct aic_lane *lane;
+	int i, rc = 0;
+
+	aic_dev = dev_get_drvdata(&ofdev->dev);
+	for (i = 0; i < MAX_LANE_COUNT; i++) {
+		lane = aic_dev->lanes[i];
+		rc = unregister_rf_ctrl_dev(lane->rf_dev);
+		if (rc)
+			return -EBUSY;
+
+		free_irq(lane->irq, lane);
+		rc = free_rf_ctrl_dev(lane->rf_dev);
+	}
+	if (rc)
+		return -EBUSY;
+
+	free_irq(aic_dev->sniff_irq, lane);
+	kfree(aic_dev);
+
+	return 0;
+}
+
+static struct of_device_id aic_match[] = {
+	{
+		.compatible = "fsl,bsc9131-aic",
+	},
+	{
+		.compatible = "fsl,bsc9132-aic",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, aic_match);
+
+static struct platform_driver aic_driver = {
+	.driver = {
+		.name = "fsl-aic",
+		.owner = THIS_MODULE,
+		.of_match_table = aic_match,
+	},
+	.probe = aic_probe,
+	.remove = aic_remove
+};
+
+static int __init aic_mod_init(void)
+{
+	return platform_driver_register(&aic_driver);
+}
+
+static void __exit aic_exit(void)
+{
+	platform_driver_unregister(&aic_driver);
+}
+
+module_init(aic_mod_init);
+module_exit(aic_exit);
diff --git a/drivers/misc/rf/controllers/fsl_aic.h b/drivers/misc/rf/controllers/fsl_aic.h
new file mode 100644
index 0000000..95cc16e
--- /dev/null
+++ b/drivers/misc/rf/controllers/fsl_aic.h
@@ -0,0 +1,450 @@
+/*
+ * drivers/rf/controllers/fsl_aic.h
+ * Freescale AIC (Antenna Controller Interface) driver
+ *
+ * AIC is the antenna interface controller found in bsc913x
+ * family of SOCs. It supports NCDMA, WCDMA-FDD, LTE-FDD, LTE-TDD
+ * and GSM-SNIFF network modes. AIC has 6 lanes on which RFICs
+ * can be connected. And AIC supports 4 RFICs working simultaneously.
+ * This driver provides only configuration path for all other modes
+ * except SNIFF because data from RFIC through AIC goes directly
+ * to a hardware accelerator from where it is taken out by DSP core
+ * in bsc913x.
+ *
+ * Author: pankaj chauhan <pankaj.chauhan@freescale.com>
+ *
+ * Copyright 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __FSL_AIC_H__
+#define __FSL_AIC_H__
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/spinlock.h>
+
+struct aic_common_regs {
+
+	u32	aic_ip_version;
+	u32	aic_interconnect;
+	u32	pll_cntl_0;
+	u32	pll_cntl_1;
+	u32	aic_sniff0_refcnt;
+	u32	aic_sniff0_refcnt_off;
+	u32	aic_sniff0_capt_off;
+	u32	aic_sniff0_capt_dur;
+	u32	aic_sniff_bcar;
+	u32	aic_sniff_bcbr;
+	u32	aic_sniff_brm_cntrl;
+	u32	aic_sniff0_cntrl;
+	u32	aic_sniff0_inten;
+	u32	aic_sniff0_int_stat;
+	u32	aic_sniff0_refcnt_val;
+	u32	aic_sniff0_frmint;
+	u32	reserved[6];
+	u32	aic_sniff1_refcnt;
+	u32	aic_sniff1_refcnt_off;
+	u32	aic_sniff1_capt_off;
+	u32	aic_sniff1_capt_dur;
+	u32	reserved1[3];
+	u32	aic_sniff1_cntrl;
+	u32	aic_sniff1_inten;
+	u32	aic_sniff1_int_stat;
+	u32	aic_sniff1_refcnt_val;
+	u32	aic_sniff1_frmint;
+	u32	reserved2[52];
+	u32	maxim_rxcntl;
+	u32	maxim_cntl;
+	u32	maxim_rssi;
+	u32	maxim_txcoeff_0_1;
+	u32	maxim_txcoeff_2_3;
+	u32	maxim_txcoeff_4_5;
+	u32	maxim_txcoeff_6_7;
+	u32	maxim_txcoeff_8_9;
+	u32	maxim_txcoeff_10_11;
+	u32	maxim_txcoeff_12_13;
+	u32	maxim_txcoeff_14_15;
+	u32	maxim_txcoeff_16_17;
+	u32	maxim_status;
+	u32	maxim_dlfrac_delay;
+	u32	maxim_spi_rxgain_1;
+	u32	maxim_spi_rxgain_2;
+	u32	reserved3[6];
+	u32	jesd0_cntl;
+	u32	jesd0_status;
+	u32	jesd1_cntl;
+	u32	jesd1_status;
+	u32	jesd2_cntl;
+	u32	jesd2_status;
+	u32	aic_tm_cntrl1;
+	u32	aic_interrupt_mux_ctrl_reg;
+	u32	jesd3_cntl;
+	u32	jesd3_status;
+	u32	reserved4[2];
+	u32	ppc_interrupt_ctrl_reg;
+	u32	ppc_interrupt_status_reg;
+	u32	dsp_lte_interrupt_ctrl_reg;
+	u32	dsp_lte_interrupt_status_reg;
+	u32	reserved5[4];
+};
+
+/*INTERCONNECT*/
+#define GPS_SNIFF_MASK			0x000000c0
+#define GPS_SNIFF_GPS_PPS_IN		0x00000000
+#define GPS_SNIFF_GPS_PPS_REFCLK_IN	0x00000040
+#define GPS_SNIFF_GPS_ETSEC_PULSE	0x00000080
+#define GPS_SNIFF_RESVD			0x000000c0
+#define AGC_STROBE_MASK			0x3
+#define AGC_STROBE_1_SHIFT		8
+#define AGC_STROBE_2_SHIFT		10
+#define AGC_STROBE_3_SHIFT		12
+#define AGC_STROBE_4_SHIFT		14
+
+/*JESDCNTL*/
+#define SINGLE_PORT		0x00000001
+#define HALF_DUPLEX		0x00000002
+#define SINGLE_DATA_RATE	0x00000004
+#define INVERT_CLK		0x00000020
+#define INVERT_RXFRAME		0x00000040
+#define RXF_NEGATIVE_EDGE_EN	0x00000400
+#define TXF_NEGATIVE_EDGE_EN	0x00000800
+#define RXF_TIMEOUT_EN		0x00010000
+#define ADI_MCLK_EN		0x00100000
+#define JESD_10BITS_WIDTH_EN	0x40000000
+#define JESD_MODE_EN		0x80000000
+#define	RDELAY_SHIFT		7
+#define RDELAY_MASK		(0x3 << RDELAY_SHIFT)
+#define RDELAY_0_CYCL		(0x0 << RXDATA_DELAY_SHIFT)
+#define RDELAY_1_by_2_CYCL	(0x1 << RXDATA_DELAY_SHIFT)
+#define RDELAY_1_CYCL		(0x2 << RXDATA_DELAY_SHIFT)
+#define RDELAY_3_by_2_CYCL	(0x3 << RXDATA_DELAY_SHIFT)
+#define TX_RX_MODE_SHIFT	3
+#define TXRX_MODE_MASK		(0x3 << TX_RX_MODE_SHIFT)
+#define TXRX_MODE_1T1R		(0x0 << TX_RX_MODE_SHIFT)
+#define TXRX_MODE_1T2R		(0x2 << TX_RX_MODE_SHIFT)
+#define TXRX_MODE_2T2R		(0x1 << TX_RX_MODE_SHIFT)
+
+/*AICTMCNTRL1*/
+/*These values will be shifted right
+ * by lane id before writing to AICTMCNTRL1
+ */
+#define TMCTRL_DL_EN	0x00100000
+#define TMCTRL_UL_EN	0x04000000
+
+/*PPC_INTERRUPT_CNTL_REG*/
+#define ADILANE0_DL_TTI		0x10
+#define ADILANE_DL_TTI_SHIFT	6
+#define IE_PPC_SNIFF0_CAPT_DONE_INT	0x04000000
+#define IE_PPC_SNIFF1_CAPT_DONE_INT	0x08000000
+
+/* PPC INTERRUPT STATUS REGISTER */
+#define PPC_ISR_SNIFF0_CAPT_DONE_INT	0x04000000
+#define PPC_ISR_SNIFF1_CAPT_DONE_INT	0x08000000
+
+struct aic_lane_regs {
+	u32	aic_dma_riqmts;
+	u32	aic_dma_tiqmts;
+	u32	aic_dma_riqmpl1;
+	u32	aic_dma_riqmpl23;
+	u32	aic_dma_tiqmpl1;
+	u32	aic_dma_tiqmpl23;
+	u32	aic_dma_mss;
+	u32	aic_dma_riqba0;
+	u32	aic_dma_riqba1;
+	u32	reserved[7];
+	u32	aic_dma_riqbs;
+	u32	aic_dma_rmba;
+	u32	aic_dma_rmbs;
+	u32	aic_dma_tiqba0;
+	u32	aic_dma_tiqba1;
+	u32	reserved1[8];
+	u32	aic_dma_tiqbs;
+	u32	aic_dma_dmsr;
+	u32	aic_dma_dcr;
+	u32	aic_dma_riqt;
+	u32	aic_dma_riqft;
+	u32	aic_dma_riqst;
+	u32	aic_dma_tiqt;
+	u32	aic_dma_tiqft;
+	u32	aic_dma_tiqst;
+	u32	aic_dma_ier;
+	u32	reserved2[19];
+	u32	aic_frame_conf;
+	u32	aic_netw_conf1;
+	u32	aic_netw_conf2;
+	u32	aic_netw_conf3;
+	u32	aic_dlul_delay;
+	u32	aic_lane_dlslot;
+	u32	aic_lane_ulslot;
+	u32	aic_lane_spslot;
+	u32	aic_lane_frame_count;
+	u32	aic_lane_tmctrl;
+	u32	reserved6[3];
+	u32	aic_symconf0;
+	u32	aic_symconf1;
+	u32	aic_symconf2;
+	u32	aic_symconf3;
+	u32	aic_symconf4;
+	u32	aic_symconf5;
+	u32	aic_symconf6;
+	u32	aic_symconf7;
+	u32	aic_int_pretime;
+	u32	aic_ref_framconf;
+	u32	aic_lane_frame_rollover;
+	u32	reserved3;
+	u32	aic_dma_isr;
+	u32	aic_dma_miar;
+	u32	aic_dma_dsr;
+	u32	aic_dma_riqbdr;
+	u32	aic_dma_tiqbdr;
+	u32	reserved4[4];
+	u32	rftimer_intr_ctrl;
+	u32	rftimer_isr;
+	u32	reserved5[34];
+};
+
+/*AICFRAMCONF*/
+#define SUBFRM_PER_FRM_SHIFT	21
+#define SUBFRM_PER_FRM_MASK	0x3f
+#define SLOT_PER_SUBFRM_SHIFT	15
+#define SLOT_PER_SUBFRM_MASK	0x3f
+#define CHIPS_PER_SLOT_SHIFT	0
+#define CHIPS_PER_SLOT_MASK	0x7fff
+
+/*AICNETWCONF*/
+#define TOTAL_LEN_SHIFT		16
+#define	TOTAL_LEN_MASK		0xffff
+#define SYM_PER_SLOT_SHIFT	0
+#define SYM_PER_SLOT_MASK	0xff
+#define PPS_TRIG_MASK		0x00003000
+#define PPS_TRIG_PPS		0x00000000
+#define PPS_TRIG_PTP		0x00001000
+#define PPS_TRIG_NLM		0x00002000
+#define PPS_TRIG_RAW_PPS	0x00003000
+#define DL_EN			0x00008000
+#define UL_EN			0x00004000
+
+/*AICNETWCONF2*/
+#define DWPTS_SHIFT		0
+#define DWPTS_MASK		0x7fff
+#define UPPTS_SHIFT		16
+#define UPPTS_MASK		0xfff
+
+/*AICNETWCONF3*/
+#define GP_SHIFT		0
+#define GP_MASK			0x7fff
+
+/*DLULDELAY*/
+#define DL_DELAY_SHIFT		16
+#define DL_DELAY_MASK		0xffff
+#define UL_DELAY_SHIFT		0
+#define UL_DELAY_MASK		0xffff
+
+/*AICLANETMCTRL*/
+#define GPS_EN			0x00000001
+#define SYNC_EN			0x00000002
+#define LTE_EN			0x00000004
+#define REFCLK_SEL		0x01000000
+#define AGC_STRB_SEL_MASK	0xc0000000
+#define AGC_STRB_SEL_SLOT	0x00000000
+#define AGC_STRB_SEL_TTI	0x40000000
+#define AGC_STRB_SEL_TTI_RLD	0x80000000
+#define AGC_STRB_SEL_NEXT_SYM	0xc0000000
+
+/* AICDMAnDMSR */
+#define RDD_UNI_SYS_MEM		0x00000000
+#define RDD_UNI_MAPLE		0x00000080
+#define RDD_MULTICAST		0x00000100
+#define RDD_MASK		0xfffffe7f
+#define DBL_BUF_MODE		0x00000200
+#define RX_OVERSAMPLING		0x00000020
+#define TNA_2ANT		0x00010000
+#define RNA_2ANT		0x00000001
+#define RSW_16B			0x00000010
+#define RSW_8B			0x00000000
+#define RXNOACK			0x00000008
+#define RDNSZ_TRUNC		0x00000400
+#define RXENSEL_SNIFFER		0x00000800
+#define TXNOACK			0x00080000
+#define TX_FLW_CTRL_DIS		0x00100000
+#define TDNSZ_TRUNC		0x04000000
+
+#define RIQBS_MASK		0x00ffffff
+#define RIQBA_MASK		0xfffffff0
+#define RIQT_MASK		0x00ffffff
+
+/* AICDMAnDCR */
+#define TIQE			0x00010000
+#define RIQE			0x00000001
+
+/* AICDMAnDSR */
+#define TIQS			0x00010000
+#define RIQS			0x00000001
+
+/* AICDMAnRIQMTS */
+#define RIQMTS_MASK		0x00000003
+#define RIQMTS_64B		0x00000000
+#define RIQMTS_128B		0x00000001
+#define RIQMTS_256B		0x00000002
+
+/* AICDMAnIER */
+#define ANT0_RIQTIE		0x00000001
+#define ANT1_RIQTIE		0x00000002
+#define RIQFTIE			0x00002000
+#define RIQSTIE			0x00004000
+#define RIQOIE			0x00008000
+#define ANT0_TIQTIE		0x00010000
+#define ANT1_TIQTIE		0x00020000
+#define TIQFTIE			0x20000000
+#define TIQSTIE			0x40000000
+#define TIQUIE			0x80000000
+
+/* AICDMAnISR */
+#define ANT0_RIQTI		0x00000001
+#define ANT1_RIQTI		0x00000002
+#define RIQFTI			0x00002000
+#define RIQSTI			0x00004000
+#define RIQOI			0x00008000
+#define ANT0_TIQTI		0x00010000
+#define ANT1_TIQTI		0x00020000
+#define TIQFTI			0x20000000
+#define TIQSTI			0x40000000
+#define TIQUI			0x80000000
+
+/*AICDMADSR*/
+#define RIQS			0x00000001
+#define TIQS			0x00010000
+
+#define RIQBDR_MASK		0xffffff
+
+/* CHIPRATE_REFCLK is chiprate in refclk terms, it is calculated as:
+ * chiprate_refclk = chips_per_slot * (REFCLK/SAMPLING_FREQUENCY)
+ *
+ * REFCLK - 19.2 Mhz
+ * chips_per_slot, and SAMPLING frequency changes with bandwidth
+ * and the ration remains same. so for all bandwidths chiprate_refclk
+ * remains constant
+ */
+#define CHIPRATE_REFCLK		9600
+#define CHIPRATE_REFCLK_WCDMA		1280
+
+/* Default rollover value is taken as 19200000
+ * so as to cover a period of 1 second */
+#define DEFAULT_ROLLOVER	19200000
+#define DEFAULT_CAPT_OFF		0
+
+#define MAX_LANE_COUNT		6
+#define LANE_REGDUMP_OFFSET	0x200
+#define SYNC_WAIT		20
+
+#define DEFAULT_DL_DELAY	0x15DC
+#define DEFAULT_UL_DELAY	0x15DC
+
+#define AIC_NUM_SNIFFER_BLKS	2
+#define AIC_MAX_NUM_CHANNELS	2
+
+struct aic_sniff_regs {
+	u32 aic_sniff_refcnt;
+	u32 aic_sniff_refcnt_off;
+	u32 aic_sniff_capt_off;
+	u32 aic_sniff_capt_dur;
+	u32 reserved[3];
+	u32 aic_sniff_ctrl;
+	u32 aic_sniff_inten;
+	u32 aic_sniff_int_stat;
+	u32 aic_sniff_refcnt_val;
+	u32 aic_sniff_frmint;
+};
+
+/*SNIFFCTRL*/
+#define REF_SEL_MASK	0x00000003
+#define REF_SEL_ADI	0x00000000
+#define REF_SEL_MAXPHY	0x00000001
+#define REF_SEL_PREMUL	0x00000002
+#define CHP_SEL_MASK	0x0000000c
+#define CHP_SEL_SHIFT	2
+#define CHP_SEL_MAXPHY	0x0000000c
+#define REFCNT_EN	0x00000010
+#define	GPS_SYNC	0x00000020
+#define LD_OFF		0x00000040
+#define CAP_EN		0x00000080
+#define PRE_CAP_EN	0x00000100
+
+/* AICSNIFFnINTEN */
+#define CAP_INT_EN	0x00000001
+#define SNIF_FRMINT_EN	0x00000002
+
+/* AICSNIFFnINT_STAT */
+#define CAP_INT_STAT		0x00000001
+#define SNIF_FRMINT_STAT	0x00000002
+
+struct aic_sniffer {
+	struct aic_lane *lane;
+	atomic_t in_use;
+	unsigned int id;
+	unsigned int intialized;
+	unsigned int gps_synced;
+	unsigned int capt_dur_frms;
+	struct aic_sniff_regs *regs;
+	spinlock_t lock;
+	int capture_done;
+};
+
+struct aic_dev {
+	unsigned int sniff_irq;
+	unsigned int dsp_general_irq;
+	atomic_t sniffers_in_use;
+	enum rf_timer_src sniff_timing_src;
+	struct aic_common_regs *regs;
+	struct aic_lane *lanes[6];
+	struct aic_sniffer sniffers[2];
+	spinlock_t lock;		/*Protects aic_dev->regs*/
+	struct device *dev;
+	u32 *gir_ant_en_mpic;
+	u32 *gir_ant;
+};
+
+/* GIR_ANT_EN_MPIC */
+#define GIR_ANT_OFFSET		0x140
+#define GIR_ANT_EN_MPIC_OFFSET	0x144
+#define AIC_IRQ_ANT29			0x10000000
+
+#define DMA_STATUS_RETRIES	2
+
+struct aic_lane_stats {
+	u32 prev_disp;
+	int dl_tti_count;
+	int ul_tti_count;
+	int rx_ant0_frames;
+	int rx_ant1_frames;
+};
+
+enum aic_lane_type {
+	AIC_LANE_ADI,
+	AIC_LANE_MAXIM
+};
+struct aic_lane {
+	struct aic_dev *aic;
+	struct rf_ctrl_dev *rf_dev;
+	struct aic_sniffer *sniffer;
+	enum aic_lane_type type;
+	unsigned int id;
+	unsigned int irq;
+	struct aic_lane_regs *regs;
+	struct aic_lane_stats stats;
+	unsigned int num_chan;
+	u32	rx_dma_done;
+	u32	rx_dma_done_mask;
+	int rx_ant0_idx;
+	int rx_ant1_idx;
+	spinlock_t lock;		/*Protects aic_lane->regs*/
+};
+
+#define AIC_DMA_DONE	0x1
+#endif
-- 
1.6.3.1



