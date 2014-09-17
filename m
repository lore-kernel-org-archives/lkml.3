Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaIQITs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaIQITp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:19:45 -0400
Message-ID: <54194411.6030905@redhat.com>
Date: Wed, 17 Sep 2014 10:19:29 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Chao Yu <chao2.yu@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] zram: use notify_free to account all free notifications
References: <1410792568-31539-1-git-send-email-sergey.senozhatsky@gmail.com> <1410792568-31539-2-git-send-email-sergey.senozhatsky@gmail.com>
In-Reply-To: <1410792568-31539-2-git-send-email-sergey.senozhatsky@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="adpXQSN0wVD5s7brEsnQSvEpMm6hhTfxh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--adpXQSN0wVD5s7brEsnQSvEpMm6hhTfxh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/15/2014 04:49 PM, Sergey Senozhatsky wrote:
> `notify_free' device attribute accounts the number of slot free notific=
ations
> and internally represents the number of zram_free_page() calls. Slot fr=
ee
> notifications are sent only when device is used as a swap device, hence=

> `notify_free' is used only for swap devices. Since f4659d8e620d08 (zram=
:
> support REQ_DISCARD) ZRAM handles yet another one free notification (al=
so
> via zram_free_page() call) -- REQ_DISCARD requests, which are sent by a=

> filesystem, whenever some data blocks are discarded. However, there is =
no
> way to know the number of notifications in the latter case.
>=20
> Use `notify_free' to account the number of pages freed by zram_bio_disc=
ard()
> and zram_slot_free_notify(). Depending on usage scenario `notify_free'
> represents:
>  a) the number of pages freed because of slot free notifications, which=
 is
>    equal to the number of swap_slot_free_notify() calls, so there is no=

>    behaviour change
>=20
>  b) the number of pages freed because of REQ_DISCARD notifications
>=20
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Acked-by: Jerome Marchand <jmarchan@redhat.com>

> ---
>  Documentation/ABI/testing/sysfs-block-zram | 13 ++++++++-----
>  drivers/block/zram/zram_drv.c              |  1 +
>  2 files changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation=
/ABI/testing/sysfs-block-zram
> index b13dc99..a6148ea 100644
> --- a/Documentation/ABI/testing/sysfs-block-zram
> +++ b/Documentation/ABI/testing/sysfs-block-zram
> @@ -77,11 +77,14 @@ What:		/sys/block/zram<id>/notify_free
>  Date:		August 2010
>  Contact:	Nitin Gupta <ngupta@vflare.org>
>  Description:
> -		The notify_free file is read-only and specifies the number of
> -		swap slot free notifications received by this device. These
> -		notifications are sent to a swap block device when a swap slot
> -		is freed. This statistic is applicable only when this disk is
> -		being used as a swap disk.
> +		The notify_free file is read-only. Depending on device usage
> +		scenario it may account a) the number of pages freed because
> +		of swap slot free notifications or b) the number of pages freed
> +		because of REQ_DISCARD requests sent by bio. The former ones
> +		are sent to a swap block device when a swap slot is freed, which
> +		implies that this disk is being used as a swap disk. The latter
> +		ones are sent by filesystem mounted with discard option,
> +		whenever some data blocks are getting discarded.
> =20
>  What:		/sys/block/zram<id>/zero_pages
>  Date:		August 2010
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_dr=
v.c
> index d78b245..3b85016 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -698,6 +698,7 @@ static void zram_bio_discard(struct zram *zram, u32=
 index,
>  		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
>  		zram_free_page(zram, index);
>  		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
> +		atomic64_inc(&zram->stats.notify_free);
>  		index++;
>  		n -=3D PAGE_SIZE;
>  	}
>=20



--adpXQSN0wVD5s7brEsnQSvEpMm6hhTfxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUGUQRAAoJEHTzHJCtsuoCi2oH/RCiJhtzJt/g02h67M3cH/QB
13GUdgtZk7bLJiYKvNtUsxxptxKtyZVIF8adJyhQdm9fyA6skZegccT54rX240hw
/u/OeKGBNdX16u04w87hxFNQSEuhfQBd67ouq8fiZDkB6gHqGMiyCfXDuU5Pc6Q4
roXiRMorbE2STXY9+lXZxVeYLZsUmVYhv2zPxT9k6IRhDOO5/qWEfvnIt1S5eero
cxad/pJ5OX9bDtAfpp4JH+ky7FY+HgJcwfD1AjD4hjluH2buIgmcn16cyNEEadRe
EcmSVQ6lTwfYs5XIVm4z6clsiy7/AzWiRBkzSPfXd6vjQO6BsrNtJ8z2K088mZU=
=/95z
-----END PGP SIGNATURE-----

--adpXQSN0wVD5s7brEsnQSvEpMm6hhTfxh--
