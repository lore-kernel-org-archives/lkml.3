Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab3F1TbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:31:05 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42267 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab3F1TbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:31:01 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2013 15:30:57 EDT
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>,
        Stef van Os <stef.van.os@Prodrive.nl>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 5/7] rapidio: add modular build option for the subsystem core
Date: Fri, 28 Jun 2013 15:18:54 -0400
Message-Id: <1372447136-5751-6-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
References: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a configuration option to build RapidIO subsystem core code as a loadable
kernel module. Currently this option is available only for x86-based platforms,
with the additional patch for PowerPC planned to be provided later.

This patch replaces kernel command line parameter "riohdid=" with its
module-specific analog "rapidio.hdid=".  

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>
---
 arch/x86/Kconfig         |    4 ++--
 drivers/rapidio/Makefile |    4 +++-
 drivers/rapidio/rio.c    |   27 ++++++++++++++-------------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe120da..583ac42 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2246,11 +2246,11 @@ source "drivers/pcmcia/Kconfig"
 source "drivers/pci/hotplug/Kconfig"
 
 config RAPIDIO
-	bool "RapidIO support"
+	tristate "RapidIO support"
 	depends on PCI
 	default n
 	help
-	  If you say Y here, the kernel will include drivers and
+	  If enabled this option will include drivers and the core
 	  infrastructure code to support RapidIO interconnect devices.
 
 source "drivers/rapidio/Kconfig"
diff --git a/drivers/rapidio/Makefile b/drivers/rapidio/Makefile
index 3036702..6271ada 100644
--- a/drivers/rapidio/Makefile
+++ b/drivers/rapidio/Makefile
@@ -1,7 +1,9 @@
 #
 # Makefile for RapidIO interconnect services
 #
-obj-y += rio.o rio-access.o rio-driver.o rio-sysfs.o
+obj-$(CONFIG_RAPIDIO) += rapidio.o
+rapidio-y := rio.o rio-access.o rio-driver.o rio-sysfs.o
+
 obj-$(CONFIG_RAPIDIO_ENUM_BASIC) += rio-scan.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 2054b62..f4f30af 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -5,7 +5,7 @@
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
  *
- * Copyright 2009 Integrated Device Technology, Inc.
+ * Copyright 2009 - 2013 Integrated Device Technology, Inc.
  * Alex Bounine <alexandre.bounine@idt.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
@@ -30,6 +30,17 @@
 
 #include "rio.h"
 
+MODULE_DESCRIPTION("RapidIO Subsystem Core");
+MODULE_AUTHOR("Matt Porter <mporter@kernel.crashing.org>");
+MODULE_AUTHOR("Alexandre Bounine <alexandre.bounine@idt.com>");
+MODULE_LICENSE("GPL");
+
+static int hdid[RIO_MAX_MPORTS];
+static int ids_num;
+module_param_array(hdid, int, &ids_num, 0);
+MODULE_PARM_DESC(hdid,
+	"Destination ID assignment to local RapidIO controllers");
+
 static LIST_HEAD(rio_devices);
 static DEFINE_SPINLOCK(rio_global_list_lock);
 
@@ -1860,24 +1871,14 @@ no_disc:
 	return 0;
 }
 
-static int hdids[RIO_MAX_MPORTS + 1];
-
 static int rio_get_hdid(int index)
 {
-	if (!hdids[0] || hdids[0] <= index || index >= RIO_MAX_MPORTS)
+	if (ids_num == 0 || ids_num <= index || index >= RIO_MAX_MPORTS)
 		return -1;
 
-	return hdids[index + 1];
+	return hdid[index];
 }
 
-static int rio_hdid_setup(char *str)
-{
-	(void)get_options(str, ARRAY_SIZE(hdids), hdids);
-	return 1;
-}
-
-__setup("riohdid=", rio_hdid_setup);
-
 int rio_register_mport(struct rio_mport *port)
 {
 	struct rio_scan_node *scan = NULL;
-- 
1.7.8.4

