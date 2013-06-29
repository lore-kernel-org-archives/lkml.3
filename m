Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3F2PPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 11:15:21 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:65287 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab3F2PPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 11:15:20 -0400
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        arnd@arndb.de, catalin.marinas@arm.com, will.deacon@arm.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH] sched: add preempt_[disable|enable]_strict()
Date: Sat, 29 Jun 2013 17:15:09 +0200
Message-Id: <1372518909-12609-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add preempt_disable_strict and preempt_enable_strict functions that
can be used to demarcate atomic sections for which we would like
to enforce -even on non-PREEMPT builds with CONFIG_DEBUG_ATOMIC_SLEEP
disabled- that sleeping is not allowed.

The rationale is that in some cases, the risk of data corruption is
high while the likelihood of immediate detection is low, e.g., when
using the NEON unit in kernel mode on arm64.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/preempt.h |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index f5d4723..178bf2e 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -56,29 +56,33 @@ do { \
 #endif /* CONFIG_PREEMPT */
 
 
-#ifdef CONFIG_PREEMPT_COUNT
-
-#define preempt_disable() \
+#define preempt_disable_strict() \
 do { \
 	inc_preempt_count(); \
 	barrier(); \
 } while (0)
 
-#define sched_preempt_enable_no_resched() \
+#define __atomic_end() \
 do { \
 	barrier(); \
 	dec_preempt_count(); \
 } while (0)
 
-#define preempt_enable_no_resched()	sched_preempt_enable_no_resched()
-
-#define preempt_enable() \
+#define preempt_enable_strict() \
 do { \
-	preempt_enable_no_resched(); \
+	__atomic_end(); \
 	barrier(); \
 	preempt_check_resched(); \
 } while (0)
 
+#ifdef CONFIG_PREEMPT_COUNT
+
+#define preempt_disable()	preempt_disable_strict()
+#define preempt_enable()	preempt_enable_strict()
+
+#define sched_preempt_enable_no_resched()	__atomic_end()
+#define preempt_enable_no_resched()		__atomic_end()
+
 /* For debugging and tracer internals only! */
 #define add_preempt_count_notrace(val)			\
 	do { preempt_count() += (val); } while (0)
-- 
1.7.9.5

