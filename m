Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3AXK6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:58:51 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:51288 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3AXKzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:55:54 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 57/71] ARC: Hostlink Pseudo-Driver for Metaware Debugger
Date: Thu, 24 Jan 2013 16:20:34 +0530
Message-ID: <1359024639-21915-21-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows ARC Target to do I/O to host in absence of any peripherals
whatsoever, assisted by Metaware Hostlink facility.

Further we have a FUSE based filesystem which makes us mount/access host
filesystem on target and do fops.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig               |    9 ++++++
 arch/arc/kernel/Makefile       |    1 +
 arch/arc/kernel/arc_hostlink.c |   58 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/kernel/arc_hostlink.c

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 2611a60..cd4ad61 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -389,6 +389,15 @@ config HZ
 	int "Timer Frequency"
 	default 100
 
+config ARC_METAWARE_HLINK
+	bool "Support for Metaware debugger assisted Host access"
+	default n
+	help
+	  This options allows a Linux userland apps to directly access
+	  host file system (open/creat/read/write etc) with help from
+	  Metaware Debugger. This can come in handy for Linux-host communication
+	  when there is no real usable peripheral such as EMAC.
+
 menuconfig ARC_DBG
 	bool "ARC debugging"
 	default y
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 44975b6..b5cd328 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_ARC_DW2_UNWIND)		+= unwind.o
 obj-$(CONFIG_KPROBES)      		+= kprobes.o
 obj-$(CONFIG_ARC_MISALIGN_ACCESS) 	+= unaligned.o
 obj-$(CONFIG_KGDB)			+= kgdb.o
+obj-$(CONFIG_ARC_METAWARE_HLINK)	+= arc_hostlink.o
 
 obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
 CFLAGS_fpu.o   += -mdpfp
diff --git a/arch/arc/kernel/arc_hostlink.c b/arch/arc/kernel/arc_hostlink.c
new file mode 100644
index 0000000..47b2a17
--- /dev/null
+++ b/arch/arc/kernel/arc_hostlink.c
@@ -0,0 +1,58 @@
+/*
+ * arc_hostlink.c: Pseudo-driver for Metaware provided "hostlink" facility
+ *
+ * Allows Linux userland access to host in absence of any peripherals.
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/fs.h>		/* file_operations */
+#include <linux/miscdevice.h>
+#include <linux/mm.h>		/* VM_IO */
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+static unsigned char __HOSTLINK__[4 * PAGE_SIZE] __aligned(PAGE_SIZE);
+
+static int arc_hl_mmap(struct file *fp, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
+			       vma->vm_end - vma->vm_start,
+			       vma->vm_page_prot)) {
+		pr_warn("Hostlink buffer mmap ERROR\n");
+		return -EAGAIN;
+	}
+	return 0;
+}
+
+static long arc_hl_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	/* we only support, returning the physical addr to mmap in user space */
+	put_user((unsigned int)__HOSTLINK__, (int __user *)arg);
+	return 0;
+}
+
+static const struct file_operations arc_hl_fops = {
+	.unlocked_ioctl	= arc_hl_ioctl,
+	.mmap		= arc_hl_mmap,
+};
+
+static struct miscdevice arc_hl_dev = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= "hostlink",
+	.fops	= &arc_hl_fops
+};
+
+static int __init arc_hl_init(void)
+{
+	pr_info("ARC Hostlink driver mmap at 0x%p\n", __HOSTLINK__);
+	return misc_register(&arc_hl_dev);
+}
+module_init(arc_hl_init);
-- 
1.7.4.1

