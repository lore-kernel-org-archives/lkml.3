Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab3IZGbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:31:32 -0400
Received: from ozlabs.org ([203.10.76.45]:47275 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab3IZGba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:31:30 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, gleb@redhat.com,
        pbonzini@redhat.com, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, <linuxppc-dev@ozlabs.org>,
        <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>, tytso@mit.edu
Subject: [PATCH 2/3] hwrng: Add a driver for the hwrng found in power7+ systems
Date: Thu, 26 Sep 2013 16:31:05 +1000
Message-Id: <1380177066-3835-2-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the hwrng found in power7+ systems, based on the
existing code for the arch_get_random_long() hook.

We only register a single instance of the driver, not one per device,
because we use the existing per_cpu array of devices in the arch code.
This means we always read from the "closest" device, avoiding inter-chip
memory traffic.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 drivers/char/hw_random/Kconfig       | 13 ++++++
 drivers/char/hw_random/Makefile      |  1 +
 drivers/char/hw_random/powernv-rng.c | 81 ++++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)
 create mode 100644 drivers/char/hw_random/powernv-rng.c

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 0aa9d91..c206de2 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -290,6 +290,19 @@ config HW_RANDOM_PSERIES
 
 	  If unsure, say Y.
 
+config HW_RANDOM_POWERNV
+	tristate "PowerNV Random Number Generator support"
+	depends on HW_RANDOM && PPC_POWERNV
+	default HW_RANDOM
+	---help---
+	  This is the driver for Random Number Generator hardware found
+	  in POWER7+ and above machines for PowerNV platform.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called powernv-rng.
+
+	  If unsure, say Y.
+
 config HW_RANDOM_EXYNOS
 	tristate "EXYNOS HW random number generator support"
 	depends on HW_RANDOM && HAS_IOMEM && HAVE_CLK
diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
index bed467c..d7d2435 100644
--- a/drivers/char/hw_random/Makefile
+++ b/drivers/char/hw_random/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
 obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
 obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
 obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
+obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
 obj-$(CONFIG_HW_RANDOM_EXYNOS)	+= exynos-rng.o
 obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
 obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
diff --git a/drivers/char/hw_random/powernv-rng.c b/drivers/char/hw_random/powernv-rng.c
new file mode 100644
index 0000000..e6965bf
--- /dev/null
+++ b/drivers/char/hw_random/powernv-rng.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright 2013 Michael Ellerman, Guo Chao, IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/hw_random.h>
+
+static int powernv_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	unsigned long *buf;
+	int i, len;
+
+	/* We rely on rng_buffer_size() being >= sizeof(unsigned long) */
+	len = max / sizeof(unsigned long);
+
+	buf = (unsigned long *)data;
+
+	for (i = 0; i < len; i++)
+		powernv_get_random_long(buf++);
+
+	return len * sizeof(unsigned long);
+}
+
+static struct hwrng powernv_hwrng = {
+	.name = "powernv-rng",
+	.read = powernv_rng_read,
+};
+
+static int powernv_rng_remove(struct platform_device *pdev)
+{
+	hwrng_unregister(&powernv_hwrng);
+
+	return 0;
+}
+
+static int powernv_rng_probe(struct platform_device *pdev)
+{
+	int rc;
+
+	rc = hwrng_register(&powernv_hwrng);
+	if (rc) {
+		/* We only register one device, ignore any others */
+		if (rc == -EEXIST)
+			rc = -ENODEV;
+
+		return rc;
+	}
+
+	pr_info("registered powernv hwrng.\n");
+
+	return 0;
+}
+
+static struct of_device_id powernv_rng_match[] = {
+	{ .compatible	= "ibm,power-rng",},
+	{},
+};
+MODULE_DEVICE_TABLE(of, powernv_rng_match);
+
+static struct platform_driver powernv_rng_driver = {
+	.driver = {
+		.name = "powernv_rng",
+		.of_match_table = powernv_rng_match,
+	},
+	.probe	= powernv_rng_probe,
+	.remove = powernv_rng_remove,
+};
+module_platform_driver(powernv_rng_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Bare metal HWRNG driver for POWER7+ and above");
-- 
1.8.1.2

