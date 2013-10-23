Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3JWKjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:39:41 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50397 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3JWKjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:39:40 -0400
X-Spam-Score: -100.8
Message-ID: <5267A72B.7060808@asianux.com>
Date: Wed, 23 Oct 2013 18:38:35 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, khilman@linaro.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: context_tracking: use extern function instead of
 static inline function for user_enter/exit()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The related assemble code can not find the static inline function. The
related commit "ad65782 context_tracking: Optimize main APIs off case
with static key" causes this issue.

The related error (for arm, with allmodconfig):

    LD      init/built-in.o
  arch/arm/kernel/built-in.o: In function `ret_fast_syscall':
  arch/arm/kernel/entry-common.S:42: undefined reference to `user_enter'
  arch/arm/kernel/built-in.o: In function `no_work_pending':
  arch/arm/kernel/entry-common.S:77: undefined reference to `user_enter'
  arch/arm/kernel/built-in.o: In function `vector_swi':
  arch/arm/kernel/entry-common.S:376: undefined reference to `user_exit'
  arch/arm/kernel/built-in.o: In function `__dabt_usr':
  arch/arm/kernel/entry-armv.S:365: undefined reference to `user_exit'
  arch/arm/kernel/built-in.o: In function `__irq_usr':
  arch/arm/kernel/entry-armv.S:375: undefined reference to `user_exit'
  arch/arm/kernel/built-in.o: In function `__und_usr':
  arch/arm/kernel/entry-armv.S:388: undefined reference to `user_exit'
  arch/arm/kernel/built-in.o: In function `__pabt_usr':
  arch/arm/kernel/entry-armv.S:662: undefined reference to `user_exit'


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/context_tracking.h |   14 ++------------
 kernel/context_tracking.c        |   12 ++++++++++++
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
index 1581587..bf220f7 100644
--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -10,23 +10,13 @@
 #ifdef CONFIG_CONTEXT_TRACKING
 extern void context_tracking_cpu_set(int cpu);
 
+extern void user_enter(void);
+extern void user_exit(void);
 extern void context_tracking_user_enter(void);
 extern void context_tracking_user_exit(void);
 extern void __context_tracking_task_switch(struct task_struct *prev,
 					   struct task_struct *next);
 
-static inline void user_enter(void)
-{
-	if (static_key_false(&context_tracking_enabled))
-		context_tracking_user_enter();
-
-}
-static inline void user_exit(void)
-{
-	if (static_key_false(&context_tracking_enabled))
-		context_tracking_user_exit();
-}
-
 static inline enum ctx_state exception_enter(void)
 {
 	enum ctx_state prev_ctx;
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 013161f..c03d0d6 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -29,6 +29,18 @@ EXPORT_SYMBOL_GPL(context_tracking_enabled);
 DEFINE_PER_CPU(struct context_tracking, context_tracking);
 EXPORT_SYMBOL_GPL(context_tracking);
 
+void user_enter(void)
+{
+	if (static_key_false(&context_tracking_enabled))
+		context_tracking_user_enter();
+}
+
+void user_exit(void)
+{
+	if (static_key_false(&context_tracking_enabled))
+		context_tracking_user_exit();
+}
+
 void context_tracking_cpu_set(int cpu)
 {
 	if (!per_cpu(context_tracking.active, cpu)) {
-- 
1.7.7.6
