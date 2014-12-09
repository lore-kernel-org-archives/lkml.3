Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaLISGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:06:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaLISGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:06:04 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 3/6] livepatch v5: find and verify the old address in klp_*_init()
Date: Tue,  9 Dec 2014 19:05:04 +0100
Message-Id: <1418148307-21434-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patched address is found and checked when the patch is enabled.
If there is a failure the patch must be reverted. It might happen,
for example, when there are duplicated symbols or when the patch
and the kernel are incompatible.

It would be better to detect these problems earlier when the structures
are initialized. It will also help to avoid the costly symbol lookup
when the patch is disabled and enabled again.

This patch does the necessary changes. It adds some complexity
to module_coming() and module_going() functions but I think that
the design is cleaner. For example, it removes the strange situation
when klp_find_verify_func_addr() sets func->old_addr but it complains
when even a valid value has already been set before.

Note that I plan to remove the duplicate code by introducing
__klp_init_func().

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/livepatch/core.c | 44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 034f79a926af..54bb39d3abb5 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -179,7 +179,8 @@ static int klp_verify_vmlinux_symbol(const char *name, unsigned long addr)
 	return -EINVAL;
 }
 
-static int klp_find_verify_func_addr(struct klp_func *func, const char *objname)
+static int klp_find_verify_func_addr(struct klp_object *obj,
+				     struct klp_func *func)
 {
 	int ret;
 
@@ -188,17 +189,18 @@ static int klp_find_verify_func_addr(struct klp_func *func, const char *objname)
 	func->old_addr = 0;
 #endif
 
-	if (func->old_addr && objname) {
-		pr_err("old address specified for module symbol\n");
-		return -EINVAL;
-	}
-
-	if (func->old_addr)
+	/*
+	 * If the old address is predefined, it might be used to check
+	 * the consistency between the patch and the patched kernel.
+	 * This does not work for kernel modules where the address
+	 * always must be detected.
+	 */
+	if (!func->old_addr || klp_is_module(obj))
+		ret = klp_find_object_symbol(obj->name, func->old_name,
+					     &func->old_addr);
+	else
 		ret = klp_verify_vmlinux_symbol(func->old_name,
 						func->old_addr);
-	else
-		ret = klp_find_object_symbol(objname, func->old_name,
-					     &func->old_addr);
 
 	return ret;
 }
@@ -348,9 +350,6 @@ static int klp_disable_object(struct klp_object *obj)
 		ret = klp_disable_func(func);
 		if (ret)
 			return ret;
-
-		if (klp_is_module(obj))
-			func->old_addr = 0;
 	}
 
 	obj->state = KLP_DISABLED;
@@ -370,10 +369,6 @@ static int klp_enable_object(struct klp_object *obj)
 		return -EINVAL;
 
 	for (func = obj->funcs; func->old_name; func++) {
-		ret = klp_find_verify_func_addr(func, obj->name);
-		if (ret)
-			goto unregister;
-
 		ret = klp_enable_func(func);
 		if (ret)
 			goto unregister;
@@ -512,6 +507,7 @@ EXPORT_SYMBOL_GPL(klp_enable_patch);
 static void klp_module_notify_coming(struct module *pmod,
 				     struct klp_object *obj)
 {
+	struct klp_func *func;
 	struct module *mod = obj->mod;
 	int ret;
 
@@ -524,6 +520,12 @@ static void klp_module_notify_coming(struct module *pmod,
 			goto err;
 	}
 
+	for (func = obj->funcs; func->old_name; func++) {
+		ret = klp_find_verify_func_addr(obj, func);
+		if (ret)
+			goto err;
+	}
+
 	ret = klp_enable_object(obj);
 	if (!ret)
 		return;
@@ -536,6 +538,7 @@ err:
 static void klp_module_notify_going(struct module *pmod,
 				    struct klp_object *obj)
 {
+	struct klp_func *func;
 	struct module *mod = obj->mod;
 	int ret;
 
@@ -547,6 +550,9 @@ static void klp_module_notify_going(struct module *pmod,
 		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
 			pmod->name, mod->name, ret);
 
+	for (func = obj->funcs; func->old_name; func++)
+		func->old_addr = 0;
+
 	obj->mod = NULL;
 }
 
@@ -719,6 +725,10 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 
 	func->state = KLP_DISABLED;
 
+	ret = klp_find_verify_func_addr(obj, func);
+	if (ret)
+		return ret;
+
 	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
 	if (!ops)
 		ret = -ENOMEM;
-- 
1.8.5.2

