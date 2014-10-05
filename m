Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaJEJCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:02:48 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35893 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaJEJAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:07 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 03/11] tc90522: use hardware algorithm & correct CNR
Date: Sun,  5 Oct 2014 17:59:39 +0900
Message-Id: <42c7bd27ff4a188ab2692f2567ec6097ac5fb4d1.1412497399.git.knightrider@are.ma>
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

1. The chip is clever enough to do fine tuning. Thus,
   simply let dvb-core do the iteration of hw_algo.
2. Tsukada's patch violates the consensus in
   include/uapi/linux/dvb/frontend.h
   Change CNR unit from .001 dB to .0001 dB, and yet
   lightweight calculus using only shifters for divs.

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-frontends/tc90522.c | 1146 ++++++++++++---------------------
 1 file changed, 427 insertions(+), 719 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index d9905fb..cf19cfb 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -1,12 +1,12 @@
 /*
- * Toshiba TC90522 Demodulator
+ * Toshiba TC90522XBG 2ch OFDM(ISDB-T) + 2ch 8PSK(ISDB-S) demodulator frontend for Earthsoft PT3
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
@@ -14,827 +14,535 @@
  * GNU General Public License for more details.
  */
 
-/*
- * NOTICE:
- * This driver is incomplete and lacks init/config of the chips,
- * as the necessary info is not disclosed.
- * It assumes that users of this driver (such as a PCI bridge of
- * DTV receiver cards) properly init and configure the chip
- * via I2C *before* calling this driver's init() function.
- *
- * Currently, PT3 driver is the only one that uses this driver,
- * and contains init/config code in its firmware.
- * Thus some part of the code might be dependent on PT3 specific config.
- */
-
-#include <linux/kernel.h>
-#include <linux/math64.h>
-#include <linux/dvb/frontend.h>
 #include "dvb_math.h"
+#include "dvb_frontend.h"
 #include "tc90522.h"
 
-#define TC90522_I2C_THRU_REG 0xfe
-
-#define TC90522_MODULE_IDX(addr) (((u8)(addr) & 0x02U) >> 1)
+#define TC90522_PASSTHROUGH 0xfe
 
-struct tc90522_state {
-	struct tc90522_config cfg;
-	struct dvb_frontend fe;
-	struct i2c_client *i2c_client;
-	struct i2c_adapter tuner_i2c;
-
-	bool lna;
+enum tc90522_state {
+	TC90522_IDLE,
+	TC90522_SET_FREQUENCY,
+	TC90522_SET_MODULATION,
+	TC90522_TRACK,
+	TC90522_ABORT,
 };
 
-struct reg_val {
-	u8 reg;
-	u8 val;
+struct tc90522 {
+	struct dvb_frontend fe;
+	struct i2c_adapter *i2c;
+	fe_delivery_system_t type;
+	u8 idx, addr_demod;
+	s32 offset;
+	enum tc90522_state state;
 };
 
-static int
-reg_write(struct tc90522_state *state, const struct reg_val *regs, int num)
+int tc90522_write(struct dvb_frontend *fe, const u8 *data, int len)
 {
-	int i, ret;
-	struct i2c_msg msg;
-
-	ret = 0;
-	msg.addr = state->i2c_client->addr;
-	msg.flags = 0;
-	msg.len = 2;
-	for (i = 0; i < num; i++) {
-		msg.buf = (u8 *)&regs[i];
-		ret = i2c_transfer(state->i2c_client->adapter, &msg, 1);
-		if (ret == 0)
-			ret = -EIO;
-		if (ret < 0)
-			return ret;
-	}
-	return 0;
-}
-
-static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
-{
-	struct i2c_msg msgs[2] = {
-		{
-			.addr = state->i2c_client->addr,
-			.flags = 0,
-			.buf = &reg,
-			.len = 1,
-		},
-		{
-			.addr = state->i2c_client->addr,
-			.flags = I2C_M_RD,
-			.buf = val,
-			.len = len,
-		},
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0, .buf = (u8 *)data, .len = len, },
 	};
-	int ret;
-
-	ret = i2c_transfer(state->i2c_client->adapter, msgs, ARRAY_SIZE(msgs));
-	if (ret == ARRAY_SIZE(msgs))
-		ret = 0;
-	else if (ret >= 0)
-		ret = -EIO;
-	return ret;
-}
 
-static struct tc90522_state *cfg_to_state(struct tc90522_config *c)
-{
-	return container_of(c, struct tc90522_state, cfg);
+	if (!data || !len)
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 1) == 1 ? 0 : -EREMOTEIO;
 }
 
-
-static int tc90522s_set_tsid(struct dvb_frontend *fe)
+int tc90522_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, u8 len)
 {
-	struct reg_val set_tsid[] = {
-		{ 0x8f, 00 },
-		{ 0x90, 00 }
-	};
+	u8 buf[len + 1];
 
-	set_tsid[0].val = (fe->dtv_property_cache.stream_id & 0xff00) >> 8;
-	set_tsid[1].val = fe->dtv_property_cache.stream_id & 0xff;
-	return reg_write(fe->demodulator_priv, set_tsid, ARRAY_SIZE(set_tsid));
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return tc90522_write(fe, buf, len + 1);
 }
 
-static int tc90522t_set_layers(struct dvb_frontend *fe)
+int tc90522_read(struct tc90522 *demod, u8 addr, u8 *buf, u8 len)
 {
-	struct reg_val rv;
-	u8 laysel;
-
-	laysel = ~fe->dtv_property_cache.isdbt_layer_enabled & 0x07;
-	laysel = (laysel & 0x01) << 2 | (laysel & 0x02) | (laysel & 0x04) >> 2;
-	rv.reg = 0x71;
-	rv.val = laysel;
-	return reg_write(fe->demodulator_priv, &rv, 1);
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf, .len = 1,	},
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf, .len = len,	},
+	};
+	if (!buf || !len)
+		return -EINVAL;
+	buf[0] = addr;
+	return i2c_transfer(demod->i2c, msg, 2) == 2 ? 0 : -EREMOTEIO;
 }
 
-/* frontend ops */
+u64 tc90522_n2int(const u8 *data, u8 n)		/* convert n_bytes data from stream (network byte order) to integer */
+{						/* can't use <arpa/inet.h>'s ntoh*() as sometimes n = 3,5,...       */
+	u32 i, val = 0;
 
-static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	struct tc90522_state *state;
-	int ret;
-	u8 reg;
-
-	state = fe->demodulator_priv;
-	ret = reg_read(state, 0xc3, &reg, 1);
-	if (ret < 0)
-		return ret;
-
-	*status = 0;
-	if (reg & 0x80) /* input level under min ? */
-		return 0;
-	*status |= FE_HAS_SIGNAL;
-
-	if (reg & 0x60) /* carrier? */
-		return 0;
-	*status |= FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC;
-
-	if (reg & 0x10)
-		return 0;
-	if (reg_read(state, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
-		return 0;
-	*status |= FE_HAS_LOCK;
-	return 0;
+	for (i = 0; i < n; i++) {
+		val <<= 8;
+		val |= data[i];
+	}
+	return val;
 }
 
-static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
+int tc90522_read_id_s(struct tc90522 *demod, u16 *id)
 {
-	struct tc90522_state *state;
-	int ret;
-	u8 reg;
-
-	state = fe->demodulator_priv;
-	ret = reg_read(state, 0x96, &reg, 1);
-	if (ret < 0)
-		return ret;
-
-	*status = 0;
-	if (reg & 0xe0) {
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
-				| FE_HAS_SYNC | FE_HAS_LOCK;
-		return 0;
-	}
-
-	ret = reg_read(state, 0x80, &reg, 1);
-	if (ret < 0)
-		return ret;
-
-	if (reg & 0xf0)
-		return 0;
-	*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
+	u8 buf[2];
+	int err = tc90522_read(demod, 0xe6, buf, 2);
 
-	if (reg & 0x0c)
-		return 0;
-	*status |= FE_HAS_SYNC | FE_HAS_VITERBI;
-
-	if (reg & 0x02)
-		return 0;
-	*status |= FE_HAS_LOCK;
-	return 0;
+	if (!err)
+		*id = tc90522_n2int(buf, 2);
+	return err;
 }
 
-static const fe_code_rate_t fec_conv_sat[] = {
-	FEC_NONE, /* unused */
-	FEC_1_2, /* for BPSK */
-	FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, /* for QPSK */
-	FEC_2_3, /* for 8PSK. (trellis code) */
+struct tmcc_s {			/* Transmission and Multiplexing Configuration Control */
+	u32 mode[4];
+	u32 slot[4];
+	u32 id[8];
 };
 
-static int tc90522s_get_frontend(struct dvb_frontend *fe)
+int tc90522_read_tmcc_s(struct tc90522 *demod, struct tmcc_s *tmcc)
 {
-	struct tc90522_state *state;
-	struct dtv_frontend_properties *c;
-	struct dtv_fe_stats *stats;
-	int ret, i;
-	int layers;
-	u8 val[10];
-	u32 cndat;
-
-	state = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
-	c->delivery_system = SYS_ISDBS;
-
-	layers = 0;
-	ret = reg_read(state, 0xe8, val, 3);
-	if (ret == 0) {
-		int slots;
-		u8 v;
-
-		/* high/single layer */
-		v = (val[0] & 0x70) >> 4;
-		c->modulation = (v == 7) ? PSK_8 : QPSK;
-		c->fec_inner = fec_conv_sat[v];
-		c->layer[0].fec = c->fec_inner;
-		c->layer[0].modulation = c->modulation;
-		c->layer[0].segment_count = val[1] & 0x3f; /* slots */
-
-		/* low layer */
-		v = (val[0] & 0x07);
-		c->layer[1].fec = fec_conv_sat[v];
-		if (v == 0)  /* no low layer */
-			c->layer[1].segment_count = 0;
-		else
-			c->layer[1].segment_count = val[2] & 0x3f; /* slots */
-		/* actually, BPSK if v==1, but not defined in fe_modulation_t */
-		c->layer[1].modulation = QPSK;
-		layers = (v > 0) ? 2 : 1;
-
-		slots =  c->layer[0].segment_count +  c->layer[1].segment_count;
-		c->symbol_rate = 28860000 * slots / 48;
-	}
-
-	/* statistics */
-
-	stats = &c->strength;
-	stats->len = 0;
-	/* let the connected tuner set RSSI property cache */
-	if (fe->ops.tuner_ops.get_rf_strength) {
-		u16 dummy;
-
-		fe->ops.tuner_ops.get_rf_strength(fe, &dummy);
-	}
-
-	stats = &c->cnr;
-	stats->len = 1;
-	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	cndat = 0;
-	ret = reg_read(state, 0xbc, val, 2);
-	if (ret == 0)
-		cndat = val[0] << 8 | val[1];
-	if (cndat >= 3000) {
-		u32 p, p4;
-		s64 cn;
-
-		cndat -= 3000;  /* cndat: 4.12 fixed point float */
-		/*
-		 * cnr[mdB] = -1634.6 * P^5 + 14341 * P^4 - 50259 * P^3
-		 *                 + 88977 * P^2 - 89565 * P + 58857
-		 *  (P = sqrt(cndat) / 64)
-		 */
-		/* p := sqrt(cndat) << 8 = P << 14, 2.14 fixed  point float */
-		/* cn = cnr << 3 */
-		p = int_sqrt(cndat << 16);
-		p4 = cndat * cndat;
-		cn = div64_s64(-16346LL * p4 * p, 10) >> 35;
-		cn += (14341LL * p4) >> 21;
-		cn -= (50259LL * cndat * p) >> 23;
-		cn += (88977LL * cndat) >> 9;
-		cn -= (89565LL * p) >> 11;
-		cn += 58857  << 3;
-		stats->stat[0].svalue = cn >> 3;
-		stats->stat[0].scale = FE_SCALE_DECIBEL;
-	}
-
-	/* per-layer post viterbi BER (or PER? config dependent?) */
-	stats = &c->post_bit_error;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	ret = reg_read(state, 0xeb, val, 10);
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue = val[i * 5] << 16
-				| val[i * 5 + 1] << 8 | val[i * 5 + 2];
-		}
-	}
-	stats = &c->post_bit_count;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue =
-				val[i * 5 + 3] << 8 | val[i * 5 + 4];
-			stats->stat[i].uvalue *= 204 * 8;
-		}
+	enum {
+		BASE = 0xc5,
+		SIZE = 0xe5 - BASE + 1
+	};
+	u8 data[SIZE];
+	u32 i, byte_offset, bit_offset;
+
+	int err = tc90522_read(demod, 0xc3, data, 1)	||
+		((data[0] >> 4) & 1)			||
+		tc90522_read(demod, 0xce, data, 2)	||
+		(tc90522_n2int(data, 2) == 0)		||
+		tc90522_read(demod, 0xc3, data, 1)	||
+		tc90522_read(demod, 0xc5, data, SIZE);
+	if (err)
+		return err;
+	for (i = 0; i < 4; i++) {
+		byte_offset = i >> 1;
+		bit_offset = (i & 1) ? 0 : 4;
+		tmcc->mode[i] = (data[0xc8 + byte_offset - BASE] >> bit_offset) & 0b00001111;
+		tmcc->slot[i] = (data[0xca + i           - BASE] >>          0) & 0b00111111;
 	}
-
+	for (i = 0; i < 8; i++)
+		tmcc->id[i] = tc90522_n2int(data + 0xce + i * 2 - BASE, 2);
 	return 0;
 }
 
-
-static const fe_transmit_mode_t tm_conv[] = {
-	TRANSMISSION_MODE_2K,
-	TRANSMISSION_MODE_4K,
-	TRANSMISSION_MODE_8K,
-	0
+enum tc90522_pwr {
+	TC90522_PWR_OFF		= 0x00,
+	TC90522_PWR_AMP_ON	= 0x04,
+	TC90522_PWR_TUNER_ON	= 0x40,
 };
 
-static const fe_code_rate_t fec_conv_ter[] = {
-	FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, 0, 0, 0
-};
+int tc90522_set_powers(struct tc90522 *demod, enum tc90522_pwr pwr)
+{
+	u8 data = pwr | 0b10011001;
 
-static const fe_modulation_t mod_conv[] = {
-	DQPSK, QPSK, QAM_16, QAM_64, 0, 0, 0, 0
-};
+	dev_dbg(&demod->i2c->dev, "%s #%d %s tuner %s amp %s\n", demod->i2c->name, demod->idx, __func__, pwr & TC90522_PWR_TUNER_ON ?
+		"ON" : "OFF", pwr & TC90522_PWR_AMP_ON ? "ON" : "OFF");
+	return tc90522_write_data(&demod->fe, 0x1e, &data, 1);
+}
 
-static int tc90522t_get_frontend(struct dvb_frontend *fe)
+/* dvb_frontend_ops */
+int tc90522_get_frontend_algo(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
-	struct dtv_frontend_properties *c;
-	struct dtv_fe_stats *stats;
-	int ret, i;
-	int layers;
-	u8 val[15], mode;
-	u32 cndat;
-
-	state = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
-	c->delivery_system = SYS_ISDBT;
-	c->bandwidth_hz = 6000000;
-	mode = 1;
-	ret = reg_read(state, 0xb0, val, 1);
-	if (ret == 0) {
-		mode = (val[0] & 0xc0) >> 2;
-		c->transmission_mode = tm_conv[mode];
-		c->guard_interval = (val[0] & 0x30) >> 4;
-	}
-
-	ret = reg_read(state, 0xb2, val, 6);
-	layers = 0;
-	if (ret == 0) {
-		u8 v;
-
-		c->isdbt_partial_reception = val[0] & 0x01;
-		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x01;
-
-		/* layer A */
-		v = (val[2] & 0x78) >> 3;
-		if (v == 0x0f)
-			c->layer[0].segment_count = 0;
-		else {
-			layers++;
-			c->layer[0].segment_count = v;
-			c->layer[0].fec = fec_conv_ter[(val[1] & 0x1c) >> 2];
-			c->layer[0].modulation = mod_conv[(val[1] & 0xe0) >> 5];
-			v = (val[1] & 0x03) << 1 | (val[2] & 0x80) >> 7;
-			c->layer[0].interleaving = v;
-		}
+	return DVBFE_ALGO_HW;
+}
 
-		/* layer B */
-		v = (val[3] & 0x03) << 1 | (val[4] & 0xc0) >> 6;
-		if (v == 0x0f)
-			c->layer[1].segment_count = 0;
-		else {
-			layers++;
-			c->layer[1].segment_count = v;
-			c->layer[1].fec = fec_conv_ter[(val[3] & 0xe0) >> 5];
-			c->layer[1].modulation = mod_conv[(val[2] & 0x07)];
-			c->layer[1].interleaving = (val[3] & 0x1c) >> 2;
-		}
+int tc90522_sleep(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
 
-		/* layer C */
-		v = (val[5] & 0x1e) >> 1;
-		if (v == 0x0f)
-			c->layer[2].segment_count = 0;
-		else {
-			layers++;
-			c->layer[2].segment_count = v;
-			c->layer[2].fec = fec_conv_ter[(val[4] & 0x07)];
-			c->layer[2].modulation = mod_conv[(val[4] & 0x38) >> 3];
-			c->layer[2].interleaving = (val[5] & 0xe0) >> 5;
-		}
-	}
+	dev_dbg(&demod->i2c->dev, "%s #%d %s %s\n", demod->i2c->name, demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T");
+	return fe->ops.tuner_ops.sleep(fe);
+}
 
-	/* statistics */
+int tc90522_wakeup(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
 
-	stats = &c->strength;
-	stats->len = 0;
-	/* let the connected tuner set RSSI property cache */
-	if (fe->ops.tuner_ops.get_rf_strength) {
-		u16 dummy;
+	dev_dbg(&demod->i2c->dev, "%s #%d %s %s\n", demod->i2c->name, demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T");
+	demod->state = TC90522_IDLE;
+	return fe->ops.tuner_ops.init(fe);
+}
 
-		fe->ops.tuner_ops.get_rf_strength(fe, &dummy);
-	}
+void tc90522_release(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
 
-	stats = &c->cnr;
-	stats->len = 1;
-	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	cndat = 0;
-	ret = reg_read(state, 0x8b, val, 3);
-	if (ret == 0)
-		cndat = val[0] << 16 | val[1] << 8 | val[2];
-	if (cndat != 0) {
-		u32 p, tmp;
-		s64 cn;
-
-		/*
-		 * cnr[mdB] = 0.024 P^4 - 1.6 P^3 + 39.8 P^2 + 549.1 P + 3096.5
-		 * (P = 10log10(5505024/cndat))
-		 */
-		/* cn = cnr << 3 (61.3 fixed point float */
-		/* p = 10log10(5505024/cndat) << 24  (8.24 fixed point float)*/
-		p = intlog10(5505024) - intlog10(cndat);
-		p *= 10;
-
-		cn = 24772;
-		cn += div64_s64(43827LL * p, 10) >> 24;
-		tmp = p >> 8;
-		cn += div64_s64(3184LL * tmp * tmp, 10) >> 32;
-		tmp = p >> 13;
-		cn -= div64_s64(128LL * tmp * tmp * tmp, 10) >> 33;
-		tmp = p >> 18;
-		cn += div64_s64(192LL * tmp * tmp * tmp * tmp, 1000) >> 24;
-
-		stats->stat[0].svalue = cn >> 3;
-		stats->stat[0].scale = FE_SCALE_DECIBEL;
-	}
+	dev_dbg(&demod->i2c->dev, "%s #%d %s\n", demod->i2c->name, demod->idx, __func__);
+	tc90522_set_powers(demod, TC90522_PWR_OFF);
+	tc90522_sleep(fe);
+}
 
-	/* per-layer post viterbi BER (or PER? config dependent?) */
-	stats = &c->post_bit_error;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	ret = reg_read(state, 0x9d, val, 15);
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue = val[i * 3] << 16
-				| val[i * 3 + 1] << 8 | val[i * 3 + 2];
-		}
-	}
-	stats = &c->post_bit_count;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue =
-				val[9 + i * 2] << 8 | val[9 + i * 2 + 1];
-			stats->stat[i].uvalue *= 204 * 8;
-		}
-	}
+s64 tc90522_get_cn_raw(struct tc90522 *demod)
+{
+	u8 buf[3], buflen = demod->type == SYS_ISDBS ? 2 : 3, addr = demod->type == SYS_ISDBS ? 0xbc : 0x8b;
+	int err = tc90522_read(demod, addr, buf, buflen);
 
-	return 0;
+	return err < 0 ? err : tc90522_n2int(buf, buflen);
 }
 
-static const struct reg_val reset_sat = { 0x03, 0x01 };
-static const struct reg_val reset_ter = { 0x01, 0x40 };
-
-static int tc90522_set_frontend(struct dvb_frontend *fe)
+s64 tc90522_get_cn_s(s64 raw)	/* @ .0001 dB */
 {
-	struct tc90522_state *state;
-	int ret;
-
-	state = fe->demodulator_priv;
-
-	if (fe->ops.tuner_ops.set_params)
-		ret = fe->ops.tuner_ops.set_params(fe);
-	else
-		ret = -ENODEV;
-	if (ret < 0)
-		goto failed;
-
-	if (fe->ops.delsys[0] == SYS_ISDBS) {
-		ret = tc90522s_set_tsid(fe);
-		if (ret < 0)
-			goto failed;
-		ret = reg_write(state, &reset_sat, 1);
-	} else {
-		ret = tc90522t_set_layers(fe);
-		if (ret < 0)
-			goto failed;
-		ret = reg_write(state, &reset_ter, 1);
-	}
-	if (ret < 0)
-		goto failed;
+	s64 x, y;
+
+	raw -= 3000;
+	if (raw < 0)
+		raw = 0;
+	x = int_sqrt(raw << 20);
+	y = 16346ll * x - (143410ll << 16);
+	y = ((x * y) >> 16) + (502590ll << 16);
+	y = ((x * y) >> 16) - (889770ll << 16);
+	y = ((x * y) >> 16) + (895650ll << 16);
+	y = (588570ll << 16) - ((x * y) >> 16);
+	return y < 0 ? 0 : y >> 16;
+}
 
-	return 0;
+s64 tc90522_get_cn_t(s64 raw)	/* @ .0001 dB */
+{
+	s64 x, y;
 
-failed:
-	dev_warn(&state->tuner_i2c.dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
+	if (!raw)
+		return 0;
+	x = (1130911733ll - 10ll * intlog10(raw)) >> 2;
+	y = (x >> 2) - (x >> 6) + (x >> 8) + (x >> 9) - (x >> 10) + (x >> 11) + (x >> 12) - (16ll << 22);
+	y = ((x * y) >> 22) + (398ll << 22);
+	y = ((x * y) >> 22) + (5491ll << 22);
+	y = ((x * y) >> 22) + (30965ll << 22);
+	return y >> 22;
 }
 
-static int tc90522_get_tune_settings(struct dvb_frontend *fe,
-	struct dvb_frontend_tune_settings *settings)
+int tc90522_read_snr(struct dvb_frontend *fe, u16 *cn)	/* raw C/N, digitally modulated S/N ratio */
 {
-	if (fe->ops.delsys[0] == SYS_ISDBS) {
-		settings->min_delay_ms = 250;
-		settings->step_size = 1000;
-		settings->max_drift = settings->step_size * 2;
-	} else {
-		settings->min_delay_ms = 400;
-		settings->step_size = 142857;
-		settings->max_drift = settings->step_size;
-	}
-	return 0;
+	struct tc90522 *demod = fe->demodulator_priv;
+	s64 err = tc90522_get_cn_raw(demod);
+	*cn = err < 0 ? 0 : err;
+	dev_dbg(&demod->i2c->dev, "%s v3 CN %d (%lld dB)\n", demod->i2c->name, (int)*cn,
+		demod->type == SYS_ISDBS ? (int64_t)tc90522_get_cn_s(*cn) : (int64_t)tc90522_get_cn_t(*cn));
+	return err < 0 ? err : 0;
 }
 
-static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
+int tc90522_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct reg_val agc_sat[] = {
-		{ 0x0a, 0x00 },
-		{ 0x10, 0x30 },
-		{ 0x11, 0x00 },
-		{ 0x03, 0x01 },
-	};
-	struct reg_val agc_ter[] = {
-		{ 0x25, 0x00 },
-		{ 0x23, 0x4c },
-		{ 0x01, 0x40 },
-	};
-	struct tc90522_state *state;
-	struct reg_val *rv;
-	int num;
-
-	state = fe->demodulator_priv;
-	if (fe->ops.delsys[0] == SYS_ISDBS) {
-		agc_sat[0].val = on ? 0xff : 0x00;
-		agc_sat[1].val |= 0x80;
-		agc_sat[1].val |= on ? 0x01 : 0x00;
-		agc_sat[2].val |= on ? 0x40 : 0x00;
-		rv = agc_sat;
-		num = ARRAY_SIZE(agc_sat);
-	} else {
-		agc_ter[0].val = on ? 0x40 : 0x00;
-		agc_ter[1].val |= on ? 0x00 : 0x01;
-		rv = agc_ter;
-		num = ARRAY_SIZE(agc_ter);
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	s64 err = tc90522_get_cn_raw(demod),
+	    raw = err < 0 ? 0 : err;
+
+	switch (demod->state) {
+	case TC90522_IDLE:
+	case TC90522_SET_FREQUENCY:
+		*status = 0;
+		break;
+
+	case TC90522_SET_MODULATION:
+	case TC90522_ABORT:
+		*status |= FE_HAS_SIGNAL;
+		break;
+
+	case TC90522_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		break;
 	}
-	return reg_write(state, rv, num);
-}
 
-static const struct reg_val sleep_sat = { 0x17, 0x01 };
-static const struct reg_val sleep_ter = { 0x03, 0x90 };
+	c->cnr.len = 1;
+	c->cnr.stat[0].svalue = demod->type == SYS_ISDBS ? tc90522_get_cn_s(raw) : tc90522_get_cn_t(raw);
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	dev_dbg(&demod->i2c->dev, "%s v5 CN %lld (%lld dB)\n", demod->i2c->name, raw, c->cnr.stat[0].svalue);
+	return err < 0 ? err : 0;
+}
 
-static int tc90522_sleep(struct dvb_frontend *fe)
+/**** ISDB-S ****/
+int tc90522_tune_s(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
 {
-	struct tc90522_state *state;
-	int ret;
-
-	state = fe->demodulator_priv;
-	if (fe->ops.delsys[0] == SYS_ISDBS)
-		ret = reg_write(state, &sleep_sat, 1);
-	else {
-		ret = reg_write(state, &sleep_ter, 1);
-		if (ret == 0 && fe->ops.set_lna &&
-		    fe->dtv_property_cache.lna == LNA_AUTO) {
-			fe->dtv_property_cache.lna = 0;
-			ret = fe->ops.set_lna(fe);
-			fe->dtv_property_cache.lna = LNA_AUTO;
-		}
-	}
-	if (ret < 0)
-		dev_warn(&state->tuner_i2c.dev,
-			"(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
-}
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct tmcc_s tmcc;
+	int i, err,
+	    freq = fe->dtv_property_cache.frequency,
+	    tsid = fe->dtv_property_cache.stream_id;
+	u8 id_s[2];
+
+	if (re_tune)
+		demod->state = TC90522_SET_FREQUENCY;
+
+	switch (demod->state) {
+	case TC90522_IDLE:
+		*delay = msecs_to_jiffies(2000);
+		*status = 0;
+		return 0;
 
-static const struct reg_val wakeup_sat = { 0x17, 0x00 };
-static const struct reg_val wakeup_ter = { 0x03, 0x80 };
+	case TC90522_SET_FREQUENCY:
+		dev_dbg(&demod->i2c->dev, "%s #%d tsid 0x%x freq %d\n", demod->i2c->name, demod->idx, tsid, freq);
+		err = fe->ops.tuner_ops.set_frequency(fe, freq);
+		if (err)
+			return err;
+		demod->offset = 0;
+		demod->state = TC90522_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
 
-static int tc90522_init(struct dvb_frontend *fe)
-{
-	struct tc90522_state *state;
-	int ret;
-
-	/*
-	 * Because the init sequence is not public,
-	 * the parent device/driver should have init'ed the device before.
-	 * just wake up the device here.
-	 */
-
-	state = fe->demodulator_priv;
-	if (fe->ops.delsys[0] == SYS_ISDBS)
-		ret = reg_write(state, &wakeup_sat, 1);
-	else {
-		ret = reg_write(state, &wakeup_ter, 1);
-		if (ret == 0 && fe->ops.set_lna &&
-		    fe->dtv_property_cache.lna == LNA_AUTO) {
-			fe->dtv_property_cache.lna = 1;
-			ret = fe->ops.set_lna(fe);
-			fe->dtv_property_cache.lna = LNA_AUTO;
+	case TC90522_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			err = tc90522_read_tmcc_s(demod, &tmcc);
+			if (!err)
+				break;
+			msleep_interruptible(1);
 		}
-	}
-	if (ret < 0) {
-		dev_warn(&state->tuner_i2c.dev,
-			"(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-		return ret;
-	}
-
-	/* prefer 'all-layers' to 'none' as a default */
-	if (fe->dtv_property_cache.isdbt_layer_enabled == 0)
-		fe->dtv_property_cache.isdbt_layer_enabled = 7;
-	return tc90522_set_if_agc(fe, true);
-}
+		if (err) {
+			dev_dbg(&demod->i2c->dev, "%s fail tc_read_tmcc_s err=0x%x\n", demod->i2c->name, err);
+			demod->state = TC90522_ABORT;
+			*delay = msecs_to_jiffies(1000);
+			return err;
+		}
+		dev_dbg(&demod->i2c->dev, "%s slots=%d,%d,%d,%d mode=%d,%d,%d,%d tmcc.id=0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x\n",
+				demod->i2c->name,
+				tmcc.slot[0], tmcc.slot[1], tmcc.slot[2], tmcc.slot[3],
+				tmcc.mode[0], tmcc.mode[1], tmcc.mode[2], tmcc.mode[3],
+				tmcc.id[0], tmcc.id[1], tmcc.id[2], tmcc.id[3],
+				tmcc.id[4], tmcc.id[5], tmcc.id[6], tmcc.id[7]);
+		for (i = 0; i < ARRAY_SIZE(tmcc.id); i++) {
+			dev_dbg(&demod->i2c->dev, "%s tsid %x i %d tmcc.id %x\n", demod->i2c->name, tsid, i, tmcc.id[i]);
+			if (tmcc.id[i] == tsid)
+				break;
+		}
+		if (tsid < ARRAY_SIZE(tmcc.id))		/* treat as slot# */
+			i = tsid;
+		if (i == ARRAY_SIZE(tmcc.id)) {
+			dev_dbg(&demod->i2c->dev, "%s #%d i%d tsid 0x%x not found\n", demod->i2c->name, demod->idx, i, tsid);
+			return -EINVAL;
+		}
+		demod->offset = i;
+		dev_dbg(&demod->i2c->dev, "%s #%d found tsid 0x%x on slot %d\n", demod->i2c->name, demod->idx, tsid, i);
+
+		id_s[0] = (tmcc.id[demod->offset] >> 8)	& 0xff;
+		id_s[1] = tmcc.id[demod->offset]	& 0xff;
+		err = tc90522_write_data(fe, 0x8f, id_s, sizeof(id_s));
+		if (err) {
+			dev_dbg(&demod->i2c->dev, "%s fail set_tmcc_s err=%d\n", demod->i2c->name, err);
+			return err;
+		}
+		for (i = 0; i < 1000; i++) {
+			u16 short_id;
+
+			err = tc90522_read_id_s(demod, &short_id);
+			if (err) {
+				dev_dbg(&demod->i2c->dev, "%s fail get_id_s err=%d\n", demod->i2c->name, err);
+				return err;
+			}
+			tsid = short_id;
+			dev_dbg(&demod->i2c->dev, "%s #%d tsid=0x%x\n", demod->i2c->name, demod->idx, tsid);
+			if ((tsid & 0xffff) == tmcc.id[demod->offset])
+				break;
+			msleep_interruptible(1);
+		}
+		demod->state = TC90522_TRACK;
+		/* fallthrough */
 
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
 
-/*
- * tuner I2C adapter functions
- */
+	case TC90522_ABORT:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	return -ERANGE;
+}
 
-static int
-tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+int tc90522_read_tuner_s(struct dvb_frontend *fe, u8 *addr, int len)
 {
-	struct tc90522_state *state;
-	struct i2c_msg *new_msgs;
-	int i, j;
-	int ret, rd_num;
-	u8 wbuf[256];
-	u8 *p, *bufend;
-
-	if (num <= 0)
-		return -EINVAL;
+	struct tc90522 *demod = fe->demodulator_priv;
+	u8 buf[] = { TC90522_PASSTHROUGH, addr[0] << 1, addr[1], TC90522_PASSTHROUGH, (addr[0] << 1) | 1, 0 };
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf,	.len = 3, },
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf + 3,	.len = 2, },
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf + 5,	.len = 1, },
+	};
 
-	rd_num = 0;
-	for (i = 0; i < num; i++)
-		if (msgs[i].flags & I2C_M_RD)
-			rd_num++;
-	new_msgs = kmalloc(sizeof(*new_msgs) * (num + rd_num), GFP_KERNEL);
-	if (!new_msgs)
-		return -ENOMEM;
+	if (!addr || (len != 2))
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 3) == 3 ? buf[5] : -EREMOTEIO;
+}
 
-	state = i2c_get_adapdata(adap);
-	p = wbuf;
-	bufend = wbuf + sizeof(wbuf);
-	for (i = 0, j = 0; i < num; i++, j++) {
-		new_msgs[j].addr = state->i2c_client->addr;
-		new_msgs[j].flags = msgs[i].flags;
+static struct dvb_frontend_ops tc90522_ops_s = {
+	.delsys = { SYS_ISDBS },
+	.info = {
+		.name = "TC90522 ISDB-S",
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_MULTISTREAM |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+	.init = tc90522_wakeup,
+	.sleep = tc90522_sleep,
+	.release = tc90522_release,
+	.write = tc90522_write,
+	.get_frontend_algo = tc90522_get_frontend_algo,
+	.read_snr = tc90522_read_snr,
+	.read_status = tc90522_read_status,
+	.tune = tc90522_tune_s,
+	.tuner_ops.calc_regs = tc90522_read_tuner_s,
+};
 
-		if (msgs[i].flags & I2C_M_RD) {
-			new_msgs[j].flags &= ~I2C_M_RD;
-			if (p + 2 > bufend)
-				break;
-			p[0] = TC90522_I2C_THRU_REG;
-			p[1] = msgs[i].addr << 1 | 0x01;
-			new_msgs[j].buf = p;
-			new_msgs[j].len = 2;
-			p += 2;
-			j++;
-			new_msgs[j].addr = state->i2c_client->addr;
-			new_msgs[j].flags = msgs[i].flags;
-			new_msgs[j].buf = msgs[i].buf;
-			new_msgs[j].len = msgs[i].len;
-			continue;
+/**** ISDB-T ****/
+int tc90522_get_tmcc_t(struct tc90522 *demod)
+{
+	u8 buf;
+	u16 i = 65535;
+	bool b = false, retryov, fulock;
+
+	while (i--) {
+		if (tc90522_read(demod, 0x80, &buf, 1))
+			return -EBADMSG;
+		retryov = buf & 0b10000000 ? true : false;
+		fulock  = buf & 0b00001000 ? true : false;
+		if (!fulock) {
+			b = true;
+			break;
 		}
-
-		if (p + msgs[i].len + 2 > bufend)
+		if (retryov)
 			break;
-		p[0] = TC90522_I2C_THRU_REG;
-		p[1] = msgs[i].addr << 1;
-		memcpy(p + 2, msgs[i].buf, msgs[i].len);
-		new_msgs[j].buf = p;
-		new_msgs[j].len = msgs[i].len + 2;
-		p += new_msgs[j].len;
+		msleep_interruptible(1);
 	}
-
-	if (i < num)
-		ret = -ENOMEM;
-	else
-		ret = i2c_transfer(state->i2c_client->adapter, new_msgs, j);
-	if (ret >= 0 && ret < j)
-		ret = -EIO;
-	kfree(new_msgs);
-	return (ret == j) ? num : ret;
+	return b ? 0 : -EBADMSG;
 }
 
-static u32 tc90522_functionality(struct i2c_adapter *adap)
+int tc90522_tune_t(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
 {
-	return I2C_FUNC_I2C;
-}
+	struct tc90522 *demod = fe->demodulator_priv;
+	int err, i;
 
-static const struct i2c_algorithm tc90522_tuner_i2c_algo = {
-	.master_xfer   = &tc90522_master_xfer,
-	.functionality = &tc90522_functionality,
-};
+	if (re_tune)
+		demod->state = TC90522_SET_FREQUENCY;
 
+	switch (demod->state) {
+	case TC90522_IDLE:
+		*delay = msecs_to_jiffies(2000);
+		*status = 0;
+		return 0;
 
-/*
- * I2C driver functions
- */
+	case TC90522_SET_FREQUENCY:
+		if (fe->ops.tuner_ops.set_frequency(fe, fe->dtv_property_cache.frequency)) {
+			*delay = msecs_to_jiffies(1000);
+			*status = 0;
+			return 0;
+		}
+		demod->state = TC90522_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
 
-static const struct dvb_frontend_ops tc90522_ops_sat = {
-	.delsys = { SYS_ISDBS },
-	.info = {
-		.name = "Toshiba TC90522 ISDB-S module",
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
-		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
-			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
-	},
+	case TC90522_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			err = tc90522_get_tmcc_t(demod);
+			if (!err)
+				break;
+			msleep_interruptible(2);
+		}
+		if (err) {
+			dev_dbg(&demod->i2c->dev, "%s #%d fail get_tmcc_t err=%d\n", demod->i2c->name, demod->idx, err);
+				demod->state = TC90522_ABORT;
+				*delay = msecs_to_jiffies(1000);
+				return 0;
+		}
+		demod->state = TC90522_TRACK;
+		/* fallthrough */
 
-	.init = tc90522_init,
-	.sleep = tc90522_sleep,
-	.set_frontend = tc90522_set_frontend,
-	.get_tune_settings = tc90522_get_tune_settings,
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
 
-	.get_frontend = tc90522s_get_frontend,
-	.read_status = tc90522s_read_status,
-};
+	case TC90522_ABORT:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	return -ERANGE;
+}
+
+int tc90522_read_tuner_t(struct dvb_frontend *fe, u8 *addr, int len)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	u8 buf[] = { TC90522_PASSTHROUGH, (addr[0] << 1) | 1, 0 };
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf,	.len = 2, },
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf + 2,	.len = 1, },
+	};
+
+	if (!addr || (len != 1))
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 2) == 2 ? buf[2] : -EREMOTEIO;
+}
 
-static const struct dvb_frontend_ops tc90522_ops_ter = {
+static struct dvb_frontend_ops tc90522_ops_t = {
 	.delsys = { SYS_ISDBT },
 	.info = {
-		.name = "Toshiba TC90522 ISDB-T module",
-		.frequency_min = 470000000,
-		.frequency_max = 770000000,
-		.frequency_stepsize = 142857,
-		.caps = FE_CAN_INVERSION_AUTO |
-			FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
-			FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
-			FE_CAN_QPSK     | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
-			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_RECOVER |
-			FE_CAN_HIERARCHY_AUTO,
+		.name = "TC90522 ISDB-T",
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
 	},
-
-	.init = tc90522_init,
+	.init = tc90522_wakeup,
 	.sleep = tc90522_sleep,
-	.set_frontend = tc90522_set_frontend,
-	.get_tune_settings = tc90522_get_tune_settings,
-
-	.get_frontend = tc90522t_get_frontend,
-	.read_status = tc90522t_read_status,
+	.release = tc90522_release,
+	.write = tc90522_write,
+	.get_frontend_algo = tc90522_get_frontend_algo,
+	.read_snr = tc90522_read_snr,
+	.read_status = tc90522_read_status,
+	.tune = tc90522_tune_t,
+	.tuner_ops.calc_regs = tc90522_read_tuner_t,
 };
 
-
-static int tc90522_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+/**** Common ****/
+int tc90522_remove(struct i2c_client *client)
 {
-	struct tc90522_state *state;
-	struct tc90522_config *cfg;
-	const struct dvb_frontend_ops *ops;
-	struct i2c_adapter *adap;
-	int ret;
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->i2c_client = client;
-
-	cfg = client->dev.platform_data;
-	memcpy(&state->cfg, cfg, sizeof(state->cfg));
-	cfg->fe = state->cfg.fe = &state->fe;
-	ops =  id->driver_data == 0 ? &tc90522_ops_sat : &tc90522_ops_ter;
-	memcpy(&state->fe.ops, ops, sizeof(*ops));
-	state->fe.demodulator_priv = state;
-
-	adap = &state->tuner_i2c;
-	adap->owner = THIS_MODULE;
-	adap->algo = &tc90522_tuner_i2c_algo;
-	adap->dev.parent = &client->dev;
-	strlcpy(adap->name, "tc90522_sub", sizeof(adap->name));
-	i2c_set_adapdata(adap, state);
-	ret = i2c_add_adapter(adap);
-	if (ret < 0)
-		goto err;
-	cfg->tuner_i2c = state->cfg.tuner_i2c = adap;
-
-	i2c_set_clientdata(client, &state->cfg);
-	dev_info(&client->dev, "Toshiba TC90522 attached.\n");
+	dev_dbg(&client->dev, "%s\n", __func__);
+	kfree(i2c_get_clientdata(client));
 	return 0;
-
-err:
-	kfree(state);
-	return ret;
 }
 
-static int tc90522_remove(struct i2c_client *client)
+int tc90522_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct tc90522_state *state;
+	struct tc90522_config *cfg = client->dev.platform_data;
+	struct tc90522 *demod = kzalloc(sizeof(struct tc90522), GFP_KERNEL);
+	struct dvb_frontend *fe	= &demod->fe;
 
-	state = cfg_to_state(i2c_get_clientdata(client));
-	i2c_del_adapter(&state->tuner_i2c);
-	kfree(state);
+	if (!demod)
+		return -ENOMEM;
+	demod->addr_demod = client->addr;
+	demod->idx	= (!(client->addr & 1) << 1) + ((client->addr & 2) >> 1);
+	demod->i2c	= client->adapter;
+	demod->type	= cfg->type;
+	memcpy(&fe->ops, (demod->type == SYS_ISDBS) ? &tc90522_ops_s : &tc90522_ops_t, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = demod;
+	if (cfg->pwr && (tc90522_set_powers(demod, TC90522_PWR_TUNER_ON)	||
+			i2c_transfer(demod->i2c, NULL, 0)			||
+			tc90522_set_powers(demod, TC90522_PWR_TUNER_ON | TC90522_PWR_AMP_ON))) {
+		tc90522_release(fe);
+		return -EIO;
+	}
+	cfg->fe = fe;
+	i2c_set_clientdata(client, demod);
 	return 0;
 }
 
-
-static const struct i2c_device_id tc90522_id[] = {
-	{ TC90522_I2C_DEV_SAT, 0 },
-	{ TC90522_I2C_DEV_TER, 1 },
-	{}
+static struct i2c_device_id tc90522_id_table[] = {
+	{ TC90522_DRVNAME, 0 },
+	{ },
 };
-MODULE_DEVICE_TABLE(i2c, tc90522_id);
+MODULE_DEVICE_TABLE(i2c, tc90522_id_table);
 
 static struct i2c_driver tc90522_driver = {
 	.driver = {
-		.name	= "tc90522",
+		.owner	= THIS_MODULE,
+		.name	= tc90522_id_table->name,
 	},
 	.probe		= tc90522_probe,
 	.remove		= tc90522_remove,
-	.id_table	= tc90522_id,
+	.id_table	= tc90522_id_table,
 };
-
 module_i2c_driver(tc90522_driver);
 
-MODULE_DESCRIPTION("Toshiba TC90522 frontend");
-MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Toshiba TC90522 8PSK(ISDB-S)/OFDM(ISDB-T) PT3 quad demodulator");
 MODULE_LICENSE("GPL");
+
-- 
1.8.4.5

