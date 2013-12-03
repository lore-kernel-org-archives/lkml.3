Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3LCOiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:38:52 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37560 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3LCOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:38:36 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/6] context_tracking: Wrap static key check into more intuitive function name
Date: Tue,  3 Dec 2013 15:38:23 +0100
Message-Id: <1386081506-24358-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
References: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a function with a meaningful name to check the global context
tracking state. static_key_false() is a bit confusing for reviewers.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/context_tracking.h       | 10 +++++-----
 include/linux/context_tracking_state.h |  4 ++++
 include/linux/tick.h                   |  2 +-
 include/linux/vtime.h                  |  2 +-
 kernel/context_tracking.c              |  8 ++++----
 5 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 1581587..37b81bd 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -17,13 +17,13 @@ extern void __context_tracking_task_switch(struct task_struct *prev,
 
 static inline void user_enter(void)
 {
-	if (static_key_false(&context_tracking_enabled))
+	if (context_tracking_is_enabled())
 		context_tracking_user_enter();
 
 }
 static inline void user_exit(void)
 {
-	if (static_key_false(&context_tracking_enabled))
+	if (context_tracking_is_enabled())
 		context_tracking_user_exit();
 }
 
@@ -31,7 +31,7 @@ static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
 
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return 0;
 
 	prev_ctx = this_cpu_read(context_tracking.state);
@@ -42,7 +42,7 @@ static inline enum ctx_state exception_enter(void)
 
 static inline void exception_exit(enum ctx_state prev_ctx)
 {
-	if (static_key_false(&context_tracking_enabled)) {
+	if (context_tracking_is_enabled()) {
 		if (prev_ctx == IN_USER)
 			context_tracking_user_enter();
 	}
@@ -51,7 +51,7 @@ static inline void exception_exit(enum ctx_state prev_ctx)
 static inline void context_tracking_task_switch(struct task_struct *prev,
 						struct task_struct *next)
 {
-	if (static_key_false(&context_tracking_enabled))
+	if (context_tracking_is_enabled())
 		__context_tracking_task_switch(prev, next);
 }
 #else
diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index 0f1979d..0db535b 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -22,6 +22,10 @@ struct context_tracking {
 extern struct static_key context_tracking_enabled;
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
+static inline bool context_tracking_is_enabled(void)
+{
+	return static_key_false(&context_tracking_enabled);
+}
 static inline bool context_tracking_in_user(void)
 {
 	return __this_cpu_read(context_tracking.state) == IN_USER;
diff --git a/include/linux/tick.h b/include/linux/tick.h
index a004f66..0175d86 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -165,7 +165,7 @@ extern cpumask_var_t tick_nohz_full_mask;
 
 static inline bool tick_nohz_full_enabled(void)
 {
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return false;
 
 	return tick_nohz_full_running;
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index f5b72b3..807c732 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -19,7 +19,7 @@ static inline bool vtime_accounting_enabled(void) { return true; }
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 static inline bool vtime_accounting_enabled(void)
 {
-	if (static_key_false(&context_tracking_enabled)) {
+	if (context_tracking_is_enabled()) {
 		if (context_tracking_active())
 			return true;
 	}
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index e5f3917..6cb20d2 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -53,10 +53,10 @@ void context_tracking_user_enter(void)
 	/*
 	 * Repeat the user_enter() check here because some archs may be calling
 	 * this from asm and if no CPU needs context tracking, they shouldn't
-	 * go further. Repeat the check here until they support the static key
-	 * check.
+	 * go further. Repeat the check here until they support the inline static
+	 * key check.
 	 */
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return;
 
 	/*
@@ -160,7 +160,7 @@ void context_tracking_user_exit(void)
 {
 	unsigned long flags;
 
-	if (!static_key_false(&context_tracking_enabled))
+	if (!context_tracking_is_enabled())
 		return;
 
 	if (in_interrupt())
-- 
1.8.3.1

