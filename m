Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaJGKtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:49:47 -0400
Received: from ozlabs.org ([103.22.144.67]:40961 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbaJGKtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:49:42 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v3 12/16] cxl: Add base builtin support
Date: Tue,  7 Oct 2014 21:48:18 +1100
Message-Id: <1412678902-18672-13-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412678902-18672-1-git-send-email-mikey@neuling.org>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This adds the base cxl support that needs to be build into the kernel to use
cxl as a module. This is needed so that the cxl call backs from the core
powerpc mm code always exist irrespective of if the cxl module is loaded or
not. This is similar to how cell works with CONFIG_SPU_BASE.

This adds a cxl_slbia() call (similar to spu_flush_all_slbs()) which checks for
the cxl module being loaded. If the modules is not loaded we return, otherwise
we call into the cxl SLB invalidation code.

This also adds the cxl_ctx_in_use() function for use in the mm code to see if
any cxl contexts are currently in use. This is used by the tlbie() to
determine if it can do local TLB invalidations or not. This also adds get/put
calls for the cxl driver module to refcount the active cxl contexts.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 drivers/misc/Kconfig      |  1 +
 drivers/misc/Makefile     |  1 +
 drivers/misc/cxl/Kconfig  |  8 +++++
 drivers/misc/cxl/Makefile |  1 +
 drivers/misc/cxl/base.c   | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 97 insertions(+)
 create mode 100644 drivers/misc/cxl/Kconfig
 create mode 100644 drivers/misc/cxl/Makefile
 create mode 100644 drivers/misc/cxl/base.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b841180..bbeb451 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -527,4 +527,5 @@ source "drivers/misc/vmw_vmci/Kconfig"
 source "drivers/misc/mic/Kconfig"
 source "drivers/misc/genwqe/Kconfig"
 source "drivers/misc/echo/Kconfig"
+source "drivers/misc/cxl/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 5497d02..7d5c4cd 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -55,3 +55,4 @@ obj-y				+= mic/
 obj-$(CONFIG_GENWQE)		+= genwqe/
 obj-$(CONFIG_ECHO)		+= echo/
 obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
+obj-$(CONFIG_CXL_BASE)		+= cxl/
diff --git a/drivers/misc/cxl/Kconfig b/drivers/misc/cxl/Kconfig
new file mode 100644
index 0000000..5cdd319
--- /dev/null
+++ b/drivers/misc/cxl/Kconfig
@@ -0,0 +1,8 @@
+#
+# IBM Coherent Accelerator (CXL) compatible devices
+#
+
+config CXL_BASE
+	bool
+	default n
+	select PPC_COPRO_BASE
diff --git a/drivers/misc/cxl/Makefile b/drivers/misc/cxl/Makefile
new file mode 100644
index 0000000..e30ad0a
--- /dev/null
+++ b/drivers/misc/cxl/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CXL_BASE)		+= base.o
diff --git a/drivers/misc/cxl/base.c b/drivers/misc/cxl/base.c
new file mode 100644
index 0000000..0654ad8
--- /dev/null
+++ b/drivers/misc/cxl/base.c
@@ -0,0 +1,86 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/rcupdate.h>
+#include <asm/errno.h>
+#include <misc/cxl.h>
+#include "cxl.h"
+
+/* protected by rcu */
+static struct cxl_calls *cxl_calls;
+
+atomic_t cxl_use_count = ATOMIC_INIT(0);
+EXPORT_SYMBOL(cxl_use_count);
+
+#ifdef CONFIG_CXL_MODULE
+
+static inline struct cxl_calls *cxl_calls_get(void)
+{
+	struct cxl_calls *calls = NULL;
+
+	rcu_read_lock();
+	calls = rcu_dereference(cxl_calls);
+	if (calls && !try_module_get(calls->owner))
+		calls = NULL;
+	rcu_read_unlock();
+
+	return calls;
+}
+
+static inline void cxl_calls_put(struct cxl_calls *calls)
+{
+	BUG_ON(calls != cxl_calls);
+
+	/* we don't need to rcu this, as we hold a reference to the module */
+	module_put(cxl_calls->owner);
+}
+
+#else /* !defined CONFIG_CXL_MODULE */
+
+static inline struct cxl_calls *cxl_calls_get(void)
+{
+	return cxl_calls;
+}
+
+static inline void cxl_calls_put(struct cxl_calls *calls) { }
+
+#endif /* CONFIG_CXL_MODULE */
+
+void cxl_slbia(struct mm_struct *mm)
+{
+	struct cxl_calls *calls;
+
+	calls = cxl_calls_get();
+	if (!calls)
+		return;
+
+	if (cxl_ctx_in_use())
+	    calls->cxl_slbia(mm);
+
+	cxl_calls_put(calls);
+}
+
+int register_cxl_calls(struct cxl_calls *calls)
+{
+	if (cxl_calls)
+		return -EBUSY;
+
+	rcu_assign_pointer(cxl_calls, calls);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_cxl_calls);
+
+void unregister_cxl_calls(struct cxl_calls *calls)
+{
+	BUG_ON(cxl_calls->owner != calls->owner);
+	RCU_INIT_POINTER(cxl_calls, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(unregister_cxl_calls);
-- 
1.9.1

