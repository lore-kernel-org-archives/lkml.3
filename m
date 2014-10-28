Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbaJ1LQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:16:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:24439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbaJ1LPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="597574386"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / GPIO: Pass index to acpi_get_gpiod_by_index() when using properties
Date: Tue, 28 Oct 2014 13:15:27 +0200
Message-Id: <1414494927-204923-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_dev_add_driver_gpios() makes it possible to set up mapping between
properties and ACPI GpioIo resources in a driver, so we can take index
parameter in acpi_find_gpio() into use with _DSD device properties now.

This index can be used to select a GPIO from a property with multiple
GPIOs:

  Package () {
  	"data-gpios",
  	Package () {
  		\_SB.GPIO, 0, 0, 0,
  		\_SB.GPIO, 1, 0, 0,
  		\_SB.GPIO, 2, 0, 1,
  	}
  }

In order to retrieve the last GPIO from a driver we can simply do:

  desc = devm_gpiod_get_index(dev, "data", 2);

and so on.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
This is on top of latest linux-pm/device-properties.

 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index fbf717a56b0a..58659dbe702a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1522,7 +1522,7 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
 				 suffixes[i]);
 		}
 
-		desc = acpi_get_gpiod_by_index(adev, propname, 0, &info);
+		desc = acpi_get_gpiod_by_index(adev, propname, idx, &info);
 		if (!IS_ERR(desc) || (PTR_ERR(desc) == -EPROBE_DEFER))
 			break;
 	}
-- 
2.1.1

