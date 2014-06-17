Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaFQXUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:20:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60391 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbaFQXUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:20:34 -0400
Date: Tue, 17 Jun 2014 19:20:30 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH UPDATED 12/12] percpu: invoke __verify_pcpu_ptr() from the
 generic part of accessors and operations
Message-ID: <20140617232030.GC8838@mtj.dyndns.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
 <1402590209-31610-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402590209-31610-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6fbc07bbe2b5a898532f970c5a397f8789ace0d5 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 17 Jun 2014 19:12:40 -0400

__verify_pcpu_ptr() is used to verify that a specified parameter is
actually an percpu pointer by percpu accessor and operation
implementations.  Currently, where it's called isn't clearly defined
and we just ensure that it's invoked at least once for all accessors
and operations.

The lack of clarity on when it should be called isn't nice and given
that this is a completely generic issue, there's no reason to make
archs worry about it.

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
Description updated to reflect dropping of data dependency barrier
patch.

Thanks.

 arch/x86/include/asm/percpu.h |  1 -
 include/linux/percpu-defs.h   | 29 +++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

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
index d8bb6e0..c93fff1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -191,9 +191,12 @@
 #ifndef __ASSEMBLY__
 
 /*
- * Macro which verifies @ptr is a percpu pointer without evaluating
- * @ptr.  This is to be used in percpu accessors to verify that the
- * input parameter is a percpu pointer.
+ * __verify_pcpu_ptr() verifies @ptr is a percpu pointer without evaluating
+ * @ptr and is invoked once before a percpu area is accessed by all
+ * accessors and operations.  This is performed in the generic part of
+ * percpu and arch overrides don't need to worry about it; however, if an
+ * arch wants to implement an arch-specific percpu accessor or operation,
+ * it may use __verify_pcpu_ptr() to verify the parameters.
  *
  * + 0 is required in order to convert the pointer type from a
  * potential array type to a pointer to a single item of the array.
@@ -212,16 +215,26 @@ do {									\
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

