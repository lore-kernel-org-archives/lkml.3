Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaHRGQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:16:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaHRGQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:16:38 -0400
Date: Mon, 18 Aug 2014 16:16:24 +1000
From: NeilBrown <neilb@suse.de>
To: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: "Manibalan P" <pmanibalan@amiindia.co.in>,
        Dan Williams <dan.j.williams@intel.com>,
        Yuri Tikhonov <yur@emcraft.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, stable@vger.kernel.org
Subject: ALERT: md/raid6 data corruption risk.
Message-ID: <20140818161624.7176991f@notabene.brown>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/h+nr1f+vI=rg.cU8rGhF+bx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/h+nr1f+vI=rg.cU8rGhF+bx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi all,
 There is a risk of data loss with md/raid6 arrays running on Linux since
 2.6.32.
 If:
   - the array is doubly degraded
   - one or both failed devices are being recovered, and
   - the array is written to

 then it is possible for data on the array to be lost.  The patch below fix=
es
 the problem.  If you apply the patch to an older kernel which has separate
 handle_stripe5() and handle_stripe6() functions, be sure that patch changes
 handle_stripe6().

 There is no risk to an optimal array or a singly-degraded array.  There is
 also no risk on a doubly-degraded array which is not recovering a device or
 is not receiving write requests.

 If you have data on a RAID6 array, please consider how to avoid corruption,
 possibly by applying the patch, possibly by removing any hot spares so
 recovery does not automatically start.

 This patch will be sent upstream shortly and will subsequently appear in
 future "-stable" kernels.

NeilBrown

=46rom f94e37dce722ec7b6666fd04be357f422daa02b5 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 13 Aug 2014 09:57:07 +1000
Subject: [PATCH] md/raid6: avoid data corruption during recovery of
 double-degraded RAID6

During recovery of a double-degraded RAID6 it is possible for
some blocks not to be recovered properly, leading to corruption.

If a write happens to one block in a stripe that would be written to a
missing device, and at the same time that stripe is recovering data
to the other missing device, then that recovered data may not be written.

This patch skips, in the double-degraded case, an optimisation that is
only safe for single-degraded arrays.

Bug was introduced in 2.6.32 and fix is suitable for any kernel since
then.  In an older kernel with separate handle_stripe5() and
handle_stripe6() functions that patch must change handle_stripe6().

Cc: stable@vger.kernel.org (2.6.32+)
Fixes: 6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8
Cc: Yuri Tikhonov <yur@emcraft.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: "Manibalan P" <pmanibalan@amiindia.co.in>
Resolves: https://bugzilla.redhat.com/show_bug.cgi?id=3D1090423
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6b2d615d1094..183588b11fc1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3817,6 +3817,8 @@ static void handle_stripe(struct stripe_head *sh)
 				set_bit(R5_Wantwrite, &dev->flags);
 				if (prexor)
 					continue;
+				if (s.failed > 1)
+					continue;
 				if (!test_bit(R5_Insync, &dev->flags) ||
 				    ((i =3D=3D sh->pd_idx || i =3D=3D sh->qd_idx)  &&
 				     s.failed =3D=3D 0))

--Sig_/h+nr1f+vI=rg.cU8rGhF+bx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/GaODnsnt1WYoG5AQKcvRAAoEcdWHs2QIeatehf8GKko5UFelknfSyV
mbMTcMLJ/9DAN0dafkzMerDNr+oRqSqamsCbt5MNe73Epp4pMBGp+t/zx0eraKfA
qZv3LKYVT+NVfGJWfSNP5sBsduLKRSehoEHk/V1idneT1545LkUjdN24LbDA6Adu
W5BzTt0UoQqx5HFwlfUQDnLG2MyNyyZPFRbfiviXAVZZ/L8xv67WDtc2uhPJDtnF
dB4wE2qStOz+7fOxQuF1/bRC43wsVYqGkB3qXcowjqQYvxbd6ZpmPpylhuoktW8t
LDaJ34UEotAXQf3OWcHQydmzrgSp/+krfie1EufZNo3zVYnZyDF4hOT9UiTIJ0qU
BbBF8jRDKCWx3tylvYaPaOL4VDovnOtIzC8aYYyjTIw7i5WIaK9V00YHO6d8oLYx
jCHgcw78o1ZeMv1bgUvvH006OrjfxAKbWAgRuGLgX71yj1BUncR7bqQ2NtcGNyL5
Up8YryRHd7mwWMCrLMehQ/zAH6TEHpPO7FTOVA3zhwl4KS+jLr/TBAvdijIkTPAv
PP8fVMXOlNNy7qTS71A5aDcV6j4U9/LE9kUZFrZYH8PIMnvpWHs+zt4cTaWRgBrq
eN3McaehqI2w/i+7peJ9DNdXF6zP6yTZ9NshVo6TvMoXTo5xvkXteiaOm3fajSyS
0IJVSUYQGXE=
=udRr
-----END PGP SIGNATURE-----

--Sig_/h+nr1f+vI=rg.cU8rGhF+bx--
