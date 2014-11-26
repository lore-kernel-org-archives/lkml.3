Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaKZOTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:19:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbaKZOTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:19:09 -0500
Date: Wed, 26 Nov 2014 15:19:17 +0100 (CET)
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
Message-ID: <alpine.LNX.2.00.1411261451570.10866@pobox.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <1416935709-404-3-git-send-email-sjenning@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

thank you for new version, it looks much better now. I still have some 
comments though. See below please.

On Tue, 25 Nov 2014, Seth Jennings wrote:

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

I wonder if we really need old_addr as an external field. I assume that 
userspace tool in kpatch use it as a "hint" for kernel part and thus 
kallsyms is not needed there (and it solves ambiguity problem as well). 
But I am not sure if it is gonna be the same in upstream. When kernel is 
randomized (CONFIG_RANDOMIZE_BASE is set to 'y', though default is 'n') 
old_addr is not usable (and we throw it away in the code). Without 
old_addr being set by the user we could spare some of code (calls to 
klp_verify_vmlinux_symbol and such). 

So the question is whether future userspace tool in upstream would need it 
and would use it. Please note that I do not mean it as a kpatch or kgraft 
way to do things, I'm just not sure about old_addr being "public" and want 
do discuss the options.

The ambiguity of symbols was discussed in some other thread in lkml in 
october (I guess) with no conclusion IIRC...

[...]

> +static void klp_ftrace_handler(unsigned long ip, unsigned long parent_ip,
> +			       struct ftrace_ops *ops, struct pt_regs *regs)

I think we should label ftrace handler as notrace to prevent possible 
recursion loop when one would like to patch the handler :). See note in 
the comment for register_ftrace_function in kernel/trace/ftrace.c.

> +{
> +	struct klp_func *func = ops->private;
> +
> +	regs->ip = (unsigned long)func->new_func;
> +}
> +
> +static int klp_enable_func(struct klp_func *func)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!func->old_addr))
> +		return -EINVAL;
> +
> +	if (WARN_ON(func->state != KLP_DISABLED))
> +		return -EINVAL;
> +
> +	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 0, 0);
> +	if (ret) {
> +		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
> +		       func->old_name, ret);
> +		return ret;
> +	}
> +	ret = register_ftrace_function(func->fops);
> +	if (ret) {
> +		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
> +		       func->old_name, ret);
> +		ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
> +	} else
> +		func->state = KLP_ENABLED;

Missing braces for else branch.

> +
> +	return ret;
> +}

[...]

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
> +		ret = -EINVAL;
> +		goto out;
> +	}

if (patch->state == KLP_DISABLED) { ?

> +	ret = __klp_disable_patch(patch);
> +out:
> +	mutex_unlock(&klp_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(klp_disable_patch);
> +


[...]
> +static void klp_module_notify_coming(struct module *pmod,
> +				     struct klp_object *obj)
> +{
> +	struct module *mod = obj->mod;
> +	int ret;
> +
> +	pr_notice("applying patch '%s' to loading module '%s'\n",
> +		  pmod->name, mod->name);
> +	obj->mod = mod;

Still there :)

> +	ret = klp_enable_object(pmod, obj);
> +	if (ret)
> +		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
> +			pmod->name, mod->name, ret);
> +}
> +
> +static void klp_module_notify_going(struct module *pmod,
> +				    struct klp_object *obj)
> +{
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


[...]
> +static int klp_init_objects(struct klp_patch *patch)
> +{
> +	struct klp_object *obj;
> +	int ret;
> +
> +	if (!patch->objs)
> +		return -EINVAL;
> +
> +	for (obj = patch->objs; obj->funcs; obj++) {
> +		/* obj->mod set by klp_object_module_get() */

Still there. Moreover obj->mod is also set in module notifier.

> +		obj->state = KLP_DISABLED;
> +
> +		/* sysfs */
> +		obj->kobj = kobject_create_and_add(obj->name, &patch->kobj);

There is the problem with obj->name set to NULL (for vmlinux). This 
creates subdirectory called '(null)' which is not nice.

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
> +}

> +int klp_register_patch(struct klp_patch *patch)
> +{
> +	int ret;
> +
> +	if (!patch || !patch->mod || !patch->objs)
> +		return -EINVAL;

Check for patch->objs is also above in klp_init_objects, so it can be 
removed from here.

> +
> +	/*
> +	 * A reference is taken on the patch module to prevent it from being
> +	 * unloaded.  Right now, we don't allow patch modules to unload since
> +	 * there is currently no method to determine if a thread is still
> +	 * running in the patched code contained in the patch module once
> +	 * the ftrace registration is successful.
> +	 */
> +	if (!try_module_get(patch->mod))
> +		return -ENODEV;
> +
> +	ret = klp_init_patch(patch);
> +	if (ret)
> +		module_put(patch->mod);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(klp_register_patch);

Thank you again for good work!

--
Miroslav Benes
SUSE Labs
