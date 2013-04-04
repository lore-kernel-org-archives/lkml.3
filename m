Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764866Ab3DDUbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:31:01 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:57235 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764003Ab3DDUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:31:00 -0400
X-Authority-Analysis: v=2.0 cv=XL2yuHdE c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=z55uD49gxukA:10 a=COy8bEXE5_QA:10 a=S1A5HrydsesA:10 a=fxJcL_dCAAAA:8 a=p-BZX3ACu3QA:10 a=B4b_7sLXiwL1hwJ14v4A:9 a=pILNOxqGKmIA:10 a=IVdq4P13A8TBZfKv:21 a=v7t9TdHflYM2TOe5:21 a=ImXnqaoifB7jbSX0JekA:9 a=QfKxxUxMAAAA:8 a=0Xpw0pVQFk0rD2PekuUA:9 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <515DE2FE.1080201@ubuntu.com>
Date: Thu, 04 Apr 2013 16:30:54 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: CAI Qian <caiqian@redhat.com>, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com> <247719576.438259.1364882929749.JavaMail.root@redhat.com> <20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk> <20130402073035.GD3670@kernel.dk> <14055702.547701.1364891947331.JavaMail.root@redhat.com> <20130402090047.GF3670@kernel.dk> <985125161.581860.1364895066584.JavaMail.root@redhat.com> <20130402094834.GA4667@kernel.dk> <20130403114142.GP4667@kernel.dk> <515C4D9D.10103@ubuntu.com>
In-Reply-To: <515C4D9D.10103@ubuntu.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2ASDWRAEQBRVKTGCVDNXI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ASDWRAEQBRVKTGCVDNXI
Content-Type: multipart/mixed;
 boundary="------------090601000806040302040407"

This is a multi-part message in MIME format.
--------------090601000806040302040407
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

> I have not tested it yet, but I am pretty sure it won't work.  It
> looks like the patch changes the BLKRRPART path to go ahead and remove
> existing partitions when GENHD_FL_NO_PARTSCAN is set.  loop doesn't
> issue the BLKRRPART ioctl when !LO_FLAGS_PARTSCAN so this won't help.
>  I think loop needs to set GENHD_FL_NO_PARTSCAN and then issue the
> ioctl regardless of the LO_FLAGS_PARTSCAN flag to get the partitions
> to be removed.  I will try to test tonight.

After testing, my initial thoughts appeared to have been correct.  I had
to modify the patch as follows.  To test, simply do:

truncate -s 10m img
losetup /dev/loop0 img
parted /dev/loop0
mklabel msdos
mkpart primary ext2 1m 2m
quit
ls /dev/loop0*

Note the /dev/loop0p1 node.  Run losetup -d /dev/loop0 and see if it is
still there.



--------------090601000806040302040407
Content-Type: text/plain; charset=windows-1252;
 name="loop.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="loop.diff"

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..8b78b5a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -155,7 +155,7 @@ static int blkdev_reread_part(struct block_device *bd=
ev)
 	struct gendisk *disk =3D bdev->bd_disk;
 	int res;
=20
-	if (!disk_part_scan_enabled(disk) || bdev !=3D bdev->bd_contains)
+	if (bdev !=3D bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 1cb4dec..0e7d637 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -430,6 +430,15 @@ rescan:
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
 	bdev->bd_invalidated =3D 0;
+
+	/*
+	 * If partition scanning is disabled, we are done.
+	 */
+	if (!disk_part_scan_enabled(disk)) {
+		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+		return 0;
+	}
+
 	if (!get_capacity(disk) || !(state =3D check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state)) {
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8bc6d39..326fac9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1039,11 +1039,9 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state =3D Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
-		ioctl_by_bdev(bdev, BLKRRPART, 0);
+	lo->lo_disk->flags |=3D GENHD_FL_NO_PART_SCAN;
+	ioctl_by_bdev(bdev, BLKRRPART, 0);
 	lo->lo_flags =3D 0;
-	if (!part_shift)
-		lo->lo_disk->flags |=3D GENHD_FL_NO_PART_SCAN;
 	mutex_unlock(&lo->lo_ctl_mutex);
 	/*
 	 * Need not hold lo_ctl_mutex to fput backing file.


--------------090601000806040302040407--

------enig2ASDWRAEQBRVKTGCVDNXI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRXeMBAAoJEJrBOlT6nu75C5QH+gOP9Mea7HorJ/XLfuoeMlWQ
4aTN0BeGDTfK39DzazN3NyAiftmKeqAzFI0g7YkR3CZzab+vG+0T6IcXFB/NYcwl
7+u+e/VcQecssvM0s614uMULaQ5Ou2MVE1inUjFNfIev1lu02l6pMv6m7yqp5fP1
ZJRx6VPhhNH+tZYrVaVNVwxJUMtoprRLpx3mXdWn4BGsd7J5mPBitJbY3o/gEsx/
dE6EZMOlFDBvsJ+YO4AsDdlif5s5T4geWC9L32zhDxdsedT6WMmyr302MQ0b6CZU
1Wxv71kL9gcDfXWkRwXtozfJV93avT1Kpa3Appb0648tQ/o90QzfSfBmN+2v3qM=
=E2HM
-----END PGP SIGNATURE-----

------enig2ASDWRAEQBRVKTGCVDNXI--
