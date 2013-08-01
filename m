Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab3HAPKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab3HAPKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:10:53 -0400
Date: Thu, 1 Aug 2013 17:05:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zach@zachsthings.com>, Zach Levis <zml@linux.vnet.ibm.com>,
        Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + fs-binfmts-better-handling-of-binfmt-loops.patch added to
	-mm tree
Message-ID: <20130801150532.GA15349@redhat.com>
References: <20130731200805.GA29678@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731200805.GA29678@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Oleg Nesterov wrote:
>
> > From: Zach Levis <zml@linux.vnet.ibm.com>
> > Subject: fs/binfmts: better handling of binfmt loops
> >
> > With these changes, when a binfmt loop is encountered, the ELOOP will
> > propagate back to the 0 depth.  At this point the argv and argc values
> > will be reset to what they were originally and an attempt is made to
> > continue with the following binfmt handlers.
>
> I must admit, I do not really understand why do we want to recover
> after pr_err(). Perhaps the changelog could say a bit more.

And still can't. Probably I missed something, but it seems that
this tries to "fix" the wrong /proc/sys/fs/binfmt_misc/register...

> > --- a/fs/exec.c~fs-binfmts-better-handling-of-binfmt-loops
> > +++ a/fs/exec.c
> > @@ -1403,13 +1403,40 @@ int search_binary_handler(struct linux_b
> >  			if (!try_module_get(fmt->module))
> >  				continue;
> >  			read_unlock(&binfmt_lock);
> > +			bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
> > +			bprm->previous_binfmts[0] = fmt;
> > +
> >  			bprm->recursion_depth = depth + 1;
> >  			retval = fn(bprm);
> >  			bprm->recursion_depth = depth;
> > +			if (retval == -ELOOP && depth == 0) { /* cur, previous */
> > +				pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
> > +						bprm->previous_binfmts[0]->name,
> > +						bprm->previous_binfmts[1]->name,
> > +						bprm->filename,
> > +						fmt->name);
> > +
> > +				/* Put argv back in its place */
> > +				while (bprm->argc > 0) {
> > +					retval = remove_arg_zero(bprm);
> > +					if (retval)
> > +						return retval;
> > +				}
>
> But why do we need this?
>
> Afaics we only need to restore bprm->p to the old value before the
> 1st do_execve_common()->copy_strings(argv) and nothing else, no ?
> free_bprm()->free_arg_pages() will do the necessary cleanup in any
> case.
>
> > +
> > +				copy_strings(bprm->argc_orig, *((struct user_arg_ptr *) bprm->argv_orig), bprm);
>
> Perhaps it would be more clean to add "struct user_arg_ptr;"
> into binfmts.h and avoid the typecast.
>
> And I do not think we should ignore the possible error from
> copy_strings(). Even if we know that it succeeded before, another
> thread can, say, unmap this memory in between.

And since we do copy_strings() again we probably need acct_arg_size()
after remove_arg_zero() loop, although this is not that important.

And with this patch "depth == 0" check(s) look even worse, imho we
need to cleanup this code first. And proc_exec_connector() looks
simply wrong. I'll try to make a patch.

But once again, I can be easily wrong, so please correct me.

Oleg.

