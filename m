Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaJPJte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:49:34 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40534 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaJPJtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:49:32 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arjun Sreedharan <arjun024@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: krealloc in kernel/params.c
Organization: D03
References: <87mw8y8jq7.fsf@rasmusvillemoes.dk>
	<87r3yaapyf.fsf@rustcorp.com.au>
X-Hashcash: 1:20:141016:arjun024@gmail.com::iQ1cssQTKdCFV5dV:00000000000000000000000000000000000000000001HmB
X-Hashcash: 1:20:141016:akpm@linux-foundation.org::NhlmlAwxN4sPzOf1:0000000000000000000000000000000000003W6J
X-Hashcash: 1:20:141016:linux-kernel@vger.kernel.org::jHagWWlQZjoB4XB6:00000000000000000000000000000000059yZ
X-Hashcash: 1:20:141016:geert@linux-m68k.org::YglDqRTnvJCswehF:000000000000000000000000000000000000000004a1q
X-Hashcash: 1:20:141016:rusty@rustcorp.com.au::zkCHp7URyAXS5NSD:00000000000000000000000000000000000000008SZJ
X-Hashcash: 1:20:141016:david.woodhouse@intel.com::jRJbBk3xIrQFUwGk:000000000000000000000000000000000000DOuF
Date: Thu, 16 Oct 2014 11:49:28 +0200
In-Reply-To: <87r3yaapyf.fsf@rustcorp.com.au> (Rusty Russell's message of
	"Wed, 15 Oct 2014 15:29:04 +1030")
Message-ID: <87fveo1h07.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15 2014, Rusty Russell <rusty@rustcorp.com.au> wrote:

> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
>> It is likely that I'm just missing something trivial, but I have
>> a hard time understanding 63662139e ("params: Fix potential
>> memory leak in add_sysfs_param()").
>
> Yes, it was a bad commit, and we've been discussing it, see:
>
> [PATCH] params: fix potential memory leak in add_sysfs_param()
>
> The only error case we are about is when add_sysfs_param()
> is called from module_param_sysfs_setup(): the in-kernel cases
> at boot time are assumed not to fail.
>
> That call should invoke free_module_param_attrs() when it fails,
> rather than relying on add_sysfs_param() to clean up.
>
> Don't patch bad code - rewrite it.  (Kernigan and Plauger)
>
> How's this?
>
> params: cleanup sysfs allocation
>
> commit 63662139e519ce06090b2759cf4a1d291b9cc0e2 attempted to patch a
> leak (which would only happen on OOM, ie. never), but it didn't quite
> work.
>
> This rewrites the code to be as simple as possible.  add_sysfs_param()
> adds a parameter.  If it fails, it's the caller's responsibility to
> clean up the parameters which already exist.
>
> The kzalloc-then-always-krealloc pattern is perhaps overly simplistic,
> but this code has clearly confused people.  It worked on me...
>

I think kzalloc immediately followed by kreallocing the returned value
is rather ugly. Other than that:

> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> diff --git a/kernel/params.c b/kernel/params.c
> index db97b791390f..5b8005d01dfc 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -603,68 +603,58 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>  				     const struct kernel_param *kp,
>  				     const char *name)
>  {
> -	struct module_param_attrs *new;
> -	struct attribute **attrs;
> -	int err, num;
> +	struct module_param_attrs *new_mp;
> +	struct attribute **new_attrs;
> +	unsigned int i;
>  
>  	/* We don't bother calling this with invisible parameters. */
>  	BUG_ON(!kp->perm);
>  
>  	if (!mk->mp) {
> -		num = 0;
> -		attrs = NULL;
> -	} else {
> -		num = mk->mp->num;
> -		attrs = mk->mp->grp.attrs;
> +		/* First allocation. */
> +		mk->mp = kzalloc(sizeof(*mk->mp), GFP_KERNEL);
> +		if (!mk->mp)
> +			return -ENOMEM;

free_module_param_attrs does not check mk->mp for being NULL before
kfree'ing mk->mp->grp.attrs, so this will oops.


Rasmus
