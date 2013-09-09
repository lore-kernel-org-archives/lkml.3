Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab3IIQEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:04:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab3IIQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:03:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 1/4] pinctrl: sh-pfc: r8a7790: add pin definitions for the I2C3 interface
Date: Mon,  9 Sep 2013 18:03:53 +0200
Message-Id: <1378742636-11215-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:1OAHxN5IIaPiPbvuvp70kMmkQSGpRNypSgjGQnQhjkj
 YdCl4FNDkZEX5XmA4BO+lUKhPg6PUSKg0yWWVcXLMzN88ZsV9G
 mn5eLSa5CrX8Ly29dT+Lxw/EAPdpNW07i+WrPJtpNT8nLjUj+a
 q3NMH6VZIIBtbxHu1fGrHEvT5LAQYcOYfimMlk49NieoGRChUF
 8fn0WJAjr8qcKDaNuHFammeM4EAADRJiJ/kozRZvNt0uPmaazA
 Rk+YqdIsQ+olm0/nvPtCPxLs9/A7OL99u8a2paDVxPmk/qh4O6
 XJfJtzBKKyzPMyxor9pzBW4AGR8TAg0nXc8ejMJQ7V+0z54eMR
 Zhs58gFAFh4OvsNZRcOhByLeup/b6wIWNvSGKvO7PVnCLk6/IQ
 RxSRiynjv3Ruw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are four I2C interfaces on r8a7790, each of them can be connected to
one of the two respective I2C controllers, e.g. interface #0 can be
configured to work with I2C0 or with IIC0. Additionally some of those
interfaces can also use one of several pin sets. Interface #3 is special,
because it can be used in automatic mode for DVFS. It only has one set
of pins available and those pins cannot be used for anything else, they
also lack the GPIO function.

This patch uses the sh-pfc ability to configure pins, not associated with
GPIOs and adds support for I2C3 to the r8a7790 PFC set up.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
index 64fcc006..c3c4d9b 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
@@ -781,6 +781,8 @@ enum {
 	ADICS_SAMP_MARK, DU2_CDE_MARK, QPOLB_MARK, SCIFA2_RXD_B_MARK,
 	USB1_PWEN_MARK, AUDIO_CLKOUT_D_MARK, USB1_OVC_MARK,
 	TCLK1_B_MARK,
+
+	I2C3_SCL_MARK, I2C3_SDA_MARK,
 	PINMUX_MARK_END,
 };
 
@@ -1719,10 +1721,22 @@ static const u16 pinmux_data[] = {
 	PINMUX_IPSR_DATA(IP16_6, AUDIO_CLKOUT_D),
 	PINMUX_IPSR_DATA(IP16_7, USB1_OVC),
 	PINMUX_IPSR_MODSEL_DATA(IP16_7, TCLK1_B, SEL_TMU1_1),
+
+	PINMUX_DATA(I2C3_SCL_MARK, FN_SEL_IICDVFS_1),
+	PINMUX_DATA(I2C3_SDA_MARK, FN_SEL_IICDVFS_1),
 };
 
+/* R8A7790 has 6 banks with 32 GPIOs in each = 192 GPIOs */
+#define ROW_GROUP_A(r) ('Z' - 'A' + 1 + (r))
+#define PIN_NUMBER(r, c) (((r) - 'A') * 16 + (c) + 200)
+#define PIN_A_NUMBER(r, c) PIN_NUMBER(ROW_GROUP_A(r), c)
+
 static struct sh_pfc_pin pinmux_pins[] = {
 	PINMUX_GPIO_GP_ALL(),
+
+	/* Pins not associated with a GPIO port */
+	SH_PFC_PIN_NAMED(ROW_GROUP_A('J'), 15, AJ15),
+	SH_PFC_PIN_NAMED(ROW_GROUP_A('H'), 15, AH15),
 };
 
 /* - DU RGB ----------------------------------------------------------------- */
@@ -1990,6 +2004,14 @@ static const unsigned int hscif1_ctrl_b_pins[] = {
 static const unsigned int hscif1_ctrl_b_mux[] = {
 	HRTS1_N_B_MARK, HCTS1_N_B_MARK,
 };
+/* - I2C3 ------------------------------------------------------------------- */
+static const unsigned int i2c3_pins[] = {
+	/* SCL, SDA */
+	PIN_A_NUMBER('J', 15), PIN_A_NUMBER('H', 15),
+};
+static const unsigned int i2c3_mux[] = {
+	I2C3_SCL_MARK, I2C3_SDA_MARK,
+};
 /* - INTC ------------------------------------------------------------------- */
 static const unsigned int intc_irq0_pins[] = {
 	/* IRQ */
@@ -3047,6 +3069,7 @@ static const struct sh_pfc_pin_group pinmux_groups[] = {
 	SH_PFC_PIN_GROUP(hscif1_data_b),
 	SH_PFC_PIN_GROUP(hscif1_clk_b),
 	SH_PFC_PIN_GROUP(hscif1_ctrl_b),
+	SH_PFC_PIN_GROUP(i2c3),
 	SH_PFC_PIN_GROUP(intc_irq0),
 	SH_PFC_PIN_GROUP(intc_irq1),
 	SH_PFC_PIN_GROUP(intc_irq2),
@@ -3243,6 +3266,10 @@ static const char * const hscif1_groups[] = {
 	"hscif1_ctrl_b",
 };
 
+static const char * const i2c3_groups[] = {
+	"i2c3",
+};
+
 static const char * const intc_groups[] = {
 	"intc_irq0",
 	"intc_irq1",
@@ -3469,6 +3496,7 @@ static const struct sh_pfc_function pinmux_functions[] = {
 	SH_PFC_FUNCTION(eth),
 	SH_PFC_FUNCTION(hscif0),
 	SH_PFC_FUNCTION(hscif1),
+	SH_PFC_FUNCTION(i2c3),
 	SH_PFC_FUNCTION(intc),
 	SH_PFC_FUNCTION(mmc0),
 	SH_PFC_FUNCTION(mmc1),
-- 
1.7.2.5

