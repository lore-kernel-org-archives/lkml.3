Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaFLQ2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:28:36 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:34200 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbaFLQXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:40 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] percpu: reorganize include/linux/percpu-defs.h
Date: Thu, 12 Jun 2014 12:23:22 -0400
Message-Id: <1402590209-31610-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize for better readability.

* Accessor definitions are collected into one place and SMP and UP now
  define them in the same order.

* Definitions are layered when possible - e.g. per_cpu() is now
  defined in terms of this_cpu_ptr().

* Rather pointless comment dropped.

* per_cpu(), __raw_get_cpu_var() and __get_cpu_var() are defined in a
  way which can be shared between SMP and UP and moved out of
  CONFIG_SMP blocks.

This patch doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu-defs.h | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index f25bb94..bd86f46 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -224,15 +224,8 @@
 	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
 })
 
-/*
- * A percpu variable may point to a discarded regions. The following are
- * established ways to produce a usable pointer from the percpu variable
- * offset.
- */
-#define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
-
-#define raw_cpu_ptr(ptr) arch_raw_cpu_ptr(ptr)
+#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
+#define raw_cpu_ptr(ptr)	arch_raw_cpu_ptr(ptr)
 
 #ifdef CONFIG_DEBUG_PREEMPT
 #define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
@@ -240,9 +233,6 @@
 #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
 #endif
 
-#define __get_cpu_var(var) (*this_cpu_ptr(&(var)))
-#define __raw_get_cpu_var(var) (*raw_cpu_ptr(&(var)))
-
 #else	/* CONFIG_SMP */
 
 #define VERIFY_PERCPU_PTR(__p) ({			\
@@ -250,14 +240,16 @@
 	(typeof(*(__p)) __kernel __force *)(__p);	\
 })
 
-#define per_cpu(var, cpu)	(*((void)(cpu), VERIFY_PERCPU_PTR(&(var))))
-#define __get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
-#define __raw_get_cpu_var(var)	(*VERIFY_PERCPU_PTR(&(var)))
-#define this_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
-#define raw_cpu_ptr(ptr)	this_cpu_ptr(ptr)
+#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
+#define raw_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
+#define this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
 
 #endif	/* CONFIG_SMP */
 
+#define per_cpu(var, cpu)	(*per_cpu_ptr(&(var), cpu))
+#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
+#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
+
 /* keep until we have removed all uses of __this_cpu_ptr */
 #define __this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
 
@@ -287,11 +279,5 @@
 	preempt_enable();				\
 } while (0)
 
-#ifdef CONFIG_SMP
-#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
-#else
-#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
-#endif
-
 #endif /* __ASSEMBLY__ */
 #endif /* _LINUX_PERCPU_DEFS_H */
-- 
1.9.3

