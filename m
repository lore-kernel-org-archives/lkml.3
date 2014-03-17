Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaCQXKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:10:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaCQXJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:09:59 -0400
Date: Tue, 18 Mar 2014 10:09:49 +1100
From: NeilBrown <neilb@suse.de>
To: Ralph Mueck <linux-kernel@rmueck.de>
Cc: i4passt@lists.cs.fau.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthias Oefelein <ma.oefelein@arcor.de>
Subject: Re: [PATCH 2/2] md: Add support for RAID-1 consistency check
 feature
Message-ID: <20140318100949.16bc5883@notabene.brown>
In-Reply-To: <1395068405-13860-3-git-send-email-linux-kernel@rmueck.de>
References: <1395068405-13860-1-git-send-email-linux-kernel@rmueck.de>
	<1395068405-13860-3-git-send-email-linux-kernel@rmueck.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Dv/g_hdlmd9uW+qlfyEHW=i"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Dv/g_hdlmd9uW+qlfyEHW=i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Mar 2014 16:00:05 +0100 Ralph Mueck <linux-kernel@rmueck.de> wro=
te:

> This patch introduces a consistency check feature for level-1 RAID
> arrays that have been created with the md driver.
> When enabled, every read request is duplicated and initiated for each
> member of the RAID array. All read blocks are compared with their
> corresponding blocks on the other array members. If the check fails for
> a block, the block is not handed over, but an error code is returned
> instead.
> As mentioned in the cover letter, the implementation still has some=20
> unresolved issues.
>=20
> Signed-off-by: Ralph Mueck <linux-kernel@rmueck.de>
> Signed-off-by: Matthias Oefelein <ma.oefelein@arcor.de>
>=20
> ---
>  drivers/md/raid1.c | 252 +++++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 250 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a6ca1c..8c64f9a 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -37,6 +37,7 @@
>  #include <linux/module.h>
>  #include <linux/seq_file.h>
>  #include <linux/ratelimit.h>
> +#include <linux/gfp.h>
>  #include "md.h"
>  #include "raid1.h"
>  #include "bitmap.h"
> @@ -257,6 +258,109 @@ static void call_bio_endio(struct r1bio *r1_bio)
>  	}
>  }
> =20
> +/* The safe_read version of the raid_end_bio_io() function */
> +/* On a read request, we issue requests to all available disks.
> + * Data is returned only if all discs contain the same data
> + */
> +static void _endio(struct r1bio *r1_bio)
> +{
> +	struct bio *bio =3D r1_bio->master_bio;
> +	int done;
> +	struct r1conf *conf =3D r1_bio->mddev->private;
> +	sector_t start_next_window =3D r1_bio->start_next_window;
> +	sector_t bi_sector =3D bio->bi_iter.bi_sector;
> +	int disk;
> +	struct md_rdev *rdev;
> +	int i;
> +	struct page *dragptr =3D NULL;
> +	int already_copied =3D 0;	/* we want to copy the data only once */
> +
> +	for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
> +		struct bio *p =3D NULL;
> +		struct bio *s =3D NULL;
> +	=09
> +		rcu_read_lock();
> +		rdev =3D rcu_dereference(conf->mirrors[disk].rdev);
> +		rcu_read_unlock();

You cannot drop rcu_read_lock until you take a reference to rdev, or stop
using it.


> +
> +		if (r1_bio->bios[disk] =3D=3D IO_BLOCKED
> +			|| rdev =3D=3D NULL
> +			|| test_bit(Unmerged, &rdev->flags)
> +			|| test_bit(Faulty, &rdev->flags)) {
> +			continue;
> +		}
> +
> +		/* bio_for_each_segment is broken. at least here.. */
> +		/* iterate over linked bios */
> +		for (p =3D r1_bio->master_bio, s =3D r1_bio->bios[disk];
> +		     (p !=3D NULL) && (s !=3D NULL);
> +		     p =3D p->bi_next, s =3D s->bi_next) {
> +			/* compare the pages read */
> +			for (i =3D 0; i < r1_bio->bios[disk]->bi_vcnt; i++) {
> +				if (dragptr) { /* dragptr points to the previous page */
> +					if(memcmp(page_address(r1_bio->bios[disk]->bi_io_vec[0].bv_page),
> +						page_address(dragptr),
> +						(r1_bio->bios[disk]->bi_io_vec[0].bv_len))) {
> +						set_bit(R1BIO_ReadError, &r1_bio->state);
> +						clear_bit(R1BIO_Uptodate, &r1_bio->state);
> +					}
> +				}
> +				dragptr =3D r1_bio->bios[disk]->bi_io_vec[0].bv_page;
> +			}

This doesn't make any sense to me at all.  You use 'i' to loop bi_vnt times,
but never use 'i' or change any other variable in that loop (except dragptr
which is always set to the same value).

And you use "bi_next", but next set up any linkage through bi_next.

Confused.

NeilBrown



--Sig_/Dv/g_hdlmd9uW+qlfyEHW=i
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyeAvTnsnt1WYoG5AQKoUQ//Wy1ACFQdXOyH7oL2LlJmcD8ibaG3IGm+
YUWqSsJWfupULR/4Il5G5C0XpYvufnd2blbMqXqH+8GE/CuLso3QzJGNh6SQNHTM
UKj+JzlAKmxoy6K3RzlrCH0wOCi+XVJEM69ftcdr5hHM0N4oeNUKqlk5Z0/hmtjZ
BdqTu5xoMaKe98poo6CLUD/rojVL/sl27cmf3MvmkN2FmfvzHLGTPVvMP+gcBYON
CsYO2X4godl4mvM5rOPv1zDR2Rvv+W5yEDJyGWwdQQlq0viHxYFQ40dykYU2Fb0c
NpqnlOL/HuB8ILlmzfEr5T0Ym+EQumYmCLAiwtX4e30hUi4SAVVC+Wun7OxRwYvN
7jwGsHDRFRwYTHE+2ofslbxg0f+lg+RnT//Hb1Zl/cRTEgpXsd2VpEFbb9RHs/MG
o/bHwjRsnZm74GhYN2T3QP0N01LPXxr1EyxnHpx3LFB4Cep1Uqc3X7c7VNSIoivT
gXWMvWWrNkYedppBJQjV91Zn2UlkYHAU6djnF3BbEH0rcu1PaJvPFuKa+qEbmEUx
7VeZe+WSgAfXjg1imQV2p2ztL0KvA+cQWzTe7Gk2m2KvwHTB9kSYGOWf9ndrBe1I
sUSCKfiJHr8wbBsj5IKuqIPoZF9YR1wm43MRPf59ZXaL3iBgYq7gXTZ4WUFIGtyC
0fu4naVfaS0=
=22uI
-----END PGP SIGNATURE-----

--Sig_/Dv/g_hdlmd9uW+qlfyEHW=i--
