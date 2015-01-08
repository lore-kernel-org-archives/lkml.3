Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbbAHBBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:01:41 -0500
Received: from ozlabs.org ([103.22.144.67]:49696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630AbbAHBBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:01:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3/3] module: fix race in kallsyms resolution during module load success.
Date: Thu,  8 Jan 2015 11:28:07 +1030
Message-Id: <1420678687-30548-4-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420678687-30548-1-git-send-email-rusty@rustcorp.com.au>
References: <1420678687-30548-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kallsyms routines (module_symbol_name, lookup_module_* etc) disable
preemption to walk the modules rather than taking the module_mutex:
this is because they are used for symbol resolution during oopses.

This works because there are synchronize_sched() and synchronize_rcu()
in the unload and failure paths.  However, there's one case which doesn't
have that: the normal case where module loading succeeds, and we free
the init section.

We don't want a synchronize_rcu() there, because it would slow down
module loading: this bug was introduced in 2009 to speed module
loading in the first place.

Thus, we want to do the free in an RCU callback.  We do this in the
simplest possible way by allocating a new rcu_head: if we put it in
the module structure we'd have to worry about that getting freed.

Reported-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c | 55 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1f85fd5c89d3..ed4ec9c30bd2 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2989,10 +2989,31 @@ static void do_mod_ctors(struct module *mod)
 #endif
 }
 
+/* For freeing module_init on success, in case kallsyms traversing */
+struct mod_initfree {
+	struct rcu_head rcu;
+	void *module_init;
+};
+
+static void do_free_init(struct rcu_head *head)
+{
+	struct mod_initfree *m = container_of(head, struct mod_initfree, rcu);
+	module_memfree(m->module_init);
+	kfree(m);
+}
+
 /* This is where the real work happens */
 static int do_init_module(struct module *mod)
 {
 	int ret = 0;
+	struct mod_initfree *freeinit;
+
+	freeinit = kmalloc(sizeof(*freeinit), GFP_KERNEL);
+	if (!freeinit) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	freeinit->module_init = mod->module_init;
 
 	/*
 	 * We want to find out whether @mod uses async during init.  Clear
@@ -3005,18 +3026,7 @@ static int do_init_module(struct module *mod)
 	if (mod->init != NULL)
 		ret = do_one_initcall(mod->init);
 	if (ret < 0) {
-		/*
-		 * Init routine failed: abort.  Try to protect us from
-		 * buggy refcounters.
-		 */
-		mod->state = MODULE_STATE_GOING;
-		synchronize_sched();
-		module_put(mod);
-		blocking_notifier_call_chain(&module_notify_list,
-					     MODULE_STATE_GOING, mod);
-		free_module(mod);
-		wake_up_all(&module_wq);
-		return ret;
+		goto fail_free_freeinit;
 	}
 	if (ret > 0) {
 		pr_warn("%s: '%s'->init suspiciously returned %d, it should "
@@ -3062,15 +3072,34 @@ static int do_init_module(struct module *mod)
 #endif
 	unset_module_init_ro_nx(mod);
 	module_arch_freeing_init(mod);
-	module_memfree(mod->module_init);
 	mod->module_init = NULL;
 	mod->init_size = 0;
 	mod->init_ro_size = 0;
 	mod->init_text_size = 0;
+	/*
+	 * We want to free module_init, but be aware that kallsyms may be
+	 * walking this with preempt disabled.  In all the failure paths,
+	 * we call synchronize_rcu/synchronize_sched, but we don't want
+	 * to slow down the success path, so use actual RCU here.
+	 */
+	call_rcu(&freeinit->rcu, do_free_init);
 	mutex_unlock(&module_mutex);
 	wake_up_all(&module_wq);
 
 	return 0;
+
+fail_free_freeinit:
+	kfree(freeinit);
+fail:
+	/* Try to protect us from buggy refcounters. */
+	mod->state = MODULE_STATE_GOING;
+	synchronize_sched();
+	module_put(mod);
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_GOING, mod);
+	free_module(mod);
+	wake_up_all(&module_wq);
+	return ret;
 }
 
 static int may_init_module(void)
-- 
2.1.0

