Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3EVA5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:57:34 -0400
Received: from ozlabs.org ([203.10.76.45]:57366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab3EVA5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:57:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Lucas De Marchi <lucas.de.marchi@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usermodehelper: kill the sub_info->path[0] check
In-Reply-To: <20130520165559.GA19645@redhat.com>
References: <20130520165559.GA19645@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 22 May 2013 09:10:14 +0930
Message-ID: <87ppwjyk9t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:
> call_usermodehelper_exec() does nothing but returns success if
> path[0] == 0. The only user which needs this strange feature is
> request_module(), it can check modprobe_path[0] itself like other
> users do if they want to detect the "disabled by admin" case.
>
> Kill it. Not only it looks strange, it can confuse other callers.
> And this allows us to revert 264b83c0 "usermodehelper: check
> subprocess_info->path != NULL", do_execve(NULL) is safe.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Nice cleanup.  It was definitely weird...

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.

> ---
>  kernel/kmod.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 8241906..fb32636 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -147,6 +147,9 @@ int __request_module(bool wait, const char *fmt, ...)
>  	 */
>  	WARN_ON_ONCE(wait && current_is_async());
>  
> +	if (!modprobe_path[0])
> +		return 0;
> +
>  	va_start(args, fmt);
>  	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
>  	va_end(args);
> @@ -569,14 +572,6 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>  	int retval = 0;
>  
>  	helper_lock();
> -	if (!sub_info->path) {
> -		retval = -EINVAL;
> -		goto out;
> -	}
> -
> -	if (sub_info->path[0] == '\0')
> -		goto out;
> -
>  	if (!khelper_wq || usermodehelper_disabled) {
>  		retval = -EBUSY;
>  		goto out;
> -- 
> 1.5.5.1
