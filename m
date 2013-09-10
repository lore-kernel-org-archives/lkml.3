Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3IJFeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:34:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3IJFeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:34:03 -0400
Date: Tue, 10 Sep 2013 15:33:47 +1000
From: NeilBrown <neilb@suse.de>
To: y b <ycbzzjlby@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] md: avoid deadlock when raid5 array has unack
 badblocks during md_stop_writes.
Message-ID: <20130910153347.5fafb58b@notabene.brown>
In-Reply-To: <CAPoh-nY8wwu-2yYRbKycPX2gEUofQu6y29TOYhOm83C2au6ZQQ@mail.gmail.com>
References: <CAPoh-nY8wwu-2yYRbKycPX2gEUofQu6y29TOYhOm83C2au6ZQQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KJiG/jxIer2AKvS/1vtY_1Z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KJiG/jxIer2AKvS/1vtY_1Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Sep 2013 13:00:52 +0800 y b <ycbzzjlby@gmail.com> wrote:

> When raid5 hit a fresh badblock, this badblock will flagged as unack
> badblock until md_update_sb is called.
> But md_stop/reboot/md_set_readonly will avoid raid5d call md_update_sb
> in md_check_recovery, the badblock will always be unack, so raid5d
> thread enter a infinite loop and never can unregister sync_thread
> that cause deadlock.
>=20
> To solve this, before md_stop_writes call md_unregister_thread, set
> MD_STOPPING_WRITES on mddev->flags. In raid5.c analyse_stripe judge
> MD_STOPPING_WRITES bit on mddev->flags, if setted don't block rdev
> to wait md_update_sb. so raid5d thread can be finished.
> Signed-off-by: Bian Yu <bianyu@kedacom.com>

Have you actually seen this deadlock happen?  Because I don't think it can
happen.

By the time we get to md_stop or md_set_readonly all dirty buffers should
have been flushed and there should be no pending writes so nothing to wait
for an unacked bad block.

If you have seen this happen, any details you can give about the exact state
of the RAID5 when it deadlocked, the stack trace of any relevant processes
etc would be very helpful.

Thanks,
NeilBrown


> ---
>  drivers/md/md.c    |    2 ++
>  drivers/md/md.h    |    3 +++
>  drivers/md/raid5.c |    3 ++-
>  3 files changed, 7 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index adf4d7e..54ef71f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5278,6 +5278,7 @@ static void md_clean(struct mddev *mddev)
>  static void __md_stop_writes(struct mddev *mddev)
>  {
>      set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> +    set_bit(MD_STOPPING_WRITES, &mddev->flags);
>      if (mddev->sync_thread) {
>          set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>          md_reap_sync_thread(mddev);
> @@ -5294,6 +5295,7 @@ static void __md_stop_writes(struct mddev *mddev)
>          mddev->in_sync =3D 1;
>          md_update_sb(mddev, 1);
>      }
> +    clear_bit(MD_STOPPING_WRITES, &mddev->flags);
>  }
>=20
>  void md_stop_writes(struct mddev *mddev)
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 608050c..c998b82 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -214,6 +214,9 @@ struct mddev {
>  #define MD_STILL_CLOSED    4    /* If set, then array has not been opene=
d since
>                   * md_ioctl checked on it.
>                   */
> +#define MD_STOPPING_WRITES 5     /* If set, raid5 shouldn't set unacknow=
ledged
> +                  * badblock blocked in analyse_stripe to avoid infinite=
 loop
> +                  */
>=20
>      int                suspended;
>      atomic_t            active_io;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f9972e2..ff1aecf 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3446,7 +3446,8 @@ static void analyse_stripe(struct stripe_head
> *sh, struct stripe_head_state *s)
>          if (rdev) {
>              is_bad =3D is_badblock(rdev, sh->sector, STRIPE_SECTORS,
>                           &first_bad, &bad_sectors);
> -            if (s->blocked_rdev =3D=3D NULL
> +            if (!test_bit(MD_STOPPING_WRITES, &conf->mddev->flags)
> +                && s->blocked_rdev =3D=3D NULL
>                  && (test_bit(Blocked, &rdev->flags)
>                  || is_bad < 0)) {
>                  if (is_bad < 0)


--Sig_/KJiG/jxIer2AKvS/1vtY_1Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi6vOznsnt1WYoG5AQLunw/+JLSBpHeRb+9z9PyAUFz5yuJ3WrBych/2
g0nWzkhW2is/hXEXQ0RV5c8+0xX5Z4woARO5uC4SEf2LBIJx0tVo3nX3jbtvwGrC
U80Zo3alI2FF8iajgPoJ84ACIMQ0jqrZr27GMgmg5tfr6ko0F8Rd1MJD9wasLVHM
i0f0zz+3zNxnIb+uZUtVb7EEBNn5dcgzFaq8DEhzRZfcOFmNMoEq+ivG6p1hquCZ
6kBuQ6sPeT7qcPaJ0tbCC9DPiip5t1vMj2qaIRWF2L9Hid4OA7QKf63/W9RBylnE
uZVbagsSGIrljJKZJ4qXYapvRyGxwQt9w1Q59Ua9O0RtKpq4lZ5jTL/+nZ6/WE6/
YJd+VLlF/AXkbdbJ6uFG6M0XR9dLmfDjtAUip2erwQoaue81vhTLwYV5S3kb3K3Q
QGOLsQftX5oYyJJZlXmC5BnzVU8sflWyBGUtHPRB5uXtcVDSs+ArcR2qfqeiaUz2
Hp1BKP6PPkcVuLmxU0EIayuA/jCd6nd05mQXqBwhhmwkc3gglyXTYdX/vjsBjKuC
eAskn1i+zcDZ7mya4lyHHaGe92vPAzdn8sRDzoauPkLjLsY7oykfejyxzKPKy1KU
V1ZNcNurjeJwbVtcpUCZSQbBTdiLVXsljbNPN0iz0BpB6BPvoV8bZpXLgEIc/mfj
FD+umi+PIzo=
=Ft6V
-----END PGP SIGNATURE-----

--Sig_/KJiG/jxIer2AKvS/1vtY_1Z--
