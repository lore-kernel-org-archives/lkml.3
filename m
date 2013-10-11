Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JKJlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:41:17 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:50884 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3JKJlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:41:15 -0400
Date: Fri, 11 Oct 2013 11:39:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: tbergstrom@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] gpu: host1x: Add syncpoint base support
Message-ID: <20131011093905.GA8659@ulmo.nvidia.com>
References: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com>
 <1381319650-9799-2-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1381319650-9799-2-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2013 at 02:54:08PM +0300, Arto Merilainen wrote:
> This patch adds support for hardware syncpoint bases. This creates
> a simple mechanism for waiting an operation to complete in the middle
> of the command buffer.

Perhaps "... simple mechanism to stall the command FIFO until an
operation is completed." That's what the TRM contains and more
accurately describes the hardware functionality.

> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
[...]
> @@ -26,6 +26,7 @@
>  #include "cdma.h"
>  #include "job.h"
> =20
> +struct host1x_base;

host1x_syncpt_base is more explicit, host1x_base sounds very generic.

> diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/c=
hannel_hw.c
> index ee19962..5f9f735 100644
> --- a/drivers/gpu/host1x/hw/channel_hw.c
> +++ b/drivers/gpu/host1x/hw/channel_hw.c
> @@ -67,6 +67,21 @@ static void submit_gathers(struct host1x_job *job)
>  	}
>  }
> =20
> +static inline void synchronize_syncpt_base(struct host1x_job *job)
> +{
> +	struct host1x_channel *ch =3D job->channel;
> +	struct host1x *host =3D dev_get_drvdata(ch->dev->parent);
> +	struct host1x_syncpt *sp =3D host->syncpt + job->syncpt_id;
> +	u32 base_id =3D sp->base->id;
> +	u32 base_val =3D host1x_syncpt_read_max(sp);
> +
> +	host1x_cdma_push(&ch->cdma,
> +			 host1x_opcode_setclass(HOST1X_CLASS_HOST1X,
> +				host1x_uclass_load_syncpt_base_r(), 1),
> +			 host1x_uclass_load_syncpt_base_base_indx_f(base_id) |
> +			 host1x_uclass_load_syncpt_base_value_f(base_val));

Please use the all-caps version of the register definitions. The
lowercase variants were only introduced to allow profiling and coverage
testing, which I think nobody's been doing and I'm in fact thinking
about removing them.

> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
[...]
> +static struct host1x_base *host1x_base_alloc(struct host1x *host)
> +{
> +	struct host1x_base *base =3D host->bases;
> +	int i;

unsigned int

> +
> +	for (i =3D 0; i < host->info->nb_bases && base->reserved; i++, base++)
> +		;

I'd like to see this rewritten as:

	for (i =3D 0; i < host->info->nb_bases; i++) {
		if (!host->bases[i].reserved)
			break;
	}

> +static void host1x_base_free(struct host1x_base *base)
> +{
> +	if (!base)
> +		return;
> +	base->reserved =3D false;
> +}

The following would be somewhat shorter:

	if (base)
		base->reserved =3D false;

>  static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
>  						  struct device *dev,
> -						  bool client_managed)
> +						  bool client_managed,
> +						  bool support_base)

I think at this point we probably want to introduce a flags argument
instead of adding all those boolean parameters. Something like:

	#define HOST1X_SYNCPT_CLIENT_MANAGED	(1 << 0)
	#define HOST1X_SYNCPT_HAS_BASE		(1 << 1)

	struct host1x_syncpt *host1x_syncpt_alloc(struct host1x *host,
						  struct device *dev,
						  unsigned long flags);

>  int host1x_syncpt_init(struct host1x *host)
>  {
>  	struct host1x_syncpt *syncpt;
> +	struct host1x_base *bases;
>  	int i;
> =20
> +	bases =3D devm_kzalloc(host->dev, sizeof(*bases) * host->info->nb_bases,
> +		GFP_KERNEL);
>  	syncpt =3D devm_kzalloc(host->dev, sizeof(*syncpt) * host->info->nb_pts,
>  		GFP_KERNEL);

I'd prefer these to be checked separately. Also the argument alignment
is wrong here. Align with the first function argument. And for
consistency, allocate bases after syncpoints...

> -	if (!syncpt)
> +	if (!syncpt || !bases)
>  		return -ENOMEM;
> =20
> -	for (i =3D 0; i < host->info->nb_pts; ++i) {
> +	for (i =3D 0; i < host->info->nb_bases; i++)
> +		bases[i].id =3D i;
> +
> +	for (i =3D 0; i < host->info->nb_pts; i++) {
>  		syncpt[i].id =3D i;
>  		syncpt[i].host =3D host;
>  	}

=2E.. and initialize them after the syncpoints...

> =20
>  	host->syncpt =3D syncpt;
> +	host->bases =3D bases;

=2E.. to match the assignment order.

> @@ -332,7 +368,14 @@ struct host1x_syncpt *host1x_syncpt_request(struct d=
evice *dev,
>  					    bool client_managed)
>  {
>  	struct host1x *host =3D dev_get_drvdata(dev->parent);
> -	return _host1x_syncpt_alloc(host, dev, client_managed);
> +	return _host1x_syncpt_alloc(host, dev, client_managed, false);
> +}
> +
> +struct host1x_syncpt *host1x_syncpt_request_based(struct device *dev,
> +						  bool client_managed)
> +{
> +	struct host1x *host =3D dev_get_drvdata(dev->parent);
> +	return _host1x_syncpt_alloc(host, dev, client_managed, true);
>  }

If we add a flags parameter to host1x_syncpt_request() (and
host1x_syncpt_alloc()) then we don't need the separate function.

> diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
> index 267c0b9..852dc76 100644
> --- a/drivers/gpu/host1x/syncpt.h
> +++ b/drivers/gpu/host1x/syncpt.h
> @@ -30,6 +30,11 @@ struct host1x;
>  /* Reserved for replacing an expired wait with a NOP */
>  #define HOST1X_SYNCPT_RESERVED			0
> =20
> +struct host1x_base {
> +	u8 id;
> +	bool reserved;

Perhaps name this to something like "requested". "reserved" makes it
sound like it's reserved for some special use.

Thierry

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSV8c5AAoJEN0jrNd/PrOh0Y4P/jABrv1wrBSv1pv6TkZzDEle
u9HT1v2ZZEkqu07xVnP6HN14I/Ovx7FqHn1OsIYniRnGVEUPF7f68f9JmlHoHc4y
t4CS85QAVf47j1foHT8oFdrRMYTAl2Y0mHR0QTkkb1GSE9Eo4tujSmiw+BwTmWu0
k4C8i+pI75VoQgZ/pNPWCXHa1G2MoM6+SvrVhXGn9qPDCL+GK4uQOqRcW+dwdF3o
qPZTqi0KVLXRp7SXAEZlZXgLq/56PySb+Ztt2vZ2BGIa2+PoLzfBNpL6LSBkPzSA
7Jweu8blABNvTg0NdHBAO8kp9NCulFCiDkf5C2PyeauOZS713TsN4968ibaJS/L7
L9e3jN8Tt/i+G5kyLZ9USuxSyRg48HY3M2G6P3eIznVzM8bYFCy6oZUKw16Gn9eC
yzVEIId81G5UY19wRS+TrRaBoyGkdDhhuUef9fLmoqjSO7vKrqGr+BtAq5HrqfEb
epHsXy+Q4UFYuQU0NqJ5AiaMErZ5n1j1c7mBP4K+k2Ye32DYSoj7mvSY/eUs5RzJ
dbnQU34jjJYpUsOdeWMOn77QPPk+1YUXpR2IRahstomrCVhvSpwX8WbRCS17t2JF
2sbwNC4RczByfbeV9TAOsrMRNYifksWRhbNNCHQ1AObrsOghHjh/k1dKHkGDc1Wd
1osGJm1oY2vFEI8Q801c
=uN7X
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
