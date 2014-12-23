Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaLZAbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:31:34 -0500
Received: from ozlabs.org ([103.22.144.67]:54293 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLZAbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:31:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Amos Kong <akong@redhat.com>, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Subject: Re: [PATCH 3/5] hwrng: core - Do not register device opportunistically
In-Reply-To: <E1Y3ICh-0007d7-SM@gondolin.me.apana.org.au>
References: <20141223053909.GA28001@gondor.apana.org.au> <E1Y3ICh-0007d7-SM@gondolin.me.apana.org.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 24 Dec 2014 09:59:41 +1030
Message-ID: <87mw6egd22.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> Currently we only register the device when a valid RNG is added.
> However the way it's done is buggy because we test whether there
> is a current RNG to determine whether we need to register.  As
> the current RNG may be missing due to a reinitialisation error
> this can lead to a reregistration of the device.
>
> As the device already has to handle a NULL current RNG anyway,
> let's just register the device always and remove the complexity.

Does this break userspace by creating a device which will just return
-ENODEV on read?  Sure, callers *should* handle it...

I far prefer this (simpler) model, though.

Thanks,
Rusty.

>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>
>  drivers/char/hw_random/core.c |   23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 42827fd..1d342f0 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -372,14 +372,14 @@ static DEVICE_ATTR(rng_available, S_IRUGO,
>  		   NULL);
>  
>  
> -static void unregister_miscdev(void)
> +static void __exit unregister_miscdev(void)
>  {
>  	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
>  	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
>  	misc_deregister(&rng_miscdev);
>  }
>  
> -static int register_miscdev(void)
> +static int __init register_miscdev(void)
>  {
>  	int err;
>  
> @@ -484,12 +484,6 @@ int hwrng_register(struct hwrng *rng)
>  		if (err)
>  			goto out_unlock;
>  		set_current_rng(rng);
> -
> -		err = register_miscdev();
> -		if (err) {
> -			drop_current_rng();
> -			goto out_unlock;
> -		}
>  	}
>  	list_add_tail(&rng->list, &rng_list);
>  
> @@ -530,7 +524,6 @@ void hwrng_unregister(struct hwrng *rng)
>  
>  	if (list_empty(&rng_list)) {
>  		mutex_unlock(&rng_mutex);
> -		unregister_miscdev();
>  		if (hwrng_fill)
>  			kthread_stop(hwrng_fill);
>  	} else
> @@ -540,16 +533,24 @@ void hwrng_unregister(struct hwrng *rng)
>  }
>  EXPORT_SYMBOL_GPL(hwrng_unregister);
>  
> -static void __exit hwrng_exit(void)
> +static int __init hwrng_modinit(void)
> +{
> +	return register_miscdev();
> +}
> +
> +static void __exit hwrng_modexit(void)
>  {
>  	mutex_lock(&rng_mutex);
>  	BUG_ON(current_rng);
>  	kfree(rng_buffer);
>  	kfree(rng_fillbuf);
>  	mutex_unlock(&rng_mutex);
> +
> +	unregister_miscdev();
>  }
>  
> -module_exit(hwrng_exit);
> +module_init(hwrng_modinit);
> +module_exit(hwrng_modexit);
>  
>  MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver");
>  MODULE_LICENSE("GPL");
