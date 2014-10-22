Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaJVT5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:57:05 -0400
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:31031
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932422AbaJVT47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:56:59 -0400
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v2 2/3] fpga manager: framework core
Date: Wed, 22 Oct 2014 14:50:04 -0500
Message-ID: <1414007405-32186-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR11CA0002.namprd11.prod.outlook.com (25.160.91.12) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 037291602B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(62966002)(31966008)(50986999)(76176999)(106356001)(48376002)(15202345003)(77096002)(76482002)(99396003)(120916001)(50466002)(77156001)(97736003)(81156004)(107046002)(229853001)(105586002)(95666004)(19580395003)(122386002)(85306004)(19580405001)(15975445006)(46102003)(80022003)(102836001)(87286001)(69596002)(93916002)(575784001)(101416001)(40100003)(86362001)(104166001)(88136002)(89996001)(33646002)(66066001)(21056001)(47776003)(53416004)(20776003)(42186005)(50226001)(87976001)(4396001)(92566001)(85852003)(92726001)(64706001)(86152002)(2201001)(2004002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Supports standard ops for low level FPGA drivers.
Various manufacturors' FPGAs can be supported by adding low
level drivers.  Each driver needs to register its ops
using fpga_mgr_register().

Exports methods of doing operations to program  FPGAs. These
should be sufficient for individual drivers to request FPGA
programming directly if desired.

Adds a sysfs interface.  The sysfs interface can be compiled out
where desired in production builds.

Resume is supported by calling low level driver's resume
function, then reloading the firmware image.

The following are exported as GPL:
* fpga_mgr_reset
   Reset the FGPA.

* fpga_mgr_write
   Write a image (in buffer) to the FPGA.

* fpga_mgr_firmware_write
   Request firmware by file name and write it to the FPGA.

* fpga_mgr_name
   Get name of FPGA manager.

* fpga_mgr_state
   Get a state of framework as a string.

* fpga_mgr_register and fpga_mgr_remove
   Register/unregister low level fpga manager driver.

The following sysfs files are created:
* /sys/class/fpga_manager/<fpga>/name
  Name of low level driver.

* /sys/class/fpga_manager/<fpga>/firmware
  Name of FPGA image file to load using firmware class.
  $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware

  read: read back name of image file previous loaded
  $ cat /sys/class/fpga_manager/<fpga>/firmware

* /sys/class/fpga_manager/<fpga>/reset
  reset the FPGA
  $ echo 1 > /sys/class/fpga_manager/<fpga>/reset

* /sys/class/fpga_manager/<fpga>/state
  State of fpga framework state machine

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v2: s/mangager/manager/
    check for invalid request_nr
    add fpga reset interface
    rework the state code
    remove FPGA_MGR_FAIL flag
    add _ERR states to fpga manager states enum
    low level state op now returns a state enum value
    initialize framework state from driver state op
    remove unused fpga read stuff
    merge sysfs.c into fpga-mgr.c
    move suspend/resume from bus.c to fpga-mgr.c
---
 drivers/Kconfig          |    2 +
 drivers/Makefile         |    1 +
 drivers/fpga/Kconfig     |   21 ++
 drivers/fpga/Makefile    |   10 +
 drivers/fpga/fpga-mgr.c  |  528 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fpga-mgr.h |  115 ++++++++++
 6 files changed, 677 insertions(+)
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga-mgr.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 622fa26..fc45fee 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -34,6 +34,8 @@ source "drivers/message/fusion/Kconfig"
 
 source "drivers/firewire/Kconfig"
 
+source "drivers/fpga/Kconfig"
+
 source "drivers/message/i2o/Kconfig"
 
 source "drivers/macintosh/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index ebee555..637b9f0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_RESET_CONTROLLER)	+= reset/
 # default.
 obj-y				+= tty/
 obj-y				+= char/
+obj-$(CONFIG_FPGA)		+= fpga/
 
 # gpu/ comes after char for AGP vs DRM startup
 obj-y				+= gpu/
diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
new file mode 100644
index 0000000..e775b17
--- /dev/null
+++ b/drivers/fpga/Kconfig
@@ -0,0 +1,21 @@
+#
+# FPGA framework configuration
+#
+
+menu "FPGA devices"
+
+config FPGA
+	tristate "FPGA Framework"
+	help
+	  Say Y here if you want support for configuring FPGAs from the
+	  kernel.  The FPGA framework adds a FPGA manager class and FPGA
+	  manager drivers.
+
+config FPGA_MGR_SYSFS
+	bool "FPGA Manager SysFS Interface"
+	depends on FPGA
+	depends on SYSFS
+	help
+	  FPGA Manager SysFS interface.
+
+endmenu
diff --git a/drivers/fpga/Makefile b/drivers/fpga/Makefile
new file mode 100644
index 0000000..c8a676f
--- /dev/null
+++ b/drivers/fpga/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the fpga framework and fpga manager drivers.
+#
+
+fpga-mgr-core-y += fpga-mgr.o
+
+# Core FPGA Manager Framework
+obj-$(CONFIG_FPGA)			+= fpga-mgr-core.o
+
+# FPGA Manager Drivers
diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
new file mode 100644
index 0000000..0c7236a
--- /dev/null
+++ b/drivers/fpga/fpga-mgr.c
@@ -0,0 +1,528 @@
+/*
+ * FPGA Manager Core
+ *
+ *  Copyright (C) 2013-2014 Altera Corporation
+ *
+ * With code from the mailing list:
+ * Copyright (C) 2013 Xilinx, Inc.
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
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/fpga-mgr.h>
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_irq.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+
+static DEFINE_IDA(fpga_mgr_ida);
+static int fpga_mgr_major;
+static struct class *fpga_mgr_class;
+
+#define FPGA_MAX_MINORS	256
+
+static DEFINE_MUTEX(fpga_manager_mutex);
+static LIST_HEAD(fpga_manager_list);
+
+/*
+ * Get FPGA state from low level driver
+ * return value is same enum as fpga_mgr_framework_state
+ *
+ * This will be used to initialize framework state
+ */
+int fpga_mgr_low_level_state(struct fpga_manager *mgr)
+{
+	if (!mgr || !mgr->mops || !mgr->mops->state)
+		return FPGA_MGR_STATE_UNKNOWN;
+
+	return mgr->mops->state(mgr);
+}
+
+/*
+ * Unlocked version
+ */
+static int __fpga_mgr_reset(struct fpga_manager *mgr)
+{
+	int ret;
+
+	if (!mgr->mops->reset)
+		return -EINVAL;
+
+	ret = mgr->mops->reset(mgr);
+
+	mgr->state = fpga_mgr_low_level_state(mgr);
+
+	return ret;
+}
+
+int fpga_mgr_reset(struct fpga_manager *mgr)
+{
+	int ret;
+
+	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
+		return -EBUSY;
+
+	ret = __fpga_mgr_reset(mgr);
+
+	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_reset);
+
+/*
+ * Unlocked version of fpga_mgr_write function.
+ *  Does not touch flags.  So caller must grab the FPGA_MGR_BUSY bit.
+ */
+static int __fpga_mgr_write(struct fpga_manager *mgr, const char *buf,
+			    size_t count)
+{
+	int ret;
+
+	if (mgr->mops->write_init) {
+		mgr->state = FPGA_MGR_STATE_WRITE_INIT;
+		ret = mgr->mops->write_init(mgr);
+		if (ret) {
+			mgr->state = FPGA_MGR_STATE_WRITE_INIT_ERR;
+			return ret;
+		}
+	}
+
+	mgr->state = FPGA_MGR_STATE_WRITE;
+	ret = mgr->mops->write(mgr, buf, count);
+	if (ret) {
+		mgr->state = FPGA_MGR_STATE_WRITE_ERR;
+		return ret;
+	}
+
+	if (mgr->mops->write_complete) {
+		mgr->state = FPGA_MGR_STATE_WRITE_COMPLETE;
+		ret = mgr->mops->write_complete(mgr);
+		if (ret) {
+			mgr->state = FPGA_MGR_STATE_WRITE_COMPLETE_ERR;
+			return ret;
+		}
+	}
+
+	mgr->state = FPGA_MGR_STATE_OPERATING;
+
+	return 0;
+}
+
+int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
+{
+	int ret;
+
+	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
+		return -EBUSY;
+
+	dev_info(mgr->dev, "writing buffer to %s\n", mgr->name);
+
+	ret = __fpga_mgr_write(mgr, buf, count);
+	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_write);
+
+/*
+ * Grab lock, request firmware, and write out to the FPGA.
+ * Update the state before each step to provide info on what step
+ * failed if there is a failure.
+ */
+int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *image_name)
+{
+	const struct firmware *fw;
+	int ret;
+
+	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
+		return -EBUSY;
+
+	dev_info(mgr->dev, "writing %s to %s\n", image_name, mgr->name);
+
+	mgr->state = FPGA_MGR_STATE_FIRMWARE_REQ;
+	ret = request_firmware(&fw, image_name, mgr->dev);
+	if (ret) {
+		mgr->state = FPGA_MGR_STATE_FIRMWARE_REQ_ERR;
+		goto fw_wr_exit;
+	}
+
+	ret = __fpga_mgr_write(mgr, fw->data, fw->size);
+	if (ret)
+		goto fw_wr_exit;
+
+	strcpy(mgr->image_name, image_name);
+
+fw_wr_exit:
+	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_firmware_write);
+
+int fpga_mgr_name(struct fpga_manager *mgr, char *buf)
+{
+	if (!mgr)
+		return -ENODEV;
+
+	return sprintf(buf, "%s\n", mgr->name);
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_name);
+
+static int fpga_mgr_get_new_minor(struct fpga_manager *mgr, int request_nr)
+{
+	int nr, start;
+
+	/* check specified minor number */
+	if (request_nr >= FPGA_MAX_MINORS) {
+		dev_err(mgr->parent, "Out of device minors (%d)\n", request_nr);
+		return -ENODEV;
+	}
+
+	if (request_nr < -1)
+		return -EINVAL;
+
+	/*
+	 * If request_nr == -1, dynamically allocate number.
+	 * If request_nr >= 0, attempt to get specific number.
+	 */
+	if (request_nr == -1)
+		start = 0;
+	else
+		start = request_nr;
+
+	nr = ida_simple_get(&fpga_mgr_ida, start, FPGA_MAX_MINORS, GFP_KERNEL);
+
+	/* return error code */
+	if (nr < 0)
+		return nr;
+
+	if ((request_nr != -1) && (request_nr != nr)) {
+		dev_err(mgr->parent,
+			"Could not get requested device minor (%d)\n", nr);
+		ida_simple_remove(&fpga_mgr_ida, nr);
+		return -ENODEV;
+	}
+
+	mgr->nr = nr;
+
+	return 0;
+}
+
+static void fpga_mgr_free_minor(int nr)
+{
+	ida_simple_remove(&fpga_mgr_ida, nr);
+}
+
+#if IS_ENABLED(CONFIG_FPGA_MGR_SYSFS)
+const char *state_str[] = {
+	[FPGA_MGR_STATE_UNKNOWN] =		"unknown",
+	[FPGA_MGR_STATE_POWER_OFF] =		"power_off",
+	[FPGA_MGR_STATE_POWER_UP] =		"power_up",
+	[FPGA_MGR_STATE_RESET] =		"reset",
+
+	/* write sequence */
+	[FPGA_MGR_STATE_FIRMWARE_REQ] =		"firmware_request",
+	[FPGA_MGR_STATE_FIRMWARE_REQ_ERR] =	"firmware_request_err",
+	[FPGA_MGR_STATE_WRITE_INIT] =		"write_init",
+	[FPGA_MGR_STATE_WRITE_INIT_ERR] =	"write_init_err",
+	[FPGA_MGR_STATE_WRITE] =		"write",
+	[FPGA_MGR_STATE_WRITE_ERR] =		"write_err",
+	[FPGA_MGR_STATE_WRITE_COMPLETE] =	"write_complete",
+	[FPGA_MGR_STATE_WRITE_COMPLETE_ERR] =	"write_complete_err",
+
+	[FPGA_MGR_STATE_OPERATING] =		"operating",
+};
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
+static ssize_t fpga_mgr_state_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", state_str[mgr->state]);
+}
+
+static ssize_t fpga_mgr_firmware_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s\n", mgr->image_name);
+}
+
+static ssize_t fpga_mgr_firmware_store(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+	unsigned int len;
+	char image_name[NAME_MAX];
+	int ret;
+
+	/* lose terminating \n */
+	strcpy(image_name, buf);
+	len = strlen(image_name);
+	if (image_name[len - 1] == '\n')
+		image_name[len - 1] = 0;
+
+	ret = fpga_mgr_firmware_write(mgr, image_name);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+/* To reset the fpga, "echo 1 > /sys/.../reset" */
+static ssize_t fpga_mgr_reset_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val == 1) {
+		ret = fpga_mgr_reset(mgr);
+		if (ret)
+			return ret;
+	} else {
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(name, S_IRUGO, fpga_mgr_name_show, NULL);
+static DEVICE_ATTR(state, S_IRUGO, fpga_mgr_state_show, NULL);
+static DEVICE_ATTR(firmware, S_IRUGO | S_IWUSR,
+		   fpga_mgr_firmware_show, fpga_mgr_firmware_store);
+static DEVICE_ATTR(reset, S_IWUSR, NULL, fpga_mgr_reset_store);
+
+static struct attribute *fpga_mgr_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_state.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_reset.attr,
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
+#else
+#define fpga_mgr_groups NULL
+#endif /* CONFIG_FPGA_MGR_SYSFS */
+
+static int fpga_mgr_suspend(struct device *dev)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+
+	if (!mgr)
+		return -ENODEV;
+
+	if (mgr->mops->suspend)
+		return mgr->mops->suspend(mgr);
+
+	return 0;
+}
+
+static int fpga_mgr_resume(struct device *dev)
+{
+	struct fpga_manager *mgr = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (!mgr)
+		return -ENODEV;
+
+	if (mgr->mops->resume) {
+		ret = mgr->mops->resume(mgr);
+		if (ret)
+			return ret;
+	}
+
+	if (strlen(mgr->image_name) != 0)
+		fpga_mgr_firmware_write(mgr, mgr->image_name);
+
+	return 0;
+}
+
+const struct dev_pm_ops fpga_mgr_dev_pm_ops = {
+	.suspend	= fpga_mgr_suspend,
+	.resume		= fpga_mgr_resume,
+};
+
+int fpga_mgr_register(struct platform_device *pdev,
+		      struct fpga_manager_ops *mops,
+		      const char *name, void *priv)
+{
+	struct fpga_manager *mgr;
+	int ret;
+
+	BUG_ON(!mops || !name || !strlen(name));
+
+	mgr = devm_kzalloc(&pdev->dev, sizeof(struct fpga_manager), GFP_KERNEL);
+	if (!mgr)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, mgr);
+	mgr->mops = mops;
+
+	mgr->np = pdev->dev.of_node;
+	mgr->parent = get_device(&pdev->dev);
+	mgr->priv = priv;
+	mgr->name = name;
+	init_completion(&mgr->status_complete);
+
+	ret = fpga_mgr_get_new_minor(mgr, pdev->id);
+	if (ret)
+		goto error_kfree;
+
+	if (mops->isr) {
+		mgr->irq = irq_of_parse_and_map(mgr->np, 0);
+		if (mgr->irq == NO_IRQ) {
+			dev_err(mgr->parent, "failed to map interrupt\n");
+			goto error_irq_map;
+		}
+
+		ret = request_irq(mgr->irq, mops->isr, 0, "fpga-mgr", mgr);
+		if (ret < 0) {
+			dev_err(mgr->parent, "error requesting interrupt\n");
+			goto error_irq_req;
+		}
+	}
+
+	mgr->dev = device_create(fpga_mgr_class, mgr->parent, MKDEV(0, 0), mgr,
+				 "fpga%d", mgr->nr);
+	if (IS_ERR(mgr->dev)) {
+		ret = PTR_ERR(mgr->dev);
+		goto error_device;
+	}
+
+	fpga_mgr_class->pm = &fpga_mgr_dev_pm_ops;
+
+	/*
+	 * Initialize framework state by requesting low level driver read state
+	 * from device.  FPGA may be in reset mode or may have been programmed
+	 * by bootloader or EEPROM.
+	 */
+	mgr->state = fpga_mgr_low_level_state(mgr);
+
+	dev_info(mgr->parent, "fpga manager [%s] registered as minor %d\n",
+		 mgr->name, mgr->nr);
+
+	INIT_LIST_HEAD(&mgr->list);
+	mutex_lock(&fpga_manager_mutex);
+	list_add(&mgr->list, &fpga_manager_list);
+	mutex_unlock(&fpga_manager_mutex);
+
+	return 0;
+
+error_device:
+	free_irq(mgr->irq, mgr);
+error_irq_req:
+	irq_dispose_mapping(mgr->irq);
+error_irq_map:
+	fpga_mgr_free_minor(mgr->nr);
+error_kfree:
+	put_device(mgr->parent);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_register);
+
+void fpga_mgr_remove(struct platform_device *pdev)
+{
+	struct fpga_manager *mgr = platform_get_drvdata(pdev);
+
+	if (!mgr)
+		return;
+
+	if (mgr->mops->fpga_remove)
+		mgr->mops->fpga_remove(mgr);
+
+	mutex_lock(&fpga_manager_mutex);
+	list_del(&mgr->list);
+	mutex_unlock(&fpga_manager_mutex);
+
+	device_destroy(fpga_mgr_class, MKDEV(fpga_mgr_major, mgr->nr));
+	free_irq(mgr->irq, mgr);
+	irq_dispose_mapping(mgr->irq);
+	fpga_mgr_free_minor(mgr->nr);
+	put_device(mgr->parent);
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_remove);
+
+static int __init fpga_mgr_dev_init(void)
+{
+	dev_t fpga_mgr_dev;
+	int ret;
+
+	pr_info("FPGA Manager framework driver\n");
+
+	fpga_mgr_class = class_create(THIS_MODULE, "fpga_manager");
+	if (IS_ERR(fpga_mgr_class))
+		return PTR_ERR(fpga_mgr_class);
+
+	fpga_mgr_class->dev_groups = fpga_mgr_groups;
+
+	ret = alloc_chrdev_region(&fpga_mgr_dev, 0, FPGA_MAX_MINORS,
+				  "fpga_manager");
+	if (ret) {
+		class_destroy(fpga_mgr_class);
+		return ret;
+	}
+
+	fpga_mgr_major = MAJOR(fpga_mgr_dev);
+
+	return 0;
+}
+
+static void __exit fpga_mgr_dev_exit(void)
+{
+	unregister_chrdev_region(MKDEV(fpga_mgr_major, 0), FPGA_MAX_MINORS);
+	class_destroy(fpga_mgr_class);
+	ida_destroy(&fpga_mgr_ida);
+}
+
+MODULE_AUTHOR("Alan Tull <atull@opensource.altera.com>");
+MODULE_DESCRIPTION("FPGA Manager framework driver");
+MODULE_LICENSE("GPL v2");
+
+subsys_initcall(fpga_mgr_dev_init);
+module_exit(fpga_mgr_dev_exit);
diff --git a/include/linux/fpga-mgr.h b/include/linux/fpga-mgr.h
new file mode 100644
index 0000000..97c7e0b
--- /dev/null
+++ b/include/linux/fpga-mgr.h
@@ -0,0 +1,115 @@
+/*
+ * FPGA Framework
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
+#include <linux/cdev.h>
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/limits.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#ifndef _LINUX_FPGA_MGR_H
+#define _LINUX_FPGA_MGR_H
+
+struct fpga_manager;
+
+/*
+ * fpga_manager_ops are the low level functions implemented by a specific
+ * fpga manager driver.  Leaving any of these out that aren't needed is fine
+ * as they are all tested for NULL before being called.
+ */
+struct fpga_manager_ops {
+	/* Returns an enum value of the FPGA's state */
+	int (*state)(struct fpga_manager *mgr);
+
+	/* Put FPGA into reset state */
+	int (*reset)(struct fpga_manager *mgr);
+
+	/* Prepare the FPGA to receive confuration data */
+	int (*write_init)(struct fpga_manager *mgr);
+
+	/* Write count bytes of configuration data to the FPGA */
+	int (*write)(struct fpga_manager *mgr, const char *buf, size_t count);
+
+	/* Return FPGA to default state after writing is done */
+	int (*write_complete)(struct fpga_manager *mgr);
+
+	/* Optional: Set FPGA into a specific state during driver remove */
+	void (*fpga_remove)(struct fpga_manager *mgr);
+
+	int (*suspend)(struct fpga_manager *mgr);
+
+	int (*resume)(struct fpga_manager *mgr);
+
+	/* FPGA manager isr */
+	irqreturn_t (*isr)(int irq, void *dev_id);
+};
+
+/* flag bits */
+#define FPGA_MGR_BUSY		0
+
+/* Valid states may vary by manufacturer; superset is: */
+enum fpga_mgr_states {
+	FPGA_MGR_STATE_UNKNOWN,		/* can't determine state */
+	FPGA_MGR_STATE_POWER_OFF,	/* FPGA power is off */
+	FPGA_MGR_STATE_POWER_UP,	/* FPGA reports power is up */
+	FPGA_MGR_STATE_RESET,		/* FPGA held in reset state */
+
+	/* write sequence */
+	FPGA_MGR_STATE_FIRMWARE_REQ,	/* firmware request in progress */
+	FPGA_MGR_STATE_FIRMWARE_REQ_ERR, /* firmware request failed */
+	FPGA_MGR_STATE_WRITE_INIT,	/* preparing FPGA for programming */
+	FPGA_MGR_STATE_WRITE_INIT_ERR,	/* Error during write_init stage */
+	FPGA_MGR_STATE_WRITE,		/* FPGA ready to receive image data */
+	FPGA_MGR_STATE_WRITE_ERR,	/* Error while programming FPGA */
+	FPGA_MGR_STATE_WRITE_COMPLETE,	/* Doing post programming steps */
+	FPGA_MGR_STATE_WRITE_COMPLETE_ERR, /* Error during write_complete */
+
+	FPGA_MGR_STATE_OPERATING,	/* FPGA is programmed and operating */
+};
+
+struct fpga_manager {
+	const char *name;
+	int nr;
+	struct device_node *np;
+	struct device *parent;
+	struct device *dev;
+	struct list_head list;
+	unsigned long flags;
+	enum fpga_mgr_states state;
+	char image_name[NAME_MAX];
+
+	struct fpga_manager_ops *mops;
+	struct completion status_complete;
+	int irq;
+	void *priv;
+};
+
+#if IS_ENABLED(CONFIG_FPGA)
+
+int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *image_name);
+int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count);
+int fpga_mgr_name(struct fpga_manager *mgr, char *buf);
+int fpga_mgr_reset(struct fpga_manager *mgr);
+int fpga_mgr_register(struct platform_device *pdev,
+		      struct fpga_manager_ops *mops,
+		      const char *name, void *priv);
+void fpga_mgr_remove(struct platform_device *pdev);
+
+#endif /* CONFIG_FPGA */
+#endif /*_LINUX_FPGA_MGR_H */
-- 
1.7.9.5

