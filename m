Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaLIUPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:15:24 -0500
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:7059
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752760AbaLIUPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:15:18 -0500
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v4 6/6] staging: fpga manager: add driver for altera socfpga manager
Date: Tue, 9 Dec 2014 14:14:50 -0600
Message-ID: <1418156090-23578-7-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0079.namprd05.prod.outlook.com (10.141.20.49) To
 DM2PR0301MB1245.namprd03.prod.outlook.com (25.160.219.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1245;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB1245;
X-Forefront-PRVS: 0420213CCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(22564002)(189002)(199003)(50466002)(86152002)(31966008)(19580395003)(101416001)(64706001)(47776003)(20776003)(92566001)(2201001)(50226001)(86362001)(575784001)(4396001)(21056001)(76176999)(66066001)(50986999)(69596002)(19580405001)(42186005)(68736005)(15975445007)(48376002)(53416004)(87976001)(97736003)(62966003)(81156004)(106356001)(89996001)(122386002)(40100003)(107046002)(229853001)(120916001)(46102003)(99396003)(105586002)(33646002)(77156002)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1245;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1245;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add driver to fpga manager framework to allow configuration
of FPGA in Altera SoC FPGA parts.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v2: fpga_manager struct now contains struct device
    fpga_manager_register parameters now take device

v3: move to drivers/staging
---
 drivers/staging/fpga/Kconfig  |    6 +
 drivers/staging/fpga/Makefile |    1 +
 drivers/staging/fpga/altera.c |  789 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 796 insertions(+)
 create mode 100644 drivers/staging/fpga/altera.c

diff --git a/drivers/staging/fpga/Kconfig b/drivers/staging/fpga/Kconfig
index e775b17..2944e3c 100644
--- a/drivers/staging/fpga/Kconfig
+++ b/drivers/staging/fpga/Kconfig
@@ -18,4 +18,10 @@ config FPGA_MGR_SYSFS
 	help
 	  FPGA Manager SysFS interface.
 
+config FPGA_MGR_ALTERA
+	tristate "Altera"
+	depends on FPGA
+	help
+	  FPGA manager driver support for configuring Altera FPGAs.
+
 endmenu
diff --git a/drivers/staging/fpga/Makefile b/drivers/staging/fpga/Makefile
index c8a676f..6e0d2bf 100644
--- a/drivers/staging/fpga/Makefile
+++ b/drivers/staging/fpga/Makefile
@@ -8,3 +8,4 @@ fpga-mgr-core-y += fpga-mgr.o
 obj-$(CONFIG_FPGA)			+= fpga-mgr-core.o
 
 # FPGA Manager Drivers
+obj-$(CONFIG_FPGA_MGR_ALTERA)		+= altera.o
diff --git a/drivers/staging/fpga/altera.c b/drivers/staging/fpga/altera.c
new file mode 100644
index 0000000..14a16b4
--- /dev/null
+++ b/drivers/staging/fpga/altera.c
@@ -0,0 +1,789 @@
+/*
+ * FPGA Manager Driver for Altera FPGAs
+ *
+ *  Copyright (C) 2013-2014 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/cdev.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/fpga-mgr.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/regulator/consumer.h>
+
+/* Controls whether to use the Configuration with DCLK steps */
+#ifndef _ALTTERA_FPGAMGR_USE_DCLK
+#define _ALTTERA_FPGAMGR_USE_DCLK 0
+#endif
+
+/* Register offsets */
+#define ALTERA_FPGAMGR_STAT_OFST				0x0
+#define ALTERA_FPGAMGR_CTL_OFST					0x4
+#define ALTERA_FPGAMGR_DCLKCNT_OFST				0x8
+#define ALTERA_FPGAMGR_DCLKSTAT_OFST				0xc
+#define ALTERA_FPGAMGR_GPIO_INTEN_OFST				0x830
+#define ALTERA_FPGAMGR_GPIO_INTMSK_OFST				0x834
+#define ALTERA_FPGAMGR_GPIO_INTTYPE_LEVEL_OFST			0x838
+#define ALTERA_FPGAMGR_GPIO_INT_POL_OFST			0x83c
+#define ALTERA_FPGAMGR_GPIO_INTSTAT_OFST			0x840
+#define ALTERA_FPGAMGR_GPIO_RAW_INTSTAT_OFST			0x844
+#define ALTERA_FPGAMGR_GPIO_PORTA_EOI_OFST			0x84c
+#define ALTERA_FPGAMGR_GPIO_EXT_PORTA_OFST			0x850
+
+/* Register bit defines */
+/* ALTERA_FPGAMGR_STAT register mode field values */
+#define ALTERA_FPGAMGR_STAT_POWER_UP				0x0 /*ramping*/
+#define ALTERA_FPGAMGR_STAT_RESET				0x1
+#define ALTERA_FPGAMGR_STAT_CFG					0x2
+#define ALTERA_FPGAMGR_STAT_INIT				0x3
+#define ALTERA_FPGAMGR_STAT_USER_MODE				0x4
+#define ALTERA_FPGAMGR_STAT_UNKNOWN				0x5
+#define ALTERA_FPGAMGR_STAT_STATE_MASK				0x7
+/* This is a flag value that doesn't really happen in this register field */
+#define ALTERA_FPGAMGR_STAT_POWER_OFF				0x0
+
+#define MSEL_PP16_FAST_NOAES_NODC				0x0
+#define MSEL_PP16_FAST_AES_NODC					0x1
+#define MSEL_PP16_FAST_AESOPT_DC				0x2
+#define MSEL_PP16_SLOW_NOAES_NODC				0x4
+#define MSEL_PP16_SLOW_AES_NODC					0x5
+#define MSEL_PP16_SLOW_AESOPT_DC				0x6
+#define MSEL_PP32_FAST_NOAES_NODC				0x8
+#define MSEL_PP32_FAST_AES_NODC					0x9
+#define MSEL_PP32_FAST_AESOPT_DC				0xa
+#define MSEL_PP32_SLOW_NOAES_NODC				0xc
+#define MSEL_PP32_SLOW_AES_NODC					0xd
+#define MSEL_PP32_SLOW_AESOPT_DC				0xe
+#define ALTERA_FPGAMGR_STAT_MSEL_MASK				0x000000f8
+#define ALTERA_FPGAMGR_STAT_MSEL_SHIFT				3
+
+/* ALTERA_FPGAMGR_CTL register */
+#define ALTERA_FPGAMGR_CTL_EN					0x00000001
+#define ALTERA_FPGAMGR_CTL_NCE					0x00000002
+#define ALTERA_FPGAMGR_CTL_NCFGPULL				0x00000004
+
+#define CDRATIO_X1						0x00000000
+#define CDRATIO_X2						0x00000040
+#define CDRATIO_X4						0x00000080
+#define CDRATIO_X8						0x000000c0
+#define ALTERA_FPGAMGR_CTL_CDRATIO_MASK				0x000000c0
+
+#define ALTERA_FPGAMGR_CTL_AXICFGEN				0x00000100
+
+#define CFGWDTH_16						0x00000000
+#define CFGWDTH_32						0x00000200
+#define ALTERA_FPGAMGR_CTL_CFGWDTH_MASK				0x00000200
+
+/* ALTERA_FPGAMGR_DCLKSTAT register */
+#define ALTERA_FPGAMGR_DCLKSTAT_DCNTDONE_E_DONE			0x1
+
+/* ALTERA_FPGAMGR_GPIO_* registers share the same bit positions */
+#define ALTERA_FPGAMGR_MON_NSTATUS				0x0001
+#define ALTERA_FPGAMGR_MON_CONF_DONE				0x0002
+#define ALTERA_FPGAMGR_MON_INIT_DONE				0x0004
+#define ALTERA_FPGAMGR_MON_CRC_ERROR				0x0008
+#define ALTERA_FPGAMGR_MON_CVP_CONF_DONE			0x0010
+#define ALTERA_FPGAMGR_MON_PR_READY				0x0020
+#define ALTERA_FPGAMGR_MON_PR_ERROR				0x0040
+#define ALTERA_FPGAMGR_MON_PR_DONE				0x0080
+#define ALTERA_FPGAMGR_MON_NCONFIG_PIN				0x0100
+#define ALTERA_FPGAMGR_MON_NSTATUS_PIN				0x0200
+#define ALTERA_FPGAMGR_MON_CONF_DONE_PIN			0x0400
+#define ALTERA_FPGAMGR_MON_FPGA_POWER_ON			0x0800
+#define ALTERA_FPGAMGR_MON_STATUS_MASK				0x0fff
+
+#define ALTERA_FPGAMGR_NUM_SUPPLIES 3
+#define ALTERA_RESUME_TIMEOUT 3
+
+#if IS_ENABLED(CONFIG_REGULATOR)
+/* In power-up order. Reverse for power-down. */
+static const char *supply_names[ALTERA_FPGAMGR_NUM_SUPPLIES] = {
+	"FPGA-1.5V",
+	"FPGA-1.1V",
+	"FPGA-2.5V",
+};
+#endif
+
+struct altera_fpga_priv {
+	void __iomem *fpga_base_addr;
+	void __iomem *fpga_data_addr;
+	struct completion status_complete;
+	int irq;
+	struct regulator *fpga_supplies[ALTERA_FPGAMGR_NUM_SUPPLIES];
+};
+
+struct cfgmgr_mode {
+	/* Values to set in the CTRL register */
+	u32 ctrl;
+
+	/* flag that this table entry is a valid mode */
+	bool valid;
+};
+
+/* For ALTERA_FPGAMGR_STAT_MSEL field */
+static struct cfgmgr_mode cfgmgr_modes[] = {
+	[MSEL_PP16_FAST_NOAES_NODC] = { CFGWDTH_16 | CDRATIO_X1, 1 },
+	[MSEL_PP16_FAST_AES_NODC] =   { CFGWDTH_16 | CDRATIO_X2, 1 },
+	[MSEL_PP16_FAST_AESOPT_DC] =  { CFGWDTH_16 | CDRATIO_X4, 1 },
+	[MSEL_PP16_SLOW_NOAES_NODC] = { CFGWDTH_16 | CDRATIO_X1, 1 },
+	[MSEL_PP16_SLOW_AES_NODC] =   { CFGWDTH_16 | CDRATIO_X2, 1 },
+	[MSEL_PP16_SLOW_AESOPT_DC] =  { CFGWDTH_16 | CDRATIO_X4, 1 },
+	[MSEL_PP32_FAST_NOAES_NODC] = { CFGWDTH_32 | CDRATIO_X1, 1 },
+	[MSEL_PP32_FAST_AES_NODC] =   { CFGWDTH_32 | CDRATIO_X4, 1 },
+	[MSEL_PP32_FAST_AESOPT_DC] =  { CFGWDTH_32 | CDRATIO_X8, 1 },
+	[MSEL_PP32_SLOW_NOAES_NODC] = { CFGWDTH_32 | CDRATIO_X1, 1 },
+	[MSEL_PP32_SLOW_AES_NODC] =   { CFGWDTH_32 | CDRATIO_X4, 1 },
+	[MSEL_PP32_SLOW_AESOPT_DC] =  { CFGWDTH_32 | CDRATIO_X8, 1 },
+};
+
+static u32 altera_fpga_reg_readl(struct altera_fpga_priv *priv, u32 reg_offset)
+{
+	return readl(priv->fpga_base_addr + reg_offset);
+}
+
+static void altera_fpga_reg_writel(struct altera_fpga_priv *priv,
+				   u32 reg_offset, u32 value)
+{
+	writel(value, priv->fpga_base_addr + reg_offset);
+}
+
+static u32 altera_fpga_reg_raw_readl(struct altera_fpga_priv *priv,
+				     u32 reg_offset)
+{
+	return __raw_readl(priv->fpga_base_addr + reg_offset);
+}
+
+static void altera_fpga_reg_raw_writel(struct altera_fpga_priv *priv,
+				       u32 reg_offset, u32 value)
+{
+	__raw_writel(value, priv->fpga_base_addr + reg_offset);
+}
+
+static void altera_fpga_data_writel(struct altera_fpga_priv *priv, u32 value)
+{
+	writel(value, priv->fpga_data_addr);
+}
+
+static inline void altera_fpga_reg_set_bitsl(struct altera_fpga_priv *priv,
+					     u32 offset, u32 bits)
+{
+	u32 val;
+
+	val = altera_fpga_reg_readl(priv, offset);
+	val |= bits;
+	altera_fpga_reg_writel(priv, offset, val);
+}
+
+static inline void altera_fpga_reg_clr_bitsl(struct altera_fpga_priv *priv,
+					     u32 offset, u32 bits)
+{
+	u32 val;
+
+	val = altera_fpga_reg_readl(priv, offset);
+	val &= ~bits;
+	altera_fpga_reg_writel(priv, offset, val);
+}
+
+static int altera_fpga_mon_status_get(struct altera_fpga_priv *priv)
+{
+	return altera_fpga_reg_readl(priv,
+				     ALTERA_FPGAMGR_GPIO_EXT_PORTA_OFST) &
+		ALTERA_FPGAMGR_MON_STATUS_MASK;
+}
+
+static int altera_fpga_state_get(struct altera_fpga_priv *priv)
+{
+	int status = altera_fpga_mon_status_get(priv);
+
+	if ((status & ALTERA_FPGAMGR_MON_FPGA_POWER_ON) == 0)
+		return ALTERA_FPGAMGR_STAT_POWER_OFF;
+
+	return altera_fpga_reg_readl(priv, ALTERA_FPGAMGR_STAT_OFST) &
+		ALTERA_FPGAMGR_STAT_STATE_MASK;
+}
+
+static void altera_fpga_clear_done_status(struct altera_fpga_priv *priv)
+{
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_DCLKSTAT_OFST,
+			       ALTERA_FPGAMGR_DCLKSTAT_DCNTDONE_E_DONE);
+}
+
+/*
+ * Set the DCLKCNT, wait for DCLKSTAT to report the count completed, and clear
+ * the complete status.
+ */
+static int altera_fpga_dclk_set_and_wait_clear(struct altera_fpga_priv *priv,
+					       u32 count)
+{
+	int timeout = 2;
+	u32 done;
+
+	/* Clear any existing DONE status. */
+	if (altera_fpga_reg_readl(priv, ALTERA_FPGAMGR_DCLKSTAT_OFST))
+		altera_fpga_clear_done_status(priv);
+
+	/* Issue the DCLK count. */
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_DCLKCNT_OFST, count);
+
+	/* Poll DCLKSTAT to see if it completed in the timeout period. */
+	do {
+		done = altera_fpga_reg_readl(priv,
+					     ALTERA_FPGAMGR_DCLKSTAT_OFST);
+		if (done == ALTERA_FPGAMGR_DCLKSTAT_DCNTDONE_E_DONE) {
+			altera_fpga_clear_done_status(priv);
+			return 0;
+		}
+		if (count <= 4)
+			udelay(1);
+		else
+			msleep(20);
+	} while (timeout--);
+
+	return -ETIMEDOUT;
+}
+
+static int altera_fpga_wait_for_state(struct altera_fpga_priv *priv, u32 state)
+{
+	int timeout = 2;
+
+	/*
+	 * HW doesn't support an interrupt for changes in state, so poll to see
+	 * if it matches the requested state within the timeout period.
+	 */
+	do {
+		if ((altera_fpga_state_get(priv) & state) != 0)
+			return 0;
+		msleep(20);
+	} while (timeout--);
+
+	return -ETIMEDOUT;
+}
+
+static void altera_fpga_enable_irqs(struct altera_fpga_priv *priv, u32 irqs)
+{
+	/* set irqs to level sensitive */
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_GPIO_INTTYPE_LEVEL_OFST, 0);
+
+	/* set interrupt polarity */
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_GPIO_INT_POL_OFST, irqs);
+
+	/* clear irqs */
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_GPIO_PORTA_EOI_OFST, irqs);
+
+	/* unmask interrupts */
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_GPIO_INTMSK_OFST, 0);
+
+	/* enable interrupts */
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_GPIO_INTEN_OFST, irqs);
+}
+
+static void altera_fpga_disable_irqs(struct altera_fpga_priv *priv)
+{
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_GPIO_INTEN_OFST, 0);
+}
+
+static irqreturn_t altera_fpga_isr(int irq, void *dev_id)
+{
+	struct altera_fpga_priv *priv = dev_id;
+	u32 irqs, st;
+	bool conf_done, nstatus;
+
+	/* clear irqs */
+	irqs = altera_fpga_reg_raw_readl(priv,
+					 ALTERA_FPGAMGR_GPIO_INTSTAT_OFST);
+
+	altera_fpga_reg_raw_writel(priv, ALTERA_FPGAMGR_GPIO_PORTA_EOI_OFST,
+				   irqs);
+
+	st = altera_fpga_reg_raw_readl(priv,
+				       ALTERA_FPGAMGR_GPIO_EXT_PORTA_OFST);
+	conf_done = (st & ALTERA_FPGAMGR_MON_CONF_DONE) != 0;
+	nstatus = (st & ALTERA_FPGAMGR_MON_NSTATUS) != 0;
+
+	/* success */
+	if (conf_done && nstatus) {
+		/* disable irqs */
+		altera_fpga_reg_raw_writel(priv,
+					   ALTERA_FPGAMGR_GPIO_INTEN_OFST, 0);
+		complete(&priv->status_complete);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int altera_fpga_wait_for_config_done(struct altera_fpga_priv *priv)
+{
+	int timeout, ret = 0;
+
+	altera_fpga_disable_irqs(priv);
+	init_completion(&priv->status_complete);
+	altera_fpga_enable_irqs(priv, ALTERA_FPGAMGR_MON_CONF_DONE);
+
+	timeout = wait_for_completion_interruptible_timeout(
+						&priv->status_complete,
+						msecs_to_jiffies(10));
+	if (timeout == 0)
+		ret = -ETIMEDOUT;
+
+	altera_fpga_disable_irqs(priv);
+	return ret;
+}
+
+static int altera_fpga_cfg_mode_get(struct altera_fpga_priv *priv)
+{
+	u32 msel;
+
+	msel = altera_fpga_reg_readl(priv, ALTERA_FPGAMGR_STAT_OFST);
+	msel &= ALTERA_FPGAMGR_STAT_MSEL_MASK;
+	msel >>= ALTERA_FPGAMGR_STAT_MSEL_SHIFT;
+
+	/* Check that this MSEL setting is supported */
+	if ((msel >= sizeof(cfgmgr_modes)/sizeof(struct cfgmgr_mode)) ||
+	    !cfgmgr_modes[msel].valid)
+		return -EINVAL;
+
+	return msel;
+}
+
+static int altera_fpga_cfg_mode_set(struct altera_fpga_priv *priv)
+{
+	u32 ctrl_reg, mode;
+
+	/* get value from MSEL pins */
+	mode = altera_fpga_cfg_mode_get(priv);
+	if (mode < 0)
+		return mode;
+
+	/* Adjust CTRL for the CDRATIO */
+	ctrl_reg = altera_fpga_reg_readl(priv, ALTERA_FPGAMGR_CTL_OFST);
+	ctrl_reg &= ~ALTERA_FPGAMGR_CTL_CDRATIO_MASK;
+	ctrl_reg &= ~ALTERA_FPGAMGR_CTL_CFGWDTH_MASK;
+	ctrl_reg |= cfgmgr_modes[mode].ctrl;
+
+	/* Set NCE to 0. */
+	ctrl_reg &= ~ALTERA_FPGAMGR_CTL_NCE;
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_CTL_OFST, ctrl_reg);
+
+	return 0;
+}
+
+static int altera_fpga_reset(struct altera_fpga_priv *priv)
+{
+	u32 ctrl_reg, status;
+	int ret;
+
+	/*
+	 * Step 1:
+	 *  - Set CTRL.CFGWDTH, CTRL.CDRATIO to match cfg mode
+	 *  - Set CTRL.NCE to 0
+	 */
+	ret = altera_fpga_cfg_mode_set(priv);
+	if (ret)
+		return ret;
+
+	/* Step 2: Set CTRL.EN to 1 */
+	altera_fpga_reg_set_bitsl(priv, ALTERA_FPGAMGR_CTL_OFST,
+				  ALTERA_FPGAMGR_CTL_EN);
+
+	/* Step 3: Set CTRL.NCONFIGPULL to 1 to put FPGA in reset */
+	ctrl_reg = altera_fpga_reg_readl(priv, ALTERA_FPGAMGR_CTL_OFST);
+	ctrl_reg |= ALTERA_FPGAMGR_CTL_NCFGPULL;
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_CTL_OFST, ctrl_reg);
+
+	/* Step 4: Wait for STATUS.MODE to report FPGA is in reset phase */
+	status = altera_fpga_wait_for_state(priv, ALTERA_FPGAMGR_STAT_RESET);
+
+	/* Step 5: Set CONTROL.NCONFIGPULL to 0 to release FPGA from reset */
+	ctrl_reg &= ~ALTERA_FPGAMGR_CTL_NCFGPULL;
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_CTL_OFST, ctrl_reg);
+
+	/* Timeout waiting for reset */
+	if (status)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+/*
+ * Prepare the FPGA to receive the configuration data.
+ */
+static int altera_fpga_ops_configure_init(struct fpga_manager *mgr)
+{
+	struct altera_fpga_priv *priv = mgr->priv;
+	int ret;
+
+	/* Steps 1 - 5: Reset the FPGA */
+	ret = altera_fpga_reset(priv);
+	if (ret)
+		return ret;
+
+	/* Step 6: Wait for FPGA to enter configuration phase */
+	if (altera_fpga_wait_for_state(priv, ALTERA_FPGAMGR_STAT_CFG))
+		return -ETIMEDOUT;
+
+	/* Step 7: Clear nSTATUS interrupt */
+	altera_fpga_reg_writel(priv, ALTERA_FPGAMGR_GPIO_PORTA_EOI_OFST,
+			       ALTERA_FPGAMGR_MON_NSTATUS);
+
+	/* Step 8: Set CTRL.AXICFGEN to 1 to enable transfer of config data */
+	altera_fpga_reg_set_bitsl(priv, ALTERA_FPGAMGR_CTL_OFST,
+				  ALTERA_FPGAMGR_CTL_AXICFGEN);
+
+	return 0;
+}
+
+/*
+ * Step 9: write data to the FPGA data register
+ */
+static int altera_fpga_ops_configure_write(struct fpga_manager *mgr,
+					   const char *buf, size_t count)
+{
+	struct altera_fpga_priv *priv = mgr->priv;
+	u32 *buffer_32 = (u32 *)buf;
+	size_t i = 0;
+
+	if (count <= 0)
+		return -EINVAL;
+
+	/* Write out the complete 32-bit chunks. */
+	while (count >= sizeof(u32)) {
+		altera_fpga_data_writel(priv, buffer_32[i++]);
+		count -= sizeof(u32);
+	}
+
+	/* Write out remaining non 32-bit chunks. */
+	switch (count) {
+	case 3:
+		altera_fpga_data_writel(priv, buffer_32[i++] & 0x00ffffff);
+		break;
+	case 2:
+		altera_fpga_data_writel(priv, buffer_32[i++] & 0x0000ffff);
+		break;
+	case 1:
+		altera_fpga_data_writel(priv, buffer_32[i++] & 0x000000ff);
+		break;
+	default:
+		/* This will never happen. */
+		break;
+	}
+
+	return 0;
+}
+
+static int altera_fpga_ops_configure_complete(struct fpga_manager *mgr)
+{
+	struct altera_fpga_priv *priv = mgr->priv;
+	u32 status;
+
+	/*
+	 * Step 10:
+	 *  - Observe CONF_DONE and nSTATUS (active low)
+	 *  - if CONF_DONE = 1 and nSTATUS = 1, configuration was successful
+	 *  - if CONF_DONE = 0 and nSTATUS = 0, configuration failed
+	 */
+	status = altera_fpga_wait_for_config_done(priv);
+	if (status)
+		return status;
+
+	/* Step 11: Clear CTRL.AXICFGEN to disable transfer of config data */
+	altera_fpga_reg_clr_bitsl(priv, ALTERA_FPGAMGR_CTL_OFST,
+				  ALTERA_FPGAMGR_CTL_AXICFGEN);
+
+	/*
+	 * Step 12:
+	 *  - Write 4 to DCLKCNT
+	 *  - Wait for STATUS.DCNTDONE = 1
+	 *  - Clear W1C bit in STATUS.DCNTDONE
+	 */
+	if (altera_fpga_dclk_set_and_wait_clear(priv, 4))
+		return -ETIMEDOUT;
+
+#if _ALTTERA_FPGAMGR_USE_DCLK
+	/* Step 13: Wait for STATUS.MODE to report INIT or USER MODE */
+	if (altera_fpga_wait_for_state(priv, ALTERA_FPGAMGR_STAT_INIT |
+				       ALTERA_FPGAMGR_STAT_USER_MODE))
+		return -ETIMEDOUT;
+
+	/*
+	 * Extra steps for Configuration with DCLK for Initialization Phase
+	 * Step 14 (using 4.2.1.2 steps), 15 (using 4.2.1.2 steps)
+	 *  - Write 0x5000 to DCLKCNT == the number of clocks needed to exit
+	 *    the Initialization Phase.
+	 *  - Poll until STATUS.DCNTDONE = 1, write 1 to clear
+	 */
+	if (altera_fpga_dclk_set_and_wait_clear(priv, 0x5000))
+		return -ETIMEDOUT;
+#endif
+
+	/* Step 13: Wait for STATUS.MODE to report USER MODE */
+	if (altera_fpga_wait_for_state(priv, ALTERA_FPGAMGR_STAT_USER_MODE))
+		return -ETIMEDOUT;
+
+	/* Step 14: Set CTRL.EN to 0 */
+	altera_fpga_reg_clr_bitsl(priv, ALTERA_FPGAMGR_CTL_OFST,
+				  ALTERA_FPGAMGR_CTL_EN);
+
+	return 0;
+}
+
+static int altera_fpga_ops_reset(struct fpga_manager *mgr)
+{
+	return altera_fpga_reset(mgr->priv);
+}
+
+/* Translate state register values to FPGA framework state */
+static const int altera_state_to_framework_state[] = {
+	[ALTERA_FPGAMGR_STAT_POWER_OFF] = FPGA_MGR_STATE_POWER_OFF,
+	[ALTERA_FPGAMGR_STAT_RESET] = FPGA_MGR_STATE_RESET,
+	[ALTERA_FPGAMGR_STAT_CFG] = FPGA_MGR_STATE_WRITE_INIT,
+	[ALTERA_FPGAMGR_STAT_INIT] = FPGA_MGR_STATE_WRITE_INIT,
+	[ALTERA_FPGAMGR_STAT_USER_MODE] = FPGA_MGR_STATE_OPERATING,
+	[ALTERA_FPGAMGR_STAT_UNKNOWN] = FPGA_MGR_STATE_UNKNOWN,
+};
+
+static int altera_fpga_ops_state(struct fpga_manager *mgr)
+{
+	struct altera_fpga_priv *priv = mgr->priv;
+	u32 state;
+	int ret;
+
+	state = altera_fpga_state_get(priv);
+
+	if (state < ARRAY_SIZE(altera_state_to_framework_state))
+		ret = altera_state_to_framework_state[state];
+	else
+		ret = FPGA_MGR_STATE_UNKNOWN;
+
+	return ret;
+}
+
+#if IS_ENABLED(CONFIG_REGULATOR)
+static int altera_fpga_regulators_on(struct altera_fpga_priv *priv)
+{
+	int i, ret;
+
+	for (i = 0; i < ALTERA_FPGAMGR_NUM_SUPPLIES; i++) {
+		ret = regulator_enable(priv->fpga_supplies[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void altera_fpga_regulators_power_off(struct altera_fpga_priv *priv)
+{
+	int i;
+
+	for (i = ALTERA_FPGAMGR_NUM_SUPPLIES - 1; i >= 0; i--)
+		regulator_disable(priv->fpga_supplies[i]);
+}
+
+static int altera_fpga_regulator_probe(struct platform_device *pdev,
+				       struct altera_fpga_priv *priv)
+{
+	struct regulator *supply;
+	unsigned int i;
+
+	for (i = 0; i < ALTERA_FPGAMGR_NUM_SUPPLIES; i++) {
+		supply = devm_regulator_get_optional(&pdev->dev,
+						     supply_names[i]);
+		if (IS_ERR(supply)) {
+			dev_err(&pdev->dev, "could not get regulators");
+			return -EPROBE_DEFER;
+		}
+		priv->fpga_supplies[i] = supply;
+	}
+
+	return altera_fpga_regulators_on(priv);
+}
+#else
+static int altera_fpga_regulators_on(struct altera_fpga_priv *priv)
+{
+	return 0;
+}
+
+static void altera_fpga_regulators_power_off(struct altera_fpga_priv *priv)
+{
+}
+
+static int altera_fpga_regulator_probe(struct platform_device *pdev,
+				       struct altera_fpga_priv *priv)
+{
+	return 0;
+}
+#endif
+
+static int altera_fpga_suspend(struct fpga_manager *mgr)
+{
+	struct altera_fpga_priv *priv = mgr->priv;
+
+	altera_fpga_regulators_power_off(priv);
+
+	return 0;
+}
+
+static int altera_fpga_resume(struct fpga_manager *mgr)
+{
+	struct altera_fpga_priv *priv = mgr->priv;
+	u32 state;
+	unsigned int timeout;
+	int ret;
+
+	ret = altera_fpga_regulators_on(priv);
+	if (ret)
+		return ret;
+
+	for (timeout = 0; timeout < ALTERA_RESUME_TIMEOUT; timeout++) {
+		state = altera_fpga_state_get(priv);
+		if (state != ALTERA_FPGAMGR_STAT_POWER_OFF)
+			break;
+		msleep(20);
+	}
+	if (state == ALTERA_FPGAMGR_STAT_POWER_OFF)
+		return -ETIMEDOUT;
+
+	return ret;
+}
+
+struct fpga_manager_ops altera_altera_fpga_ops = {
+	.reset = altera_fpga_ops_reset,
+	.state = altera_fpga_ops_state,
+	.write_init = altera_fpga_ops_configure_init,
+	.write = altera_fpga_ops_configure_write,
+	.write_complete = altera_fpga_ops_configure_complete,
+	.suspend = altera_fpga_suspend,
+	.resume = altera_fpga_resume,
+};
+
+static int altera_fpga_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = pdev->dev.of_node;
+	struct altera_fpga_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ret = altera_fpga_regulator_probe(pdev, priv);
+	if (ret)
+		return ret;
+
+	priv->fpga_base_addr = of_iomap(np, 0);
+	if (!priv->fpga_base_addr)
+		return -EINVAL;
+
+	priv->fpga_data_addr = of_iomap(np, 1);
+	if (!priv->fpga_data_addr) {
+		ret = -EINVAL;
+		goto err_unmap_base_addr;
+	}
+
+	priv->irq = irq_of_parse_and_map(np, 0);
+	if (priv->irq == NO_IRQ) {
+		ret = -EINVAL;
+		goto err_unmap_data_addr;
+	}
+
+	ret = request_irq(priv->irq, altera_fpga_isr, 0, "altera-fpga-mgr",
+			  priv);
+	if (ret < 0)
+		goto err_dispose_irq;
+
+	ret = fpga_mgr_register(dev, "Altera FPGA Manager",
+				&altera_altera_fpga_ops, priv);
+	if (ret)
+		goto err_free_irq;
+
+	return 0;
+
+err_free_irq:
+	free_irq(priv->irq, priv);
+err_dispose_irq:
+	irq_dispose_mapping(priv->irq);
+err_unmap_data_addr:
+	iounmap(priv->fpga_data_addr);
+err_unmap_base_addr:
+	iounmap(priv->fpga_base_addr);
+	return ret;
+}
+
+static int altera_fpga_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct fpga_manager *mgr = to_fpga_manager(dev);
+	struct altera_fpga_priv *priv = mgr->priv;
+
+	fpga_mgr_remove(dev);
+	free_irq(priv->irq, priv);
+	irq_dispose_mapping(priv->irq);
+	iounmap(priv->fpga_data_addr);
+	iounmap(priv->fpga_base_addr);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id altera_fpga_of_match[] = {
+	{ .compatible = "altr,fpga-mgr", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, altera_fpga_of_match);
+#endif
+
+static struct platform_driver altera_fpga_driver = {
+	.remove = altera_fpga_remove,
+	.driver = {
+		.name	= "altera_fpga_manager",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(altera_fpga_of_match),
+	},
+	.probe = altera_fpga_probe,
+};
+
+static int __init altera_fpga_init(void)
+{
+	return platform_driver_register(&altera_fpga_driver);
+}
+
+static void __exit altera_fpga_exit(void)
+{
+	platform_driver_unregister(&altera_fpga_driver);
+}
+
+module_init(altera_fpga_init);
+module_exit(altera_fpga_exit);
+
+MODULE_AUTHOR("Alan Tull <atull@opensource.altera.com>");
+MODULE_DESCRIPTION("Altera FPGA Manager");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

