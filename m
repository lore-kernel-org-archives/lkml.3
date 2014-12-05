Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaLELSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:18:25 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:52135 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLELSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:18:23 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: [PATCH v1 2/5] uaccess: count pagefault_disable() levels in pagefault_count
Date: Fri,  5 Dec 2014 12:18:06 +0100
Message-Id: <1417778289-51567-3-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120511-0021-0000-0000-0000020802F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pagefault_disable() and pagefault_enable() have to increment/decrement the
pagefault_count. We keep manipulating the preempt count to retain compability
to existing pagefault handlers. This has to be demangled in separate patches.

It is now possible to verify whether in a pagefault_disable() envionment by
calling pagefault_disabled().

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 include/linux/uaccess.h | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index ecd3319..1dfc678 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -2,20 +2,45 @@
 #define __LINUX_UACCESS_H__
 
 #include <linux/preempt.h>
+#include <linux/thread_info.h>
 #include <asm/uaccess.h>
 
+static __always_inline int pagefault_count(void)
+{
+	return current_thread_info()->pagefault_count;
+}
+
+static __always_inline int *pagefault_count_ptr(void)
+{
+	return &current_thread_info()->pagefault_count;
+}
+
+static __always_inline void pagefault_count_inc(void)
+{
+	(*pagefault_count_ptr())++;
+}
+
+static __always_inline void pagefault_count_dec(void)
+{
+	(*pagefault_count_ptr())--;
+}
+
 /*
- * These routines enable/disable the pagefault handler in that
- * it will not take any locks and go straight to the fixup table.
+ * These routines enable/disable the pagefault handler. If disabled, it will
+ * not take any locks and go straight to the fixup table.
+ *
+ * We increase the preempt and the pagefault count, to be able to distinguish
+ * whether we run in simple atomic context or in a real pagefault_disable()
+ * context.
+ *
+ * For now, after pagefault_disabled() has been called, we run in atomic
+ * context. User access methods will not sleep.
  *
- * They have great resemblance to the preempt_disable/enable calls
- * and in fact they are identical; this is because currently there is
- * no other way to make the pagefault handlers do this. So we do
- * disable preemption but we don't necessarily care about that.
  */
 static inline void pagefault_disable(void)
 {
 	preempt_count_inc();
+	pagefault_count_inc();
 	/*
 	 * make sure to have issued the store before a pagefault
 	 * can hit.
@@ -25,18 +50,24 @@ static inline void pagefault_disable(void)
 
 static inline void pagefault_enable(void)
 {
-#ifndef CONFIG_PREEMPT
 	/*
 	 * make sure to issue those last loads/stores before enabling
 	 * the pagefault handler again.
 	 */
 	barrier();
+	pagefault_count_dec();
+#ifndef CONFIG_PREEMPT
 	preempt_count_dec();
 #else
 	preempt_enable();
 #endif
 }
 
+/*
+ * Is the pagefault handler disabled? If so, user access methods will not sleep.
+ */
+#define pagefault_disabled() (pagefault_count() != 0)
+
 #ifndef ARCH_HAS_NOCACHE_UACCESS
 
 static inline unsigned long __copy_from_user_inatomic_nocache(void *to,
-- 
1.8.5.5

