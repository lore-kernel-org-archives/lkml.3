Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaJGKth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:49:37 -0400
Received: from ozlabs.org ([103.22.144.67]:57066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaJGKtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:49:35 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v3 07/16] cxl: Add new header for call backs and structs
Date: Tue,  7 Oct 2014 21:48:13 +1100
Message-Id: <1412678902-18672-8-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412678902-18672-1-git-send-email-mikey@neuling.org>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This new header adds callbacks and structs needed by the rest of the kernel to
hook into the cxl infrastructure.

cxl_ctx_get/put/in_use are static inlined here as they are called in tlbie
which we want to be fast (mpe's suggestion).

Empty functions are provided when CONFIG_CXL_BASE is not enabled.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 include/misc/cxl.h | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 include/misc/cxl.h

diff --git a/include/misc/cxl.h b/include/misc/cxl.h
new file mode 100644
index 0000000..10cb742
--- /dev/null
+++ b/include/misc/cxl.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _MISC_CXL_H
+#define _MISC_CXL_H
+
+#define CXL_IRQ_RANGES 4
+
+struct cxl_irq_ranges {
+	irq_hw_number_t offset[CXL_IRQ_RANGES];
+	irq_hw_number_t range[CXL_IRQ_RANGES];
+};
+
+#ifdef CONFIG_CXL_BASE
+
+extern atomic_t cxl_use_count;
+
+static inline bool cxl_ctx_in_use(void)
+{
+       return (atomic_read(&cxl_use_count) != 0);
+}
+
+static inline void cxl_ctx_get(void)
+{
+       atomic_inc(&cxl_use_count);
+}
+
+static inline void cxl_ctx_put(void)
+{
+       atomic_dec(&cxl_use_count);
+}
+
+void cxl_slbia(struct mm_struct *mm);
+
+#else /* CONFIG_CXL_BASE */
+
+static inline bool cxl_ctx_in_use(void) { return false; }
+static inline void cxl_slbia(struct mm_struct *mm) {}
+
+#endif /* CONFIG_CXL_BASE */
+
+#endif
-- 
1.9.1

