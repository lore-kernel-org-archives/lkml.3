Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaIXIg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:36:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:38755 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaIXI1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:14 -0400
Message-Id: <20140924082242.458562904@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 08/11] module: Fix nested sleep
References: <20140924081845.572814794@infradead.org>
Content-Disposition: inline; filename=peterz-sleep-module.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A genuine bug, we cannot use blocking primitives inside a wait loop.

So rewrite the wait_event_interruptible() usage to use the fresh
wait_woken() stuff.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/module.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3095,6 +3095,32 @@ static int may_init_module(void)
 }
 
 /*
+ * Can't use wait_event_interruptible() because our condition
+ * 'finished_loading()' contains a blocking primitive itself (mutex_lock).
+ */
+static int wait_finished_loading(struct module *mod)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	int ret = 0;
+
+	add_wait_queue(&module_wq, &wait);
+	for (;;) {
+		if (finished_loading(mod->name))
+			break;
+
+		if (signal_pending_state(TASK_INTERRUPTIBLE, current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+	}
+	remove_wait_queue(&module_wq, &wait);
+
+	return ret;
+}
+
+/*
  * We try to place it in the list now to make sure it's unique before
  * we dedicate too many resources.  In particular, temporary percpu
  * memory exhaustion.
@@ -3114,8 +3140,8 @@ static int add_unformed_module(struct mo
 		    || old->state == MODULE_STATE_UNFORMED) {
 			/* Wait in case it fails to load. */
 			mutex_unlock(&module_mutex);
-			err = wait_event_interruptible(module_wq,
-					       finished_loading(mod->name));
+
+			err = wait_finished_loading(mod);
 			if (err)
 				goto out_unlocked;
 			goto again;


