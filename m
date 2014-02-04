Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936048AbaBDWeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:34:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933791AbaBDVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:07:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        robert.hodaszi@digi.com, Peter Chen <peter.chen@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.12 014/133] usb: chipidea: add freescale imx28 special write register method
Date: Tue,  4 Feb 2014 13:06:55 -0800
Message-Id: <20140204210737.424393449@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/chipidea/ci.h    |   26 ++++++++++++++++++++++++--
 drivers/usb/chipidea/core.c  |    2 ++
 drivers/usb/chipidea/host.c  |    1 +
 include/linux/usb/chipidea.h |    1 +
 4 files changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -135,6 +135,7 @@ struct hw_bank {
  * @id_event: indicates there is an id event, and handled at ci_otg_work
  * @b_sess_valid_event: indicates there is a vbus event, and handled
  * at ci_otg_work
+ * @imx28_write_fix: Freescale imx28 needs swp instruction for writing
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -173,6 +174,7 @@ struct ci_hdrc {
 	struct dentry			*debugfs;
 	bool				id_event;
 	bool				b_sess_valid_event;
+	bool				imx28_write_fix;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
@@ -253,6 +255,26 @@ static inline u32 hw_read(struct ci_hdrc
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
@@ -266,7 +288,7 @@ static inline void hw_write(struct ci_hd
 		data = (ioread32(ci->hw_bank.regmap[reg]) & ~mask)
 			| (data & mask);
 
-	iowrite32(data, ci->hw_bank.regmap[reg]);
+	__hw_write(ci, data, ci->hw_bank.regmap[reg]);
 }
 
 /**
@@ -281,7 +303,7 @@ static inline u32 hw_test_and_clear(stru
 {
 	u32 val = ioread32(ci->hw_bank.regmap[reg]) & mask;
 
-	iowrite32(val, ci->hw_bank.regmap[reg]);
+	__hw_write(ci, val, ci->hw_bank.regmap[reg]);
 	return val;
 }
 
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -497,6 +497,8 @@ static int ci_hdrc_probe(struct platform
 		ci->transceiver = ci->platdata->phy;
 	else
 		ci->global_phy = true;
+	ci->imx28_write_fix = !!(ci->platdata->flags &
+		CI_HDRC_IMX28_WRITE_FIX);
 
 	ret = hw_device_init(ci, base);
 	if (ret < 0) {
--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -65,6 +65,7 @@ static int host_start(struct ci_hdrc *ci
 	ehci->caps = ci->hw_bank.cap;
 	ehci->has_hostpc = ci->hw_bank.lpm;
 	ehci->has_tdi_phy_lpm = ci->hw_bank.lpm;
+	ehci->imx28_write_fix = ci->imx28_write_fix;
 
 	if (ci->platdata->reg_vbus) {
 		ret = regulator_enable(ci->platdata->reg_vbus);
--- a/include/linux/usb/chipidea.h
+++ b/include/linux/usb/chipidea.h
@@ -24,6 +24,7 @@ struct ci_hdrc_platform_data {
 	 * but otg is not supported (no register otgsc).
 	 */
 #define CI_HDRC_DUAL_ROLE_NOT_OTG	BIT(4)
+#define CI_HDRC_IMX28_WRITE_FIX		BIT(5)
 	enum usb_dr_mode	dr_mode;
 #define CI_HDRC_CONTROLLER_RESET_EVENT		0
 #define CI_HDRC_CONTROLLER_STOPPED_EVENT	1


