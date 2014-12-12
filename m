Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282AbaLLE0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 23:26:47 -0500
Received: from ozlabs.org ([103.22.144.67]:55058 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933985AbaLLE0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 23:26:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Jani Nikula <jani.nikula@intel.com>,
        Hannes Reinecke <hare@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] param: do not set store func without write perm
In-Reply-To: <20141211222144.GA7070@www.outflux.net>
References: <20141211222144.GA7070@www.outflux.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 12 Dec 2014 13:38:08 +1030
Message-ID: <87r3w5d0pz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> When a module_param is defined without DAC write permissions, it can
> still be changed at runtime and updated. Drivers using a 0444 permission
> may be surprised that these values can still be changed.
>
> For drivers that want to allow updates, any S_IW* flag will set the
> "store" function as before. Drivers without S_IW* flags will have the
> "store" function unset, unforcing a read-only value. Drivers that wish
> neither "store" nor "get" can continue to use "0" for perms to stay out
> of sysfs entirely.

Hmm, fair enough.  The use of the acronym DAC here is a bit weird;
I would have just said:

	/* If no perms, it's not writable even if root chmods it! */
	if ((kp->perm & (S_IWUSR | S_IWGRP | S_IWOTH)) != 0)
		new->attrs[num].mattr.store = param_attr_store;

Applied (with fuzz fixed, since I reworked that code in my tree).

Thanks,
Rusty.

>
> Old behavior:
>   # cd /sys/module/snd/parameters
>   # ls -l
>   total 0
>   -r--r--r-- 1 root root 4096 Dec 11 13:55 cards_limit
>   -r--r--r-- 1 root root 4096 Dec 11 13:55 major
>   -r--r--r-- 1 root root 4096 Dec 11 13:55 slots
>   # cat major
>   116
>   # echo -1 > major
>   -bash: major: Permission denied
>   # chmod u+w major
>   # echo -1 > major
>   # cat major
>   -1
>
> New behavior:
>   ...
>   # chmod u+w major
>   # echo -1 > major
>   -bash: echo: write error: Input/output error
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/params.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/params.c b/kernel/params.c
> index db97b791390f..fd50ce9f1bbf 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -647,7 +647,9 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>  	sysfs_attr_init(&new->attrs[num].mattr.attr);
>  	new->attrs[num].param = kp;
>  	new->attrs[num].mattr.show = param_attr_show;
> -	new->attrs[num].mattr.store = param_attr_store;
> +	/* Do not allow runtime DAC changes to make param writable. */
> +	if ((kp->perm & (S_IWUSR | S_IWGRP | S_IWOTH)) != 0)
> +		new->attrs[num].mattr.store = param_attr_store;
>  	new->attrs[num].mattr.attr.name = (char *)name;
>  	new->attrs[num].mattr.attr.mode = kp->perm;
>  	new->num = num+1;
> -- 
> 1.9.1
>
>
> -- 
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
