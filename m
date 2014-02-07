Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaBGMlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:41:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaBGLuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: robert.hodaszi@digi.com, Peter Chen <peter.chen@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 122/233] usb: chipidea: add freescale imx28 special write register method
Date: Fri,  7 Feb 2014 11:45:41 +0000
Message-Id: <1391773652-25214-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit ed8f8318d2ef3e5f9e4ddf79349508c116b68d7f upstream.

According to Freescale imx28 Errata, "ENGR119653 USB: ARM to USB
register error issue", All USB register write operations must
use the ARM SWP instruction. So, we implement special hw_write
and hw_test_and_clear for imx28.

Discussion for it at below:
http://marc.info/?l=linux-usb&m=137996395529294&w=2

This patch is needed for stable tree 3.11+.

Cc: robert.hodaszi@digi.com
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/chipidea/ci.h    | 26 ++++++++++++++++++++++++--
 drivers/usb/chipidea/core.c  |  2 ++
 drivers/usb/chipidea/host.c  |  1 +
 include/linux/usb/chipidea.h |  1 +
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 33cb29f..7a36c23 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -132,6 +132,7 @@ struct hw_bank {
  * @transceiver: pointer to USB PHY, if any
  * @hcd: pointer to usb_hcd for ehci host driver
  * @debugfs: root dentry for this controller in debugfs
+ * @imx28_write_fix: Freescale imx28 needs swp instruction for writing
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -168,6 +169,7 @@ struct ci_hdrc {
 	struct usb_phy			*transceiver;
 	struct usb_hcd			*hcd;
 	struct dentry			*debugfs;
+	bool				imx28_write_fix;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
@@ -248,6 +250,26 @@ static inline u32 hw_read(struct ci_hdrc *ci, enum ci_hw_regs reg, u32 mask)
 	return ioread32(ci->hw_bank.regmap[reg]) & mask;
 }
 
+#ifdef CONFIG_SOC_IMX28
+static inline void imx28_ci_writel(u32 val, volatile void __iomem *addr)
+{
+	__asm__ ("swp %0, %0, [%1]" : : "r"(val), "r"(addr));
+}
+#else
+static inline void imx28_ci_writel(u32 val, volatile void __iomem *addr)
+{
+}
+#endif
+
+static inline void __hw_write(struct ci_hdrc *ci, u32 val,
+		void __iomem *addr)
+{
+	if (ci->imx28_write_fix)
+		imx28_ci_writel(val, addr);
+	else
+		iowrite32(val, addr);
+}
+
 /**
  * hw_write: writes to a hw register
  * @reg:  register index
@@ -261,7 +283,7 @@ static inline void hw_write(struct ci_hdrc *ci, enum ci_hw_regs reg,
 		data = (ioread32(ci->hw_bank.regmap[reg]) & ~mask)
 			| (data & mask);
 
-	iowrite32(data, ci->hw_bank.regmap[reg]);
+	__hw_write(ci, data, ci->hw_bank.regmap[reg]);
 }
 
 /**
@@ -276,7 +298,7 @@ static inline u32 hw_test_and_clear(struct ci_hdrc *ci, enum ci_hw_regs reg,
 {
 	u32 val = ioread32(ci->hw_bank.regmap[reg]) & mask;
 
-	iowrite32(val, ci->hw_bank.regmap[reg]);
+	__hw_write(ci, val, ci->hw_bank.regmap[reg]);
 	return val;
 }
 
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index a5df24c..f698637 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -432,6 +432,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		ci->transceiver = ci->platdata->phy;
 	else
 		ci->global_phy = true;
+	ci->imx28_write_fix = !!(ci->platdata->flags &
+		CI_HDRC_IMX28_WRITE_FIX);
 
 	ret = hw_device_init(ci, base);
 	if (ret < 0) {
diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
index 40d0fda..309c4ab 100644
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -63,6 +63,7 @@ static int host_start(struct ci_hdrc *ci)
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = ci->hw_bank.cap;
 	ehci->has_hostpc = ci->hw_bank.lpm;
+	ehci->imx28_write_fix = ci->imx28_write_fix;
 
 	ret = usb_add_hcd(hcd, 0, 0);
 	if (ret)
diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
index 2562994..2196bc1 100644
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -20,6 +20,7 @@ struct ci_hdrc_platform_data {
 #define CI_HDRC_REQUIRE_TRANSCEIVER	BIT(1)
 #define CI_HDRC_PULLUP_ON_VBUS		BIT(2)
 #define CI_HDRC_DISABLE_STREAMING	BIT(3)
+#define CI_HDRC_IMX28_WRITE_FIX		BIT(5)
 	enum usb_dr_mode	dr_mode;
 #define CI_HDRC_CONTROLLER_RESET_EVENT		0
 #define CI_HDRC_CONTROLLER_STOPPED_EVENT	1
-- 
1.8.3.2

