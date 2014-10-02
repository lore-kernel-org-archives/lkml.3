Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaJBEE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 00:04:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaJBEEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 00:04:25 -0400
Date: Thu, 2 Oct 2014 14:04:10 +1000
From: NeilBrown <neilb@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Shaohua Li <shli@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [dm-devel] dm-raid: add RAID discard support
Message-ID: <20141002140410.1b379f74@notabene.brown>
In-Reply-To: <20141002120049.58dba551@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
	<20141001133237.GB16521@redhat.com>
	<20141002093403.25cc832f@notabene.brown>
	<20141002013135.GA21091@redhat.com>
	<20141002120049.58dba551@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/0AyWikMcAkej.VCMJqRbFG_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0AyWikMcAkej.VCMJqRbFG_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


I plan to submit this to Linus tomorrow, hopefully for 3.7, unless there are
complaints. It is in my for-next branch now.

Thanks,
NeilBrown


=46rom aec6f821ed92fac5ae4f1db50279a3999de5872a Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 2 Oct 2014 13:45:00 +1000
Subject: [PATCH] md/raid5: disable 'DISCARD' by default due to safety
 concerns.

It has come to my attention (thanks Martin) that 'discard_zeroes_data'
is only a hint.  Some devices in some cases don't do what it
says on the label.

The use of DISCARD in RAID5 depends on reads from discarded regions
being predictably zero.  If a write to a previously discarded region
performs a read-modify-write cycle it assumes that the parity block
was consistent with the data blocks.  If all were zero, this would
be the case.  If some are and some aren't this would not be the case.
This could lead to data corruption after a device failure when
data needs to be reconstructed from the parity.

As we cannot trust 'discard_zeroes_data', ignore it by default
and so disallow DISCARD on all raid4/5/6 arrays.

As many devices are trustworthy, and as there are benefits to using
DISCARD, add a module parameter to over-ride this caution and cause
DISCARD to work if discard_zeroes_data is set.

If a site want to enable DISCARD on some arrays but not on others they
should select DISCARD support at the filesystem level, and set the
raid456 module parameter.
    raid456.devices_handle_discard_safely=3DY

As this is a data-safety issue, I believe this patch is suitable for
-stable.
DISCARD support for RAID456 was added in 3.7

Cc: Shaohua Li <shli@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>
Cc: stable@vger.kernel.org (3.7+)
Fixes: 620125f2bf8ff0c4969b79653b54d7bcc9d40637
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 183588b11fc1..9f0fbecd1eb5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -64,6 +64,10 @@
 #define cpu_to_group(cpu) cpu_to_node(cpu)
 #define ANY_GROUP NUMA_NO_NODE
=20
+static bool devices_handle_discard_safely =3D false;
+module_param(devices_handle_discard_safely, bool, 0644);
+MODULE_PARM_DESC(devices_handle_discard_safely,
+		 "Set to Y if all devices in each array reliably return zeroes on reads =
from discarded regions");
 static struct workqueue_struct *raid5_wq;
 /*
  * Stripe cache
@@ -6208,7 +6212,7 @@ static int run(struct mddev *mddev)
 		mddev->queue->limits.discard_granularity =3D stripe;
 		/*
 		 * unaligned part of discard request will be ignored, so can't
-		 * guarantee discard_zerors_data
+		 * guarantee discard_zeroes_data
 		 */
 		mddev->queue->limits.discard_zeroes_data =3D 0;
=20
@@ -6233,6 +6237,18 @@ static int run(struct mddev *mddev)
 			    !bdev_get_queue(rdev->bdev)->
 						limits.discard_zeroes_data)
 				discard_supported =3D false;
+			/* Unfortunately, discard_zeroes_data is not currently
+			 * a guarantee - just a hint.  So we only allow DISCARD
+			 * if the sysadmin has confirmed that only safe devices
+			 * are in use by setting a module parameter.
+			 */
+			if (!devices_handle_discard_safely) {
+				if (discard_supported) {
+					pr_info("md/raid456: discard support disabled due to uncertainty.\n");
+					pr_info("Set raid456.devices_handle_discard_safely=3DY to override.\n=
");
+				}
+				discard_supported =3D false;
+			}
 		}
=20
 		if (discard_supported &&

--Sig_/0AyWikMcAkej.VCMJqRbFG_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCzOuznsnt1WYoG5AQIB4xAAvzMtpITo0/kg1yF2RHNL0rU++YL7FZjh
z5ZVX1k5NU+MZWOZ+FA1zloLbY+oBxJAMYx1AjqqxSzTmH2BbXWKqbcCDBnxR0yw
706xAk+tYiJwNxE5wNxpdhxHWT9W2jIwBWYlSRThG5m0+L5UrmWBjzGjJ4eWySxG
b212kCzfmQd89b0v/e/r6CLQsVr0PQTl+de3Nvi4n0LgSAztc+T9ru8l+4VJJu5V
2La6iDjzyM7VrIuLBRCZaM01WWYC7mawONQ2O9tpJ4o7fixFXah7OtydyUvcdZcn
jWe8Qbz3m8QZ562CIKiRcuAssOzmSdru5ZE06jqnFWuUk5+DLK7M8+m7k0D3jF4M
9PE8uffr+RRSOHU5zR8sYiCE78hfBCWolzTOtdqFVxbtzGVvo2oslasXNUhFsJK3
9spW6C+SvC9XLGuuA673x67FQz9WTMyWpyCR7pg0TOhLmKpPyP5I2Ghd89a9MLDY
7zXskk8S34kATRUxBkXb2ms+BIX/2u33sacRUF9hZ+HPPm29kaFG0KYQJ+FUXH1h
9hllPzxIDW09coB1KBjN+kKuxR3uYmdVw8qKrGLS6MkzkR7FCyR1NbMl8lPwiLOs
xZsbxVlpFFIbOjPIpt3cK6dnb779CpM81uh4VmBmy82YY0gy/4XmUHN48884txW0
lVA16iZfVeY=
=TW1W
-----END PGP SIGNATURE-----

--Sig_/0AyWikMcAkej.VCMJqRbFG_--
