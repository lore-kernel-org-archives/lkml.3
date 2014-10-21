Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaJUO1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:27:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932631AbaJUO1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:27:49 -0400
Message-ID: <54466649.901@redhat.com>
Date: Tue, 21 Oct 2014 15:57:29 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: karam.lee@lge.com, minchan@kernel.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org
CC: matthew.r.wilcox@intel.com, seungho1.park@lge.com
Subject: Re: [PATCH v3 3/3] zram: implement rw_page operation of zram
References: <1413876458-19279-1-git-send-email-karam.lee@lge.com> <1413876458-19279-4-git-send-email-karam.lee@lge.com>
In-Reply-To: <1413876458-19279-4-git-send-email-karam.lee@lge.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fDuSmQSfLfgASt5wV6JSArcnKm6uJHVgg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fDuSmQSfLfgASt5wV6JSArcnKm6uJHVgg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/21/2014 09:27 AM, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
>=20
> This patch implements rw_page operation for zram block device.
>=20
> I implemented the feature in zram and tested it.
> Test bed was the G2, LG electronic mobile device, whtich has msm8974
> processor and 2GB memory.
> With a memory allocation test program consuming memory, the system
> generates swap.
> And operating time of swap_write_page() was measured.
>=20
> --------------------------------------------------
> |             |   operating time   | improvement |
> |             |  (20 runs average) |             |
> --------------------------------------------------
> |with patch   |    1061.15 us      |    +2.4%    |
> --------------------------------------------------
> |without patch|    1087.35 us      |             |
> --------------------------------------------------
>=20
> Each test(with paged_io,with BIO) result set shows normal distribution
> and has equal variance.
> I mean the two values are valid result to compare.
> I can say operation with paged I/O(without BIO) is faster 2.4% with
> confidence level 95%.
>=20
> Signed-off-by: karam.lee <karam.lee@lge.com>
> ---
>  drivers/block/zram/zram_drv.c |   38 +++++++++++++++++++++++++++++++++=
+++++
>  1 file changed, 38 insertions(+)
>=20
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> index 4565fdc..696f0b5 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -810,8 +810,46 @@ static void zram_slot_free_notify(struct block_dev=
ice *bdev,
>  	atomic64_inc(&zram->stats.notify_free);
>  }
> =20
> +static int zram_rw_page(struct block_device *bdev, sector_t sector,
> +		       struct page *page, int rw)
> +{
> +	int offset, ret =3D 1;

Small nitpick, but why do you initialize ret to 1? It doesn't seem to be
ever used (nor is 1 a valid return value AFAICT).

It otherwise looks good.

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> +	u32 index;
> +	struct zram *zram;
> +	struct bio_vec bv;
> +
> +	zram =3D bdev->bd_disk->private_data;
> +	if (!valid_io_request(zram, sector, PAGE_SIZE)) {
> +		atomic64_inc(&zram->stats.invalid_io);
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	down_read(&zram->init_lock);
> +	if (unlikely(!init_done(zram))) {
> +		ret =3D -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	index =3D sector >> SECTORS_PER_PAGE_SHIFT;
> +	offset =3D sector & (SECTORS_PER_PAGE - 1) << SECTOR_SHIFT;
> +
> +	bv.bv_page =3D page;
> +	bv.bv_len =3D PAGE_SIZE;
> +	bv.bv_offset =3D 0;
> +
> +	ret =3D zram_bvec_rw(zram, &bv, index, offset, rw);
> +
> +out_unlock:
> +	up_read(&zram->init_lock);
> +out:
> +	page_endio(page, rw, ret);
> +	return ret;
> +}
> +
>  static const struct block_device_operations zram_devops =3D {
>  	.swap_slot_free_notify =3D zram_slot_free_notify,
> +	.rw_page =3D zram_rw_page,
>  	.owner =3D THIS_MODULE
>  };
> =20
>=20



--fDuSmQSfLfgASt5wV6JSArcnKm6uJHVgg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJURmZPAAoJEHTzHJCtsuoCllsH/1NMBUijKqKM864MguUkRCuo
buU5yNCKdUMOGjSONZhL50drzkyZHci+MH0tEhek7diBSlYc3Zj/5mJxij3ESCbv
ObWs9F2HUUMHEDxX7CWsJMFjsg9TXzBLJG0L7E+6kCsdiUfwcX6GsKhBwQ3/5kyf
7lL4DRUNCRFstzZU8ZXBsfiCUbrxTo0UHf97RHFpnrtyYMg9D7VOt52s4gI1eLkP
1j95S/t2wkH7/2xkACHtpYtBh9FcSBhxJoQeoem7br/neCqPBzV3FtbX9YTZy8A9
/KkVodd8EiTksqHE3hO1dH5LZ/lsqgmIMPgnFw7/dH5uGavop42Wl4fDo6c175M=
=8iEF
-----END PGP SIGNATURE-----

--fDuSmQSfLfgASt5wV6JSArcnKm6uJHVgg--
