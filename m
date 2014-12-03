Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaLCKAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:00:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaLCKAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:00:08 -0500
Date: Wed, 3 Dec 2014 11:00:20 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/3] kernel: add support for live patching
In-Reply-To: <1416935709-404-3-git-send-email-sjenning@redhat.com>
Message-ID: <alpine.LNX.2.00.1412031052480.16122@pobox.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <1416935709-404-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tue, 25 Nov 2014, Seth Jennings wrote:

> This commit introduces code for the live patching core.  It implements
> an ftrace-based mechanism and kernel interface for doing live patching
> of kernel and kernel module functions.
> 
> It represents the greatest common functionality set between kpatch and
> kgraft and can accept patches built using either method.
> 
> This first version does not implement any consistency mechanism that
> ensures that old and new code do not run together.  In practice, ~90% of
> CVEs are safe to apply in this way, since they simply add a conditional
> check.  However, any function change that can not execute safely with
> the old version of the function can _not_ be safely applied in this
> version.
> 
> Signed-off-by: Seth Jennings <sjenning@redhat.com>
> ---

[...]

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> new file mode 100644
> index 0000000..4e01b59
> --- /dev/null
> +++ b/include/linux/livepatch.h
> @@ -0,0 +1,121 @@
> +/*
> + * livepatch.h - Kernel Live Patching Core
> + *
> + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _LINUX_LIVEPATCH_H_
> +#define _LINUX_LIVEPATCH_H_
> +
> +#include <linux/module.h>
> +#include <linux/ftrace.h>
> +
> +#if IS_ENABLED(CONFIG_LIVE_PATCHING)
> +
> +#include <asm/livepatch.h>
> +
> +enum klp_state {
> +	KLP_DISABLED,
> +	KLP_ENABLED
> +};
> +
> +/**
> + * struct klp_func - function structure for live patching
> + * @old_name:	name of the function to be patched
> + * @new_func:	pointer to the patched function code
> + * @old_addr:	a hint conveying at what address the old function
> + *		can be found (optional, vmlinux patches only)
> + */
> +struct klp_func {
> +	/* external */
> +	const char *old_name;
> +	void *new_func;
> +	/*
> +	 * The old_addr field is optional and can be used to resolve
> +	 * duplicate symbol names in the vmlinux object.  If this
> +	 * information is not present, the symbol is located by name
> +	 * with kallsyms. If the name is not unique and old_addr is
> +	 * not provided, the patch application fails as there is no
> +	 * way to resolve the ambiguity.
> +	 */
> +	unsigned long old_addr;
> +
> +	/* internal */
> +	struct kobject kobj;
> +	struct ftrace_ops *fops;
> +	enum klp_state state;
> +};
> +
> +/**
> + * struct klp_reloc - relocation structure for live patching
> + * @dest	address where the relocation will be written
> + * @src		address of the referenced symbol (optional,
> + *		vmlinux	patches only)
> + * @type	ELF relocation type
> + * @name	name of the referenced symbol (for lookup/verification)
> + * @addend	offset from the referenced symbol
> + * @external	symbol is either exported or within the	live patch module itself
> + */
> +struct klp_reloc {
> +	unsigned long dest;
> +	unsigned long src;
> +	unsigned long type;
> +	const char *name;
> +	int addend;
> +	int external;
> +};
> +
> +/* struct klp_object - kernel object structure for live patching
> + * @name	module name (or NULL for vmlinux)
> + * @relocs	relocation entries to be applied at load time
> + * @funcs	function entries for functions to be patched in the object
> + */
> +struct klp_object {
> +	/* external */
> +	const char *name;
> +	struct klp_reloc *relocs;
> +	struct klp_func *funcs;
> +
> +	/* internal */
> +	struct kobject *kobj;
> +	struct module *mod;
> +	enum klp_state state;
> +};
> +
> +/**
> + * struct klp_patch - patch structure for live patching
> + * @mod		reference to the live patch module
> + * @objs	object entries for kernel objects to be patched
> + */
> +struct klp_patch {
> +	/* external */
> +	struct module *mod;
> +	struct klp_object *objs;
> +
> +	/* internal */
> +	struct list_head list;
> +	struct kobject kobj;
> +	enum klp_state state;
> +};

as I had promised before I did some work on func-object-patch hierarchy 
trying to remove the object level. The result is not nice though. 
Three levels have some advantages. We don't need to solve ambiguity of 
function names in sysfs (to some extent), patching of coming and going 
modules is nice this way and relocations are bound to modules, i.e. 
objects, too. So I would leave object level there in the end :)

But I'd like to propose this patch. It makes the klp_init_* functions 
cleaner in my opinion...

Mira

-- >8 --
>From 0e925c303acf8b596ba8941417e1c3991cdb0adc Mon Sep 17 00:00:00 2001
From: Miroslav Benes <mbenes@suse.cz>
Date: Tue, 2 Dec 2014 14:34:21 +0100
Subject: [PATCH] Restructure of klp_init_* functions

Structure of klp_init_{patch|objects|funcs} functions could be a bit hard to
read. We can move the loops in klp_init_objects and klp_init_funcs one level up
to klp_init_patch and klp_init_objects respectively. Thus klp_init_objects
become klp_init_object and similarly klp_init_funcs is klp_init_func now.

This change also makes it symmetric with the naming scheme used for
klp_{enable|disable}_* functions.

Signed-off-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/livepatch/core.c | 88 +++++++++++++++++++++----------------------------
 1 file changed, 37 insertions(+), 51 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 8e2e8cd..4ffc281 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -627,103 +627,89 @@ static void klp_free_patch(struct klp_patch *patch)
 	kobject_put(&patch->kobj);
 }
 
-static int klp_init_funcs(struct klp_object *obj)
+static int klp_init_func(struct klp_func *func, struct klp_object *obj)
 {
-	struct klp_func *func;
 	struct ftrace_ops *ops;
 	int ret;
 
-	if (!obj->funcs)
-		return -EINVAL;
-
-	for (func = obj->funcs; func->old_name; func++) {
-		func->state = KLP_DISABLED;
+	func->state = KLP_DISABLED;
 
-		ops = kzalloc(sizeof(*ops), GFP_KERNEL);
-		if (!ops) {
-			ret = -ENOMEM;
-			goto free;
-		}
-		ops->private = func;
-		ops->func = klp_ftrace_handler;
-		ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
+	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
+	if (!ops)
+		return -ENOMEM;
 
-		/* sysfs */
-		ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
-					   obj->kobj, func->old_name);
-		if (ret) {
-			kfree(ops);
-			goto free;
-		}
+	ops->private = func;
+	ops->func = klp_ftrace_handler;
+	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
+	func->fops = ops;
 
-		func->fops = ops;
+	ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
+				  obj->kobj, func->old_name);
+	if (ret) {
+		kfree(func->fops);
+		return ret;
 	}
 
 	return 0;
-free:
-	klp_free_funcs_limited(obj, func);
-	return ret;
 }
 
-static int klp_init_objects(struct klp_patch *patch)
+static int klp_init_object(struct klp_object *obj, struct klp_patch *patch)
 {
-	struct klp_object *obj;
+	struct klp_func *func;
 	int ret;
 
-	if (!patch->objs)
+	if (!obj->funcs)
 		return -EINVAL;
 
-	for (obj = patch->objs; obj->funcs; obj++) {
-		/* obj->mod set by klp_object_module_get() */
-		obj->state = KLP_DISABLED;
+	/* obj->mod set by klp_object_module_get() */
+	obj->state = KLP_DISABLED;
 
-		/* sysfs */
-		obj->kobj = kobject_create_and_add(obj->name, &patch->kobj);
-		if (!obj->kobj)
-			goto free;
+	obj->kobj = kobject_create_and_add(obj->name, &patch->kobj);
+	if (!obj->kobj)
+		return -ENOMEM;
 
-		/* init functions */
-		ret = klp_init_funcs(obj);
-		if (ret) {
-			kobject_put(obj->kobj);
+	for (func = obj->funcs; func->old_name; func++) {
+		ret = klp_init_func(func, obj);
+		if (ret)
 			goto free;
-		}
 	}
 
 	return 0;
 free:
-	klp_free_objects_limited(patch, obj);
-	return -ENOMEM;
+	klp_free_funcs_limited(obj, func);
+	return ret;
 }
 
 static int klp_init_patch(struct klp_patch *patch)
 {
+	struct klp_object *obj;
 	int ret;
 
-	if (!patch)
+	if (!patch || !patch->objs)
 		return -EINVAL;
 
-	/* init */
 	patch->state = KLP_DISABLED;
 
-	/* sysfs */
 	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
 				   klp_root_kobj, patch->mod->name);
 	if (ret)
 		return ret;
 
-	ret = klp_init_objects(patch);
-	if (ret) {
-		kobject_put(&patch->kobj);
-		return ret;
+	for (obj = patch->objs; obj->funcs; obj++) {
+		ret = klp_init_object(obj, patch);
+		if (ret)
+			goto free;
 	}
 
-	/* add to global list of patches */
 	mutex_lock(&klp_mutex);
 	list_add(&patch->list, &klp_patches);
 	mutex_unlock(&klp_mutex);
 
 	return 0;
+free:
+	klp_free_objects_limited(patch, obj);
+	kobject_put(&patch->kobj);
+	return ret;
 }
 
 /**
-- 
2.1.2
