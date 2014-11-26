Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaKZNhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:37:55 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56908 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaKZNhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:37:50 -0500
Message-ID: <5475D7A7.4070109@suse.cz>
Date: Wed, 26 Nov 2014 14:37:43 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/3] kernel: add support for live patching
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <1416935709-404-3-git-send-email-sjenning@redhat.com>
In-Reply-To: <1416935709-404-3-git-send-email-sjenning@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it is improving a lot over the time. I have still few comments below.

On 11/25/2014, 06:15 PM, Seth Jennings wrote:
> --- /dev/null
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -0,0 +1,40 @@
...
> +#ifndef _ASM_X86_LIVEPATCH_H
> +#define _ASM_X86_LIVEPATCH_H
> +
> +#include <linux/module.h>
> +
> +#ifdef CONFIG_LIVE_PATCHING
> +#ifndef CC_USING_FENTRY
> +#error Your compiler must support -mfentry for live patching to work
> +#endif
> +extern int klp_write_module_reloc(struct module *mod, unsigned long type,
> +				  unsigned long loc, unsigned long value);
> +
> +#else
> +static inline int klp_write_module_reloc(struct module *mod, unsigned long type,
> +					 unsigned long loc, unsigned long value)
> +{
> +	return -ENOSYS;
> +}
> +#endif
> +
> +#endif /* _ASM_X86_LIVEPATCH_H */
...
> --- /dev/null
> +++ b/arch/x86/kernel/livepatch.c
> @@ -0,0 +1,74 @@
...
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <asm/cacheflush.h>
> +#include <asm/page_types.h>

It would make sense to include asm/livepatch.h here. Whenever somebody
changes the prototype of the function or adds a new functionality, it
would force them to write them right.

> +int klp_write_module_reloc(struct module *mod, unsigned long type,
> +			   unsigned long loc, unsigned long value)
> +{
> +	int ret, readonly, numpages, size = 4;
> +	unsigned long val;
> +	unsigned long core = (unsigned long)mod->module_core;
> +	unsigned long core_ro_size = mod->core_ro_size;
> +	unsigned long core_size = mod->core_size;
> +
> +	switch (type) {
> +	case R_X86_64_NONE:
> +		return 0;
> +	case R_X86_64_64:
> +		val = value;
> +		size = 8;
> +		break;
> +	case R_X86_64_32:
> +		val = (u32)value;
> +		break;
> +	case R_X86_64_32S:
> +		val = (s32)value;
> +		break;
> +	case R_X86_64_PC32:
> +		val = (u32)(value - loc);
> +		break;
> +	default:
> +		/* unsupported relocation type */
> +		return -EINVAL;
> +	}
> +
> +	if (loc >= core && loc < core + core_ro_size)
> +		readonly = 1;
> +	else if (loc >= core + core_ro_size && loc < core + core_size)
> +		readonly = 0;
> +	else
> +		/* loc not in expected range */
> +		return -EINVAL;
> +
> +	numpages = ((loc & PAGE_MASK) == ((loc + size) & PAGE_MASK)) ? 1 : 2;

This deserves a comment or better assignment. Maybe something like:
numpages = DIV_ROUND_UP((loc & ~PAGE_MASK) + size, PAGE_SIZE);

> +	if (readonly)
> +		set_memory_rw(loc & PAGE_MASK, numpages);
> +
> +	ret = probe_kernel_write((void *)loc, &val, size);
> +
> +	if (readonly)
> +		set_memory_ro(loc & PAGE_MASK, numpages);
> +
> +	return ret;
> +}
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> new file mode 100644
> index 0000000..4e01b59
> --- /dev/null
> +++ b/include/linux/livepatch.h
> @@ -0,0 +1,121 @@
...
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

Missing colons there and below too 8-).

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

Why do you limit documentation only to "API" members? People reading and
working on the code want to know something about the rest too.

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
...
> --- /dev/null
> +++ b/kernel/livepatch/core.c
> @@ -0,0 +1,807 @@
...
> +static void klp_module_notify_coming(struct module *pmod,
> +				     struct klp_object *obj)
> +{
> +	struct module *mod = obj->mod;
...
> +	obj->mod = mod;

No :).

> +	ret = klp_enable_object(pmod, obj);
> +	if (ret)
> +		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
> +			pmod->name, mod->name, ret);
> +}
...
> +static void klp_kobj_release_patch(struct kobject *kobj)
> +{
> +	struct klp_patch *patch;
> +
> +	patch = container_of(kobj, struct klp_patch, kobj);
> +	if (!list_empty(&patch->list))
> +		list_del(&patch->list);

This is broken.

First, the mutex protecting klp_patches is not held on all paths.

Second, ->release is not necessarily called in-line. I mean, whenever
kobject_put returns, this does not mean, the patch will be removed from
the list. Even if it was the last put. This will have unexpected impact
on the assumptions I and others might have about klp_patches. E.g. all
references of objects and funcs in the patch might be gone at any time I
crawl through the list before this ->release is called.

> +}
> +
> +static struct kobj_type klp_ktype_patch = {
> +	.release = klp_kobj_release_patch,
> +	.sysfs_ops = &kobj_sysfs_ops,
> +	.default_attrs = klp_patch_attrs
> +};
...
> +static void klp_free_patch(struct klp_patch *patch)
> +{
> +	klp_free_objects_limited(patch, NULL);
> +	kobject_put(&patch->kobj);

This one is called with klp_mutex. Do not assume ->release will be
called in-line. It will and it will not. You have to call this outside
the lock, given you need the lock in ->release.

> +}
> +
> +static int klp_init_funcs(struct klp_object *obj)
> +{
> +	struct klp_func *func;
> +	struct ftrace_ops *ops;
> +	int ret;
> +
> +	if (!obj->funcs)
> +		return -EINVAL;
> +
> +	for (func = obj->funcs; func->old_name; func++) {
> +		func->state = KLP_DISABLED;
> +
> +		ops = kzalloc(sizeof(*ops), GFP_KERNEL);
> +		if (!ops) {
> +			ret = -ENOMEM;
> +			goto free;
> +		}
> +		ops->private = func;
> +		ops->func = klp_ftrace_handler;
> +		ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;

Maybe I missed some discussion. So why cannot func->ops be static?

> +		/* sysfs */
> +		ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
> +					   obj->kobj, func->old_name);
> +		if (ret) {
> +			kfree(ops);
> +			goto free;
> +		}
> +
> +		func->fops = ops;
> +	}
> +
> +	return 0;
> +free:
> +	klp_free_funcs_limited(obj, func);
> +	return ret;
> +}
> +
> +static int klp_init_objects(struct klp_patch *patch)
> +{
> +	struct klp_object *obj;
> +	int ret;
> +
> +	if (!patch->objs)
> +		return -EINVAL;

This was already checked in klp_register_patch. Do you anticipate more
paths than that to come here?

> +
> +	for (obj = patch->objs; obj->funcs; obj++) {
> +		/* obj->mod set by klp_object_module_get() */

I don't see it anywhere.

> +		obj->state = KLP_DISABLED;
> +
> +		/* sysfs */
> +		obj->kobj = kobject_create_and_add(obj->name, &patch->kobj);
> +		if (!obj->kobj)
> +			goto free;
> +
> +		/* init functions */
> +		ret = klp_init_funcs(obj);
> +		if (ret) {
> +			kobject_put(obj->kobj);
> +			goto free;
> +		}
> +	}
> +
> +	return 0;
> +free:
> +	klp_free_objects_limited(patch, obj);
> +	return -ENOMEM;

klp_init_funcs does not always return ENOMEM. The error should be
propagated for easier debugging.

> +}
> +
> +static int klp_init_patch(struct klp_patch *patch)
> +{
> +	int ret;
> +
> +	if (!patch)
> +		return -EINVAL;

Detto as above.


> +	/* init */
> +	patch->state = KLP_DISABLED;
> +
> +	/* sysfs */
> +	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
> +				   klp_root_kobj, patch->mod->name);
> +	if (ret)
> +		return ret;
> +
> +	ret = klp_init_objects(patch);
> +	if (ret) {
> +		kobject_put(&patch->kobj);

Hmm, but who initializes patch->list for klp_ktype_patch->release()?

> +		return ret;
> +	}
> +
> +	/* add to global list of patches */

All three comments here are useless as they point out obvious. Drop
them. And similar ones from the routines above.

> +	mutex_lock(&klp_mutex);
> +	list_add(&patch->list, &klp_patches);
> +	mutex_unlock(&klp_mutex);
> +
> +	return 0;
> +}
...
> +/**
> + * klp_unregister_patch() - unregisters a patch
> + * @patch:	Disabled patch to be unregistered
> + *
> + * Frees the data structures and removes the sysfs interface.
> + *
> + * Return: 0 on success, otherwise error
> + */
> +int klp_unregister_patch(struct klp_patch *patch)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&klp_mutex);
> +	if (patch->state == KLP_ENABLED) {
> +		ret = -EINVAL;

Wouldn't be EBUSY more appropriate?

> +		goto out;
> +	}
> +	klp_free_patch(patch);
> +out:
> +	mutex_unlock(&klp_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(klp_unregister_patch);
> +
> +static int klp_init(void)
> +{
> +	int ret;
> +
> +	ret = register_module_notifier(&klp_module_nb);
> +	if (ret)
> +		return ret;
> +
> +	klp_root_kobj = kobject_create_and_add("livepatch", kernel_kobj);
> +	if (!klp_root_kobj) {
> +		ret = -ENOMEM;
> +		goto unregister;
> +	}
> +
> +	return 0;
> +unregister:
> +	unregister_module_notifier(&klp_module_nb);
> +	return ret;

If this really fails, any KLP API function above will crash. We need to
set some flag here and test it above.

> +}
> +
> +module_init(klp_init);
> 

thanks,
-- 
js
suse labs
