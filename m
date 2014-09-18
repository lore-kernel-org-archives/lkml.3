Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbaIRWjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:39:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39883 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbaIRWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:39:11 -0400
From: Josh Cartwright <joshc@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] pinctrl: qcom: use restart_notifier mechanism for ps_hold
Date: Thu, 18 Sep 2014 17:32:59 -0500
Message-Id: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By converting to the restart_notifier mechanism for restart, we allow
for other mechanisms, like the watchdog, to be used for restart in the
case where PS_HOLD has failed to reset the chip.

Choose priority 128, as according to documentation, this mechanism "is
sufficient to restart the entire system".

Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index d5ed127..9fced3b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -27,8 +27,7 @@
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-
-#include <asm/system_misc.h>
+#include <linux/reboot.h>
 
 #include "../core.h"
 #include "../pinconf.h"
@@ -43,6 +42,7 @@
  * @dev:            device handle.
  * @pctrl:          pinctrl handle.
  * @chip:           gpiochip handle.
+ * @restart_nb:     restart notifier block.
  * @irq:            parent irq for the TLMM irq_chip.
  * @lock:           Spinlock to protect register resources as well
  *                  as msm_pinctrl data structures.
@@ -56,6 +56,7 @@ struct msm_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctrl;
 	struct gpio_chip chip;
+	struct notifier_block restart_nb;
 	int irq;
 
 	spinlock_t lock;
@@ -852,13 +853,14 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	return 0;
 }
 
-#ifdef CONFIG_ARM
-static void __iomem *msm_ps_hold;
-
-static void msm_reset(enum reboot_mode reboot_mode, const char *cmd)
+static int msm_ps_hold_restart(struct notifier_block *nb, unsigned long action,
+			       void *data)
 {
-	writel(0, msm_ps_hold);
+	struct msm_pinctrl *pctrl = container_of(nb, struct msm_pinctrl, restart_nb);
+
+	writel(0, pctrl->regs + PS_HOLD_OFFSET);
 	mdelay(10000);
+	return NOTIFY_DONE;
 }
 
 static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
@@ -868,13 +870,16 @@ static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
 
 	for (; i <= pctrl->soc->nfunctions; i++)
 		if (!strcmp(func[i].name, "ps_hold")) {
-			msm_ps_hold = pctrl->regs + PS_HOLD_OFFSET;
-			arm_pm_restart = msm_reset;
+			pctrl->restart_nb.notifier_call = msm_ps_hold_restart;
+			pctrl->restart_nb.priority = 128;
+			if (register_restart_handler(&pctrl->restart_nb)) {
+				dev_err(pctrl->dev,
+					"failed to setup restart handler.\n");
+				pctrl->restart_nb.notifier_call = NULL;
+			}
+			break;
 		}
 }
-#else
-static void msm_pinctrl_setup_pm_reset(const struct msm_pinctrl *pctrl) {}
-#endif
 
 int msm_pinctrl_probe(struct platform_device *pdev,
 		      const struct msm_pinctrl_soc_data *soc_data)
@@ -943,6 +948,15 @@ int msm_pinctrl_remove(struct platform_device *pdev)
 
 	pinctrl_unregister(pctrl->pctrl);
 
+	if (pctrl->restart_nb.notifier_call) {
+		ret = unregister_restart_handler(&pctrl->restart_nb);
+		if (ret) {
+			dev_err(&pdev->dev,
+				"unable to unregister restart handler\n");
+			return ret;
+		}
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(msm_pinctrl_remove);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

