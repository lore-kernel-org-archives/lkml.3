Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbbAPQvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:51:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbbAPQvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:51:13 -0500
Date: Fri, 16 Jan 2015 17:51:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: support for repatching a function
In-Reply-To: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com>
Message-ID: <alpine.LNX.2.10.1501161743220.1074@wotan.suse.de>
References: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.10 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015, Josh Poimboeuf wrote:

> Add support for patching a function multiple times.  If multiple patches
> affect a function, the function in the most recently enabled patch
> "wins".  This enables a cumulative patch upgrade path, where each patch
> is a superset of previous patches.
> 
> This requires restructuring the data a little bit.  With the current
> design, where each klp_func struct has its own ftrace_ops, we'd have to
> unregister the old ops and then register the new ops, because
> FTRACE_OPS_FL_IPMODIFY prevents us from having two ops registered for
> the same function at the same time.  That would leave a regression
> window where the function isn't patched at all (not good for a patch
> upgrade path).
> 
> This patch replaces the per-klp_func ftrace_ops with a global klp_ops
> list, with one ftrace_ops per original function.  A single ftrace_ops is
> shared between all klp_funcs which have the same old_addr.  This allows
> the switch between function versions to happen instantaneously by
> updating the klp_ops struct's func_stack list.  The winner is the
> klp_func at the top of the func_stack (front of the list).
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Acked-by: Seth Jennings <sjenning@redhat.com>
> ---
>  include/linux/livepatch.h |   4 +-
>  kernel/livepatch/core.c   | 157 +++++++++++++++++++++++++++++++---------------
>  2 files changed, 108 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 950bc61..f14c6fb 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -40,8 +40,8 @@ enum klp_state {
>   * @old_addr:	a hint conveying at what address the old function
>   *		can be found (optional, vmlinux patches only)
>   * @kobj:	kobject for sysfs resources
> - * @fops:	ftrace operations structure
>   * @state:	tracks function-level patch application state
> + * @stack_node:	list node for klp_ops func_stack list
>   */
>  struct klp_func {
>  	/* external */
> @@ -59,8 +59,8 @@ struct klp_func {
>  
>  	/* internal */
>  	struct kobject kobj;
> -	struct ftrace_ops *fops;
>  	enum klp_state state;
> +	struct list_head stack_node;
>  };
>  
>  /**
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index ce42d3b..5c10381 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -29,17 +29,40 @@
>  #include <linux/kallsyms.h>
>  #include <linux/livepatch.h>
>  
> +struct klp_ops {
> +	struct list_head node;
> +	struct list_head func_stack;
> +	struct ftrace_ops fops;
> +};
> +
>  /*
> - * The klp_mutex protects the klp_patches list and state transitions of any
> - * structure reachable from the patches list.  References to any structure must
> - * be obtained under mutex protection.
> + * The klp_mutex protects the global lists and state transitions of any
> + * structure reachable from them.  References to any structure must be obtained
> + * under mutex protection (except in klp_ftrace_handler(), which uses RCU to
> + * ensure it gets consistent data).
>   */
> -
>  static DEFINE_MUTEX(klp_mutex);
> +
>  static LIST_HEAD(klp_patches);
> +static LIST_HEAD(klp_ops);
>  
>  static struct kobject *klp_root_kobj;
>  
> +static struct klp_ops *klp_find_ops(unsigned long old_addr)
> +{
> +	struct klp_ops *ops;
> +	struct klp_func *func;
> +
> +	list_for_each_entry(ops, &klp_ops, node) {
> +		func = list_first_entry(&ops->func_stack, struct klp_func,
> +					stack_node);
> +		if (func->old_addr == old_addr)
> +			return ops;
> +	}
> +
> +	return NULL;
> +}
> +
>  static bool klp_is_module(struct klp_object *obj)
>  {
>  	return obj->name;
> @@ -267,16 +290,28 @@ static int klp_write_object_relocations(struct module *pmod,
>  
>  static void notrace klp_ftrace_handler(unsigned long ip,
>  				       unsigned long parent_ip,
> -				       struct ftrace_ops *ops,
> +				       struct ftrace_ops *fops,
>  				       struct pt_regs *regs)
>  {
> -	struct klp_func *func = ops->private;
> +	struct klp_ops *ops;
> +	struct klp_func *func;
> +
> +	ops = container_of(fops, struct klp_ops, fops);
> +
> +	rcu_read_lock();
> +	func = list_first_or_null_rcu(&ops->func_stack, struct klp_func,
> +				      stack_node);
> +	rcu_read_unlock();
> +
> +	if (WARN_ON(!func))
> +		return;
>  
>  	klp_arch_set_pc(regs, (unsigned long)func->new_func);
>  }
>  
>  static int klp_disable_func(struct klp_func *func)
>  {
> +	struct klp_ops *ops;
>  	int ret;
>  
>  	if (WARN_ON(func->state != KLP_ENABLED))
> @@ -285,16 +320,28 @@ static int klp_disable_func(struct klp_func *func)
>  	if (WARN_ON(!func->old_addr))
>  		return -EINVAL;
>  
> -	ret = unregister_ftrace_function(func->fops);
> -	if (ret) {
> -		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
> -		       func->old_name, ret);
> -		return ret;
> -	}
> +	ops = klp_find_ops(func->old_addr);
> +	if (WARN_ON(!ops))
> +		return -EINVAL;
>  
> -	ret = ftrace_set_filter_ip(func->fops, func->old_addr, 1, 0);
> -	if (ret)
> -		pr_warn("function unregister succeeded but failed to clear the filter\n");
> +	if (list_is_singular(&ops->func_stack)) {
> +		ret = unregister_ftrace_function(&ops->fops);
> +		if (ret) {
> +			pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
> +			       func->old_name, ret);
> +			return ret;
> +		}
> +
> +		ret = ftrace_set_filter_ip(&ops->fops, func->old_addr, 1, 0);
> +		if (ret)
> +			pr_warn("function unregister succeeded but failed to clear the filter\n");
> +
> +		list_del_rcu(&func->stack_node);
> +		list_del(&ops->node);
> +		kfree(ops);
> +	} else {
> +		list_del_rcu(&func->stack_node);

One thing that makes me worried here is we basically apply patches in a 
'stackable' manner, but then this allows them to be removed (disabled) in 
an arbitrary order. Is this really the semantics we want?

The scenario I am concerned about, in a nutshell:

foo_unpatched()
	foo_patch1()
		foo_patch2()
			foo_patch3()
		disable(foo_patch2)
		disable(foo_patch3)
	foo_patch1()

I.e. basically due to reverting of foo_patch2() while it wasn't in use, we 
turn subsequent revert of foo_patch3() into foo_patch1() state, although 
the function foo_patch3() was originally patching was foo_patch2().

If this is implemented really in a fully stackable manner (i.e. you 
basically would be able to disable only the function that is currently 
"active", i.e. on top of the stack), woudln't that provide more 
predictable semantics?

Thanks,

-- 
Jiri Kosina
SUSE Labs
