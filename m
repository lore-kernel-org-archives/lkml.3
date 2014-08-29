Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaH1Oza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:55:30 -0400
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:50507 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034AbaH1Oz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:55:27 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 4/4] pinctrl: qcom: Add support for reset for apq8064
Date: Thu, 28 Aug 2014 20:22:50 -0700
Message-Id: <1409282570-27299-5-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409282570-27299-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409282570-27299-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for reset functions to reboot the boards
with soc apq8064.

CC: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Stephen Boyd <sboyd@codeaurora.org>
CC: Andy Gross <agross@codeaurora.org>
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/pinctrl/qcom/pinctrl-apq8064.c |    7 +++++-
 drivers/pinctrl/qcom/pinctrl-msm.c     |   38 ++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
index feb6f15..ef1263c 100644
--- a/drivers/pinctrl/qcom/pinctrl-apq8064.c
+++ b/drivers/pinctrl/qcom/pinctrl-apq8064.c
@@ -324,6 +324,7 @@ enum apq8064_functions {
 	APQ_MUX_tsif1,
 	APQ_MUX_tsif2,
 	APQ_MUX_usb2_hsic,
+	APQ_MUX_ps_hold,
 	APQ_MUX_NA,
 };
 
@@ -351,6 +352,9 @@ static const char * const gpio_groups[] = {
 	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
 	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89"
 };
+static const char * const ps_hold_groups[] = {
+	"gpio78"
+};
 static const char * const gsbi1_groups[] = {
 	"gpio18", "gpio19", "gpio20", "gpio21"
 };
@@ -477,6 +481,7 @@ static const struct msm_function apq8064_functions[] = {
 	FUNCTION(tsif1),
 	FUNCTION(tsif2),
 	FUNCTION(usb2_hsic),
+	FUNCTION(ps_hold),
 };
 
 static const struct msm_pingroup apq8064_groups[] = {
@@ -558,7 +563,7 @@ static const struct msm_pingroup apq8064_groups[] = {
 	PINGROUP(75, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(76, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(77, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
-	PINGROUP(78, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
+	PINGROUP(78, ps_hold, NA, NA, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(79, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(80, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(81, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 2738108..be43e7a 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -12,6 +12,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -27,12 +28,17 @@
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
 
+#include <asm/system_misc.h>
+
 #include "../core.h"
 #include "../pinconf.h"
 #include "pinctrl-msm.h"
 #include "../pinctrl-utils.h"
 
 #define MAX_NR_GPIO 300
+#define PS_HOLD_OFFSET 0x820
+
+static void __iomem *msm_ps_hold;
 
 /**
  * struct msm_pinctrl - state for a pinctrl-msm device
@@ -848,10 +854,31 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	return 0;
 }
 
+static void qcom_reset(enum reboot_mode reboot_mode, const char *cmd)
+{
+	writel(0, msm_ps_hold);
+	mdelay(10000);
+}
+
+const struct msm_function
+*find_pshold_function(const struct msm_function *functions,
+					unsigned nfunctions, const char *name)
+{
+	int i = 0;
+	const struct msm_function *func;
+
+	for (func = functions; i <= nfunctions; func++, i++)
+		if (!strcmp(func->name, name))
+			return func;
+
+	return NULL;
+}
+
 int msm_pinctrl_probe(struct platform_device *pdev,
 		      const struct msm_pinctrl_soc_data *soc_data)
 {
 	struct msm_pinctrl *pctrl;
+	const struct msm_function *func;
 	struct resource *res;
 	int ret;
 
@@ -871,6 +898,17 @@ int msm_pinctrl_probe(struct platform_device *pdev,
 	if (IS_ERR(pctrl->regs))
 		return PTR_ERR(pctrl->regs);
 
+#ifdef CONFIG_ARM
+	func = find_pshold_function(soc_data->functions,
+					soc_data->nfunctions, "ps_hold");
+	if (func) {
+		dev_dbg(&pdev->dev, "Found Function %s\n", func->name);
+		msm_ps_hold = pctrl->regs + PS_HOLD_OFFSET;
+		arm_pm_restart = qcom_reset;
+	}
+#else
+#error "not supported on this arch"
+#endif
 	pctrl->irq = platform_get_irq(pdev, 0);
 	if (pctrl->irq < 0) {
 		dev_err(&pdev->dev, "No interrupt defined for msmgpio\n");
-- 
1.7.0.4

