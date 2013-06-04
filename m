Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab3FDHR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:17:57 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64490 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759884Ab3FDHRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:17:49 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-pm@vger.kernel.org
Subject: [PATCH v4] arm: zynq: Add cpuidle support
Date: Tue,  4 Jun 2013 09:17:39 +0200
Message-Id: <360abe7d7e8b8a0f785ec846c24fa5cb6658b956.1370330248.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-21290-1370330259-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-21290-1370330259-0001

Add support for cpuidle.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v4:
- Add record to MAINTAINERS file
- Use long license in header + Maintainer record
- Remove unused headers
- Fix indentations
- s/zynq_init_cpuidle/zynq_cpuidle_init/g
- use cpuidle_register function
- Do not use module_init, use device_initcall instead
  (Using it as module is not possible because some
   arm core functions are not exported for modules)

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

 MAINTAINERS                    |  1 +
 drivers/cpuidle/Kconfig        |  6 +++
 drivers/cpuidle/Makefile       |  1 +
 drivers/cpuidle/cpuidle-zynq.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)
 create mode 100644 drivers/cpuidle/cpuidle-zynq.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 90f45f4..6e4d4e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1309,6 +1309,7 @@ W:	http://wiki.xilinx.com
 T:	git git://git.xilinx.com/linux-xlnx.git
 S:	Supported
 F:	arch/arm/mach-zynq/
+F:	drivers/cpuidle/cpuidle-zynq.c

 ARM64 PORT (AARCH64 ARCHITECTURE)
 M:	Catalin Marinas <catalin.marinas@arm.com>
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
index 0000000..38e03a1
--- /dev/null
+++ b/drivers/cpuidle/cpuidle-zynq.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2012-2013 Xilinx
+ *
+ * CPU idle support for Xilinx Zynq
+ *
+ * based on arch/arm/mach-at91/cpuidle.c
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * The cpu idle uses wait-for-interrupt and RAM self refresh in order
+ * to implement two idle states -
+ * #1 wait-for-interrupt
+ * #2 wait-for-interrupt and RAM self refresh
+ *
+ * Maintainer: Michal Simek <michal.simek@xilinx.com>
+ */
+
+#include <linux/init.h>
+#include <linux/cpu_pm.h>
+#include <linux/cpuidle.h>
+#include <linux/of.h>
+#include <asm/proc-fns.h>
+#include <asm/cpuidle.h>
+
+#define ZYNQ_MAX_STATES		2
+
+/* Actual code that puts the SoC in different idle states */
+static int zynq_enter_idle(struct cpuidle_device *dev,
+			   struct cpuidle_driver *drv, int index)
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
+			.enter			= zynq_enter_idle,
+			.exit_latency		= 10,
+			.target_residency	= 10000,
+			.flags			= CPUIDLE_FLAG_TIME_VALID |
+						  CPUIDLE_FLAG_TIMER_STOP,
+			.name			= "RAM_SR",
+			.desc			= "WFI and RAM Self Refresh",
+		},
+	},
+	.safe_state_index = 0,
+	.state_count = ZYNQ_MAX_STATES,
+};
+
+/* Initialize CPU idle by registering the idle states */
+static int __init zynq_cpuidle_init(void)
+{
+	if (!of_machine_is_compatible("xlnx,zynq-7000"))
+		return -ENODEV;
+
+	pr_info("Xilinx Zynq CpuIdle Driver started\n");
+
+	return cpuidle_register(&zynq_idle_driver, NULL);
+}
+
+device_initcall(zynq_cpuidle_init);
--
1.8.2.3


--=_mimegpg-monstr-desktop-21290-1370330259-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGtlJMACgkQykllyylKDCGNJACeMP3IC/BiaKzGPAprzoiGpevi
R7AAmgLgrv1H5heL5WdW+lOHJZ+vaQVd
=w4V+
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-21290-1370330259-0001--
