Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaFLQ2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:28:53 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55387 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbaFLQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:36 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/12] percpu: introduce arch_raw_cpu_ptr()
Date: Thu, 12 Jun 2014 12:23:19 -0400
Message-Id: <1402590209-31610-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, archs can override raw_cpu_ptr() directly; however, we
wanna build a layer of indirection in the generic part of percpu so
that we can implement generic features there without affecting archs.

Introduce arch_raw_cpu_ptr() which is used to define raw_cpu_ptr() by
generic percpu code.  The two are identical for now.  x86 is currently
the only arch which overrides raw_cpu_ptr() and is converted to
define arch_raw_cpu_ptr() instead.

This doesn't introduce any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/percpu.h |  2 +-
 include/asm-generic/percpu.h  | 11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 851bcdc..9bc23f1 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -52,7 +52,7 @@
  * Compared to the generic __my_cpu_offset version, the following
  * saves one instruction and avoids clobbering a temp register.
  */
-#define raw_cpu_ptr(ptr)				\
+#define arch_raw_cpu_ptr(ptr)				\
 ({							\
 	unsigned long tcp_ptr__;			\
 	__verify_pcpu_ptr(ptr);				\
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 63d2b68..a247d80 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -53,9 +53,16 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define per_cpu(var, cpu) \
 	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))
 
-#ifndef raw_cpu_ptr
-#define raw_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
+/*
+ * Arch may define arch_raw_cpu_ptr() to provide more efficient address
+ * translations for raw_cpu_ptr().
+ */
+#ifndef arch_raw_cpu_ptr
+#define arch_raw_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
 #endif
+
+#define raw_cpu_ptr(ptr) arch_raw_cpu_ptr(ptr)
+
 #ifdef CONFIG_DEBUG_PREEMPT
 #define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
 #else
-- 
1.9.3

