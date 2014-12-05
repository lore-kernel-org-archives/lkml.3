Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbaLEEMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:12:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45442 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933525AbaLEEME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:12:04 -0500
X-Listener-Flag: 11101
From: Flora Fu <flora.fu@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Flora Fu <flora.fu@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>
Subject: [PATCH v3 1/8] soc: mediatek: Add PMIC wrapper for MT8135 and MT6397 SoC
Date: Fri, 5 Dec 2014 12:07:52 +0800
Message-ID: <1417752479-4749-2-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
References: <1417752479-4749-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PMIC wrapper of MT8135 to access MT6397 MFD.

Signed-off-by: Flora Fu <flora.fu@mediatek.com>
---
 drivers/soc/Kconfig                        |   1 +
 drivers/soc/Makefile                       |   1 +
 drivers/soc/mediatek/Kconfig               |  12 +
 drivers/soc/mediatek/Makefile              |   1 +
 drivers/soc/mediatek/mt8135-pmic-wrap.c    | 844 +++++++++++++++++++++++++++++
 drivers/soc/mediatek/mt8135-pmic-wrap.h    | 138 +++++
 include/linux/soc/mediatek/mtk-pmic-wrap.h |  25 +
 7 files changed, 1022 insertions(+)
 create mode 100644 drivers/soc/mediatek/Kconfig
 create mode 100644 drivers/soc/mediatek/Makefile
 create mode 100644 drivers/soc/mediatek/mt8135-pmic-wrap.c
 create mode 100644 drivers/soc/mediatek/mt8135-pmic-wrap.h
 create mode 100644 include/linux/soc/mediatek/mtk-pmic-wrap.h

diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 76d6bd4..d8bde82 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -1,5 +1,6 @@
 menu "SOC (System On Chip) specific Drivers"
 
+source "drivers/soc/mediatek/Kconfig"
 source "drivers/soc/qcom/Kconfig"
 source "drivers/soc/ti/Kconfig"
 source "drivers/soc/versatile/Kconfig"
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
index 063113d..70042b2 100644
--- a/drivers/soc/Makefile
+++ b/drivers/soc/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the Linux Kernel SOC specific device drivers.
 #
 
+obj-$(CONFIG_ARCH_MEDIATEK)	+= mediatek/
 obj-$(CONFIG_ARCH_QCOM)		+= qcom/
 obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
 obj-$(CONFIG_SOC_TI)		+= ti/
diff --git a/drivers/soc/mediatek/Kconfig b/drivers/soc/mediatek/Kconfig
new file mode 100644
index 0000000..746e030
--- /dev/null
+++ b/drivers/soc/mediatek/Kconfig
@@ -0,0 +1,12 @@
+#
+# MediaTek SoC drivers
+#
+config MT8135_PMIC_WRAP
+	tristate "MediaTek MT8135 PMIC Wrapper Support"
+	depends on ARCH_MEDIATEK
+	select REGMAP
+	help
+	  Say yes here to add support for MediaTek MT8135 PMIC Wrapper.
+	  PMIC wrapper is a proprietary hardware in MT8135 to make
+	  communication protocols to access PMIC device.
+	  This driver implement access protocols for MT8135.
diff --git a/drivers/soc/mediatek/Makefile b/drivers/soc/mediatek/Makefile
new file mode 100644
index 0000000..49b9588
--- /dev/null
+++ b/drivers/soc/mediatek/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_MT8135_PMIC_WRAP)		+= mt8135-pmic-wrap.o
diff --git a/drivers/soc/mediatek/mt8135-pmic-wrap.c b/drivers/soc/mediatek/mt8135-pmic-wrap.c
new file mode 100644
index 0000000..75aa28e
--- /dev/null
+++ b/drivers/soc/mediatek/mt8135-pmic-wrap.c
@@ -0,0 +1,844 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <linux/mfd/mt6397/registers.h>
+#include <linux/soc/mediatek/mtk-pmic-wrap.h>
+#include "mt8135-pmic-wrap.h"
+
+/* macro for wrapper status */
+#define PWRAP_GET_WACS0_WDATA(x)	(((x) >> 0) & 0x0000ffff)
+#define PWRAP_GET_WACS0_ADR(x)		(((x) >> 16) & 0x00007fff)
+#define PWRAP_GET_WACS0_WRITE(x)	(((x) >> 31) & 0x00000001)
+#define PWRAP_GET_WACS0_RDATA(x)	(((x) >> 0) & 0x0000ffff)
+#define PWRAP_GET_WACS0_FSM(x)		(((x) >> 16) & 0x00000007)
+#define PWRAP_STATE_SYNC_IDLE0		(1 << 20)
+#define PWRAP_STATE_INIT_DONE0		(1 << 21)
+
+/* macro for WACS FSM */
+#define PWRAP_WACS_FSM_IDLE		0x00
+#define PWRAP_WACS_FSM_REQ		0x02
+#define PWRAP_WACS_FSM_WFDLE		0x04
+#define PWRAP_WACS_FSM_WFVLDCLR		0x06
+#define PWRAP_WACS_INIT_DONE		0x01
+#define PWRAP_WACS_WACS_SYNC_IDLE	0x01
+
+/* macro for device wrapper default value */
+#define PWRAP_DEW_READ_TEST_VAL		0x5aa5
+#define PWRAP_DEW_WRITE_TEST_VAL	0xa55a
+
+/* macro for manual command */
+#define PWRAP_OP_WR			0x1
+#define PWRAP_OP_RD			0x0
+#define PWRAP_OP_CSH			0x0
+#define PWRAP_OP_CSL			0x1
+#define PWRAP_OP_OUTS			0x8
+#define PWRAP_OP_OUTD			0x9
+#define PWRAP_OP_OUTQ			0xA
+
+static bool is_fsm_idle(u32 x)
+{
+	return PWRAP_GET_WACS0_FSM(x) == PWRAP_WACS_FSM_IDLE;
+}
+
+static bool is_fsm_vldclr(u32 x)
+{
+	return PWRAP_GET_WACS0_FSM(x) == PWRAP_WACS_FSM_WFVLDCLR;
+}
+
+static bool is_sync_idle(u32 x)
+{
+	return x & PWRAP_STATE_SYNC_IDLE0;
+}
+
+static bool is_fsm_idle_and_sync_idle(u32 x)
+{
+	return (PWRAP_GET_WACS0_FSM(x) == PWRAP_WACS_FSM_IDLE) &&
+	 (x & PWRAP_STATE_SYNC_IDLE0);
+}
+
+static bool is_cipher_ready(u32 x)
+{
+	return x == 1;
+}
+
+static int wait_for_state_ready(
+	struct pmic_wrapper *wrp, bool (*fp)(u32),
+	void *wacs_register, void *wacs_vldclr_register, u32 *read_reg)
+{
+	u32 reg_rdata;
+	unsigned long timeout;
+	int timeout_retry = 0;
+	struct device *dev = &wrp->pdev->dev;
+
+	timeout = jiffies + usecs_to_jiffies(255);
+	do {
+		reg_rdata = readl(wacs_register);
+		if (time_after(jiffies, timeout)) {
+			if (timeout_retry) {
+				dev_err(dev, "timeout when waiting for idle\n");
+				return -ETIMEDOUT;
+			}
+			timeout_retry = 1;
+		}
+	} while (!fp(reg_rdata));
+
+	if (read_reg)
+		*read_reg = reg_rdata;
+
+	return 0;
+}
+
+static int pwrap_write(struct pmic_wrapper *wrp, u32 adr, u32 wdata)
+{
+	u32 wacs_cmd;
+	int ret;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	ret = wait_for_state_ready(wrp, is_fsm_idle,
+		pwrap_base + PWRAP_WACS2_RDATA,
+		pwrap_base + PWRAP_WACS2_VLDCLR, 0);
+	if (ret) {
+		dev_err(dev, "%s command fail, ret=%d\n", __func__, ret);
+		return ret;
+	}
+
+	wacs_cmd = (1 << 31) | ((adr >> 1) << 16) | wdata;
+	writel(wacs_cmd, pwrap_base + PWRAP_WACS2_CMD);
+
+	return 0;
+}
+
+static int pwrap_read(struct pmic_wrapper *wrp, u32 adr, u32 *rdata)
+{
+	u32 reg_rdata;
+	u32 wacs_cmd;
+	int ret;
+	u32 rval;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	if (!rdata)
+		return -EINVAL;
+
+	ret = wait_for_state_ready(wrp, is_fsm_idle,
+		pwrap_base + PWRAP_WACS2_RDATA,
+		pwrap_base + PWRAP_WACS2_VLDCLR, 0);
+	if (ret) {
+		dev_err(dev, "%s command fail, ret=%d\n", __func__, ret);
+		return ret;
+	}
+
+	wacs_cmd = (adr >> 1) << 16;
+	writel(wacs_cmd, pwrap_base + PWRAP_WACS2_CMD);
+
+	ret = wait_for_state_ready(wrp, is_fsm_vldclr,
+		pwrap_base + PWRAP_WACS2_RDATA, NULL, &reg_rdata);
+	if (ret) {
+		dev_err(dev, "%s read fail, ret=%d\n", __func__, ret);
+		return ret;
+	}
+	rval = PWRAP_GET_WACS0_RDATA(reg_rdata);
+	writel(1, pwrap_base + PWRAP_WACS2_VLDCLR);
+	*rdata = rval;
+
+	return 0;
+}
+
+static int pwrap_regmap_read(void *context, u32 adr, u32 *rdata)
+{
+	u32 reg_rdata;
+
+	struct pmic_wrapper *wrp = context;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+
+	reg_rdata = readl(pwrap_base + PWRAP_WACS2_RDATA);
+	if (PWRAP_GET_WACS0_FSM(reg_rdata) == PWRAP_WACS_FSM_WFVLDCLR)
+		writel(1, pwrap_base + PWRAP_WACS2_VLDCLR);
+
+	return pwrap_read(wrp, adr, rdata);
+}
+
+static int pwrap_regmap_write(void *context, u32 adr, u32 wdata)
+{
+	u32 reg_rdata;
+
+	struct pmic_wrapper *wrp = context;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+
+	reg_rdata = readl(pwrap_base + PWRAP_WACS2_RDATA);
+	if (PWRAP_GET_WACS0_FSM(reg_rdata) == PWRAP_WACS_FSM_WFVLDCLR)
+		writel(1, pwrap_base + PWRAP_WACS2_VLDCLR);
+
+	return pwrap_write(wrp, adr, wdata);
+}
+
+static int pwrap_reset(struct pmic_wrapper *wrp)
+{
+	int ret;
+	struct reset_control *rstc_infracfg, *rstc_pericfg;
+	struct device *dev = &wrp->pdev->dev;
+
+	rstc_infracfg = devm_reset_control_get(dev, "infra-pwrap-rst");
+	if (IS_ERR(rstc_infracfg)) {
+		ret = PTR_ERR(rstc_infracfg);
+		dev_err(dev, "get pwrap-rst failed=%d\n", ret);
+		return ret;
+	}
+	rstc_pericfg = devm_reset_control_get(dev, "peri-pwrap-bridge-rst");
+	if (IS_ERR(rstc_pericfg)) {
+		ret = PTR_ERR(rstc_pericfg);
+		dev_err(dev, "get peri-pwrap-bridge-rst failed=%d\n", ret);
+		return ret;
+	}
+
+	reset_control_assert(rstc_infracfg);
+	reset_control_assert(rstc_pericfg);
+	reset_control_deassert(rstc_infracfg);
+	reset_control_deassert(rstc_pericfg);
+
+	return 0;
+}
+
+static int pwrap_set_clock(struct pmic_wrapper *wrp)
+{
+	int ret;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+	struct clk *pmicspi;
+	struct clk *pmicspi_parent;
+
+	pmicspi = devm_clk_get(dev, "pmicspi-sel");
+	if (IS_ERR(pmicspi)) {
+		ret = PTR_ERR(pmicspi);
+		dev_err(dev, "pmicspi-sel fail ret=%d\n", ret);
+		return ret;
+	}
+	pmicspi_parent = devm_clk_get(dev, "pmicspi-parent");
+	if (IS_ERR(pmicspi_parent)) {
+		ret = PTR_ERR(pmicspi_parent);
+		dev_err(dev, "pmicspi-parent fail ret=%d\n", ret);
+		return ret;
+	}
+
+	/* Note: HW design, enable clock mux and then switch to new source. */
+	ret = clk_set_parent(pmicspi, pmicspi_parent);
+	if (ret) {
+		dev_err(dev, "prepare pmicspi clock fail, ret=%d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(pmicspi);
+	if (ret) {
+		dev_err(dev, "prepare pmicspi clock fail, ret=%d\n", ret);
+		return ret;
+	}
+
+	/* Enable internal dynamic clock */
+	writel(1, pwrap_base + PWRAP_DCM_EN);
+	writel(0, pwrap_base + PWRAP_DCM_DBC_PRD);
+
+	return 0;
+}
+
+static int pwrap_reset_spislv(struct pmic_wrapper *wrp)
+{
+	int ret, i;
+	u32 cmd;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	writel(0, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	writel(0, pwrap_base + PWRAP_WRAP_EN);
+	writel(1, pwrap_base + PWRAP_MUX_SEL);
+	writel(1, pwrap_base + PWRAP_MAN_EN);
+	writel(0, pwrap_base + PWRAP_DIO_EN);
+
+	cmd = (PWRAP_OP_WR << 13) | (PWRAP_OP_CSL << 8);
+	writel(cmd, pwrap_base + PWRAP_MAN_CMD);
+
+	cmd = (PWRAP_OP_WR << 13) | (PWRAP_OP_OUTS << 8);
+	writel(cmd, pwrap_base + PWRAP_MAN_CMD);
+
+	cmd = (PWRAP_OP_WR << 13) | (PWRAP_OP_CSH << 8);
+	writel(cmd, pwrap_base + PWRAP_MAN_CMD);
+
+	for (i = 0; i < 4; i++) {
+		cmd = (PWRAP_OP_WR << 13) | (PWRAP_OP_OUTS << 8);
+		writel(cmd, pwrap_base + PWRAP_MAN_CMD);
+	}
+	ret = wait_for_state_ready(wrp, is_sync_idle,
+	pwrap_base + PWRAP_WACS2_RDATA, NULL, 0);
+	if (ret)
+		dev_err(dev, "%s fail, ret=%d\n", __func__, ret);
+
+	writel(0, pwrap_base + PWRAP_MAN_EN);
+	writel(0, pwrap_base + PWRAP_MUX_SEL);
+
+	return 0;
+}
+
+static int pwrap_init_sidly(struct pmic_wrapper *wrp)
+{
+	u32 arb_en_backup;
+	u32 rdata;
+	u32 ind;
+	u32 result;
+	u32 sidly;
+	bool failed = false;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	/* Enable WACS2 to do read test on bus */
+	writel(1, pwrap_base + PWRAP_WRAP_EN);
+	writel(0x8, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	writel(1, pwrap_base + PWRAP_WACS2_EN);
+	arb_en_backup = readl(pwrap_base + PWRAP_HIPRIO_ARB_EN);
+
+	/* Scan all SIDLY by Read Test */
+	result = 0;
+	for (ind = 0; ind < 4; ind++) {
+		writel(ind, wrp->pwrap_base + PWRAP_SIDLY);
+		pwrap_read(wrp, PWRAP_DEW_READ_TEST, &rdata);
+		if (rdata == PWRAP_DEW_READ_TEST_VAL) {
+			dev_info(dev, "[Read Test] pass, SIDLY=%x\n", ind);
+			result |= (0x1 << ind);
+		}
+	}
+
+	/* Config SIDLY according to results */
+	switch (result) {
+	/* only 1 pass, choose it */
+	case 0x1:
+		sidly = 0;
+		break;
+	case 0x2:
+		sidly = 1;
+		break;
+	case 0x4:
+		sidly = 2;
+		break;
+	case 0x8:
+		sidly = 3;
+		break;
+		/* two pass, choose the one on SIDLY boundary */
+	case 0x3:
+		sidly = 0;
+		break;
+	case 0x6: /* no boundary, choose smaller one */
+		sidly = 1;
+		break;
+	case 0xc:
+		sidly = 3;
+		break;
+		/* three pass, choose the middle one */
+	case 0x7:
+		sidly = 1;
+		break;
+	case 0xe:
+		sidly = 2;
+		break;
+		/* four pass, choose the smaller middle one */
+	case 0xf:
+		sidly = 1;
+		break;
+		/* pass range not continuous, should not happen */
+	default:
+		sidly = 0;
+		failed = true;
+		break;
+	}
+	writel(sidly, pwrap_base + PWRAP_SIDLY);
+	writel(arb_en_backup, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	if (!failed)
+		return 0;
+
+	dev_err(dev, "%s fail, result=%x\n", __func__, result);
+
+	return -EIO;
+}
+
+static int pwrap_init_reg_clock(struct pmic_wrapper *wrp, u32 regck_sel)
+{
+	u32 wdata;
+	u32 rdata;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	pwrap_read(wrp, MT6397_TOP_CKCON2, &rdata);
+	wdata = rdata & (~(0x3 << 10));
+	if (regck_sel == 1)
+		wdata |= (0x1 << 10);
+
+	if (pwrap_write(wrp, MT6397_TOP_CKCON2, wdata))  {
+		dev_err(dev, "Enable PMIC TOP_CKCON2 fail\n");
+		return -EFAULT;
+	}
+	switch (regck_sel) {
+	case 1:
+		writel(0xc, pwrap_base + PWRAP_CSHEXT);
+		writel(0x4, pwrap_base + PWRAP_CSHEXT_WRITE);
+		writel(0xc, pwrap_base + PWRAP_CSHEXT_READ);
+		writel(0x0, pwrap_base + PWRAP_CSLEXT_START);
+		writel(0x0, pwrap_base + PWRAP_CSLEXT_END);
+		break;
+	case 2:
+		writel(0x4, pwrap_base + PWRAP_CSHEXT);
+		writel(0x0, pwrap_base + PWRAP_CSHEXT_WRITE);
+		writel(0x4, pwrap_base + PWRAP_CSHEXT_READ);
+		writel(0x0, pwrap_base + PWRAP_CSLEXT_START);
+		writel(0x0, pwrap_base + PWRAP_CSLEXT_END);
+		break;
+	default:
+		writel(0xf, pwrap_base + PWRAP_CSHEXT);
+		writel(0xf, pwrap_base + PWRAP_CSHEXT_WRITE);
+		writel(0xf, pwrap_base + PWRAP_CSHEXT_READ);
+		writel(0xf, pwrap_base + PWRAP_CSLEXT_START);
+		writel(0xf, pwrap_base + PWRAP_CSLEXT_END);
+		break;
+	}
+
+	/* Enable PMIC side reg clock */
+	if (pwrap_write(wrp, MT6397_WRP_CKPDN, 0) ||
+		pwrap_write(wrp, MT6397_WRP_RST_CON, 0)) {
+		dev_err(dev, "Enable PMIC fail\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int pwrap_init_dio(struct pmic_wrapper *wrp, u32 dio_en)
+{
+	u32 arb_en_backup;
+	u32 rdata;
+	int ret;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	arb_en_backup = readl(pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	writel(0x8, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	pwrap_write(wrp, PWRAP_DEW_DIO_EN, dio_en);
+
+	/* Check IDLE & INIT_DONE in advance */
+	ret = wait_for_state_ready(wrp, is_fsm_idle_and_sync_idle,
+		pwrap_base + PWRAP_WACS2_RDATA, NULL, 0);
+	if (ret) {
+		dev_err(dev, "%s fail, ret=%d\n", __func__, ret);
+		return ret;
+	}
+	writel(dio_en, pwrap_base + PWRAP_DIO_EN);
+
+	/* Read Test */
+	pwrap_read(wrp, PWRAP_DEW_READ_TEST, &rdata);
+	if (rdata != PWRAP_DEW_READ_TEST_VAL) {
+		dev_err(dev, "DIO Test Fail en=%x, rdata=%x\n", dio_en, rdata);
+		return -EFAULT;
+	}
+
+	writel(arb_en_backup, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	return 0;
+}
+
+static int pwrap_init_cipher(struct pmic_wrapper *wrp)
+{
+	int ret;
+	u32 arb_en_backup;
+	u32 rdata;
+	unsigned long timeout;
+	int timeout_retry = 0;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	arb_en_backup = readl(pwrap_base + PWRAP_HIPRIO_ARB_EN);
+
+	writel(0x8, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	writel(1, pwrap_base + PWRAP_CIPHER_SWRST);
+	writel(0, pwrap_base + PWRAP_CIPHER_SWRST);
+	writel(1, pwrap_base + PWRAP_CIPHER_KEY_SEL);
+	writel(2, pwrap_base + PWRAP_CIPHER_IV_SEL);
+	writel(1, pwrap_base + PWRAP_CIPHER_LOAD);
+	writel(1, pwrap_base + PWRAP_CIPHER_START);
+
+	/* Config cipher mode @PMIC */
+	pwrap_write(wrp, PWRAP_DEW_CIPHER_SWRST, 0x1);
+	pwrap_write(wrp, PWRAP_DEW_CIPHER_SWRST, 0x0);
+	pwrap_write(wrp, PWRAP_DEW_CIPHER_KEY_SEL, 0x1);
+	pwrap_write(wrp, PWRAP_DEW_CIPHER_IV_SEL, 0x2);
+	pwrap_write(wrp, PWRAP_DEW_CIPHER_LOAD, 0x1);
+	pwrap_write(wrp, PWRAP_DEW_CIPHER_START, 0x1);
+
+	/* wait for cipher data ready@AP */
+	ret = wait_for_state_ready(wrp, is_cipher_ready,
+		pwrap_base + PWRAP_CIPHER_RDY, NULL, 0);
+	if (ret) {
+		dev_err(dev, "cipher data ready@AP fail, ret=%d\n", ret);
+		return ret;
+	}
+
+	/* wait for cipher data ready@PMIC */
+	timeout = jiffies + usecs_to_jiffies(255);
+	do {
+		pwrap_read(wrp, PWRAP_DEW_CIPHER_RDY, &rdata);
+		if (time_after(jiffies, timeout)) {
+			if (timeout_retry) {
+				dev_err(dev, "timeout when waiting for idle\n");
+				return -ETIMEDOUT;
+			}
+			timeout_retry = 1;
+		}
+	} while (rdata != 0x1);
+
+	/* wait for cipher mode idle */
+	pwrap_write(wrp, PWRAP_DEW_CIPHER_MODE, 0x1);
+	ret = wait_for_state_ready(wrp, is_fsm_idle_and_sync_idle,
+		pwrap_base + PWRAP_WACS2_RDATA, NULL, 0);
+	if (ret) {
+		dev_err(dev, "cipher mode idle fail, ret=%d\n", ret);
+		return ret;
+	}
+
+	writel(1, pwrap_base + PWRAP_CIPHER_MODE);
+	writel(arb_en_backup, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	/* Write Test */
+	if (pwrap_write(wrp, PWRAP_DEW_WRITE_TEST, PWRAP_DEW_WRITE_TEST_VAL) ||
+	    pwrap_read(wrp, PWRAP_DEW_WRITE_TEST, &rdata) ||
+			(rdata != PWRAP_DEW_WRITE_TEST_VAL)) {
+		dev_err(dev, "rdata=0x%04X\n", rdata);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int pwrap_init_crc(struct pmic_wrapper *wrp)
+{
+	void __iomem *pwrap_base = wrp->pwrap_base;
+
+	if (pwrap_write(wrp, PWRAP_DEW_CRC_EN, 0x1))
+		return -EFAULT;
+
+	writel(0x1, pwrap_base + PWRAP_CRC_EN);
+	writel(0x0, pwrap_base + PWRAP_SIG_MODE);
+	writel(PWRAP_DEW_CRC_VAL, pwrap_base + PWRAP_SIG_ADR);
+
+	return 0;
+}
+
+static int pwrap_enable_wacs(struct pmic_wrapper *wrp)
+{
+	void __iomem *pwrap_base = wrp->pwrap_base;
+
+	writel(0x1ff, pwrap_base + PWRAP_HIPRIO_ARB_EN);
+	writel(0x7, pwrap_base + PWRAP_RRARB_EN);
+	writel(0x1, pwrap_base + PWRAP_WACS0_EN);
+	writel(0x1, pwrap_base + PWRAP_WACS1_EN);
+	writel(0x1, pwrap_base + PWRAP_WACS2_EN);
+	writel(0x5, pwrap_base + PWRAP_STAUPD_PRD);
+	writel(0xff, pwrap_base + PWRAP_STAUPD_GRPEN);
+	writel(0xf, pwrap_base + PWRAP_WDT_UNIT);
+	writel(0xffffffff, pwrap_base + PWRAP_WDT_SRC_EN);
+	writel(0x1, pwrap_base + PWRAP_TIMER_EN);
+	writel(~((1 << 31) | (1 << 1)), pwrap_base + PWRAP_INT_EN);
+
+	return 0;
+}
+
+static int pwrap_enable_event_bridge(struct pmic_wrapper *wrp)
+{
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	void __iomem *pwrap_bridge_base = wrp->pwrap_bridge_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	/* enable pwrap events and pwrap bridge in AP side */
+	writel(0x1, pwrap_base + PWRAP_EVENT_IN_EN);
+	writel(0xffff, pwrap_base + PWRAP_EVENT_DST_EN);
+	writel(0x7f, pwrap_bridge_base + PWRAP_BRIDGE_IORD_ARB_EN);
+	writel(0x1, pwrap_bridge_base + PWRAP_BRIDGE_WACS3_EN);
+	writel(0x1, pwrap_bridge_base + PWRAP_BRIDGE_WACS4_EN);
+	writel(0x1, pwrap_bridge_base + PWRAP_BRIDGE_WDT_UNIT);
+	writel(0xffff, pwrap_bridge_base + PWRAP_BRIDGE_WDT_SRC_EN);
+	writel(0x1, pwrap_bridge_base + PWRAP_BRIDGE_TIMER_EN);
+	writel(0x7ff, pwrap_bridge_base + PWRAP_BRIDGE_INT_EN);
+
+	/* enable PMIC event out and sources */
+	if (pwrap_write(wrp, PWRAP_DEW_EVENT_OUT_EN, 0x1) ||
+	    pwrap_write(wrp, PWRAP_DEW_EVENT_SRC_EN, 0xffff)) {
+		dev_err(dev, "enable dewrap fail\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int pwrap_switch_event_pin(struct pmic_wrapper *wrp)
+{
+	u32 rdata;
+	struct device *dev = &wrp->pdev->dev;
+
+	/* switch event pin from usbdl mode to normal mode @ MT6397 */
+	if (pwrap_read(wrp, MT6397_TOP_CKCON3, &rdata) ||
+	    pwrap_write(wrp, MT6397_TOP_CKCON3, (rdata & 0x0007))) {
+		dev_err(dev, "switch event pin fail\n");
+		return -EFAULT;
+	}
+
+	return 0;
+};
+
+static int pwrap_init_done(struct pmic_wrapper *wrp)
+{
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	void __iomem *pwrap_bridge_base = wrp->pwrap_bridge_base;
+
+	writel(1, pwrap_base + PWRAP_INIT_DONE2);
+	writel(1, pwrap_base + PWRAP_INIT_DONE0);
+	writel(1, pwrap_base + PWRAP_INIT_DONE1);
+	writel(1, pwrap_bridge_base + PWRAP_BRIDGE_INIT_DONE3);
+	writel(1, pwrap_bridge_base + PWRAP_BRIDGE_INIT_DONE4);
+
+	return 0;
+}
+
+static int pwrap_init(struct pmic_wrapper *wrp)
+{
+	int ret;
+
+	/* Reset pwrap and pwrap bridge in infracfg and perifcfg. */
+	ret = pwrap_reset(wrp);
+	if (ret)
+		return ret;
+
+	/* Set SPI_CK frequency = 26MHz */
+	ret = pwrap_set_clock(wrp);
+	if (ret)
+		return ret;
+
+	/* Reset SPI slave */
+	ret = pwrap_reset_spislv(wrp);
+	if (ret)
+		return ret;
+
+	/* Setup serial input delay */
+	ret = pwrap_init_sidly(wrp);
+	if (ret)
+		return ret;
+
+	/* SPI Waveform Configuration 0:safe mode, 1:18MHz, 2:26MHz */
+	ret = pwrap_init_reg_clock(wrp, 2);
+	if (ret)
+		return ret;
+
+	/* Enable dual IO mode */
+	ret = pwrap_init_dio(wrp, 1);
+	if (ret)
+		return ret;
+
+	/* Enable encryption */
+	ret = pwrap_init_cipher(wrp);
+	if (ret)
+		return ret;
+
+	/* Signature checking - using CRC */
+	ret = pwrap_init_crc(wrp);
+	if (ret)
+		return ret;
+
+	/* Enable all wrapper access */
+	ret = pwrap_enable_wacs(wrp);
+	if (ret)
+		return ret;
+
+	 /* Switch event pin from usbdl mode to normal mode */
+	ret = pwrap_switch_event_pin(wrp);
+	if (ret)
+		return ret;
+
+	/* Enable evnts and pwrap bridge */
+	ret = pwrap_enable_event_bridge(wrp);
+	if (ret)
+		return ret;
+
+	/* Setup the init done registers */
+	ret = pwrap_init_done(wrp);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int pwrap_iomap_init(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct pmic_wrapper *wrp = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pwrap-base");
+	if (!res) {
+		dev_err(dev, "could not get pwrap-base resource\n");
+		return -ENODEV;
+	}
+	wrp->pwrap_base = devm_ioremap(dev, res->start, resource_size(res));
+	if (!wrp->pwrap_base) {
+		dev_err(dev, "could not get pwrap_base\n");
+		return -ENOMEM;
+	}
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+		"pwrap-bridge-base");
+	if (!res) {
+		dev_err(dev, "could not get pwrap-bridge-base resource\n");
+		return -ENODEV;
+	}
+	wrp->pwrap_bridge_base = devm_ioremap(dev, res->start,
+		resource_size(res));
+	if (!wrp->pwrap_bridge_base) {
+		dev_err(dev, "could not get pwrap_bridge_base\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int pwrap_check_and_init(struct pmic_wrapper *wrp)
+{
+	int ret;
+	u32 rdata;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	rdata = readl(pwrap_base + PWRAP_INIT_DONE2);
+	if (rdata)
+		goto done;
+
+	ret = pwrap_init(wrp);
+	if (ret) {
+		dev_err(dev, "PMIC wrapper init error, ret=%d\n", ret);
+		return ret;
+	}
+
+done:
+	rdata = readl(pwrap_base + PWRAP_WACS2_RDATA);
+	if (!(rdata & PWRAP_STATE_INIT_DONE0)) {
+		dev_err(dev, "initialization isn't finished\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static irqreturn_t pwrap_interrupt(int irqno, void *dev_id)
+{
+	u32 rdata;
+	struct pmic_wrapper *wrp = dev_id;
+	void __iomem *pwrap_base = wrp->pwrap_base;
+	struct device *dev = &wrp->pdev->dev;
+
+	rdata = readl(pwrap_base + PWRAP_INT_FLG);
+	dev_err(dev, "unexpected interrupt int=0x%x\n", rdata);
+
+	writel(0x8, pwrap_base + PWRAP_HARB_HPRIO);
+	writel(0xffffffff, pwrap_base + PWRAP_INT_CLR);
+
+	return IRQ_HANDLED;
+}
+
+const struct regmap_config pwrap_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+	.reg_read = pwrap_regmap_read,
+	.reg_write = pwrap_regmap_write,
+};
+
+static int pwrap_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct pmic_wrapper *wrp;
+	int irq;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = pdev->dev.of_node;
+
+	wrp = devm_kzalloc(dev, sizeof(struct pmic_wrapper), GFP_KERNEL);
+	if (!wrp)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, wrp);
+
+	ret = pwrap_iomap_init(pdev);
+	if (ret) {
+		dev_err(dev, "pwrap_iomap_init, ret=%d\n", ret);
+		return ret;
+	}
+
+	wrp->pdev = pdev;
+	ret = pwrap_check_and_init(wrp);
+	if (ret) {
+		dev_err(dev, "PMIC wrapper HW init failed=%d\n", ret);
+		return ret;
+	}
+
+	/* Register pwrap irq to catch interrupt when pwrap behaves abnormal. */
+	irq = platform_get_irq(pdev, 0);
+	ret = devm_request_threaded_irq(dev, irq,
+			pwrap_interrupt, NULL,
+			IRQF_TRIGGER_HIGH, "mt8135-pwrap", wrp);
+	if (ret) {
+		dev_err(dev, "Register IRQ failed, ret=%d\n", ret);
+		return ret;
+	}
+
+	wrp->regmap = devm_regmap_init(dev, NULL, wrp, &pwrap_regmap_config);
+	if (IS_ERR(wrp->regmap)) {
+		ret = PTR_ERR(wrp->regmap);
+		dev_err(dev, "Failed to allocate register map, ret=%d\n",
+			ret);
+		return ret;
+	}
+
+	ret = of_platform_populate(np, NULL, NULL, dev);
+	if (ret) {
+		dev_err(dev, "%s fail to create devices\n", np->full_name);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct of_device_id of_pwrap_match_tbl[] = {
+	{.compatible = "mediatek,mt8135-pwrap",},
+	{}
+};
+MODULE_DEVICE_TABLE(of, of_pwrap_match_tbl);
+
+static struct platform_driver pwrap_drv = {
+	.driver = {
+		.name = "mt8135-pwrap",
+		.of_match_table = of_match_ptr(of_pwrap_match_tbl),
+	},
+	.probe = pwrap_probe,
+};
+
+module_platform_driver(pwrap_drv);
+
+MODULE_AUTHOR("Flora Fu <flora.fu@mediatek.com>");
+MODULE_DESCRIPTION("MediaTek MT8135 PMIC Wrapper Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/soc/mediatek/mt8135-pmic-wrap.h b/drivers/soc/mediatek/mt8135-pmic-wrap.h
new file mode 100644
index 0000000..6e79a0a
--- /dev/null
+++ b/drivers/soc/mediatek/mt8135-pmic-wrap.h
@@ -0,0 +1,138 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __PMIC_WRAP_REGS_H__
+#define __PMIC_WRAP_REGS_H__
+
+/* macro for wrapper registers */
+#define PWRAP_MUX_SEL			0x0
+#define PWRAP_WRAP_EN			0x4
+#define PWRAP_DIO_EN			0x8
+#define PWRAP_SIDLY			0xC
+#define PWRAP_CSHEXT			0x10
+#define PWRAP_CSHEXT_WRITE		0x14
+#define PWRAP_CSHEXT_READ		0x18
+#define PWRAP_CSLEXT_START		0x1C
+#define PWRAP_CSLEXT_END		0x20
+#define PWRAP_STAUPD_PRD		0x24
+#define PWRAP_STAUPD_GRPEN		0x28
+#define PWRAP_STAUPD_MAN_TRIG		0x2C
+#define PWRAP_STAUPD_STA		0x30
+#define PWRAP_EVENT_IN_EN		0x34
+#define PWRAP_EVENT_DST_EN		0x38
+#define PWRAP_WRAP_STA			0x3C
+#define PWRAP_RRARB_INIT		0x40
+#define PWRAP_RRARB_EN			0x44
+#define PWRAP_RRARB_STA0		0x48
+#define PWRAP_RRARB_STA1		0x4C
+#define PWRAP_HARB_INIT			0x50
+#define PWRAP_HARB_HPRIO		0x54
+#define PWRAP_HIPRIO_ARB_EN		0x58
+#define PWRAP_HARB_STA0			0x5C
+#define PWRAP_HARB_STA1			0x60
+#define PWRAP_MAN_EN			0x64
+#define PWRAP_MAN_CMD			0x68
+#define PWRAP_MAN_RDATA			0x6C
+#define PWRAP_MAN_VLDCLR		0x70
+#define PWRAP_WACS0_EN			0x74
+#define PWRAP_INIT_DONE0		0x78
+#define PWRAP_WACS0_CMD			0x7C
+#define PWRAP_WACS0_RDATA		0x80
+#define PWRAP_WACS0_VLDCLR		0x84
+#define PWRAP_WACS1_EN			0x88
+#define PWRAP_INIT_DONE1		0x8C
+#define PWRAP_WACS1_CMD			0x90
+#define PWRAP_WACS1_RDATA		0x94
+#define PWRAP_WACS1_VLDCLR		0x98
+#define PWRAP_WACS2_EN			0x9C
+#define PWRAP_INIT_DONE2		0xA0
+#define PWRAP_WACS2_CMD			0xA4
+#define PWRAP_WACS2_RDATA		0xA8
+#define PWRAP_WACS2_VLDCLR		0xAC
+#define PWRAP_INT_EN			0xB0
+#define PWRAP_INT_FLG_RAW		0xB4
+#define PWRAP_INT_FLG			0xB8
+#define PWRAP_INT_CLR			0xBC
+#define PWRAP_SIG_ADR			0xC0
+#define PWRAP_SIG_MODE			0xC4
+#define PWRAP_SIG_VALUE			0xC8
+#define PWRAP_SIG_ERRVAL		0xCC
+#define PWRAP_CRC_EN			0xD0
+#define PWRAP_EVENT_STA			0xD4
+#define PWRAP_EVENT_STACLR		0xD8
+#define PWRAP_TIMER_EN			0xDC
+#define PWRAP_TIMER_STA			0xE0
+#define PWRAP_WDT_UNIT			0xE4
+#define PWRAP_WDT_SRC_EN		0xE8
+#define PWRAP_WDT_FLG			0xEC
+#define PWRAP_DEBUG_INT_SEL		0xF0
+#define PWRAP_CIPHER_KEY_SEL		0x134
+#define PWRAP_CIPHER_IV_SEL		0x138
+#define PWRAP_CIPHER_LOAD		0x13C
+#define PWRAP_CIPHER_START		0x140
+#define PWRAP_CIPHER_RDY		0x144
+#define PWRAP_CIPHER_MODE		0x148
+#define PWRAP_CIPHER_SWRST		0x14C
+#define PWRAP_DCM_EN			0x15C
+#define PWRAP_DCM_DBC_PRD		0x160
+
+/* macro for wrapper bridge registers */
+#define PWRAP_BRIDGE_IARB_INIT		0x0
+#define PWRAP_BRIDGE_IORD_ARB_EN	0x4
+#define PWRAP_BRIDGE_IARB_STA0		0x8
+#define PWRAP_BRIDGE_IARB_STA1		0xC
+#define PWRAP_BRIDGE_WACS3_EN		0x10
+#define PWRAP_BRIDGE_INIT_DONE3		0x14
+#define PWRAP_BRIDGE_WACS3_CMD		0x18
+#define PWRAP_BRIDGE_WACS3_RDATA	0x1C
+#define PWRAP_BRIDGE_WACS3_VLDCLR	0x20
+#define PWRAP_BRIDGE_WACS4_EN		0x24
+#define PWRAP_BRIDGE_INIT_DONE4		0x28
+#define PWRAP_BRIDGE_WACS4_CMD		0x2C
+#define PWRAP_BRIDGE_WACS4_RDATA	0x30
+#define PWRAP_BRIDGE_WACS4_VLDCLR	0x34
+#define PWRAP_BRIDGE_INT_EN		0x38
+#define PWRAP_BRIDGE_INT_FLG_RAW	0x3C
+#define PWRAP_BRIDGE_INT_FLG		0x40
+#define PWRAP_BRIDGE_INT_CLR		0x44
+#define PWRAP_BRIDGE_TIMER_EN		0x48
+#define PWRAP_BRIDGE_TIMER_STA		0x4C
+#define PWRAP_BRIDGE_WDT_UNIT		0x50
+#define PWRAP_BRIDGE_WDT_SRC_EN		0x54
+#define PWRAP_BRIDGE_WDT_FLG		0x58
+#define PWRAP_BRIDGE_DEBUG_INT_SE	0x5C
+
+/* macro for slave device wrapper registers */
+#define PWRAP_DEW_BASE			0xBC00
+#define PWRAP_DEW_EVENT_OUT_EN		(PWRAP_DEW_BASE + 0x0)
+#define PWRAP_DEW_DIO_EN		(PWRAP_DEW_BASE + 0x2)
+#define PWRAP_DEW_EVENT_SRC_EN		(PWRAP_DEW_BASE + 0x4)
+#define PWRAP_DEW_EVENT_SRC		(PWRAP_DEW_BASE + 0x6)
+#define PWRAP_DEW_EVENT_FLAG		(PWRAP_DEW_BASE + 0x8)
+#define PWRAP_DEW_READ_TEST		(PWRAP_DEW_BASE + 0xA)
+#define PWRAP_DEW_WRITE_TEST		(PWRAP_DEW_BASE + 0xC)
+#define PWRAP_DEW_CRC_EN		(PWRAP_DEW_BASE + 0xE)
+#define PWRAP_DEW_CRC_VAL		(PWRAP_DEW_BASE + 0x10)
+#define PWRAP_DEW_MON_GRP_SEL		(PWRAP_DEW_BASE + 0x12)
+#define PWRAP_DEW_MON_FLAG_SEL		(PWRAP_DEW_BASE + 0x14)
+#define PWRAP_DEW_EVENT_TEST		(PWRAP_DEW_BASE + 0x16)
+#define PWRAP_DEW_CIPHER_KEY_SEL	(PWRAP_DEW_BASE + 0x18)
+#define PWRAP_DEW_CIPHER_IV_SEL		(PWRAP_DEW_BASE + 0x1A)
+#define PWRAP_DEW_CIPHER_LOAD		(PWRAP_DEW_BASE + 0x1C)
+#define PWRAP_DEW_CIPHER_START		(PWRAP_DEW_BASE + 0x1E)
+#define PWRAP_DEW_CIPHER_RDY		(PWRAP_DEW_BASE + 0x20)
+#define PWRAP_DEW_CIPHER_MODE		(PWRAP_DEW_BASE + 0x22)
+#define PWRAP_DEW_CIPHER_SWRST		(PWRAP_DEW_BASE + 0x24)
+
+#endif	/* __PMIC_WRAP_REGS_H__ */
diff --git a/include/linux/soc/mediatek/mtk-pmic-wrap.h b/include/linux/soc/mediatek/mtk-pmic-wrap.h
new file mode 100644
index 0000000..28212a1
--- /dev/null
+++ b/include/linux/soc/mediatek/mtk-pmic-wrap.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu <flora.fu@mediatek.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MTK_PMIC_WRAP_H__
+#define __MTK_PMIC_WRAP_H__
+
+struct pmic_wrapper {
+	struct platform_device *pdev;
+	struct regmap *regmap;
+	void __iomem *pwrap_base;
+	void __iomem *pwrap_bridge_base;
+};
+
+#endif	/* __MTK_PMIC_WRAP_H__ */
-- 
1.8.1.1.dirty

