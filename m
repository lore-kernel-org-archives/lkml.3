Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840AbaLOTDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:03:16 -0500
Received: from ozlabs.org ([103.22.144.67]:37289 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaLOTDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:03:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: George Spelvin <linux@horizon.com>, akpm@linux-foundation.org,
        linux@horizon.com
Cc: linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH v2] VERIFY_OCTAL_PERMISSIONS: Move to <linux/sysfs.h> where it belongs
In-Reply-To: <20141206032310.27123.qmail@ns.horizon.com>
References: <20141206032310.27123.qmail@ns.horizon.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 15 Dec 2014 14:26:15 +1030
Message-ID: <87egs1d0rk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Spelvin <linux@horizon.com> writes:
> It's the only user of <linux/bug.h> in kernel.h, so that reduces
> the compile-time cost of #include <linux/kernel.h>
>
> Only one user has to change: <linux/moduleparam.h>.  The <linux/types.h>
> there is needed for one function prototype that passes s16 parameters.
> My first reaction is to wonder if that can be gotten rid of, too.
>
> Some other extraneous header files pruned while I was at it.
> Tested with allyesconfig & allmodconfig on x86-64, just to
> be sure.
>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: George Spelvin <linux@horizon.com>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.


> ---
> Look, even more header pruning.
>
>  include/linux/kernel.h      | 10 ----------
>  include/linux/moduleparam.h |  4 ++--
>  include/linux/sysfs.h       | 15 ++++++++++++---
>  3 files changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3d770f55..07080aa2 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -804,14 +804,4 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
>  # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
>  #endif
>  
> -/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
> -#define VERIFY_OCTAL_PERMISSIONS(perms)					\
> -	(BUILD_BUG_ON_ZERO((perms) < 0) +				\
> -	 BUILD_BUG_ON_ZERO((perms) > 0777) +				\
> -	 /* User perms >= group perms >= other perms */			\
> -	 BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
> -	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)) +	\
> -	 /* Other writable?  Generally considered a bad idea. */	\
> -	 BUILD_BUG_ON_ZERO((perms) & 2) +				\
> -	 (perms))
>  #endif
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 1c9effa2..974097df 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -1,9 +1,9 @@
>  #ifndef _LINUX_MODULE_PARAMS_H
>  #define _LINUX_MODULE_PARAMS_H
>  /* (C) Copyright 2001, 2002 Rusty Russell IBM Corporation */
> -#include <linux/init.h>
>  #include <linux/stringify.h>
> -#include <linux/kernel.h>
> +#include <linux/sysfs.h>
> +#include <linux/types.h>
>  
>  /* You can override this manually, but generally this should match the
>     module name. */
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index f97d0dbb..3562f331 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -14,12 +14,10 @@
>  
>  #include <linux/kernfs.h>
>  #include <linux/compiler.h>
> -#include <linux/errno.h>
> -#include <linux/list.h>
>  #include <linux/lockdep.h>
>  #include <linux/kobject_ns.h>
>  #include <linux/stat.h>
> -#include <linux/atomic.h>
> +#include <linux/bug.h>
>  
>  struct kobject;
>  struct module;
> @@ -70,6 +68,17 @@ struct attribute_group {
>   * for examples..
>   */
>  
> +/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
> +#define VERIFY_OCTAL_PERMISSIONS(perms)					\
> +	(BUILD_BUG_ON_ZERO((perms) < 0) +				\
> +	 BUILD_BUG_ON_ZERO((perms) > 0777) +				\
> +	 /* User perms >= group perms >= other perms */			\
> +	 BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
> +	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)) +	\
> +	 /* Other writable?  Generally considered a bad idea. */	\
> +	 BUILD_BUG_ON_ZERO((perms) & 2) +				\
> +	 (perms))
> +
>  #define __ATTR(_name, _mode, _show, _store) {				\
>  	.attr = {.name = __stringify(_name),				\
>  		 .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },		\
> -- 
> 2.1.3
