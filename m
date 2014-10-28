Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaJ1LMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:12:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbaJ1LMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:12:19 -0400
Date: Tue, 28 Oct 2014 04:11:24 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-3c9b2c3d64a49f264422d7743599cf7f6535972d@git.kernel.org>
Cc: gregkh@linuxfoundation.org, tglx@linutronix.de, hpa@zytor.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, fengguang.wu@intel.com, peterz@infradead.org
Reply-To: gregkh@linuxfoundation.org, hpa@zytor.com, tglx@linutronix.de,
        rusty@rustcorp.com.au, mingo@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fengguang.wu@intel.com
In-Reply-To: <20140924082242.458562904@infradead.org>
References: <20140924082242.458562904@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, modules:
  Fix nested sleep in add_unformed_module()
Git-Commit-ID: 3c9b2c3d64a49f264422d7743599cf7f6535972d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c9b2c3d64a49f264422d7743599cf7f6535972d
Gitweb:     http://git.kernel.org/tip/3c9b2c3d64a49f264422d7743599cf7f6535972d
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:56:30 +0100

sched, modules: Fix nested sleep in add_unformed_module()

This is a genuine bug in add_unformed_module(), we cannot use blocking
primitives inside a wait loop.

So rewrite the wait_event_interruptible() usage to use the fresh
wait_woken() stuff.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: oleg@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/20140924082242.458562904@infradead.org
[ So this is probably complex to backport and the race wasn't reported AFAIK,
  so not marked for -stable. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/module.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 88cec1d..e52a873 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3097,6 +3097,32 @@ static int may_init_module(void)
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
+		if (signal_pending(current)) {
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
@@ -3116,8 +3142,8 @@ again:
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
