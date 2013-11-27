Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3K0Hkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 02:40:41 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50034 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3K0Hki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 02:40:38 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: wsa@the-dreams.de, linus.walleij@linaro.org, linux-sh@vger.kernel.org,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 27 Nov 2013 16:41:22 +0900
Message-Id: <20131127074122.18314.48522.sendpatchset@w520>
Subject: [PATCH] pinctrl: sh-pfc: Initial r7s72100 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add r7s72100 PINCTRL support via sh-pfc. At this point this code
provides enough support to allow use together with the gpio-rz
driver. Incremental per-device patches will in the future be
submitted on top of this base patch to allow PINCTRL enablement
for each individual device.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/pinctrl/sh-pfc/Kconfig        |    5 
 drivers/pinctrl/sh-pfc/Makefile       |    1 
 drivers/pinctrl/sh-pfc/core.c         |    9 +
 drivers/pinctrl/sh-pfc/core.h         |    1 
 drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  166 +++++++++++++++++++++++++++++++++
 5 files changed, 182 insertions(+)

--- 0001/drivers/pinctrl/sh-pfc/Kconfig
+++ work/drivers/pinctrl/sh-pfc/Kconfig	2013-11-27 15:18:31.000000000 +0900
@@ -20,6 +20,11 @@ config GPIO_SH_PFC
 	  This enables support for GPIOs within the SoC's pin function
 	  controller.
 
+config PINCTRL_PFC_R7S72100
+	def_bool y
+	depends on ARCH_R7S72100
+	select PINCTRL_SH_PFC
+
 config PINCTRL_PFC_R8A73A4
 	def_bool y
 	depends on ARCH_R8A73A4
--- 0001/drivers/pinctrl/sh-pfc/Makefile
+++ work/drivers/pinctrl/sh-pfc/Makefile	2013-11-27 15:18:31.000000000 +0900
@@ -3,6 +3,7 @@ ifeq ($(CONFIG_GPIO_SH_PFC),y)
 sh-pfc-objs			+= gpio.o
 endif
 obj-$(CONFIG_PINCTRL_SH_PFC)	+= sh-pfc.o
+obj-$(CONFIG_PINCTRL_PFC_R7S72100)	+= pfc-r7s72100.o
 obj-$(CONFIG_PINCTRL_PFC_R8A73A4)	+= pfc-r8a73a4.o
 obj-$(CONFIG_PINCTRL_PFC_R8A7740)	+= pfc-r8a7740.o
 obj-$(CONFIG_PINCTRL_PFC_R8A7778)	+= pfc-r8a7778.o
--- 0001/drivers/pinctrl/sh-pfc/core.c
+++ work/drivers/pinctrl/sh-pfc/core.c	2013-11-27 15:18:31.000000000 +0900
@@ -401,6 +401,12 @@ static int sh_pfc_init_ranges(struct sh_
 
 #ifdef CONFIG_OF
 static const struct of_device_id sh_pfc_of_table[] = {
+#ifdef CONFIG_PINCTRL_PFC_R7S72100
+	{
+		.compatible = "renesas,pfc-r7s72100",
+		.data = &r7s72100_pinmux_info,
+	},
+#endif
 #ifdef CONFIG_PINCTRL_PFC_R8A73A4
 	{
 		.compatible = "renesas,pfc-r8a73a4",
@@ -549,6 +555,9 @@ static int sh_pfc_remove(struct platform
 }
 
 static const struct platform_device_id sh_pfc_id_table[] = {
+#ifdef CONFIG_PINCTRL_PFC_R7S72100
+	{ "pfc-r7s72100", (kernel_ulong_t)&r7s72100_pinmux_info },
+#endif
 #ifdef CONFIG_PINCTRL_PFC_R8A73A4
 	{ "pfc-r8a73a4", (kernel_ulong_t)&r8a73a4_pinmux_info },
 #endif
--- 0001/drivers/pinctrl/sh-pfc/core.h
+++ work/drivers/pinctrl/sh-pfc/core.h	2013-11-27 15:18:31.000000000 +0900
@@ -64,6 +64,7 @@ void sh_pfc_write_raw_reg(void __iomem *
 int sh_pfc_get_pin_index(struct sh_pfc *pfc, unsigned int pin);
 int sh_pfc_config_mux(struct sh_pfc *pfc, unsigned mark, int pinmux_type);
 
+extern const struct sh_pfc_soc_info r7s72100_pinmux_info;
 extern const struct sh_pfc_soc_info r8a73a4_pinmux_info;
 extern const struct sh_pfc_soc_info r8a7740_pinmux_info;
 extern const struct sh_pfc_soc_info r8a7778_pinmux_info;
--- /dev/null
+++ work/drivers/pinctrl/sh-pfc/pfc-r7s72100.c	2013-11-27 15:20:28.000000000 +0900
@@ -0,0 +1,166 @@
+/*
+ * R7S72100 processor support
+ *
+ * Copyright (C) 2013  Renesas Electronics Corporation
+ * Copyright (C) 2013  Magnus Damm
+ * Copyright (C) 2012  Renesas Solutions Corp.
+ * Copyright (C) 2012  Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ */
+
+#include <linux/kernel.h>
+
+#include "core.h"
+#include "sh_pfc.h"
+
+#define RZ_PORT_PIN(bank, pin) (((bank) * 16) + (pin))
+
+#define PORT_P_1(bank, pin, fn, sfx) fn(bank, pin, P_##bank##_##pin, sfx)
+
+#define PORT_P_16(bank, fn, sfx)					\
+	PORT_P_1(bank, 0,  fn, sfx), PORT_P_1(bank, 1,  fn, sfx),	\
+	PORT_P_1(bank, 2,  fn, sfx), PORT_P_1(bank, 3,  fn, sfx),	\
+	PORT_P_1(bank, 4,  fn, sfx), PORT_P_1(bank, 5,  fn, sfx),	\
+	PORT_P_1(bank, 6,  fn, sfx), PORT_P_1(bank, 7,  fn, sfx),	\
+	PORT_P_1(bank, 8,  fn, sfx), PORT_P_1(bank, 9,  fn, sfx),	\
+	PORT_P_1(bank, 10, fn, sfx), PORT_P_1(bank, 11, fn, sfx),	\
+	PORT_P_1(bank, 12, fn, sfx), PORT_P_1(bank, 13, fn, sfx),	\
+	PORT_P_1(bank, 14, fn, sfx), PORT_P_1(bank, 15, fn, sfx)
+
+#define CPU_ALL_PORT(fn, sfx)						\
+	PORT_P_16(0, fn, sfx), PORT_P_16(1, fn, sfx),			\
+	PORT_P_16(2, fn, sfx), PORT_P_16(3, fn, sfx),			\
+	PORT_P_16(4, fn, sfx), PORT_P_16(5, fn, sfx),			\
+	PORT_P_16(6, fn, sfx), PORT_P_16(7, fn, sfx),			\
+	PORT_P_16(8, fn, sfx), PORT_P_16(9, fn, sfx),			\
+	PORT_P_16(10, fn, sfx), PORT_P_16(11, fn, sfx),			\
+	PORT_P_16(12, fn, sfx)
+
+#define P_ALL(n) GP_ALL(n)
+
+enum {
+	PINMUX_RESERVED = 0,
+
+	PINMUX_DATA_BEGIN,
+	P_ALL(DATA),
+	PINMUX_DATA_END,
+
+	PINMUX_FUNCTION_BEGIN,
+	P_ALL(PMC_0), P_ALL(PMC_1),
+	P_ALL(PFC_0), P_ALL(PFC_1),
+	P_ALL(PFCE_0), P_ALL(PFCE_1),
+	P_ALL(PFCAE_0), P_ALL(PFCAE_1),
+	P_ALL(PIBC_0), P_ALL(PIBC_1),
+	P_ALL(PBDC_0), P_ALL(PBDC_1),
+	P_ALL(PIPC_0), P_ALL(PIPC_1),
+	PINMUX_FUNCTION_END,
+
+	PINMUX_MARK_BEGIN,
+	P_ALL(MARK_FN1), P_ALL(MARK_FN2), P_ALL(MARK_FN3), P_ALL(MARK_FN4),
+	P_ALL(MARK_FN5), P_ALL(MARK_FN6), P_ALL(MARK_FN7), P_ALL(MARK_FN8),
+	PINMUX_MARK_END,
+};
+
+#define _P_ALL(n) CPU_ALL_PORT(n, unused)
+
+#define _P_GPIO(bank, _pin, _name, sfx)					\
+	[(bank * 16) + _pin] = {					\
+		.pin = (bank * 16) + _pin,				\
+		.name = __stringify(_name),				\
+		.enum_id = _name##_DATA,				\
+	}
+
+#define _P_DATA(bank, pin, name, sfx)					\
+	PINMUX_DATA(name##_DATA, name##_PMC_0,				\
+		    name##_PIBC_1, name##_PBDC_1)
+
+#define _P_FN(n, fn, pfcae, pfce, pfc)					\
+	PINMUX_DATA(n##_MARK_FN##fn, n##_PMC_1,				\
+		    n##_PFCAE_##pfcae, n##_PFCE_##pfce, n##_PFC_##pfc)
+
+#define _P_MARK_FN1(bank, pin, name, sfx) _P_FN(name, 1, 0, 0, 0)
+#define _P_MARK_FN2(bank, pin, name, sfx) _P_FN(name, 2, 0, 0, 1)
+#define _P_MARK_FN3(bank, pin, name, sfx) _P_FN(name, 3, 0, 1, 0)
+#define _P_MARK_FN4(bank, pin, name, sfx) _P_FN(name, 4, 0, 1, 1)
+#define _P_MARK_FN5(bank, pin, name, sfx) _P_FN(name, 5, 1, 0, 0)
+#define _P_MARK_FN6(bank, pin, name, sfx) _P_FN(name, 6, 1, 0, 1)
+#define _P_MARK_FN7(bank, pin, name, sfx) _P_FN(name, 7, 1, 1, 0)
+#define _P_MARK_FN8(bank, pin, name, sfx) _P_FN(name, 8, 1, 1, 1)
+
+static const u16 pinmux_data[] = {
+	_P_ALL(_P_DATA), /* PINMUX_DATA(P_M_N_DATA, P_M_N_PMC_0), */
+	_P_ALL(_P_MARK_FN1), _P_ALL(_P_MARK_FN2),
+	_P_ALL(_P_MARK_FN3), _P_ALL(_P_MARK_FN4),
+	_P_ALL(_P_MARK_FN5), _P_ALL(_P_MARK_FN6),
+	_P_ALL(_P_MARK_FN7), _P_ALL(_P_MARK_FN8),
+};
+
+static struct sh_pfc_pin pinmux_pins[] = {
+	_P_ALL(_P_GPIO),
+};
+
+static const struct sh_pfc_pin_group pinmux_groups[] = {
+};
+
+static const struct sh_pfc_function pinmux_functions[] = {
+};
+
+#define PFC_REG(idx, name, reg)						\
+	{ PINMUX_CFG_REG(__stringify(name), reg, 16, 1) {		\
+		P_##idx##_15_##name##_0, P_##idx##_15_##name##_1,	\
+		P_##idx##_14_##name##_0, P_##idx##_14_##name##_1,	\
+		P_##idx##_13_##name##_0, P_##idx##_13_##name##_1,	\
+		P_##idx##_12_##name##_0, P_##idx##_12_##name##_1,	\
+		P_##idx##_11_##name##_0, P_##idx##_11_##name##_1,	\
+		P_##idx##_10_##name##_0, P_##idx##_10_##name##_1,	\
+		P_##idx##_9_##name##_0, P_##idx##_9_##name##_1,		\
+		P_##idx##_8_##name##_0, P_##idx##_8_##name##_1,		\
+		P_##idx##_7_##name##_0, P_##idx##_7_##name##_1,		\
+		P_##idx##_6_##name##_0, P_##idx##_6_##name##_1,		\
+		P_##idx##_5_##name##_0, P_##idx##_5_##name##_1,		\
+		P_##idx##_4_##name##_0, P_##idx##_4_##name##_1,		\
+		P_##idx##_3_##name##_0, P_##idx##_3_##name##_1,		\
+		P_##idx##_2_##name##_0, P_##idx##_2_##name##_1,		\
+		P_##idx##_1_##name##_0, P_##idx##_1_##name##_1,		\
+		P_##idx##_0_##name##_0, P_##idx##_0_##name##_1 }	\
+	}
+
+#define PFC_REGS(idx)						\
+	PFC_REG(idx, PMC, (0xfcfe3400 + (idx * 4))),		\
+	PFC_REG(idx, PFC, (0xfcfe3500 + (idx * 4))),		\
+	PFC_REG(idx, PFCE, (0xfcfe3600 + (idx * 4))),		\
+	PFC_REG(idx, PFCAE, (0xfcfe3a00 + (idx * 4))),		\
+	PFC_REG(idx, PIBC, (0xfcfe7000 + (idx * 4))),		\
+	PFC_REG(idx, PBDC, (0xfcfe7100 + (idx * 4))),		\
+	PFC_REG(idx, PIPC, (0xfcfe7200 + (idx * 4)))
+
+static struct pinmux_cfg_reg pinmux_config_regs[] = {
+	PFC_REGS(0), PFC_REGS(1), PFC_REGS(2), PFC_REGS(3),
+	PFC_REGS(4), PFC_REGS(5), PFC_REGS(6), PFC_REGS(7),
+	PFC_REGS(8), PFC_REGS(9), PFC_REGS(10), PFC_REGS(11),
+	PFC_REG(12, PMC, 0xfcfe7b40),
+	PFC_REG(12, PIBC, 0xfcfe7f00),
+	{ },
+};
+
+const struct sh_pfc_soc_info r7s72100_pinmux_info = {
+	.name = "r7s72100_pfc",
+
+	.function = { PINMUX_FUNCTION_BEGIN, PINMUX_FUNCTION_END },
+
+	.pins = pinmux_pins,
+	.nr_pins = ARRAY_SIZE(pinmux_pins),
+	.groups = pinmux_groups,
+	.nr_groups = ARRAY_SIZE(pinmux_groups),
+	.functions = pinmux_functions,
+	.nr_functions = ARRAY_SIZE(pinmux_functions),
+
+	.cfg_regs = pinmux_config_regs,
+
+	.gpio_data = pinmux_data,
+	.gpio_data_size = ARRAY_SIZE(pinmux_data),
+};
