Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3CDDL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:11:56 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:7606 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab3CDDLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:11:54 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz2fh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1155h)
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Ley Foon Tan <lftan@altera.com>
Subject: [PATCH 1/1] drivers/misc: Add Altera System ID driver
Date: Mon, 4 Mar 2013 11:11:37 +0800
Message-ID: <1362366697-2768-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add Altera System ID driver.
User can obtain the system ID and timestamp of the system by
reading the sysfs entry.

Usage:
cat /sys/bus/platform/devices/[addr].sysid/sysid/id
cat /sys/bus/platform/devices/[addr].sysid/sysid/timestamp

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 .../devicetree/bindings/misc/altera_sysid.txt      |   18 +++
 drivers/misc/Kconfig                               |    6 +
 drivers/misc/Makefile                              |    3 +-
 drivers/misc/altera_sysid.c                        |  142 ++++++++++++++++++++
 4 files changed, 168 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/altera_sysid.txt
 create mode 100644 drivers/misc/altera_sysid.c

diff --git a/Documentation/devicetree/bindings/misc/altera_sysid.txt b/Documentation/devicetree/bindings/misc/altera_sysid.txt
new file mode 100644
index 0000000..463dc15
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/altera_sysid.txt
@@ -0,0 +1,18 @@
+Altera Sysid IP core driver
+
+Required properties:
+- compatible: altr,sysid-1.0
+
+Optional properties:
+- id:  A unique 32-bit value that is based on the contents of the system.
+- timestamp: A unique 32-bit value that is based on the system generation time.
+
+Example:
+
+sysid_qsys: sysid@0x10000 {
+	compatible = "altr,sysid-1.0";
+	reg = < 0x10000 0x00000008 >;
+	id = < 1 >;
+	timestamp = < 1359538782 >;
+};
+
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e83fdfe..0e783af 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -510,6 +510,12 @@ config LATTICE_ECP3_CONFIG
 
 	  If unsure, say N.
 
+config ALTERA_SYSID
+	tristate "Altera System ID"
+	help
+	This enables Altera System ID soft core driver.
+
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 35a1463..dc7142d 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -47,7 +47,8 @@ obj-y				+= ti-st/
 obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
-obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_ALTERA_STAPL)	+= altera-stapl/
+obj-$(CONFIG_ALTERA_SYSID)	+= altera_sysid.o
 obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_MAX8997_MUIC)	+= max8997-muic.o
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
diff --git a/drivers/misc/altera_sysid.c b/drivers/misc/altera_sysid.c
new file mode 100644
index 0000000..7472a4b
--- /dev/null
+++ b/drivers/misc/altera_sysid.c
@@ -0,0 +1,142 @@
+/*
+ *  Copyright (C) 2013 Altera Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Credit:
+ * Walter Goossens
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#define DRV_NAME	"altera_sysid"
+
+struct altera_sysid {
+	void __iomem		*regs;
+};
+
+/* System ID Registers*/
+#define SYSID_REG_ID		(0x0)
+#define SYSID_REG_TIMESTAMP	(0x4)
+
+static ssize_t altera_sysid_show_id(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct altera_sysid *sysid = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", readl(sysid->regs + SYSID_REG_ID));
+}
+
+static ssize_t altera_sysid_show_timestamp(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	unsigned int reg;
+	struct tm timestamp;
+	struct altera_sysid *sysid = dev_get_drvdata(dev);
+
+	reg = readl(sysid->regs + SYSID_REG_TIMESTAMP);
+
+	time_to_tm(reg, 0, &timestamp);
+
+	return sprintf(buf, "%u (%u-%u-%u %u:%u:%u UTC)\n", reg,
+		(unsigned int)(timestamp.tm_year + 1900),
+		timestamp.tm_mon + 1, timestamp.tm_mday, timestamp.tm_hour,
+		timestamp.tm_min, timestamp.tm_sec);
+}
+
+static DEVICE_ATTR(id, S_IRUGO, altera_sysid_show_id, NULL);
+static DEVICE_ATTR(timestamp, S_IRUGO, altera_sysid_show_timestamp, NULL);
+
+static struct attribute *altera_sysid_attrs[] = {
+	&dev_attr_id.attr,
+	&dev_attr_timestamp.attr,
+	NULL,
+};
+
+struct attribute_group altera_sysid_attr_group = {
+	.name = "sysid",
+	.attrs = altera_sysid_attrs,
+};
+
+static int altera_sysid_probe(struct platform_device *pdev)
+{
+	struct altera_sysid *sysid;
+	struct resource	*regs;
+
+	sysid = devm_kzalloc(&pdev->dev, sizeof(struct altera_sysid),
+		GFP_KERNEL);
+	if (!sysid)
+		return -ENOMEM;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+
+	sysid->regs = devm_request_and_ioremap(&pdev->dev, regs);
+	if (!sysid->regs)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, sysid);
+
+	return sysfs_create_group(&pdev->dev.kobj, &altera_sysid_attr_group);
+}
+
+static int __exit altera_sysid_remove(struct platform_device *pdev)
+{
+	sysfs_remove_group(&pdev->dev.kobj, &altera_sysid_attr_group);
+
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static const struct of_device_id altera_sysid_match[] = {
+	{ .compatible = "altr,sysid-1.0" },
+	{ /* Sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, altera_sysid_match);
+
+static struct platform_driver altera_sysid_platform_driver = {
+	.driver = {
+		.name		= DRV_NAME,
+		.owner		= THIS_MODULE,
+		.of_match_table	= altera_sysid_match,
+	},
+	.remove			= __exit_p(altera_sysid_remove),
+};
+
+static int __init altera_sysid_init(void)
+{
+	return platform_driver_probe(&altera_sysid_platform_driver,
+		altera_sysid_probe);
+}
+
+static void __exit altera_sysid_exit(void)
+{
+	platform_driver_unregister(&altera_sysid_platform_driver);
+}
+
+module_init(altera_sysid_init);
+module_exit(altera_sysid_exit);
+
+MODULE_AUTHOR("Ley Foon Tan");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Altera System ID driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.7.4


