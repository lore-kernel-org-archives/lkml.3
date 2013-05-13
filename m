Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3EMJfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:35:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:21520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab3EMJeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:34:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,660,1363158000"; 
   d="scan'208";a="336184379"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: [PATCH v2 1/3] driver: add TXT driver in kernel
Date: Tue, 14 May 2013 01:24:42 +0800
Message-Id: <1368465884-14779-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
References: <1368465884-14779-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TXT driver can be used to access below resources:
  - TXT config space
  - SMX parameter

Intel TXT (Trusted Execution Technology) will provide higher
assurance of system configuration and initial state as well as
data reset protection. It also helps solve real end user concerns
about having confidence that their hardware is running the VMM
or kernel that it was configured with, especially since they may
be responsible for providing such assurances to VMs and services
running on it.

See Documentation/intel_txt.txt for more information about
Intel TXT.

Intel TXT configuration registers are a subset of chipset registers.
These chipset registers that interact with SMX are accessed from two
regions of memory, which represent the public and private configuration
spaces, by system software using memory read/write protocols.

Safer Mode Extensions (SMX) provide a processor's programming
interface in an Intel TXT platform for system software to establish
a measured environment within the platform to support trust decisions
by end users.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 drivers/platform/x86/Kconfig               |    2 +
 drivers/platform/x86/Makefile              |    1 +
 drivers/platform/x86/intel_txt/Kconfig     |   27 ++++++++++++
 drivers/platform/x86/intel_txt/Makefile    |    5 +++
 drivers/platform/x86/intel_txt/txt-sysfs.c |   62 ++++++++++++++++++++++++++++
 5 files changed, 97 insertions(+)
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
index 0000000..dd81b21
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/Kconfig
@@ -0,0 +1,27 @@
+#
+# intel TXT driver configuration
+#
+
+config INTEL_TXT_DRIVER
+	tristate "INTEL TXT sysfs driver"
+	default m
+	depends on INTEL_TXT
+	select SECURITYFS
+	---help---
+	  TXT Driver can be used to access below resources:
+	    - TXT config space
+	    - SMX parameter
+
+	  Intel TXT configuration registers are a subset of chipset
+	  registers. These chipset registers that interact with SMX
+	  are accessed from two regions of memory, which represent
+	  the public and private configuration spaces, by system
+	  software using memory read/write protocols.
+
+	  Safer Mode Extensions (SMX) provide a processor's programming
+	  interface in an Intel TXT platform for system software to
+	  establish a measured environment within the platform to support
+	  trust decisions by end users.
+
+	  To compile this driver as a module, choose M here; the module
+	  will be called intel_txt.
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
index 0000000..3ea7307
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/txt-sysfs.c
@@ -0,0 +1,62 @@
+/*
+ * txt-sysfs.c
+ *
+ * This module can be used to access below resources
+ *   - TXT config space
+ *   - SMX parameter
+ *
+ * Intel TXT (Trusted Execution Technology) will provide higher
+ * assurance of system configuration and initial state as well as
+ * data reset protection. It also helps solve real end user concerns
+ * about having confidence that their hardware is running the VMM
+ * or kernel that it was configured with, especially since they may
+ * be responsible for providing such assurances to VMs and services
+ * running on it.
+ *
+ * See Documentation/intel_txt.txt for more information about
+ * Intel TXT.
+ *
+ * Intel TXT configuration registers are a subset of chipset registers.
+ * These chipset registers that interact with SMX are accessed from two
+ * regions of memory, which represent the public and private configuration
+ * spaces, by system software using memory read/write protocols.
+ *
+ * Safer Mode Extensions (SMX) provide a processor's programming
+ * interface in an Intel TXT platform for system software to establish
+ * a measured environment within the platform to support trust decisions
+ * by end users.
+ *
+ * Data can be found below
+ *   /sys/devices/platform/intel_txt/...
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfs.h>
+#include <linux/tboot.h>
+
+#define DEV_NAME "intel_txt"
+static struct platform_device *txt_pdev;
+
+static int __init txt_sysfs_init(void)
+{
+	if (!tboot_enabled())
+		return -ENODEV;
+
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

