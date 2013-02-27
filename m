Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab3B0WLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:11:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab3B0WLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:11:31 -0500
Date: Thu, 28 Feb 2013 09:11:10 +1100
From: NeilBrown <neilb@suse.de>
To: Dan Williams <djbw@fb.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130228091110.7da87b53@notabene.brown>
In-Reply-To: <CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
References: <20130223074001.GA5199@www.outflux.net>
	<CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/EGhp9W_6F9VBExLmMm4Mfop"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/EGhp9W_6F9VBExLmMm4Mfop
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 26 Feb 2013 17:27:45 -0800 Dan Williams <djbw@fb.com> wrote:

> On Fri, Feb 22, 2013 at 11:40 PM, Kees Cook <keescook@chromium.org> wrote:
> > The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> > while now and is almost always enabled by default. As agreed during the
> > Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Alasdair G Kergon <agk@redhat.com>
> > ---
> >  drivers/md/Kconfig |    1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> > index 7cdf359..0cc3a3d 100644
> > --- a/drivers/md/Kconfig
> > +++ b/drivers/md/Kconfig
> > @@ -158,7 +158,6 @@ config MULTICORE_RAID456
> >         bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
> >         depends on MD_RAID456
> >         depends on SMP
> > -       depends on EXPERIMENTAL
>=20
> In this case MULTICORE_RAID456 and the related code should go as
> well... now that there are patches to supersede this implementation in
> md-next.
>=20

What a good idea.

Following will be in -next shortly.

NeilBrown


=46rom 51acbcec6c42b24482bac18e42befc822524535d Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 28 Feb 2013 09:08:34 +1100
Subject: [PATCH] md: remove CONFIG_MULTICORE_RAID456

This doesn't seem to actually help and we have an alternate
multi-threading approach waiting in the wings, so just get
rid of this config option and associated code.

As a bonus, we remove one use of CONFIG_EXPERIMENTAL

Cc: Dan Williams <djbw@fb.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 91a02ee..9a10313 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -154,17 +154,6 @@ config MD_RAID456
=20
 	  If unsure, say Y.
=20
-config MULTICORE_RAID456
-	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
-	depends on MD_RAID456
-	depends on SMP
-	depends on EXPERIMENTAL
-	---help---
-	  Enable the raid456 module to dispatch per-stripe raid operations to a
-	  thread pool.
-
-	  If unsure, say N.
-
 config MD_MULTIPATH
 	tristate "Multipath I/O support"
 	depends on BLK_DEV_MD
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 19d77a0..35031c8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1406,7 +1406,7 @@ static void ops_run_check_pq(struct stripe_head *sh, =
struct raid5_percpu *percpu
 			   &sh->ops.zero_sum_result, percpu->spare_page, &submit);
 }
=20
-static void __raid_run_ops(struct stripe_head *sh, unsigned long ops_reque=
st)
+static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
 {
 	int overlap_clear =3D 0, i, disks =3D sh->disks;
 	struct dma_async_tx_descriptor *tx =3D NULL;
@@ -1471,36 +1471,6 @@ static void __raid_run_ops(struct stripe_head *sh, u=
nsigned long ops_request)
 	put_cpu();
 }
=20
-#ifdef CONFIG_MULTICORE_RAID456
-static void async_run_ops(void *param, async_cookie_t cookie)
-{
-	struct stripe_head *sh =3D param;
-	unsigned long ops_request =3D sh->ops.request;
-
-	clear_bit_unlock(STRIPE_OPS_REQ_PENDING, &sh->state);
-	wake_up(&sh->ops.wait_for_ops);
-
-	__raid_run_ops(sh, ops_request);
-	release_stripe(sh);
-}
-
-static void raid_run_ops(struct stripe_head *sh, unsigned long ops_request)
-{
-	/* since handle_stripe can be called outside of raid5d context
-	 * we need to ensure sh->ops.request is de-staged before another
-	 * request arrives
-	 */
-	wait_event(sh->ops.wait_for_ops,
-		   !test_and_set_bit_lock(STRIPE_OPS_REQ_PENDING, &sh->state));
-	sh->ops.request =3D ops_request;
-
-	atomic_inc(&sh->count);
-	async_schedule(async_run_ops, sh);
-}
-#else
-#define raid_run_ops __raid_run_ops
-#endif
-
 static int grow_one_stripe(struct r5conf *conf)
 {
 	struct stripe_head *sh;
@@ -1509,9 +1479,6 @@ static int grow_one_stripe(struct r5conf *conf)
 		return 0;
=20
 	sh->raid_conf =3D conf;
-	#ifdef CONFIG_MULTICORE_RAID456
-	init_waitqueue_head(&sh->ops.wait_for_ops);
-	#endif
=20
 	spin_lock_init(&sh->stripe_lock);
=20
@@ -1630,9 +1597,6 @@ static int resize_stripes(struct r5conf *conf, int ne=
wsize)
 			break;
=20
 		nsh->raid_conf =3D conf;
-		#ifdef CONFIG_MULTICORE_RAID456
-		init_waitqueue_head(&nsh->ops.wait_for_ops);
-		#endif
 		spin_lock_init(&nsh->stripe_lock);
=20
 		list_add(&nsh->lru, &newstripes);

--Sig_/EGhp9W_6F9VBExLmMm4Mfop
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUS6Efjnsnt1WYoG5AQJbbA/9HhG6K+lnhFIhkMGNyxs4rs6nDCyEwQPw
fcHB2LQ0hfsZqZiZ3Q1rMeP7IwKI9P+jtRZgoFhdM/B0n0ASZwEqnetO7+ym415e
W98dqD4OdC0lK3Ry8ZIW9LoVwGbjwuS3gwJy4NynBVtrnnXRbdxmOnnT+Ma57ZZA
1x9eFVyca1WkmSE2FMhHdgOUw0YratzCPyP5FaSwxJHMQRQnfH3L0rZQWPwbhUZb
U3im1g8BASKWru9BWE5J/aroddLGwzKPMcWOi9j6djuvVvuhMxeI9vohfwoHdMK/
0SMsz2+1j6PEinOtKmIP4W3DoGtSBZOawcF00HnvqOps527fqkWD5zDf0rii950H
j3fh6mvzEGvmDse17r0D2CJH9whIdgMRgT02pvgHMwTQ9qhRXT2DrAOZMowyZQSd
//O7WPpOGfNS6Bnc5Hu4EU/XmRWP575SflgObmTamm8DwWL9zNS22jDZOG9MJYOR
+hh2AzIimYRUjA4OGFx/RudWcGUrKoABiEZRX10iL2Hoa0u9kMaZl1b5WTzymwbQ
OIhoMjjUmXxLNZ8uDPJWCLEDKBuD4QCLNxsvo0E26fkpRhjHID7TqEO8Nb6fGmzg
VxEgGd8iWZnoaeOoOdM7JlONA/dGOp/o1yi4u2yG1CdMYhsBth5tHg5foKy2kwkv
ziWP+eqNQI4=
=oNKE
-----END PGP SIGNATURE-----

--Sig_/EGhp9W_6F9VBExLmMm4Mfop--
