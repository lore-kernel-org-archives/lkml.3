Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaLISGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:06:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaLISGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:06:00 -0500
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
Subject: [PATCH 2/6] livepatch v5: do not quietly ignore wrong usage
Date: Tue,  9 Dec 2014 19:05:03 +0100
Message-Id: <1418148307-21434-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suggested to add more checks between v4 and v5 of this patchset. Some
of them were lazy. They allowed to call the function even when there
was nothing to do. Mirek persuaded me that it was bad design because
it would hide some potential problems. We fixed this for klp_object_enable()
but not for the other lazy checks.

This patch removes the other lazy checks. Also it makes sure that
the functions are called only when allowed.

Note that the check in klp_disable_object() must be an error. It is called
when the patch is enabled. We could not disable it without the valid address.

Note that it adds some more nested checks but I plan to clean this later by
introducing __klp_init_object(). It will help to remove the duplicated
code from module_coming().

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/livepatch/core.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index b848069e44cc..034f79a926af 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -231,12 +231,11 @@ static int klp_write_object_relocations(struct module *pmod,
 	int ret;
 	struct klp_reloc *reloc;
 
-	if (!klp_is_object_loaded(obj))
-		return 0;
+	if (WARN_ON(!klp_is_object_loaded(obj)))
+		return -EINVAL;
 
-	/* be happy when there is nothing to do */
-	if (!obj->relocs)
-		return 0;
+	if (WARN_ON(!obj->relocs))
+		return -EINVAL;
 
 	for (reloc = obj->relocs; reloc->name; reloc++) {
 		if (!klp_is_module(obj)) {
@@ -315,9 +314,8 @@ static int klp_disable_func(struct klp_func *func)
 	if (WARN_ON(func->state != KLP_ENABLED))
 		return -EINVAL;
 
-	if (!func->old_addr)
-		/* parent object is not loaded */
-		return 0;
+	if (WARN_ON(!func->old_addr))
+		return -EINVAL;
 
 	ret = unregister_ftrace_function(func->fops);
 	if (ret) {
@@ -520,9 +518,11 @@ static void klp_module_notify_coming(struct module *pmod,
 	pr_notice("applying patch '%s' to loading module '%s'\n",
 		  pmod->name, mod->name);
 
-	ret = klp_write_object_relocations(pmod, obj);
-	if (ret)
-		goto err;
+	if (obj->relocs) {
+		ret = klp_write_object_relocations(pmod, obj);
+		if (ret)
+			goto err;
+	}
 
 	ret = klp_enable_object(obj);
 	if (!ret)
@@ -751,9 +751,11 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 
 	klp_find_object_module(obj);
 
-	ret = klp_write_object_relocations(patch->mod, obj);
-	if (ret)
-		return ret;
+	if (obj->relocs && klp_is_object_loaded(obj)) {
+		ret = klp_write_object_relocations(patch->mod, obj);
+		if (ret)
+			return ret;
+	}
 
 	name = klp_is_module(obj) ? obj->name : "vmlinux";
 	obj->kobj = kobject_create_and_add(name, &patch->kobj);
-- 
1.8.5.2

