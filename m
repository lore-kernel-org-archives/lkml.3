Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3KUOqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:46:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:38249 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab3KUOp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:45:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,744,1378882800"; 
   d="scan'208";a="439241459"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] mmc: sdhci-acpi: covert to use GPIO descriptor API
Date: Thu, 21 Nov 2013 16:45:50 +0200
Message-Id: <1385045153-25160-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new descriptor based GPIO interface is now the recommend and more safer
way of using GPIOs from device drivers. Convert the ACPI SDHCI driver to
use that interface.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/mmc/host/sdhci-acpi.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index ef19874fcd1f..379ddfe14bc7 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -31,10 +31,9 @@
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/acpi.h>
-#include <linux/acpi_gpio.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
@@ -199,22 +198,19 @@ static irqreturn_t sdhci_acpi_sd_cd(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int sdhci_acpi_add_own_cd(struct device *dev, int gpio,
-				 struct mmc_host *mmc)
+static int sdhci_acpi_add_own_cd(struct device *dev, struct mmc_host *mmc)
 {
+	struct gpio_desc *desc;
 	unsigned long flags;
 	int err, irq;
 
-	if (gpio < 0) {
-		err = gpio;
+	desc = devm_gpiod_get_index(dev, NULL, 0);
+	if (IS_ERR(desc)) {
+		err = PTR_ERR(desc);
 		goto out;
 	}
 
-	err = devm_gpio_request_one(dev, gpio, GPIOF_DIR_IN, "sd_cd");
-	if (err)
-		goto out;
-
-	irq = gpio_to_irq(gpio);
+	irq = gpiod_to_irq(desc);
 	if (irq < 0) {
 		err = irq;
 		goto out_free;
@@ -228,7 +224,7 @@ static int sdhci_acpi_add_own_cd(struct device *dev, int gpio,
 	return 0;
 
 out_free:
-	devm_gpio_free(dev, gpio);
+	devm_gpiod_put(dev, desc);
 out:
 	dev_warn(dev, "failed to setup card detect wake up\n");
 	return err;
@@ -254,7 +250,7 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
 	struct resource *iomem;
 	resource_size_t len;
 	const char *hid;
-	int err, gpio;
+	int err;
 
 	if (acpi_bus_get_device(handle, &device))
 		return -ENODEV;
@@ -279,8 +275,6 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
 	if (IS_ERR(host))
 		return PTR_ERR(host);
 
-	gpio = acpi_get_gpio_by_index(dev, 0, NULL);
-
 	c = sdhci_priv(host);
 	c->host = host;
 	c->slot = sdhci_acpi_get_slot(handle, hid);
@@ -338,7 +332,7 @@ static int sdhci_acpi_probe(struct platform_device *pdev)
 		goto err_free;
 
 	if (sdhci_acpi_flag(c, SDHCI_ACPI_SD_CD)) {
-		if (sdhci_acpi_add_own_cd(dev, gpio, host->mmc))
+		if (sdhci_acpi_add_own_cd(dev, host->mmc))
 			c->use_runtime_pm = false;
 	}
 
-- 
1.8.4.3

