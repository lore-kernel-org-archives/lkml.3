Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab3EWQi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:38:57 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:56492 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753783Ab3EWQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:38:56 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [RESEND PATCH] pwm: pwm-atmel-tcb: pinctrl support
Date: Thu, 23 May 2013 18:38:52 +0200
Message-Id: <1369327132-31935-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 5099763628279903254
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I sent a patch 1 month ago to add pinctrl support to pwm-atmel-tcb
driver and didn't get any review.

Could you take a look?

This patch adds pins request for the pwm device exposed by the TC
block using the pinctrl subsystem.


Best Regards,

Boris

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/pwm/pwm-atmel-tcb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index 16cb530..985b7bf 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -21,6 +21,7 @@
 #include <linux/pwm.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
+#include <linux/pinctrl/consumer.h>
 
 #define NPWM	6
 
@@ -365,6 +366,7 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	struct atmel_tcb_pwm_chip *tcbpwm;
 	struct device_node *np = pdev->dev.of_node;
 	struct atmel_tc *tc;
+	struct pinctrl *pinctrl;
 	int err;
 	int tcblock;
 
@@ -389,6 +391,13 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl)) {
+		atmel_tc_free(tc);
+		dev_err(&pdev->dev, "failed to get pinctrl config\n");
+		return PTR_ERR(pinctrl);
+	}
+
 	tcbpwm->chip.dev = &pdev->dev;
 	tcbpwm->chip.ops = &atmel_tcb_pwm_ops;
 	tcbpwm->chip.of_xlate = of_pwm_xlate_with_flags;
-- 
1.7.9.5

