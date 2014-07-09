Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaGIQSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:18:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22878 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaGIQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:18:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ewYR1FnORQspEmZw8Gee1NzMQXlIRHcE=
X-DKIM: OpenDKIM Filter v2.0.1 titan D66CB5A6BD4
Date: Wed, 9 Jul 2014 12:18:36 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, herbert@gondor.apana.org.au,
        keescook@chromium.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio: rng: ensure reads happen after
 successful probe
Message-ID: <20140709161836.GQ13433@titan.lakedaemon.net>
References: <cover.1404538109.git.amit.shah@redhat.com>
 <f64852e0dd8a439193db4c7da1d3022d029cc85d.1404538109.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f64852e0dd8a439193db4c7da1d3022d029cc85d.1404538109.git.amit.shah@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2014 at 11:04:53AM +0530, Amit Shah wrote:
> The hwrng core asks for random data in the hwrng_register() call itself
> from commit d9e7972619.  This doesn't play well with virtio -- the
> DRIVER_OK bit is only set by virtio core on a successful probe, and
> we're not yet out of our probe routine when this call is made.  This
> causes the host to not acknowledge any requests we put in the virtqueue,
> and the insmod or kernel boot process just waits for data to arrive from
> the host, which never happens.
> 
> CC: Kees Cook <keescook@chromium.org>
> CC: Jason Cooper <jason@lakedaemon.net>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: <stable@vger.kernel.org> # For v3.15+
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/char/hw_random/core.c       |  6 ++++++
>  drivers/char/hw_random/virtio-rng.c | 10 ++++++++++
>  2 files changed, 16 insertions(+)

Yeah, I don't think there's any viable way to get random data out of
virtio-rng at probe time...  :-(

Reviewed-by: Jason Cooper <jason@lakedaemon.net>

> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index df95e2f..50f5b76 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -68,6 +68,12 @@ static void add_early_randomness(struct hwrng *rng)
>  	unsigned char bytes[16];
>  	int bytes_read;
>  
> +	/*
> +	 * Currently only virtio-rng cannot return data during device
> +	 * probe, and that's handled in virtio-rng.c itself.  If there
> +	 * are more such devices, this call to rng_get_data can be
> +	 * made conditional here instead of doing it per-device.
> +	 */
>  	bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
>  	if (bytes_read > 0)
>  		add_device_randomness(bytes, bytes_read);
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index f3e7150..157f27c 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -38,6 +38,8 @@ struct virtrng_info {
>  	int index;
>  };
>  
> +bool probe_done;
> +
>  static void random_recv_done(struct virtqueue *vq)
>  {
>  	struct virtrng_info *vi = vq->vdev->priv;
> @@ -67,6 +69,13 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
>  	int ret;
>  	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
>  
> +	/*
> +	 * Don't ask host for data till we're setup.  This call can
> +	 * happen during hwrng_register(), after commit d9e7972619.

nit: There's no need to reference the commit in the comment, you already
mention it in the commit log.

thx,

Jason.

> +	 */
> +	if (unlikely(!probe_done))
> +		return 0;
> +
>  	if (!vi->busy) {
>  		vi->busy = true;
>  		init_completion(&vi->have_data);
> @@ -137,6 +146,7 @@ static int probe_common(struct virtio_device *vdev)
>  		return err;
>  	}
>  
> +	probe_done = true;
>  	return 0;
>  }
>  
> -- 
> 1.9.3
> 
