Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaDCWSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:18:35 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:62599 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaDCWRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:17:54 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 20/20] of: push struct boot_param_header and defines into powerpc
Date: Thu,  3 Apr 2014 17:17:03 -0500
Message-Id: <1396563423-30893-21-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Now powerpc is the only user of struct boot_param_header and FDT defines,
so they can be moved into the powerpc architecture code.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/include/asm/prom.h | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/of_fdt.h          | 37 -------------------------------------
 2 files changed, 39 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index d977b9b..74b79f0 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -26,6 +26,45 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 
+#define OF_DT_BEGIN_NODE	0x1		/* Start of node, full name */
+#define OF_DT_END_NODE		0x2		/* End node */
+#define OF_DT_PROP		0x3		/* Property: name off, size,
+						 * content */
+#define OF_DT_NOP		0x4		/* nop */
+#define OF_DT_END		0x9
+
+#define OF_DT_VERSION		0x10
+
+/*
+ * This is what gets passed to the kernel by prom_init or kexec
+ *
+ * The dt struct contains the device tree structure, full pathes and
+ * property contents. The dt strings contain a separate block with just
+ * the strings for the property names, and is fully page aligned and
+ * self contained in a page, so that it can be kept around by the kernel,
+ * each property name appears only once in this page (cheap compression)
+ *
+ * the mem_rsvmap contains a map of reserved ranges of physical memory,
+ * passing it here instead of in the device-tree itself greatly simplifies
+ * the job of everybody. It's just a list of u64 pairs (base/size) that
+ * ends when size is 0
+ */
+struct boot_param_header {
+	__be32	magic;			/* magic word OF_DT_HEADER */
+	__be32	totalsize;		/* total size of DT block */
+	__be32	off_dt_struct;		/* offset to structure */
+	__be32	off_dt_strings;		/* offset to strings */
+	__be32	off_mem_rsvmap;		/* offset to memory reserve map */
+	__be32	version;		/* format version */
+	__be32	last_comp_version;	/* last compatible version */
+	/* version 2 fields below */
+	__be32	boot_cpuid_phys;	/* Physical CPU id we're booting on */
+	/* version 3 fields below */
+	__be32	dt_strings_size;	/* size of the DT strings block */
+	/* version 17 fields below */
+	__be32	dt_struct_size;		/* size of the DT structure block */
+};
+
 /*
  * OF address retreival & translation
  */
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index aa7fb87..7f67790 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -17,47 +17,10 @@
 
 /* Definitions used by the flattened device tree */
 #define OF_DT_HEADER		0xd00dfeed	/* marker */
-#define OF_DT_BEGIN_NODE	0x1		/* Start of node, full name */
-#define OF_DT_END_NODE		0x2		/* End node */
-#define OF_DT_PROP		0x3		/* Property: name off, size,
-						 * content */
-#define OF_DT_NOP		0x4		/* nop */
-#define OF_DT_END		0x9
-
-#define OF_DT_VERSION		0x10
 
 #ifndef __ASSEMBLY__
 #include <linux/libfdt.h>
 
-/*
- * This is what gets passed to the kernel by prom_init or kexec
- *
- * The dt struct contains the device tree structure, full pathes and
- * property contents. The dt strings contain a separate block with just
- * the strings for the property names, and is fully page aligned and
- * self contained in a page, so that it can be kept around by the kernel,
- * each property name appears only once in this page (cheap compression)
- *
- * the mem_rsvmap contains a map of reserved ranges of physical memory,
- * passing it here instead of in the device-tree itself greatly simplifies
- * the job of everybody. It's just a list of u64 pairs (base/size) that
- * ends when size is 0
- */
-struct boot_param_header {
-	__be32	magic;			/* magic word OF_DT_HEADER */
-	__be32	totalsize;		/* total size of DT block */
-	__be32	off_dt_struct;		/* offset to structure */
-	__be32	off_dt_strings;		/* offset to strings */
-	__be32	off_mem_rsvmap;		/* offset to memory reserve map */
-	__be32	version;		/* format version */
-	__be32	last_comp_version;	/* last compatible version */
-	/* version 2 fields below */
-	__be32	boot_cpuid_phys;	/* Physical CPU id we're booting on */
-	/* version 3 fields below */
-	__be32	dt_strings_size;	/* size of the DT strings block */
-	/* version 17 fields below */
-	__be32	dt_struct_size;		/* size of the DT structure block */
-};
 
 #if defined(CONFIG_OF_FLATTREE)
 
-- 
1.8.3.2

