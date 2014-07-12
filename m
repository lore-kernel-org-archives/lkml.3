Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaGLRB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 13:01:56 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:37400 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaGLRBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 13:01:55 -0400
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, rostedt@goodmis.org,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH v3] rcu: define tracepoint strings only if CONFIG_TRACING is set
Date: Sat, 12 Jul 2014 19:01:49 +0200
Message-Id: <1405184509-12601-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f7f7bac9cb1c ("rcu: Have the RCU tracepoints use the tracepoint_string
infrastructure") unconditionally populates the __tracepoint_str input section,
but this section is not assigned an output section if CONFIG_TRACING is not set.
This results in the __tracepoint_str turning up in unexpected places, i.e.,
after _edata.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: rostedt@goodmis.org
Cc: paulmck@linux.vnet.ibm.com
---
v3:
- make definition of <var>_varname conditional as well
v2:
- s/DEFINE_TPS/DEFINE_RCU_TPS/

 kernel/rcu/tree.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba77363fbb..0756a4696007 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -79,9 +79,18 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
  * the tracing userspace tools to be able to decipher the string
  * address to the matching string.
  */
-#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
+#ifdef CONFIG_TRACING
+# define DEFINE_RCU_TPS(sname) \
 static char sname##_varname[] = #sname; \
-static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
+static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
+# define RCU_STATE_NAME(sname) sname##_varname
+#else
+# define DEFINE_RCU_TPS(sname)
+# define RCU_STATE_NAME(sname) __stringify(sname)
+#endif
+
+#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
+DEFINE_RCU_TPS(sname) \
 struct rcu_state sname##_state = { \
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
@@ -93,7 +102,7 @@ struct rcu_state sname##_state = { \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
 	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
-	.name = sname##_varname, \
+	.name = RCU_STATE_NAME(sname), \
 	.abbr = sabbr, \
 }; \
 DEFINE_PER_CPU(struct rcu_data, sname##_data)
-- 
1.8.3.2

