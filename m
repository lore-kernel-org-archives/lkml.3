Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaAMP5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:57:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaAMP5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:57:40 -0500
Date: Mon, 13 Jan 2014 07:56:56 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-fn7h6vu8wtgxk0ih402qcijx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        rusty@rustcorp.com.au, peterz@infradead.org, bitbucket@online.de,
        eliezer.tamir@linux.intel.com, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, arjan@linux.intel.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bitbucket@online.de, eliezer.tamir@linux.intel.com,
        akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/preempt:
  Take away preempt_enable_no_resched() from modules
Git-Commit-ID: 62b94a08da1bae9d187d49dfcd6665af393750f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:57:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62b94a08da1bae9d187d49dfcd6665af393750f8
Gitweb:     http://git.kernel.org/tip/62b94a08da1bae9d187d49dfcd6665af393750f8
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 20 Nov 2013 16:52:19 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:37 +0100

sched/preempt: Take away preempt_enable_no_resched() from modules

Discourage drivers/modules to be creative with preemption.

Sadly all is implemented in macros and inline so if they want to do
evil they still can, but at least try and discourage some.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: rui.zhang@intel.com
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: hpa@zytor.com
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-fn7h6vu8wtgxk0ih402qcijx@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/preempt.h | 22 ++++++++++++++++++++--
 include/linux/uaccess.h |  5 ++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index a3d9dc8..dd9ddf8 100644
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
@@ -116,6 +124,16 @@ do { \
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
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
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 9d8cf05..ecd3319 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -25,13 +25,16 @@ static inline void pagefault_disable(void)
 
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
