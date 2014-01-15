Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaAOVzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:55:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaAOVzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:55:48 -0500
Date: Thu, 16 Jan 2014 08:55:36 +1100
From: NeilBrown <neilb@suse.de>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: check command validity early in md_ioctl().
Message-ID: <20140116085536.54a3f56a@notabene.brown>
In-Reply-To: <1389801532-25567-1-git-send-email-nschichan@freebox.fr>
References: <20140115125740.160e8998@notabene.brown>
	<1389801532-25567-1-git-send-email-nschichan@freebox.fr>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1o6bD9rRhENl1exf/VQXoHV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1o6bD9rRhENl1exf/VQXoHV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Jan 2014 16:58:52 +0100 Nicolas Schichan <nschichan@freebox.fr>
wrote:

> Verify that the cmd parameter passed to md_ioctl() is valid before
> doing anything.
>=20
> This fixes mddev->hold_active being set to 0 when an invalid ioctl
> command is passed to md_ioctl() before the array has been configured.
>=20
> Clearing mddev->hold_active in that case can lead to a livelock
> situation when an invalid ioctl number is given to md_ioctl() by a
> process when the mddev is currently being opened by another process:
>=20
> Process 1				Process 2
> ---------				---------
>=20
> md_alloc()
>   mddev_find()
>   -> returns a new mddev with
>      hold_active =3D=3D UNTIL_IOCTL
>   add_disk()
>   -> sends KOBJ_ADD uevent
>=20
> 					(sees KOBJ_ADD uevent for device)
>                     			md_open()
>                     			md_ioctl(INVALID_IOCTL)
>                     			-> returns ENODEV and clears
>                        			   mddev->hold_active
>                     			md_release()
>                       			md_put()
>                       			-> deletes the mddev as
>                          		   hold_active is 0
>=20
> md_open()
>   mddev_find()
>   -> returns a newly
>     allocated mddev with
>     mddev->gendisk =3D=3D NULL
> -> returns with ERESTARTSYS
>    (kernel restarts the open syscall)
>=20
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---
>=20
> A couple of notes:
>=20
> This patch is based on linux 3.13-rc8.
>=20
> The following  MD ioctl constants are  defined in md_u.h  but not used
> anywhere else, so are not accepted as valid ioctl commands:
>=20
> CLEAR_ARRAY
> SET_DISK_INFO
> WRITE_RAID_INFO
> UNPROTECT_ARRAY
> PROTECT_ARRAY
>=20
>=20
>  drivers/md/md.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21f4d7f..941ac65 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6328,6 +6328,32 @@ static int md_getgeo(struct block_device *bdev, st=
ruct hd_geometry *geo)
>  	return 0;
>  }
> =20
> +static inline bool md_ioctl_valid(unsigned int cmd)
> +{
> +	switch (cmd) {
> +	case ADD_NEW_DISK:
> +	case BLKROSET:
> +	case GET_ARRAY_INFO:
> +	case GET_BITMAP_FILE:
> +	case GET_DISK_INFO:
> +	case HOT_ADD_DISK:
> +	case HOT_REMOVE_DISK:
> +	case PRINT_RAID_DEBUG:
> +	case RAID_AUTORUN:
> +	case RAID_VERSION:
> +	case RESTART_ARRAY_RW:
> +	case RUN_ARRAY:
> +	case SET_ARRAY_INFO:
> +	case SET_BITMAP_FILE:
> +	case SET_DISK_FAULTY:
> +	case STOP_ARRAY:
> +	case STOP_ARRAY_RO:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  static int md_ioctl(struct block_device *bdev, fmode_t mode,
>  			unsigned int cmd, unsigned long arg)
>  {
> @@ -6336,6 +6362,9 @@ static int md_ioctl(struct block_device *bdev, fmod=
e_t mode,
>  	struct mddev *mddev =3D NULL;
>  	int ro;
> =20
> +	if (!md_ioctl_valid(cmd))
> +		return -ENOTTY;
> +
>  	switch (cmd) {
>  	case RAID_VERSION:
>  	case GET_ARRAY_INFO:


Patch applied - thanks!

NeilBrown

--Sig_/1o6bD9rRhENl1exf/VQXoHV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtcD2Dnsnt1WYoG5AQLz/Q//bAg8hFFqS/RKhE/6+Fm66GDKmIk7OsW9
UHCoQscjU915P5QPL7+pRWgnpReyX71Rp3uz3or7oXrHiO8vAirKbSRbl20APRp7
UoxVxKyBPwuRiBzGjpjxuaA7omOiUSDLjmUp3pTHh1MNX1zcP5XfPZx2FXVt7yXO
7+4Q1xTIsbsUMXUYvlPN8cv4S1WWmcOtIL9zzCDYnSKjtSPqXiCVnGsWTcD8HjU0
5oDh6+uaEf+NCouCoKHNy2e+EmOARc1lTYekyEN4EAwkKTKmPiCCF18I3zo0lV/v
Krt2+IrqQ+ogj3wCiE/+nIPZFJsp3Yt57uwd+M7ZtmaVV4lzr5ZwUsBX4/u15V6x
B8q5aJil2+FDoaYZbHLIUAj/xlgkWoReMaGlp0Fb8g1LkQnE1rJdnJUmEvrGbtlJ
4ewFbC/ybVXPh6D2erfdOarbYahfAdtG2iokAu+RUBGktuT4e6jAzD58TPkLS9Ax
UtuIlxO7KoI5+toyUhBr2mXJUoB1Efo8NqOgJyND7vsOKVV1reaOFzQi4kYxukLg
pKUvtcGdvdvYSAAYCtgM5NABATaubsGEYLEfH+xpnA7cp/w9/ntIY58deM9l9k5z
mgOvL56Emg8vmCKeBOa3c/aiL7sZ1IOawH5VKyZgOeSMDjQEpSby77RVqqT3cG5m
d76/W1DIeys=
=ft1X
-----END PGP SIGNATURE-----

--Sig_/1o6bD9rRhENl1exf/VQXoHV--
