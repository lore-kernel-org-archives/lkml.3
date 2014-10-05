Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaJEJAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:00:46 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54174 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaJEJAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:40 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 10/11] qm1d1c0042: namespace cleanup & remodelling
Date: Sun,  5 Oct 2014 17:59:46 +0900
Message-Id: <b4e2b62c75f5b336a4a0f8757ba9f4e4d8c59585.1412497399.git.knightrider@are.ma>
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

- minimize exports
- use client->dev.platform_data to point frontend
- use real address for I2C
- no freq limits in FE, it is non sense. move here...
- try to treat invalid frequency as channel number

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/tuners/qm1d1c0042.c | 644 ++++++++++++++++++--------------------
 1 file changed, 296 insertions(+), 348 deletions(-)

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 18bc745..39adc0a 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -1,12 +1,12 @@
 /*
- * Sharp QM1D1C0042 8PSK tuner driver
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
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
@@ -14,156 +14,145 @@
  * GNU General Public License for more details.
  */
 
-/*
- * NOTICE:
- * As the disclosed information on the chip is very limited,
- * this driver lacks some features, including chip config like IF freq.
- * It assumes that users of this driver (such as a PCI bridge of
- * DTV receiver cards) know the relevant info and
- * configure the chip via I2C if necessary.
- *
- * Currently, PT3 driver is the only one that uses this driver,
- * and contains init/config code in its firmware.
- * Thus some part of the code might be dependent on PT3 specific config.
- */
-
-#include <linux/kernel.h>
-#include <linux/math64.h>
+#include "dvb_frontend.h"
 #include "qm1d1c0042.h"
 
-#define QM1D1C0042_NUM_REGS 0x20
+struct qm1d1c0042 {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx, reg[32];
+	u32 freq;
+	int (*read)(struct dvb_frontend *fe, u8 *buf, int buflen);
+};
 
-static const u8 reg_initval[QM1D1C0042_NUM_REGS] = {
+static const u8 qm1d1c0042_reg_rw[] = {
 	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
 	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
 	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
-	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
-};
-
-static const struct qm1d1c0042_config default_cfg = {
-	.xtal_freq = 16000,
-	.lpf = 1,
-	.fast_srch = 0,
-	.lpf_wait = 20,
-	.fast_srch_wait = 4,
-	.normal_srch_wait = 15,
+	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00,
 };
 
-struct qm1d1c0042_state {
-	struct qm1d1c0042_config cfg;
-	struct i2c_client *i2c;
-	u8 regs[QM1D1C0042_NUM_REGS];
-};
-
-static struct qm1d1c0042_state *cfg_to_state(struct qm1d1c0042_config *c)
-{
-	return container_of(c, struct qm1d1c0042_state, cfg);
-}
-
-static int reg_write(struct qm1d1c0042_state *state, u8 reg, u8 val)
+/* read via demodulator */
+int qm1d1c0042_fe_read(struct dvb_frontend *fe, u8 addr_data, u8 *data)
 {
-	u8 wbuf[2] = { reg, val };
 	int ret;
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 addr[] = { qm->addr_tuner, addr_data };
 
-	ret = i2c_master_send(state->i2c, wbuf, sizeof(wbuf));
-	if (ret >= 0 && ret < sizeof(wbuf))
-		ret = -EIO;
-	return (ret == sizeof(wbuf)) ? 0 : ret;
+	if ((addr_data != 0x00) && (addr_data != 0x0d))
+		return -EFAULT;
+	ret = qm->read(fe, addr, ARRAY_SIZE(addr));
+	if (ret < 0)
+		return ret;
+	*data = ret;
+	return 0;
 }
 
-static int reg_read(struct qm1d1c0042_state *state, u8 reg, u8 *val)
+/* write via demodulator */
+int qm1d1c0042_fe_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, int len)
 {
-	struct i2c_msg msgs[2] = {
-		{
-			.addr = state->i2c->addr,
-			.flags = 0,
-			.buf = &reg,
-			.len = 1,
-		},
-		{
-			.addr = state->i2c->addr,
-			.flags = I2C_M_RD,
-			.buf = val,
-			.len = 1,
-		},
-	};
-	int ret;
+	u8 buf[len + 1];
 
-	ret = i2c_transfer(state->i2c->adapter, msgs, ARRAY_SIZE(msgs));
-	if (ret >= 0 && ret < ARRAY_SIZE(msgs))
-		ret = -EIO;
-	return (ret == ARRAY_SIZE(msgs)) ? 0 : ret;
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
 }
 
+#define QM1D1C0042_FE_PASSTHROUGH 0xfe
 
-static int qm1d1c0042_set_srch_mode(struct qm1d1c0042_state *state, bool fast)
+int qm1d1c0042_fe_write_tuner(struct dvb_frontend *fe, u8 *data, int len)
 {
-	if (fast)
-		state->regs[0x03] |= 0x01; /* set fast search mode */
-	else
-		state->regs[0x03] &= ~0x01 & 0xff;
+	u8 buf[len + 2];
 
-	return reg_write(state, 0x03, state->regs[0x03]);
+	buf[0] = QM1D1C0042_FE_PASSTHROUGH;
+	buf[1] = ((struct qm1d1c0042 *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
 }
 
-static int qm1d1c0042_wakeup(struct qm1d1c0042_state *state)
+int qm1d1c0042_write(struct dvb_frontend *fe, u8 addr, u8 data)
 {
-	int ret;
-
-	state->regs[0x01] |= 1 << 3;             /* BB_Reg_enable */
-	state->regs[0x01] &= (~(1 << 0)) & 0xff; /* NORMAL (wake-up) */
-	state->regs[0x05] &= (~(1 << 3)) & 0xff; /* pfd_rst NORMAL */
-	ret = reg_write(state, 0x01, state->regs[0x01]);
-	if (ret == 0)
-		ret = reg_write(state, 0x05, state->regs[0x05]);
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf[] = { addr, data };
+	int err = qm1d1c0042_fe_write_tuner(fe, buf, sizeof(buf));
 
-	if (ret < 0)
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, state->cfg.fe->dvb->num, state->cfg.fe->id);
-	return ret;
+	qm->reg[addr] = buf[1];
+	return err;
 }
 
-/* tuner_ops */
-
-static int qm1d1c0042_set_config(struct dvb_frontend *fe, void *priv_cfg)
+int qm1d1c0042_write_pskmsrst(struct dvb_frontend *fe)
 {
-	struct qm1d1c0042_state *state;
-	struct qm1d1c0042_config *cfg;
-
-	state = fe->tuner_priv;
-	cfg = priv_cfg;
+	u8 data = 0x01;
 
-	if (cfg->fe)
-		state->cfg.fe = cfg->fe;
+	return qm1d1c0042_fe_write_data(fe, 0x03, &data, 1);
+}
 
-	if (cfg->xtal_freq != QM1D1C0042_CFG_XTAL_DFLT)
-		dev_warn(&state->i2c->dev,
-			"(%s) changing xtal_freq not supported. ", __func__);
-	state->cfg.xtal_freq = default_cfg.xtal_freq;
+enum qm1d1c0042_agc {
+	QM1D1C0042_AGC_AUTO,
+	QM1D1C0042_AGC_MANUAL,
+};
 
-	state->cfg.lpf = cfg->lpf;
-	state->cfg.fast_srch = cfg->fast_srch;
+int qm1d1c0042_set_agc(struct dvb_frontend *fe, enum qm1d1c0042_agc agc)
+{
+	u8 data = (agc == QM1D1C0042_AGC_AUTO) ? 0xff : 0x00;
+	int err = qm1d1c0042_fe_write_data(fe, 0x0a, &data, 1);
+
+	if (err)
+		return err;
+	data = 0xb0 | ((agc == QM1D1C0042_AGC_AUTO) ? 1 : 0);
+	err = qm1d1c0042_fe_write_data(fe, 0x10, &data, 1);
+	if (err)
+		return err;
+
+	data = (agc == QM1D1C0042_AGC_AUTO) ? 0x40 : 0x00;
+	return (err = qm1d1c0042_fe_write_data(fe, 0x11, &data, 1)) ? err : qm1d1c0042_write_pskmsrst(fe);
+}
 
-	if (cfg->lpf_wait != QM1D1C0042_CFG_WAIT_DFLT)
-		state->cfg.lpf_wait = cfg->lpf_wait;
-	else
-		state->cfg.lpf_wait = default_cfg.lpf_wait;
+int qm1d1c0042_sleep(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 1;
+
+	dev_dbg(fe->dvb->device, "#%d %s\n", qm->idx, __func__);
+	qm->reg[0x01] &= (~(1 << 3)) & 0xff;
+	qm->reg[0x01] |= 1 << 0;
+	qm->reg[0x05] |= 1 << 3;
+	return	qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL)	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05])	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1);
+}
 
-	if (cfg->fast_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
-		state->cfg.fast_srch_wait = cfg->fast_srch_wait;
-	else
-		state->cfg.fast_srch_wait = default_cfg.fast_srch_wait;
+int qm1d1c0042_wakeup(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 0;
+
+	dev_dbg(fe->dvb->device, "#%d %s\n", qm->idx, __func__);
+	qm->reg[0x01] |= 1 << 3;
+	qm->reg[0x01] &= (~(1 << 0)) & 0xff;
+	qm->reg[0x05] &= (~(1 << 3)) & 0xff;
+	return	qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1)	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05]);
+}
 
-	if (cfg->normal_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
-		state->cfg.normal_srch_wait = cfg->normal_srch_wait;
-	else
-		state->cfg.normal_srch_wait = default_cfg.normal_srch_wait;
-	return 0;
+void qm1d1c0042_ch2freq(u32 channel, u32 *number, u32 *freq)
+{
+	if (channel < 12) {
+		*number = 1 + 2 * channel;
+		*freq = 104948 + 3836 * channel;
+	} else if (channel < 24) {
+		channel -= 12;
+		*number = 2 + 2 * channel;
+		*freq = 161300 + 4000 * channel;
+	} else {
+		channel -= 24;
+		*number = 1 + 2 * channel;
+		*freq = 159300 + 4000 * channel;
+	}
 }
 
-/* divisor, vco_band parameters */
-/*  {maxfreq,  param1(band?), param2(div?) */
-static const u32 conv_table[9][3] = {
+static const u32 qm1d1c0042_freq_tab[9][3] = {
 	{ 2151000, 1, 7 },
 	{ 1950000, 1, 6 },
 	{ 1800000, 1, 5 },
@@ -175,274 +164,233 @@ static const u32 conv_table[9][3] = {
 	{  950000, 0, 0 }
 };
 
-static int qm1d1c0042_set_params(struct dvb_frontend *fe)
+static const u32 qm1d1c0042_sd_tab[24][3] = {
+	{0x38fae1, 0x0d, 0x5},
+	{0x3f570a, 0x0e, 0x3},
+	{0x05b333, 0x0e, 0x5},
+	{0x3c0f5c, 0x0f, 0x4},
+	{0x026b85, 0x0f, 0x6},
+	{0x38c7ae, 0x10, 0x5},
+	{0x3f23d7, 0x11, 0x3},
+	{0x058000, 0x11, 0x5},
+	{0x3bdc28, 0x12, 0x4},
+	{0x023851, 0x12, 0x6},
+	{0x38947a, 0x13, 0x5},
+	{0x3ef0a3, 0x14, 0x3},
+	{0x3c8000, 0x16, 0x4},
+	{0x048000, 0x16, 0x6},
+	{0x3c8000, 0x17, 0x5},
+	{0x048000, 0x18, 0x3},
+	{0x3c8000, 0x18, 0x6},
+	{0x048000, 0x19, 0x4},
+	{0x3c8000, 0x1a, 0x3},
+	{0x048000, 0x1a, 0x5},
+	{0x3c8000, 0x1b, 0x4},
+	{0x048000, 0x1b, 0x6},
+	{0x3c8000, 0x1c, 0x5},
+	{0x048000, 0x1d, 0x3},
+};
+
+static int qm1d1c0042_tuning(struct qm1d1c0042 *qm, u32 *sd, u32 channel)
 {
-	struct qm1d1c0042_state *state;
-	u32 freq;
-	int i, ret;
-	u8 val, mask;
-	u32 a, sd;
-	s32 b;
-
-	state = fe->tuner_priv;
-	freq = fe->dtv_property_cache.frequency;
-
-	state->regs[0x08] &= 0xf0;
-	state->regs[0x08] |= 0x09;
-
-	state->regs[0x13] &= 0x9f;
-	state->regs[0x13] |= 0x20;
-
-	/* div2/vco_band */
-	val = state->regs[0x02] & 0x0f;
-	for (i = 0; i < 8; i++)
-		if (freq < conv_table[i][0] && freq >= conv_table[i + 1][0]) {
-			val |= conv_table[i][1] << 7;
-			val |= conv_table[i][2] << 4;
-			break;
+	int ret;
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 i, N, A;
+
+	qm->reg[0x08] &= 0xf0;
+	qm->reg[0x08] |= 0x09;
+
+	qm->reg[0x13] &= 0x9f;
+	qm->reg[0x13] |= 0x20;
+
+	for (i = 0; i < 8; i++) {
+		if ((qm1d1c0042_freq_tab[i+1][0] <= qm->freq) && (qm->freq < qm1d1c0042_freq_tab[i][0])) {
+			i_data = qm->reg[0x02];
+			i_data &= 0x0f;
+			i_data |= qm1d1c0042_freq_tab[i][1] << 7;
+			i_data |= qm1d1c0042_freq_tab[i][2] << 4;
+			qm1d1c0042_write(fe, 0x02, i_data);
 		}
-	ret = reg_write(state, 0x02, val);
-	if (ret < 0)
-		return ret;
-
-	a = (freq + state->cfg.xtal_freq / 2) / state->cfg.xtal_freq;
-
-	state->regs[0x06] &= 0x40;
-	state->regs[0x06] |= (a - 12) / 4;
-	ret = reg_write(state, 0x06, state->regs[0x06]);
-	if (ret < 0)
-		return ret;
-
-	state->regs[0x07] &= 0xf0;
-	state->regs[0x07] |= (a - 4 * ((a - 12) / 4 + 1) - 5) & 0x0f;
-	ret = reg_write(state, 0x07, state->regs[0x07]);
-	if (ret < 0)
-		return ret;
-
-	/* LPF */
-	val = state->regs[0x08];
-	if (state->cfg.lpf) {
-		/* LPF_CLK, LPF_FC */
-		val &= 0xf0;
-		val |= 0x02;
 	}
-	ret = reg_write(state, 0x08, val);
-	if (ret < 0)
-		return ret;
 
-	/*
-	 * b = (freq / state->cfg.xtal_freq - a) << 20;
-	 * sd = b          (b >= 0)
-	 *      1<<22 + b  (b < 0)
-	 */
-	b = (s32)div64_s64(((s64) freq) << 20, state->cfg.xtal_freq)
-			   - (((s64) a) << 20);
+	*sd = qm1d1c0042_sd_tab[channel][0];
+	N = qm1d1c0042_sd_tab[channel][1];
+	A = qm1d1c0042_sd_tab[channel][2];
 
-	if (b >= 0)
-		sd = b;
-	else
-		sd = (1 << 22) + b;
-
-	state->regs[0x09] &= 0xc0;
-	state->regs[0x09] |= (sd >> 16) & 0x3f;
-	state->regs[0x0a] = (sd >> 8) & 0xff;
-	state->regs[0x0b] = sd & 0xff;
-	ret = reg_write(state, 0x09, state->regs[0x09]);
-	if (ret == 0)
-		ret = reg_write(state, 0x0a, state->regs[0x0a]);
-	if (ret == 0)
-		ret = reg_write(state, 0x0b, state->regs[0x0b]);
-	if (ret != 0)
-		return ret;
-
-	if (!state->cfg.lpf) {
-		/* CSEL_Offset */
-		ret = reg_write(state, 0x13, state->regs[0x13]);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* VCO_TM, LPF_TM */
-	mask = state->cfg.lpf ? 0x3f : 0x7f;
-	val = state->regs[0x0c] & mask;
-	ret = reg_write(state, 0x0c, val);
-	if (ret < 0)
-		return ret;
-	usleep_range(2000, 3000);
-	val = state->regs[0x0c] | ~mask;
-	ret = reg_write(state, 0x0c, val);
-	if (ret < 0)
+	qm->reg[0x06] &= 0x40;
+	qm->reg[0x06] |= N;
+	ret = qm1d1c0042_write(fe, 0x06, qm->reg[0x06]);
+	if (ret)
 		return ret;
 
-	if (state->cfg.lpf)
-		msleep(state->cfg.lpf_wait);
-	else if (state->regs[0x03] & 0x01)
-		msleep(state->cfg.fast_srch_wait);
-	else
-		msleep(state->cfg.normal_srch_wait);
-
-	if (state->cfg.lpf) {
-		/* LPF_FC */
-		ret = reg_write(state, 0x08, 0x09);
-		if (ret < 0)
-			return ret;
-
-		/* CSEL_Offset */
-		ret = reg_write(state, 0x13, state->regs[0x13]);
-		if (ret < 0)
-			return ret;
-	}
-	return 0;
+	qm->reg[0x07] &= 0xf0;
+	qm->reg[0x07] |= A & 0x0f;
+	return qm1d1c0042_write(fe, 0x07, qm->reg[0x07]);
 }
 
-static int qm1d1c0042_sleep(struct dvb_frontend *fe)
+static int qm1d1c0042_local_lpf_tuning(struct qm1d1c0042 *qm, u32 channel)
 {
-	struct qm1d1c0042_state *state;
-	int ret;
-
-	state = fe->tuner_priv;
-	state->regs[0x01] &= (~(1 << 3)) & 0xff; /* BB_Reg_disable */
-	state->regs[0x01] |= 1 << 0;             /* STDBY */
-	state->regs[0x05] |= 1 << 3;             /* pfd_rst STANDBY */
-	ret = reg_write(state, 0x05, state->regs[0x05]);
-	if (ret == 0)
-		ret = reg_write(state, 0x01, state->regs[0x01]);
-	if (ret < 0)
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 sd = 0;
+	int err = qm1d1c0042_tuning(qm, &sd, channel);
+
+	if (err)
+		return err;
+	i_data = qm->reg[0x08] & 0xf0;
+	i_data |= 2;
+	err = qm1d1c0042_write(fe, 0x08, i_data);
+	if (err)
+		return err;
+
+	qm->reg[0x09] &= 0xc0;
+	qm->reg[0x09] |= (sd >> 16) & 0x3f;
+	qm->reg[0x0a] = (sd >> 8) & 0xff;
+	qm->reg[0x0b] = (sd >> 0) & 0xff;
+	err =	qm1d1c0042_write(fe, 0x09, qm->reg[0x09])	||
+		qm1d1c0042_write(fe, 0x0a, qm->reg[0x0a])	||
+		qm1d1c0042_write(qm->fe, 0x0b, qm->reg[0x0b]);
+	if (err)
+		return err;
+
+	i_data = qm->reg[0x0c];
+	i_data &= 0x3f;
+	err = qm1d1c0042_write(fe, 0x0c, i_data);
+	if (err)
+		return err;
+	msleep_interruptible(1);
+
+	i_data = qm->reg[0x0c];
+	i_data |= 0xc0;
+	return	qm1d1c0042_write(fe, 0x0c, i_data)	||
+		qm1d1c0042_write(fe, 0x08, 0x09)	||
+		qm1d1c0042_write(fe, 0x13, qm->reg[0x13]);
 }
 
-static int qm1d1c0042_init(struct dvb_frontend *fe)
+int qm1d1c0042_get_locked(struct qm1d1c0042 *qm, bool *locked)
 {
-	struct qm1d1c0042_state *state;
-	u8 val;
-	int i, ret;
-
-	state = fe->tuner_priv;
-	memcpy(state->regs, reg_initval, sizeof(reg_initval));
+	int err = qm1d1c0042_fe_read(qm->fe, 0x0d, &qm->reg[0x0d]);
 
-	reg_write(state, 0x01, 0x0c);
-	reg_write(state, 0x01, 0x0c);
-
-	ret = reg_write(state, 0x01, 0x0c); /* soft reset on */
-	if (ret < 0)
-		goto failed;
-	usleep_range(2000, 3000);
-
-	val = state->regs[0x01] | 0x10;
-	ret = reg_write(state, 0x01, val); /* soft reset off */
-	if (ret < 0)
-		goto failed;
+	if (err)
+		return err;
+	if (qm->reg[0x0d] & 0x40)
+		*locked = true;
+	else
+		*locked = false;
+	return err;
+}
 
-	/* check ID */
-	ret = reg_read(state, 0x00, &val);
-	if (ret < 0 || val != 0x48)
-		goto failed;
-	usleep_range(2000, 3000);
+u32 qm1d1c0042_freq2ch(u32 frequency)
+{
+	u32 freq = frequency / 10,
+	    ch0 = (freq - 104948) / 3836, diff0 = freq - (104948 + 3836 * ch0),
+	    ch1 = (freq - 161300) / 4000, diff1 = freq - (161300 + 4000 * ch1),
+	    ch2 = (freq - 159300) / 4000, diff2 = freq - (159300 + 4000 * ch2),
+	    min = diff0 < diff1 ? diff0 : diff1;
+
+	if (frequency < 1024)
+		return frequency;	/* consider as channel ID if low */
+	if (diff2 < min)
+		return ch2 + 24;
+	if (min == diff1)
+		return ch1 + 12;
+	return ch0;
+}
 
-	state->regs[0x0c] |= 0x40;
-	ret = reg_write(state, 0x0c, state->regs[0x0c]);
-	if (ret < 0)
-		goto failed;
-	msleep(state->cfg.lpf_wait);
-
-	/* set all writable registers */
-	for (i = 1; i <= 0x0c ; i++) {
-		ret = reg_write(state, i, state->regs[i]);
-		if (ret < 0)
-			goto failed;
-	}
-	for (i = 0x11; i < QM1D1C0042_NUM_REGS; i++) {
-		ret = reg_write(state, i, state->regs[i]);
-		if (ret < 0)
-			goto failed;
+int qm1d1c0042_set_freq(struct dvb_frontend *fe, u32 frequency)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u32 channel = qm1d1c0042_freq2ch(frequency);
+	u32 number, freq;
+	bool locked = false;
+	unsigned long timeout;
+	int err = qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL);
+
+	if (err)
+		return err;
+	qm1d1c0042_ch2freq(channel, &number, &freq);
+	qm->freq = freq * 10 - 500;
+	dev_dbg(fe->dvb->device, "#%d ch %d freq %d kHz\n", qm->idx, channel, qm->freq);
+
+	err = qm1d1c0042_local_lpf_tuning(qm, channel);
+	if (err)
+		return err;
+
+	timeout = jiffies + msecs_to_jiffies(1000);	/* 1s */
+	while (time_before(jiffies, timeout)) {
+		err = qm1d1c0042_get_locked(qm, &locked);
+		if (err)
+			return err;
+		if (locked)
+			break;
+		msleep_interruptible(1);
 	}
-
-	ret = qm1d1c0042_wakeup(state);
-	if (ret < 0)
-		goto failed;
-
-	ret = qm1d1c0042_set_srch_mode(state, state->cfg.fast_srch);
-	if (ret < 0)
-		goto failed;
-
-	return ret;
-
-failed:
-	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-		__func__, fe->dvb->num, fe->id);
-	return ret;
+	dev_dbg(fe->dvb->device, "#%d %s %s\n", qm->idx, __func__, locked ? "LOCKED" : "TIMEOUT");
+	return locked ? qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_AUTO) : -ETIMEDOUT;
 }
 
-/* I2C driver functions */
-
-static const struct dvb_tuner_ops qm1d1c0042_ops = {
+static struct dvb_tuner_ops qm1d1c0042_ops = {
 	.info = {
-		.name = "Sharp QM1D1C0042",
-
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
+		.frequency_min	= 1,		/* freq under 1024 kHz is handled as channel */
+		.frequency_max	= 2150000,	/* kHz */
+		.frequency_step	= 1000,		/* = 1 MHz */
 	},
-
-	.init = qm1d1c0042_init,
+	.set_frequency = qm1d1c0042_set_freq,
 	.sleep = qm1d1c0042_sleep,
-	.set_config = qm1d1c0042_set_config,
-	.set_params = qm1d1c0042_set_params,
+	.init = qm1d1c0042_wakeup,
 };
 
-
-static int qm1d1c0042_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+int qm1d1c0042_remove(struct i2c_client *client)
 {
-	struct qm1d1c0042_state *state;
-	struct qm1d1c0042_config *cfg;
-	struct dvb_frontend *fe;
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->i2c = client;
+	struct dvb_frontend *fe = i2c_get_clientdata(client);
 
-	cfg = client->dev.platform_data;
-	fe = cfg->fe;
-	fe->tuner_priv = state;
-	qm1d1c0042_set_config(fe, cfg);
-	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(qm1d1c0042_ops));
-
-	i2c_set_clientdata(client, &state->cfg);
-	dev_info(&client->dev, "Sharp QM1D1C0042 attached.\n");
+	dev_dbg(&client->dev, "%s\n", __func__);
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
 	return 0;
 }
 
-static int qm1d1c0042_remove(struct i2c_client *client)
+int qm1d1c0042_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct qm1d1c0042_state *state;
+	u8 d[] = { 0x10, 0x15, 0x04 };
+	struct dvb_frontend *fe = client->dev.platform_data;
+	struct qm1d1c0042 *qm = kzalloc(sizeof(struct qm1d1c0042), GFP_KERNEL);
 
-	state = cfg_to_state(i2c_get_clientdata(client));
-	state->cfg.fe->tuner_priv = NULL;
-	kfree(state);
-	return 0;
+	if (!qm)
+		return -ENOMEM;
+	fe->tuner_priv = qm;
+	qm->fe = fe;
+	qm->idx = !(client->addr & 1);
+	qm->addr_tuner = client->addr;
+	qm->read = fe->ops.tuner_ops.calc_regs;
+	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(struct dvb_tuner_ops));
+	memcpy(qm->reg, qm1d1c0042_reg_rw, sizeof(qm1d1c0042_reg_rw));
+	qm->freq = 0;
+	i2c_set_clientdata(client, fe);
+	return	qm1d1c0042_fe_write_data(fe, 0x1e, d,   1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1c, d+1, 1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1f, d+2, 1);
 }
 
-
-static const struct i2c_device_id qm1d1c0042_id[] = {
-	{"qm1d1c0042", 0},
-	{}
+static struct i2c_device_id qm1d1c0042_id_table[] = {
+	{ QM1D1C0042_DRVNAME, 0 },
+	{ },
 };
-MODULE_DEVICE_TABLE(i2c, qm1d1c0042_id);
+MODULE_DEVICE_TABLE(i2c, qm1d1c0042_id_table);
 
 static struct i2c_driver qm1d1c0042_driver = {
 	.driver = {
-		.name	= "qm1d1c0042",
+		.owner	= THIS_MODULE,
+		.name	= qm1d1c0042_id_table->name,
 	},
 	.probe		= qm1d1c0042_probe,
 	.remove		= qm1d1c0042_remove,
-	.id_table	= qm1d1c0042_id,
+	.id_table	= qm1d1c0042_id_table,
 };
-
 module_i2c_driver(qm1d1c0042_driver);
 
-MODULE_DESCRIPTION("Sharp QM1D1C0042 tuner");
-MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 QM1D1C0042 ISDB-S tuner driver");
 MODULE_LICENSE("GPL");
+
-- 
1.8.4.5

