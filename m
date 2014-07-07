Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbaGGEik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:38:40 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:55125 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaGGEih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <f64852e0dd8a439193db4c7da1d3022d029cc85d.1404538109.git.amit.shah@redhat.com>
References: <cover.1404538109.git.amit.shah@redhat.com>
	<f64852e0dd8a439193db4c7da1d3022d029cc85d.1404538109.git.amit.shah@redhat.com>
Date: Sun, 6 Jul 2014 21:38:36 -0700
X-Google-Sender-Auth: 1lfi231t3yj0pjsGfRJMGaGQBnM
Message-ID: <CAGXu5jK1wL9DCnH0RcqhantcCvyJhwZfkw+_L7VQi8wfY2Nt_g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] virtio: rng: ensure reads happen after successful probe
From: Kees Cook <keescook@chromium.org>
To: Amit Shah <amit.shah@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Cooper <jason@lakedaemon.net>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 10:34 PM, Amit Shah <amit.shah@redhat.com> wrote:
> The hwrng core asks for random data in the hwrng_register() call itself
> from commit d9e7972619.  This doesn't play well with virtio -- the
> DRIVER_OK bit is only set by virtio core on a successful probe, and
> we're not yet out of our probe routine when this call is made.  This
> causes the host to not acknowledge any requests we put in the virtqueue,
> and the insmod or kernel boot process just waits for data to arrive from
> the host, which never happens.

Doesn't this mean that virtio-rng won't ever contribute entropy to the system?

-Kees

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
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index df95e2f..50f5b76 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -68,6 +68,12 @@ static void add_early_randomness(struct hwrng *rng)
>         unsigned char bytes[16];
>         int bytes_read;
>
> +       /*
> +        * Currently only virtio-rng cannot return data during device
> +        * probe, and that's handled in virtio-rng.c itself.  If there
> +        * are more such devices, this call to rng_get_data can be
> +        * made conditional here instead of doing it per-device.
> +        */
>         bytes_read = rng_get_data(rng, bytes, sizeof(bytes), 1);
>         if (bytes_read > 0)
>                 add_device_randomness(bytes, bytes_read);
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index f3e7150..157f27c 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -38,6 +38,8 @@ struct virtrng_info {
>         int index;
>  };
>
> +bool probe_done;
> +
>  static void random_recv_done(struct virtqueue *vq)
>  {
>         struct virtrng_info *vi = vq->vdev->priv;
> @@ -67,6 +69,13 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
>         int ret;
>         struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
>
> +       /*
> +        * Don't ask host for data till we're setup.  This call can
> +        * happen during hwrng_register(), after commit d9e7972619.
> +        */
> +       if (unlikely(!probe_done))
> +               return 0;
> +
>         if (!vi->busy) {
>                 vi->busy = true;
>                 init_completion(&vi->have_data);
> @@ -137,6 +146,7 @@ static int probe_common(struct virtio_device *vdev)
>                 return err;
>         }
>
> +       probe_done = true;
>         return 0;
>  }
>
> --
> 1.9.3
>



-- 
Kees Cook
Chrome OS Security
