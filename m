Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbaHAWdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:33:55 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:52263
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756136AbaHAWds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:33:48 -0400
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH 2/3] fpga bus driver
Date: Fri, 1 Aug 2014 17:28:37 -0500
Message-ID: <1406932118-13885-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
References: <1406932118-13885-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0025.namprd02.prod.outlook.com (10.141.56.25) To
 DM2PR03MB317.namprd03.prod.outlook.com (10.141.54.15)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029097202E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(22564002)(189002)(199002)(93916002)(77982001)(66066001)(76176999)(50986999)(62966002)(15975445006)(87976001)(87286001)(92566001)(69596002)(102836001)(48376002)(50466002)(85852003)(80022001)(15202345003)(86362001)(20776003)(101416001)(76482001)(81542001)(21056001)(53416004)(81156004)(4396001)(99396002)(50226001)(77096002)(229853001)(74502001)(19580395003)(19580405001)(42186005)(77156001)(88136002)(89996001)(86152002)(107046002)(81342001)(33646002)(106356001)(2201001)(92726001)(64706001)(95666004)(79102001)(104166001)(74662001)(47776003)(31966008)(83322001)(46102001)(105586002)(83072002)(85306004)(2004002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB317;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

This driver allows programming the fpga from
device tree overlays.

This code is dependent on Pantelis Antoniou's current
work on Device Tree overlays, a method of dynamically
altering the kerel's live Device Tree.  This patchset
was tested with Pantelis's and Grant Likely's stuff
that is in git plus some dtc fixups for compiling
overlays.

Resume is handled by re-requesting the firmware and
reprogramming the FPGA.

Here's a simple example. Start with:
  * the altera-gpio driver built in to the kernel but not in the
    device tree.
  * raw fpga image at /lib/firmware/soc_system.rbf
  * Load appropriate device tree overlay in configfs by doing
    $ mkdir /config/device-tree/overlays/1
    $ echo socfpga_overlay.dtbo > /config/device-tree/overlays/1/path
  * This results in the FPGA getting programmed and the altera
    gpio driver getting probed.

TODO:
  * Add ability to take fpga/cpu bridges out of reset.
  * To remove/clear FPGA image, remove device tree overlay by doing:
    $ rmdir /config/device-tree/overlays/1

Device tree overlay looks like this:
/dts-v1/;
/plugin/;
/ {
	fragment@0 {
		target-path="/soc";
		__overlay__ {
			#address-cells = <1>;
	                #size-cells = <1>;

			bridge@0xff200000 {
				compatible = "fpga-mgr-bus", "simple-bus";
				reg = <0xff200000 0x200000>;
				clocks = <0x2 0x2>;
				clock-names = "h2f_lw_axi_clock", "f2h_sdram0_clock";
				#address-cells = <0x2>;
				#size-cells = <0x1>;
				ranges = <0x1 0x10040 0xff210040 0x20>;

				fpgamgr = <&hps_0_fpgamgr>;
				fpga-firmware = "soc_system.rbf";

				gpio@0x100010040 {
					compatible = "altr,pio-14.0", "altr,pio-1.0";
					reg = <0x1 0x10040 0x20>;
					clocks = <0x2>;
					altr,gpio-bank-width = <0x4>;
					resetvalue = <0x0>;
					#gpio-cells = <0x2>;
					gpio-controller;
					linux,phandle = <0x2d>;
				};
			};
		};
	};
};

This patch adds one exported function to the core
(fpga-mgr.c):

EXPORT_SYMBOL_GPL(of_fpga_mgr_dev_lookup);
  Get pointer to fpga manager struct given a phandle.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 drivers/fpga/Kconfig     |    7 +++
 drivers/fpga/Makefile    |    1 +
 drivers/fpga/bus.c       |  145 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/fpga/fpga-mgr.c  |   26 +++++++++
 include/linux/fpga-mgr.h |    4 ++
 5 files changed, 183 insertions(+)
 create mode 100644 drivers/fpga/bus.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 49293a3..9a2c25b 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -10,4 +10,11 @@ config FPGA
 	  Say Y here if you want support for configuring FPGAs from the
 	  kernel.  The FPGA framework adds a FPGA manager class and FPGA
 	  manager drivers.
+
+config FPGA_MGR_BUS
+	bool "FPGA Manager Bus"
+	depends on FPGA
+	help
+	  FPGA Manager Bus interface.  Allows loading FPGA images
+	  from Device Tree or from other drivers.
 endmenu
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index c8a676f..e39911f 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -6,5 +6,6 @@ fpga-mgr-core-y += fpga-mgr.o
 
 # Core FPGA Manager Framework
 obj-$(CONFIG_FPGA)			+= fpga-mgr-core.o
+obj-$(CONFIG_FPGA_MGR_BUS)		+= bus.o
 
 # FPGA Manager Drivers
diff --git a/drivers/fpga/bus.c b/drivers/fpga/bus.c
new file mode 100644
index 0000000..3aa4a8e
--- /dev/null
+++ b/drivers/fpga/bus.c
@@ -0,0 +1,145 @@
+/*
+ * FPGA Manager Bus Driver
+ *
+ *  Copyright (C) 2013-2014 Altera Corporation
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
+ */
+#include <linux/completion.h>
+#include <linux/fs.h>
+#include <linux/fpga-mgr.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+struct fpga_mgr_bus_priv {
+	struct device *dev;
+	struct device_node *np;
+	struct fpga_manager *mgr;
+	const char *path;
+};
+
+static int fpga_mgr_bus_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int fpga_mgr_bus_resume(struct device *dev)
+{
+	struct fpga_mgr_bus_priv *priv = dev_get_drvdata(dev);
+
+	if (strlen(priv->path) != 0)
+		fpga_mgr_firmware_write(priv->mgr, priv->path);
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(fpga_mgr_bus_pm_ops,
+			 fpga_mgr_bus_suspend, fpga_mgr_bus_resume);
+
+static int fpga_mgr_bus_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct fpga_mgr_bus_priv *priv;
+	const char *path;
+	struct fpga_manager *mgr;
+	int ret = 0;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	/* Find the FPGA Manager to associate with */
+	mgr = of_fpga_mgr_dev_lookup(np, "fpgamgr", &ret);
+	if (ret != 0) {
+		dev_err(mgr->dev, "%s could not find fpga mgr\n", __func__);
+		return -ENODEV;
+	}
+
+	/* Find the FPGA image on the firmware path */
+	of_property_read_string(np, "fpga-firmware", &path);
+
+	ret = fpga_mgr_firmware_write(mgr, path);
+	if (ret != 0) {
+		dev_err(mgr->dev, "%s fpga mgr write failure\n", __func__);
+		return -EIO;
+	}
+
+	priv->dev = dev;
+	priv->np = np;
+	priv->mgr = mgr;
+	priv->path = path;
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+}
+
+/* Called when the Device Tree overlay is removed */
+static int fpga_mgr_bus_remove(struct platform_device *pdev)
+{
+	/*
+	 * Todo - when Device Tree overlay is removed,
+         * callback to low level FPGA driver to clear
+         * out FPGA image.
+	 */
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id fpga_mgr_bus_of_match[] = {
+	{ .compatible = "fpga-mgr-bus", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, fpga_mgr_bus_of_match);
+#endif
+
+static struct platform_driver fpga_mgr_bus_driver = {
+	.probe = fpga_mgr_bus_probe,
+	.remove = fpga_mgr_bus_remove,
+	.driver = {
+		.name	= "fpga_manager_bus",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(fpga_mgr_bus_of_match),
+		.pm = &fpga_mgr_bus_pm_ops,
+	},
+};
+
+static int __init fpga_mgr_bus_init(void)
+{
+	return platform_driver_register(&fpga_mgr_bus_driver);
+}
+
+static void __exit fpga_mgr_bus_exit(void)
+{
+	platform_driver_unregister(&fpga_mgr_bus_driver);
+}
+
+module_init(fpga_mgr_bus_init);
+module_exit(fpga_mgr_bus_exit);
+
+MODULE_AUTHOR("Alan Tull <atull@opensource.altera.com>");
+MODULE_DESCRIPTION("Altera FPGA Manager Bus");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index 0e2eba4..93327ea 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_irq.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -228,6 +229,31 @@ static int fpga_mgr_ops_framework_status(struct fpga_manager *mgr, char *buf)
 	return ret;
 }
 
+/* Find the fpga manager that is pointed to by a phandle */
+struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
+					    const char *mgr_property,
+					    int *ret)
+{
+	struct fpga_manager *mgr;
+	struct device_node *mgr_node;
+
+	mgr_node = of_parse_phandle(node, mgr_property, 0);
+
+	if (!mgr_node) {
+		*ret = -ENODEV;
+		return NULL;
+	}
+
+	list_for_each_entry(mgr, &fpga_manager_list, list)
+		if (mgr_node == mgr->np)
+			return mgr;
+
+	*ret = -EPROBE_DEFER;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(of_fpga_mgr_dev_lookup);
+
 static int fpga_mgr_suspend(struct device *dev)
 {
 	struct fpga_manager *mgr = dev_get_drvdata(dev);
diff --git a/include/linux/fpga-mgr.h b/include/linux/fpga-mgr.h
index 6af0873..35d3380 100644
--- a/include/linux/fpga-mgr.h
+++ b/include/linux/fpga-mgr.h
@@ -105,6 +105,10 @@ struct fpga_manager {
 
 #if IS_ENABLED(CONFIG_FPGA)
 
+struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
+					    const char *mgr_property,
+					    int *ret);
+
 int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *path);
 int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count);
 int fpga_mgr_status_get(struct fpga_manager *mgr, char *buf);
-- 
1.7.9.5

