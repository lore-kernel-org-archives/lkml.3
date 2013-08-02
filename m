Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3HBVKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:10:34 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39928 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab3HBVJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:09:43 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 3/3] smp.h: Move !SMP version of on_each_cpu() out-of-line
Date: Fri,  2 Aug 2013 14:09:36 -0700
Message-Id: <1375477776-13302-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com>
References: <1375477776-13302-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

All of the other non-trivial !SMP versions of functions in smp.h are
out-of-line in up.c.  Move on_each_cpu() there as well.

This allows us to get rid of the #include <linux/irqflags.h>.  The
drawback is that this makes both the x86_64 and i386 defconfig !SMP
kernels about 200 bytes larger each.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 include/linux/smp.h | 21 +++++----------------
 kernel/up.c         | 11 +++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 3724a90..cfb7ca0 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -11,7 +11,6 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 #include <linux/init.h>
-#include <linux/irqflags.h>
 
 extern void cpu_idle(void);
 
@@ -30,6 +29,11 @@ int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
 			     int wait);
 
 /*
+ * Call a function on all processors
+ */
+int on_each_cpu(smp_call_func_t func, void *info, int wait);
+
+/*
  * Call a function on processors specified by mask, which might include
  * the local one.
  */
@@ -112,11 +116,6 @@ static inline void call_function_init(void) { }
 #endif
 
 /*
- * Call a function on all processors
- */
-int on_each_cpu(smp_call_func_t func, void *info, int wait);
-
-/*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
  */
@@ -141,16 +140,6 @@ static inline int up_smp_call_function(smp_call_func_t func, void *info)
 #define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
 
-static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	func(info);
-	local_irq_restore(flags);
-	return 0;
-}
-
 static inline void smp_send_reschedule(int cpu) { }
 #define smp_prepare_boot_cpu()			do {} while (0)
 #define smp_call_function_many(mask, func, info, wait) \
diff --git a/kernel/up.c b/kernel/up.c
index b1cf036..630d72b 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -22,6 +22,17 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+int on_each_cpu(smp_call_func_t func, void *info, int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	func(info);
+	local_irq_restore(flags);
+	return 0;
+}
+EXPORT_SYMBOL(on_each_cpu);
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
-- 
1.7.11.7

