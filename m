Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab3BEWPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:15:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48275 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab3BEWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:13:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 88/93] module: put modules in list much earlier.
Date: Tue,  5 Feb 2013 20:07:17 -0200
Message-Id: <1360102042-10732-89-git-send-email-herton.krzesinski@canonical.com>
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

commit 1fb9341ac34825aa40354e74d9a2c69df7d2c304 upstream.

Prarit's excellent bug report:
> In recent Fedora releases (F17 & F18) some users have reported seeing
> messages similar to
>
> [   15.478160] kvm: Could not allocate 304 bytes percpu data
> [   15.478174] PERCPU: allocation failed, size=304 align=32, alloc from
> reserved chunk failed
>
> during system boot.  In some cases, users have also reported seeing this
> message along with a failed load of other modules.
>
> What is happening is systemd is loading an instance of the kvm module for
> each cpu found (see commit e9bda3b).  When the module load occurs the kernel
> currently allocates the modules percpu data area prior to checking to see
> if the module is already loaded or is in the process of being loaded.  If
> the module is already loaded, or finishes load, the module loading code
> releases the current instance's module's percpu data.

Now we have a new state MODULE_STATE_UNFORMED, we can insert the
module into the list (and thus guarantee its uniqueness) before we
allocate the per-cpu region.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Tested-by: Prarit Bhargava <prarit@redhat.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/module.c |   90 ++++++++++++++++++++++++++++++-------------------------
 lib/bug.c       |    1 +
 2 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index a2bc837..19716ac 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2897,7 +2897,7 @@ static bool finished_loading(const char *name)
 	bool ret;
 
 	mutex_lock(&module_mutex);
-	mod = find_module(name);
+	mod = find_module_all(name, true);
 	ret = !mod || mod->state == MODULE_STATE_LIVE
 		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
@@ -2930,10 +2930,36 @@ static struct module *load_module(void __user *umod,
 		goto free_copy;
 	}
 
+	/*
+	 * We try to place it in the list now to make sure it's unique
+	 * before we dedicate too many resources.  In particular,
+	 * temporary percpu memory exhaustion.
+	 */
+	mod->state = MODULE_STATE_UNFORMED;
+again:
+	mutex_lock(&module_mutex);
+	if ((old = find_module_all(mod->name, true)) != NULL) {
+		if (old->state == MODULE_STATE_COMING
+		    || old->state == MODULE_STATE_UNFORMED) {
+			/* Wait in case it fails to load. */
+			mutex_unlock(&module_mutex);
+			err = wait_event_interruptible(module_wq,
+					       finished_loading(mod->name));
+			if (err)
+				goto free_module;
+			goto again;
+		}
+		err = -EEXIST;
+		mutex_unlock(&module_mutex);
+		goto free_module;
+	}
+	list_add_rcu(&mod->list, &modules);
+	mutex_unlock(&module_mutex);
+
 	/* Now module is in final location, initialize linked lists, etc. */
 	err = module_unload_init(mod);
 	if (err)
-		goto free_module;
+		goto unlink_mod;
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
@@ -2968,54 +2994,33 @@ static struct module *load_module(void __user *umod,
 		goto free_arch_cleanup;
 	}
 
-	/* Mark state as coming so strong_try_module_get() ignores us. */
-	mod->state = MODULE_STATE_COMING;
-
-	/* Now sew it into the lists so we can get lockdep and oops
-	 * info during argument parsing.  No one should access us, since
-	 * strong_try_module_get() will fail.
-	 * lockdep/oops can run asynchronous, so use the RCU list insertion
-	 * function to insert in a way safe to concurrent readers.
-	 * The mutex protects against concurrent writers.
-	 */
-again:
-	mutex_lock(&module_mutex);
-	if ((old = find_module(mod->name)) != NULL) {
-		if (old->state == MODULE_STATE_COMING) {
-			/* Wait in case it fails to load. */
-			mutex_unlock(&module_mutex);
-			err = wait_event_interruptible(module_wq,
-					       finished_loading(mod->name));
-			if (err)
-				goto free_arch_cleanup;
-			goto again;
-		}
-		err = -EEXIST;
-		goto unlock;
-	}
-
-	/* This has to be done once we're sure module name is unique. */
 	dynamic_debug_setup(info.debug, info.num_debug);
 
-	/* Find duplicate symbols */
+	mutex_lock(&module_mutex);
+	/* Find duplicate symbols (must be called under lock). */
 	err = verify_export_symbols(mod);
 	if (err < 0)
-		goto ddebug;
+		goto ddebug_cleanup;
 
+	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info.hdr, info.sechdrs, mod);
-	list_add_rcu(&mod->list, &modules);
+
+	/* Mark state as coming so strong_try_module_get() ignores us,
+	 * but kallsyms etc. can see us. */
+	mod->state = MODULE_STATE_COMING;
+
 	mutex_unlock(&module_mutex);
 
 	/* Module is ready to execute: parsing args may do that. */
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
 			 -32768, 32767, &ddebug_dyndbg_module_param_cb);
 	if (err < 0)
-		goto unlink;
+		goto bug_cleanup;
 
 	/* Link in to syfs. */
 	err = mod_sysfs_setup(mod, &info, mod->kp, mod->num_kp);
 	if (err < 0)
-		goto unlink;
+		goto bug_cleanup;
 
 	/* Get rid of temporary copy. */
 	free_copy(&info);
@@ -3024,16 +3029,13 @@ again:
 	trace_module_load(mod);
 	return mod;
 
- unlink:
+ bug_cleanup:
+	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
-	/* Unlink carefully: kallsyms could be walking list. */
-	list_del_rcu(&mod->list);
 	module_bug_cleanup(mod);
-	wake_up_all(&module_wq);
- ddebug:
-	dynamic_debug_remove(info.debug);
- unlock:
 	mutex_unlock(&module_mutex);
+ ddebug_cleanup:
+	dynamic_debug_remove(info.debug);
 	synchronize_sched();
 	kfree(mod->args);
  free_arch_cleanup:
@@ -3042,6 +3044,12 @@ again:
 	free_modinfo(mod);
  free_unload:
 	module_unload_free(mod);
+ unlink_mod:
+	mutex_lock(&module_mutex);
+	/* Unlink carefully: kallsyms could be walking list. */
+	list_del_rcu(&mod->list);
+	wake_up_all(&module_wq);
+	mutex_unlock(&module_mutex);
  free_module:
 	module_deallocate(mod, &info);
  free_copy:
diff --git a/lib/bug.c b/lib/bug.c
index a28c141..d0cdf14 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -55,6 +55,7 @@ static inline unsigned long bug_addr(const struct bug_entry *bug)
 }
 
 #ifdef CONFIG_MODULES
+/* Updates are protected by module mutex */
 static LIST_HEAD(module_bug_list);
 
 static const struct bug_entry *module_find_bug(unsigned long bugaddr)
-- 
1.7.9.5

