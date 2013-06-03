Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3FCHPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 03:15:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59706 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3FCHPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 03:15:49 -0400
Date: Mon, 3 Jun 2013 09:15:26 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Meyer <thomas@m3y3r.de>, mst@redhat.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
Message-ID: <20130603071526.GA5483@pengutronix.de>
References: <1370080565.29224.29.camel@localhost.localdomain>
 <87mwr8sz9g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mwr8sz9g.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty,

[added akpm to Cc: who took the patch back then and Julia for the
coccinelle part below]

On Mon, Jun 03, 2013 at 11:59:15AM +0930, Rusty Russell wrote:
> 
> Back in 2011, Uwe Kleine-König added the nonsensically-named
> PTR_RET(), providing a means to avoid if() statements in code (commit 
> fa9ee9c4b9).
> 
> Instead, just make PTR_ERR() return 0 if the pointer isn't an error
> value.  This is harmless, since PTR_ERR() should have never been
> passed a non-error value.  And GCC is usually smart enough to remove
> the extra test if IS_ERR() has already been called.
I wonder in which situations gcc fails to be smart enough. Did you check
this?

> My vmlinux text increased by 300 bytes:
> 
> 	   text	   data	    bss	    dec	    hex	filename
> 	6029452	 491628	2576384	9097464	 8ad0f8	vmlinux
> 	6029721	 491628	2576384	9097733	 8ad205	vmlinux.PTR_ERR
> 
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Thomas Meyer <thomas@m3y3r.de>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/include/linux/err.h b/include/linux/err.h
> index f2edce2..621d859 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -24,14 +24,16 @@ static inline void * __must_check ERR_PTR(long error)
>  	return (void *) error;
>  }
>  
> -static inline long __must_check PTR_ERR(const void *ptr)
> +static inline long __must_check IS_ERR(const void *ptr)
>  {
> -	return (long) ptr;
> +	return IS_ERR_VALUE((unsigned long)ptr);
>  }
>  
> -static inline long __must_check IS_ERR(const void *ptr)
> +static inline long __must_check PTR_ERR(const void *ptr)
>  {
> -	return IS_ERR_VALUE((unsigned long)ptr);
> +	if (IS_ERR(ptr))
> +		return (long) ptr;
> +	return 0;
>  }
>  
>  static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
> @@ -52,14 +54,7 @@ static inline void * __must_check ERR_CAST(const void *ptr)
>  	return (void *) ptr;
>  }
>  
> -static inline int __must_check PTR_RET(const void *ptr)
> -{
> -	if (IS_ERR(ptr))
> -		return PTR_ERR(ptr);
> -	else
> -		return 0;
> -}
> -
> +#define PTR_RET	PTR_ERR
I'd add a comment here that PTR_RET shouldn't be used anymore.

>  #endif
>  
>  #endif /* _LINUX_ERR_H */
> 

Is it worth to apply the same change to tools/virtio/linux/err.h to
minimize the chance for later surprises?
Also scripts/coccinelle/api/ptr_ret.cocci starts giving false warnings.

Other than that I think the change is fine.

Best regards
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
