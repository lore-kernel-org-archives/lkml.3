Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934957Ab3DHGdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:33:35 -0400
Received: from ozlabs.org ([203.10.76.45]:46497 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934944Ab3DHGdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:33:33 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel\@vger.kernel.org \>\> \"linux-kernel\@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: module: strncpy issue, using strlcpy instead of strncpy
In-Reply-To: <51615AB0.9060502@asianux.com>
References: <51615AB0.9060502@asianux.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 08 Apr 2013 15:00:44 +0930
Message-ID: <87r4ila8sb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:
>   ownername and namebuf are all NUL terminated string.
>
>   need always let them ended by '\0'.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/module.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 3c2c72d..597efd8 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1283,7 +1283,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
>  
>  getname:
>  	/* We must make copy under the lock if we failed to get ref. */
> -	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
> +	strlcpy(ownername, module_name(owner), MODULE_NAME_LEN);

This should just be strcpy().

>  unlock:
>  	mutex_unlock(&module_mutex);
>  	return sym;
> @@ -3464,7 +3464,7 @@ const char *module_address_lookup(unsigned long addr,
>  	}
>  	/* Make a copy in here where it's safe */
>  	if (ret) {
> -		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
> +		strlcpy(namebuf, ret, KSYM_NAME_LEN);

This isn't a bug, because the caller (kallsyms_lookup) puts a NUL in
ret[KSYM_NAME_LEN].

However, kallsyms_lookup also calls kallsyms_expand_symbol, which
doesn't stop at KSYM_NAME_LEN, so if a name was longer than that we'd
have a real bug.

Would you like to take a look at that, too?

Thanks,
Rusty.
