Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaGWJ0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:26:00 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57476 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGWJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:25:55 -0400
Subject: [PATCH 2/2] powerpc/powernv: Interface to add opal dump region
To: linux-kernel@vger.kernel.org
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Date: Wed, 23 Jul 2014 14:55:45 +0530
Message-ID: <20140723092525.5170.25926.stgit@hegdevasant.in.ibm.com>
In-Reply-To: <20140723092506.5170.34633.stgit@hegdevasant.in.ibm.com>
References: <20140723092506.5170.34633.stgit@hegdevasant.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072309-5490-0000-0000-000000757AD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerNV platform is capable of capturing host memory region when system
crashes (because of host/firmware). We have new OPAL API to register
memory region to be capture when system crashes.

This patch adds support for new API and also registers kernel log buffer.

Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/opal.h                   |   12 +++++
 arch/powerpc/platforms/powernv/Makefile           |    2 -
 arch/powerpc/platforms/powernv/opal-dump-region.c |   46 +++++++++++++++++++++
 arch/powerpc/platforms/powernv/opal-wrappers.S    |    1 
 arch/powerpc/platforms/powernv/opal.c             |    2 +
 5 files changed, 62 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/platforms/powernv/opal-dump-region.c

diff --git a/arch/powerpc/include/asm/opal.h b/arch/powerpc/include/asm/opal.h
index 0da1dbd..6b9c01e 100644
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@ -147,6 +147,7 @@ struct opal_sg_list {
 #define OPAL_SET_PARAM				90
 #define OPAL_DUMP_RESEND			91
 #define OPAL_DUMP_INFO2				94
+#define OPAL_REGISTER_DUMP_REGION		98
 
 #ifndef __ASSEMBLY__
 
@@ -860,6 +861,7 @@ int64_t opal_get_param(uint64_t token, uint32_t param_id, uint64_t buffer,
 int64_t opal_set_param(uint64_t token, uint32_t param_id, uint64_t buffer,
 		uint64_t length);
 int64_t opal_sensor_read(uint32_t sensor_hndl, int token, __be32 *sensor_data);
+int64_t opal_register_dump_region(uint32_t id, uint64_t start, uint64_t end);
 
 /* Internal functions */
 extern int early_init_dt_scan_opal(unsigned long node, const char *uname,
@@ -899,6 +901,7 @@ extern int opal_elog_init(void);
 extern void opal_platform_dump_init(void);
 extern void opal_sys_param_init(void);
 extern void opal_msglog_init(void);
+extern void opal_dump_region_init(void);
 
 extern int opal_machine_check(struct pt_regs *regs);
 extern bool opal_mce_check_early_recovery(struct pt_regs *regs);
@@ -912,6 +915,15 @@ struct opal_sg_list *opal_vmalloc_to_sg_list(void *vmalloc_addr,
 					     unsigned long vmalloc_size);
 void opal_free_sg_list(struct opal_sg_list *sg);
 
+/*
+ * Dump regions ids
+ *   0x01 - 0x7F : OPAL
+ *   0x80 - 0xFF : Kernel
+ */
+#define DUMP_REGION_HOST_START		0x80
+#define DUMP_REGION_LOG_BUF		0x80
+#define DUMP_REGION_HOST_END		0xFF
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __OPAL_H */
diff --git a/arch/powerpc/platforms/powernv/Makefile b/arch/powerpc/platforms/powernv/Makefile
index 4ad227d..e2819aa 100644
--- a/arch/powerpc/platforms/powernv/Makefile
+++ b/arch/powerpc/platforms/powernv/Makefile
@@ -1,7 +1,7 @@
 obj-y			+= setup.o opal-wrappers.o opal.o opal-async.o
 obj-y			+= opal-rtc.o opal-nvram.o opal-lpc.o opal-flash.o
 obj-y			+= rng.o opal-elog.o opal-dump.o opal-sysparam.o opal-sensor.o
-obj-y			+= opal-msglog.o
+obj-y			+= opal-msglog.o opal-dump-region.o
 
 obj-$(CONFIG_SMP)	+= smp.o subcore.o subcore-asm.o
 obj-$(CONFIG_PCI)	+= pci.o pci-p5ioc2.o pci-ioda.o
diff --git a/arch/powerpc/platforms/powernv/opal-dump-region.c b/arch/powerpc/platforms/powernv/opal-dump-region.c
new file mode 100644
index 0000000..2cce388
--- /dev/null
+++ b/arch/powerpc/platforms/powernv/opal-dump-region.c
@@ -0,0 +1,46 @@
+/*
+ * PowerNV OPAL dump memory region interface
+ *
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/pagemap.h>
+#include <linux/printk.h>
+#include <asm/opal.h>
+
+/*
+ * Pass kernel address range (start, size) that will be included in
+ * system dump (collected by service processor whenever system crashes).
+ *
+ * @id		: Memory region ID (see opal.h)
+ * @addr	: Start address
+ * @size	: size in bytes
+ */
+static int add_dump_region_entry(uint32_t id, void *addr, uint64_t size)
+{
+	__be32 be_id = cpu_to_be32(id);
+	__be64 be_addr = cpu_to_be64(__pa(addr));
+	__be64 be_size = cpu_to_be64(size);
+
+	return opal_register_dump_region(be_id, be_addr, be_size);
+}
+
+void __init opal_dump_region_init(void)
+{
+	void *addr;
+	uint64_t size;
+	int rc;
+
+	/* Register kernel log buffer */
+	addr = get_log_buf_addr();
+	size = get_log_buf_len();
+	rc = add_dump_region_entry(DUMP_REGION_LOG_BUF, addr, size);
+	if (rc)
+		pr_warn("DUMP: Failed to register kernel log buffer. "
+			"rc = %d\n", rc);
+}
diff --git a/arch/powerpc/platforms/powernv/opal-wrappers.S b/arch/powerpc/platforms/powernv/opal-wrappers.S
index 4abbff2..935c30a 100644
--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -146,3 +146,4 @@ OPAL_CALL(opal_sync_host_reboot,		OPAL_SYNC_HOST_REBOOT);
 OPAL_CALL(opal_sensor_read,			OPAL_SENSOR_READ);
 OPAL_CALL(opal_get_param,			OPAL_GET_PARAM);
 OPAL_CALL(opal_set_param,			OPAL_SET_PARAM);
+OPAL_CALL(opal_register_dump_region,		OPAL_REGISTER_DUMP_REGION);
diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 1999756..2834303 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -616,6 +616,8 @@ static int __init opal_init(void)
 	/* Create "opal" kobject under /sys/firmware */
 	rc = opal_sysfs_init();
 	if (rc == 0) {
+		/* Setup dump region interface */
+		opal_dump_region_init();
 		/* Setup error log interface */
 		rc = opal_elog_init();
 		/* Setup code update interface */

