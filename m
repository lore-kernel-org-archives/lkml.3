Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaKGVyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:54:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaKGVyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:54:32 -0500
Date: Fri, 7 Nov 2014 15:54:26 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: more patches for the same func: was Re: [PATCH 2/2] kernel: add
 support for live patching
Message-ID: <20141107215426.GH4071@treble.redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <1415284748-14648-3-git-send-email-sjenning@redhat.com>
 <20141107173903.GD1136@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141107173903.GD1136@dhcp128.suse.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 06:39:03PM +0100, Petr Mladek wrote:
> On Thu 2014-11-06 08:39:08, Seth Jennings wrote:
> > This commit introduces code for the live patching core.  It implements
> > an ftrace-based mechanism and kernel interface for doing live patching
> > of kernel and kernel module functions.
> > 
> > It represents the greatest common functionality set between kpatch and
> > kgraft and can accept patches built using either method.
> > 
> > This first version does not implement any consistency mechanism that
> > ensures that old and new code do not run together.  In practice, ~90% of
> > CVEs are safe to apply in this way, since they simply add a conditional
> > check.  However, any function change that can not execute safely with
> > the old version of the function can _not_ be safely applied in this
> > version.
> 
> [...] 
> 
> > +static int lpc_enable_func(struct lpc_func *func)
> > +{
> > +	int ret;
> > +
> > +	BUG_ON(!func->old_addr);
> > +	BUG_ON(func->state != DISABLED);
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
> 
> [...]
> 
> > +/* caller must ensure that obj->mod is set if object is a module */
> > +static int lpc_enable_object(struct module *pmod, struct lpc_object *obj)
> > +{
> > +	struct lpc_func *func;
> > +	int ret;
> > +
> > +	if (obj->mod && !try_module_get(obj->mod))
> > +		return -ENODEV;
> > +
> > +	if (obj->dynrelas) {
> > +		ret = lpc_write_object_relocations(pmod, obj);
> > +		if (ret)
> > +			goto unregister;
> > +	}
> > +	list_for_each_entry(func, &obj->funcs, list) {
> > +		ret = lpc_find_verify_func_addr(func, obj->name);
> > +		if (ret)
> > +			goto unregister;
> > +
> > +		ret = lpc_enable_func(func);
> > +		if (ret)
> > +			goto unregister;
> > +	}
> > +	obj->state = ENABLED;
> > +
> > +	return 0;
> > +unregister:
> > +	WARN_ON(lpc_unregister_object(obj));
> > +	return ret;
> > +}
> > +
> > +/******************************
> > + * enable/disable
> > + ******************************/
> > +
> > +/* must be called with lpc_mutex held */
> > +static struct lpc_patch *lpc_find_patch(struct lp_patch *userpatch)
> > +{
> > +	struct lpc_patch *patch;
> > +
> > +	list_for_each_entry(patch, &lpc_patches, list)
> > +		if (patch->userpatch == userpatch)
> > +			return patch;
> > +
> > +	return NULL;
> > +}
> 
> [...]
> 
> > +
> > +/* must be called with lpc_mutex held */
> > +static int lpc_enable_patch(struct lpc_patch *patch)
> > +{
> > +	struct lpc_object *obj;
> > +	int ret;
> > +
> > +	BUG_ON(patch->state != DISABLED);
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
> AFAIK, this does not handle correctly the situation when there
> are more patches for the same symbol. IMHO, the first registered
> ftrace function wins. It means that later patches are ignored.

Yeah, good point.  With kpatch we had a single ftrace_ops which was
shared for all patched functions, so we didn't have this problem.  From
the ftrace handler, we would just get the most recent version of the
function from our hash table.

With livepatch we decided to change to the model of one ftrace ops per
patched function.  Which I think is probably a good idea, but it's hard
to say for sure without knowing our consistency model yet.

> 
> In kGraft, we detect this situation and do the following:
> 
>    add_new_ftrace_function()
>    /* old one still might be used at this stage */
>    if (old_function)
>       remove_old_ftrace_function();
>    /* the new one is used from now on */
> 
> Similar problem is when a patch is disabled. We need to know
> if it was actually used. If not, we are done. If it is active,
> we need to look if there is an older patch for the the same
> symbol and enable the other ftrace function instead.

Yeah, maybe we should do something similar for livepatch.

> 
> Best Regards,
> Petr
> 
> 
> PS: We should probably decide on the used structures before we start
> coding fixes for this particular problems. I have similar concern about
> the complexity as my colleagues have. But I need to think more about
> it. Let's discuss it in the other thread.

Sounds good :-)

-- 
Josh
