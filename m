Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3AKDzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 22:55:51 -0500
Received: from ozlabs.org ([203.10.76.45]:32928 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3AKDzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 22:55:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Tim Abbott" <tabbott@ksplice.com>
Subject: Re: [PATCH] module, fix percpu reserved memory exhaustion
In-Reply-To: <1357785669-31848-1-git-send-email-prarit@redhat.com>
References: <1357785669-31848-1-git-send-email-prarit@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 11 Jan 2013 14:18:14 +1030
Message-ID: <87d2xc1itd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava <prarit@redhat.com> writes:
> [   15.478160] kvm: Could not allocate 304 bytes percpu data
> [   15.478174] PERCPU: allocation failed, size=304 align=32, alloc
> from reserved chunk failed
...
> What is happening is systemd is loading an instance of the kvm module for
> each cpu found (see commit e9bda3b).  When the module load occurs the kernel
> currently allocates the modules percpu data area prior to checking to see
> if the module is already loaded or is in the process of being loaded.  If
> the module is already loaded, or finishes load, the module loading code
> releases the current instance's module's percpu data.

Wow, what a cool bug!  Classic unforseen side-effect.

I'd prefer not to do relocations with the module_lock held: it can be
relatively slow.  Yet we can't do relocations before the per-cpu
allocation, obviously.  Did you do boot timings before and after?

An alternative would be to put the module into the list even earlier
(say, just after layout_and_allocate) so we could block on concurrent
loads at that point.  But then we have to make sure noone looks in the
module too early before it's completely set up, and that's complicated
and error-prone too.  A separate list is kind of icky.

We currently have PERCPU_MODULE_RESERVE set at 8k: in my 32-bit
allmodconfig build, there are only three modules with per-cpu data,
totalling 328 bytes.  So it's not reasonable to increase that number to
paper over this.

This is what a new boot state looks like (pains not to break ksplice).
It's two patches, but I'll just post them back to back:

module: add new state MODULE_STATE_UNFORMED.

You should never look at such a module, so it's excised from all paths
which traverse the modules list.

We add the state at the end, to avoid gratuitous ABI break (ksplice).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/module.h b/include/linux/module.h
index 7760c6d..4432373 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -199,11 +199,11 @@ struct module_use {
 	struct module *source, *target;
 };
 
-enum module_state
-{
-	MODULE_STATE_LIVE,
-	MODULE_STATE_COMING,
-	MODULE_STATE_GOING,
+enum module_state {
+	MODULE_STATE_LIVE,	/* Normal state. */
+	MODULE_STATE_COMING,	/* Full formed, running module_init. */
+	MODULE_STATE_GOING,	/* Going away. */
+	MODULE_STATE_UNFORMED,	/* Still setting it up. */
 };
 
 /**
diff --git a/kernel/module.c b/kernel/module.c
index 41bc118..c3a2ee8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -188,6 +188,7 @@ struct load_info {
    ongoing or failed initialization etc. */
 static inline int strong_try_module_get(struct module *mod)
 {
+	BUG_ON(mod && mod->state == MODULE_STATE_UNFORMED);
 	if (mod && mod->state == MODULE_STATE_COMING)
 		return -EBUSY;
 	if (try_module_get(mod))
@@ -343,6 +344,9 @@ bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 #endif
 		};
 
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
+
 		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
 			return true;
 	}
@@ -450,16 +454,24 @@ const struct kernel_symbol *find_symbol(const char *name,
 EXPORT_SYMBOL_GPL(find_symbol);
 
 /* Search for module by name: must hold module_mutex. */
-struct module *find_module(const char *name)
+static struct module *find_module_all(const char *name,
+				      bool even_unformed)
 {
 	struct module *mod;
 
 	list_for_each_entry(mod, &modules, list) {
+		if (!even_unformed && mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (strcmp(mod->name, name) == 0)
 			return mod;
 	}
 	return NULL;
 }
+
+struct module *find_module(const char *name)
+{
+	return find_module_all(name, false);
+}
 EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
@@ -525,6 +537,8 @@ bool is_module_percpu_address(unsigned long addr)
 	preempt_disable();
 
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (!mod->percpu_size)
 			continue;
 		for_each_possible_cpu(cpu) {
@@ -1048,6 +1062,8 @@ static ssize_t show_initstate(struct module_attribute *mattr,
 	case MODULE_STATE_GOING:
 		state = "going";
 		break;
+	default:
+		BUG();
 	}
 	return sprintf(buffer, "%s\n", state);
 }
@@ -1786,6 +1802,8 @@ void set_all_modules_text_rw(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
 						mod->module_core + mod->core_text_size,
@@ -1807,6 +1825,8 @@ void set_all_modules_text_ro(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
 						mod->module_core + mod->core_text_size,
@@ -2998,7 +3018,8 @@ static bool finished_loading(const char *name)
 
 	mutex_lock(&module_mutex);
 	mod = find_module(name);
-	ret = !mod || mod->state != MODULE_STATE_COMING;
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3361,6 +3382,8 @@ const char *module_address_lookup(unsigned long addr,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
 			if (modname)
@@ -3384,6 +3407,8 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
 			const char *sym;
@@ -3408,6 +3433,8 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
 			const char *sym;
@@ -3435,6 +3462,8 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
 			*type = mod->symtab[symnum].st_info;
@@ -3477,9 +3506,12 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 			ret = mod_find_symname(mod, colon+1);
 		*colon = ':';
 	} else {
-		list_for_each_entry_rcu(mod, &modules, list)
+		list_for_each_entry_rcu(mod, &modules, list) {
+			if (mod->state == MODULE_STATE_UNFORMED)
+				continue;
 			if ((ret = mod_find_symname(mod, name)) != 0)
 				break;
+		}
 	}
 	preempt_enable();
 	return ret;
@@ -3494,6 +3526,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	int ret;
 
 	list_for_each_entry(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		for (i = 0; i < mod->num_symtab; i++) {
 			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
 				 mod, mod->symtab[i].st_value);
@@ -3509,6 +3543,7 @@ static char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
 
+	BUG_ON(mod->state == MODULE_STATE_UNFORMED);
 	if (mod->taints ||
 	    mod->state == MODULE_STATE_GOING ||
 	    mod->state == MODULE_STATE_COMING) {
@@ -3550,6 +3585,10 @@ static int m_show(struct seq_file *m, void *p)
 	struct module *mod = list_entry(p, struct module, list);
 	char buf[8];
 
+	/* We always ignore unformed modules. */
+	if (mod->state == MODULE_STATE_UNFORMED)
+		return 0;
+
 	seq_printf(m, "%s %u",
 		   mod->name, mod->init_size + mod->core_size);
 	print_unload_info(m, mod);
@@ -3610,6 +3649,8 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (mod->num_exentries == 0)
 			continue;
 
@@ -3658,10 +3699,13 @@ struct module *__module_address(unsigned long addr)
 	if (addr < module_addr_min || addr > module_addr_max)
 		return NULL;
 
-	list_for_each_entry_rcu(mod, &modules, list)
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (within_module_core(addr, mod)
 		    || within_module_init(addr, mod))
 			return mod;
+	}
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__module_address);
@@ -3714,8 +3758,11 @@ void print_modules(void)
 	printk(KERN_DEFAULT "Modules linked in:");
 	/* Most callers should already have preempt disabled, but make sure */
 	preempt_disable();
-	list_for_each_entry_rcu(mod, &modules, list)
+	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		printk(" %s%s", mod->name, module_flags(mod, buf));
+	}
 	preempt_enable();
 	if (last_unloaded_module[0])
 		printk(" [last unloaded: %s]", last_unloaded_module);

module: put modules in list much earlier.

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

diff --git a/kernel/module.c b/kernel/module.c
index c3a2ee8..ec535aa 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3017,7 +3017,7 @@ static bool finished_loading(const char *name)
 	bool ret;
 
 	mutex_lock(&module_mutex);
-	mod = find_module(name);
+	mod = find_module_all(name, true);
 	ret = !mod || mod->state == MODULE_STATE_LIVE
 		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
@@ -3141,6 +3141,32 @@ static int load_module(struct load_info *info, const char __user *uargs,
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
 #ifdef CONFIG_MODULE_SIG
 	mod->sig_ok = info->sig_ok;
 	if (!mod->sig_ok)
@@ -3150,7 +3176,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	/* Now module is in final location, initialize linked lists, etc. */
 	err = module_unload_init(mod);
 	if (err)
-		goto free_module;
+		goto unlink_mod;
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
@@ -3185,54 +3211,33 @@ static int load_module(struct load_info *info, const char __user *uargs,
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
 	dynamic_debug_setup(info->debug, info->num_debug);
 
-	/* Find duplicate symbols */
+	mutex_lock(&module_mutex);
+	/* Find duplicate symbols (must be called under lock). */
 	err = verify_export_symbols(mod);
 	if (err < 0)
-		goto ddebug;
+		goto ddebug_cleanup;
 
+	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
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
 	err = mod_sysfs_setup(mod, info, mod->kp, mod->num_kp);
 	if (err < 0)
-		goto unlink;
+		goto bug_cleanup;
 
 	/* Get rid of temporary copy. */
 	free_copy(info);
@@ -3242,16 +3247,13 @@ again:
 
 	return do_init_module(mod);
 
- unlink:
+ bug_cleanup:
+	/* module_bug_cleanup needs module_mutex protection */
 	mutex_lock(&module_mutex);
-	/* Unlink carefully: kallsyms could be walking list. */
-	list_del_rcu(&mod->list);
 	module_bug_cleanup(mod);
-	wake_up_all(&module_wq);
- ddebug:
-	dynamic_debug_remove(info->debug);
- unlock:
 	mutex_unlock(&module_mutex);
+ ddebug_cleanup:
+	dynamic_debug_remove(info->debug);
 	synchronize_sched();
 	kfree(mod->args);
  free_arch_cleanup:
@@ -3260,6 +3262,12 @@ again:
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
 	module_deallocate(mod, info);
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
