Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161336Ab3BONM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:12:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935916Ab3BOMpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:20 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 02/13] ghes: move structures/enum to a header file
Date: Fri, 15 Feb 2013 10:44:50 -0200
Message-Id: <866281753e9de609c88520ebd4880b9d5c64b5cb.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a ghes_edac driver will need to access ghes structures, in order
to properly handle the errors, move those structures to a separate
header file. No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/acpi/apei/ghes.c | 47 ++---------------------------------------------
 include/acpi/ghes.h      | 45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 45 deletions(-)
 create mode 100644 include/acpi/ghes.h

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 7ae2750..6d0e146 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -48,8 +48,8 @@
 #include <linux/genalloc.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
-#include <acpi/apei.h>
-#include <acpi/hed.h>
+
+#include <acpi/ghes.h>
 #include <asm/mce.h>
 #include <asm/tlbflush.h>
 #include <asm/nmi.h>
@@ -84,42 +84,6 @@
 	((struct acpi_hest_generic_status *)				\
 	 ((struct ghes_estatus_node *)(estatus_node) + 1))
 
-/*
- * One struct ghes is created for each generic hardware error source.
- * It provides the context for APEI hardware error timer/IRQ/SCI/NMI
- * handler.
- *
- * estatus: memory buffer for error status block, allocated during
- * HEST parsing.
- */
-#define GHES_TO_CLEAR		0x0001
-#define GHES_EXITING		0x0002
-
-struct ghes {
-	struct acpi_hest_generic *generic;
-	struct acpi_hest_generic_status *estatus;
-	u64 buffer_paddr;
-	unsigned long flags;
-	union {
-		struct list_head list;
-		struct timer_list timer;
-		unsigned int irq;
-	};
-};
-
-struct ghes_estatus_node {
-	struct llist_node llnode;
-	struct acpi_hest_generic *generic;
-};
-
-struct ghes_estatus_cache {
-	u32 estatus_len;
-	atomic_t count;
-	struct acpi_hest_generic *generic;
-	unsigned long long time_in;
-	struct rcu_head rcu;
-};
-
 bool ghes_disable;
 module_param_named(disable, ghes_disable, bool, 0);
 
@@ -333,13 +297,6 @@ static void ghes_fini(struct ghes *ghes)
 	apei_unmap_generic_address(&ghes->generic->error_status_address);
 }
 
-enum {
-	GHES_SEV_NO = 0x0,
-	GHES_SEV_CORRECTED = 0x1,
-	GHES_SEV_RECOVERABLE = 0x2,
-	GHES_SEV_PANIC = 0x3,
-};
-
 static inline int ghes_severity(int severity)
 {
 	switch (severity) {
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
new file mode 100644
index 0000000..3eb8dc4
--- /dev/null
+++ b/include/acpi/ghes.h
@@ -0,0 +1,45 @@
+#include <acpi/apei.h>
+#include <acpi/hed.h>
+
+/*
+ * One struct ghes is created for each generic hardware error source.
+ * It provides the context for APEI hardware error timer/IRQ/SCI/NMI
+ * handler.
+ *
+ * estatus: memory buffer for error status block, allocated during
+ * HEST parsing.
+ */
+#define GHES_TO_CLEAR		0x0001
+#define GHES_EXITING		0x0002
+
+struct ghes {
+	struct acpi_hest_generic *generic;
+	struct acpi_hest_generic_status *estatus;
+	u64 buffer_paddr;
+	unsigned long flags;
+	union {
+		struct list_head list;
+		struct timer_list timer;
+		unsigned int irq;
+	};
+};
+
+struct ghes_estatus_node {
+	struct llist_node llnode;
+	struct acpi_hest_generic *generic;
+};
+
+struct ghes_estatus_cache {
+	u32 estatus_len;
+	atomic_t count;
+	struct acpi_hest_generic *generic;
+	unsigned long long time_in;
+	struct rcu_head rcu;
+};
+
+enum {
+	GHES_SEV_NO = 0x0,
+	GHES_SEV_CORRECTED = 0x1,
+	GHES_SEV_RECOVERABLE = 0x2,
+	GHES_SEV_PANIC = 0x3,
+};
-- 
1.8.1.2

