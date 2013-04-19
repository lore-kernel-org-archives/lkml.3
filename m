Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968276Ab3DSKva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:51:30 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:43177 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757182Ab3DSKsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:48:14 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 03/15] fsl_pmc: Add API to enable device as wakeup event source
Date: Fri, 19 Apr 2013 18:47:36 +0800
Message-ID: <1366368468-29143-3-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenhui zhao <chenhui.zhao@freescale.com>

Add APIs for setting wakeup source and lossless Ethernet in low power modes.
These APIs can be used by wake-on-packet feature.

Change-Id: I1803dcd4571af1eac49b43d99c578e7f99e2c278
Signed-off-by: Dave Liu <daveliu@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Jin Qing <b24347@freescale.com>
Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/sysdev/fsl_pmc.c |   72 ++++++++++++++++++++++++++++++++++++++++-
 arch/powerpc/sysdev/fsl_soc.h |   11 ++++++
 2 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
index 6c2c8b3..94ae476 100644
--- a/arch/powerpc/sysdev/fsl_pmc.c
+++ b/arch/powerpc/sysdev/fsl_pmc.c
@@ -38,6 +38,7 @@ struct pmc_regs {
 	__be32 powmgtcsr;
 #define POWMGTCSR_SLP		0x00020000
 #define POWMGTCSR_DPSLP		0x00100000
+#define POWMGTCSR_LOSSLESS	0x00400000
 	__be32 res3[2];
 	/* 0xe008c: Power management clock disable register */
 	__be32 pmcdr;
@@ -48,6 +49,75 @@ static unsigned int pmc_flag;
 
 #define PMC_SLEEP	0x1
 #define PMC_DEEP_SLEEP	0x2
+#define PMC_LOSSLESS	0x4
+
+/**
+ * mpc85xx_pmc_set_wake - enable devices as wakeup event source
+ * @dev: a device affected
+ * @enable: True to enable event generation; false to disable
+ *
+ * This enables the device as a wakeup event source, or disables it.
+ *
+ * RETURN VALUE:
+ * 0 is returned on success.
+ * -EINVAL is returned if device is not supposed to wake up the system.
+ * -ENODEV is returned if PMC is unavailable.
+ * Error code depending on the platform is returned if both the platform and
+ * the native mechanism fail to enable the generation of wake-up events
+ */
+int mpc85xx_pmc_set_wake(struct device *dev, bool enable)
+{
+	int ret = 0;
+	struct device_node *clk_np;
+	const u32 *prop;
+	u32 pmcdr_mask;
+
+	if (!pmc_regs) {
+		dev_err(dev, "%s: PMC is unavailable\n", __func__);
+		return -ENODEV;
+	}
+
+	if (enable && !device_may_wakeup(dev))
+		return -EINVAL;
+
+	clk_np = of_parse_phandle(dev->of_node, "fsl,pmc-handle", 0);
+	if (!clk_np)
+		return -EINVAL;
+
+	prop = of_get_property(clk_np, "fsl,pmcdr-mask", NULL);
+	if (!prop) {
+		ret = -EINVAL;
+		goto out;
+	}
+	pmcdr_mask = be32_to_cpup(prop);
+
+	if (enable)
+		/* clear to enable clock in low power mode */
+		clrbits32(&pmc_regs->pmcdr, pmcdr_mask);
+	else
+		setbits32(&pmc_regs->pmcdr, pmcdr_mask);
+
+out:
+	of_node_put(clk_np);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mpc85xx_pmc_set_wake);
+
+/**
+ * mpc85xx_pmc_set_lossless_ethernet - enable lossless ethernet
+ * in (deep) sleep mode
+ * @enable: True to enable event generation; false to disable
+ */
+void mpc85xx_pmc_set_lossless_ethernet(int enable)
+{
+	if (pmc_flag & PMC_LOSSLESS) {
+		if (enable)
+			setbits32(&pmc_regs->powmgtcsr,	POWMGTCSR_LOSSLESS);
+		else
+			clrbits32(&pmc_regs->powmgtcsr, POWMGTCSR_LOSSLESS);
+	}
+}
+EXPORT_SYMBOL_GPL(mpc85xx_pmc_set_lossless_ethernet);
 
 static int pmc_suspend_enter(suspend_state_t state)
 {
@@ -122,7 +192,7 @@ static int pmc_probe(struct platform_device *pdev)
 		pmc_flag |= PMC_DEEP_SLEEP;
 
 	if (of_device_is_compatible(np, "fsl,p1022-pmc"))
-		pmc_flag |= PMC_DEEP_SLEEP;
+		pmc_flag |= PMC_DEEP_SLEEP | PMC_LOSSLESS;
 
 	suspend_set_ops(&pmc_suspend_ops);
 
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index 949377d..e58f4dd 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -21,6 +21,17 @@ struct device_node;
 
 extern void fsl_rstcr_restart(char *cmd);
 
+#ifdef CONFIG_FSL_PMC
+int mpc85xx_pmc_set_wake(struct device *dev, bool enable);
+void mpc85xx_pmc_set_lossless_ethernet(int enable);
+#else
+static inline int mpc85xx_pmc_set_wake(struct device *dev, bool enable)
+{
+	return -ENODEV;
+}
+#define mpc85xx_pmc_set_lossless_ethernet(enable)	do { } while (0)
+#endif
+
 #if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
 
 /* The different ports that the DIU can be connected to */
-- 
1.7.3


