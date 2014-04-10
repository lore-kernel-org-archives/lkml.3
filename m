Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030804AbaDJNBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:01:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:41131 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030615AbaDJNBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:01:02 -0400
Message-Id: <20140410130059.526268061@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 10 Apr 2014 09:00:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 1/2] tracepoint: Fix sparse warnings in tracepoint.c
References: <20140410130021.634516192@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracepoint-Fix-sparse-warnings-in-tracepoint.c.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Fix the following sparse warnings:

  CHECK   kernel/tracepoint.c
kernel/tracepoint.c:184:18: warning: incorrect type in assignment (different address spaces)
kernel/tracepoint.c:184:18:    expected struct tracepoint_func *tp_funcs
kernel/tracepoint.c:184:18:    got struct tracepoint_func [noderef] <asn:4>*funcs
kernel/tracepoint.c:216:18: warning: incorrect type in assignment (different address spaces)
kernel/tracepoint.c:216:18:    expected struct tracepoint_func *tp_funcs
kernel/tracepoint.c:216:18:    got struct tracepoint_func [noderef] <asn:4>*funcs
kernel/tracepoint.c:392:24: error: return expression in void function
  CC      kernel/tracepoint.o
kernel/tracepoint.c: In function tracepoint_module_going:
kernel/tracepoint.c:491:6: warning: symbol 'syscall_regfunc' was not declared. Should it be static?
kernel/tracepoint.c:508:6: warning: symbol 'syscall_unregfunc' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/1397049883-28692-1-git-send-email-mathieu.desnoyers@efficios.com

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h      | 5 +++++
 include/trace/events/syscalls.h | 3 ---
 kernel/tracepoint.c             | 6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 69a298b..9d30ee4 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -80,6 +80,11 @@ static inline void tracepoint_synchronize_unregister(void)
 	synchronize_sched();
 }
 
+#ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
+extern void syscall_regfunc(void);
+extern void syscall_unregfunc(void);
+#endif /* CONFIG_HAVE_SYSCALL_TRACEPOINTS */
+
 #define PARAMS(args...) args
 
 #endif /* _LINUX_TRACEPOINT_H */
diff --git a/include/trace/events/syscalls.h b/include/trace/events/syscalls.h
index 5a4c04a..14e49c7 100644
--- a/include/trace/events/syscalls.h
+++ b/include/trace/events/syscalls.h
@@ -13,9 +13,6 @@
 
 #ifdef CONFIG_HAVE_SYSCALL_TRACEPOINTS
 
-extern void syscall_regfunc(void);
-extern void syscall_unregfunc(void);
-
 TRACE_EVENT_FN(sys_enter,
 
 	TP_PROTO(struct pt_regs *regs, long id),
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 162be19..ca2cfe2 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -181,7 +181,8 @@ static int tracepoint_add_func(struct tracepoint *tp,
 	if (tp->regfunc && !static_key_enabled(&tp->key))
 		tp->regfunc();
 
-	tp_funcs = tp->funcs;
+	tp_funcs = rcu_dereference_protected(tp->funcs,
+			lockdep_is_held(&tracepoints_mutex));
 	old = func_add(&tp_funcs, func);
 	if (IS_ERR(old)) {
 		WARN_ON_ONCE(1);
@@ -213,7 +214,8 @@ static int tracepoint_remove_func(struct tracepoint *tp,
 {
 	struct tracepoint_func *old, *tp_funcs;
 
-	tp_funcs = tp->funcs;
+	tp_funcs = rcu_dereference_protected(tp->funcs,
+			lockdep_is_held(&tracepoints_mutex));
 	old = func_remove(&tp_funcs, func);
 	if (IS_ERR(old)) {
 		WARN_ON_ONCE(1);
-- 
1.8.5.3


