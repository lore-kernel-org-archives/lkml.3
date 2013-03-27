Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3C0O7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:59:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:29553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab3C0O7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:59:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="276679490"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/5] mei: move mei-me to separate module
Date: Wed, 27 Mar 2013 16:58:30 +0200
Message-Id: <1364396310-10718-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
References: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei layer provides host bus message layer, client management,
and os interface

mei-me - provides access to ME hardware through
the pci bus

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Kconfig     | 5 ++---
 drivers/misc/mei/Makefile    | 6 ++++--
 drivers/misc/mei/init.c      | 7 +++++--
 drivers/misc/mei/interrupt.c | 4 ++++
 drivers/misc/mei/main.c      | 4 ++++
 5 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/Kconfig b/drivers/misc/mei/Kconfig
index d21b4d0..c76fa31 100644
--- a/drivers/misc/mei/Kconfig
+++ b/drivers/misc/mei/Kconfig
@@ -10,10 +10,9 @@ config INTEL_MEI
 	  <http://software.intel.com/en-us/manageability/>
 
 config INTEL_MEI_ME
-	bool "ME Enabled Intel Chipsets"
-	depends on INTEL_MEI
+	tristate "ME Enabled Intel Chipsets"
+	select INTEL_MEI
 	depends on X86 && PCI && WATCHDOG_CORE
-	default y
 	help
 	  MEI support for ME Enabled Intel chipsets.
 
diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 040af6c..2c336d0 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -10,5 +10,7 @@ mei-objs += client.o
 mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
-mei-$(CONFIG_INTEL_MEI_ME) += pci-me.o
-mei-$(CONFIG_INTEL_MEI_ME) += hw-me.o
+
+obj-$(CONFIG_INTEL_MEI_ME) += mei-me.o
+mei-me-objs := pci-me.o
+mei-me-objs += hw-me.o
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index b3f7c3e..c1c8d76 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/export.h>
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -67,6 +68,7 @@ void mei_device_init(struct mei_device *dev)
 	mei_io_list_init(&dev->amthif_rd_complete_list);
 
 }
+EXPORT_SYMBOL_GPL(mei_device_init);
 
 /**
  * mei_start - initializes host and fw to start work.
@@ -136,6 +138,7 @@ err:
 	mutex_unlock(&dev->device_lock);
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(mei_start);
 
 /**
  * mei_reset - resets host and fw.
@@ -203,6 +206,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	/* remove all waiting requests */
 	mei_cl_all_write_clear(dev);
 }
+EXPORT_SYMBOL_GPL(mei_reset);
 
 void mei_stop(struct mei_device *dev)
 {
@@ -222,9 +226,8 @@ void mei_stop(struct mei_device *dev)
 	flush_scheduled_work();
 
 	mei_watchdog_unregister(dev);
-
 }
-
+EXPORT_SYMBOL_GPL(mei_stop);
 
 
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 73fbce3..6ce45ef 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -15,6 +15,7 @@
  */
 
 
+#include <linux/export.h>
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
@@ -78,6 +79,7 @@ void mei_irq_compl_handler(struct mei_device *dev, struct mei_cl_cb *compl_list)
 			mei_cl_complete_handler(cl, cb);
 	}
 }
+EXPORT_SYMBOL_GPL(mei_irq_compl_handler);
 /**
  * _mei_irq_thread_state_ok - checks if mei header matches file private data
  *
@@ -440,6 +442,7 @@ int mei_irq_read_handler(struct mei_device *dev,
 end:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mei_irq_read_handler);
 
 
 /**
@@ -590,6 +593,7 @@ int mei_irq_write_handler(struct mei_device *dev, struct mei_cl_cb *cmpl_list)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mei_irq_write_handler);
 
 
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 903f809..27b3df2 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -758,12 +758,16 @@ int mei_register(struct device *dev)
 	mei_misc_device.parent = dev;
 	return misc_register(&mei_misc_device);
 }
+EXPORT_SYMBOL_GPL(mei_register);
 
 void mei_deregister(void)
 {
 	misc_deregister(&mei_misc_device);
 	mei_misc_device.parent = NULL;
 }
+EXPORT_SYMBOL_GPL(mei_deregister);
 
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
 MODULE_LICENSE("GPL v2");
 
-- 
1.7.11.7

