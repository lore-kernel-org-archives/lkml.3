Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaJEJBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:01:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44889 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaJEJAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:44 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 11/11] pt3: merge I2C & DMA handlers
Date: Sun,  5 Oct 2014 17:59:47 +0900
Message-Id: <5f141d98575839ea256401487efe01e683c44af0.1412497399.git.knightrider@are.ma>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
In-Reply-To: <cover.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- namespace cleanup, minimize exports and "goto" sentences
- remove useless parameters: one_adapter, num_bufs
- using single DVB adapter is wrong approach, change to 1 adapter per 1 FE + 1 tuner
- use pci_request_selected_regions() instead of pci_request_regions()
- provide
	struct i2c_client *pt3_register_subdev(struct i2c_adapter *adap, struct i2c_board_info const *info)
  and
	void pt3_unregister_subdev(struct i2c_client *clt)
  -> should be merged into standard functions?

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/pci/pt3/pt3.c     | 1557 +++++++++++++++++++++------------------
 drivers/media/pci/pt3/pt3_dma.c |  225 ------
 drivers/media/pci/pt3/pt3_i2c.c |  240 ------
 3 files changed, 839 insertions(+), 1183 deletions(-)
 delete mode 100644 drivers/media/pci/pt3/pt3_dma.c
 delete mode 100644 drivers/media/pci/pt3/pt3_i2c.c

diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 1fdeac1..fcefee7 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -1,12 +1,12 @@
 /*
- * Earthsoft PT3 driver
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCIE bridge Altera Cyclone IV FPGA EP4CGX15BF14C8N
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,863 +14,984 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/freezer.h>
-#include <linux/kernel.h>
-#include <linux/kthread.h>
-#include <linux/mutex.h>
-#include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/string.h>
-
-#include "dmxdev.h"
-#include "dvbdev.h"
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include "dvb_demux.h"
+#include "dmxdev.h"
 #include "dvb_frontend.h"
-
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+#include "mxl301rf.h"
 #include "pt3.h"
 
-DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
+MODULE_LICENSE("GPL");
 
-static bool one_adapter;
-module_param(one_adapter, bool, 0444);
-MODULE_PARM_DESC(one_adapter, "Place FE's together under one adapter.");
+static struct pci_device_id pt3_id_table[] = {
+	{ PCI_DEVICE(0x1172, 0x4c15) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pt3_id_table);
 
-static int num_bufs = 4;
-module_param(num_bufs, int, 0444);
-MODULE_PARM_DESC(num_bufs, "Number of DMA buffer (188KiB) per FE.");
+static int lnb = 2;
+module_param(lnb, int, 0);
+MODULE_PARM_DESC(lnb, "LNB level (0:OFF 1:+11V 2:+15V)");
+
+/* common defs */
+
+#define PT3_REG_VERSION	0x00	/*	R	Version		*/
+#define PT3_REG_BUS	0x04	/*	R	Bus		*/
+#define PT3_REG_SYS_W	0x08	/*	W	System		*/
+#define PT3_REG_SYS_R	0x0c	/*	R	System		*/
+#define PT3_REG_I2C_W	0x10	/*	W	I2C		*/
+#define PT3_REG_I2C_R	0x14	/*	R	I2C		*/
+#define PT3_REG_RAM_W	0x18	/*	W	RAM		*/
+#define PT3_REG_RAM_R	0x1c	/*	R	RAM		*/
+#define PT3_REG_BASE	0x40	/* + 0x18*idx			*/
+#define PT3_OFS_DMA_D_L	0x00	/*	W	DMA descriptor	*/
+#define PT3_OFS_DMA_D_H	0x04	/*	W	DMA descriptor	*/
+#define PT3_OFS_DMA_CTL	0x08	/*	W	DMA		*/
+#define PT3_OFS_TS_CTL	0x0c	/*	W	TS		*/
+#define PT3_OFS_STATUS	0x10	/*	R	DMA/FIFO/TS	*/
+#define PT3_OFS_TS_ERR	0x14	/*	R	TS		*/
+
+struct pt3_adapter;
+
+struct pt3_board {
+	struct mutex lock;
+	int lnb;
+	bool reset;
+
+	struct pci_dev *pdev;
+	int bars;
+	void __iomem *bar_reg, *bar_mem;
+	struct i2c_adapter i2c;
+	u8 i2c_buf;
+	u32 i2c_addr;
+	bool i2c_filled;
+
+	struct pt3_adapter **adap;
+};
 
+struct pt3_adapter {
+	struct mutex lock;
+	struct pt3_board *pt3;
 
-static const struct i2c_algorithm pt3_i2c_algo = {
-	.master_xfer   = &pt3_i2c_master_xfer,
-	.functionality = &pt3_i2c_functionality,
+	u8 idx;
+	bool sleep;
+	struct pt3_dma *dma;
+	struct task_struct *kthread;
+	struct dvb_adapter dvb;
+	struct dvb_demux demux;
+	struct dmxdev dmxdev;
+	int users;
+
+	struct i2c_client *i2c_demod, *i2c_tuner;
+	struct dvb_frontend *fe;
+	int (*orig_sleep)(struct dvb_frontend *fe);
+	int (*orig_init)(struct dvb_frontend *fe);
 };
 
-static const struct pt3_adap_config adap_conf[PT3_NUM_FE] = {
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x11),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("qm1d1c0042", 0x63),
-		},
-		.tuner_cfg.qm1d1c0042 = {
-			.lpf = 1,
-		},
-		.init_freq = 1049480 - 300,
-	},
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x10),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("mxl301rf", 0x62),
-		},
-		.init_freq = 515142857,
-	},
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x13),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("qm1d1c0042", 0x60),
-		},
-		.tuner_cfg.qm1d1c0042 = {
-			.lpf = 1,
-		},
-		.init_freq = 1049480 + 300,
-	},
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x12),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("mxl301rf", 0x61),
-		},
-		.init_freq = 521142857,
-	},
+/* DMA handler */
+
+#define PT3_DMA_MAX_DESCS	204
+#define PT3_DMA_PAGE_SIZE	(PT3_DMA_MAX_DESCS * sizeof(struct pt3_dma_desc))
+#define PT3_DMA_BLOCK_COUNT	17
+#define PT3_DMA_BLOCK_SIZE	(PT3_DMA_PAGE_SIZE * 47)
+#define PT3_DMA_TS_BUF_SIZE	(PT3_DMA_BLOCK_SIZE * PT3_DMA_BLOCK_COUNT)
+#define PT3_DMA_TS_SYNC		0x47
+#define PT3_DMA_TS_NOT_SYNC	0x74
+
+struct pt3_dma_page {
+	dma_addr_t addr;
+	u8 *data;
+	u32 size, data_pos;
 };
 
+enum pt3_dma_mode {
+	USE_LFSR = 1 << 16,
+	REVERSE  = 1 << 17,
+	RESET    = 1 << 18,
+};
 
-struct reg_val {
-	u8 reg;
-	u8 val;
+struct pt3_dma {
+	struct pt3_adapter *adap;
+	bool enabled;
+	u32 ts_pos, ts_count, desc_count;
+	struct pt3_dma_page *ts_info, *desc_info;
+	struct mutex lock;
 };
 
-static int
-pt3_demod_write(struct pt3_adapter *adap, const struct reg_val *data, int num)
+void pt3_dma_free(struct pt3_dma *dma)
 {
-	struct i2c_msg msg;
-	int i, ret;
-
-	ret = 0;
-	msg.addr = adap->i2c_demod->addr;
-	msg.flags = 0;
-	msg.len = 2;
-	for (i = 0; i < num; i++) {
-		msg.buf = (u8 *)&data[i];
-		ret = i2c_transfer(adap->i2c_demod->adapter, &msg, 1);
-		if (ret == 0)
-			ret = -EREMOTE;
-		if (ret < 0)
-			return ret;
+	struct pt3_dma_page *page;
+	u32 i;
+
+	if (dma->ts_info) {
+		for (i = 0; i < dma->ts_count; i++) {
+			page = &dma->ts_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->ts_info);
 	}
-	return 0;
+	if (dma->desc_info) {
+		for (i = 0; i < dma->desc_count; i++) {
+			page = &dma->desc_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->desc_info);
+	}
+	kfree(dma);
 }
 
-static inline void pt3_lnb_ctrl(struct pt3_board *pt3, bool on)
+struct pt3_dma_desc {
+	u64 page_addr;
+	u32 page_size;
+	u64 next_desc;
+} __packed;
+
+void pt3_dma_build_page_descriptor(struct pt3_dma *dma)
 {
-	iowrite32((on ? 0x0f : 0x0c), pt3->regs[0] + REG_SYSTEM_W);
+	struct pt3_dma_page *desc_info, *ts_info;
+	u64 ts_addr, desc_addr;
+	u32 i, j, ts_size, desc_remain, ts_info_pos, desc_info_pos;
+	struct pt3_dma_desc *prev, *curr;
+
+	dev_dbg(dma->adap->dvb.device, "#%d %s ts_count=%d ts_size=%d desc_count=%d desc_size=%d\n",
+		dma->adap->idx, __func__, dma->ts_count, dma->ts_info[0].size, dma->desc_count, dma->desc_info[0].size);
+	desc_info_pos = ts_info_pos = 0;
+	desc_info = &dma->desc_info[desc_info_pos];
+	desc_addr   = desc_info->addr;
+	desc_remain = desc_info->size;
+	desc_info->data_pos = 0;
+	prev = NULL;
+	curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+	desc_info_pos++;
+
+	for (i = 0; i < dma->ts_count; i++) {
+		if (unlikely(ts_info_pos >= dma->ts_count)) {
+			dev_dbg(dma->adap->dvb.device, "#%d ts_info overflow max=%d curr=%d\n", dma->adap->idx, dma->ts_count, ts_info_pos);
+			return;
+		}
+		ts_info = &dma->ts_info[ts_info_pos];
+		ts_addr = ts_info->addr;
+		ts_size = ts_info->size;
+		ts_info_pos++;
+		dev_dbg(dma->adap->dvb.device, "#%d i=%d, ts_info addr=0x%llx ts_size=%d\n", dma->adap->idx, i, ts_addr, ts_size);
+		for (j = 0; j < ts_size / PT3_DMA_PAGE_SIZE; j++) {
+			if (desc_remain < sizeof(struct pt3_dma_desc)) {
+				if (unlikely(desc_info_pos >= dma->desc_count)) {
+					dev_dbg(dma->adap->dvb.device, "#%d desc_info overflow max=%d curr=%d\n",
+						dma->adap->idx, dma->desc_count, desc_info_pos);
+					return;
+				}
+				desc_info = &dma->desc_info[desc_info_pos];
+				desc_info->data_pos = 0;
+				curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+				dev_dbg(dma->adap->dvb.device, "#%d desc_info_pos=%d ts_addr=0x%llx remain=%d\n",
+					dma->adap->idx, desc_info_pos, ts_addr, desc_remain);
+				desc_addr = desc_info->addr;
+				desc_remain = desc_info->size;
+				desc_info_pos++;
+			}
+			if (prev)
+				prev->next_desc = desc_addr | 0b10;
+			curr->page_addr = ts_addr           | 0b111;
+			curr->page_size = PT3_DMA_PAGE_SIZE | 0b111;
+			curr->next_desc = 0b10;
+			dev_dbg(dma->adap->dvb.device, "#%d j=%d dma write desc ts_addr=0x%llx desc_info_pos=%d desc_remain=%d\n",
+				dma->adap->idx, j, ts_addr, desc_info_pos, desc_remain);
+			ts_addr += PT3_DMA_PAGE_SIZE;
+
+			prev = curr;
+			desc_info->data_pos += sizeof(struct pt3_dma_desc);
+			if (unlikely(desc_info->data_pos > desc_info->size)) {
+				dev_dbg(dma->adap->dvb.device, "#%d dma desc_info data overflow max=%d curr=%d\n",
+					dma->adap->idx, desc_info->size, desc_info->data_pos);
+				return;
+			}
+			curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+			desc_addr += sizeof(struct pt3_dma_desc);
+			desc_remain -= sizeof(struct pt3_dma_desc);
+		}
+	}
+	if (prev)
+		prev->next_desc = dma->desc_info->addr | 0b10;
 }
 
-static inline struct pt3_adapter *pt3_find_adapter(struct dvb_frontend *fe)
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap)
 {
-	struct pt3_board *pt3;
-	int i;
+	struct pt3_dma_page *page;
+	u32 i;
+	struct pt3_dma *dma = kzalloc(sizeof(struct pt3_dma), GFP_KERNEL);
+
+	if (!dma)
+		goto fail;
+	dma->adap = adap;
+	dma->enabled = false;
+	mutex_init(&dma->lock);
+
+	dma->ts_count = PT3_DMA_BLOCK_COUNT;
+	dma->ts_info = kcalloc(dma->ts_count, sizeof(struct pt3_dma_page), GFP_KERNEL);
+	if (!dma->ts_info) {
+		dev_dbg(adap->dvb.device, "#%d fail allocate TS DMA page\n", adap->idx);
+		goto fail;
+	}
+	dev_dbg(adap->dvb.device, "#%d Alloc TS buf (ts_count %d)\n", adap->idx, dma->ts_count);
+	for (i = 0; i < dma->ts_count; i++) {
+		page = &dma->ts_info[i];
+		page->size = PT3_DMA_BLOCK_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			dev_dbg(adap->dvb.device, "#%d fail alloc_consistent. %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
 
-	if (one_adapter) {
-		pt3 = fe->dvb->priv;
-		for (i = 0; i < PT3_NUM_FE; i++)
-			if (pt3->adaps[i]->fe == fe)
-				return pt3->adaps[i];
+	dma->desc_count = 1 + (PT3_DMA_TS_BUF_SIZE / PT3_DMA_PAGE_SIZE - 1) / PT3_DMA_MAX_DESCS;
+	dma->desc_info = kcalloc(dma->desc_count, sizeof(struct pt3_dma_page), GFP_KERNEL);
+	if (!dma->desc_info) {
+		dev_dbg(adap->dvb.device, "#%d fail allocate Desc DMA page\n", adap->idx);
+		goto fail;
+	}
+	dev_dbg(adap->dvb.device, "#%d Alloc Descriptor buf (desc_count %d)\n", adap->idx, dma->desc_count);
+	for (i = 0; i < dma->desc_count; i++) {
+		page = &dma->desc_info[i];
+		page->size = PT3_DMA_PAGE_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			dev_dbg(adap->dvb.device, "#%d fail alloc_consistent %d\n", adap->idx, i);
+			goto fail;
+		}
 	}
-	return container_of(fe->dvb, struct pt3_adapter, dvb_adap);
+
+	dev_dbg(adap->dvb.device, "#%d build page descriptor\n", adap->idx);
+	pt3_dma_build_page_descriptor(dma);
+	return dma;
+fail:
+	if (dma)
+		pt3_dma_free(dma);
+	return NULL;
 }
 
-/*
- * all 4 tuners in PT3 are packaged in a can module (Sharp VA4M6JC2103).
- * it seems that they share the power lines and Amp power line and
- * adaps[3] controls those powers.
- */
-static int
-pt3_set_tuner_power(struct pt3_board *pt3, bool tuner_on, bool amp_on)
+void __iomem *pt3_dma_get_base_addr(struct pt3_dma *dma)
 {
-	struct reg_val rv = { 0x1e, 0x99 };
-
-	if (tuner_on)
-		rv.val |= 0x40;
-	if (amp_on)
-		rv.val |= 0x04;
-	return pt3_demod_write(pt3->adaps[PT3_NUM_FE - 1], &rv, 1);
+	return dma->adap->pt3->bar_reg + PT3_REG_BASE + (0x18 * dma->adap->idx);
 }
 
-static int pt3_set_lna(struct dvb_frontend *fe)
+void pt3_dma_reset(struct pt3_dma *dma)
 {
-	struct pt3_adapter *adap;
-	struct pt3_board *pt3;
-	u32 val;
-	int ret;
-
-	/* LNA is shared btw. 2 TERR-tuners */
+	struct pt3_dma_page *ts;
+	u32 i;
 
-	adap = pt3_find_adapter(fe);
-	val = fe->dtv_property_cache.lna;
-	if (val == LNA_AUTO || val == adap->cur_lna)
-		return 0;
-
-	pt3 = adap->dvb_adap.priv;
-	if (mutex_lock_interruptible(&pt3->lock))
-		return -ERESTARTSYS;
-	if (val)
-		pt3->lna_on_cnt++;
-	else
-		pt3->lna_on_cnt--;
-
-	if (val && pt3->lna_on_cnt <= 1) {
-		pt3->lna_on_cnt = 1;
-		ret = pt3_set_tuner_power(pt3, true, true);
-	} else if (!val && pt3->lna_on_cnt <= 0) {
-		pt3->lna_on_cnt = 0;
-		ret = pt3_set_tuner_power(pt3, true, false);
-	} else
-		ret = 0;
-	mutex_unlock(&pt3->lock);
-	adap->cur_lna = (val != 0);
-	return ret;
+	for (i = 0; i < dma->ts_count; i++) {
+		ts = &dma->ts_info[i];
+		memset(ts->data, 0, ts->size);
+		ts->data_pos = 0;
+		*ts->data = PT3_DMA_TS_NOT_SYNC;
+	}
+	dma->ts_pos = 0;
 }
 
-static int pt3_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled)
 {
-	struct pt3_adapter *adap;
-	struct pt3_board *pt3;
-	bool on;
-
-	/* LNB power is shared btw. 2 SAT-tuners */
-
-	adap = pt3_find_adapter(fe);
-	on = (volt != SEC_VOLTAGE_OFF);
-	if (on == adap->cur_lnb)
-		return 0;
-	adap->cur_lnb = on;
-	pt3 = adap->dvb_adap.priv;
-	if (mutex_lock_interruptible(&pt3->lock))
-		return -ERESTARTSYS;
-	if (on)
-		pt3->lnb_on_cnt++;
-	else
-		pt3->lnb_on_cnt--;
-
-	if (on && pt3->lnb_on_cnt <= 1) {
-		pt3->lnb_on_cnt = 1;
-		pt3_lnb_ctrl(pt3, true);
-	} else if (!on && pt3->lnb_on_cnt <= 0) {
-		pt3->lnb_on_cnt = 0;
-		pt3_lnb_ctrl(pt3, false);
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u64 start_addr = dma->desc_info->addr;
+
+	if (enabled) {
+		dev_dbg(dma->adap->dvb.device, "#%d DMA enable start_addr=%llx\n", dma->adap->idx, start_addr);
+		pt3_dma_reset(dma);
+		writel(1 << 1, base + PT3_OFS_DMA_CTL);	/* stop DMA */
+		writel(start_addr         & 0xffffffff, base + PT3_OFS_DMA_D_L);
+		writel((start_addr >> 32) & 0xffffffff, base + PT3_OFS_DMA_D_H);
+		dev_dbg(dma->adap->dvb.device, "set descriptor address low %llx\n",  start_addr         & 0xffffffff);
+		dev_dbg(dma->adap->dvb.device, "set descriptor address high %llx\n", (start_addr >> 32) & 0xffffffff);
+		writel(1 << 0, base + PT3_OFS_DMA_CTL);	/* start DMA */
+	} else {
+		dev_dbg(dma->adap->dvb.device, "#%d DMA disable\n", dma->adap->idx);
+		writel(1 << 1, base + PT3_OFS_DMA_CTL);	/* stop DMA */
+		while (1) {
+			if (!(readl(base + PT3_OFS_STATUS) & 1))
+				break;
+			msleep_interruptible(1);
+		}
 	}
-	mutex_unlock(&pt3->lock);
-	return 0;
+	dma->enabled = enabled;
 }
 
-/* register values used in pt3_fe_init() */
-
-static const struct reg_val init0_sat[] = {
-	{ 0x03, 0x01 },
-	{ 0x1e, 0x10 },
-};
-static const struct reg_val init0_ter[] = {
-	{ 0x01, 0x40 },
-	{ 0x1c, 0x10 },
-};
-static const struct reg_val cfg_sat[] = {
-	{ 0x1c, 0x15 },
-	{ 0x1f, 0x04 },
-};
-static const struct reg_val cfg_ter[] = {
-	{ 0x1d, 0x01 },
-};
-
-/*
- * pt3_fe_init: initialize demod sub modules and ISDB-T tuners all at once.
- *
- * As for demod IC (TC90522) and ISDB-T tuners (MxL301RF),
- * the i2c sequences for init'ing them are not public and hidden in a ROM,
- * and include the board specific configurations as well.
- * They are stored in a lump and cannot be taken out / accessed separately,
- * thus cannot be moved to the FE/tuner driver.
- */
-static int pt3_fe_init(struct pt3_board *pt3)
+static u32 pt3_dma_gray2binary(u32 gray, u32 bit)	/* convert Gray code to binary, e.g. 1001 -> 1110 */
 {
-	int i, ret;
-	struct dvb_frontend *fe;
+	u32 binary = 0, i, j, k;
 
-	pt3_i2c_reset(pt3);
-	ret = pt3_init_all_demods(pt3);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to init demod chips.");
-		return ret;
+	for (i = 0; i < bit; i++) {
+		k = 0;
+		for (j = i; j < bit; j++)
+			k ^= (gray >> j) & 1;
+		binary |= k << i;
 	}
+	return binary;
+}
 
-	/* additional config? */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-
-		if (fe->ops.delsys[0] == SYS_ISDBS)
-			ret = pt3_demod_write(pt3->adaps[i],
-					      init0_sat, ARRAY_SIZE(init0_sat));
-		else
-			ret = pt3_demod_write(pt3->adaps[i],
-					      init0_ter, ARRAY_SIZE(init0_ter));
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "demod[%d] faild in init sequence0.", i);
-			return ret;
-		}
-		ret = fe->ops.init(fe);
-		if (ret < 0)
-			return ret;
-	}
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma)
+{
+	return pt3_dma_gray2binary(readl(pt3_dma_get_base_addr(dma) + PT3_OFS_TS_ERR), 32);
+}
 
-	usleep_range(2000, 4000);
-	ret = pt3_set_tuner_power(pt3, true, false);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to control tuner module.");
-		return ret;
-	}
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u32 data = mode | initval;
 
-	/* output pin configuration */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		if (fe->ops.delsys[0] == SYS_ISDBS)
-			ret = pt3_demod_write(pt3->adaps[i],
-						cfg_sat, ARRAY_SIZE(cfg_sat));
-		else
-			ret = pt3_demod_write(pt3->adaps[i],
-						cfg_ter, ARRAY_SIZE(cfg_ter));
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "demod[%d] faild in init sequence1.", i);
-			return ret;
-		}
-	}
-	usleep_range(4000, 6000);
-
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		if (fe->ops.delsys[0] != SYS_ISDBS)
-			continue;
-		/* init and wake-up ISDB-S tuners */
-		ret = fe->ops.tuner_ops.init(fe);
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "Failed to init SAT-tuner[%d].", i);
-			return ret;
-		}
-	}
-	ret = pt3_init_all_mxl301rf(pt3);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to init TERR-tuners.");
-		return ret;
-	}
+	dev_dbg(dma->adap->dvb.device, "#%d %s base=%p data=0x%04x\n", dma->adap->idx, __func__, base, data);
+	writel(data, base + PT3_OFS_TS_CTL);
+}
 
-	ret = pt3_set_tuner_power(pt3, true, true);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to control tuner module.");
-		return ret;
-	}
+bool pt3_dma_ready(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u8 *p;
+	u32 next = dma->ts_pos + 1;
+
+	if (next >= dma->ts_count)
+		next = 0;
+	ts = &dma->ts_info[next];
+	p = &ts->data[ts->data_pos];
+
+	if (*p == PT3_DMA_TS_SYNC)
+		return true;
+	if (*p == PT3_DMA_TS_NOT_SYNC)
+		return false;
+
+	dev_dbg(dma->adap->dvb.device, "#%d invalid sync byte value=0x%02x ts_pos=%d data_pos=%d curr=0x%02x\n",
+		dma->adap->idx, *p, next, ts->data_pos, dma->ts_info[dma->ts_pos].data[0]);
+	return false;
+}
 
-	/* Wake up all tuners and make an initial tuning,
-	 * in order to avoid interference among the tuners in the module,
-	 * according to the doc from the manufacturer.
-	 */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		ret = 0;
-		if (fe->ops.delsys[0] == SYS_ISDBT)
-			ret = fe->ops.tuner_ops.init(fe);
-		/* set only when called from pt3_probe(), not resume() */
-		if (ret == 0 && fe->dtv_property_cache.frequency == 0) {
-			fe->dtv_property_cache.frequency =
-						adap_conf[i].init_freq;
-			ret = fe->ops.tuner_ops.set_params(fe);
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux)
+{
+	bool ready;
+	struct pt3_dma_page *ts;
+	u32 i, prev;
+	size_t csize, remain = dma->ts_info[dma->ts_pos].size;
+
+	mutex_lock(&dma->lock);
+	dev_dbg(dma->adap->dvb.device, "#%d dma_copy ts_pos=0x%x data_pos=0x%x\n",
+		   dma->adap->idx, dma->ts_pos, dma->ts_info[dma->ts_pos].data_pos);
+	for (;;) {
+		for (i = 0; i < 20; i++) {
+			ready = pt3_dma_ready(dma);
+			if (ready)
+				break;
+			msleep_interruptible(30);
 		}
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "Failed in initial tuning of tuner[%d].", i);
-			return ret;
+		if (!ready) {
+			dev_dbg(dma->adap->dvb.device, "#%d dma_copy NOT READY\n", dma->adap->idx);
+			goto last;
+		}
+		prev = dma->ts_pos - 1;
+		if (prev < 0 || dma->ts_count <= prev)
+			prev = dma->ts_count - 1;
+		if (dma->ts_info[prev].data[0] != PT3_DMA_TS_NOT_SYNC)
+			dev_dbg(dma->adap->dvb.device, "#%d DMA buffer overflow. prev=%d data=0x%x\n",
+					dma->adap->idx, prev, dma->ts_info[prev].data[0]);
+		ts = &dma->ts_info[dma->ts_pos];
+		for (;;) {
+			csize = (remain < (ts->size - ts->data_pos)) ?
+				 remain : (ts->size - ts->data_pos);
+			dvb_dmx_swfilter(demux, &ts->data[ts->data_pos], csize);
+			remain -= csize;
+			ts->data_pos += csize;
+			if (ts->data_pos >= ts->size) {
+				ts->data_pos = 0;
+				ts->data[ts->data_pos] = PT3_DMA_TS_NOT_SYNC;
+				dma->ts_pos++;
+				if (dma->ts_pos >= dma->ts_count)
+					dma->ts_pos = 0;
+				break;
+			}
+			if (remain <= 0)
+				goto last;
 		}
 	}
+last:
+	mutex_unlock(&dma->lock);
+	return dma->ts_info[dma->ts_pos].size - remain;
+}
 
-	/* and sleep again, waiting to be opened by users. */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		if (fe->ops.tuner_ops.sleep)
-			ret = fe->ops.tuner_ops.sleep(fe);
-		if (ret < 0)
-			break;
-		if (fe->ops.sleep)
-			ret = fe->ops.sleep(fe);
-		if (ret < 0)
-			break;
-		if (fe->ops.delsys[0] == SYS_ISDBS)
-			fe->ops.set_voltage = &pt3_set_voltage;
-		else
-			fe->ops.set_lna = &pt3_set_lna;
-	}
-	if (i < PT3_NUM_FE) {
-		dev_warn(&pt3->pdev->dev, "FE[%d] failed to standby.", i);
-		return ret;
-	}
-	return 0;
+u32 pt3_dma_get_status(struct pt3_dma *dma)
+{
+	return readl(pt3_dma_get_base_addr(dma) + PT3_OFS_STATUS);
 }
 
+/* I2C handler */
+
+#define PT3_I2C_DATA_OFFSET	2048
+#define PT3_I2C_START_ADDR	0x17fa
+
+enum pt3_i2c_cmd {
+	I_END,
+	I_ADDRESS,
+	I_CLOCK_L,
+	I_CLOCK_H,
+	I_DATA_L,
+	I_DATA_H,
+	I_RESET,
+	I_SLEEP,
+	I_DATA_L_NOP  = 0x08,
+	I_DATA_H_NOP  = 0x0c,
+	I_DATA_H_READ = 0x0d,
+	I_DATA_H_ACK0 = 0x0e,
+	I_DATA_H_ACK1 = 0x0f,
+};
 
-static int pt3_attach_fe(struct pt3_board *pt3, int i)
+bool pt3_i2c_is_clean(struct pt3_board *pt3)
 {
-	struct i2c_board_info info;
-	struct tc90522_config cfg;
-	struct i2c_client *cl;
-	struct dvb_adapter *dvb_adap;
-	int ret;
+	return (readl(pt3->bar_reg + PT3_REG_I2C_R) >> 3) & 1;
+}
 
-	info = adap_conf[i].demod_info;
-	cfg = adap_conf[i].demod_cfg;
-	cfg.tuner_i2c = NULL;
-	info.platform_data = &cfg;
-
-	ret = -ENODEV;
-	request_module("tc90522");
-	cl = i2c_new_device(&pt3->i2c_adap, &info);
-	if (!cl || !cl->dev.driver)
-		return -ENODEV;
-	pt3->adaps[i]->i2c_demod = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_demod_i2c_unregister_device;
-
-	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT, sizeof(cl->name))) {
-		struct qm1d1c0042_config tcfg;
-
-		tcfg = adap_conf[i].tuner_cfg.qm1d1c0042;
-		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("qm1d1c0042");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
-	} else {
-		struct mxl301rf_config tcfg;
-
-		tcfg = adap_conf[i].tuner_cfg.mxl301rf;
-		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("mxl301rf");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
-	}
-	if (!cl || !cl->dev.driver)
-		goto err_demod_module_put;
-	pt3->adaps[i]->i2c_tuner = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_tuner_i2c_unregister_device;
-
-	dvb_adap = &pt3->adaps[one_adapter ? 0 : i]->dvb_adap;
-	ret = dvb_register_frontend(dvb_adap, cfg.fe);
-	if (ret < 0)
-		goto err_tuner_module_put;
-	pt3->adaps[i]->fe = cfg.fe;
-	return 0;
+void pt3_i2c_reset(struct pt3_board *pt3)
+{
+	writel(1 << 17, pt3->bar_reg + PT3_REG_I2C_W);			/* 0x00020000 */
+}
 
-err_tuner_module_put:
-	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
-err_tuner_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
-err_demod_module_put:
-	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
-err_demod_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
+void pt3_i2c_wait(struct pt3_board *pt3, u32 *status)
+{
+	u32 val;
 
-	return ret;
+	while (1) {
+		val = readl(pt3->bar_reg + PT3_REG_I2C_R);
+		if (!(val & 1))						/* sequence stopped */
+			break;
+		msleep_interruptible(1);
+	}
+	if (status)
+		*status = val;						/* I2C register status */
 }
 
-
-static int pt3_fetch_thread(void *data)
+void pt3_i2c_mem_write(struct pt3_board *pt3, u8 data)
 {
-	struct pt3_adapter *adap = data;
-	ktime_t delay;
-	bool was_frozen;
+	void __iomem *dst = pt3->bar_mem + PT3_I2C_DATA_OFFSET + pt3->i2c_addr;
 
-#define PT3_INITIAL_BUF_DROPS 4
-#define PT3_FETCH_DELAY 10
-#define PT3_FETCH_DELAY_DELTA 2
-
-	pt3_init_dmabuf(adap);
-	adap->num_discard = PT3_INITIAL_BUF_DROPS;
+	if (pt3->i2c_filled) {
+		pt3->i2c_buf |= data << 4;
+		writeb(pt3->i2c_buf, dst);
+		pt3->i2c_addr++;
+	} else
+		pt3->i2c_buf = data;
+	pt3->i2c_filled ^= true;
+}
 
-	dev_dbg(adap->dvb_adap.device,
-		"PT3: [%s] started.\n", adap->thread->comm);
-	set_freezable();
-	while (!kthread_freezable_should_stop(&was_frozen)) {
-		if (was_frozen)
-			adap->num_discard = PT3_INITIAL_BUF_DROPS;
+void pt3_i2c_start(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_H);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_L);
+}
 
-		pt3_proc_dma(adap);
+void pt3_i2c_cmd_write(struct pt3_board *pt3, const u8 *data, u32 size)
+{
+	u32 i, j;
+	u8 byte;
 
-		delay = ktime_set(0, PT3_FETCH_DELAY * NSEC_PER_MSEC);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		freezable_schedule_hrtimeout_range(&delay,
-					PT3_FETCH_DELAY_DELTA * NSEC_PER_MSEC,
-					HRTIMER_MODE_REL);
+	for (i = 0; i < size; i++) {
+		byte = data[i];
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, (byte >> (7 - j)) & 1 ? I_DATA_H_NOP : I_DATA_L_NOP);
+		pt3_i2c_mem_write(pt3, I_DATA_H_ACK0);
 	}
-	dev_dbg(adap->dvb_adap.device,
-		"PT3: [%s] exited.\n", adap->thread->comm);
-	adap->thread = NULL;
-	return 0;
 }
 
-static int pt3_start_streaming(struct pt3_adapter *adap)
+void pt3_i2c_cmd_read(struct pt3_board *pt3, u8 *data, u32 size)
 {
-	struct task_struct *thread;
+	u32 i, j;
 
-	/* start fetching thread */
-	thread = kthread_run(pt3_fetch_thread, adap, "pt3-ad%i-dmx%i",
-				adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
-	if (IS_ERR(thread)) {
-		int ret = PTR_ERR(thread);
-
-		dev_warn(adap->dvb_adap.device,
-			"PT3 (adap:%d, dmx:%d): failed to start kthread.\n",
-			adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
-		return ret;
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, I_DATA_H_READ);
+		if (i == (size - 1))
+			pt3_i2c_mem_write(pt3, I_DATA_H_NOP);
+		else
+			pt3_i2c_mem_write(pt3, I_DATA_L_NOP);
 	}
-	adap->thread = thread;
+}
 
-	return pt3_start_dma(adap);
+void pt3_i2c_stop(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_H);
 }
 
-static int pt3_stop_streaming(struct pt3_adapter *adap)
+int pt3_i2c_flush(struct pt3_board *pt3, bool end, u32 start_addr)
 {
-	int ret;
+	u32 status;
 
-	ret = pt3_stop_dma(adap);
-	if (ret)
-		dev_warn(adap->dvb_adap.device,
-			"PT3: failed to stop streaming of adap:%d/FE:%d\n",
-			adap->dvb_adap.num, adap->fe->id);
+	if (end) {
+		pt3_i2c_mem_write(pt3, I_END);
+		if (pt3->i2c_filled)
+			pt3_i2c_mem_write(pt3, I_END);
+	}
+	pt3_i2c_wait(pt3, &status);
+	writel(1 << 16 | start_addr, pt3->bar_reg + PT3_REG_I2C_W);	/* 0x00010000 start sequence */
+	pt3_i2c_wait(pt3, &status);
+	if (status & 0b0110) {						/* ACK status */
+		dev_err(&pt3->i2c.dev, "%s %s failed, status=0x%x\n", pt3->i2c.name, __func__, status);
+		return -EIO;
+	}
+	return 0;
+}
 
-	/* kill the fetching thread */
-	ret = kthread_stop(adap->thread);
-	return ret;
+u32 pt3_i2c_func(struct i2c_adapter *i2c)
+{
+	return I2C_FUNC_I2C;
 }
 
-static int pt3_start_feed(struct dvb_demux_feed *feed)
+int pt3_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msg, int num)
 {
-	struct pt3_adapter *adap;
+	struct pt3_board *pt3 = i2c_get_adapdata(i2c);
+	int i, j;
+
+	if (!num)
+		return pt3_i2c_flush(pt3, false, PT3_I2C_START_ADDR);
+	if ((num < 1) || (num > 3) || !msg || msg[0].flags)		/* always write first */
+		return -ENOTSUPP;
+	mutex_lock(&pt3->lock);
+	pt3->i2c_addr = 0;
+	for (i = 0; i < num; i++) {
+		u8 byte = (msg[i].addr << 1) | (msg[i].flags & 1);
 
-	if (signal_pending(current))
-		return -EINTR;
-
-	adap = container_of(feed->demux, struct pt3_adapter, demux);
-	adap->num_feeds++;
-	if (adap->thread)
-		return 0;
-	if (adap->num_feeds != 1) {
-		dev_warn(adap->dvb_adap.device,
-			"%s: unmatched start/stop_feed in adap:%i/dmx:%i.\n",
-			__func__, adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
-		adap->num_feeds = 1;
+		pt3_i2c_start(pt3);
+		pt3_i2c_cmd_write(pt3, &byte, 1);
+		if (msg[i].flags == I2C_M_RD)
+			pt3_i2c_cmd_read(pt3, msg[i].buf, msg[i].len);
+		else
+			pt3_i2c_cmd_write(pt3, msg[i].buf, msg[i].len);
 	}
+	pt3_i2c_stop(pt3);
+	if (pt3_i2c_flush(pt3, true, 0))
+		num = -EIO;
+	else
+		for (i = 1; i < num; i++)
+			if (msg[i].flags == I2C_M_RD)
+				for (j = 0; j < msg[i].len; j++)
+					msg[i].buf[j] = readb(pt3->bar_mem + PT3_I2C_DATA_OFFSET + j);
+	mutex_unlock(&pt3->lock);
+	return num;
+}
+
+static const struct i2c_algorithm pt3_i2c_algo = {
+	.functionality = pt3_i2c_func,
+	.master_xfer = pt3_i2c_xfer,
+};
 
-	return pt3_start_streaming(adap);
+int pt3_i2c_add_adapter(struct pt3_board *pt3)
+{
+	struct i2c_adapter *i2c = &pt3->i2c;
 
+	i2c->algo = &pt3_i2c_algo;
+	i2c->algo_data = NULL;
+	i2c->dev.parent = &pt3->pdev->dev;
+	strcpy(i2c->name, PT3_DRVNAME);
+	i2c_set_adapdata(i2c, pt3);
+	return	i2c_add_adapter(i2c) ||
+		(!pt3_i2c_is_clean(pt3) && pt3_i2c_flush(pt3, false, 0));
 }
 
-static int pt3_stop_feed(struct dvb_demux_feed *feed)
-{
-	struct pt3_adapter *adap;
+/* PCI bridge routines */
 
-	adap = container_of(feed->demux, struct pt3_adapter, demux);
+struct pt3_lnb {
+	u32 bits;
+	char *str;
+};
 
-	adap->num_feeds--;
-	if (adap->num_feeds > 0 || !adap->thread)
-		return 0;
-	adap->num_feeds = 0;
+static const struct pt3_lnb pt3_lnb[] = {
+	{0b1100,  "0V"},
+	{0b1101, "11V"},
+	{0b1111, "15V"},
+};
 
-	return pt3_stop_streaming(adap);
-}
+struct pt3_cfg {
+	fe_delivery_system_t type;
+	u8 addr_tuner, addr_demod;
+};
 
+static const struct pt3_cfg pt3_cfg[] = {
+	{SYS_ISDBS, 0x63, 0b00010001},
+	{SYS_ISDBS, 0x60, 0b00010011},
+	{SYS_ISDBT, 0x62, 0b00010000},
+	{SYS_ISDBT, 0x61, 0b00010010},
+};
+#define PT3_ADAPN ARRAY_SIZE(pt3_cfg)
 
-static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
+int pt3_update_lnb(struct pt3_board *pt3)
 {
-	int ret;
-	struct pt3_adapter *adap;
-	struct dvb_adapter *da;
+	u8 i, lnb_eff = 0;
+
+	if (pt3->reset) {
+		writel(pt3_lnb[0].bits, pt3->bar_reg + PT3_REG_SYS_W);
+		pt3->reset = false;
+		pt3->lnb = 0;
+	} else {
+		struct pt3_adapter *adap;
 
-	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
-	if (!adap) {
-		dev_err(&pt3->pdev->dev, "failed to alloc mem for adapter.\n");
-		return -ENOMEM;
+		for (i = 0; i < PT3_ADAPN; i++) {
+			adap = pt3->adap[i];
+			dev_dbg(adap->dvb.device, "#%d sleep %d\n", adap->idx, adap->sleep);
+			if ((pt3_cfg[i].type == SYS_ISDBS) && (!adap->sleep))
+				lnb_eff |= lnb;
+		}
+		if (unlikely(lnb_eff < 0 || 2 < lnb_eff)) {
+			dev_err(&pt3->pdev->dev, "Invalid LNB\n");
+			return -EINVAL;
+		}
+		if (pt3->lnb != lnb_eff) {
+			writel(pt3_lnb[lnb_eff].bits, pt3->bar_reg + PT3_REG_SYS_W);
+			pt3->lnb = lnb_eff;
+		}
 	}
-	pt3->adaps[index] = adap;
-	adap->adap_idx = index;
+	dev_dbg(&pt3->pdev->dev, "LNB=%s\n", pt3_lnb[lnb_eff].str);
+	return 0;
+}
 
-	if (index == 0 || !one_adapter) {
-		ret = dvb_register_adapter(&adap->dvb_adap, "PT3 DVB",
-				THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+int pt3_thread(void *data)
+{
+	size_t ret;
+	struct pt3_adapter *adap = data;
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	set_freezable();
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+		while ((ret = pt3_dma_copy(adap->dma, &adap->demux)) > 0)
+			;
 		if (ret < 0) {
-			dev_err(&pt3->pdev->dev,
-				"failed to register adapter dev.\n");
-			goto err_mem;
+			dev_dbg(adap->dvb.device, "#%d fail dma_copy\n", adap->idx);
+			msleep_interruptible(1);
 		}
-		da = &adap->dvb_adap;
-	} else
-		da = &pt3->adaps[0]->dvb_adap;
-
-	adap->dvb_adap.priv = pt3;
-	adap->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
-	adap->demux.priv = adap;
-	adap->demux.feednum = 256;
-	adap->demux.filternum = 256;
-	adap->demux.start_feed = pt3_start_feed;
-	adap->demux.stop_feed = pt3_stop_feed;
-	ret = dvb_dmx_init(&adap->demux);
-	if (ret < 0) {
-		dev_err(&pt3->pdev->dev, "failed to init dmx dev.\n");
-		goto err_adap;
 	}
+	return 0;
+}
 
-	adap->dmxdev.filternum = 256;
-	adap->dmxdev.demux = &adap->demux.dmx;
-	ret = dvb_dmxdev_init(&adap->dmxdev, da);
-	if (ret < 0) {
-		dev_err(&pt3->pdev->dev, "failed to init dmxdev.\n");
-		goto err_demux;
+int pt3_start_feed(struct dvb_demux_feed *feed)
+{
+	int err = 0;
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!adap->users++) {
+		dev_dbg(adap->dvb.device, "#%d %s selected, DMA %s\n",
+			adap->idx, (pt3_cfg[adap->idx].type == SYS_ISDBS) ? "S" : "T",
+			pt3_dma_get_status(adap->dma) & 1 ? "ON" : "OFF");
+		mutex_lock(&adap->lock);
+		if (!adap->kthread) {
+			adap->kthread = kthread_run(pt3_thread, adap, PT3_DRVNAME "_%d", adap->idx);
+			if (IS_ERR(adap->kthread)) {
+				err = PTR_ERR(adap->kthread);
+				adap->kthread = NULL;
+			} else {
+				pt3_dma_set_test_mode(adap->dma, RESET, 0);	/* reset error count */
+				pt3_dma_set_enabled(adap->dma, true);
+			}
+		}
+		mutex_unlock(&adap->lock);
+		if (err)
+			return err;
 	}
+	return 0;
+}
 
-	ret = pt3_alloc_dmabuf(adap);
-	if (ret) {
-		dev_err(&pt3->pdev->dev, "failed to alloc DMA buffers.\n");
-		goto err_dmabuf;
+int pt3_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!--adap->users) {
+		mutex_lock(&adap->lock);
+		if (adap->kthread) {
+			pt3_dma_set_enabled(adap->dma, false);
+			dev_dbg(adap->dvb.device, "#%d DMA ts_err packet cnt %d\n",
+				adap->idx, pt3_dma_get_ts_error_packet_count(adap->dma));
+			kthread_stop(adap->kthread);
+			adap->kthread = NULL;
+		}
+		mutex_unlock(&adap->lock);
 	}
-
 	return 0;
+}
 
-err_dmabuf:
-	pt3_free_dmabuf(adap);
-	dvb_dmxdev_release(&adap->dmxdev);
-err_demux:
-	dvb_dmx_release(&adap->demux);
-err_adap:
-	if (index == 0 || !one_adapter)
-		dvb_unregister_adapter(da);
-err_mem:
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+struct pt3_adapter *pt3_dvb_register_adapter(struct pt3_board *pt3)
+{
+	int ret;
+	struct dvb_adapter *dvb;
+	struct dvb_demux *demux;
+	struct dmxdev *dmxdev;
+	struct pt3_adapter *adap = kzalloc(sizeof(struct pt3_adapter), GFP_KERNEL);
+
+	if (!adap)
+		return ERR_PTR(-ENOMEM);
+	adap->pt3 = pt3;
+	adap->sleep = true;
+
+	dvb = &adap->dvb;
+	dvb->priv = adap;
+	ret = dvb_register_adapter(dvb, PT3_DRVNAME, THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+	dev_dbg(dvb->device, "adapter%d registered\n", ret);
+	if (ret >= 0) {
+		demux = &adap->demux;
+		demux->dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
+		demux->priv = adap;
+		demux->feednum = 256;
+		demux->filternum = 256;
+		demux->start_feed = pt3_start_feed;
+		demux->stop_feed = pt3_stop_feed;
+		demux->write_to_decoder = NULL;
+		ret = dvb_dmx_init(demux);
+		if (ret >= 0) {
+			dmxdev = &adap->dmxdev;
+			dmxdev->filternum = 256;
+			dmxdev->demux = &demux->dmx;
+			dmxdev->capabilities = 0;
+			ret = dvb_dmxdev_init(dmxdev, dvb);
+			if (ret >= 0)
+				return adap;
+			dvb_dmx_release(demux);
+		}
+		dvb_unregister_adapter(dvb);
+	}
 	kfree(adap);
-	pt3->adaps[index] = NULL;
-	return ret;
+	return ERR_PTR(ret);
 }
 
-static void pt3_cleanup_adapter(struct pt3_board *pt3, int index)
+int pt3_sleep(struct dvb_frontend *fe)
 {
-	struct pt3_adapter *adap;
-	struct dmx_demux *dmx;
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
 
-	adap = pt3->adaps[index];
-	if (adap == NULL)
-		return;
+	dev_dbg(adap->dvb.device, "#%d %s orig %p\n", adap->idx, __func__, adap->orig_sleep);
+	adap->sleep = true;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_sleep) ? adap->orig_sleep(fe) : 0;
+}
+
+int pt3_wakeup(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
 
-	/* stop demux kthread */
-	if (adap->thread)
-		pt3_stop_streaming(adap);
+	dev_dbg(adap->dvb.device, "#%d %s orig %p\n", adap->idx, __func__, adap->orig_init);
+	adap->sleep = false;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_init) ? adap->orig_init(fe) : 0;
+}
+
+void pt3_unregister_subdev(struct i2c_client *clt)
+{
+	if (clt) {
+		module_put(clt->dev.driver->owner);
+		i2c_unregister_device(clt);
+	}
+}
 
-	dmx = &adap->demux.dmx;
-	dmx->close(dmx);
+void pt3_cleanup_adapter(struct pt3_adapter *adap)
+{
+	if (!adap)
+		return;
+	if (adap->kthread)
+		kthread_stop(adap->kthread);
 	if (adap->fe) {
-		adap->fe->callback = NULL;
-		if (adap->fe->frontend_priv)
-			dvb_unregister_frontend(adap->fe);
-		if (adap->i2c_tuner) {
-			module_put(adap->i2c_tuner->dev.driver->owner);
-			i2c_unregister_device(adap->i2c_tuner);
-		}
-		if (adap->i2c_demod) {
-			module_put(adap->i2c_demod->dev.driver->owner);
-			i2c_unregister_device(adap->i2c_demod);
-		}
+		dvb_unregister_frontend(adap->fe);
+		adap->fe->ops.release(adap->fe);
 	}
-	pt3_free_dmabuf(adap);
+	pt3_unregister_subdev(adap->i2c_tuner);
+	pt3_unregister_subdev(adap->i2c_demod);
+	if (adap->dma) {
+		if (adap->dma->enabled)
+			pt3_dma_set_enabled(adap->dma, false);
+		pt3_dma_free(adap->dma);
+	}
+	adap->demux.dmx.close(&adap->demux.dmx);
 	dvb_dmxdev_release(&adap->dmxdev);
 	dvb_dmx_release(&adap->demux);
-	if (index == 0 || !one_adapter)
-		dvb_unregister_adapter(&adap->dvb_adap);
+	dvb_unregister_adapter(&adap->dvb);
 	kfree(adap);
-	pt3->adaps[index] = NULL;
 }
 
-#ifdef CONFIG_PM_SLEEP
-
-static int pt3_suspend(struct device *dev)
+void pt3_remove(struct pci_dev *pdev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pt3_board *pt3 = pci_get_drvdata(pdev);
 	int i;
-	struct pt3_adapter *adap;
+	struct pt3_board *pt3 = pci_get_drvdata(pdev);
 
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		adap = pt3->adaps[i];
-		if (adap->num_feeds > 0)
-			pt3_stop_dma(adap);
-		dvb_frontend_suspend(adap->fe);
-		pt3_free_dmabuf(adap);
+	if (pt3) {
+		pt3->reset = true;
+		pt3_update_lnb(pt3);
+		for (i = 0; i < PT3_ADAPN; i++)
+			pt3_cleanup_adapter(pt3->adap[i]);
+		pt3_i2c_reset(pt3);
+		i2c_del_adapter(&pt3->i2c);
+		if (pt3->bar_mem)
+			iounmap(pt3->bar_mem);
+		if (pt3->bar_reg)
+			iounmap(pt3->bar_reg);
+		pci_release_selected_regions(pdev, pt3->bars);
+		kfree(pt3->adap);
+		kfree(pt3);
 	}
-
-	pt3_lnb_ctrl(pt3, false);
-	pt3_set_tuner_power(pt3, false, false);
-	return 0;
+	pci_disable_device(pdev);
 }
 
-static int pt3_resume(struct device *dev)
+int pt3_abort(struct pci_dev *pdev, int err, char *fmt, ...)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pt3_board *pt3 = pci_get_drvdata(pdev);
-	int i, ret;
-	struct pt3_adapter *adap;
-
-	ret = pt3_fe_init(pt3);
-	if (ret)
-		return ret;
-
-	if (pt3->lna_on_cnt > 0)
-		pt3_set_tuner_power(pt3, true, true);
-	if (pt3->lnb_on_cnt > 0)
-		pt3_lnb_ctrl(pt3, true);
-
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		adap = pt3->adaps[i];
-		dvb_frontend_resume(adap->fe);
-		ret = pt3_alloc_dmabuf(adap);
-		if (ret) {
-			dev_err(&pt3->pdev->dev, "failed to alloc DMA bufs.\n");
-			continue;
-		}
-		if (adap->num_feeds > 0)
-			pt3_start_dma(adap);
-	}
-
-	return 0;
+	va_list ap;
+	char *s = NULL;
+	int slen;
+
+	va_start(ap, fmt);
+	slen = vsnprintf(s, 0, fmt, ap);
+	s = vzalloc(slen);
+	if (slen > 0 && s) {
+		vsnprintf(s, slen, fmt, ap);
+		dev_err(&pdev->dev, "%s", s);
+		vfree(s);
+	}
+	va_end(ap);
+	pt3_remove(pdev);
+	return err;
 }
 
-#endif /* CONFIG_PM_SLEEP */
-
-
-static void pt3_remove(struct pci_dev *pdev)
+struct i2c_client *pt3_register_subdev(struct i2c_adapter *adap, struct i2c_board_info const *info)
 {
-	struct pt3_board *pt3;
-	int i;
-
-	pt3 = pci_get_drvdata(pdev);
-	for (i = PT3_NUM_FE - 1; i >= 0; i--)
-		pt3_cleanup_adapter(pt3, i);
-	i2c_del_adapter(&pt3->i2c_adap);
-	kfree(pt3->i2c_buf);
-	pci_iounmap(pt3->pdev, pt3->regs[0]);
-	pci_iounmap(pt3->pdev, pt3->regs[1]);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-	kfree(pt3);
+	struct i2c_client *clt;
+
+	request_module("%s", info->type);
+	clt = i2c_new_device(adap, info);
+	if (clt && clt->dev.driver)
+		if (!try_module_get(clt->dev.driver->owner)) {
+			i2c_unregister_device(clt);
+			clt = NULL;
+		}
+	return clt;
 }
 
-static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	u8 rev;
-	u32 ver;
-	int i, ret;
 	struct pt3_board *pt3;
-	struct i2c_adapter *i2c;
-
-	if (pci_read_config_byte(pdev, PCI_REVISION_ID, &rev) || rev != 1)
-		return -ENODEV;
+	struct pt3_adapter *adap;
+	const struct pt3_cfg *cfg = pt3_cfg;
+	struct dvb_frontend *fe[PT3_ADAPN];
+	u8 i;
+	int err, bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	err = pci_enable_device(pdev)					||
+		pci_set_dma_mask(pdev, DMA_BIT_MASK(64))		||
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))	||
+		pci_read_config_byte(pdev, PCI_CLASS_REVISION, &i)	||
+		pci_request_selected_regions(pdev, bars, PT3_DRVNAME);
+	if (err)
+		return pt3_abort(pdev, err, "PCI/DMA error\n");
+	if (i != 1)
+		return pt3_abort(pdev, -EINVAL, "Revision 0x%x is not supported\n", i);
 
-	ret = pci_enable_device(pdev);
-	if (ret < 0)
-		return -ENODEV;
 	pci_set_master(pdev);
-
-	ret = pci_request_regions(pdev, DRV_NAME);
-	if (ret < 0)
-		goto err_disable_device;
-
-	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-	if (ret == 0)
-		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-	else {
-		ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (ret == 0)
-			dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
-		else {
-			dev_err(&pdev->dev, "Failed to set DMA mask.\n");
-			goto err_release_regions;
-		}
-		dev_info(&pdev->dev, "Use 32bit DMA.\n");
-	}
-
-	pt3 = kzalloc(sizeof(*pt3), GFP_KERNEL);
-	if (!pt3) {
-		dev_err(&pdev->dev, "Failed to alloc mem for this dev.\n");
-		ret = -ENOMEM;
-		goto err_release_regions;
-	}
-	pci_set_drvdata(pdev, pt3);
+	pt3 = kzalloc(sizeof(struct pt3_board), GFP_KERNEL);
+	if (!pt3)
+		return pt3_abort(pdev, -ENOMEM, "struct pt3_board out of memory\n");
+	pt3->adap = kcalloc(PT3_ADAPN, sizeof(struct pt3_adapter *), GFP_KERNEL);
+	if (!pt3->adap)
+		return pt3_abort(pdev, -ENOMEM, "No memory for *adap\n");
+
+	pt3->bars = bars;
 	pt3->pdev = pdev;
+	pci_set_drvdata(pdev, pt3);
+	pt3->bar_reg = pci_ioremap_bar(pdev, 0);
+	pt3->bar_mem = pci_ioremap_bar(pdev, 2);
+	if (!pt3->bar_reg || !pt3->bar_mem)
+		return pt3_abort(pdev, -EIO, "Failed pci_ioremap_bar\n");
+
+	err = readl(pt3->bar_reg + PT3_REG_VERSION);
+	i = ((err >> 24) & 0xFF);
+	if (i != 3)
+		return pt3_abort(pdev, -EIO, "ID=0x%x, not a PT3\n", i);
+	i = ((err >>  8) & 0xFF);
+	if (i != 4)
+		return pt3_abort(pdev, -EIO, "FPGA version 0x%x is not supported\n", i);
+	err = pt3_i2c_add_adapter(pt3);
+	if (err < 0)
+		return pt3_abort(pdev, err, "Cannot add I2C\n");
 	mutex_init(&pt3->lock);
-	pt3->regs[0] = pci_ioremap_bar(pdev, 0);
-	pt3->regs[1] = pci_ioremap_bar(pdev, 2);
-	if (pt3->regs[0] == NULL || pt3->regs[1] == NULL) {
-		dev_err(&pdev->dev, "Failed to ioremap.\n");
-		ret = -ENOMEM;
-		goto err_kfree;
-	}
-
-	ver = ioread32(pt3->regs[0] + REG_VERSION);
-	if ((ver >> 16) != 0x0301) {
-		dev_warn(&pdev->dev, "PT%d, I/F-ver.:%d not supported",
-			ver >> 24, (ver & 0x00ff0000) >> 16);
-		ret = -ENODEV;
-		goto err_iounmap;
-	}
-
-	pt3->num_bufs = clamp_val(num_bufs, MIN_DATA_BUFS, MAX_DATA_BUFS);
-
-	pt3->i2c_buf = kmalloc(sizeof(*pt3->i2c_buf), GFP_KERNEL);
-	if (pt3->i2c_buf == NULL) {
-		dev_err(&pdev->dev, "Failed to alloc mem for i2c.\n");
-		ret = -ENOMEM;
-		goto err_iounmap;
-	}
-	i2c = &pt3->i2c_adap;
-	i2c->owner = THIS_MODULE;
-	i2c->algo = &pt3_i2c_algo;
-	i2c->algo_data = NULL;
-	i2c->dev.parent = &pdev->dev;
-	strlcpy(i2c->name, DRV_NAME, sizeof(i2c->name));
-	i2c_set_adapdata(i2c, pt3);
-	ret = i2c_add_adapter(i2c);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to add i2c adapter.\n");
-		goto err_i2cbuf;
-	}
-
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		ret = pt3_alloc_adapter(pt3, i);
-		if (ret < 0)
-			break;
-
-		ret = pt3_attach_fe(pt3, i);
-		if (ret < 0)
-			break;
-	}
-	if (i < PT3_NUM_FE) {
-		dev_err(&pdev->dev, "Failed to create FE%d.\n", i);
-		goto err_cleanup_adapters;
-	}
 
-	ret = pt3_fe_init(pt3);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to init frontends.\n");
-		i = PT3_NUM_FE - 1;
-		goto err_cleanup_adapters;
+	for (i = 0; i < PT3_ADAPN; i++) {
+		adap = pt3_dvb_register_adapter(pt3);
+		if (IS_ERR(adap))
+			return pt3_abort(pdev, PTR_ERR(adap), "Failed pt3_dvb_register_adapter\n");
+		adap->idx = i;
+		adap->dma = pt3_dma_create(adap);
+		if (!adap->dma)
+			return pt3_abort(pdev, -ENOMEM, "Failed pt3_dma_create\n");
+		pt3->adap[i] = adap;
+		adap->sleep = true;
+		mutex_init(&adap->lock);
+	}
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		struct tc90522_config cfg_demod = {};
+		struct i2c_board_info info = {};
+
+		adap = pt3->adap[i];
+		cfg_demod.type = cfg[i].type;
+		cfg_demod.pwr = i + 1 == PT3_ADAPN;
+		info.addr = cfg[i].addr_demod;
+		info.platform_data = &cfg_demod;
+		strlcpy(info.type, TC90522_DRVNAME, I2C_NAME_SIZE);
+		adap->i2c_demod = pt3_register_subdev(&pt3->i2c, &info);
+		if (!adap->i2c_demod)
+			return pt3_abort(pdev, -ENODEV, "Cannot register I2C demod\n");
+		fe[i] = cfg_demod.fe;
+
+		info.addr = cfg[i].addr_tuner;
+		info.platform_data = fe[i];
+		strlcpy(info.type, cfg[i].type == SYS_ISDBS ? QM1D1C0042_DRVNAME : MXL301RF_DRVNAME, I2C_NAME_SIZE);
+		adap->i2c_tuner = pt3_register_subdev(&pt3->i2c, &info);
+		if (!adap->i2c_tuner)
+			return pt3_abort(pdev, -ENODEV, "Cannot register I2C tuner\n");
+	}
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		dev_dbg(&pdev->dev, "#%d %s\n", i, __func__);
+		adap = pt3->adap[i];
+		adap->orig_sleep	= fe[i]->ops.sleep;
+		adap->orig_init		= fe[i]->ops.init;
+		fe[i]->ops.sleep	= pt3_sleep;
+		fe[i]->ops.init		= pt3_wakeup;
+		fe[i]->dvb		= &adap->dvb;
+		if ((adap->orig_init(fe[i]) && adap->orig_init(fe[i]) && adap->orig_init(fe[i])) ||
+			adap->orig_sleep(fe[i]) || dvb_register_frontend(&adap->dvb, fe[i])) {
+			while (i--)
+				dvb_unregister_frontend(fe[i]);
+			for (i = 0; i < PT3_ADAPN; i++) {
+				fe[i]->ops.release(fe[i]);
+				adap->fe = NULL;
+			}
+			return pt3_abort(pdev, -EREMOTEIO, "Cannot register frontend\n");
+		}
+		adap->fe = fe[i];
 	}
-
-	dev_info(&pdev->dev,
-		"successfully init'ed PT%d (fw:0x%02x, I/F:0x%02x).\n",
-		ver >> 24, (ver >> 8) & 0xff, (ver >> 16) & 0xff);
+	pt3->reset = true;
+	pt3_update_lnb(pt3);
 	return 0;
-
-err_cleanup_adapters:
-	while (i >= 0)
-		pt3_cleanup_adapter(pt3, i--);
-	i2c_del_adapter(i2c);
-err_i2cbuf:
-	kfree(pt3->i2c_buf);
-err_iounmap:
-	if (pt3->regs[0])
-		pci_iounmap(pdev, pt3->regs[0]);
-	if (pt3->regs[1])
-		pci_iounmap(pdev, pt3->regs[1]);
-err_kfree:
-	kfree(pt3);
-err_release_regions:
-	pci_release_regions(pdev);
-err_disable_device:
-	pci_disable_device(pdev);
-	return ret;
-
 }
 
-static const struct pci_device_id pt3_id_table[] = {
-	{ PCI_DEVICE_SUB(0x1172, 0x4c15, 0xee8d, 0x0368) },
-	{ },
-};
-MODULE_DEVICE_TABLE(pci, pt3_id_table);
-
-static SIMPLE_DEV_PM_OPS(pt3_pm_ops, pt3_suspend, pt3_resume);
-
 static struct pci_driver pt3_driver = {
-	.name		= DRV_NAME,
+	.name		= PT3_DRVNAME,
 	.probe		= pt3_probe,
 	.remove		= pt3_remove,
 	.id_table	= pt3_id_table,
-
-	.driver.pm	= &pt3_pm_ops,
 };
-
 module_pci_driver(pt3_driver);
 
-MODULE_DESCRIPTION("Earthsoft PT3 Driver");
-MODULE_AUTHOR("Akihiro TSUKADA");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
deleted file mode 100644
index f0ce904..0000000
--- a/drivers/media/pci/pt3/pt3_dma.c
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * Earthsoft PT3 driver
- *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/dma-mapping.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-
-#include "pt3.h"
-
-#define PT3_ACCESS_UNIT (TS_PACKET_SZ * 128)
-#define PT3_BUF_CANARY  (0x74)
-
-static u32 get_dma_base(int idx)
-{
-	int i;
-
-	i = (idx == 1 || idx == 2) ? 3 - idx : idx;
-	return REG_DMA_BASE + 0x18 * i;
-}
-
-int pt3_stop_dma(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3 = adap->dvb_adap.priv;
-	u32 base;
-	u32 stat;
-	int retry;
-
-	base = get_dma_base(adap->adap_idx);
-	stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
-	if (!(stat & 0x01))
-		return 0;
-
-	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
-	for (retry = 0; retry < 5; retry++) {
-		stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
-		if (!(stat & 0x01))
-			return 0;
-		msleep(50);
-	}
-	return -EIO;
-}
-
-int pt3_start_dma(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3 = adap->dvb_adap.priv;
-	u32 base = get_dma_base(adap->adap_idx);
-
-	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
-	iowrite32(lower_32_bits(adap->desc_buf[0].b_addr),
-			pt3->regs[0] + base + OFST_DMA_DESC_L);
-	iowrite32(upper_32_bits(adap->desc_buf[0].b_addr),
-			pt3->regs[0] + base + OFST_DMA_DESC_H);
-	iowrite32(0x01, pt3->regs[0] + base + OFST_DMA_CTL);
-	return 0;
-}
-
-
-static u8 *next_unit(struct pt3_adapter *adap, int *idx, int *ofs)
-{
-	*ofs += PT3_ACCESS_UNIT;
-	if (*ofs >= DATA_BUF_SZ) {
-		*ofs -= DATA_BUF_SZ;
-		(*idx)++;
-		if (*idx == adap->num_bufs)
-			*idx = 0;
-	}
-	return &adap->buffer[*idx].data[*ofs];
-}
-
-int pt3_proc_dma(struct pt3_adapter *adap)
-{
-	int idx, ofs;
-
-	idx = adap->buf_idx;
-	ofs = adap->buf_ofs;
-
-	if (adap->buffer[idx].data[ofs] == PT3_BUF_CANARY)
-		return 0;
-
-	while (*next_unit(adap, &idx, &ofs) != PT3_BUF_CANARY) {
-		u8 *p;
-
-		p = &adap->buffer[adap->buf_idx].data[adap->buf_ofs];
-		if (adap->num_discard > 0)
-			adap->num_discard--;
-		else if (adap->buf_ofs + PT3_ACCESS_UNIT > DATA_BUF_SZ) {
-			dvb_dmx_swfilter_packets(&adap->demux, p,
-				(DATA_BUF_SZ - adap->buf_ofs) / TS_PACKET_SZ);
-			dvb_dmx_swfilter_packets(&adap->demux,
-				adap->buffer[idx].data, ofs / TS_PACKET_SZ);
-		} else
-			dvb_dmx_swfilter_packets(&adap->demux, p,
-				PT3_ACCESS_UNIT / TS_PACKET_SZ);
-
-		*p = PT3_BUF_CANARY;
-		adap->buf_idx = idx;
-		adap->buf_ofs = ofs;
-	}
-	return 0;
-}
-
-void pt3_init_dmabuf(struct pt3_adapter *adap)
-{
-	int idx, ofs;
-	u8 *p;
-
-	idx = 0;
-	ofs = 0;
-	p = adap->buffer[0].data;
-	/* mark the whole buffers as "not written yet" */
-	while (idx < adap->num_bufs) {
-		p[ofs] = PT3_BUF_CANARY;
-		ofs += PT3_ACCESS_UNIT;
-		if (ofs >= DATA_BUF_SZ) {
-			ofs -= DATA_BUF_SZ;
-			idx++;
-			p = adap->buffer[idx].data;
-		}
-	}
-	adap->buf_idx = 0;
-	adap->buf_ofs = 0;
-}
-
-void pt3_free_dmabuf(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3;
-	int i;
-
-	pt3 = adap->dvb_adap.priv;
-	for (i = 0; i < adap->num_bufs; i++)
-		dma_free_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
-			adap->buffer[i].data, adap->buffer[i].b_addr);
-	adap->num_bufs = 0;
-
-	for (i = 0; i < adap->num_desc_bufs; i++)
-		dma_free_coherent(&pt3->pdev->dev, PAGE_SIZE,
-			adap->desc_buf[i].descs, adap->desc_buf[i].b_addr);
-	adap->num_desc_bufs = 0;
-}
-
-
-int pt3_alloc_dmabuf(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3;
-	void *p;
-	int i, j;
-	int idx, ofs;
-	int num_desc_bufs;
-	dma_addr_t data_addr, desc_addr;
-	struct xfer_desc *d;
-
-	pt3 = adap->dvb_adap.priv;
-	adap->num_bufs = 0;
-	adap->num_desc_bufs = 0;
-	for (i = 0; i < pt3->num_bufs; i++) {
-		p = dma_alloc_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
-					&adap->buffer[i].b_addr, GFP_KERNEL);
-		if (p == NULL)
-			goto failed;
-		adap->buffer[i].data = p;
-		adap->num_bufs++;
-	}
-	pt3_init_dmabuf(adap);
-
-	/* build circular-linked pointers (xfer_desc) to the data buffers*/
-	idx = 0;
-	ofs = 0;
-	num_desc_bufs =
-		DIV_ROUND_UP(adap->num_bufs * DATA_BUF_XFERS, DESCS_IN_PAGE);
-	for (i = 0; i < num_desc_bufs; i++) {
-		p = dma_alloc_coherent(&pt3->pdev->dev, PAGE_SIZE,
-					&desc_addr, GFP_KERNEL);
-		if (p == NULL)
-			goto failed;
-		adap->num_desc_bufs++;
-		adap->desc_buf[i].descs = p;
-		adap->desc_buf[i].b_addr = desc_addr;
-
-		if (i > 0) {
-			d = &adap->desc_buf[i - 1].descs[DESCS_IN_PAGE - 1];
-			d->next_l = lower_32_bits(desc_addr);
-			d->next_h = upper_32_bits(desc_addr);
-		}
-		for (j = 0; j < DESCS_IN_PAGE; j++) {
-			data_addr = adap->buffer[idx].b_addr + ofs;
-			d = &adap->desc_buf[i].descs[j];
-			d->addr_l = lower_32_bits(data_addr);
-			d->addr_h = upper_32_bits(data_addr);
-			d->size = DATA_XFER_SZ;
-
-			desc_addr += sizeof(struct xfer_desc);
-			d->next_l = lower_32_bits(desc_addr);
-			d->next_h = upper_32_bits(desc_addr);
-
-			ofs += DATA_XFER_SZ;
-			if (ofs >= DATA_BUF_SZ) {
-				ofs -= DATA_BUF_SZ;
-				idx++;
-				if (idx >= adap->num_bufs) {
-					desc_addr = adap->desc_buf[0].b_addr;
-					d->next_l = lower_32_bits(desc_addr);
-					d->next_h = upper_32_bits(desc_addr);
-					return 0;
-				}
-			}
-		}
-	}
-	return 0;
-
-failed:
-	pt3_free_dmabuf(adap);
-	return -ENOMEM;
-}
diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
deleted file mode 100644
index ec6a8a2..0000000
--- a/drivers/media/pci/pt3/pt3_i2c.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * Earthsoft PT3 driver
- *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <linux/i2c.h>
-#include <linux/io.h>
-#include <linux/pci.h>
-
-#include "pt3.h"
-
-#define PT3_I2C_BASE  2048
-#define PT3_CMD_ADDR_NORMAL 0
-#define PT3_CMD_ADDR_INIT_DEMOD  4096
-#define PT3_CMD_ADDR_INIT_TUNER  (4096 + 2042)
-
-/* masks for I2C status register */
-#define STAT_SEQ_RUNNING 0x1
-#define STAT_SEQ_ERROR   0x6
-#define STAT_NO_SEQ      0x8
-
-#define PT3_I2C_RUN   (1 << 16)
-#define PT3_I2C_RESET (1 << 17)
-
-enum ctl_cmd {
-	I_END,
-	I_ADDRESS,
-	I_CLOCK_L,
-	I_CLOCK_H,
-	I_DATA_L,
-	I_DATA_H,
-	I_RESET,
-	I_SLEEP,
-	I_DATA_L_NOP  = 0x08,
-	I_DATA_H_NOP  = 0x0c,
-	I_DATA_H_READ = 0x0d,
-	I_DATA_H_ACK0 = 0x0e,
-	I_DATA_H_ACK1 = 0x0f,
-};
-
-
-static void cmdbuf_add(struct pt3_i2cbuf *cbuf, enum ctl_cmd cmd)
-{
-	int buf_idx;
-
-	if ((cbuf->num_cmds % 2) == 0)
-		cbuf->tmp = cmd;
-	else {
-		cbuf->tmp |= cmd << 4;
-		buf_idx = cbuf->num_cmds / 2;
-		if (buf_idx < ARRAY_SIZE(cbuf->data))
-			cbuf->data[buf_idx] = cbuf->tmp;
-	}
-	cbuf->num_cmds++;
-}
-
-static void put_end(struct pt3_i2cbuf *cbuf)
-{
-	cmdbuf_add(cbuf, I_END);
-	if (cbuf->num_cmds % 2)
-		cmdbuf_add(cbuf, I_END);
-}
-
-static void put_start(struct pt3_i2cbuf *cbuf)
-{
-	cmdbuf_add(cbuf, I_DATA_H);
-	cmdbuf_add(cbuf, I_CLOCK_H);
-	cmdbuf_add(cbuf, I_DATA_L);
-	cmdbuf_add(cbuf, I_CLOCK_L);
-}
-
-static void put_byte_write(struct pt3_i2cbuf *cbuf, u8 val)
-{
-	u8 mask;
-
-	mask = 0x80;
-	for (mask = 0x80; mask > 0; mask >>= 1)
-		cmdbuf_add(cbuf, (val & mask) ? I_DATA_H_NOP : I_DATA_L_NOP);
-	cmdbuf_add(cbuf, I_DATA_H_ACK0);
-}
-
-static void put_byte_read(struct pt3_i2cbuf *cbuf, u32 size)
-{
-	int i, j;
-
-	for (i = 0; i < size; i++) {
-		for (j = 0; j < 8; j++)
-			cmdbuf_add(cbuf, I_DATA_H_READ);
-		cmdbuf_add(cbuf, (i == size - 1) ? I_DATA_H_NOP : I_DATA_L_NOP);
-	}
-}
-
-static void put_stop(struct pt3_i2cbuf *cbuf)
-{
-	cmdbuf_add(cbuf, I_DATA_L);
-	cmdbuf_add(cbuf, I_CLOCK_H);
-	cmdbuf_add(cbuf, I_DATA_H);
-}
-
-
-/* translates msgs to internal commands for bit-banging */
-static void translate(struct pt3_i2cbuf *cbuf, struct i2c_msg *msgs, int num)
-{
-	int i, j;
-	bool rd;
-
-	cbuf->num_cmds = 0;
-	for (i = 0; i < num; i++) {
-		rd = !!(msgs[i].flags & I2C_M_RD);
-		put_start(cbuf);
-		put_byte_write(cbuf, msgs[i].addr << 1 | rd);
-		if (rd)
-			put_byte_read(cbuf, msgs[i].len);
-		else
-			for (j = 0; j < msgs[i].len; j++)
-				put_byte_write(cbuf, msgs[i].buf[j]);
-	}
-	if (num > 0) {
-		put_stop(cbuf);
-		put_end(cbuf);
-	}
-}
-
-static int wait_i2c_result(struct pt3_board *pt3, u32 *result, int max_wait)
-{
-	int i;
-	u32 v;
-
-	for (i = 0; i < max_wait; i++) {
-		v = ioread32(pt3->regs[0] + REG_I2C_R);
-		if (!(v & STAT_SEQ_RUNNING))
-			break;
-		usleep_range(500, 750);
-	}
-	if (i >= max_wait)
-		return -EIO;
-	if (result)
-		*result = v;
-	return 0;
-}
-
-/* send [pre-]translated i2c msgs stored at addr */
-static int send_i2c_cmd(struct pt3_board *pt3, u32 addr)
-{
-	u32 ret;
-
-	/* make sure that previous transactions had finished */
-	if (wait_i2c_result(pt3, NULL, 50)) {
-		dev_warn(&pt3->pdev->dev, "(%s) prev. transaction stalled\n",
-				__func__);
-		return -EIO;
-	}
-
-	iowrite32(PT3_I2C_RUN | addr, pt3->regs[0] + REG_I2C_W);
-	usleep_range(200, 300);
-	/* wait for the current transaction to finish */
-	if (wait_i2c_result(pt3, &ret, 500) || (ret & STAT_SEQ_ERROR)) {
-		dev_warn(&pt3->pdev->dev, "(%s) failed.\n", __func__);
-		return -EIO;
-	}
-	return 0;
-}
-
-
-/* init commands for each demod are combined into one transaction
- *  and hidden in ROM with the address PT3_CMD_ADDR_INIT_DEMOD.
- */
-int  pt3_init_all_demods(struct pt3_board *pt3)
-{
-	ioread32(pt3->regs[0] + REG_I2C_R);
-	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_DEMOD);
-}
-
-/* init commands for two ISDB-T tuners are hidden in ROM. */
-int  pt3_init_all_mxl301rf(struct pt3_board *pt3)
-{
-	usleep_range(1000, 2000);
-	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_TUNER);
-}
-
-void pt3_i2c_reset(struct pt3_board *pt3)
-{
-	iowrite32(PT3_I2C_RESET, pt3->regs[0] + REG_I2C_W);
-}
-
-/*
- * I2C algorithm
- */
-int
-pt3_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
-{
-	struct pt3_board *pt3;
-	struct pt3_i2cbuf *cbuf;
-	int i;
-	void __iomem *p;
-
-	pt3 = i2c_get_adapdata(adap);
-	cbuf = pt3->i2c_buf;
-
-	for (i = 0; i < num; i++)
-		if (msgs[i].flags & I2C_M_RECV_LEN) {
-			dev_warn(&pt3->pdev->dev,
-				"(%s) I2C_M_RECV_LEN not supported.\n",
-				__func__);
-			return -EINVAL;
-		}
-
-	translate(cbuf, msgs, num);
-	memcpy_toio(pt3->regs[1] + PT3_I2C_BASE + PT3_CMD_ADDR_NORMAL / 2,
-			cbuf->data, cbuf->num_cmds);
-
-	if (send_i2c_cmd(pt3, PT3_CMD_ADDR_NORMAL) < 0)
-		return -EIO;
-
-	p = pt3->regs[1] + PT3_I2C_BASE;
-	for (i = 0; i < num; i++)
-		if ((msgs[i].flags & I2C_M_RD) && msgs[i].len > 0) {
-			memcpy_fromio(msgs[i].buf, p, msgs[i].len);
-			p += msgs[i].len;
-		}
-
-	return num;
-}
-
-u32 pt3_i2c_functionality(struct i2c_adapter *adap)
-{
-	return I2C_FUNC_I2C;
-}
-- 
1.8.4.5

