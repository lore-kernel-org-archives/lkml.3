Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaJMTUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:20:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:8440 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaJMTUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:20:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,712,1406617200"; 
   d="scan'208";a="588213547"
From: David Cohen <david.a.cohen@linux.intel.com>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC/PATCH] gpio/pinctrl: baytrail: move gpio driver from pinctrl to gpio directory
Date: Mon, 13 Oct 2014 12:17:37 -0700
Message-Id: <1413227857-555-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though GPIO module on Intel Bay Trail is able to control pin
functionality, it's unlikely Linux kernel driver will ever support it
since BIOS should handle all pin muxing itself.

Currently this driver does not register any pinctrl interface and
doesn't call any pinctrl interface. It just uses on internal functions
the 'struct pinctrl_gpio_range', which is a weak justification to not be
under gpio directory.

Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/gpio/Kconfig                                         | 12 ++++++++++++
 drivers/gpio/Makefile                                        |  1 +
 drivers/{pinctrl/pinctrl-baytrail.c => gpio/gpio-baytrail.c} |  0
 drivers/pinctrl/Kconfig                                      | 12 ------------
 drivers/pinctrl/Makefile                                     |  1 -
 5 files changed, 13 insertions(+), 13 deletions(-)
 rename drivers/{pinctrl/pinctrl-baytrail.c => gpio/gpio-baytrail.c} (100%)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0959ca9b6b27..c0e2f5647d6a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -738,6 +738,18 @@ config GPIO_AMD8111
 
 	  If unsure, say N
 
+config GPIO_BAYTRAIL
+	bool "Intel Baytrail GPIO pin control"
+	depends on ACPI && X86
+	select GPIOLIB_IRQCHIP
+	help
+	  driver for memory mapped GPIO functionality on Intel Baytrail
+	  platforms. Supports 3 banks with 102, 28 and 44 gpios.
+	  Most pins are usually muxed to some other functionality by firmware,
+	  so only a small amount is available for gpio use.
+
+	  Requires ACPI device enumeration code to set up a platform device.
+
 config GPIO_INTEL_MID
 	bool "Intel Mid GPIO support"
 	depends on PCI && X86
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index e5d346cf3b6e..21fc2a4baa6f 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
 obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
 obj-$(CONFIG_GPIO_AMD8111)	+= gpio-amd8111.o
 obj-$(CONFIG_GPIO_ARIZONA)	+= gpio-arizona.o
+obj-$(CONFIG_GPIO_BAYTRAIL)	+= gpio-baytrail.o
 obj-$(CONFIG_GPIO_BCM_KONA)	+= gpio-bcm-kona.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/gpio/gpio-baytrail.c
similarity index 100%
rename from drivers/pinctrl/pinctrl-baytrail.c
rename to drivers/gpio/gpio-baytrail.c
diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index c6a66de6ed72..de65d26f5538 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -67,18 +67,6 @@ config PINCTRL_AT91
 	help
 	  Say Y here to enable the at91 pinctrl driver
 
-config PINCTRL_BAYTRAIL
-	bool "Intel Baytrail GPIO pin control"
-	depends on GPIOLIB && ACPI && X86
-	select GPIOLIB_IRQCHIP
-	help
-	  driver for memory mapped GPIO functionality on Intel Baytrail
-	  platforms. Supports 3 banks with 102, 28 and 44 gpios.
-	  Most pins are usually muxed to some other functionality by firmware,
-	  so only a small amount is available for gpio use.
-
-	  Requires ACPI device enumeration code to set up a platform device.
-
 config PINCTRL_BCM2835
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 51f52d32859e..0936d42f0b51 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -15,7 +15,6 @@ obj-$(CONFIG_PINCTRL_BF54x)	+= pinctrl-adi2-bf54x.o
 obj-$(CONFIG_PINCTRL_BF60x)	+= pinctrl-adi2-bf60x.o
 obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
 obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
-obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
 obj-$(CONFIG_PINCTRL_BCM281XX)	+= pinctrl-bcm281xx.o
 obj-$(CONFIG_PINCTRL_FALCON)	+= pinctrl-falcon.o
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
-- 
2.1.0

