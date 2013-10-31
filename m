Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab3JaAQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 20:16:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab3JaAQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 20:16:28 -0400
Date: Thu, 31 Oct 2013 11:16:12 +1100
From: NeilBrown <neilb@suse.de>
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, shli@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raid0: Set discard_granularity to correct value after
 reshape.
Message-ID: <20131031111612.2735d0c1@notabene.brown>
In-Reply-To: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
References: <20131030122022.20862.97997.stgit@gklab-154-222.igk.intel.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QN1VansVW.J2ZAn8L_Hzkvd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QN1VansVW.J2ZAn8L_Hzkvd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Oct 2013 13:20:22 +0100 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> In case of reshape of raid0 through raid4 a value of discard_granularity
> will be set to stripe size. MD driver should re-set this value to correct
> one when migration will be finished. Otherwise array will be left with
> wrong value and discard operations will not work properly.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Cc: Shaohua Li <shli@kernel.org>
> ---
>  drivers/md/raid0.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index c4d420b..807ca3a 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -266,6 +266,8 @@ static int create_strip_zones(struct mddev *mddev, st=
ruct r0conf **private_conf)
>  	}
>  	mddev->queue->backing_dev_info.congested_fn =3D raid0_congested;
>  	mddev->queue->backing_dev_info.congested_data =3D mddev;
> +	mddev->queue->limits.discard_granularity =3D
> +			queue_logical_block_size(mddev->queue);
> =20
>  	/*
>  	 * now since we have the hard sector sizes, we can make sure

Thanks, but this doesn't seem like the right sort of fix.  It is to specific
to the symptom rather than trying to address the underlying problem.

Maybe something like this?  Can you review and test?

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 628cd529343f..740b6340f980 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3620,6 +3620,7 @@ level_store(struct mddev *mddev, const char *buf, siz=
e_t len)
 		mddev->in_sync =3D 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
+	blk_set_stacking_limit(&mddev->queue->limits);
 	pers->run(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	mddev_resume(mddev);

--Sig_/QN1VansVW.J2ZAn8L_Hzkvd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnGhTDnsnt1WYoG5AQLoeBAAjZBrsLz72tts2FXhs8B4A+1/Tp9exK1S
udJJk38SYP1r8XuKAzqH/nbQpwZ6yAW/gt902mbUgJgiuwAACuMypCJPD2hxIYD3
S2RaSFDNZ5h8U22fHyYplgQwA0jAbRYC+mdHLdxHD/yQ5IqmztBdOTDEK62ZuaKZ
lgM71hFJpIscaiLTl3glJK1Nh3Sez6rmI00yZizRQ6Dd2KdVcJPTNjZZ07SD5ek/
id+K9Qdx7Iy2drE7fK5L8NG22BphE8dY5XFGj9cpKEE9sPWtt/kwnnPNXSV72OzF
rd1GR8pSQ+oYlITVSa528Qi9nX2pAiQMDgm741HyruOFWSq7tZahvWMoYHwrlM5U
Z6mms+6bqLKom6ExswdwKwGdwIxOCvNV5Fv6k0Zly1bD8wp1racIbhK9Ekumk9ZJ
W30T+OWJIGG8irKX9hfPO/noAE02PpszFuyfw/VA+WDsmpNGDs1xEwxQ9V9ejFsd
S9PhvPdsI0JJd+OrGt7C1K9HHTm2s6hsqFuPDiAU450UukipnVBLaWeBecXBR5YD
WBMrWJgAN00pIimiUzBWLDMelHXj3dX29A0CWjDEy1U6sUnSnxt83SQNKPSnKlB2
dbYSO8A/npyY5Y66z6FFnxCJdvpelZtxpW61muK3WjwDUtYv8zxUCksz0IDBcQco
Kaamw5szsM4=
=F60I
-----END PGP SIGNATURE-----

--Sig_/QN1VansVW.J2ZAn8L_Hzkvd--
