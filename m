Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab3IRUII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:08:08 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33291 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab3IRUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:08:06 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Juha Yrjola <juha.yrjola@solidboot.com>
Subject: [PATCH 1/2] hwrng: OMAP3 ROM Random Number Generator support
Date: Wed, 18 Sep 2013 22:05:56 +0200
Message-Id: <1379534757-20870-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
References: <201303281854.02847@pali>
 <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver provides kernel-side support for the Random Number
Generator hardware found on OMAP34xx processors.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
---
 drivers/char/hw_random/Kconfig         |   13 +++
 drivers/char/hw_random/Makefile        |    1 +
 drivers/char/hw_random/omap3-rom-rng.c |  145 ++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)
 create mode 100644 drivers/char/hw_random/omap3-rom-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 0aa9d91..0a331c3 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -165,6 +165,19 @@ config HW_RANDOM_OMAP
 
  	  If unsure, say Y.
 
+config HW_RANDOM_OMAP3_ROM
+	tristate "OMAP3 ROM Random Number Generator support"
+	depends on HW_RANDOM && ARCH_OMAP3
+	default HW_RANDOM
+	---help---
+	  This driver provides kernel-side support for the Random Number
+	  Generator hardware found on OMAP34xx processors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called omap3-rom-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_OCTEON
 	tristate "Octeon Random Number Generator support"
 	depends on HW_RANDOM && CAVIUM_OCTEON_SOC
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index bed467c..7c8aa80 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -15,6 +15,7 @@ n2-rng-y := n2-drv.o n2-asm.o
 obj-$(CONFIG_HW_RANDOM_VIA) += via-rng.o
 obj-$(CONFIG_HW_RANDOM_IXP4XX) += ixp4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_OMAP) += omap-rng.o
+obj-$(CONFIG_HW_RANDOM_OMAP3_ROM) += omap3-rom-rng.o
 obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
 obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
 obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
diff --git a/drivers/char/hw_random/omap3-rom-rng.c b/drivers/char/hw_random/omap3-rom-rng.c
new file mode 100644
index 0000000..a9dbb2d
--- /dev/null
+++ b/drivers/char/hw_random/omap3-rom-rng.c
@@ -0,0 +1,145 @@
+/*
+ * omap3-rom-rng.c - RNG driver for TI OMAP3 CPU family
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Juha Yrjola <juha.yrjola@solidboot.com>
+ *
+ * Copyright (C) 2013 Pali Rohár <pali.rohar@gmail.com>
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/random.h>
+#include <linux/hw_random.h>
+#include <linux/timer.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
+#define RNG_RESET			0x01
+#define RNG_GEN_PRNG_HW_INIT		0x02
+#define RNG_GEN_HW			0x08
+
+static const char *omap3_rom_rng_name = "OMAP3 ROM RNG";
+
+/* param1: ptr, param2: count, param3: flag */
+static u32 (*omap3_rom_rng_call)(u32, u32, u32);
+
+static struct timer_list idle_timer;
+static int rng_idle;
+static struct clk *rng_clk;
+
+static void omap3_rom_rng_idle(unsigned long data)
+{
+	int r;
+
+	r = omap3_rom_rng_call(0, 0, RNG_RESET);
+	if (r != 0) {
+		printk(KERN_ERR "%s: reset failed: %d\n",
+		       omap3_rom_rng_name, r);
+		return;
+	}
+	clk_disable_unprepare(rng_clk);
+	rng_idle = 1;
+}
+
+static int omap3_rom_rng_get_random(void *buf, unsigned int count)
+{
+	u32 r;
+	u32 ptr;
+
+	del_timer_sync(&idle_timer);
+	if (rng_idle) {
+		clk_prepare_enable(rng_clk);
+		r = omap3_rom_rng_call(0, 0, RNG_GEN_PRNG_HW_INIT);
+		if (r != 0) {
+			clk_disable_unprepare(rng_clk);
+			printk(KERN_ERR "%s: HW init failed: %d\n",
+			       omap3_rom_rng_name, r);
+			return -EIO;
+		}
+		rng_idle = 0;
+	}
+
+	ptr = virt_to_phys(buf);
+	r = omap3_rom_rng_call(ptr, count, RNG_GEN_HW);
+	mod_timer(&idle_timer, jiffies + msecs_to_jiffies(500));
+	if (r != 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int omap3_rom_rng_data_present(struct hwrng *rng, int wait)
+{
+	return 1;
+}
+
+static int omap3_rom_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	int r;
+
+	r = omap3_rom_rng_get_random(data, 4);
+	if (r < 0)
+		return r;
+	return 4;
+}
+
+static struct hwrng omap3_rom_rng_ops = {
+	.name		= "omap3-rom",
+	.data_present	= omap3_rom_rng_data_present,
+	.data_read	= omap3_rom_rng_data_read,
+};
+
+static int omap3_rom_rng_probe(struct platform_device *pdev)
+{
+	printk(KERN_INFO "%s: initializing\n", omap3_rom_rng_name);
+
+	omap3_rom_rng_call = pdev->dev.platform_data;
+	if (!omap3_rom_rng_call) {
+		printk(KERN_ERR "%s: omap3_rom_rng_call is NULL\n",
+		       omap3_rom_rng_name);
+		return -EINVAL;
+	}
+
+	setup_timer(&idle_timer, omap3_rom_rng_idle, 0);
+	rng_clk = clk_get(&pdev->dev, "ick");
+	if (IS_ERR(rng_clk)) {
+		printk(KERN_ERR "%s: unable to get RNG clock\n",
+		       omap3_rom_rng_name);
+		return IS_ERR(rng_clk);
+	}
+
+	/* Leave the RNG in reset state. */
+	clk_prepare_enable(rng_clk);
+	omap3_rom_rng_idle(0);
+
+	return hwrng_register(&omap3_rom_rng_ops);
+}
+
+static int omap3_rom_rng_remove(struct platform_device *pdev)
+{
+	hwrng_unregister(&omap3_rom_rng_ops);
+	clk_disable_unprepare(rng_clk);
+	clk_put(rng_clk);
+	return 0;
+}
+
+static struct platform_driver omap3_rom_rng_driver = {
+	.driver = {
+		.name		= "omap3-rom-rng",
+		.owner		= THIS_MODULE,
+	},
+	.probe		= omap3_rom_rng_probe,
+	.remove		= omap3_rom_rng_remove,
+};
+
+module_platform_driver(omap3_rom_rng_driver);
+
+MODULE_ALIAS("platform:omap3-rom-rng");
+MODULE_AUTHOR("Juha Yrjola");
+MODULE_AUTHOR("Pali Rohár <pali.rohar@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

