Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaJEJBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:01:32 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50871 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaJEJAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:00:35 -0400
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=" 
	<info@are.ma>
X-Google-Original-From: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, crope@iki.fi, m.chehab@samsung.com,
        mchehab@osg.samsung.com, hdegoede@redhat.com,
        laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
        sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
        peter.senna@gmail.com
Subject: [PATCH 09/11] mxl301rf: namespace cleanup & remodelling
Date: Sun,  5 Oct 2014 17:59:45 +0900
Message-Id: <71d57e0796dd43d589c34db6d281b2d34dfa6fc8.1412497399.git.knightrider@are.ma>
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
 drivers/media/tuners/mxl301rf.c | 550 +++++++++++++++++++++-------------------
 1 file changed, 291 insertions(+), 259 deletions(-)

diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
index 1575a5d..b1ed978 100644
--- a/drivers/media/tuners/mxl301rf.c
+++ b/drivers/media/tuners/mxl301rf.c
@@ -1,12 +1,12 @@
 /*
- * MaxLinear MxL301RF OFDM tuner driver
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-T tuner MaxLinear CMOS Hybrid TV MxL301RF
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
@@ -14,116 +14,24 @@
  * GNU General Public License for more details.
  */
 
-/*
- * NOTICE:
- * This driver is incomplete and lacks init/config of the chips,
- * as the necessary info is not disclosed.
- * Other features like get_if_frequency() are missing as well.
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
+#include "dvb_frontend.h"
 #include "mxl301rf.h"
 
-struct mxl301rf_state {
-	struct mxl301rf_config cfg;
-	struct i2c_client *i2c;
+struct mxl301rf {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx;
+	u32 freq;
+	int (*read)(struct dvb_frontend *fe, u8 *buf, int buflen);
 };
 
-static struct mxl301rf_state *cfg_to_state(struct mxl301rf_config *c)
-{
-	return container_of(c, struct mxl301rf_state, cfg);
-}
-
-static int raw_write(struct mxl301rf_state *state, const u8 *buf, int len)
-{
-	int ret;
-
-	ret = i2c_master_send(state->i2c, buf, len);
-	if (ret >= 0 && ret < len)
-		ret = -EIO;
-	return (ret == len) ? 0 : ret;
-}
-
-static int reg_write(struct mxl301rf_state *state, u8 reg, u8 val)
-{
-	u8 buf[2] = { reg, val };
-
-	return raw_write(state, buf, 2);
-}
-
-static int reg_read(struct mxl301rf_state *state, u8 reg, u8 *val)
-{
-	u8 wbuf[2] = { 0xfb, reg };
-	int ret;
-
-	ret = raw_write(state, wbuf, sizeof(wbuf));
-	if (ret == 0)
-		ret = i2c_master_recv(state->i2c, val, 1);
-	if (ret >= 0 && ret < 1)
-		ret = -EIO;
-	return (ret == 1) ? 0 : ret;
-}
-
-/* tuner_ops */
-
-/* get RSSI and update propery cache, set to *out in % */
-static int mxl301rf_get_rf_strength(struct dvb_frontend *fe, u16 *out)
-{
-	struct mxl301rf_state *state;
-	int ret;
-	u8  rf_in1, rf_in2, rf_off1, rf_off2;
-	u16 rf_in, rf_off;
-	s64 level;
-	struct dtv_fe_stats *rssi;
-
-	rssi = &fe->dtv_property_cache.strength;
-	rssi->len = 1;
-	rssi->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	*out = 0;
-
-	state = fe->tuner_priv;
-	ret = reg_write(state, 0x14, 0x01);
-	if (ret < 0)
-		return ret;
-	usleep_range(1000, 2000);
-
-	ret = reg_read(state, 0x18, &rf_in1);
-	if (ret == 0)
-		ret = reg_read(state, 0x19, &rf_in2);
-	if (ret == 0)
-		ret = reg_read(state, 0xd6, &rf_off1);
-	if (ret == 0)
-		ret = reg_read(state, 0xd7, &rf_off2);
-	if (ret != 0)
-		return ret;
-
-	rf_in = (rf_in2 & 0x07) << 8 | rf_in1;
-	rf_off = (rf_off2 & 0x0f) << 5 | (rf_off1 >> 3);
-	level = rf_in - rf_off - (113 << 3); /* x8 dBm */
-	level = level * 1000 / 8;
-	rssi->stat[0].svalue = level;
-	rssi->stat[0].scale = FE_SCALE_DECIBEL;
-	/* *out = (level - min) * 100 / (max - min) */
-	*out = (rf_in - rf_off + (1 << 9) - 1) * 100 / ((5 << 9) - 2);
-	return 0;
-}
-
-/* spur shift parameters */
-struct shf {
-	u32	freq;		/* Channel center frequency */
-	u32	ofst_th;	/* Offset frequency threshold */
-	u8	shf_val;	/* Spur shift value */
-	u8	shf_dir;	/* Spur shift direction */
+struct shf_dvbt {
+	u32	freq,		/* Channel center frequency @ kHz	*/
+		freq_th;	/* Offset frequency threshold @ kHz	*/
+	u8	shf_val,	/* Spur shift value			*/
+		shf_dir;	/* Spur shift direction			*/
 };
 
-static const struct shf shf_tab[] = {
+static const struct shf_dvbt shf_dvbt_tab[] = {
 	{  64500, 500, 0x92, 0x07 },
 	{ 191500, 300, 0xe2, 0x07 },
 	{ 205500, 500, 0x2c, 0x04 },
@@ -143,207 +51,331 @@ static const struct shf shf_tab[] = {
 	{ 153143, 500, 0x01, 0x07 }
 };
 
-struct reg_val {
-	u8 reg;
-	u8 val;
-} __attribute__ ((__packed__));
-
-static const struct reg_val set_idac[] = {
-	{ 0x0d, 0x00 },
-	{ 0x0c, 0x67 },
-	{ 0x6f, 0x89 },
-	{ 0x70, 0x0c },
-	{ 0x6f, 0x8a },
-	{ 0x70, 0x0e },
-	{ 0x6f, 0x8b },
-	{ 0x70, 0x1c },
+static const u32 mxl301rf_rf_tab[112] = {
+	0x058d3f49, 0x05e8ccc9, 0x06445a49, 0x069fe7c9, 0x06fb7549,
+	0x075702c9, 0x07b29049, 0x080e1dc9, 0x0869ab49, 0x08c538c9,
+	0x0920c649, 0x097c53c9, 0x09f665c9, 0x0a51f349, 0x0aad80c9,
+	0x0b090e49, 0x0b649bc9, 0x0ba1a4c9, 0x0bfd3249, 0x0c58bfc9,
+	0x0cb44d49, 0x0d0fdac9, 0x0d6b6849, 0x0dc6f5c9, 0x0e228349,
+	0x0e7e10c9, 0x0ed99e49, 0x0f352bc9, 0x0f90b949, 0x0fec46c9,
+	0x1047d449, 0x10a361c9, 0x10feef49, 0x115a7cc9, 0x11b60a49,
+	0x121197c9, 0x126d2549, 0x12c8b2c9, 0x13244049, 0x137fcdc9,
+	0x13db5b49, 0x1436e8c9, 0x14927649, 0x14ee03c9, 0x15499149,
+	0x15a51ec9, 0x1600ac49, 0x165c39c9, 0x16b7c749, 0x171354c9,
+	0x176ee249, 0x17ca6fc9, 0x1825fd49, 0x18818ac9, 0x18dd1849,
+	0x1938a5c9, 0x19943349, 0x19efc0c9, 0x1a4b4e49, 0x1aa6dbc9,
+	0x1b026949, 0x1b5df6c9, 0x1bb98449, 0x1c339649, 0x1c8f23c9,
+	0x1ceab149, 0x1d463ec9, 0x1da1cc49, 0x1dfd59c9, 0x1e58e749,
+	0x1eb474c9, 0x1f100249, 0x1f6b8fc9, 0x1fc71d49, 0x2022aac9,
+	0x207e3849, 0x20d9c5c9, 0x21355349, 0x2190e0c9, 0x21ec6e49,
+	0x2247fbc9, 0x22a38949, 0x22ff16c9, 0x235aa449, 0x23b631c9,
+	0x2411bf49, 0x246d4cc9, 0x24c8da49, 0x252467c9, 0x257ff549,
+	0x25db82c9, 0x26371049, 0x26929dc9, 0x26ee2b49, 0x2749b8c9,
+	0x27a54649, 0x2800d3c9, 0x285c6149, 0x28b7eec9, 0x29137c49,
+	0x296f09c9, 0x29ca9749, 0x2a2624c9, 0x2a81b249, 0x2add3fc9,
+	0x2b38cd49, 0x2b945ac9, 0x2befe849, 0x2c4b75c9, 0x2ca70349,
+	0x2d0290c9, 0x2d5e1e49,
 };
+#define MXL301RF_NHK (mxl301rf_rf_tab[77])	/* 日本放送協会 Nippon Hōsō Kyōkai, Japan Broadcasting Corporation */
 
-static int mxl301rf_set_params(struct dvb_frontend *fe)
+int mxl301rf_freq(int freq)
 {
-	struct reg_val tune0[] = {
-		{ 0x13, 0x00 },		/* abort tuning */
-		{ 0x3b, 0xc0 },
-		{ 0x3b, 0x80 },
-		{ 0x10, 0x95 },		/* BW */
-		{ 0x1a, 0x05 },
-		{ 0x61, 0x00 },		/* spur shift value (placeholder) */
-		{ 0x62, 0xa0 }		/* spur shift direction (placeholder) */
-	};
+	if (freq >= 90000000)
+		return freq;					/* real_freq Hz	*/
+	if (freq > 255)
+		return MXL301RF_NHK;
+	if (freq > 127)
+		return mxl301rf_rf_tab[freq - 128];		/* freqno (IO#)	*/
+	if (freq > 63) {					/* CATV		*/
+		freq -= 64;
+		if (freq > 22)
+			return mxl301rf_rf_tab[freq - 1];	/* C23-C62	*/
+		if (freq > 12)
+			return mxl301rf_rf_tab[freq - 10];	/* C13-C22	*/
+		return MXL301RF_NHK;
+	}
+	if (freq > 62)
+		return MXL301RF_NHK;
+	if (freq > 12)
+		return mxl301rf_rf_tab[freq + 50];		/* 13-62	*/
+	if (freq >  3)
+		return mxl301rf_rf_tab[freq +  9];		/*  4-12	*/
+	if (freq)
+		return mxl301rf_rf_tab[freq -  1];		/*  1-3		*/
+	return MXL301RF_NHK;
+}
 
-	struct reg_val tune1[] = {
-		{ 0x11, 0x40 },		/* RF frequency L (placeholder) */
-		{ 0x12, 0x0e },		/* RF frequency H (placeholder) */
-		{ 0x13, 0x01 }		/* start tune */
+void mxl301rf_rftune(struct dvb_frontend *fe, u8 *data, u32 *size, u32 freq)
+{
+	u8 rf_data[] = {
+		0x13, 0x00,	/* abort tune			*/
+		0x3b, 0xc0,
+		0x3b, 0x80,
+		0x10, 0x95,	/* BW				*/
+		0x1a, 0x05,
+		0x61, 0x00,
+		0x62, 0xa0,
+		0x11, 0x40,	/* 2 bytes to store RF freq.	*/
+		0x12, 0x0e,	/* 2 bytes to store RF freq.	*/
+		0x13, 0x01	/* start tune			*/
 	};
-
-	struct mxl301rf_state *state;
-	u32 freq;
-	u16 f;
-	u32 tmp, div;
-	int i, ret;
-
-	state = fe->tuner_priv;
-	freq = fe->dtv_property_cache.frequency;
-
-	/* spur shift function (for analog) */
-	for (i = 0; i < ARRAY_SIZE(shf_tab); i++) {
-		if (freq >= (shf_tab[i].freq - shf_tab[i].ofst_th) * 1000 &&
-		    freq <= (shf_tab[i].freq + shf_tab[i].ofst_th) * 1000) {
-			tune0[5].val = shf_tab[i].shf_val;
-			tune0[6].val = 0xa0 | shf_tab[i].shf_dir;
-			break;
-		}
-	}
-	ret = raw_write(state, (u8 *) tune0, sizeof(tune0));
-	if (ret < 0)
-		goto failed;
-	usleep_range(3000, 4000);
-
-	/* convert freq to 10.6 fixed point float [MHz] */
-	f = freq / 1000000;
-	tmp = freq % 1000000;
-	div = 1000000;
+	u32 i, dig_rf_freq, tmp,
+		kHz = 1000,
+		MHz = 1000000,
+		frac_divider = 1000000;
+
+	freq = mxl301rf_freq(freq);
+	dig_rf_freq = freq / MHz;
+	tmp = freq % MHz;
 	for (i = 0; i < 6; i++) {
-		f <<= 1;
-		div >>= 1;
-		if (tmp > div) {
-			tmp -= div;
-			f |= 1;
+		dig_rf_freq <<= 1;
+		frac_divider /= 2;
+		if (tmp > frac_divider) {
+			tmp -= frac_divider;
+			dig_rf_freq++;
 		}
 	}
 	if (tmp > 7812)
-		f++;
-	tune1[0].val = f & 0xff;
-	tune1[1].val = f >> 8;
-	ret = raw_write(state, (u8 *) tune1, sizeof(tune1));
-	if (ret < 0)
-		goto failed;
-	msleep(31);
-
-	ret = reg_write(state, 0x1a, 0x0d);
-	if (ret < 0)
-		goto failed;
-	ret = raw_write(state, (u8 *) set_idac, sizeof(set_idac));
-	if (ret < 0)
-		goto failed;
-	return 0;
+		dig_rf_freq++;
+	rf_data[2 * 7 + 1] = (u8)(dig_rf_freq);
+	rf_data[2 * 8 + 1] = (u8)(dig_rf_freq >> 8);
+
+	for (i = 0; i < ARRAY_SIZE(shf_dvbt_tab); i++) {
+		if ((freq >= (shf_dvbt_tab[i].freq - shf_dvbt_tab[i].freq_th) * kHz) &&
+				(freq <= (shf_dvbt_tab[i].freq + shf_dvbt_tab[i].freq_th) * kHz)) {
+			rf_data[2 * 5 + 1] = shf_dvbt_tab[i].shf_val;
+			rf_data[2 * 6 + 1] = 0xa0 | shf_dvbt_tab[i].shf_dir;
+			break;
+		}
+	}
+	memcpy(data, rf_data, sizeof(rf_data));
+	*size = sizeof(rf_data);
 
-failed:
-	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-		__func__, fe->dvb->num, fe->id);
-	return ret;
+	dev_dbg(fe->dvb->device, "mx_rftune freq=%d\n", freq);
 }
 
-static const struct reg_val standby_data[] = {
-	{ 0x01, 0x00 },
-	{ 0x13, 0x00 }
-};
-
-static int mxl301rf_sleep(struct dvb_frontend *fe)
+/* write via demodulator */
+int mxl301rf_fe_write_data(struct dvb_frontend *fe, u8 addr_data, const u8 *data, int len)
 {
-	struct mxl301rf_state *state;
-	int ret;
+	u8 buf[len + 1];
 
-	state = fe->tuner_priv;
-	ret = raw_write(state, (u8 *)standby_data, sizeof(standby_data));
-	if (ret < 0)
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
 }
 
+#define MXL301RF_FE_PASSTHROUGH 0xfe
 
-/* init sequence is not public.
- * the parent must have init'ed the device.
- * just wake up here.
- */
-static int mxl301rf_init(struct dvb_frontend *fe)
+int mxl301rf_fe_write_tuner(struct dvb_frontend *fe, const u8 *data, int len)
 {
-	struct mxl301rf_state *state;
+	u8 buf[len + 2];
+
+	buf[0] = MXL301RF_FE_PASSTHROUGH;
+	buf[1] = ((struct mxl301rf *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
+}
+
+/* read via demodulator */
+void mxl301rf_fe_read(struct dvb_frontend *fe, u8 addr, u8 *data)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	const u8 wbuf[2] = {0xfb, addr};
 	int ret;
 
-	state = fe->tuner_priv;
+	mxl301rf_fe_write_tuner(fe, wbuf, sizeof(wbuf));
+	ret = mx->read(fe, &mx->addr_tuner, 1);
+	if (ret >= 0)
+		*data = ret;
+}
 
-	ret = reg_write(state, 0x01, 0x01);
-	if (ret < 0) {
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			 __func__, fe->dvb->num, fe->id);
-		return ret;
-	}
-	return 0;
+void mxl301rf_idac_setting(struct dvb_frontend *fe)
+{
+	const u8 idac[] = {
+		0x0d, 0x00,
+		0x0c, 0x67,
+		0x6f, 0x89,
+		0x70, 0x0c,
+		0x6f, 0x8a,
+		0x70, 0x0e,
+		0x6f, 0x8b,
+		0x70, 0x10+12,
+	};
+	mxl301rf_fe_write_tuner(fe, idac, sizeof(idac));
 }
 
-/* I2C driver functions */
+void mxl301rf_set_register(struct dvb_frontend *fe, u8 addr, u8 value)
+{
+	const u8 data[2] = {addr, value};
 
-static const struct dvb_tuner_ops mxl301rf_ops = {
-	.info = {
-		.name = "MaxLinear MxL301RF",
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+}
 
-		.frequency_min =  93000000,
-		.frequency_max = 803142857,
-	},
+int mxl301rf_write_imsrst(struct dvb_frontend *fe)
+{
+	u8 data = 0x01 << 6;
 
-	.init = mxl301rf_init,
-	.sleep = mxl301rf_sleep,
+	return mxl301rf_fe_write_data(fe, 0x01, &data, 1);
+}
 
-	.set_params = mxl301rf_set_params,
-	.get_rf_strength = mxl301rf_get_rf_strength,
+enum mxl301rf_agc {
+	MXL301RF_AGC_AUTO,
+	MXL301RF_AGC_MANUAL,
 };
 
+int mxl301rf_set_agc(struct dvb_frontend *fe, enum mxl301rf_agc agc)
+{
+	u8 data = (agc == MXL301RF_AGC_AUTO) ? 0x40 : 0x00;
+	int err = mxl301rf_fe_write_data(fe, 0x25, &data, 1);
+
+	if (err)
+		return err;
+	data = 0x4c | ((agc == MXL301RF_AGC_AUTO) ? 0x00 : 0x01);
+	return	mxl301rf_fe_write_data(fe, 0x23, &data, 1) ||
+		mxl301rf_write_imsrst(fe);
+}
 
-static int mxl301rf_probe(struct i2c_client *client,
-			  const struct i2c_device_id *id)
+int mxl301rf_sleep(struct dvb_frontend *fe)
 {
-	struct mxl301rf_state *state;
-	struct mxl301rf_config *cfg;
-	struct dvb_frontend *fe;
+	u8 buf = (1 << 7) | (1 << 4);
+	const u8 data[4] = {0x01, 0x00, 0x13, 0x00};
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+
+	if (err)
+		return err;
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+	return mxl301rf_fe_write_data(fe, 0x03, &buf, 1);
+}
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
+bool mxl301rf_rfsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
 
-	state->i2c = client;
-	cfg = client->dev.platform_data;
+	mxl301rf_fe_read(fe, 0x16, &data);
+	return (data & 0x0c) == 0x0c;
+}
 
-	memcpy(&state->cfg, cfg, sizeof(state->cfg));
-	fe = cfg->fe;
-	fe->tuner_priv = state;
-	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(mxl301rf_ops));
+bool mxl301rf_refsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
 
-	i2c_set_clientdata(client, &state->cfg);
-	dev_info(&client->dev, "MaxLinear MxL301RF attached.\n");
+	mxl301rf_fe_read(fe, 0x16, &data);
+	return (data & 0x03) == 0x03;
+}
+
+bool mxl301rf_locked(struct dvb_frontend *fe)
+{
+	bool locked1 = false, locked2 = false;
+	unsigned long timeout = jiffies + msecs_to_jiffies(100);
+
+	while (time_before(jiffies, timeout)) {
+		locked1 = mxl301rf_rfsynth_locked(fe);
+		locked2 = mxl301rf_refsynth_locked(fe);
+		if (locked1 && locked2)
+			break;
+		msleep_interruptible(1);
+	}
+	dev_dbg(fe->dvb->device, "#%d %s lock1=%d lock2=%d\n", ((struct mxl301rf *)fe->tuner_priv)->idx, __func__, locked1, locked2);
+	return locked1 && locked2 ? !mxl301rf_set_agc(fe, MXL301RF_AGC_AUTO) : false;
+}
+
+int mxl301rf_tuner_rftune(struct dvb_frontend *fe, u32 freq)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	u8 data[100];
+	u32 size = 0;
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+
+	if (err)
+		return err;
+	mx->freq = freq;
+	mxl301rf_rftune(fe, data, &size, freq);
+	if (size != 20) {
+		dev_dbg(fe->dvb->device, "fail mx_rftune size = %d\n", size);
+		return -EINVAL;
+	}
+	mxl301rf_fe_write_tuner(fe, data, 14);
+	msleep_interruptible(1);
+	mxl301rf_fe_write_tuner(fe, data + 14, 6);
+	msleep_interruptible(1);
+	mxl301rf_set_register(fe, 0x1a, 0x0d);
+	mxl301rf_idac_setting(fe);
+	return mxl301rf_locked(fe) ? 0 : -ETIMEDOUT;
+}
+
+int mxl301rf_wakeup(struct dvb_frontend *fe)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	int err;
+	u8 buf = (1 << 7) | (0 << 4);
+	const u8 data[2] = {0x01, 0x01};
+
+	err = mxl301rf_fe_write_data(fe, 0x03, &buf, 1);
+	if (err)
+		return err;
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+	mxl301rf_tuner_rftune(fe, mx->freq);
 	return 0;
 }
 
-static int mxl301rf_remove(struct i2c_client *client)
+static struct dvb_tuner_ops mxl301rf_ops = {
+	.info = {
+		.frequency_min	= 1,		/* freq under 90 MHz is handled as channel */
+		.frequency_max	= 770000000,	/* Hz */
+		.frequency_step	= 142857,
+	},
+	.set_frequency = mxl301rf_tuner_rftune,
+	.sleep = mxl301rf_sleep,
+	.init = mxl301rf_wakeup,
+};
+
+int mxl301rf_remove(struct i2c_client *client)
 {
-	struct mxl301rf_state *state;
+	struct dvb_frontend *fe = i2c_get_clientdata(client);
 
-	state = cfg_to_state(i2c_get_clientdata(client));
-	state->cfg.fe->tuner_priv = NULL;
-	kfree(state);
+	dev_dbg(&client->dev, "%s\n", __func__);
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
 	return 0;
 }
 
+int mxl301rf_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	u8 d[] = { 0x10, 0x01 };
+	struct dvb_frontend *fe = client->dev.platform_data;
+	struct mxl301rf *mx = kzalloc(sizeof(struct mxl301rf), GFP_KERNEL);
 
-static const struct i2c_device_id mxl301rf_id[] = {
-	{"mxl301rf", 0},
-	{}
+	if (!mx)
+		return -ENOMEM;
+	fe->tuner_priv = mx;
+	mx->fe = fe;
+	mx->idx = (client->addr & 1) | 2;
+	mx->addr_tuner = client->addr;
+	mx->read = fe->ops.tuner_ops.calc_regs;
+	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(struct dvb_tuner_ops));
+	i2c_set_clientdata(client, fe);
+	return	mxl301rf_fe_write_data(fe, 0x1c, d, 1)	||
+		mxl301rf_fe_write_data(fe, 0x1d, d+1, 1);
+}
+
+static struct i2c_device_id mxl301rf_id_table[] = {
+	{ MXL301RF_DRVNAME, 0 },
+	{ },
 };
-MODULE_DEVICE_TABLE(i2c, mxl301rf_id);
+MODULE_DEVICE_TABLE(i2c, mxl301rf_id_table);
 
 static struct i2c_driver mxl301rf_driver = {
 	.driver = {
-		.name	= "mxl301rf",
+		.owner	= THIS_MODULE,
+		.name	= mxl301rf_id_table->name,
 	},
 	.probe		= mxl301rf_probe,
 	.remove		= mxl301rf_remove,
-	.id_table	= mxl301rf_id,
+	.id_table	= mxl301rf_id_table,
 };
-
 module_i2c_driver(mxl301rf_driver);
 
-MODULE_DESCRIPTION("MaxLinear MXL301RF tuner");
-MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 MxL301RF MaxLinear CMOS Hybrid TV ISDB-T tuner driver");
 MODULE_LICENSE("GPL");
+
-- 
1.8.4.5

