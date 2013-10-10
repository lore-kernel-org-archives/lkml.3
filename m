Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3JJIBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:01:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:24586 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab3JJIBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:01:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="408711251"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 5/5] gpiolib / ACPI: document the GPIO descriptor based interface
Date: Thu, 10 Oct 2013 11:01:11 +0300
Message-Id: <1381392071-21407-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the existing ACPI specific GPIO interface, document the new
descriptor based GPIO interface in Documentation/acpi/enumeration.txt, so
it is clear that this new interface is preferred over the ACPI specific
version.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/acpi/enumeration.txt | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index aca4e69..b994bcb 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -295,10 +295,6 @@ These GPIO numbers are controller relative and path "\\_SB.PCI0.GPI0"
 specifies the path to the controller. In order to use these GPIOs in Linux
 we need to translate them to the Linux GPIO numbers.
 
-The driver can do this by including <linux/acpi_gpio.h> and then calling
-acpi_get_gpio(path, gpio). This will return the Linux GPIO number or
-negative errno if there was no translation found.
-
 In a simple case of just getting the Linux GPIO number from device
 resources one can use acpi_get_gpio_by_index() helper function. It takes
 pointer to the device and index of the GpioIo/GpioInt descriptor in the
@@ -322,3 +318,25 @@ suitable to the gpiolib before passing them.
 
 In case of GpioInt resource an additional call to gpio_to_irq() must be
 done before calling request_irq().
+
+Note that the above API is ACPI specific and not recommended for drivers
+that need to support non-ACPI systems. The recommended way is to use
+the descriptor based GPIO interfaces. The above example looks like this
+when converted to the GPIO desc:
+
+	#include <linux/gpio/consumer.h>
+	...
+
+	struct gpio_desc *irq_desc, *power_desc;
+
+	irq_desc = gpiod_get_index(dev, NULL, 1);
+	if (IS_ERR(irq_desc))
+		/* handle error */
+
+	power_desc = gpiod_get_index(dev, NULL, 0);
+	if (IS_ERR(power_desc))
+		/* handle error */
+
+	/* Now we can use the GPIO descriptors */
+
+See also Documentation/gpio.txt.
-- 
1.8.4.rc3

