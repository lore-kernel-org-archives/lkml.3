Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbbATGkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 01:40:32 -0500
Received: from ozlabs.org ([103.22.144.67]:55353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbATGka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 01:40:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Wang\, Yalin" <Yalin.Wang@sonymobile.com>,
        "'akpm\@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'jani.nikula\@intel.com'" <jani.nikula@intel.com>,
        "'hch\@infradead.org'" <hch@infradead.org>,
        "'hare\@suse.de'" <hare@suse.de>,
        "'keescook\@chromium.org'" <keescook@chromium.org>,
        "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] export module parameters even the permission is zero
In-Reply-To: <35FD53F367049845BC99AC72306C23D103EDAF89E1A3@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103EDAF89E1A3@CNBJMBX05.corpusers.net>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Jan 2015 17:02:39 +1030
Message-ID: <87lhkyarnc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Wang, Yalin" <Yalin.Wang@sonymobile.com> writes:
> This patch make sure to export module parameters even the permission
> is zero, this is useful for some platforms like Android,
> the init process can change the parameter mode/owner by
> chmod/chown during bootup
>
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>

Hi!

        Unfortunately, this won't work.  Various parts of the code
assume that 0 permissions means "cannot be changed or read", so this
change would introduce many bugs (eg. the parameter could be
__initdata).

Since these are owned by root at boot, changing mode and owner should
still work.  However, you can't make a read-only field writable and
expect it to work.

Hope that helps,
Rusty.



> ---
>  kernel/params.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/kernel/params.c b/kernel/params.c
> index bd65d136..aa80c04 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -607,9 +607,6 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>  	struct attribute **new_attrs;
>  	unsigned int i;
>  
> -	/* We don't bother calling this with invisible parameters. */
> -	BUG_ON(!kp->perm);
> -
>  	if (!mk->mp) {
>  		/* First allocation. */
>  		mk->mp = kzalloc(sizeof(*mk->mp), GFP_KERNEL);
> @@ -812,9 +809,6 @@ static void __init param_sysfs_builtin(void)
>  	for (kp = __start___param; kp < __stop___param; kp++) {
>  		char *dot;
>  
> -		if (kp->perm == 0)
> -			continue;
> -
>  		dot = strchr(kp->name, '.');
>  		if (!dot) {
>  			/* This happens for core_param() */
> -- 
> 2.1.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
