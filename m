Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab3FCNkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:40:37 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:54554 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab3FCNkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:40:35 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org
Subject: [PATCH v3] arm: zynq: Add cpuidle support
Date: Mon,  3 Jun 2013 15:40:29 +0200
Message-Id: <2ba502c172f5374ed2e424292fb50345c9dd007a.1370266815.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17546-1370266829-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17546-1370266829-0001

Add support for cpuidle.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v3:
- Move driver to drivers/cpuidle/
- Check zynq compatible string suggested by Arnd
- Use zynq_ function prefix because of multiplatform kernel
- Incorporate comments from Daniel Lezcano
- Rebase on the top of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next

Changes in v2:
- Fix file header

Changes in v1:
- It was the part of Zynq core changes
  https://patchwork.kernel.org/patch/2342511/

 drivers/cpuidle/Kconfig        |   6 +++
 drivers/cpuidle/Makefile       |   1 +
 drivers/cpuidle/cpuidle-zynq.c | 100 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)
 create mode 100644 drivers/cpuidle/cpuidle-zynq.c

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index c4cc27e..8272a08 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -39,4 +39,10 @@ config CPU_IDLE_CALXEDA
 	help
 	  Select this to enable cpuidle on Calxeda processors.

+config CPU_IDLE_ZYNQ
+	bool "CPU Idle Driver for Xilinx Zynq processors"
+	depends on ARCH_ZYNQ
+	help
+	  Select this to enable cpuidle on Xilinx Zynq processors.
+
 endif
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index 0d8bd55..8767a7b 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o

 obj-$(CONFIG_CPU_IDLE_CALXEDA) += cpuidle-calxeda.o
 obj-$(CONFIG_ARCH_KIRKWOOD) += cpuidle-kirkwood.o
+obj-$(CONFIG_CPU_IDLE_ZYNQ) += cpuidle-zynq.o
diff --git a/drivers/cpuidle/cpuidle-zynq.c b/drivers/cpuidle/cpuidle-zynq.c
new file mode 100644
index 0000000..afe6af3
--- /dev/null
+++ b/drivers/cpuidle/cpuidle-zynq.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (C) 2012-2013 Xilinx
+ *
+ * CPU idle support for Xilinx Zynq
+ *
+ * based on arch/arm/mach-at91/cpuidle.c
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ * The cpu idle uses wait-for-interrupt and RAM self refresh in order
+ * to implement two idle states -
+ * #1 wait-for-interrupt
+ * #2 wait-for-interrupt and RAM self refresh
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/cpuidle.h>
+#include <linux/io.h>
+#include <linux/export.h>
+#include <linux/clockchips.h>
+#include <linux/cpu_pm.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <asm/proc-fns.h>
+#include <asm/cpuidle.h>
+
+#define ZYNQ_MAX_STATES		2
+
+static DEFINE_PER_CPU(struct cpuidle_device, zynq_cpuidle_device);
+
+/* Actual code that puts the SoC in different idle states */
+static int zynq_enter_idle(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int index)
+{
+	/* Devices must be stopped here */
+	cpu_pm_enter();
+
+	/* Add code for DDR self refresh start */
+	cpu_do_idle();
+
+	/* Add code for DDR self refresh stop */
+	cpu_pm_exit();
+
+	return index;
+}
+
+static struct cpuidle_driver zynq_idle_driver = {
+	.name = "zynq_idle",
+	.owner = THIS_MODULE,
+	.states = {
+		ARM_CPUIDLE_WFI_STATE,
+		{
+			.enter            = zynq_enter_idle,
+			.exit_latency     = 10,
+			.target_residency = 10000,
+			.flags            = CPUIDLE_FLAG_TIME_VALID,
+					    CPUIDLE_FLAG_TIMER_STOP,
+			.name             = "RAM_SR",
+			.desc             = "WFI and RAM Self Refresh",
+		},
+	},
+	.safe_state_index = 0,
+	.state_count = ZYNQ_MAX_STATES,
+};
+
+/* Initialize CPU idle by registering the idle states */
+static int zynq_init_cpuidle(void)
+{
+	unsigned int cpu;
+	struct cpuidle_device *device;
+	int ret;
+
+	if (!of_machine_is_compatible("xlnx,zynq-7000"))
+		return -ENODEV;
+
+	ret = cpuidle_register_driver(&zynq_idle_driver);
+	if (ret) {
+		pr_err("%s: Driver registration failed\n", __func__);
+		return ret;
+	}
+
+	for_each_possible_cpu(cpu) {
+		device = &per_cpu(zynq_cpuidle_device, cpu);
+		device->cpu = cpu;
+		ret = cpuidle_register_device(device);
+		if (ret) {
+			pr_err("%s: Device registration failed\n", __func__);
+			return ret;
+		}
+	}
+
+	pr_info("Xilinx Zynq CpuIdle Driver started\n");
+	return 0;
+}
+module_init(zynq_init_cpuidle);
--
1.8.2.3


--=_mimegpg-monstr-desktop-17546-1370266829-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGsnM4ACgkQykllyylKDCGE/gCgk0q7l3Ji7xfIOpWN+Kcwd8/0
/oYAnjmv+7eJ42hDNH4LsCs+uXyhKYGn
=IJqg
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17546-1370266829-0001--
