Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbaKUOiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:38:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaKUOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:38:07 -0500
Date: Fri, 21 Nov 2014 15:38:11 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/3] kernel: add support for live patching
In-Reply-To: <20141120173552.GA20462@treble.redhat.com>
Message-ID: <alpine.LNX.2.00.1411211150160.27891@pobox.suse.cz>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com> <1416187764-3341-3-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411201359440.21690@pobox.suse.cz> <20141120173552.GA20462@treble.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Josh Poimboeuf wrote:

> On Thu, Nov 20, 2014 at 02:10:33PM +0100, Miroslav Benes wrote:
> > 
> > On Sun, 16 Nov 2014, Seth Jennings wrote:
> > 
> > > This commit introduces code for the live patching core.  It implements
> > > an ftrace-based mechanism and kernel interface for doing live patching
> > > of kernel and kernel module functions.
> > > 
> > > It represents the greatest common functionality set between kpatch and
> > > kgraft and can accept patches built using either method.
> > > 
> > > This first version does not implement any consistency mechanism that
> > > ensures that old and new code do not run together.  In practice, ~90% of
> > > CVEs are safe to apply in this way, since they simply add a conditional
> > > check.  However, any function change that can not execute safely with
> > > the old version of the function can _not_ be safely applied in this
> > > version.
> > > 
> > > Signed-off-by: Seth Jennings <sjenning@redhat.com>
> > 
> > Hi,
> > 
> > below is the patch which merges the internal and external data structures 
> > (so it is only one part of our original patch for version 1). Apart from 
> > that I tried to make minimal changes to the code. Only unnecessary 
> > kobjects were removed and I renamed lpc_create_* functions to lpc_init_* 
> > as it made more sense in this approach, I think.
> > 
> > I hope this clearly shows our point of view stated previously. What do 
> > you say?
> 
> Thanks for rebasing to v2 and splitting up the patches!  Personally I'm
> ok with this patch (though I do have a few comments below).

Great.

> > Next, I'll look at the three level hierarchy and sysfs directory and see 
> > if we can make it simpler yet keep its advantages.
> > 
> > Regards,
> > 
> > Miroslav Benes
> > SUSE Labs
> > 
> > -- >8 --
> > From aba839eb6b3292b193843715bfce7834969c0c17 Mon Sep 17 00:00:00 2001
> > From: Miroslav Benes <mbenes@suse.cz>
> > Date: Wed, 19 Nov 2014 16:06:35 +0100
> > Subject: [PATCH] Remove the data duplication in internal and public structures
> > 
> > The split of internal and external structures is cleaner and makes the API more
> > stable. But it makes the code more complicated. It requires more space and data
> > copying. Also the one letter difference of the names (lp_ vs. lpc_ prefix)
> > causes confusion.
> > 
> > The API is not a real issue for live patching. We take care neither of backward
> > nor forward compatibility. The dependency between a patch and kernel is even
> > more strict than by version. They have to use the same configuration and the
> > same build environment.
> > 
> > This patch merge the external and internal structures into one.  The structures
> > are initialized using ".item = value" syntax. Therefore the API is basically as
> > stable as it was before. We could later even hide it under some helper macros
> > if requested.
> > 
> > For the purpose if this patch, we used the prefix "lpc". It allows to make as
> > less changes as possible and show the real effect. If the patch is accepted, it
> > would make sense to merge it into the original patch and even use another
> > common prefix, for example the proposed "klp".
> > 
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > ---
> >  include/linux/livepatch.h |  47 +++++--
> >  kernel/livepatch/core.c   | 338 ++++++++++++----------------------------------
> >  2 files changed, 121 insertions(+), 264 deletions(-)
> > 
> > diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> > index 8b68fef..f16de32 100644
> > --- a/include/linux/livepatch.h
> > +++ b/include/linux/livepatch.h
> > @@ -21,10 +21,23 @@
> >  #define _LINUX_LIVEPATCH_H_
> >  
> >  #include <linux/module.h>
> > +#include <linux/ftrace.h>
> >  
> >  /* TODO: add kernel-doc for structures once agreed upon */
> >  
> > -struct lp_func {
> > +enum lpc_state {
> > +	LPC_DISABLED,
> > +	LPC_ENABLED
> > +};
> > +
> > +struct lpc_func {
> > +	/* internal */
> 
> Would it be a little clearer to list the external fields first?

It would. It was not possible in v1 of my patch as flexible array needs to 
be the last in struct (struct lpc_func funcs[]). Now as it is a pointer it 
makes perfect sense to have the external fields first.

> > +	struct kobject *kobj;
> > +	struct ftrace_ops fops;
> > +	enum lpc_state state;
> > +	unsigned long new_addr;
> 
> I think this internal new_addr field isn't really needed since we
> already have the external new_func field.

True.

> > +
> > +	/* external */
> >  	const char *old_name; /* function to be patched */
> >  	void *new_func; /* replacement function in patch module */
> >  	/*
> > @@ -38,7 +51,7 @@ struct lp_func {
> >  	unsigned long old_addr;
> >  };

[...]

> > -static struct lpc_func *lpc_create_func(struct kobject *root,
> > -					struct lp_func *userfunc)
> > +static int lpc_init_funcs(struct lpc_object *obj)
> >  {
> >  	struct lpc_func *func;
> >  	struct ftrace_ops *ops;
> > -	int ret;
> > -
> > -	/* alloc */
> > -	func = kzalloc(sizeof(*func), GFP_KERNEL);
> > -	if (!func)
> > -		return NULL;
> > -
> > -	/* init */
> > -	INIT_LIST_HEAD(&func->list);
> > -	func->old_name = userfunc->old_name;
> > -	func->new_addr = (unsigned long)userfunc->new_func;
> > -	func->old_addr = userfunc->old_addr;
> > -	func->state = LPC_DISABLED;
> > -	ops = &func->fops;
> > -	ops->private = func;
> > -	ops->func = lpc_ftrace_handler;
> > -	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
> 
> FTRACE_OPS_FL_DYNAMIC is probably no longer appropriate here, since I
> think both kGraft and kpatch allocate the func struct statically.

Yes, that's right. Also looking at kGraft code we have only SAVE_REGS 
there.

> However, we can't know for sure how the user allocated it, so maybe we
> need to change funcs->fops to be a pointer, and allocate it here?
> 
> That may also require embedding kobj into the func struct so that ops
> can be freed with lpc_kobj_release_func.

Hm, dynamic allocation in lpc_init_funcs and freeing in kobj release 
callback would probably be better. 

> > -
> > -	/* sysfs */
> > -	ret = kobject_init_and_add(&func->kobj, &lpc_ktype_func,
> > -				   root, func->old_name);
> > -	if (ret) {
> > -		kfree(func);
> > -		return NULL;
> > -	}
> > -
> > -	return func;
> > -}
> > -
> > -static int lpc_create_funcs(struct lpc_object *obj,
> > -			    struct lp_func *userfuncs)
> > -{
> > -	struct lp_func *userfunc;
> > -	struct lpc_func *func;
> >  
> > -	if (!userfuncs)
> > -		return -EINVAL;
> > -
> > -	for (userfunc = userfuncs; userfunc->old_name; userfunc++) {
> > -		func = lpc_create_func(&obj->kobj, userfunc);
> > -		if (!func)
> > +	for (func = obj->funcs; func->old_name; func++) {
> > +		func->new_addr = (unsigned long)func->new_func;
> > +		func->state = LPC_DISABLED;
> > +		ops = &func->fops;
> > +		ops->private = func;
> > +		ops->func = lpc_ftrace_handler;
> > +		ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
> > +
> > +		/* sysfs */
> > +		func->kobj = kobject_create_and_add(func->old_name, obj->kobj);
> > +		if (!func->kobj)
> >  			goto free;
> > -		list_add(&func->list, &obj->funcs);
> >  	}
> > +
> >  	return 0;
> >  free:
> > -	lpc_free_funcs(obj);
> > +	lpc_free_funcs_limited(obj, func);
> >  	return -ENOMEM;
> >  }
> >  
> > -static struct lpc_object *lpc_create_object(struct kobject *root,
> > -					    struct lp_object *userobj)
> > +static int lpc_init_objects(struct lpc_patch *patch)
> >  {
> >  	struct lpc_object *obj;
> >  	int ret;
> >  
> > -	/* alloc */
> > -	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
> > -	if (!obj)
> > -		return NULL;
> > +	for (obj = patch->objs; obj->name; obj++) {
> > +		/* obj->mod set by lpc_object_module_get() */
> > +		obj->state = LPC_DISABLED;
> >  
> > -	/* init */
> > -	INIT_LIST_HEAD(&obj->list);
> > -	obj->name = userobj->name;
> > -	obj->relocs = userobj->relocs;
> > -	obj->state = LPC_DISABLED;
> > -	/* obj->mod set by lpc_object_module_get() */
> > -	INIT_LIST_HEAD(&obj->funcs);
> > -
> > -	/* sysfs */
> > -	ret = kobject_init_and_add(&obj->kobj, &lpc_ktype_object,
> > -				   root, obj->name);
> > -	if (ret) {
> > -		kfree(obj);
> > -		return NULL;
> > -	}
> > -
> > -	/* create functions */
> > -	ret = lpc_create_funcs(obj, userobj->funcs);
> > -	if (ret) {
> > -		kobject_put(&obj->kobj);
> > -		return NULL;
> > -	}
> > -
> > -	return obj;
> > -}
> > -
> > -static int lpc_create_objects(struct lpc_patch *patch,
> > -			      struct lp_object *userobjs)
> > -{
> > -	struct lp_object *userobj;
> > -	struct lpc_object *obj;
> > -
> > -	if (!userobjs)
> > -		return -EINVAL;
> > +		/* sysfs */
> > +		obj->kobj = kobject_create_and_add(obj->name, &patch->kobj);
> > +		if (!obj->kobj)
> > +			goto free;
> >  
> > -	for (userobj = userobjs; userobj->name; userobj++) {
> > -		obj = lpc_create_object(&patch->kobj, userobj);
> > -		if (!obj)
> > +		/* init functions */
> > +		ret = lpc_init_funcs(obj);
> > +		if (ret) {
> > +			kobject_put(obj->kobj);
> >  			goto free;
> > -		list_add(&obj->list, &patch->objs);
> > +		}
> >  	}
> > +
> >  	return 0;
> >  free:
> > -	lpc_free_objects(patch);
> > +	lpc_free_objects_limited(patch, obj);
> >  	return -ENOMEM;
> >  }
> >  
> > -static int lpc_create_patch(struct lp_patch *userpatch)
> > +static int lpc_init_patch(struct lpc_patch *patch)
> >  {
> > -	struct lpc_patch *patch;
> >  	int ret;
> >  
> > -	/* alloc */
> > -	patch = kzalloc(sizeof(*patch), GFP_KERNEL);
> > -	if (!patch)
> > -		return -ENOMEM;
> > +	mutex_lock(&lpc_mutex);
> >  
> >  	/* init */
> > -	INIT_LIST_HEAD(&patch->list);
> > -	patch->userpatch = userpatch;
> > -	patch->mod = userpatch->mod;
> >  	patch->state = LPC_DISABLED;
> 
> Would be nice if we could detect a double call to lpc_register() and
> return -EINVAL if the patch is already enabled (but I'm not sure how to
> do that with this data layout).  Probably not a big deal.

If I understand you correctly we could return -EINVAL in 
lpc_register_patch if the patch is already enabled. If it is disabled a 
double call of register could be detected only with addition of some flag 
to lpc_patch struct. I don't know if it is worth it.

> > -	INIT_LIST_HEAD(&patch->objs);
> >  
> >  	/* sysfs */
> >  	ret = kobject_init_and_add(&patch->kobj, &lpc_ktype_patch,
> >  				   lpc_root_kobj, patch->mod->name);
> > -	if (ret) {
> > -		kfree(patch);
> > +	if (ret)
> >  		return ret;
> > -	}
> >  
> >  	/* create objects */
> > -	ret = lpc_create_objects(patch, userpatch->objs);
> > +	ret = lpc_init_objects(patch);
> >  	if (ret) {
> >  		kobject_put(&patch->kobj);
> >  		return ret;
> >  	}
> >  
> >  	/* add to global list of patches */
> > -	mutex_lock(&lpc_mutex);
> >  	list_add(&patch->list, &lpc_patches);
> > +
> >  	mutex_unlock(&lpc_mutex);
> >  
> >  	return 0;
> > @@ -902,7 +740,7 @@ static int lpc_create_patch(struct lp_patch *userpatch)
> >   ***********************************/
> >  
> >  /**
> > - * lp_register_patch() - registers a patch
> > + * lpc_register_patch() - registers a patch
> >   * @userpatch:	Patch to be registered
> >   *
> >   * Allocates the data structure associated with the patch and
> 
> s/Allocates/Initializes/

Yes.

> 
> > @@ -910,11 +748,11 @@ static int lpc_create_patch(struct lp_patch *userpatch)
> >   *
> >   * Return: 0 on success, otherwise error
> >   */
> > -int lp_register_patch(struct lp_patch *userpatch)
> > +int lpc_register_patch(struct lpc_patch *userpatch)
> 
> We can probably s/userpatch/patch/g .

Definitely better.

> >  {
> >  	int ret;
> >  
> > -	if (!userpatch || !userpatch->mod || !userpatch->objs)
> > +	if (!userpatch || !userpatch->mod)
> 
> Why?

Oh, this is a remnant of some intermediate state where objs in lpc_patch 
was declared as a flexible array (struct lpc_object objs[]). In that case 
the check was redundant. In the end I changed it back to a pointer and 
forgot to fix that. So thanks. It means that similar check for 
obj->funcs should be returned to lpc_init_funcs or somewhere. Sorry for 
that.

Thank you
Mira

> >  		return -EINVAL;
> >  
> >  	/*
> > @@ -927,43 +765,37 @@ int lp_register_patch(struct lp_patch *userpatch)
> >  	if (!try_module_get(userpatch->mod))
> >  		return -ENODEV;
> >  
> > -	ret = lpc_create_patch(userpatch);
> > +	ret = lpc_init_patch(userpatch);
> >  	if (ret)
> >  		module_put(userpatch->mod);
> >  
> >  	return ret;
> >  }
> > -EXPORT_SYMBOL_GPL(lp_register_patch);
> > +EXPORT_SYMBOL_GPL(lpc_register_patch);
> >  
> >  /**
> > - * lp_unregister_patch() - unregisters a patch
> > + * lpc_unregister_patch() - unregisters a patch
> >   * @userpatch:	Disabled patch to be unregistered
> >   *
> >   * Frees the data structures and removes the sysfs interface.
> >   *
> >   * Return: 0 on success, otherwise error
> >   */
> > -int lp_unregister_patch(struct lp_patch *userpatch)
> > +int lpc_unregister_patch(struct lpc_patch *userpatch)
> >  {
> > -	struct lpc_patch *patch;
> >  	int ret = 0;
> >  
> >  	mutex_lock(&lpc_mutex);
> > -	patch = lpc_find_patch(userpatch);
> > -	if (!patch) {
> > -		ret = -ENODEV;
> > -		goto out;
> > -	}
> > -	if (patch->state == LPC_ENABLED) {
> > +	if (userpatch->state == LPC_ENABLED) {
> >  		ret = -EINVAL;
> >  		goto out;
> >  	}
> > -	lpc_free_patch(patch);
> > +	lpc_free_patch(userpatch);
> >  out:
> >  	mutex_unlock(&lpc_mutex);
> >  	return ret;
> >  }
> > -EXPORT_SYMBOL_GPL(lp_unregister_patch);
> > +EXPORT_SYMBOL_GPL(lpc_unregister_patch);
> >  
> >  /************************************
> >   * entry/exit
> > -- 
> > 2.1.2
> > 
> 
> -- 
> Josh
> 

--
Miroslav Benes
SUSE Labs
