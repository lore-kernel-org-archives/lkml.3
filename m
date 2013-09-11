Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3IKCmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:42:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab3IKCmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:42:12 -0400
Date: Wed, 11 Sep 2013 12:42:00 +1000
From: NeilBrown <neilb@suse.de>
To: ycbzzjlby@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bian Yu <bianyu@kedacom.com>
Subject: Re: [PATCH] raid5: Retry R5_ReadNoMerge flag when hit a read error.
Message-ID: <20130911124200.6855813b@notabene.brown>
In-Reply-To: <1378080782-9971-1-git-send-email-ycbzzjlby@gmail.com>
References: <1378080782-9971-1-git-send-email-ycbzzjlby@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RwU9PQoF7dZVultT0VAzkyj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RwU9PQoF7dZVultT0VAzkyj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun,  1 Sep 2013 20:13:02 -0400 ycbzzjlby@gmail.com wrote:

> From: Bian Yu <bianyu@kedacom.com>
>=20
> Because of block layer merge, one bio fails will cause other bios
> which belongs to the same request fails, so raid5_end_read_request
> will record all these bios as badblocks.
> If retry request with R5_ReadNoMerge flag to avoid bios merge,
> badblocks can only record sector which is bad exactly.
>=20
> test:
> hdparm --yes-i-know-what-i-am-doing --make-bad-sector 300000 /dev/sdb
> mdadm -C /dev/md0 -l5 -n3 /dev/sd[bcd] --assume-clean
> mdadm /dev/md0 -f /dev/sdd
> mdadm /dev/md0 -r /dev/sdd
> mdadm --zero-superblock /dev/sdd
> mdadm /dev/md0 -a /dev/sdd
>=20
> 1. Without this patch:
> cat /sys/block/md0/md/rd*/bad_blocks
> 299776 256
> 299776 256
>=20
> 2. With this patch:
> cat /sys/block/md0/md/rd*/bad_blocks
> 300000 8
> 300000 8
>=20
> Signed-off-by: Bian Yu <bianyu@kedacom.com>
> ---
>  drivers/md/raid5.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ff1aecf..ee8c280 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1924,6 +1924,9 @@ static void raid5_end_read_request(struct bio * bi,=
 int error)
>  			       mdname(conf->mddev), bdn);
>  		else
>  			retry =3D 1;
> +		if (set_bad && test_bit(In_sync, &rdev->flags)
> +		    && !test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> +			retry =3D 1;
>  		if (retry)
>  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags)) {
>  				set_bit(R5_ReadError, &sh->dev[i].flags);


Applied, thanks.

NeilBrown

--Sig_/RwU9PQoF7dZVultT0VAzkyj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi/YeDnsnt1WYoG5AQKeahAAq72LoOH1Bb5K4BbGynB5Ly18jkkmHqsQ
Q0JXyjLImaRDLggjYBHqlx+5eFw7cZVdl00ZgznJRuywAPLf1GTupJ5iEPYnPTok
fNj4gZiNvBWmjv+G45IY74mKANqz2GLT5+/+NhTJouPawWoN98zoTHCCNCODJwNP
8lyv6dNev+n2q3Vf1rYOgjMdAo3wshFeQsIduuOaxvPqet+hEmRg4VlF7QdjrUgZ
vNKCFTEvOKFKCU6SOqiSFP+TRxPRu9ybRoXI4GNeXjyAyFbi8WM4IPSCcybtqRxy
MSDaCpBgs5IKzZAlNvr759jS+binE5soGAW5KQShM/uEO+x34+iGq0r1fodbJt5N
ZbFJMNd27jeY3zHlOMQ8l9hXwd8/3TeyFO0kIliN2zsZ1A3gbGNcWh6LxF1lAAKJ
xRVuhuRQrQ3cDECEXoQHLYKDeA+mHz3muQluyaPGJXBKPBJg5bZjFq2sOeN7qf6U
O5fuWJkRPmrrhEgN+/t+XvBbaXRwgGARJPBTJjDqyU2HS1Oq967aeI38byZQ98gy
5c906ijSJezqNcjwImIxMa2iT83ZkyRYOv+5Z+vY0KDT5NCZgL060iKDpzPIpeyd
qnAYWr2u+RDpvX66uIo6SSB4+3XQcf+lhmoR4Al6Tb/siMkPxJywEtgldc7pcf/C
1shI8lhubM0=
=UJln
-----END PGP SIGNATURE-----

--Sig_/RwU9PQoF7dZVultT0VAzkyj--
