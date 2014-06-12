Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbaFLQZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:25:44 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:54376 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaFLQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:49 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/12] percpu: invoke __verify_pcpu_ptr() from the generic part of accessors and operations
Date: Thu, 12 Jun 2014 12:23:29 -0400
Message-Id: <1402590209-31610-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__verify_pcpu_ptr() is used to verify that a specified parameter is
actually an percpu pointer by percpu accessor and operation
implementations.  Currently, where it's called isn't clearly defined
and we just ensure that it's invoked at least once for all accessors
and operations.

As __verify_pcpu_ptr() now includes a data dependency barrier,
invoking it more times than necessary may incur unnecessary overhead.
Alos, the lack of clarity on when it should be called isn't nice and
given that this is a completely generic issue, there's no reason to
make archs worry about it.

This patch updates __verify_pcpu_ptr() invocations such that it's
always invoked from the final generic wrapper once per access or
operation.  As this is already the case for {raw|this}_cpu_*()
definitions through __pcpu_size_*(), only the {raw|per|this}_cpu_ptr()
accessors need to be updated.

This change makes it unnecessary for archs to worry about
__verify_pcpu_ptr().  x86's arch_raw_cpu_ptr() is updated accordingly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/percpu.h |  1 -
 include/linux/percpu-defs.h   | 26 +++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 9bc23f1..fd47218 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -55,7 +55,6 @@
 #define arch_raw_cpu_ptr(ptr)				\
 ({							\
 	unsigned long tcp_ptr__;			\
-	__verify_pcpu_ptr(ptr);				\
 	asm volatile("add " __percpu_arg(1) ", %0"	\
 		     : "=r" (tcp_ptr__)			\
 		     : "m" (this_cpu_off), "0" (ptr));	\
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 31ef245..511bd49 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -193,6 +193,12 @@
 #ifndef __ASSEMBLY__
 
 /*
+ * __verify_pcpu_ptr() must be invoked once before a percpu area is
+ * accessed by all accessors and operations.  This is performed in the
+ * generic part of percpu and arch overrides don't need to worry about it;
+ * however, if an arch wants to implement an arch-specific percpu accessor
+ * or operation, it may use __verify_pcpu_ptr() to verify the parameters.
+ *
  * This macro serves two purposes.  It verifies @ptr is a percpu pointer
  * without evaluating @ptr and provides the data dependency barrier paired
  * with smp_wmb() at the end of the allocation path so that the memory
@@ -221,16 +227,26 @@ do {									\
  * pointer value.  The weird cast keeps both GCC and sparse happy.
  */
 #define SHIFT_PERCPU_PTR(__p, __offset)					\
+	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset))
+
+#define per_cpu_ptr(ptr, cpu)						\
 ({									\
-	__verify_pcpu_ptr(__p);						\
-	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
+	__verify_pcpu_ptr(ptr);						\
+	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)));			\
 })
 
-#define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR(ptr, per_cpu_offset(cpu))
-#define raw_cpu_ptr(ptr)	arch_raw_cpu_ptr(ptr)
+#define raw_cpu_ptr(ptr)						\
+({									\
+	__verify_pcpu_ptr(ptr);						\
+	arch_raw_cpu_ptr(ptr);						\
+})
 
 #ifdef CONFIG_DEBUG_PREEMPT
-#define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
+#define this_cpu_ptr(ptr)						\
+({									\
+	__verify_pcpu_ptr(ptr);						\
+	SHIFT_PERCPU_PTR(ptr, my_cpu_offset);				\
+})
 #else
 #define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
 #endif
-- 
1.9.3

