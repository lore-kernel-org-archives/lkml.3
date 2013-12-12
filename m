Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3LLOVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:21:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36068 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3LLOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:20 -0500
Message-Id: <20131212141655.059169830@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 08/15] preempt: Take away preempt_enable_no_resched() from modules
References: <20131212140835.729222186@infradead.org>
Content-Disposition: inline; filename=peterz-hide-preempt_enable_no_resched-modules.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discourage drivers/modules to be creative with preemption.

Sadly all is implemented in macros and inline so if they want to do
evil they still can, but at least try and discourage some.

Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/preempt.h |   22 ++++++++++++++++++++--
 include/linux/uaccess.h |    5 ++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -64,7 +64,11 @@ do { \
 } while (0)
 
 #else
-#define preempt_enable() preempt_enable_no_resched()
+#define preempt_enable() \
+do { \
+	barrier(); \
+	preempt_count_dec(); \
+} while (0)
 #define preempt_check_resched() do { } while (0)
 #endif
 
@@ -93,7 +97,11 @@ do { \
 		__preempt_schedule_context(); \
 } while (0)
 #else
-#define preempt_enable_notrace() preempt_enable_no_resched_notrace()
+#define preempt_enable_notrace() \
+do { \
+	barrier(); \
+	__preempt_count_dec(); \
+} while (0)
 #endif
 
 #else /* !CONFIG_PREEMPT_COUNT */
@@ -126,6 +134,16 @@ do { \
 #define preempt_fold_need_resched() do { } while (0)
 #endif
 
+#ifdef MODULE
+/*
+ * Modules have no business playing preemption tricks.
+ */
+#undef sched_preempt_enable_no_resched
+#undef preempt_enable_no_resched
+#undef preempt_enable_no_resched_notrace
+#undef preempt_check_resched
+#endif
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
 struct preempt_notifier;
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -25,13 +25,16 @@ static inline void pagefault_disable(voi
 
 static inline void pagefault_enable(void)
 {
+#ifndef CONFIG_PREEMPT
 	/*
 	 * make sure to issue those last loads/stores before enabling
 	 * the pagefault handler again.
 	 */
 	barrier();
 	preempt_count_dec();
-	preempt_check_resched();
+#else
+	preempt_enable();
+#endif
 }
 
 #ifndef ARCH_HAS_NOCACHE_UACCESS


