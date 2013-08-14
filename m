Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab3HNR5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 13:57:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab3HNR47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 13:56:59 -0400
Date: Wed, 14 Aug 2013 19:50:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zach@zachsthings.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, keescook@chromium.org,
        cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] fs/binfmts: Better handling of binfmt loops
Message-ID: <20130814175014.GA1080@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1376497898-18619-3-git-send-email-zach@zachsthings.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376497898-18619-3-git-send-email-zach@zachsthings.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Zach Levis wrote:
>
> Example: a qemu is configured to run 64-bit ELFs on an otherwise 32-bit
> system. The system's owner switches to running with 64-bit executables,
> but forgets to disable the binfmt_misc option that redirects 64bit ELFs
> to qemu. Since the qemu executable is a 64-bit ELF now, binfmt_misc
> keeps on matching it with the qemu rule, preventing the execution of any
> 64-bit binary.

Honestly, I dislike this version even more, sorry. The patch becomes
much more complex, and and it is still not clear to me why do we want
these complications.

> My (rough, but functional) test scripts for this issue are available at:
>     https://gist.github.com/zml2008/6075418

Well, suppose that someone tries to read this changelog in 2014 to
understand the code. Are you sure this link will be still alive?

It would be better to have everything in the changelog, if possible.

> +static void put_binfmts(struct linux_binprm *bprm, struct linux_binfmt *cur_fmt)
> +{
> +	if (bprm->previous_binfmts[1])
> +		put_binfmt(bprm->previous_binfmts[1]);
> +	if (bprm->previous_binfmts[0])
> +		put_binfmt(bprm->previous_binfmts[0]);
> +	if (cur_fmt)
> +		put_binfmt(cur_fmt);
> +}

I didn't actually read this patch, but at first glance this doesn't look
right. Just suppose that ->load_binary() succeeds at depth = N, this will
be called N times.

In fact I am not sure update_prev_binfmts() is right too, but probably
I do not understand the logic. Just suppose that each ->load_binary()
simply returns ENOEXEC at some depth. Do we really want to replace
previous_binfmts[1] every time?

> @@ -1393,18 +1494,44 @@ int search_binary_handler(struct linux_binprm *bprm)
>  	list_for_each_entry(fmt, &formats, lh) {
>  		if (!try_module_get(fmt->module))
>  			continue;
> +
> +		if (!update_prev_binfmts(bprm, fmt))
> +			continue;
> +
>  		read_unlock(&binfmt_lock);
> +
>  		bprm->recursion_depth++;
>  		retval = fmt->load_binary(bprm);
>  		bprm->recursion_depth--;
> -		if (retval >= 0 || retval != -ENOEXEC ||
> -		    bprm->mm == NULL || bprm->file == NULL) {
> -			put_binfmt(fmt);
> +		if (retval == -ELOOP
> +			&& bprm->recursion_depth == 0) { /* cur, previous */
> +			pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
> +				binfmt_name(bprm->previous_binfmts[0]),
> +				binfmt_name(bprm->previous_binfmts[1]),
> +				bprm->filename,
> +				fmt->name);
> +
> +			free_arg_pages(bprm);
> +			if (bprm->interp != bprm->filename)
> +				kfree(bprm->interp);
> +			bprm_close_file(bprm);
> +			retval = init_bprm(bprm, bprm->filename,
> +					   bprm->argv_orig, bprm->envp_orig);
> +			if (retval < 0) {
> +				put_binfmts(bprm, fmt);
> +				return retval;
> +			}

I still think that if we want this, it would be better to move this hack
into load_misc_binary(). Only linux_binprm itself can know it is desirable
(or even safe) to recover/restart in general.

And btw, if we want this, then why we only do this if recursion_depth == 0?
Just condider '#!/path-to-the-binary-which-wants-this-patch".

And again, the patch (afaics) translates -ELOOP into -ENOEXEC on failure,
not good.

Oleg.

