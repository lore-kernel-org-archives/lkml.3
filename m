Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3D0HGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 03:06:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:4157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab3D0HFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 03:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,562,1363158000"; 
   d="scan'208";a="303853847"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard L Maliszewski <richard.l.maliszewski@intel.com>,
        Shane Wang <shane.wang@intel.com>, Gang Wei <gang.wei@intel.com>,
        linux-kernel@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Subject: [PATCH 1/5] driver: add TXT driver in kernel
Date: Sat, 27 Apr 2013 22:56:16 +0800
Message-Id: <1367074580-16530-2-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
References: <1367074580-16530-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TXT driver is expected to be a better tool to access below resources:
TXT config space, TXT heap, TXT log and SMX parameter.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 drivers/char/Kconfig         |    2 ++
 drivers/char/Makefile        |    1 +
 drivers/char/txt/Kconfig     |   18 ++++++++++++++++++
 drivers/char/txt/Makefile    |    5 +++++
 drivers/char/txt/txt-sysfs.c |   41 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 67 insertions(+)
 create mode 100644 drivers/char/txt/Kconfig
 create mode 100644 drivers/char/txt/Makefile
 create mode 100644 drivers/char/txt/txt-sysfs.c

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3bb6fa3..9309e89 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -565,6 +565,8 @@ config UV_MMTIMER
 
 source "drivers/char/tpm/Kconfig"
 
+source "drivers/char/txt/Kconfig"
+
 config TELCLOCK
 	tristate "Telecom clock driver for ATCA SBC"
 	depends on X86
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 7ff1d0d..301d5b4 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_HANGCHECK_TIMER)	+= hangcheck-timer.o
 obj-$(CONFIG_TCG_TPM)		+= tpm/
+obj-$(CONFIG_TXT)		+= txt/
 
 obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
 
diff --git a/drivers/char/txt/Kconfig b/drivers/char/txt/Kconfig
new file mode 100644
index 0000000..2e57ef6
--- /dev/null
+++ b/drivers/char/txt/Kconfig
@@ -0,0 +1,18 @@
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
+           - TXT heap
+           - Tboot log mem
+           - SMX parameter
+
+         To compile this driver as a module, choose M here; the module will be
+         called txt.
diff --git a/drivers/char/txt/Makefile b/drivers/char/txt/Makefile
new file mode 100644
index 0000000..3148bb8
--- /dev/null
+++ b/drivers/char/txt/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the intel TXT drivers.
+#
+obj-$(CONFIG_TXT) += txt.o
+txt-y := txt-sysfs.o
diff --git a/drivers/char/txt/txt-sysfs.c b/drivers/char/txt/txt-sysfs.c
new file mode 100644
index 0000000..c56bfe3
--- /dev/null
+++ b/drivers/char/txt/txt-sysfs.c
@@ -0,0 +1,41 @@
+/*
+ * txt-sysfs.c
+ *
+ * This module is expected to be a better tool to access below resources
+ *   - TXT config space
+ *   - TXT heap
+ *   - Tboot log mem
+ *   - SMX parameter
+ *
+ * Data is currently found below
+ *   /sys/devices/platform/txt/...
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfs.h>
+
+#define DEV_NAME "txt"
+struct platform_device *pdev;
+
+static int __init txt_sysfs_init(void)
+{
+	pdev = platform_device_register_simple(DEV_NAME, -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	pr_info("Loading TXT module successfully\n");
+	return 0;
+}
+
+static void __exit txt_sysfs_exit(void)
+{
+	platform_device_unregister(pdev);
+	pr_info("Unloading TXT module successfully\n");
+}
+
+module_init(txt_sysfs_init);
+module_exit(txt_sysfs_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

