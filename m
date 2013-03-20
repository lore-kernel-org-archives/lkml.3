Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3CTEy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 00:54:57 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:26975
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab3CTEyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 00:54:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Anson Huang <b20788@freescale.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <shawn.guo@linaro.org>
Subject: [PATCH 3/3] ARM: imx: enable RBC to support anatop LPM mode
Date: Wed, 20 Mar 2013 13:39:40 -0400
Message-ID: <1363801180-8284-3-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363801180-8284-1-git-send-email-b20788@freescale.com>
References: <1363801180-8284-1-git-send-email-b20788@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RBC is to control whether some ANATOP sub modules
can enter lpm mode when SOC is into STOP mode, if
RBC is enabled and PMIC_VSTBY_REQ is set, ANATOP
will have below behaviors:

1. Digital LDOs(CORE, SOC and PU) are bypassed;
2. Analog LDOs(1P1, 2P5, 3P0) are disabled;

As the 2P5 is necessary for DRAM IO pre-drive in
STOP mode, so we need to enable weak 2P5 in STOP
mode when 2P5 LDO is disabled.

For RBC settings, there are some rules as below
due to hardware designe:

1. All interrupts must be masked during operating
   RBC registers;
2. At least 2 CKIL(32K) cycles is needed after the
   RBC setting is changed.

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 arch/arm/mach-imx/anatop.c    |   19 +++++++++++++++++++
 arch/arm/mach-imx/clk-imx6q.c |   35 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-imx/common.h    |    3 +++
 arch/arm/mach-imx/gpc.c       |   21 ++++++++++++++++++++-
 arch/arm/mach-imx/pm-imx6q.c  |    2 ++
 5 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/anatop.c b/arch/arm/mach-imx/anatop.c
index 8f6ab27..38b4f44 100644
--- a/arch/arm/mach-imx/anatop.c
+++ b/arch/arm/mach-imx/anatop.c
@@ -18,12 +18,29 @@
 
 #define REG_SET		0x4
 #define REG_CLR		0x8
+#define ANA_MISC0	0x150
 #define ANA_REG_CORE	0x140
+#define ANA_REG_2P5	0x130
 
+#define BM_ANADIG_REG_2P5_ENABLE_WEAK_LINREG	0x40000
+#define BM_ANADIG_ANA_MISC0_STOP_MODE_CONFIG	0x1000
 #define BM_ANADIG_REG_CORE_FET_ODRIVE		0x20000000
 
 static struct regmap *anatop;
 
+void imx_anatop_enable_weak2p5(bool enable)
+{
+	u32 val;
+
+	regmap_read(anatop, ANA_MISC0, &val);
+
+	/* can only be enabled when stop_mode_config is clear. */
+	regmap_write(anatop, ANA_REG_2P5 + ((enable &&
+		((val & BM_ANADIG_ANA_MISC0_STOP_MODE_CONFIG)
+		== 0)) ? REG_SET : REG_CLR),
+		BM_ANADIG_REG_2P5_ENABLE_WEAK_LINREG);
+}
+
 void imx_anatop_enable_fet_odrive(bool enable)
 {
 	regmap_write(anatop, ANA_REG_CORE + (enable ?
@@ -32,12 +49,14 @@ void imx_anatop_enable_fet_odrive(bool enable)
 
 void imx_anatop_pre_suspend(void)
 {
+	imx_anatop_enable_weak2p5(true);
 	imx_anatop_enable_fet_odrive(true);
 }
 
 void imx_anatop_post_resume(void)
 {
 	imx_anatop_enable_fet_odrive(false);
+	imx_anatop_enable_weak2p5(false);
 }
 
 void __init imx_anatop_init(void)
diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index b365efc..646ce12 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/clk.h>
 #include <linux/clkdev.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -25,6 +26,8 @@
 
 #define CCR				0x0
 #define BM_CCR_WB_COUNT			(0x7 << 16)
+#define BM_CCR_RBC_BYPASS_COUNT		(0x3f << 21)
+#define BM_CCR_RBC_EN			(0x1 << 27)
 
 #define CCGR0				0x68
 #define CCGR1				0x6c
@@ -70,6 +73,38 @@ void imx6q_set_chicken_bit(void)
 	writel_relaxed(val, ccm_base + CGPR);
 }
 
+void imx6q_set_rbc(bool enable)
+{
+	u32 val;
+
+	/*
+	 * need to mask all interrupts in GPC before
+	 * operating RBC configurations
+	 */
+	imx_gpc_mask_all();
+
+	/* configurate RBC enable bit */
+	val = readl_relaxed(ccm_base + CCR);
+	val &= ~BM_CCR_RBC_EN;
+	val |= enable ? BM_CCR_RBC_EN : 0;
+	writel_relaxed(val, ccm_base + CCR);
+
+	/* configurate RBC count */
+	val = readl_relaxed(ccm_base + CCR);
+	val &= ~BM_CCR_RBC_BYPASS_COUNT;
+	val |= enable ? BM_CCR_RBC_BYPASS_COUNT : 0;
+	writel(val, ccm_base + CCR);
+
+	/*
+	 * need to delay at least 2 cycles of CKIL(32K)
+	 * due to hardware design requirement, which is
+	 * ~61us, here we use 65us for safe
+	 */
+	udelay(65);
+	/* restore GPC interrupt mask settings */
+	imx_gpc_restore_all();
+}
+
 void imx6q_set_wb(bool enable)
 {
 	u32 val;
diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
index b9125cf..66fe41c 100644
--- a/arch/arm/mach-imx/common.h
+++ b/arch/arm/mach-imx/common.h
@@ -129,11 +129,14 @@ extern void imx_src_prepare_restart(void);
 extern void imx_gpc_init(void);
 extern void imx_gpc_pre_suspend(void);
 extern void imx_gpc_post_resume(void);
+extern void imx_gpc_mask_all(void);
+extern void imx_gpc_restore_all(void);
 extern void imx_anatop_init(void);
 extern void imx_anatop_pre_suspend(void);
 extern void imx_anatop_post_resume(void);
 extern int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode);
 extern void imx6q_set_chicken_bit(void);
+extern void imx6q_set_rbc(bool enable);
 extern void imx6q_set_wb(bool enable);
 extern void imx_cpu_die(unsigned int cpu);
 extern int imx_cpu_kill(unsigned int cpu);
diff --git a/arch/arm/mach-imx/gpc.c b/arch/arm/mach-imx/gpc.c
index a96ccc7..504049e 100644
--- a/arch/arm/mach-imx/gpc.c
+++ b/arch/arm/mach-imx/gpc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2011 Freescale Semiconductor, Inc.
+ * Copyright 2011-2013 Freescale Semiconductor, Inc.
  * Copyright 2011 Linaro Ltd.
  *
  * The code contained herein is licensed under the GNU General Public
@@ -68,6 +68,25 @@ static int imx_gpc_irq_set_wake(struct irq_data *d, unsigned int on)
 	return 0;
 }
 
+void imx_gpc_mask_all(void)
+{
+	void __iomem *reg_imr1 = gpc_base + GPC_IMR1;
+	int i;
+
+	for (i = 0; i < IMR_NUM; i++)
+		writel_relaxed(0xffffffff, reg_imr1 + i * 4);
+
+}
+
+void imx_gpc_restore_all(void)
+{
+	void __iomem *reg_imr1 = gpc_base + GPC_IMR1;
+	int i;
+
+	for (i = 0; i < IMR_NUM; i++)
+		writel_relaxed(gpc_saved_imrs[i], reg_imr1 + i * 4);
+}
+
 static void imx_gpc_irq_unmask(struct irq_data *d)
 {
 	void __iomem *reg;
diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
index 57ca274..24ac7bc 100644
--- a/arch/arm/mach-imx/pm-imx6q.c
+++ b/arch/arm/mach-imx/pm-imx6q.c
@@ -36,10 +36,12 @@ static int imx6q_pm_enter(suspend_state_t state)
 		imx_gpc_pre_suspend();
 		imx_anatop_pre_suspend();
 		imx_set_cpu_jump(0, v7_cpu_resume);
+		imx6q_set_rbc(true);
 		imx6q_set_wb(true);
 		/* Zzz ... */
 		cpu_suspend(0, imx6q_suspend_finish);
 		imx6q_set_wb(false);
+		imx6q_set_rbc(false);
 		imx_smp_prepare();
 		imx_anatop_post_resume();
 		imx_gpc_post_resume();
-- 
1.7.9.5


