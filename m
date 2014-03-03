Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaCCPKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:10:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33752 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbaCCPId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:08:33 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>, <tony@atomide.com>
CC: <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <rogerq@ti.com>
Subject: [PATCH 09/12] phy: ti-pipe3: streamline PHY operations
Date: Mon, 3 Mar 2014 17:07:31 +0200
Message-ID: <1393859254-10937-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393859254-10937-1-git-send-email-rogerq@ti.com>
References: <1393859254-10937-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit .power_on() and .power_off() to just control the
PHY power and not the DPLL. The DPLL will be enabled
in .init() and idled in .exit().

Don't reprogram the DPLL if it has been already locked
by the bootloader. This fixes a problem with SATA, where
it fails if SATA was used by the bootloader.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-ti-pipe3.c | 114 +++++++++++++++++++++++++--------------------
 1 file changed, 63 insertions(+), 51 deletions(-)

diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
index ee8871d..d3c085a 100644
--- a/drivers/phy/phy-ti-pipe3.c
+++ b/drivers/phy/phy-ti-pipe3.c
@@ -47,7 +47,8 @@
 #define	PLL_SD_MASK		0x0003FC00
 #define	PLL_SD_SHIFT		10
 #define	SET_PLL_GO		0x1
-#define	PLL_TICOPWDN		0x10000
+#define PLL_LDOPWDN		BIT(15)
+#define PLL_TICOPWDN		BIT(16)
 #define	PLL_LOCK		0x2
 #define	PLL_IDLE		0x1
 
@@ -56,7 +57,8 @@
  * value required for the PIPE3PHY_PLL_CONFIGURATION2.PLL_IDLE status
  * to be correctly reflected in the PIPE3PHY_PLL_STATUS register.
  */
-# define PLL_IDLE_TIME  100;
+#define PLL_IDLE_TIME	100	/* in milliseconds */
+#define PLL_LOCK_TIME	100	/* in milliseconds */
 
 struct pipe3_dpll_params {
 	u16	m;
@@ -132,24 +134,6 @@ static struct pipe3_dpll_params *ti_pipe3_get_dpll_params(struct ti_pipe3 *phy)
 static int ti_pipe3_power_off(struct phy *x)
 {
 	struct ti_pipe3 *phy = phy_get_drvdata(x);
-	int val;
-	int timeout = PLL_IDLE_TIME;
-
-	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
-	val |= PLL_IDLE;
-	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
-
-	do {
-		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
-		if (val & PLL_TICOPWDN)
-			break;
-		udelay(5);
-	} while (--timeout);
-
-	if (!timeout) {
-		dev_err(phy->dev, "power off failed\n");
-		return -EBUSY;
-	}
 
 	omap_control_phy_power(phy->control_dev, 0);
 
@@ -159,44 +143,34 @@ static int ti_pipe3_power_off(struct phy *x)
 static int ti_pipe3_power_on(struct phy *x)
 {
 	struct ti_pipe3 *phy = phy_get_drvdata(x);
-	int val;
-	int timeout = PLL_IDLE_TIME;
-
-	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
-	val &= ~PLL_IDLE;
-	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
 
-	do {
-		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
-		if (!(val & PLL_TICOPWDN))
-			break;
-		udelay(5);
-	} while (--timeout);
-
-	if (!timeout) {
-		dev_err(phy->dev, "power on failed\n");
-		return -EBUSY;
-	}
+	omap_control_phy_power(phy->control_dev, 1);
 
 	return 0;
 }
 
-static void ti_pipe3_dpll_relock(struct ti_pipe3 *phy)
+static int ti_pipe3_dpll_wait_lock(struct ti_pipe3 *phy)
 {
 	u32		val;
 	unsigned long	timeout;
 
-	ti_pipe3_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
-
-	timeout = jiffies + msecs_to_jiffies(20);
+	timeout = jiffies + msecs_to_jiffies(PLL_LOCK_TIME);
 	do {
+		cpu_relax();
 		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
 		if (val & PLL_LOCK)
 			break;
-	} while (!WARN_ON(time_after(jiffies, timeout)));
+	} while (!time_after(jiffies, timeout));
+
+	if (!(val & PLL_LOCK)) {
+		dev_err(phy->dev, "DPLL failed to lock\n");
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
-static int ti_pipe3_dpll_lock(struct ti_pipe3 *phy)
+static int ti_pipe3_dpll_program(struct ti_pipe3 *phy)
 {
 	u32			val;
 	struct pipe3_dpll_params *dpll_params;
@@ -230,27 +204,65 @@ static int ti_pipe3_dpll_lock(struct ti_pipe3 *phy)
 	val |= dpll_params->sd << PLL_SD_SHIFT;
 	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
 
-	ti_pipe3_dpll_relock(phy);
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
 
-	return 0;
+	return ti_pipe3_dpll_wait_lock(phy);
 }
 
 static int ti_pipe3_init(struct phy *x)
 {
 	struct ti_pipe3 *phy = phy_get_drvdata(x);
-	int ret;
+	u32 val;
+	int ret = 0;
 
-	ret = ti_pipe3_dpll_lock(phy);
-	if (ret)
-		return ret;
+	/* Bring it out of IDLE if it is IDLE */
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
+	if (val & PLL_IDLE) {
+		val &= ~PLL_IDLE;
+		ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
+		ret = ti_pipe3_dpll_wait_lock(phy);
+	}
 
-	omap_control_phy_power(phy->control_dev, 1);
+	/* Program the DPLL only if not locked */
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
+	if (!(val & PLL_LOCK))
+		if (ti_pipe3_dpll_program(phy))
+			return -EINVAL;
 
-	return 0;
+	return ret;
 }
 
+static int ti_pipe3_exit(struct phy *x)
+{
+	struct ti_pipe3 *phy = phy_get_drvdata(x);
+	u32 val;
+	unsigned long timeout;
+
+	/* Put DPLL in IDLE mode */
+	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
+	val |= PLL_IDLE;
+	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
+
+	/* wait for LDO and Oscillator to power down */
+	timeout = jiffies + msecs_to_jiffies(PLL_IDLE_TIME);
+	do {
+		cpu_relax();
+		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
+		if ((val & PLL_TICOPWDN) && (val & PLL_LDOPWDN))
+			break;
+	} while (!time_after(jiffies, timeout));
+
+	if (!(val & PLL_TICOPWDN) || !(val & PLL_LDOPWDN)) {
+		dev_err(phy->dev, "Failed to power down: PLL_STATUS 0x%x\n",
+			val);
+		return -EBUSY;
+	}
+
+	return 0;
+}
 static struct phy_ops ops = {
 	.init		= ti_pipe3_init,
+	.exit		= ti_pipe3_exit,
 	.power_on	= ti_pipe3_power_on,
 	.power_off	= ti_pipe3_power_off,
 	.owner		= THIS_MODULE,
-- 
1.8.3.2

