Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaGVM2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:28:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626AbaGVM2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:28:49 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/2] module: add within_module() function
Date: Tue, 22 Jul 2014 14:28:09 +0200
Message-Id: <1406032090-16151-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1406032090-16151-1-git-send-email-pmladek@suse.cz>
References: <1406032090-16151-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is just a small optimization that allows to replace few
occurrences of within_module_init() || within_module_core()
with a single call.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 include/linux/module.h |  5 +++++
 kernel/module.c        | 12 ++++--------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index f520a767c86c..61d8fb2d0873 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -408,6 +408,11 @@ static inline int within_module_init(unsigned long addr, const struct module *mo
 	       addr < (unsigned long)mod->module_init + mod->init_size;
 }
 
+static inline int within_module(unsigned long addr, const struct module *mod)
+{
+	return within_module_init(addr, mod) || within_module_core(addr, mod);
+}
+
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name);
 
diff --git a/kernel/module.c b/kernel/module.c
index ae79ce615cb9..be0e479ccb5c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3444,8 +3444,7 @@ const char *module_address_lookup(unsigned long addr,
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			if (modname)
 				*modname = mod->name;
 			ret = get_ksymbol(mod, addr, size, offset);
@@ -3469,8 +3468,7 @@ int lookup_module_symbol_name(unsigned long addr, char *symname)
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, NULL, NULL);
@@ -3495,8 +3493,7 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size,
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_init(addr, mod) ||
-		    within_module_core(addr, mod)) {
+		if (within_module(addr, mod)) {
 			const char *sym;
 
 			sym = get_ksymbol(mod, addr, size, offset);
@@ -3760,8 +3757,7 @@ struct module *__module_address(unsigned long addr)
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		if (within_module_core(addr, mod)
-		    || within_module_init(addr, mod))
+		if (within_module(addr, mod))
 			return mod;
 	}
 	return NULL;
-- 
1.8.4

