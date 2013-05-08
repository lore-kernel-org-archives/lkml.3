Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab3EHC4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:56:06 -0400
Received: from ozlabs.org ([203.10.76.45]:45251 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab3EHC4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:56:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module.c: for looping, need use 'goto' instead of 'break' to jump out in time
In-Reply-To: <51889EE4.4070504@asianux.com>
References: <51889EE4.4070504@asianux.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 08 May 2013 09:59:06 +0930
Message-ID: <87ip2unwkt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
> In the 'for' looping, when error occurs, the 'break' only jump out of
> 'switch', and still in 'for' looping.  If error occurs multiple times,
> the original error value will be overwrite.
>
> Currently, that will not cause issue, but still better to improve it,
> so that let it return the first real error code in time.

We choose to print all the problems, rather than just one.  I don't
really mind though.

It we want this patch, it would be neater to just 'return -ENOEXEC'
and 'return PTR_ERR(ksym) ?: -ENOENT'.

Cheers,
Rusty.

> The related commit: "1da177e Linux-2.6.12-rc"
>
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/module.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index b049939..7e012ff 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1977,7 +1977,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			printk("%s: please compile with -fno-common\n",
>  			       mod->name);
>  			ret = -ENOEXEC;
> -			break;
> +			goto tail;
>  
>  		case SHN_ABS:
>  			/* Don't need to do anything */
> @@ -2000,7 +2000,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			printk(KERN_WARNING "%s: Unknown symbol %s (err %li)\n",
>  			       mod->name, name, PTR_ERR(ksym));
>  			ret = PTR_ERR(ksym) ?: -ENOENT;
> -			break;
> +			goto tail;
>  
>  		default:
>  			/* Divert to percpu allocation if a percpu var. */
> @@ -2013,6 +2013,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  		}
>  	}
>  
> +tail:
>  	return ret;
>  }
>  
> -- 
> 1.7.7.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
