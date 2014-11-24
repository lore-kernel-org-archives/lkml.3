Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaKXUKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:10:30 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:39265 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaKXUKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:10:22 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 3/3] drivers: bus: Add Renesas Bus State Controller Driver
Date: Mon, 24 Nov 2014 21:10:08 +0100
Message-Id: <1416859808-18503-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
References: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the Renesas Bus State Controller (BSC, sometimes called
"LBSC within Bus Bridge", or "External Bus Interface") found on several
Renesas ARM SoCs.

The sole purpose of this driver is to enable its clock and PM domain (if
exist(s)), which are specified in the DT and managed from platform and
PM domain code.  The BSC clock and PM domain must be enabled for
external devices connected to the BSC (e.g. NOR FLASH or Ethernet) to
work.

Due to the child-parent relationship with devices connected to the BSC,
PM domain and clock state transitions are handled in the correct order.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
  - Is there a simpler way to do this?
  - As none of this code is really hardware-specific, should the driver
    be renamed to simple-bus, and match against "simple-bus"?
  - Should this be moved to core code, without an explicit driver for
    "simple-bus"?
Please reply to the cover letter!

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/bus/Kconfig       |  8 ++++++++
 drivers/bus/Makefile      |  1 +
 drivers/bus/renesas-bsc.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+)
 create mode 100644 drivers/bus/renesas-bsc.c

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 7697fc8903f62d07..7e901480ba67dcad 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -58,6 +58,14 @@ config OMAP_OCP2SCP
 	  OCP2SCP and in OMAP5, both USB PHY and SATA PHY is connected via
 	  OCP2SCP.
 
+config RENESAS_BSC
+	bool "Renesas Bus State Controller"
+	depends on ARCH_SHMOBILE && OF
+	help
+	  Driver for the Renesas Bus State Controller (BSC, sometimes called
+	  "LBSC within Bus Bridge", or "External Bus Interface") found on
+	  several Renesas ARM SoCs.
+
 config VEXPRESS_CONFIG
 	bool "Versatile Express configuration bus"
 	default y if ARCH_VEXPRESS
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 2eb1f668c7fbc00d..b1ac67cfa9d5663c 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -14,4 +14,5 @@ obj-$(CONFIG_MVEBU_MBUS) += mvebu-mbus.o
 obj-$(CONFIG_OMAP_INTERCONNECT)	+= omap_l3_smx.o omap_l3_noc.o
 
 obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
+obj-$(CONFIG_RENESAS_BSC)	+= renesas-bsc.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
diff --git a/drivers/bus/renesas-bsc.c b/drivers/bus/renesas-bsc.c
new file mode 100644
index 0000000000000000..ca35aae266d3365a
--- /dev/null
+++ b/drivers/bus/renesas-bsc.c
@@ -0,0 +1,51 @@
+/*
+ * Renesas Bus State Controller Driver
+ *
+ * Copyright (C) 2014 Glider bvba
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+
+static int renesas_bsc_probe(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	pm_runtime_enable(&pdev->dev);
+	return 0;
+}
+
+static int renesas_bsc_remove(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	pm_runtime_disable(&pdev->dev);
+	return 0;
+}
+
+static const struct of_device_id renesas_bsc_of_match[] = {
+	{ .compatible = "renesas,bsc", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, renesas_bsc_of_match);
+
+static struct platform_driver renesas_bsc_driver = {
+	.probe = renesas_bsc_probe,
+	.remove = renesas_bsc_remove,
+	.driver = {
+		.name = "renesas-bsc",
+		.of_match_table = renesas_bsc_of_match,
+	},
+};
+
+module_platform_driver(renesas_bsc_driver);
+
+MODULE_DESCRIPTION("Renesas Bus State Controller Driver");
+MODULE_AUTHOR("Geert Uytterhoeven <geert@linux-m68k.org>");
+MODULE_LICENSE("GPL");
-- 
1.9.1

