Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab3ETInU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 04:43:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3ETInJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 04:43:09 -0400
Date: Mon, 20 May 2013 04:42:54 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, oleg@redhat.com,
        bfields@fieldses.org, viro@zeniv.linux.org.uk, bharrosh@panasas.com,
        devel@openvz.org
Subject: Re: [RFC PATCH] kmod: add ability to swap root in usermode helper
Message-ID: <20130520044254.42b1cd88@tlielax.poochiereds.net>
In-Reply-To: <20130520070017.7957.9224.stgit@localhost.localdomain>
References: <20130520070017.7957.9224.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 May 2013 11:00:37 +0400
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> Usermode helper executes all binaries in global "init" root context. This
> doesn't allow to call to call the binary from other root (for example in a
> container).
> Currently, containerized NFS server requires an ability to execute a binary in
> a other context, than "init" root (UMH is used for client recovery tracking).
> This patch adds root swap to ____call_usermodehelper(), if non-NULL root was
> passed as a part of subprocess_info data, and a call_usermodehelper_root()
> helper, which accept root as a parameter. Root path reference must be hold by
> the caller, since it will be on UMH thread exit.
> 

I assume you mean that it will be put on thread exit.

> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---
>  include/linux/kmod.h |    9 +++++++++
>  kernel/kmod.c        |   41 ++++++++++++++++++++++++++++++++++-------
>  2 files changed, 43 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 0555cc6..0b041c7 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -64,12 +64,21 @@ struct subprocess_info {
>  	int (*init)(struct subprocess_info *info, struct cred *new);
>  	void (*cleanup)(struct subprocess_info *info);
>  	void *data;
> +	struct path *root;
>  };
>  
>  extern int
> +call_usermodehelper_root(char *path, char **argv, char **envp, int wait,
> +			 struct path *root);
> +extern int
>  call_usermodehelper(char *path, char **argv, char **envp, int wait);
>  
>  extern struct subprocess_info *
> +call_usermodehelper_setup_root(char *path, char **argv, char **envp, gfp_t gfp_mask,
> +			       int (*init)(struct subprocess_info *info, struct cred *new),
> +			       void (*cleanup)(struct subprocess_info *), void *data,
> +			       struct path *root);
> +extern struct subprocess_info *
>  call_usermodehelper_setup(char *path, char **argv, char **envp, gfp_t gfp_mask,
>  			  int (*init)(struct subprocess_info *info, struct cred *new),
>  			  void (*cleanup)(struct subprocess_info *), void *data);
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 1296e72..1b41f2c 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -39,6 +39,7 @@
>  #include <linux/rwsem.h>
>  #include <linux/ptrace.h>
>  #include <linux/async.h>
> +#include <linux/fs_struct.h>
>  #include <asm/uaccess.h>
>  
>  #include <trace/events/module.h>
> @@ -215,6 +216,9 @@ static int ____call_usermodehelper(void *data)
>  	 */
>  	set_user_nice(current, 0);
>  
> +	if (sub_info->root)
> +		set_fs_root(current->fs, sub_info->root);
> +
>  	retval = -ENOMEM;
>  	new = prepare_kernel_cred(current);
>  	if (!new)
> @@ -505,7 +509,7 @@ static void helper_unlock(void)
>  }
>  
>  /**
> - * call_usermodehelper_setup - prepare to call a usermode helper
> + * call_usermodehelper_setup_root - prepare to call a usermode helper
>   * @path: path to usermode executable
>   * @argv: arg vector for process
>   * @envp: environment for process
> @@ -513,6 +517,7 @@ static void helper_unlock(void)
>   * @cleanup: a cleanup function
>   * @init: an init function
>   * @data: arbitrary context sensitive data
> + * @root: fs root to swap to before binary execution
>   *
>   * Returns either %NULL on allocation failure, or a subprocess_info
>   * structure.  This should be passed to call_usermodehelper_exec to
> @@ -527,11 +532,11 @@ static void helper_unlock(void)
>   * Function must be runnable in either a process context or the
>   * context in which call_usermodehelper_exec is called.
>   */

It would be best to spell out the need for the caller to hold a
reference in the above kerneldoc comment, since that's what people will
look at when they write new code that calls this.

> -struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
> +struct subprocess_info *call_usermodehelper_setup_root(char *path, char **argv,
>  		char **envp, gfp_t gfp_mask,
>  		int (*init)(struct subprocess_info *info, struct cred *new),
>  		void (*cleanup)(struct subprocess_info *info),
> -		void *data)
> +		void *data, struct path *root)
>  {
>  	struct subprocess_info *sub_info;
>  	sub_info = kzalloc(sizeof(struct subprocess_info), gfp_mask);
> @@ -546,9 +551,22 @@ struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
>  	sub_info->cleanup = cleanup;
>  	sub_info->init = init;
>  	sub_info->data = data;
> +
> +	sub_info->root = root;
>    out:
>  	return sub_info;
>  }
> +EXPORT_SYMBOL(call_usermodehelper_setup_root);
> +

nit: do we really need a new exported helper function here? There
aren't that many callers of call_usermodehelper_setup, so you could
just add the argument and fix up the existing callers.

> +struct subprocess_info *call_usermodehelper_setup(char *path, char **argv,
> +		char **envp, gfp_t gfp_mask,
> +		int (*init)(struct subprocess_info *info, struct cred *new),
> +		void (*cleanup)(struct subprocess_info *info),
> +		void *data)
> +{
> +	return call_usermodehelper_setup_root(path, argv, envp, gfp_mask, init,
> +					      cleanup, data, NULL);
> +}
>  EXPORT_SYMBOL(call_usermodehelper_setup);
>  
>  /**
> @@ -617,7 +635,7 @@ unlock:
>  EXPORT_SYMBOL(call_usermodehelper_exec);
>  
>  /**
> - * call_usermodehelper() - prepare and start a usermode application
> + * call_usermodehelper_root() - prepare and start a usermode application
>   * @path: path to usermode executable
>   * @argv: arg vector for process
>   * @envp: environment for process
> @@ -625,24 +643,33 @@ EXPORT_SYMBOL(call_usermodehelper_exec);
>   *        when UMH_NO_WAIT don't wait at all, but you get no useful error back
>   *        when the program couldn't be exec'ed. This makes it safe to call
>   *        from interrupt context.
> + * @root: fs root to swap to before binary execution
>   *
>   * This function is the equivalent to use call_usermodehelper_setup() and
>   * call_usermodehelper_exec().
>   */

I'd also spell out the need for the caller to hold an extra reference
to @root here.

> -int call_usermodehelper(char *path, char **argv, char **envp, int wait)
> +int call_usermodehelper_root(char *path, char **argv, char **envp, int wait,
> +			     struct path *root)
>  {
>  	struct subprocess_info *info;
>  	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
>  
> -	info = call_usermodehelper_setup(path, argv, envp, gfp_mask,
> -					 NULL, NULL, NULL);
> +	info = call_usermodehelper_setup_root(path, argv, envp, gfp_mask,
> +					      NULL, NULL, NULL, root);
>  	if (info == NULL)
>  		return -ENOMEM;
>  
>  	return call_usermodehelper_exec(info, wait);
>  }
> +EXPORT_SYMBOL(call_usermodehelper_root);
> +
> +int call_usermodehelper(char *path, char **argv, char **envp, int wait)
> +{
> +	return call_usermodehelper_root(path, argv, envp, wait, NULL);
> +}
>  EXPORT_SYMBOL(call_usermodehelper);
>  
> +
>  static int proc_cap_handler(struct ctl_table *table, int write,
>  			 void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
> 

Looks reasonable otherwise, you can add my Acked-by when you fix up the
comments. Nice work...

-- 
Jeff Layton <jlayton@redhat.com>
