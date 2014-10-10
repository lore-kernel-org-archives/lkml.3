Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaJJXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:25:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:14043 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaJJXZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:25:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="612737918"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] Move pagefault_enable/disable to own include file
Date: Fri, 10 Oct 2014 16:25:14 -0700
Message-Id: <1412983517-12419-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
References: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Move pagefault_enable/disable from linux/uaccess.h to
an own include file. This avoids an include loop
with asm/uaccess.h needing these inlines in its own
inlines.

linux/uaccess.h still includes the header so there
is no change for any existing users.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h |  1 +
 include/linux/pagefault.h      | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/uaccess.h        | 34 +---------------------------------
 3 files changed, 41 insertions(+), 33 deletions(-)
 create mode 100644 include/linux/pagefault.h

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 0d592e0..e50a84f 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -7,6 +7,7 @@
 #include <linux/compiler.h>
 #include <linux/thread_info.h>
 #include <linux/string.h>
+#include <linux/pagefault.h>
 #include <asm/asm.h>
 #include <asm/page.h>
 #include <asm/smap.h>
diff --git a/include/linux/pagefault.h b/include/linux/pagefault.h
new file mode 100644
index 0000000..f9520bd
--- /dev/null
+++ b/include/linux/pagefault.h
@@ -0,0 +1,39 @@
+#ifndef _LINUX_PAGEFAULT_H
+#define _LINUX_PAGEFAULT_H 1
+
+#include <linux/preempt.h>
+
+/*
+ * These routines enable/disable the pagefault handler in that
+ * it will not take any locks and go straight to the fixup table.
+ *
+ * They have great resemblance to the preempt_disable/enable calls
+ * and in fact they are identical; this is because currently there is
+ * no other way to make the pagefault handlers do this. So we do
+ * disable preemption but we don't necessarily care about that.
+ */
+static inline void pagefault_disable(void)
+{
+	preempt_count_inc();
+	/*
+	 * make sure to have issued the store before a pagefault
+	 * can hit.
+	 */
+	barrier();
+}
+
+static inline void pagefault_enable(void)
+{
+#ifndef CONFIG_PREEMPT
+	/*
+	 * make sure to issue those last loads/stores before enabling
+	 * the pagefault handler again.
+	 */
+	barrier();
+	preempt_count_dec();
+#else
+	preempt_enable();
+#endif
+}
+
+#endif
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index ecd3319..9a5e894 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -2,41 +2,9 @@
 #define __LINUX_UACCESS_H__
 
 #include <linux/preempt.h>
+#include <linux/pagefault.h>
 #include <asm/uaccess.h>
 
-/*
- * These routines enable/disable the pagefault handler in that
- * it will not take any locks and go straight to the fixup table.
- *
- * They have great resemblance to the preempt_disable/enable calls
- * and in fact they are identical; this is because currently there is
- * no other way to make the pagefault handlers do this. So we do
- * disable preemption but we don't necessarily care about that.
- */
-static inline void pagefault_disable(void)
-{
-	preempt_count_inc();
-	/*
-	 * make sure to have issued the store before a pagefault
-	 * can hit.
-	 */
-	barrier();
-}
-
-static inline void pagefault_enable(void)
-{
-#ifndef CONFIG_PREEMPT
-	/*
-	 * make sure to issue those last loads/stores before enabling
-	 * the pagefault handler again.
-	 */
-	barrier();
-	preempt_count_dec();
-#else
-	preempt_enable();
-#endif
-}
-
 #ifndef ARCH_HAS_NOCACHE_UACCESS
 
 static inline unsigned long __copy_from_user_inatomic_nocache(void *to,
-- 
1.9.3

