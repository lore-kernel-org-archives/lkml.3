Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaH1S3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:29:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52832 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaH1S0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/15] rcu: Define tracepoint strings only if CONFIG_TRACING is set
Date: Thu, 28 Aug 2014 11:26:27 -0700
Message-Id: <1409250394-25159-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-3532-0000-0000-0000043705F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Commit f7f7bac9cb1c ("rcu: Have the RCU tracepoints use the tracepoint_string
infrastructure") unconditionally populates the __tracepoint_str input section,
but this section is not assigned an output section if CONFIG_TRACING is not set.
This results in the __tracepoint_str turning up in unexpected places, i.e.,
after _edata.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 2719978ea018..dc52dc3b8c3e 100644
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
1.8.1.5

