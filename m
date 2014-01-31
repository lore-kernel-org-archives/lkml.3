Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaBAIGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 03:06:12 -0500
Received: from ozlabs.org ([203.10.76.45]:34989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaBAIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 03:06:09 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dan Carpenter <dan.carpenter@oracle.com>, Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] hw_random: cleanup in hwrng_register()
In-Reply-To: <20140130114943.GB12734@elgon.mountain>
References: <20140130114943.GB12734@elgon.mountain>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 31 Jan 2014 16:18:51 +1030
Message-ID: <87k3dgvgzg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> My static checker complains that:
>
> 	drivers/char/hw_random/core.c:341 hwrng_register()
> 	warn: we tested 'old_rng' before and it was 'false'
>
> The problem is that sometimes we test "if (!old_rng)" and sometimes we
> test "if (must_register_misc)".  The static checker knows they are
> equivalent but a human being reading the code could easily be confused.
>
> I have simplified the code by removing the "must_register_misc" variable
> and I have removed the redundant check on "if (!old_rng)".
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Yeah, clearer too.

Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.

>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index b9495a8c05c6..463382036a01 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -301,7 +301,6 @@ err_misc_dereg:
>  
>  int hwrng_register(struct hwrng *rng)
>  {
> -	int must_register_misc;
>  	int err = -EINVAL;
>  	struct hwrng *old_rng, *tmp;
>  
> @@ -326,7 +325,6 @@ int hwrng_register(struct hwrng *rng)
>  			goto out_unlock;
>  	}
>  
> -	must_register_misc = (current_rng == NULL);
>  	old_rng = current_rng;
>  	if (!old_rng) {
>  		err = hwrng_init(rng);
> @@ -335,13 +333,11 @@ int hwrng_register(struct hwrng *rng)
>  		current_rng = rng;
>  	}
>  	err = 0;
> -	if (must_register_misc) {
> +	if (!old_rng) {
>  		err = register_miscdev();
>  		if (err) {
> -			if (!old_rng) {
> -				hwrng_cleanup(rng);
> -				current_rng = NULL;
> -			}
> +			hwrng_cleanup(rng);
> +			current_rng = NULL;
>  			goto out_unlock;
>  		}
>  	}
