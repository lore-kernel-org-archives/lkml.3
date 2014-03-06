Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaCFMzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:55:40 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16019 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaCFMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:55:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+dJxRM30CsqLrszHelT2QKVOD4C7FNF3c=
X-DKIM: OpenDKIM Filter v2.0.1 titan DF59553B882
Date: Thu, 6 Mar 2014 07:55:33 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        linux-crypto@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND 3] hwrng: add randomness to system from rng
 sources
Message-ID: <20140306125533.GA1872@titan.lakedaemon.net>
References: <20140303235148.GA7601@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303235148.GA7601@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 03:51:48PM -0800, Kees Cook wrote:
> When bringing a new RNG source online, it seems like it would make sense
> to use some of its bytes to make the system entropy pool more random,
> as done with all sorts of other devices that contain per-device or
> per-boot differences.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/char/hw_random/core.c |    7 +++++++
>  1 file changed, 7 insertions(+)

fwiw,

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.

> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index a0f7724852eb..6e5bb68a708c 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -41,6 +41,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
> +#include <linux/random.h>
>  #include <asm/uaccess.h>
>  
>  
> @@ -305,6 +306,8 @@ int hwrng_register(struct hwrng *rng)
>  	int must_register_misc;
>  	int err = -EINVAL;
>  	struct hwrng *old_rng, *tmp;
> +	unsigned char bytes[16];
> +	int bytes_read;
>  
>  	if (rng->name == NULL ||
>  	    (rng->data_read == NULL && rng->read == NULL))
> @@ -348,6 +351,10 @@ int hwrng_register(struct hwrng *rng)
>  	}
>  	INIT_LIST_HEAD(&rng->list);
>  	list_add_tail(&rng->list, &rng_list);
> +
> +	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
> +	if (bytes_read > 0)
> +		add_device_randomness(bytes, bytes_read);
>  out_unlock:
>  	mutex_unlock(&rng_mutex);
>  out:
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
