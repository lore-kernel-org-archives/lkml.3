Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaK1RHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:07:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaK1RHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:07:44 -0500
Date: Fri, 28 Nov 2014 18:07:37 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Petr Mladek <pmladek@suse.cz>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/3] kernel: add support for live patching
Message-ID: <20141128170735.GD32376@dhcp128.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
 <1416935709-404-3-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416935709-404-3-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-25 11:15:08, Seth Jennings wrote:
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

It is nicely improving. I have few more comments.

[...]

> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
> new file mode 100644
> index 0000000..38fa496
> --- /dev/null
> +++ b/arch/x86/include/asm/livepatch.h
> @@ -0,0 +1,40 @@
> +/*
> + * livepatch.h - x86-specific Kernel Live Patching Core
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

I would avoid the #else part. IMHO, it is better to report such
problems at compile time. The alternative could be added later
if anyone really wants to use it outside LivePatch and do
some minimal build without this feature.

> +
> +#endif /* _ASM_X86_LIVEPATCH_H */

[...]

> --- /dev/null
> +++ b/arch/x86/kernel/livepatch.c
> @@ -0,0 +1,74 @@
> +/*
> + * livepatch.c - x86-specific Kernel Live Patching Core
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
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <asm/cacheflush.h>
> +#include <asm/page_types.h>
> +

Please, add some comments that would explain the purpose
of the function and parameters.

> +int klp_write_module_reloc(struct module *mod, unsigned long type,
> +			   unsigned long loc, unsigned long value)
> +{
> +	int ret, readonly, numpages, size = 4;

I would use bool for "readonly" and change the code to use "true" and "false".

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

Small optimization would be:

	if (loc < core || loc >= core + core_size)
		/* loc does not point to any symbol inside the module */
		return -EINVAL;

	if (loc < core + core_ro_size)
		readonly = 1;
	else
		readonly = 0;

> +	numpages = ((loc & PAGE_MASK) == ((loc + size) & PAGE_MASK)) ? 1 : 2;
> +
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

[...]

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

The names are a bit confusing. It makes the feeling that we copy some
data from "src" to "dest". I wonder if we could get some more
descriptive names from the reloc function.

I would use the same naming scheme that is used by
arch_kexec_apply_relocations_add() and apply_relocate_add()
and also by the new klp_write_module_reloc()
I mean:

  dest -> loc
  src -> val

> +	unsigned long type;
> +	const char *name;
> +	int addend;

After all, I would keep the "addend". It sounds strange but it seems to
be the name used by other similar functions as well. See also
include/uapi/linux/elf.h

> +	int external;
> +};
> +
> +/* struct klp_object - kernel object structure for live patching

/**

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
> +
> +extern int klp_register_patch(struct klp_patch *);
> +extern int klp_unregister_patch(struct klp_patch *);
> +extern int klp_enable_patch(struct klp_patch *);
> +extern int klp_disable_patch(struct klp_patch *);
> +
> +#endif /* CONFIG_LIVE_PATCHING */
> +
> +#endif /* _LINUX_LIVEPATCH_H_ */

[...]

> --- /dev/null
> +++ b/kernel/livepatch/core.c
> @@ -0,0 +1,807 @@
> +/*
> + * core.c - Kernel Live Patching Core
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
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/ftrace.h>
> +#include <linux/list.h>
> +#include <linux/kallsyms.h>
> +#include <linux/livepatch.h>
> +
> +/*
> + * The klp_mutex protects the klp_patches list and state transitions of any
> + * structure reachable from the patches list.  References to any structure must
> + * be obtained under mutex protection.
> + */
> +
> +static DEFINE_MUTEX(klp_mutex);
> +static LIST_HEAD(klp_patches);
> +
> +static struct kobject *klp_root_kobj;
> +
> +/* sets obj->mod if object is not vmlinux and module is found */
> +static bool klp_find_object_module(struct klp_object *obj)
> +{
> +	if (!obj->name)
> +		return 1;
> +
> +	mutex_lock(&module_mutex);
> +	/*
> +	 * We don't need to take a reference on the module here because we have
> +	 * the klp_mutex, which is also taken by the module notifier.  This
> +	 * prevents any module from unloading until we release the klp_mutex.
> +	 */
> +	obj->mod = find_module(obj->name);
> +	mutex_unlock(&module_mutex);
> +
> +	return !!obj->mod;

I know that this is effective to return boolean here because
it handles also patch against the kernel core (vmlinux). But
the logic looks tricky. I would prefer a cleaner design and
use this function only to set obj->mod.

I wanted to see how it would look like, so I will send a patch for
this in a separate mail.


> +}

[...]

> +static int klp_write_object_relocations(struct module *pmod,
> +					struct klp_object *obj)
> +{
> +	int ret;
> +	struct klp_reloc *reloc;

We should add some consistency checks here. I will send
a patch for this as well.

> +	for (reloc = obj->relocs; reloc->name; reloc++) {

This might deserve a comment. Something like:

		/*
		 * Only symbols from modules need to be relocated.
		 * The symbols from the core kernel binary (vmlinux) are
		 * only used to check consistency between the patch and
		 * the patched kernel.
		 */
> +		if (!obj->name) {
> +			ret = klp_verify_vmlinux_symbol(reloc->name,
> +							reloc->src);
> +			if (ret)
> +				return ret;
> +		} else {
> +			/* module, reloc->src needs to be discovered */
> +			if (reloc->external)
> +				ret = klp_find_external_symbol(pmod,
> +							       reloc->name,
> +							       &reloc->src);
> +			else
> +				ret = klp_find_symbol(obj->mod->name,
> +						      reloc->name,
> +						      &reloc->src);

I was confused that klp_find_external_symbol() is actually more
generic than klp_find_symbol(). It might help to rename:
klp_find_symbol() -> klp_find_object_symbol()


> +			if (ret)
> +				return ret;
> +		}
> +		ret = klp_write_module_reloc(pmod, reloc->type, reloc->dest,
> +					     reloc->src + reloc->addend);
> +		if (ret) {
> +			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
> +			       reloc->name, reloc->src, ret);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +

[...]

> +static int klp_disable_object(struct klp_object *obj)
> +{
> +	struct klp_func *func;
> +	int ret;

	if (WARN_ON(obj->state != KLP_ENABLED))
		return -EINVAL;

> +
> +	for (func = obj->funcs; func->old_name; func++) {
> +		if (func->state != KLP_ENABLED)
> +			continue;
> +		ret = klp_disable_func(func);
> +		if (ret)
> +			return ret;
> +		if (obj->name)
> +			func->old_addr = 0;
> +	}
> +	obj->state = KLP_DISABLED;
> +
> +	return 0;
> +}
> +
> +static int klp_enable_object(struct module *pmod, struct klp_object *obj)
> +{
> +	struct klp_func *func;
> +	int ret;
> +
	if (WARN_ON(obj->state != KLP_DISABLED))
		return -EINVAL;

> +	if (WARN_ON(!obj->mod && obj->name))
> +		return -EINVAL;
> +
> +	if (obj->relocs) {
> +		ret = klp_write_object_relocations(pmod, obj);

I was curious why the relocation is here. I think that the motivation
was to safe the call when handling comming modules.

IMHO, more clean solution would be to do this in klp_init_object().
It will also cause removing the "pmod" parameter and this function
will be more symmetric with klp_disable_object();

I was curious how it would work, so I prepared a patch. I will send
it in separate mail.

> +		if (ret)
> +			goto unregister;
> +	}
> +
> +	for (func = obj->funcs; func->old_name; func++) {
> +		ret = klp_find_verify_func_addr(func, obj->name);
> +		if (ret)
> +			goto unregister;
> +
> +		ret = klp_enable_func(func);
> +		if (ret)
> +			goto unregister;
> +	}
> +	obj->state = KLP_ENABLED;
> +
> +	return 0;
> +unregister:
> +	WARN_ON(klp_disable_object(obj));
> +	return ret;
> +}
> +
> +static int __klp_disable_patch(struct klp_patch *patch)
> +{
> +	struct klp_object *obj;
> +	int ret;
> +
	if (WARN_ON(patch->state != KLP_ENABLED))
		return -EINVAL;

> +	pr_notice("disabling patch '%s'\n", patch->mod->name);
> +
> +	for (obj = patch->objs; obj->funcs; obj++) {
> +		if (obj->state != KLP_ENABLED)
> +			continue;
> +		ret = klp_disable_object(obj);
> +		if (ret)
> +			return ret;
> +	}
> +	patch->state = KLP_DISABLED;
> +
> +	return 0;
> +}
> +
> +/**
> + * klp_disable_patch() - disables a registered patch
> + * @patch:	The registered, enabled patch to be disabled
> + *
> + * Unregisters the patched functions from ftrace.
> + *
> + * Return: 0 on success, otherwise error
> + */
> +int klp_disable_patch(struct klp_patch *patch)
> +{
> +	int ret;
> +
> +	mutex_lock(&klp_mutex);
> +	if (patch->state == KLP_ENABLED) {

IMHO, this check belongs to the __klp_disable_patch().
Same approach that is already used in klp_enable_patch().

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +	ret = __klp_disable_patch(patch);
> +out:
> +	mutex_unlock(&klp_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(klp_disable_patch);
> +
> +static int __klp_enable_patch(struct klp_patch *patch)
> +{
> +	struct klp_object *obj;
> +	int ret;
> +
> +	if (WARN_ON(patch->state != KLP_DISABLED))
> +		return -EINVAL;
> +
> +	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
> +	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
> +
> +	pr_notice("enabling patch '%s'\n", patch->mod->name);
> +
> +	for (obj = patch->objs; obj->funcs; obj++) {
> +		if (!klp_find_object_module(obj))
> +			continue;
> +		ret = klp_enable_object(patch->mod, obj);
> +		if (ret)
> +			goto unregister;
> +	}
> +	patch->state = KLP_ENABLED;
> +	return 0;
> +
> +unregister:
> +	WARN_ON(__klp_disable_patch(patch));
> +	return ret;
> +}
> +
> +/**
> + * klp_enable_patch() - enables a registered patch
> + * @patch:	The registered, disabled patch to be enabled
> + *
> + * Performs the needed symbol lookups and code relocations,
> + * then registers the patched functions with ftrace.
> + *
> + * Return: 0 on success, otherwise error
> + */
> +int klp_enable_patch(struct klp_patch *patch)
> +{
> +	int ret;
> +
> +	mutex_lock(&klp_mutex);
> +	ret = __klp_enable_patch(patch);
> +	mutex_unlock(&klp_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(klp_enable_patch);
> +
> +static void klp_module_notify_coming(struct module *pmod,
> +				     struct klp_object *obj)

I was confused that this function handles only one patch. Then
I found that it is called for each patch from klp_module_notify().

What about renaming to klp_init_and_enable_object_delayed() or
klp_module_notify_init_and_enable_object() or so.

In fact, we might want to split this into two functions handling
the init and enable part. It will make the name shorter and it
will be more in sync with the rest of the code.

> +{
> +	struct module *mod = obj->mod;
> +	int ret;
> +
> +	pr_notice("applying patch '%s' to loading module '%s'\n",
> +		  pmod->name, mod->name);
> +	obj->mod = mod;

It means that we do not need to call klp_find_object_module() in
klp_enable_object(). This will be solved with my patch moving
the relocation to the init phase as well.

If you agree and we do relocation here. It would make sense to somehow
share the code with klp_init_object().

> +	ret = klp_enable_object(pmod, obj);
> +	if (ret)
> +		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
> +			pmod->name, mod->name, ret);
> +}
> +
> +static void klp_module_notify_going(struct module *pmod,
> +				    struct klp_object *obj)
> +{

Same problem here. I would use a better same, see the comments
klp_module_notify_coming() above.

> +	struct module *mod = obj->mod;
> +	int ret;
> +
> +	pr_notice("reverting patch '%s' on unloading module '%s'\n",
> +		  pmod->name, mod->name);
> +	ret = klp_disable_object(obj);
> +	if (ret)
> +		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
> +			pmod->name, mod->name, ret);
> +	obj->mod = NULL;
> +}
> +
> +static int klp_module_notify(struct notifier_block *nb, unsigned long action,
> +			    void *data)
> +{
> +	struct module *mod = data;
> +	struct klp_patch *patch;
> +	struct klp_object *obj;
> +
> +	if (action != MODULE_STATE_COMING && action != MODULE_STATE_GOING)
> +		return 0;
> +
> +	mutex_lock(&klp_mutex);
> +	list_for_each_entry(patch, &klp_patches, list) {
> +		if (patch->state == KLP_DISABLED)
> +			continue;
> +		for (obj = patch->objs; obj->funcs; obj++) {
> +			if (!obj->name || strcmp(obj->name, mod->name))
> +				continue;
> +			if (action == MODULE_STATE_COMING) {
> +				obj->mod = mod;
> +				klp_module_notify_coming(patch->mod, obj);
> +			} else /* MODULE_STATE_GOING */
> +				klp_module_notify_going(patch->mod, obj);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&klp_mutex);
> +	return 0;
> +}
> +
[...]

> +static int klp_init_patch(struct klp_patch *patch)
> +{
> +	int ret;
> +
> +	if (!patch)
> +		return -EINVAL;

I would feel more comfortable if the take the lock already here.
At least, it might be needed to avoid race with klp_module_notify()
stuff. It will block any module load/remove until the klp structures
are consistent.

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
> +		return ret;
> +	}
> +
> +	/* add to global list of patches */
> +	mutex_lock(&klp_mutex);
> +	list_add(&patch->list, &klp_patches);
> +	mutex_unlock(&klp_mutex);
> +
> +	return 0;
> +}

Anyway, thanks for working on it. The progress is great.

BTW: I wonder what is the preferred way of cooperation. I prepared
patch for changes in the program logic. Here it might be worth
solving the potential conflicts. But I made only comments about
the renaming and other simple changes. I think that these are easier
do directly without having to solve conflict.

Best Regards,
Petr
