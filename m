Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaLITs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:48:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaLITsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:48:55 -0500
Date: Tue, 9 Dec 2014 12:51:41 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] livepatch v5: split init and free code that is done
 only for loaded modules
Message-ID: <20141209185141.GA3955@treble.redhat.com>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
 <1418148307-21434-6-git-send-email-pmladek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418148307-21434-6-git-send-email-pmladek@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 07:05:06PM +0100, Petr Mladek wrote:
> This patch makes it clear what initialization and freeing steps need to be done
> when an object (module) is being loaded or removed. It will help to maintain
> the module coming and going handlers. Also it will remove duplicated
> code from these handlers.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  kernel/livepatch/core.c | 92 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 61 insertions(+), 31 deletions(-)
> 
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 97a8d4a3d6d8..fe312b9ada78 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -590,6 +590,12 @@ static struct kobj_type klp_ktype_func = {
>  	.sysfs_ops = &kobj_sysfs_ops,
>  };
>  
> +/* Clean up when a patched object is unloaded */
> +static void klp_free_func_loaded(struct klp_func *func)
> +{
> +	func->old_addr = 0;
> +}
> +
>  /*
>   * Free all functions' kobjects in the array up to some limit. When limit is
>   * NULL, all kobjects are freed.
> @@ -603,6 +609,17 @@ static void klp_free_funcs_limited(struct klp_object *obj,
>  		kobject_put(&func->kobj);
>  }
>  
> +/* Clean up when a patched object is unloaded */
> +static void klp_free_object_loaded(struct klp_object *obj)
> +{
> +	struct klp_func *func;
> +
> +	obj->mod = NULL;
> +
> +	for (func = obj->funcs; func->old_name; func++)
> +		klp_free_func_loaded(func);
> +}
> +
>  /*
>   * Free all objects' kobjects in the array up to some limit. When limit is
>   * NULL, all kobjects are freed.
> @@ -626,6 +643,12 @@ static void klp_free_patch(struct klp_patch *patch)
>  	kobject_put(&patch->kobj);
>  }
>  
> +/* parts of the initialization that is done only when the object is loaded */
> +static int klp_init_func_loaded(struct klp_object *obj, struct klp_func *func)
> +{
> +	return klp_find_verify_func_addr(obj, func);
> +}
> +

Creating a new function here for one line of code, which is only called
once, seems excessive, and makes the code harder to understand IMO.

Ditto for klp_free_func_loaded.

>  static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  {
>  	struct ftrace_ops *ops;
> @@ -633,10 +656,6 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  
>  	func->state = KLP_DISABLED;
>  
> -	ret = klp_find_verify_func_addr(obj, func);
> -	if (ret)
> -		return ret;
> -
>  	ops = kzalloc(sizeof(*ops), GFP_KERNEL);
>  	if (!ops)
>  		ret = -ENOMEM;
> @@ -656,6 +675,28 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
>  	return 0;
>  }
>  
> +/* parts of the initialization that is done only when the object is loaded */
> +static int klp_init_object_loaded(struct klp_patch *patch,
> +				  struct klp_object *obj)
> +{
> +	struct klp_func *func;
> +	int ret;
> +
> +	if (obj->relocs) {
> +		ret = klp_write_object_relocations(patch->mod, obj);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	for (func = obj->funcs; func->old_name; func++) {
> +		ret = klp_init_func_loaded(obj, func);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
>  static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>  {
>  	struct klp_func *func;
> @@ -669,12 +710,6 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>  
>  	klp_find_object_module(obj);
>  
> -	if (obj->relocs && klp_is_object_loaded(obj)) {
> -		ret = klp_write_object_relocations(patch->mod, obj);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	name = klp_is_module(obj) ? obj->name : "vmlinux";
>  	obj->kobj = kobject_create_and_add(name, &patch->kobj);
>  	if (!obj->kobj)
> @@ -686,6 +721,12 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
>  			goto free;
>  	}
>  
> +	if (klp_is_object_loaded(obj)) {
> +		ret = klp_init_object_loaded(patch, obj);
> +		if (ret)
> +			goto free;
> +	}
> +
>  	return 0;
>  
>  free:
> @@ -802,27 +843,19 @@ int klp_register_patch(struct klp_patch *patch)
>  }
>  EXPORT_SYMBOL_GPL(klp_register_patch);
>  
> -static void klp_module_notify_coming(struct module *pmod,
> +static void klp_module_notify_coming(struct klp_patch *patch,
>  				     struct klp_object *obj)
>  {
> -	struct klp_func *func;
> +	struct module *pmod = patch->mod;
>  	struct module *mod = obj->mod;
>  	int ret;
>  
>  	pr_notice("applying patch '%s' to loading module '%s'\n",
>  		  pmod->name, mod->name);
>  
> -	if (obj->relocs) {
> -		ret = klp_write_object_relocations(pmod, obj);
> -		if (ret)
> -			goto err;
> -	}
> -
> -	for (func = obj->funcs; func->old_name; func++) {
> -		ret = klp_find_verify_func_addr(obj, func);
> -		if (ret)
> -			goto err;
> -	}
> +	ret = klp_init_object_loaded(patch, obj);
> +	if (ret)
> +		goto err;
>  
>  	ret = klp_enable_object(obj);
>  	if (!ret)
> @@ -833,10 +866,10 @@ err:
>  		pmod->name, mod->name, ret);
>  }
>  
> -static void klp_module_notify_going(struct module *pmod,
> +static void klp_module_notify_going(struct klp_patch *patch,
>  				    struct klp_object *obj)
>  {
> -	struct klp_func *func;
> +	struct module *pmod = patch->mod;
>  	struct module *mod = obj->mod;
>  	int ret;
>  
> @@ -848,10 +881,7 @@ static void klp_module_notify_going(struct module *pmod,
>  		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
>  			pmod->name, mod->name, ret);
>  
> -	for (func = obj->funcs; func->old_name; func++)
> -		func->old_addr = 0;
> -
> -	obj->mod = NULL;
> +	klp_free_object_loaded(obj);
>  }
>  
>  static int klp_module_notify(struct notifier_block *nb, unsigned long action,
> @@ -876,9 +906,9 @@ static int klp_module_notify(struct notifier_block *nb, unsigned long action,
>  
>  			if (action == MODULE_STATE_COMING) {
>  				obj->mod = mod;
> -				klp_module_notify_coming(patch->mod, obj);
> +				klp_module_notify_coming(patch, obj);
>  			} else /* MODULE_STATE_GOING */
> -				klp_module_notify_going(patch->mod, obj);
> +				klp_module_notify_going(patch, obj);
>  
>  			break;
>  		}
> -- 
> 1.8.5.2
> 

-- 
Josh
