Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaDCSOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:14:02 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:45739 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaDCSN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:13:57 -0400
Message-ID: <533DA4DE.40408@archlinux.org>
Date: Thu, 03 Apr 2014 20:13:50 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dave Reisner <d@falconindy.com>, linux-kernel@vger.kernel.org
CC: tj@kernel.org
Subject: Re: Initramfs FSID altered in 3.14
References: <20140403175744.GE585@rampage>
In-Reply-To: <20140403175744.GE585@rampage>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i8s1NDBLn8IQAMVvnJv3Oini4Pl3PFJRH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i8s1NDBLn8IQAMVvnJv3Oini4Pl3PFJRH
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 03.04.2014 19:57, schrieb Dave Reisner:
> Hi,
>=20
> [This is a repost of a G+ post at Tejun's request]
>=20
> With Linux 3.14, you might notice in /proc/self/mountinfo that your
> root's parent FSID is now 0, instead of the 1 that it's been for the
> last N years. Tejun wrote the change (9e30cc9595303b27b48) that caused
> this, but the change comes in a rather innocuous way. Instead of an
> internal kernel mount of sysfs being assigned 0, it's now the initramfs=
=2E
>=20
> So far, this has already caused switch_root and findmnt (from
> util-linux) to break, cp (from coreutils) to break when using the -x
> flag in early userspace, and it's also been pointed out that systemd's
> readahead code makes assumptions about a device number of 0.
>=20
> Are we now supposed to go and change all the assumptions in userspace
> about 0 being special? I'm conflicted. The kernel isn't supposed to
> break userspace, but it seems to me that FSIDs were never something to
> rely on -- similar to the block device numbering scheme.

Most of these bugs were not caused by rootfs' FSID being different from
1, but rather because there was a file system with FSID 0.

Only util-linux/switch_root assumed that rootfs always had exactly FSID
1 - which is IMO a wrong assumption.

However, tt seems that people have been assuming that st_dev > 0 for a
while. If we want to revert this in the kernel, this patch (untested)
should be sufficient:

diff --git a/fs/super.c b/fs/super.c
index 80d5cf2..d9fddde 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -802,7 +802,7 @@ void emergency_remount(void)
 static DEFINE_IDA(unnamed_dev_ida);
 static DEFINE_SPINLOCK(unnamed_dev_lock);/* protects the above */
-static int unnamed_dev_start =3D 0; /* don't bother trying below it */
+static int unnamed_dev_start =3D 1; /* don't bother trying below it */
 int get_anon_bdev(dev_t *p)
 {



--i8s1NDBLn8IQAMVvnJv3Oini4Pl3PFJRH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTPaTgAAoJEChPw0yOSxol4IIP/0yMhbbkEuV8Cawja10f+y/4
b/xRXRNgEt6nbq6RHqnKk+h2TmhgQ9SbH02DLIQY19F08lGhWBkWKy1P4EZ74aV5
MgJVYEVK7jt21CpO/+pytZs+ci+ELNnaDVenF63fedM3tY3tHRa2dVYq0KEXybdm
xI77tpUORNKVbveRlzBmXNPmnOZbXQpb+cX7d/givG89IplLk+p7WemzaQ8+kYBw
DsnOuqmjfiod6R6axxnQynSkpD4deonY7RAoi9LeSnyg+tpi7LE8/K0iE6LVzyVV
JsMNLy75i62TU+u+Ddg1tZ2Rs6lz1OaX6RuFRqTy4PXA8zZVynRo9dcZU25DhgsN
PcNFJJG2R8+/NUuOXVthYCrb/pEpMbGZVfDqnzjvTQS/xFBPbHu70hjGWLXiF8L3
EozXN9g3DGiaQ7FEXfCRVvRRwENJrpitKCmGjiVL4xYqBDW7CPsMkrhIWWXUAsJM
vWv0h8sa92jPBmv2X8mtKaKYqTPl8A5FPfuSExaQPGcMBKdbGO/7BYWN9KgvG3f4
cYBlkVVK6lEaVNDLpsv4irmdiqbQV9AL0N+n72zDuH2GoEdAe4r/7zFfMWm/1SjM
/PkO3noDcTYRGoISmjG+SrWemoKyIknZr20APndXT3wJNpX1g7nijBZ7oGtNawrf
FLIoi6UnU+yYuFUaxw6g
=TPdy
-----END PGP SIGNATURE-----

--i8s1NDBLn8IQAMVvnJv3Oini4Pl3PFJRH--
