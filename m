Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab3HNHcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:32:23 -0400
Received: from ozlabs.org ([203.10.76.45]:56698 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab3HNHcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:32:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] [PATCH 1/3] module: Add flag to allow mod params to have no arguments
In-Reply-To: <20130813213038.928834078@goodmis.org>
References: <20130813210228.989279359@goodmis.org> <20130813213038.928834078@goodmis.org>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 14 Aug 2013 17:00:53 +0930
Message-ID: <87y584k9ua.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> Currently the params.c code allows only two "set" functions to have
> no arguments. If a parameter does not have an argument, then it
> looks at the set function and tests if it is either param_set_bool()
> or param_set_bint(). If it is not one of these functions, then it
> fails the loading of the module.
>
> But there may be module parameters that have different set functions
> and still allow no arguments. But unless each of these cases adds
> their function to the if statement, it wont be allowed to have no
> arguments. This method gets rather messing and does not scale.
>
> Instead, introduce a flags field to the kernel_param_ops, where if
> the flag KERNEL_PARAM_FL_NOARG is set, the parameter will not fail
> if it does not contain an argument. It will be expected that the
> corresponding set function can handle a NULL pointer as "val".

Good idea.  This hack was introduced because people wrote their own
param parsers which didn't expect NULL, leading to oopsen.

A flag is a better solution.

Applied all three.

Thanks,
Rusty.


>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/moduleparam.h |   13 ++++++++++++-
>  kernel/params.c             |    6 ++++--
>  2 files changed, 16 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 27d9da3..c3eb102 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -36,7 +36,18 @@ static const char __UNIQUE_ID(name)[]					  \
>  
>  struct kernel_param;
>  
> +/*
> + * Flags available for kernel_param_ops
> + *
> + * NOARG - the parameter allows for no argument (foo instead of foo=1)
> + */
> +enum {
> +	KERNEL_PARAM_FL_NOARG = (1 << 0)
> +};
> +
>  struct kernel_param_ops {
> +	/* How the ops should behave */
> +	unsigned int flags;
>  	/* Returns 0, or -errno.  arg is in kp->arg. */
>  	int (*set)(const char *val, const struct kernel_param *kp);
>  	/* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
> @@ -187,7 +198,7 @@ struct kparam_array
>  /* Obsolete - use module_param_cb() */
>  #define module_param_call(name, set, get, arg, perm)			\
>  	static struct kernel_param_ops __param_ops_##name =		\
> -		 { (void *)set, (void *)get };				\
> +		{ 0, (void *)set, (void *)get };			\
>  	__module_param_call(MODULE_PARAM_PREFIX,			\
>  			    name, &__param_ops_##name, arg,		\
>  			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
> diff --git a/kernel/params.c b/kernel/params.c
> index 440e65d..27a0af9 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -103,8 +103,8 @@ static int parse_one(char *param,
>  			    || params[i].level > max_level)
>  				return 0;
>  			/* No one handled NULL, so do it here. */
> -			if (!val && params[i].ops->set != param_set_bool
> -			    && params[i].ops->set != param_set_bint)
> +			if (!val &&
> +			    !(params[i].ops->flags & KERNEL_PARAM_FL_NOARG))
>  				return -EINVAL;
>  			pr_debug("handling %s with %p\n", param,
>  				params[i].ops->set);
> @@ -320,6 +320,7 @@ int param_get_bool(char *buffer, const struct kernel_param *kp)
>  EXPORT_SYMBOL(param_get_bool);
>  
>  struct kernel_param_ops param_ops_bool = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
>  	.set = param_set_bool,
>  	.get = param_get_bool,
>  };
> @@ -370,6 +371,7 @@ int param_set_bint(const char *val, const struct kernel_param *kp)
>  EXPORT_SYMBOL(param_set_bint);
>  
>  struct kernel_param_ops param_ops_bint = {
> +	.flags = KERNEL_PARAM_FL_NOARG,
>  	.set = param_set_bint,
>  	.get = param_get_int,
>  };
> -- 
> 1.7.10.4
