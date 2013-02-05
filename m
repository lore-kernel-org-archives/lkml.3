Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab3BEWNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:13:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48263 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab3BEWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 85/93] module: fix symbol waiting when module fails before init
Date: Tue,  5 Feb 2013 20:07:14 -0200
Message-Id: <1360102042-10732-86-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 6f13909f4fe9652f189b462c6c98767309000321 upstream.

We use resolve_symbol_wait(), which blocks if the module containing
the symbol is still loading.  However:

1) The module_wq we use is only woken after calling the modules' init
   function, but there are other failure paths after the module is
   placed in the linked list where we need to do the same thing.

2) wake_up() only wakes one waiter, and our waitqueue is shared by all
   modules, so we need to wake them all.

3) wake_up_all() doesn't imply a memory barrier: I feel happier calling
   it after we've grabbed and dropped the module_mutex, not just after
   the state assignment.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/module.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 2a15c59..27e302a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2984,7 +2984,7 @@ static struct module *load_module(void __user *umod,
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
 	module_bug_cleanup(mod);
-
+	wake_up_all(&module_wq);
  ddebug:
 	dynamic_debug_remove(info.debug);
  unlock:
@@ -3059,7 +3059,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 		blocking_notifier_call_chain(&module_notify_list,
 					     MODULE_STATE_GOING, mod);
 		free_module(mod);
-		wake_up(&module_wq);
+		wake_up_all(&module_wq);
 		return ret;
 	}
 	if (ret > 0) {
@@ -3071,9 +3071,8 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 		dump_stack();
 	}
 
-	/* Now it's a first class citizen!  Wake up anyone waiting for it. */
+	/* Now it's a first class citizen! */
 	mod->state = MODULE_STATE_LIVE;
-	wake_up(&module_wq);
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
@@ -3096,6 +3095,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	mod->init_ro_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
+	wake_up_all(&module_wq);
 
 	return 0;
 }
-- 
1.7.9.5

