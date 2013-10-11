Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3JKJqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 05:46:00 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:39939 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3JKJp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 05:45:58 -0400
Date: Fri, 11 Oct 2013 11:43:52 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: tbergstrom@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drm/tegra: Deliver syncpoint base to user space
Message-ID: <20131011094352.GB8659@ulmo.nvidia.com>
References: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com>
 <1381319650-9799-3-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <1381319650-9799-3-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2013 at 02:54:09PM +0300, Arto Merilainen wrote:
> This patch makes the necessary additions to deliver syncpoint base
> to the user space.
>=20
> This patch splits the index field in the drm_tegra_get_syncpt structure
> into three separate fields (index, support_base, base_id). This allows
> to keep compatibility over kernel versions:
> - The placing of index field stays constant and therefore the interface
>   should stay compatible with earlier userspace versions.
> - The old index field was input-only and it was not supposed to be read
>   afterwards. Delivering data back in the same field should not introduce
>   regressions to any old user space applications.
> - Old kernels left support_base and base_id fields intact (zero) and
>   hence the new user space applications get the correct response from
>   the kernel (=3Dsyncpoint does not have a base).
>=20
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> ---
>  drivers/gpu/host1x/drm/drm.c | 2 ++
>  include/uapi/drm/tegra_drm.h | 4 +++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
> index 8c61cee..4251563 100644
> --- a/drivers/gpu/host1x/drm/drm.c
> +++ b/drivers/gpu/host1x/drm/drm.c
> @@ -468,6 +468,8 @@ static int tegra_get_syncpt(struct drm_device *drm, v=
oid *data,
> =20
>  	syncpt =3D context->client->syncpts[args->index];
>  	args->id =3D host1x_syncpt_id(syncpt);
> +	args->support_base =3D syncpt->base ? 1 : 0;
> +	args->base_id =3D syncpt->base ? syncpt->base->id : 0;
> =20
>  	return 0;
>  }
> diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
> index 73bde4e..7a79ca5 100644
> --- a/include/uapi/drm/tegra_drm.h
> +++ b/include/uapi/drm/tegra_drm.h
> @@ -61,7 +61,9 @@ struct drm_tegra_close_channel {
> =20
>  struct drm_tegra_get_syncpt {
>  	__u64 context;
> -	__u32 index;
> +	__u16 index;
> +	__u8 support_base;
> +	__u8 base_id;
>  	__u32 id;

I don't like this. Can't we just add a separate IOCTL? Something like:

	struct drm_tegra_get_syncpt_base {
		__u64 context;
		__u32 syncpt;
		__u32 base;
	};

Which could be used somewhat like this:

	struct drm_tegra_get_syncpt_base args;

	memset(&args, 0, sizeof(args));
	args.context =3D context;
	args.syncpt =3D syncpt;

	err =3D ioctl(fd, DRM_IOCTL_TEGRA_GET_SYNCPT_BASE, &args);
	if (err < 0) {
		/*
		 * perhaps errno =3D=3D ENOTSUP if the syncpoint has no
		 * associated base?
		 */
	}

	base =3D args.base;

Thierry

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSV8hYAAoJEN0jrNd/PrOhcEYP/i2so60RDayfzz06Ci2QtitC
Hp3k/d9jZAXFvXOnyEsIiTpc4VVbrUzRPQ8iSmCRqGA/UeC9/ElIgaZPEQT9ovHK
wbthxuKioL8PQCuMqL82siK0EqmO2gdMXLyarW01PBkm9macvcqoh4go49gMwQMv
qe4Bt51HCIabp3vcQXmUpY8cVAwMFrGG+KSn9xY30odyNy8p5X5bAxzFgFqYigHh
G7oMGisLHGHOzlz6tuQsJo0gML7zGi6PuMpWuJNQEfSJLuk5gxGG6P1BxA7SsIpM
zC+Z4Po+dktyUkung6jMbeNgW1ggLAsGQsgfvWdy6c2AKZ5jKq3+WPLwksZgWgXg
xMeMHLqEpQxXQBQm3ZK16DvMa50vfqZrQWuWLCi9yc45nrOc3GBBAr3SQ/8pJZs7
BrDTahDqPIzABuGv58oqB32+9iHz9EOuO4KvyCtW0Ot5FPuAo9I3H3OVm7oMQhb8
mAXhu7nkYhJXlAShmuwYa9ngoc3e0sgdKRaMNEx5n9vIoT3cGTRVIQiZq8kRc3jq
PpcFU7QZo0uYq7KElim3yovhSHkISu678s8r6DpqVHAvjMNQQ27gwOr1I/YiDbim
a68TgL3X2NCPHtZaooUZj2+GLZMmSCpSnrt7ciCNBBaObrlOoNQUmyIdzm0VzVki
FbEuhzEzaJE42G9riZvj
=IDMv
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
