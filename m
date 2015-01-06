Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbbAFUOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:14:30 -0500
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:37750
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755629AbbAFUOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:14:22 -0500
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
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v8 3/4] staging: fpga manager: framework core
Date: Tue, 6 Jan 2015 14:13:38 -0600
Message-ID: <1420575219-27061-4-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0017.namprd00.prod.outlook.com (25.160.102.27) To
 BY1PR0301MB1238.namprd03.prod.outlook.com (25.161.203.22)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY1PR0301MB1238;
X-Forefront-PRVS: 0448A97BF2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(22564002)(199003)(15975445007)(53416004)(87976001)(2950100001)(42186005)(62966003)(77156002)(81156004)(105586002)(106356001)(107046002)(69596002)(19580395003)(97736003)(122386002)(229853001)(21056001)(19580405001)(31966008)(48376002)(66066001)(4396001)(50466002)(76176999)(50226001)(46102003)(50986999)(86152002)(92566001)(2201001)(120916001)(47776003)(64706001)(20776003)(99396003)(89996001)(33646002)(86362001)(68736005)(40100003)(101416001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1238;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 20:14:13.9509 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1238
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
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
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

v3: Add struct device to fpga_manager (not as a pointer)
    Add to_fpga_manager
    Don't get irq in fpga-mgr.c (let low level driver do it)
    remove from struct fpga_manager: nr, np, parent
    get rid of fpga_mgr_get_new_minor()
    simplify fpga_manager_register:
      reorder parameters
      use dev instead of pdev
    get rid of code that used to make more sense when this
      was a char driver, don't alloc_chrdev_region
    use a mutex instead of flags

v4: Move to drivers/staging

v5: Make some things be static
    Kconfig: add 'if FPGA'
    Makefile: s/fpga-mgr-core.o/fpga-mgr.o/
    clean up includes
    use enum fpga_mgr_states instead of int
    static const char *state_str
    use DEVICE_ATTR_RO/RW/WO and ATTRIBUTE_GROUPS
    return -EINVAL instead of BUG_ON
    move ida_simple_get after kzalloc
    clean up fpga_mgr_remove
    fpga-mgr.h: remove '#if IS_ENABLED(CONFIG_FPGA)'
    add kernel-doc documentation
    Move header to new include/linux/fpga folder
    static const struct fpga_mgr_ops
    dev_info msg simplified

v6: no statically allocated string for image_name
    kernel doc fixes
    changes regarding enabling SYSFS for fpga mgr
    Makefile cleanup

v7: no change in this patch for v7 of the patchset

v8: no change in this patch for v8 of the patchset
---
 drivers/staging/Kconfig         |    2 +
 drivers/staging/Makefile        |    1 +
 drivers/staging/fpga/Kconfig    |   24 ++
 drivers/staging/fpga/Makefile   |    8 +
 drivers/staging/fpga/fpga-mgr.c |  551 +++++++++++++++++++++++++++++++++++++++
 include/linux/fpga/fpga-mgr.h   |  124 +++++++++
 6 files changed, 710 insertions(+)
 create mode 100644 drivers/staging/fpga/Kconfig
 create mode 100644 drivers/staging/fpga/Makefile
 create mode 100644 drivers/staging/fpga/fpga-mgr.c
 create mode 100644 include/linux/fpga/fpga-mgr.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 815de37..6380ae2 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -106,4 +106,6 @@ source "drivers/staging/unisys/Kconfig"
 
 source "drivers/staging/clocking-wizard/Kconfig"
 
+source "drivers/staging/fpga/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 33c640b..7ea49c0 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -45,3 +45,4 @@ obj-$(CONFIG_GS_FPGABOOT)	+= gs_fpgaboot/
 obj-$(CONFIG_CRYPTO_SKEIN)	+= skein/
 obj-$(CONFIG_UNISYSSPAR)	+= unisys/
 obj-$(CONFIG_COMMON_CLK_XLNX_CLKWZRD)	+= clocking-wizard/
+obj-$(CONFIG_FPGA)		+= fpga/
diff --git a/drivers/staging/fpga/Kconfig b/drivers/staging/fpga/Kconfig
new file mode 100644
index 0000000..89ebafc
--- /dev/null
+++ b/drivers/staging/fpga/Kconfig
@@ -0,0 +1,24 @@
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
+if FPGA
+
+config FPGA_MGR_SYSFS
+	bool "FPGA Manager SysFS Interface"
+	depends on SYSFS
+	help
+	  FPGA Manager SysFS interface.
+
+endif # FPGA
+
+endmenu
diff --git a/drivers/staging/fpga/Makefile b/drivers/staging/fpga/Makefile
new file mode 100644
index 0000000..3313c52
--- /dev/null
+++ b/drivers/staging/fpga/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the fpga framework and fpga manager drivers.
+#
+
+# Core FPGA Manager Framework
+obj-$(CONFIG_FPGA)			+= fpga-mgr.o
+
+# FPGA Manager Drivers
diff --git a/drivers/staging/fpga/fpga-mgr.c b/drivers/staging/fpga/fpga-mgr.c
new file mode 100644
index 0000000..daf28b5
--- /dev/null
+++ b/drivers/staging/fpga/fpga-mgr.c
@@ -0,0 +1,551 @@
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
+#include <linux/fpga/fpga-mgr.h>
+#include <linux/idr.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+
+static DEFINE_MUTEX(fpga_mgr_mutex);
+static DEFINE_IDA(fpga_mgr_ida);
+static struct class *fpga_mgr_class;
+
+static LIST_HEAD(fpga_manager_list);
+
+/**
+ * fpga_mgr_low_level_state - get FPGA state from low level driver
+ * @mgr: fpga manager
+ *
+ * This will be used to initialize framework state
+ *
+ * Return: an enum value for state.
+ */
+static enum fpga_mgr_states fpga_mgr_low_level_state(struct fpga_manager *mgr)
+{
+	if (!mgr || !mgr->mops || !mgr->mops->state)
+		return FPGA_MGR_STATE_UNKNOWN;
+
+	return mgr->mops->state(mgr);
+}
+
+/**
+ * __fpga_mgr_reset - unlocked version of fpga_mgr_reset
+ * @mgr: fpga manager
+ *
+ * Return: 0 on success, error code otherwise.
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
+	kfree(mgr->image_name);
+	mgr->image_name = NULL;
+
+	return ret;
+}
+
+/**
+ * fpga_mgr_reset - reset the fpga
+ * @mgr: fpga manager
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int fpga_mgr_reset(struct fpga_manager *mgr)
+{
+	int ret;
+
+	if (!mutex_trylock(&mgr->lock))
+		return -EBUSY;
+
+	ret = __fpga_mgr_reset(mgr);
+
+	mutex_unlock(&mgr->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_reset);
+
+/**
+ * __fpga_mgr_stage_init - prepare fpga for configuration
+ * @mgr: fpga manager
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+static int __fpga_mgr_stage_write_init(struct fpga_manager *mgr)
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
+	return 0;
+}
+
+/**
+ * __fpga_mgr_stage_write - write buffer to fpga
+ * @mgr: fpga manager
+ * @buf: buffer contain fpga image
+ * @count: byte count of buf
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+static int __fpga_mgr_stage_write(struct fpga_manager *mgr, const char *buf,
+				  size_t count)
+{
+	int ret;
+
+	mgr->state = FPGA_MGR_STATE_WRITE;
+	ret = mgr->mops->write(mgr, buf, count);
+	if (ret) {
+		mgr->state = FPGA_MGR_STATE_WRITE_ERR;
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * __fpga_mgr_stage_complete - after writing, place fpga in operating state
+ * @mgr: fpga manager
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+static int __fpga_mgr_stage_write_complete(struct fpga_manager *mgr)
+{
+	int ret;
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
+	mgr->state = fpga_mgr_low_level_state(mgr);
+
+	return 0;
+}
+
+/**
+ * __fpga_mgr_write - whole fpga image write cycle
+ * @mgr: fpga manager
+ * @buf: buffer contain fpga image
+ * @count: byte count of buf
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+static int __fpga_mgr_write(struct fpga_manager *mgr, const char *buf,
+			    size_t count)
+{
+	int ret;
+
+	ret = __fpga_mgr_stage_write_init(mgr);
+	if (ret)
+		return ret;
+
+	ret = __fpga_mgr_stage_write(mgr, buf, count);
+	if (ret)
+		return ret;
+
+	return __fpga_mgr_stage_write_complete(mgr);
+}
+
+/**
+ * fpga_mgr_write - do complete fpga image write cycle
+ * @mgr: fpga manager
+ * @buf: buffer contain fpga image
+ * @count: byte count of buf
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
+{
+	int ret;
+
+	if (!mutex_trylock(&mgr->lock))
+		return -EBUSY;
+
+	dev_info(&mgr->dev, "writing buffer to %s\n", mgr->name);
+
+	ret = __fpga_mgr_write(mgr, buf, count);
+	mutex_unlock(&mgr->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_write);
+
+/**
+ * fpga_mgr_firmware_write - request firmware and write to fpga
+ * @mgr: fpga manager
+ * @image_name: name of image file on the firmware search path
+ *
+ * Grab lock, request firmware, and write out to the FPGA.
+ * Update the state before each step to provide info on what step
+ * failed if there is a failure.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *image_name)
+{
+	const struct firmware *fw;
+	int ret;
+
+	if (!mutex_trylock(&mgr->lock))
+		return -EBUSY;
+
+	dev_info(&mgr->dev, "writing %s to %s\n", image_name, mgr->name);
+
+	mgr->state = FPGA_MGR_STATE_FIRMWARE_REQ;
+	ret = request_firmware(&fw, image_name, &mgr->dev);
+	if (ret) {
+		mgr->state = FPGA_MGR_STATE_FIRMWARE_REQ_ERR;
+		goto fw_wr_exit;
+	}
+
+	ret = __fpga_mgr_write(mgr, fw->data, fw->size);
+	if (ret)
+		goto fw_wr_exit;
+
+	kfree(mgr->image_name);
+	mgr->image_name = kstrdup(image_name, GFP_KERNEL);
+
+fw_wr_exit:
+	mutex_unlock(&mgr->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_firmware_write);
+
+/**
+ * fpga_mgr_name - returns the fpga manager name
+ * @mgr: fpga manager
+ * @buf: buffer to receive the name
+ *
+ * Return: number of chars in buf excluding null byte on success;
+ * error code otherwise.
+ */
+int fpga_mgr_name(struct fpga_manager *mgr, char *buf)
+{
+	if (!mgr)
+		return -ENODEV;
+
+	return sprintf(buf, "%s\n", mgr->name);
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_name);
+
+static const char * const state_str[] = {
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
+static ssize_t name_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
+
+	return fpga_mgr_name(mgr, buf);
+}
+
+static ssize_t state_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
+
+	return sprintf(buf, "%s\n", state_str[mgr->state]);
+}
+
+static ssize_t firmware_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
+
+	if (!mgr->image_name)
+		return 0;
+
+	return sprintf(buf, "%s\n", mgr->image_name);
+}
+
+static ssize_t firmware_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
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
+static ssize_t reset_store(struct device *dev,
+			   struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
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
+static DEVICE_ATTR_RO(name);
+static DEVICE_ATTR_RO(state);
+static DEVICE_ATTR_RW(firmware);
+static DEVICE_ATTR_WO(reset);
+
+static struct attribute *fpga_mgr_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_state.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_reset.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(fpga_mgr);
+
+static int fpga_mgr_suspend(struct device *dev)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
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
+	struct fpga_manager *mgr = to_fpga_manager(dev);
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
+static const struct dev_pm_ops fpga_mgr_dev_pm_ops = {
+	.suspend	= fpga_mgr_suspend,
+	.resume		= fpga_mgr_resume,
+};
+
+static void fpga_mgr_dev_release(struct device *dev)
+{
+	struct fpga_manager *mgr = to_fpga_manager(dev);
+
+	dev_dbg(dev, "releasing '%s'\n", mgr->name);
+
+	if (mgr->mops->fpga_remove)
+		mgr->mops->fpga_remove(mgr);
+
+	mgr->mops = NULL;
+
+	mutex_lock(&fpga_mgr_mutex);
+	list_del(&mgr->list);
+	mutex_unlock(&fpga_mgr_mutex);
+
+	ida_simple_remove(&fpga_mgr_ida, mgr->dev.id);
+	kfree(mgr->image_name);
+	kfree(mgr);
+}
+
+/**
+ * fpga_mgr_register - register a low level fpga manager driver
+ * @dev: fpga manager device
+ * @name: fpga manager name
+ * @mops: pointer to structure of fpga manager ops
+ * @priv: fpga manager private data
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int fpga_mgr_register(struct device *dev, const char *name,
+		      const struct fpga_manager_ops *mops,
+		      void *priv)
+{
+	struct fpga_manager *mgr;
+	int id, ret;
+
+	if (!mops || !name || !strlen(name))
+		return -EINVAL;
+
+	mgr = kzalloc(sizeof(*mgr), GFP_KERNEL);
+	if (!mgr)
+		return -ENOMEM;
+
+	id = ida_simple_get(&fpga_mgr_ida, 0, 0, GFP_KERNEL);
+	if (id < 0)
+		return id;
+
+	mutex_init(&mgr->lock);
+
+	mgr->name = name;
+	mgr->mops = mops;
+	mgr->priv = priv;
+
+	/*
+	 * Initialize framework state by requesting low level driver read state
+	 * from device.  FPGA may be in reset mode or may have been programmed
+	 * by bootloader or EEPROM.
+	 */
+	mgr->state = fpga_mgr_low_level_state(mgr);
+
+	INIT_LIST_HEAD(&mgr->list);
+	mutex_lock(&fpga_mgr_mutex);
+	list_add(&mgr->list, &fpga_manager_list);
+	mutex_unlock(&fpga_mgr_mutex);
+
+	device_initialize(&mgr->dev);
+	mgr->dev.class = fpga_mgr_class;
+	mgr->dev.parent = dev;
+	mgr->dev.of_node = dev->of_node;
+	mgr->dev.release = fpga_mgr_dev_release;
+	mgr->dev.id = id;
+	dev_set_name(&mgr->dev, "%d", id);
+	ret = device_add(&mgr->dev);
+	if (ret)
+		goto error_device;
+
+	dev_info(&mgr->dev, "%s registered\n", mgr->name);
+
+	return 0;
+
+error_device:
+	ida_simple_remove(&fpga_mgr_ida, id);
+	kfree(mgr);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_register);
+
+/**
+ * fpga_mgr_remove - remove a low level fpga manager driver
+ * @pdev: fpga manager device
+ */
+void fpga_mgr_remove(struct platform_device *pdev)
+{
+	struct list_head *tmp;
+	struct fpga_manager *mgr = NULL;
+
+	list_for_each(tmp, &fpga_manager_list) {
+		mgr = list_entry(tmp, struct fpga_manager, list);
+		if (mgr->dev.parent == &pdev->dev) {
+			device_unregister(&mgr->dev);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(fpga_mgr_remove);
+
+static int __init fpga_mgr_dev_init(void)
+{
+	pr_info("FPGA Manager framework driver\n");
+
+	fpga_mgr_class = class_create(THIS_MODULE, "fpga_manager");
+	if (IS_ERR(fpga_mgr_class))
+		return PTR_ERR(fpga_mgr_class);
+
+	if (IS_ENABLED(CONFIG_FPGA_MGR_SYSFS))
+		fpga_mgr_class->dev_groups = fpga_mgr_groups;
+
+	fpga_mgr_class->pm = &fpga_mgr_dev_pm_ops;
+
+	return 0;
+}
+
+static void __exit fpga_mgr_dev_exit(void)
+{
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
diff --git a/include/linux/fpga/fpga-mgr.h b/include/linux/fpga/fpga-mgr.h
new file mode 100644
index 0000000..dcf2c68
--- /dev/null
+++ b/include/linux/fpga/fpga-mgr.h
@@ -0,0 +1,124 @@
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
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/limits.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+#ifndef _LINUX_FPGA_MGR_H
+#define _LINUX_FPGA_MGR_H
+
+struct fpga_manager;
+
+/**
+ * struct fpga_manager_ops - ops for low level fpga manager drivers
+ * @state: returns an enum value of the FPGA's state
+ * @reset: put FPGA into reset state
+ * @write_init: prepare the FPGA to receive confuration data
+ * @write: write count bytes of configuration data to the FPGA
+ * @write_complete: set FPGA to operating state after writing is done
+ * @fpga_remove: optional: Set FPGA into a specific state during driver remove
+ * @suspend: optional: low level fpga suspend
+ * @resume: optional: low level fpga resume
+ *
+ * fpga_manager_ops are the low level functions implemented by a specific
+ * fpga manager driver.  The optional ones are tested for NULL before being
+ * called, so leaving them out is fine.
+ */
+struct fpga_manager_ops {
+	enum fpga_mgr_states (*state)(struct fpga_manager *mgr);
+	int (*reset)(struct fpga_manager *mgr);
+	int (*write_init)(struct fpga_manager *mgr);
+	int (*write)(struct fpga_manager *mgr, const char *buf, size_t count);
+	int (*write_complete)(struct fpga_manager *mgr);
+	void (*fpga_remove)(struct fpga_manager *mgr);
+	int (*suspend)(struct fpga_manager *mgr);
+	int (*resume)(struct fpga_manager *mgr);
+};
+
+/**
+ * enum fpga_mgr_states - fpga framework states
+ * @FPGA_MGR_STATE_UNKNOWN: can't determine state
+ * @FPGA_MGR_STATE_POWER_OFF: FPGA power is off
+ * @FPGA_MGR_STATE_POWER_UP: FPGA reports power is up
+ * @FPGA_MGR_STATE_RESET: FPGA in reset state
+ * @FPGA_MGR_STATE_FIRMWARE_REQ: firmware request in progress
+ * @FPGA_MGR_STATE_FIRMWARE_REQ_ERR: firmware request failed
+ * @FPGA_MGR_STATE_WRITE_INIT: preparing FPGA for programming
+ * @FPGA_MGR_STATE_WRITE_INIT_ERR: Error during WRITE_INIT stage
+ * @FPGA_MGR_STATE_WRITE: writing image to FPGA
+ * @FPGA_MGR_STATE_WRITE_ERR: Error while writing FPGA
+ * @FPGA_MGR_STATE_WRITE_COMPLETE: Doing post programming steps
+ * @FPGA_MGR_STATE_WRITE_COMPLETE_ERR: Error during WRITE_COMPLETE
+ * @FPGA_MGR_STATE_OPERATING: FPGA is programmed and operating
+ */
+enum fpga_mgr_states {
+	FPGA_MGR_STATE_UNKNOWN,
+	FPGA_MGR_STATE_POWER_OFF,
+	FPGA_MGR_STATE_POWER_UP,
+	FPGA_MGR_STATE_RESET,
+
+	/* write sequence */
+	FPGA_MGR_STATE_FIRMWARE_REQ,
+	FPGA_MGR_STATE_FIRMWARE_REQ_ERR,
+	FPGA_MGR_STATE_WRITE_INIT,
+	FPGA_MGR_STATE_WRITE_INIT_ERR,
+	FPGA_MGR_STATE_WRITE,
+	FPGA_MGR_STATE_WRITE_ERR,
+	FPGA_MGR_STATE_WRITE_COMPLETE,
+	FPGA_MGR_STATE_WRITE_COMPLETE_ERR,
+
+	FPGA_MGR_STATE_OPERATING,
+};
+
+/**
+ * struct fpga_manager - fpga manager structure
+ * @name: name of low level fpga manager
+ * @dev: fpga manager device
+ * @list: entry in list of all fpga managers
+ * @lock: lock on calls to fpga manager ops
+ * @state: state of fpga manager
+ * @image_name: name of fpga image file if any
+ * @mops: pointer to struct of fpga manager ops
+ * @priv: low level driver private date
+ */
+struct fpga_manager {
+	const char *name;
+	struct device dev;
+	struct list_head list;
+	struct mutex lock;	/* lock on calls to ops */
+	enum fpga_mgr_states state;
+	char *image_name;
+
+	const struct fpga_manager_ops *mops;
+	void *priv;
+};
+
+#define to_fpga_manager(d) container_of(d, struct fpga_manager, dev)
+
+int fpga_mgr_firmware_write(struct fpga_manager *mgr, const char *image_name);
+int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count);
+int fpga_mgr_name(struct fpga_manager *mgr, char *buf);
+int fpga_mgr_reset(struct fpga_manager *mgr);
+int fpga_mgr_register(struct device *pdev, const char *name,
+		      const struct fpga_manager_ops *mops, void *priv);
+void fpga_mgr_remove(struct platform_device *pdev);
+
+#endif /*_LINUX_FPGA_MGR_H */
-- 
1.7.9.5

