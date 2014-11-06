Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaKFQ6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:58:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbaKFQ6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:58:03 -0500
Date: Thu, 6 Nov 2014 10:57:48 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel: add support for live patching
Message-ID: <20141106165748.GB14689@cerebellum.variantweb.net>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <545B98E6.2070009@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B98E6.2070009@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:51:02PM +0100, Jiri Slaby wrote:
> On 11/06/2014, 03:39 PM, Seth Jennings wrote:
> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.
> 
> Hi,
> 
> nice! So we have something to start with. Brilliant!
> 
> I have some comments below now. Yet, it obviously needs deeper review
> which will take more time.
> 
> > --- /dev/null
> > +++ b/include/linux/livepatch.h
> > @@ -0,0 +1,45 @@
> > +#ifndef _LIVEPATCH_H_
> > +#define _LIVEPATCH_H_
> 
> This should follow the linux kernel naming: LINUX_LIVEPATCH_H

Didn't realize that was the convention.  Just to be sure, you meant
_LINUX_LIVEPATCH_H right (with the leading underscore)?

> 
> 
> > +#include <linux/module.h>
> > +
> > +struct lp_func {
> 
> I am not much happy with "lp" which effectively means parallel printer
> support. What about lip?

Not sure how much clearer lip is.  It isn't for me :-/  I'm not opposed
to changing it.  I was just trying to keep the name short since it is
used many times.  Reducing the prefix from something like "livepatch_"
to "lp_" seemed to be the shortest and most straightforward way.

> 
> > +	const char *old_name; /* function to be patched */
> > +	void *new_func; /* replacement function in patch module */
> > +	/*
> > +	 * The old_addr field is optional and can be used to resolve
> > +	 * duplicate symbol names in the vmlinux object.  If this
> > +	 * information is not present, the symbol is located by name
> > +	 * with kallsyms. If the name is not unique and old_addr is
> > +	 * not provided, the patch application fails as there is no
> > +	 * way to resolve the ambiguity.
> > +	 */
> > +	unsigned long old_addr;
> > +};
> >
> > +struct lp_dynrela {
> > +	unsigned long dest;
> > +	unsigned long src;
> > +	unsigned long type;
> > +	const char *name;
> > +	int addend;
> > +	int external;
> > +};
> > +
> > +struct lp_object {
> > +	const char *name; /* "vmlinux" or module name */
> > +	struct lp_func *funcs;
> > +	struct lp_dynrela *dynrelas;
> > +};
> > +
> > +struct lp_patch {
> > +	struct module *mod; /* module containing the patch */
> > +	struct lp_object *objs;
> > +};
> 
> Please document all the structures and all its members. And use
> kernel-doc format for that. (You can take an inspiration in kgraft.)

Sure.

> 
> > +int lp_register_patch(struct lp_patch *);
> > +int lp_unregister_patch(struct lp_patch *);
> > +int lp_enable_patch(struct lp_patch *);
> > +int lp_disable_patch(struct lp_patch *);
> > +
> > +#endif /* _LIVEPATCH_H_ */
> 
> ...
> 
> > --- /dev/null
> > +++ b/kernel/livepatch/Makefile
> > @@ -0,0 +1,3 @@
> > +obj-$(CONFIG_LIVE_PATCHING) += livepatch.o
> > +
> > +livepatch-objs := core.o
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > new file mode 100644
> > index 0000000..b32dbb5
> > --- /dev/null
> > +++ b/kernel/livepatch/core.c
> > @@ -0,0 +1,1020 @@
> 
> ...
> 
> > +/*************************************
> > + * Core structures
> > + ************************************/
> > +
> > +/*
> > + * lp_ structs vs lpc_ structs
> > + *
> > + * For each element (patch, object, func) in the live-patching code,
> > + * there are two types with two different prefixes: lp_ and lpc_.
> > + *
> > + * Structures used by the live-patch modules to register with this core module
> > + * are prefixed with lp_ (live patching).  These structures are part of the
> > + * registration API and are defined in livepatch.h.  The structures used
> > + * internally by this core module are prefixed with lpc_ (live patching core).
> > + */
> 
> I am not sure if the separation and the allocations/kobj handling are
> worth it. It makes the code really less understandable. Can we have just
> struct lip_function (don't unnecessarily abbreviate), lip_objectfile
> (object is too generic, like Java object) and lip_patch containing all
> the needed information? It would clean up the code a lot. (Yes, we would
> have profited from c++ here.)

I looked at doing this and this is actually what we did in kpatch.  We
made one structure that had "private" members that the user wasn't
suppose to access that were only used in the core.  This was messy
though.  Every time you wanted to add a "private" field to the struct so
the core could do something new, you were changing the API to the patch
modules as well.  While copying the data into an internal structure does
add code and opportunity for errors, that functionality is localized
into functions that are specifically tasked with taking care of that.
So the risk is minimized and we gain flexibility within the core and
more self-documenting API structures.

> 
> > +static DEFINE_SEMAPHORE(lpc_mutex);
> 
> Ugh, those are deprecated. Use mutex. (Or am I missing the need of
> recursive locking?)

Sure.

> 
> > +static LIST_HEAD(lpc_patches);
> > +
> > +enum lpc_state {
> > +	DISABLED,
> > +	ENABLED
> 
> These are too generic names. This is prone to conflicts in the tree.

Add LPC_ prefix good enough?

> 
> > +};
> > +
> > +struct lpc_func {
> > +	struct list_head list;
> > +	struct kobject kobj;
> > +	struct ftrace_ops fops;
> > +	enum lpc_state state;
> > +
> > +	const char *old_name;
> 
> So you do lpc_func->old_name = lp_func->old_name.
> 
> Why? Duplication is always bad and introduces errors. The same for the
> other members here and there. Well, lip_function would solve that.

See earlier comment.

> 
> > +	unsigned long new_addr;
> > +	unsigned long old_addr;
> > +};
> > +
> > +struct lpc_object {
> > +	struct list_head list;
> > +	struct kobject kobj;
> > +	struct module *mod; /* module associated with object */
> > +	enum lpc_state state;
> > +
> > +	const char *name;
> > +	struct list_head funcs;
> > +	struct lp_dynrela *dynrelas;
> > +};
> > +
> > +struct lpc_patch {
> > +	struct list_head list;
> > +	struct kobject kobj;
> > +	struct lp_patch *userpatch; /* for correlation during unregister */
> > +	enum lpc_state state;
> > +
> > +	struct module *mod;
> > +	struct list_head objs;
> > +};
> > +
> > +/*******************************************
> > + * Helpers
> > + *******************************************/
> > +
> > +/* sets obj->mod if object is not vmlinux and module was found */
> > +static bool is_object_loaded(struct lpc_object *obj)
> 
> Always prefix function names. We try to avoid kallsyms duplicates ;).

Sure.

> 
> > +{
> > +	struct module *mod;
> > +
> > +	if (!strcmp(obj->name, "vmlinux"))
> > +		return 1;
> > +
> > +	mutex_lock(&module_mutex);
> > +	mod = find_module(obj->name);
> > +	mutex_unlock(&module_mutex);
> > +	obj->mod = mod;
> 
> This is racy. Mod can be already gone now, right?.

Yes, we should take a ref on the module before releasing the
module_mutex.

> 
> > +
> > +	return !!mod;
> > +}
> > +
> > +/************************************
> > + * kallsyms
> > + ***********************************/
> > +
> > +struct lpc_find_arg {
> > +	const char *objname;
> > +	const char *name;
> > +	unsigned long addr;
> > +	/*
> > +	 * If count == 0, the symbol was not found. If count == 1, a unique
> > +	 * match was found and addr is set.  If count > 1, there is
> > +	 * unresolvable ambiguity among "count" number of symbols with the same
> > +	 * name in the same object.
> > +	 */
> > +	unsigned long count;
> > +};
> 
> ...
> 
> > +static int lpc_find_symbol(const char *objname, const char *name,
> > +			   unsigned long *addr)
> 
> The first two params can be const, right?

Not following.  The first two params _are_ const.  If you are saying they
should be... I agree! :)

> 
> > +{
> > +	struct lpc_find_arg args = {
> > +		.objname = objname,
> > +		.name = name,
> > +		.addr = 0,
> > +		.count = 0
> > +	};
> > +
> > +	if (objname && !strcmp(objname, "vmlinux"))
> > +		args.objname = NULL;
> > +
> > +	kallsyms_on_each_symbol(lpc_find_callback, &args);
> > +
> > +	if (args.count == 0)
> > +		pr_err("symbol '%s' not found in symbol table\n", name);
> > +	else if (args.count > 1)
> > +		pr_err("unresolvable ambiguity (%lu matches) on symbol '%s' in object '%s'\n",
> > +		       args.count, name, objname);
> > +	else {
> > +		*addr = args.addr;
> > +		return 0;
> > +	}
> > +
> > +	*addr = 0;
> > +	return -EINVAL;
> > +}
> 
> ...
> 
> > +/****************************************
> > + * dynamic relocations (load-time linker)
> > + ****************************************/
> 
> I am skipping this now (see Jiri's e-mail).
> 
> > +/***********************************
> > + * ftrace registration
> > + **********************************/
> > +
> > +static void lpc_ftrace_handler(unsigned long ip, unsigned long parent_ip,
> > +			       struct ftrace_ops *ops, struct pt_regs *regs)
> > +{
> > +	struct lpc_func *func = ops->private;
> > +
> > +	regs->ip = func->new_addr;
> > +}
> > +
> > +static int lpc_enable_func(struct lpc_func *func)
> > +{
> > +	int ret;
> > +
> > +	BUG_ON(!func->old_addr);
> > +	BUG_ON(func->state != DISABLED);
> 
> No BUGs please, just return appropriately. Possibly with WARN_ON.

Sure.

> 
> > +	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 0, 0);
> > +	if (ret) {
> > +		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		return ret;
> > +	}
> > +	ret = register_ftrace_function(&func->fops);
> > +	if (ret) {
> > +		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
> > +	} else
> > +		func->state = ENABLED;
> > +
> > +	return ret;
> > +}
> > +
> > +static int lpc_unregister_func(struct lpc_func *func)
> > +{
> > +	int ret;
> > +
> > +	BUG_ON(func->state != ENABLED);
> 
> Detto.

Ok.

> 
> > +	if (!func->old_addr)
> > +		/* parent object is not loaded */
> > +		return 0;
> > +	ret = unregister_ftrace_function(&func->fops);
> > +	if (ret) {
> > +		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
> > +		       func->old_name, ret);
> > +		return ret;
> > +	}
> > +	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
> > +	if (ret)
> > +		pr_warn("function unregister succeeded but failed to clear the filter\n");
> > +	func->state = DISABLED;
> > +
> > +	return 0;
> > +}
> 
> > +/******************************
> > + * enable/disable
> > + ******************************/
> 
> ...
> 
> > +/* must be called with lpc_mutex held */
> > +static int lpc_enable_patch(struct lpc_patch *patch)
> 
> The question I want to raise here is whether we need two-state
> registration: register+enable. We don't in kGraft. Why do you?

We actually don't in kpatch either and this was a late change for this
patchset.  The thinking was that, while the patch modules would normally
call lpc_register_patch() and lpc_enable_patch() in the same way all the
time, breaking them up created more symmetric code and gives more flexibility
to the API.

Josh might like to elaborate here.

> 
> > +{
> > +	struct lpc_object *obj;
> > +	int ret;
> > +
> > +	BUG_ON(patch->state != DISABLED);
> 
> No bugs...

Ok.

> 
> > +
> > +	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
> > +	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
> > +
> > +	pr_notice("enabling patch '%s'\n", patch->mod->name);
> > +
> > +	list_for_each_entry(obj, &patch->objs, list) {
> > +		if (!is_object_loaded(obj))
> > +			continue;
> > +		ret = lpc_enable_object(patch->mod, obj);
> > +		if (ret)
> > +			goto unregister;
> > +	}
> > +	patch->state = ENABLED;
> > +	return 0;
> > +
> > +unregister:
> > +	WARN_ON(lpc_disable_patch(patch));
> > +	return ret;
> > +}
> > +
> > +int lp_enable_patch(struct lp_patch *userpatch)
> > +{
> > +	struct lpc_patch *patch;
> > +	int ret;
> > +
> > +	down(&lpc_mutex);
> > +	patch = lpc_find_patch(userpatch);
> > +	if (!patch) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +	ret = lpc_enable_patch(patch);
> > +out:
> > +	up(&lpc_mutex);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(lp_enable_patch);
> 
> ...
> 
> > +/************************************
> > + * register/unregister
> > + ***********************************/
> > +
> > +int lp_register_patch(struct lp_patch *userpatch)
> 
> This and other guys forming the interface should be documented.

Yes.

Thanks,
Seth

> 
> > +{
> > +	int ret;
> > +
> > +	if (!userpatch || !userpatch->mod || !userpatch->objs)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * A reference is taken on the patch module to prevent it from being
> > +	 * unloaded.  Right now, we don't allow patch modules to unload since
> > +	 * there is currently no method to determine if a thread is still
> > +	 * running in the patched code contained in the patch module once
> > +	 * the ftrace registration is successful.
> > +	 */
> > +	if (!try_module_get(userpatch->mod))
> > +		return -ENODEV;
> > +
> > +	down(&lpc_mutex);
> > +	ret = lpc_create_patch(userpatch);
> > +	up(&lpc_mutex);
> > +	if (ret)
> > +		module_put(userpatch->mod);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(lp_register_patch);
> 
> ...
> 
> 
> Thanks for the work!
> 
> -- 
> js
> suse labs
