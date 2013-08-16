Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3HPNVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 09:21:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab3HPNUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 09:20:46 -0400
Date: Fri, 16 Aug 2013 15:15:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zach Levis <zach@zachsthings.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, keescook@chromium.org,
        cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com
Subject: Re: [PATCH v5 2/3] fs/binfmts: Better handling of binfmt loops
Message-ID: <20130816131501.GA21774@redhat.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1376583641-10298-3-git-send-email-zach@zachsthings.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376583641-10298-3-git-send-email-zach@zachsthings.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Zach Levis wrote:
>
> +static bool update_prev_binfmts(struct linux_binprm *bprm,
> +				struct linux_binfmt *cur_fmt)
> +{
> +
> +	if (!try_module_get(cur_fmt->module))
> +		return false;
> +	if (bprm->previous_binfmts[1])
> +		put_binfmt(bprm->previous_binfmts[1]);
> +	bprm->previous_binfmts[1] = bprm->previous_binfmts[0];
> +	bprm->previous_binfmts[0] = cur_fmt;
> +	return true;
> +}

Still can't understand the logic behind this function and its usage.
IOW, what ->previous_binfmts[] actually means? previous_binfmts[1]
could be a caller or the previous fmt which was called at the same
depth.

> @@ -1393,15 +1498,38 @@ int search_binary_handler(struct linux_binprm *bprm)
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
> +		if (retval == -ELOOP
> +		    && bprm->recursion_depth == 0) { /* cur, previous */
> +			pr_err("Too much recursion with binfmts (0:%s, -1:%s) in file %s, skipping (base %s).\n",
> +				binfmt_name(bprm->previous_binfmts[0]),
> +				binfmt_name(bprm->previous_binfmts[1]),
> +				bprm->filename,
> +				fmt->name);
> +
> +			free_arg_pages(bprm);
> +			if (bprm->interp != bprm->filename)
> +				kfree(bprm->interp);

this doesn't look safe too, kfree(interp) can be called twice.

and once again, we should not lose -ELOOP as an error code if the
next fmt returns ENOEXEC.

But the main problem (in my opinion) is that this doesn't worth the
trouble, sorry.

Oleg.

