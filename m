Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaHZF1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:27:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:45760 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaHZF1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:27:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,401,1406617200"; 
   d="scan'208";a="472607115"
Date: Tue, 26 Aug 2014 02:30:06 -0300
From: Lucas De Marchi <lucas.demarchi@intel.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, linux-modules@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] module: Lock up a module when loading with a
 LOCLUP flag
Message-ID: <20140826053004.GG1409@intel.com>
References: <20140825105520.21089.26870.stgit@kbuild-fedora.novalocal>
 <20140825105548.21089.42883.stgit@kbuild-fedora.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825105548.21089.42883.stgit@kbuild-fedora.novalocal>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:55:48AM +0000, Masami Hiramatsu wrote:
> Lock-up a module in kernel so that it is not removed unless
> forcibly unload. This is done by loading a module with
> MODULE_INIT_LOCKUP_MODULE flag (via finit_module).
> This speeds up try_module_get by skipping refcount inc/dec for
> the locked modules.
> 
> Note that this flag requires to update libkmod to support it.

Patches to kmod go to linux-modules@vger.kernel.org

However I'm skeptical with the use case of this flag. Is this only so
that try_module_get() is a little bit faster? How much?

Then this would depend on a flag the user passed to modprobe which means
only a few modules will use the flag. If you change the default
behavior in kmod to pass this flag always, then any module the user
wants to remove will need to be forcibly removed.

I'm leaving the rest of the patch here since I'm CC'ing linux-modules.

-- 
Lucas De Marchi


> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  include/linux/module.h      |    6 ++++++
>  include/uapi/linux/module.h |    1 +
>  kernel/module.c             |   28 ++++++++++++++++++++--------
>  3 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 71f282a..670cb2e 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -205,6 +205,7 @@ struct module_use {
>  
>  enum module_state {
>  	MODULE_STATE_LIVE,	/* Normal state. */
> +	MODULE_STATE_LOCKUP,	/* Module is never removed except forced */
>  	MODULE_STATE_COMING,	/* Full formed, running module_init. */
>  	MODULE_STATE_GOING,	/* Going away. */
>  	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> @@ -390,6 +391,11 @@ static inline int module_is_live(struct module *mod)
>  	return mod->state != MODULE_STATE_GOING;
>  }
>  
> +static inline int module_is_locked(struct module *mod)
> +{
> +	return mod->state == MODULE_STATE_LOCKUP;
> +}
> +
>  struct module *__module_text_address(unsigned long addr);
>  struct module *__module_address(unsigned long addr);
>  bool is_module_address(unsigned long addr);
> diff --git a/include/uapi/linux/module.h b/include/uapi/linux/module.h
> index 38da425..8195603 100644
> --- a/include/uapi/linux/module.h
> +++ b/include/uapi/linux/module.h
> @@ -4,5 +4,6 @@
>  /* Flags for sys_finit_module: */
>  #define MODULE_INIT_IGNORE_MODVERSIONS	1
>  #define MODULE_INIT_IGNORE_VERMAGIC	2
> +#define MODULE_INIT_LOCKUP_MODULE	4
>  
>  #endif /* _UAPI_LINUX_MODULE_H */
> diff --git a/kernel/module.c b/kernel/module.c
> index 3bd0dc9..85ffc1d 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -753,7 +753,7 @@ static int __try_stop_module(void *_sref)
>  	struct stopref *sref = _sref;
>  
>  	/* If it's not unused, quit unless we're forcing. */
> -	if (module_refcount(sref->mod) != 0) {
> +	if (module_is_locked(sref->mod) || module_refcount(sref->mod) != 0) {
>  		if (!(*sref->forced = try_force_unload(sref->flags)))
>  			return -EWOULDBLOCK;
>  	}
> @@ -830,7 +830,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>  	}
>  
>  	/* Doing init or already dying? */
> -	if (mod->state != MODULE_STATE_LIVE) {
> +	if (mod->state != MODULE_STATE_LIVE &&
> +	    mod->state != MODULE_STATE_LOCKUP) {
>  		/* FIXME: if (force), slam module count damn the torpedoes */
>  		pr_debug("%s already dying\n", mod->name);
>  		ret = -EBUSY;
> @@ -947,6 +948,9 @@ bool try_module_get(struct module *module)
>  	bool ret = true;
>  
>  	if (module) {
> +		if (module_is_locked(module))
> +			goto end;
> +
>  		preempt_disable();
>  
>  		if (likely(module_is_live(module))) {
> @@ -957,13 +961,14 @@ bool try_module_get(struct module *module)
>  
>  		preempt_enable();
>  	}
> +end:
>  	return ret;
>  }
>  EXPORT_SYMBOL(try_module_get);
>  
>  void module_put(struct module *module)
>  {
> -	if (module) {
> +	if (module && !module_is_locked(module)) {
>  		preempt_disable();
>  		smp_wmb(); /* see comment in module_refcount */
>  		__this_cpu_inc(module->refptr->decs);
> @@ -1026,6 +1031,7 @@ static ssize_t show_initstate(struct module_attribute *mattr,
>  
>  	switch (mk->mod->state) {
>  	case MODULE_STATE_LIVE:
> +	case MODULE_STATE_LOCKUP:
>  		state = "live";
>  		break;
>  	case MODULE_STATE_COMING:
> @@ -2981,6 +2987,7 @@ static bool finished_loading(const char *name)
>  	mutex_lock(&module_mutex);
>  	mod = find_module_all(name, strlen(name), true);
>  	ret = !mod || mod->state == MODULE_STATE_LIVE
> +		|| mod->state == MODULE_STATE_LOCKUP
>  		|| mod->state == MODULE_STATE_GOING;
>  	mutex_unlock(&module_mutex);
>  
> @@ -2999,7 +3006,7 @@ static void do_mod_ctors(struct module *mod)
>  }
>  
>  /* This is where the real work happens */
> -static int do_init_module(struct module *mod)
> +static int do_init_module(struct module *mod, bool locked)
>  {
>  	int ret = 0;
>  
> @@ -3034,7 +3041,7 @@ static int do_init_module(struct module *mod)
>  	}
>  
>  	/* Now it's a first class citizen! */
> -	mod->state = MODULE_STATE_LIVE;
> +	mod->state = locked ? MODULE_STATE_LOCKUP : MODULE_STATE_LIVE;
>  	blocking_notifier_call_chain(&module_notify_list,
>  				     MODULE_STATE_LIVE, mod);
>  
> @@ -3290,7 +3297,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
>  	/* Done! */
>  	trace_module_load(mod);
>  
> -	return do_init_module(mod);
> +	return do_init_module(mod, flags & MODULE_INIT_LOCKUP_MODULE);
>  
>   bug_cleanup:
>  	/* module_bug_cleanup needs module_mutex protection */
> @@ -3358,8 +3365,9 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
>  
>  	pr_debug("finit_module: fd=%d, uargs=%p, flags=%i\n", fd, uargs, flags);
>  
> -	if (flags & ~(MODULE_INIT_IGNORE_MODVERSIONS
> -		      |MODULE_INIT_IGNORE_VERMAGIC))
> +	if (flags & ~(MODULE_INIT_IGNORE_MODVERSIONS |
> +		      MODULE_INIT_IGNORE_VERMAGIC |
> +		      MODULE_INIT_LOCKUP_MODULE))
>  		return -EINVAL;
>  
>  	err = copy_module_from_fd(fd, &info);
> @@ -3602,10 +3610,14 @@ static char *module_flags(struct module *mod, char *buf)
>  
>  	BUG_ON(mod->state == MODULE_STATE_UNFORMED);
>  	if (mod->taints ||
> +	    mod->state == MODULE_STATE_LOCKUP ||
>  	    mod->state == MODULE_STATE_GOING ||
>  	    mod->state == MODULE_STATE_COMING) {
>  		buf[bx++] = '(';
>  		bx += module_flags_taint(mod, buf + bx);
> +		/* Show a - for module-is-locked */
> +		if (mod->state == MODULE_STATE_LOCKUP)
> +			buf[bx++] = '*';
>  		/* Show a - for module-is-being-unloaded */
>  		if (mod->state == MODULE_STATE_GOING)
>  			buf[bx++] = '-';
> 
> 
