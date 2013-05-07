Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab3EGHFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:05:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:51457 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab3EGHFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="298699205"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: [PATCH 1/4] driver: add TXT driver in kernel
Date: Tue,  7 May 2013 22:55:16 +0800
Message-Id: <1367938519-840-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
References: <1367938519-840-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TXT driver is expected to be a better tool to access below resources:
TXT config space, TXT log and SMX parameter.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 drivers/platform/x86/Kconfig               |    2 ++
 drivers/platform/x86/Makefile              |    1 +
 drivers/platform/x86/intel_txt/Kconfig     |   17 +++++++++++++
 drivers/platform/x86/intel_txt/Makefile    |    5 ++++
 drivers/platform/x86/intel_txt/txt-sysfs.c |   38 ++++++++++++++++++++++++++++
 5 files changed, 63 insertions(+)
 create mode 100644 drivers/platform/x86/intel_txt/Kconfig
 create mode 100644 drivers/platform/x86/intel_txt/Makefile
 create mode 100644 drivers/platform/x86/intel_txt/txt-sysfs.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3338437..2c50e7d 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -693,6 +693,8 @@ config INTEL_IPS
 	  functionality.  If in doubt, say Y here; it will only load on
 	  supported platforms.
 
+source "drivers/platform/x86/intel_txt/Kconfig"
+
 config IBM_RTL
 	tristate "Device driver to enable PRTL support"
 	depends on X86 && PCI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index ace2b38..669b464 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_INTEL_SCU_IPC)	+= intel_scu_ipc.o
 obj-$(CONFIG_INTEL_SCU_IPC_UTIL) += intel_scu_ipcutil.o
 obj-$(CONFIG_INTEL_MFLD_THERMAL) += intel_mid_thermal.o
 obj-$(CONFIG_INTEL_IPS)		+= intel_ips.o
+obj-$(CONFIG_INTEL_TXT_DRIVER)	+= intel_txt/
 obj-$(CONFIG_GPIO_INTEL_PMIC)	+= intel_pmic_gpio.o
 obj-$(CONFIG_XO1_RFKILL)	+= xo1-rfkill.o
 obj-$(CONFIG_XO15_EBOOK)	+= xo15-ebook.o
diff --git a/drivers/platform/x86/intel_txt/Kconfig b/drivers/platform/x86/intel_txt/Kconfig
new file mode 100644
index 0000000..ddf8b03
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/Kconfig
@@ -0,0 +1,17 @@
+#
+# intel TXT driver configuration
+#
+
+config INTEL_TXT_DRIVER
+       tristate "INTEL TXT sysfs driver"
+       default m
+       depends on INTEL_TXT
+       select SECURITYFS
+       ---help---
+         TXT Driver is expected to be a better tool to access below resources:
+           - TXT config space
+           - Tboot log mem
+           - SMX parameter
+
+         To compile this driver as a module, choose M here; the module will be
+         called txt.
diff --git a/drivers/platform/x86/intel_txt/Makefile b/drivers/platform/x86/intel_txt/Makefile
new file mode 100644
index 0000000..a130308
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the intel TXT drivers.
+#
+obj-$(CONFIG_INTEL_TXT_DRIVER) += intel_txt.o
+intel_txt-y := txt-sysfs.o
diff --git a/drivers/platform/x86/intel_txt/txt-sysfs.c b/drivers/platform/x86/intel_txt/txt-sysfs.c
new file mode 100644
index 0000000..96efe87
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/txt-sysfs.c
@@ -0,0 +1,38 @@
+/*
+ * txt-sysfs.c
+ *
+ * This module is expected to be a better tool to access below resources
+ *   - TXT config space
+ *   - Tboot log mem
+ *   - SMX parameter
+ *
+ * Data is currently found below
+ *   /sys/devices/platform/intel_txt/...
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfs.h>
+
+#define DEV_NAME "intel_txt"
+static struct platform_device *txt_pdev;
+
+static int __init txt_sysfs_init(void)
+{
+	txt_pdev = platform_device_register_simple(DEV_NAME, -1, NULL, 0);
+	if (IS_ERR(txt_pdev))
+		return PTR_ERR(txt_pdev);
+
+	return 0;
+}
+
+static void __exit txt_sysfs_exit(void)
+{
+	platform_device_unregister(txt_pdev);
+}
+
+module_init(txt_sysfs_init);
+module_exit(txt_sysfs_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

