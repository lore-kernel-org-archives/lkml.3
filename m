Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaH2Ocr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:32:47 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:59640 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877AbaH2Oco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:32:44 -0400
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
Subject: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
Date: Fri, 29 Aug 2014 20:00:59 +0530
Message-Id: <1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
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
 drivers/pinctrl/qcom/pinctrl-apq8064.c |    7 ++++++-
 drivers/pinctrl/qcom/pinctrl-msm.c     |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletions(-)

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
index 9175bbc..80a64ca 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -12,6 +12,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -27,12 +28,15 @@
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
 
 /**
  * struct msm_pinctrl - state for a pinctrl-msm device
@@ -850,6 +854,30 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	return 0;
 }
 
+#ifdef CONFIG_ARM
+static void __iomem *msm_ps_hold;
+
+static void msm_reset(enum reboot_mode reboot_mode, const char *cmd)
+{
+	writel(0, msm_ps_hold);
+	mdelay(10000);
+}
+
+static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
+{
+	int i = 0;
+	const struct msm_function *func = pctrl->soc->functions;
+
+	for (; i <= pctrl->soc->nfunctions; i++)
+		if (!strcmp(func[i].name, "ps_hold")) {
+			msm_ps_hold = pctrl->regs + PS_HOLD_OFFSET;
+			arm_pm_restart = msm_reset;
+		}
+}
+#else
+static void msm_pinctrl_setup_pm_reset(const struct msm_pinctrl *pctrl) {}
+#endif
+
 int msm_pinctrl_probe(struct platform_device *pdev,
 		      const struct msm_pinctrl_soc_data *soc_data)
 {
@@ -873,6 +901,8 @@ int msm_pinctrl_probe(struct platform_device *pdev,
 	if (IS_ERR(pctrl->regs))
 		return PTR_ERR(pctrl->regs);
 
+	msm_pinctrl_setup_pm_reset(pctrl);
+
 	pctrl->irq = platform_get_irq(pdev, 0);
 	if (pctrl->irq < 0) {
 		dev_err(&pdev->dev, "No interrupt defined for msmgpio\n");
-- 
1.7.0.4

