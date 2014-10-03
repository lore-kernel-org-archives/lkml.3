Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaJCFiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:38:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaJCFiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:38:16 -0400
Date: Fri, 3 Oct 2014 15:38:01 +1000
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaohua Li <shli@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>
Subject: [GIT PULL REQUEST] one last-minute update for md/raid5
Message-ID: <20141003153801.7cd83266@notabene.brown>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/blMCYqA47lJao73nKoxOIyF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/blMCYqA47lJao73nKoxOIyF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Linus,
 I hope this is in time for 3.17...
 It turns out that 'discard_zeroes_data' is not a guarantee, and RAID4/5/6
 really depends on it for DISCARD to be handled safely.
 So it is safest to default to disabling DISCARD on these arrays until some
 sort of whitelist arrangement can be found.

Thanks,
NeilBrown


The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://neil.brown.name/md tags/md/3.17-final-fix

for you to fetch changes up to 8e0e99ba64c7ba46133a7c8a3e3f7de01f23bd93:

  md/raid5: disable 'DISCARD' by default due to safety concerns. (2014-10-0=
2 13:45:00 +1000)

----------------------------------------------------------------
One fix for raid5 discard issue.

----------------------------------------------------------------
NeilBrown (1):
      md/raid5: disable 'DISCARD' by default due to safety concerns.

 drivers/md/raid5.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)
commit 8e0e99ba64c7ba46133a7c8a3e3f7de01f23bd93
Author: NeilBrown <neilb@suse.de>
Date:   Thu Oct 2 13:45:00 2014 +1000

    md/raid5: disable 'DISCARD' by default due to safety concerns.
   =20
    It has come to my attention (thanks Martin) that 'discard_zeroes_data'
    is only a hint.  Some devices in some cases don't do what it
    says on the label.
   =20
    The use of DISCARD in RAID5 depends on reads from discarded regions
    being predictably zero.  If a write to a previously discarded region
    performs a read-modify-write cycle it assumes that the parity block
    was consistent with the data blocks.  If all were zero, this would
    be the case.  If some are and some aren't this would not be the case.
    This could lead to data corruption after a device failure when
    data needs to be reconstructed from the parity.
   =20
    As we cannot trust 'discard_zeroes_data', ignore it by default
    and so disallow DISCARD on all raid4/5/6 arrays.
   =20
    As many devices are trustworthy, and as there are benefits to using
    DISCARD, add a module parameter to over-ride this caution and cause
    DISCARD to work if discard_zeroes_data is set.
   =20
    If a site want to enable DISCARD on some arrays but not on others they
    should select DISCARD support at the filesystem level, and set the
    raid456 module parameter.
        raid456.devices_handle_discard_safely=3DY
   =20
    As this is a data-safety issue, I believe this patch is suitable for
    -stable.
    DISCARD support for RAID456 was added in 3.7
   =20
    Cc: Shaohua Li <shli@kernel.org>
    Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
    Cc: Mike Snitzer <snitzer@redhat.com>
    Cc: Heinz Mauelshagen <heinzm@redhat.com>
    Cc: stable@vger.kernel.org (3.7+)
    Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
    Acked-by: Mike Snitzer <snitzer@redhat.com>
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

--Sig_/blMCYqA47lJao73nKoxOIyF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVC42OTnsnt1WYoG5AQLgfxAAmuyhWBx2dB1gDyBKd2vkfYHZkD0aks+F
Xk7OEyI5n6X8HmExl+49B/PLE3Gbcif7QpC4Z92ifuxoOPScgYAxkSHh2fXhnN5K
gYsnB7+55H2OnlaW3VmS5xsoQ5IWqQj6DGk0O+HrpVv/qSJF0RpD1S0cJrF14Kto
11xUNWm8H+/IVsAyB7SiaRvf4IfxeSWx4xlZQozugWJ0EAP8YoVyQemgHO8Hqf2+
TJeKznx+3iPfiyaF+YykXqkwXvWb0gr2QO35MCGCRLWUl10koQ+dlq3XuZs2RYvI
D4iTA2ERBEBMJU1PN9wynQmoKxRoYbXi+hVcbT+GksXjyo6yY9Lc0Yd5zBoSv1yV
R7fw0elHMn4NmxA+Cr+8hZx7kTgF3l2lyQOOxDCeuTOZ4iR95AAwoE5DqvcaNUPp
jNIlVBopokWQaFVUkIP17gUZYYledjR9hTaHtEcvv02QFSU8ztfqicRrBO1R5Bjr
uoRLDvMDjw96DJAMKg1VgiP8LXliNYXi9PwSXDuQPFL7yu5vSzt9caW3AONgZIY8
ALZ9yfZRpxKyWE+hoAHgHJyO8WUaueMmJt5K/6+MsRTH6nxvpo2pWMm8QR000K2S
u4/T+0su5i7rwN5lcT4kyhesZWMdQ/Qi/QITdZuD9sPU0O/PkBZUhmLn1K34wlrP
bbKpkxybMwo=
=SYYL
-----END PGP SIGNATURE-----

--Sig_/blMCYqA47lJao73nKoxOIyF--
