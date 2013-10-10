Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3JJIB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:01:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:13269 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab3JJIBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:01:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="306008331"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 3/5] gpiolib / ACPI: add ACPI support for gpiod_get_index()
Date: Thu, 10 Oct 2013 11:01:09 +0300
Message-Id: <1381392071-21407-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiod_get_index() and gpiod_get() are now the new preferred way to request
GPIOs. Add support for finding the corresponding GPIO descriptor from ACPI
namespace.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index e2a2cdd..1e099de 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/of_gpio.h>
+#include <linux/acpi_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
 
@@ -2111,6 +2112,12 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *id,
 }
 #endif
 
+static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
+					unsigned int idx, unsigned long *flags)
+{
+	return acpi_get_gpiod_by_index(dev, idx, NULL);
+}
+
 static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
 				    unsigned int idx, unsigned long *flags)
 {
@@ -2192,6 +2199,9 @@ struct gpio_desc *__must_check gpiod_get_index(struct device *dev,
 	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node) {
 		dev_dbg(dev, "using device tree for GPIO lookup\n");
 		desc = of_find_gpio(dev, con_id, idx, &flags);
+	} else if (IS_ENABLED(CONFIG_ACPI) && dev && ACPI_HANDLE(dev)) {
+		dev_dbg(dev, "using ACPI for GPIO lookup\n");
+		desc = acpi_find_gpio(dev, con_id, idx, &flags);
 	} else {
 		dev_dbg(dev, "using lookup tables for GPIO lookup");
 		desc = gpiod_find(dev, con_id, idx, &flags);
-- 
1.8.4.rc3

