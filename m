Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436Ab3GaUNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab3GaUNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:13:23 -0400
Date: Wed, 31 Jul 2013 22:08:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zach@zachsthings.com>, Zach Levis <zml@linux.vnet.ibm.com>,
        Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + fs-binfmts-better-handling-of-binfmt-loops.patch added to
	-mm tree
Message-ID: <20130731200805.GA29678@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Zach Levis <zml@linux.vnet.ibm.com>
> Subject: fs/binfmts: better handling of binfmt loops
>
> With these changes, when a binfmt loop is encountered, the ELOOP will
> propagate back to the 0 depth.  At this point the argv and argc values
> will be reset to what they were originally and an attempt is made to
> continue with the following binfmt handlers.

I must admit, I do not really understand why do we want to recover
after pr_err(). Perhaps the changelog could say a bit more.

> --- a/fs/exec.c~fs-binfmts-better-handling-of-binfmt-loops
> +++ a/fs/exec.c
> @@ -1403,13 +1403,40 @@ int search_binary_handler(struct linux_b
>  			if (!try_module_get(fmt->module))
>  				continue;
>  			read_unlock(&binfmt_lock);
> +			bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
> +			bprm->previous_binfmts[0] = fmt;
> +
>  			bprm->recursion_depth = depth + 1;
>  			retval = fn(bprm);
>  			bprm->recursion_depth = depth;
> +			if (retval == -ELOOP && depth == 0) { /* cur, previous */
> +				pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
> +						bprm->previous_binfmts[0]->name,
> +						bprm->previous_binfmts[1]->name,
> +						bprm->filename,
> +						fmt->name);
> +
> +				/* Put argv back in its place */
> +				while (bprm->argc > 0) {
> +					retval = remove_arg_zero(bprm);
> +					if (retval)
> +						return retval;
> +				}

But why do we need this?

Afaics we only need to restore bprm->p to the old value before the
1st do_execve_common()->copy_strings(argv) and nothing else, no ?
free_bprm()->free_arg_pages() will do the necessary cleanup in any
case.

> +
> +				copy_strings(bprm->argc_orig, *((struct user_arg_ptr *) bprm->argv_orig), bprm);

Perhaps it would be more clean to add "struct user_arg_ptr;"
into binfmts.h and avoid the typecast.

And I do not think we should ignore the possible error from
copy_strings(). Even if we know that it succeeded before, another
thread can, say, unmap this memory in between.

> +				bprm->argc = bprm->argc_orig;

Or we can simply do count() again. compared to copy_strings() this
is cheap.

Oleg.

