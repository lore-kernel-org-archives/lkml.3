Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaGKLi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:38:26 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39383 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaGKLiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:38:24 -0400
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, rostedt@goodmis.org,
        dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com
Subject: [PATCH] rcu: define tracepoint strings only if CONFIG_TRACING is set
Date: Fri, 11 Jul 2014 13:38:12 +0200
Message-Id: <1405078692-29957-1-git-send-email-ard.biesheuvel@linaro.org>
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
Cc: dipankar@in.ibm.com
Cc: paulmck@linux.vnet.ibm.com
---
 kernel/rcu/tree.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index f1ba77363fbb..ac1984149eb5 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -79,9 +79,16 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
  * the tracing userspace tools to be able to decipher the string
  * address to the matching string.
  */
+#ifdef CONFIG_TRACING
+#define DEFINE_TPS(sname) \
+static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
+#else
+#define DEFINE_TPS(sname)
+#endif
+
 #define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
 static char sname##_varname[] = #sname; \
-static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
+DEFINE_TPS(sname) \
 struct rcu_state sname##_state = { \
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
-- 
1.8.3.2

