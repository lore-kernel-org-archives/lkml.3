Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3BEWNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:13:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab3BEWNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:13:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 87/93] module: add new state MODULE_STATE_UNFORMED.
Date: Tue,  5 Feb 2013 20:07:16 -0200
Message-Id: <1360102042-10732-88-git-send-email-herton.krzesinski@canonical.com>
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

commit 0d21b0e3477395e7ff2acc269f15df6e6a8d356d upstream.

You should never look at such a module, so it's excised from all paths
which traverse the modules list.

We add the state at the end, to avoid gratuitous ABI break (ksplice).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/module.h      |   10 ++++----
 kernel/debug/kdb/kdb_main.c |    2 ++
 kernel/module.c             |   57 +++++++++++++++++++++++++++++++++++++++----
 3 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index fbcafe2..16100ba 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -196,11 +196,11 @@ struct module_use {
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
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 1f91413..8f71ca3 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1982,6 +1982,8 @@ static int kdb_lsmod(int argc, const char **argv)
 
 	kdb_printf("Module                  Size  modstruct     Used by\n");
 	list_for_each_entry(mod, kdb_modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 
 		kdb_printf("%-20s%8u  0x%p ", mod->name,
 			   mod->core_size, (void *)mod);
diff --git a/kernel/module.c b/kernel/module.c
index 8dd60f4..a2bc837 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -145,6 +145,7 @@ struct load_info {
    ongoing or failed initialization etc. */
 static inline int strong_try_module_get(struct module *mod)
 {
+	BUG_ON(mod && mod->state == MODULE_STATE_UNFORMED);
 	if (mod && mod->state == MODULE_STATE_COMING)
 		return -EBUSY;
 	if (try_module_get(mod))
@@ -300,6 +301,9 @@ bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 #endif
 		};
 
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
+
 		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
 			return true;
 	}
@@ -410,16 +414,24 @@ const struct kernel_symbol *find_symbol(const char *name,
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
@@ -485,6 +497,8 @@ bool is_module_percpu_address(unsigned long addr)
 	preempt_disable();
 
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (!mod->percpu_size)
 			continue;
 		for_each_possible_cpu(cpu) {
@@ -1008,6 +1022,8 @@ static ssize_t show_initstate(struct module_attribute *mattr,
 	case MODULE_STATE_GOING:
 		state = "going";
 		break;
+	default:
+		BUG();
 	}
 	return sprintf(buffer, "%s\n", state);
 }
@@ -1746,6 +1762,8 @@ void set_all_modules_text_rw(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
 						mod->module_core + mod->core_text_size,
@@ -1767,6 +1785,8 @@ void set_all_modules_text_ro(void)
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if ((mod->module_core) && (mod->core_text_size)) {
 			set_page_attributes(mod->module_core,
 						mod->module_core + mod->core_text_size,
@@ -2878,7 +2898,8 @@ static bool finished_loading(const char *name)
 
 	mutex_lock(&module_mutex);
 	mod = find_module(name);
-	ret = !mod || mod->state != MODULE_STATE_COMING;
+	ret = !mod || mod->state == MODULE_STATE_LIVE
+		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
 
 	return ret;
@@ -3197,6 +3218,8 @@ const char *module_address_lookup(unsigned long addr,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
 			if (modname)
@@ -3220,6 +3243,8 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
 			const char *sym;
@@ -3244,6 +3269,8 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (within_module_init(addr, mod) ||
 		    within_module_core(addr, mod)) {
 			const char *sym;
@@ -3271,6 +3298,8 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
 			*type = mod->symtab[symnum].st_info;
@@ -3313,9 +3342,12 @@ unsigned long module_kallsyms_lookup_name(const char *name)
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
@@ -3330,6 +3362,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	int ret;
 
 	list_for_each_entry(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		for (i = 0; i < mod->num_symtab; i++) {
 			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
 				 mod, mod->symtab[i].st_value);
@@ -3345,6 +3379,7 @@ static char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
 
+	BUG_ON(mod->state == MODULE_STATE_UNFORMED);
 	if (mod->taints ||
 	    mod->state == MODULE_STATE_GOING ||
 	    mod->state == MODULE_STATE_COMING) {
@@ -3386,6 +3421,10 @@ static int m_show(struct seq_file *m, void *p)
 	struct module *mod = list_entry(p, struct module, list);
 	char buf[8];
 
+	/* We always ignore unformed modules. */
+	if (mod->state == MODULE_STATE_UNFORMED)
+		return 0;
+
 	seq_printf(m, "%s %u",
 		   mod->name, mod->init_size + mod->core_size);
 	print_unload_info(m, mod);
@@ -3446,6 +3485,8 @@ const struct exception_table_entry *search_module_extables(unsigned long addr)
 
 	preempt_disable();
 	list_for_each_entry_rcu(mod, &modules, list) {
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
 		if (mod->num_exentries == 0)
 			continue;
 
@@ -3494,10 +3535,13 @@ struct module *__module_address(unsigned long addr)
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
@@ -3550,8 +3594,11 @@ void print_modules(void)
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
-- 
1.7.9.5

