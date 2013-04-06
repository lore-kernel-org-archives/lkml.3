Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422860Ab3DFNB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:01:26 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:52557 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422799Ab3DFNBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:01:25 -0400
From: Sebastian Wankerl <sisewank@cip.cs.fau.de>
To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Cc: Philip Kranz <philip.kranz@googlemail.com>,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>
Subject: [PATCH] Make information about modules available to kgdb.
Date: Sat,  6 Apr 2013 15:00:55 +0200
Message-Id: <1365253255-14154-1-git-send-email-sisewank@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Kranz <philip.kranz@googlemail.com>

To be able to properly debug kernel modules kgbd needs to know all SHF_ALLOC
sections of the module. This patch add an array of those sections to struct
module. One cannot use sysfs since it does not contain all sections needed.

Signed-off-by: Philip Kranz <philip.kranz@googlemail.com>
Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de>

---
 include/linux/module.h |    5 +++++
 kernel/module.c        |   42 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 46f1ea0..0209f02 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -375,6 +375,11 @@ struct module
 	ctor_fn_t *ctors;
 	unsigned int num_ctors;
 #endif
+
+#ifdef CONFIG_KGDB
+	unsigned int num_alloc_sections;
+	unsigned long *alloc_sections;
+#endif
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
diff --git a/kernel/module.c b/kernel/module.c
index 3c2c72d..a959b2f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -103,9 +103,10 @@
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
-#ifdef CONFIG_KGDB_KDB
-struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
-#endif /* CONFIG_KGDB_KDB */
+#ifdef CONFIG_KGDB
+/* k(g)db needs the list of modules */
+struct list_head *kdb_modules = &modules;
+#endif /* CONFIG_KGDB */
 
 #ifdef CONFIG_MODULE_SIG
 #ifdef CONFIG_MODULE_SIG_FORCE
@@ -1868,6 +1869,10 @@ static void free_module(struct module *mod)
 	mutex_unlock(&module_mutex);
 	mod_sysfs_teardown(mod);
 
+#ifdef CONFIG_KGDB
+	kfree(mod->alloc_sections);
+#endif
+
 	/* Remove dynamic debug info */
 	ddebug_remove_module(mod->name);
 
@@ -3206,6 +3211,33 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_KGDB
+static void save_alloc_sections(struct module *mod, struct load_info *info)
+{
+	int i, j;
+
+	mod->num_alloc_sections = 0;
+
+	for (i = 0; i < info->hdr->e_shnum; i++)
+		if (info->sechdrs[i].sh_flags & SHF_ALLOC)
+			mod->num_alloc_sections++;
+
+	mod->alloc_sections =
+		kzalloc(sizeof(unsigned long) * mod->num_alloc_sections,
+			GFP_KERNEL);
+	if (mod->alloc_sections == NULL)
+		return;
+
+	j = 0;
+	for (i = 0; i < info->hdr->e_shnum; i++) {
+		if (info->sechdrs[i].sh_flags & SHF_ALLOC) {
+			mod->alloc_sections[j] = info->sechdrs[i].sh_addr;
+			j++;
+		}
+	}
+}
+#endif
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static int load_module(struct load_info *info, const char __user *uargs,
@@ -3301,6 +3333,10 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err < 0)
 		goto bug_cleanup;
 
+#ifdef CONFIG_KGDB
+	save_alloc_sections(mod, info);
+#endif
+
 	/* Get rid of temporary copy. */
 	free_copy(info);
 
-- 
1.7.10.4

