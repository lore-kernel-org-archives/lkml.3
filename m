Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3FOBNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:13:14 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:57766 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3FOBNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:13:13 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mathias Krause <minipli@googlemail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] module: don't modify argument of module_kallsyms_lookup_name()
Date: Sat, 15 Jun 2013 03:12:58 +0200
Message-Id: <1371258778-12655-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass a pointer to a const string in the form "module:symbol"
module_kallsyms_lookup_name() will try to split the string at the colon,
i.e., will try to modify r/o data. That will, in fact, fail on a kernel
with enabled CONFIG_DEBUG_RODATA.

Avoid modifying the passed string in module_kallsyms_lookup_name(),
modify find_module_all() instead to pass it the module name length.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
v2:
- don't use kstrdup(), pass the string length to find_module_all() as
  suggested by Rusty

 kernel/module.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index cab4bce..bf3b846 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -455,7 +455,7 @@ const struct kernel_symbol *find_symbol(const char *name,
 EXPORT_SYMBOL_GPL(find_symbol);
 
 /* Search for module by name: must hold module_mutex. */
-static struct module *find_module_all(const char *name,
+static struct module *find_module_all(const char *name, size_t len,
 				      bool even_unformed)
 {
 	struct module *mod;
@@ -463,7 +463,7 @@ static struct module *find_module_all(const char *name,
 	list_for_each_entry(mod, &modules, list) {
 		if (!even_unformed && mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (strcmp(mod->name, name) == 0)
+		if (strlen(mod->name) == len && !memcmp(mod->name, name, len))
 			return mod;
 	}
 	return NULL;
@@ -471,7 +471,7 @@ static struct module *find_module_all(const char *name,
 
 struct module *find_module(const char *name)
 {
-	return find_module_all(name, false);
+	return find_module_all(name, strlen(name), false);
 }
 EXPORT_SYMBOL_GPL(find_module);
 
@@ -3014,7 +3014,7 @@ static bool finished_loading(const char *name)
 	bool ret;
 
 	mutex_lock(&module_mutex);
-	mod = find_module_all(name, true);
+	mod = find_module_all(name, strlen(name), true);
 	ret = !mod || mod->state == MODULE_STATE_LIVE
 		|| mod->state == MODULE_STATE_GOING;
 	mutex_unlock(&module_mutex);
@@ -3152,7 +3152,8 @@ static int add_unformed_module(struct module *mod)
 
 again:
 	mutex_lock(&module_mutex);
-	if ((old = find_module_all(mod->name, true)) != NULL) {
+	old = find_module_all(mod->name, strlen(mod->name), true);
+	if (old != NULL) {
 		if (old->state == MODULE_STATE_COMING
 		    || old->state == MODULE_STATE_UNFORMED) {
 			/* Wait in case it fails to load. */
@@ -3563,10 +3564,8 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	/* Don't lock: we're in enough trouble already. */
 	preempt_disable();
 	if ((colon = strchr(name, ':')) != NULL) {
-		*colon = '\0';
-		if ((mod = find_module(name)) != NULL)
+		if ((mod = find_module_all(name, colon - name, false)) != NULL)
 			ret = mod_find_symname(mod, colon+1);
-		*colon = ':';
 	} else {
 		list_for_each_entry_rcu(mod, &modules, list) {
 			if (mod->state == MODULE_STATE_UNFORMED)
-- 
1.7.10.4

