Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaHAWd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:33:57 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:59558
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756302AbaHAWdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:33:52 -0400
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
Subject: [PATCH 3/3] fpga sysfs interface
Date: Fri, 1 Aug 2014 17:28:38 -0500
Message-ID: <1406932118-13885-4-git-send-email-atull@opensource.altera.com>
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

Add basic sysfs interface.  Only exports two files:

/sys/class/fpga_manager/fpga0/name
   Name of low level driver.

/sys/class/fpga_manager/fpga0/status
   status of fpga framework as returned by core
   fpga-mgr.c's fpga_mgr_ops_framework_status
   function or by the low level driver's status
   function.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
 drivers/fpga/Kconfig     |    7 +++++
 drivers/fpga/Makefile    |    1 +
 drivers/fpga/fpga-mgr.c  |    2 ++
 drivers/fpga/sysfs.c     |   69 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fpga-mgr.h |   12 ++++++++
 5 files changed, 91 insertions(+)
 create mode 100644 drivers/fpga/sysfs.c

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 9a2c25b..113b8b4 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -17,4 +17,11 @@ config FPGA_MGR_BUS
 	help
 	  FPGA Manager Bus interface.  Allows loading FPGA images
 	  from Device Tree or from other drivers.
+
+config FPGA_MGR_SYSFS
+	bool "FPGA Manager SysFS Interface"
+	depends on FPGA
+	depends on SYSFS
+	help
+	  FPGA Manager SysFS interface.
 endmenu
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
index e39911f..cad3d8c 100644
--- a/drivers/fpga/Makefile
+++ b/drivers/fpga/Makefile
@@ -7,5 +7,6 @@ fpga-mgr-core-y += fpga-mgr.o
 # Core FPGA Manager Framework
 obj-$(CONFIG_FPGA)			+= fpga-mgr-core.o
 obj-$(CONFIG_FPGA_MGR_BUS)		+= bus.o
+obj-$(CONFIG_FPGA_MGR_SYSFS)		+= sysfs.o
 
 # FPGA Manager Drivers
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
index 93327ea..a604de7 100644
--- a/drivers/fpga/fpga-mgr.c
+++ b/drivers/fpga/fpga-mgr.c
@@ -402,6 +402,8 @@ static int __init fpga_mgr_dev_init(void)
 	if (IS_ERR(fpga_mgr_class))
 		return PTR_ERR(fpga_mgr_class);
 
+	fpga_mgr_sysfs_init(fpga_mgr_class);
+
 	ret = alloc_chrdev_region(&fpga_mgr_dev, 0, FPGA_MAX_MINORS,
 				  "fpga_manager");
 	if (ret) {
diff --git a/drivers/fpga/sysfs.c b/drivers/fpga/sysfs.c
new file mode 100644
index 0000000..ba2332d
--- /dev/null
+++ b/drivers/fpga/sysfs.c
@@ -0,0 +1,69 @@
+/*
+ * FPGA Manager SysFS Interface
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/fpga-mgr.h>
+
+/*
+ * class attributes
+ */
+static ssize_t fpga_mgr_name_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	return fpga_mgr_name(mgr, buf);
+}
+
+static ssize_t fpga_mgr_status_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	return fpga_mgr_status_get(mgr, buf);
+}
+
+static DEVICE_ATTR(name, S_IRUGO, fpga_mgr_name_show, NULL);
+static DEVICE_ATTR(status, S_IRUGO, fpga_mgr_status_show, NULL);
+
+static struct attribute *fpga_mgr_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_status.attr,
+	NULL,
+};
+
+static const struct attribute_group fpga_mgr_group = {
+	.attrs = fpga_mgr_attrs,
+};
+
+const struct attribute_group *fpga_mgr_groups[] = {
+	&fpga_mgr_group,
+	NULL,
+};
+
+void fpga_mgr_sysfs_init(struct class *fpga_mgr_class)
+{
+	fpga_mgr_class->dev_groups = fpga_mgr_groups;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_sysfs_init);
+
+MODULE_AUTHOR("Alan Tull <atull@opensource.altera.com>");
+MODULE_DESCRIPTION("FPGA Manager framework driver sysfs interface");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/fpga-mgr.h b/include/linux/fpga-mgr.h
index 35d3380..86eeff5 100644
--- a/include/linux/fpga-mgr.h
+++ b/include/linux/fpga-mgr.h
@@ -105,6 +105,18 @@ struct fpga_manager {
 
 #if IS_ENABLED(CONFIG_FPGA)
 
+#ifdef CONFIG_FPGA_MGR_SYSFS
+
+void fpga_mgr_sysfs_init(struct class *fpga_mgr_class);
+
+#else
+
+static inline void fpga_mgr_sysfs_init(struct class *fpga_mgr_class)
+{
+}
+
+#endif /* CONFIG_FPGA_MGR_SYSFS */
+
 struct fpga_manager *of_fpga_mgr_dev_lookup(struct device_node *node,
 					    const char *mgr_property,
 					    int *ret);
-- 
1.7.9.5

