Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaKGRjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:39:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbaKGRjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:39:06 -0500
Date: Fri, 7 Nov 2014 18:39:03 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: more patches for the same func: was Re: [PATCH 2/2] kernel: add
 support for live patching
Message-ID: <20141107173903.GD1136@dhcp128.suse.cz>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415284748-14648-3-git-send-email-sjenning@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-06 08:39:08, Seth Jennings wrote:
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

[...] 

> +static int lpc_enable_func(struct lpc_func *func)
> +{
> +	int ret;
> +
> +	BUG_ON(!func->old_addr);
> +	BUG_ON(func->state != DISABLED);
> +	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 0, 0);
> +	if (ret) {
> +		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
> +		       func->old_name, ret);
> +		return ret;
> +	}
> +	ret = register_ftrace_function(&func->fops);
> +	if (ret) {
> +		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
> +		       func->old_name, ret);
> +		ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
> +	} else
> +		func->state = ENABLED;
> +
> +	return ret;
> +}
> +

[...]

> +/* caller must ensure that obj->mod is set if object is a module */
> +static int lpc_enable_object(struct module *pmod, struct lpc_object *obj)
> +{
> +	struct lpc_func *func;
> +	int ret;
> +
> +	if (obj->mod && !try_module_get(obj->mod))
> +		return -ENODEV;
> +
> +	if (obj->dynrelas) {
> +		ret = lpc_write_object_relocations(pmod, obj);
> +		if (ret)
> +			goto unregister;
> +	}
> +	list_for_each_entry(func, &obj->funcs, list) {
> +		ret = lpc_find_verify_func_addr(func, obj->name);
> +		if (ret)
> +			goto unregister;
> +
> +		ret = lpc_enable_func(func);
> +		if (ret)
> +			goto unregister;
> +	}
> +	obj->state = ENABLED;
> +
> +	return 0;
> +unregister:
> +	WARN_ON(lpc_unregister_object(obj));
> +	return ret;
> +}
> +
> +/******************************
> + * enable/disable
> + ******************************/
> +
> +/* must be called with lpc_mutex held */
> +static struct lpc_patch *lpc_find_patch(struct lp_patch *userpatch)
> +{
> +	struct lpc_patch *patch;
> +
> +	list_for_each_entry(patch, &lpc_patches, list)
> +		if (patch->userpatch == userpatch)
> +			return patch;
> +
> +	return NULL;
> +}

[...]

> +
> +/* must be called with lpc_mutex held */
> +static int lpc_enable_patch(struct lpc_patch *patch)
> +{
> +	struct lpc_object *obj;
> +	int ret;
> +
> +	BUG_ON(patch->state != DISABLED);
> +
> +	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
> +	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
> +
> +	pr_notice("enabling patch '%s'\n", patch->mod->name);
> +
> +	list_for_each_entry(obj, &patch->objs, list) {
> +		if (!is_object_loaded(obj))
> +			continue;
> +		ret = lpc_enable_object(patch->mod, obj);
> +		if (ret)
> +			goto unregister;
> +	}
> +	patch->state = ENABLED;
> +	return 0;
> +
> +unregister:
> +	WARN_ON(lpc_disable_patch(patch));
> +	return ret;
> +}
> +
> +int lp_enable_patch(struct lp_patch *userpatch)
> +{
> +	struct lpc_patch *patch;
> +	int ret;
> +
> +	down(&lpc_mutex);
> +	patch = lpc_find_patch(userpatch);
> +	if (!patch) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +	ret = lpc_enable_patch(patch);
> +out:
> +	up(&lpc_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(lp_enable_patch);

AFAIK, this does not handle correctly the situation when there
are more patches for the same symbol. IMHO, the first registered
ftrace function wins. It means that later patches are ignored.

In kGraft, we detect this situation and do the following:

   add_new_ftrace_function()
   /* old one still might be used at this stage */
   if (old_function)
      remove_old_ftrace_function();
   /* the new one is used from now on */

Similar problem is when a patch is disabled. We need to know
if it was actually used. If not, we are done. If it is active,
we need to look if there is an older patch for the the same
symbol and enable the other ftrace function instead.

Best Regards,
Petr


PS: We should probably decide on the used structures before we start
coding fixes for this particular problems. I have similar concern about
the complexity as my colleagues have. But I need to think more about
it. Let's discuss it in the other thread.
