Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaHSKrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 06:47:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:39797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbaHSKq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 06:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="586838238"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: Linus <linus.walleij@linaro.org>
Cc: <mika.westerberg@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCHv2] gpio-lynxpoint: enable input sensing in resume
Date: Tue, 19 Aug 2014 14:00:01 +0300
Message-Id: <1408446001-4998-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that input sensing bit might be reset during
suspend/resume. Set input sensing again for all requested gpios
in resume

Tested-by: Jerome Blin <jerome.blin@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/gpio/gpio-lynxpoint.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpio/gpio-lynxpoint.c b/drivers/gpio/gpio-lynxpoint.c
index ff9eb91..fa945ec 100644
--- a/drivers/gpio/gpio-lynxpoint.c
+++ b/drivers/gpio/gpio-lynxpoint.c
@@ -407,9 +407,27 @@ static int lp_gpio_runtime_resume(struct device *dev)
 	return 0;
 }
 
+static int lp_gpio_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct lp_gpio *lg = platform_get_drvdata(pdev);
+	unsigned long reg;
+	int i;
+
+	/* on some hardware suspend clears input sensing, re-enable it here */
+	for (i = 0; i < lg->chip.ngpio; i++) {
+		if (gpiochip_is_requested(&lg->chip, i) != NULL) {
+			reg = lp_gpio_reg(&lg->chip, i, LP_CONFIG2);
+			outl(inl(reg) & ~GPINDIS_BIT, reg);
+		}
+	}
+	return 0;
+}
+
 static const struct dev_pm_ops lp_gpio_pm_ops = {
 	.runtime_suspend = lp_gpio_runtime_suspend,
 	.runtime_resume = lp_gpio_runtime_resume,
+	.resume = lp_gpio_resume,
 };
 
 static const struct acpi_device_id lynxpoint_gpio_acpi_match[] = {
-- 
1.8.3.2

