Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbaCRPMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:12:15 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:50988 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbaCRPMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:12:13 -0400
Date: Tue, 18 Mar 2014 15:48:51 +0100
From: Simon Guinot <simon.guinot@sequanux.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?UsOpbWkgUsOpcm9sbGU=?= <remi.rerolle@seagate.com>
Subject: Re: [PATCH 0/2] md: fix fix deadlock while suspending RAID array
Message-ID: <20140318144850.GE14452@kw.sim.vm.gnt>
References: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="juZjCTNxrMaZdGZC"
Content-Disposition: inline
In-Reply-To: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--juZjCTNxrMaZdGZC
Content-Type: multipart/mixed; boundary="/2994txjAzEdQwm5"
Content-Disposition: inline


--/2994txjAzEdQwm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2014 at 08:12:08PM +0100, Simon Guinot wrote:
> Hi,
>=20
> This patch series fixes a deadlock which have been observed while
> updating a RAID array level, using the mdadm --grow command. A full
> description of the issue (hopefully understandable enough) is provided
> by the commit message in the second patch.
>=20
> Please, let me know if this patches are correct and/or if there is an
> another way (maybe more handy) to solve this deadlock issue.

Hi Neil,

Please, let me know your feedback about this bug and the patches.

Additionally, you will find attached to this email a shell script which
allows to reproduce the deadlock (with most of the configurations).
Basically, this script creates some loopback devices on the top of files
(size 10MB) stored under /tmp. In an infinite loop, the loopback devices
are used to create a RAID1 array and then to migrate this last into a
RAID5 one. At some point, you should hit the deadlock.

Thanks,

Simon

>=20
> Thanks,
>=20
> Simon
>=20
> Simon Guinot (2):
>   md: move up mddev locking functions
>   md: fix deadlock while suspending RAID array
>=20
>  drivers/md/md.c | 154 ++++++++++++++++++++++++++++++--------------------=
------
>  1 file changed, 83 insertions(+), 71 deletions(-)
>=20
> --=20
> 1.8.5.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--/2994txjAzEdQwm5
Content-Type: application/x-sh
Content-Disposition: attachment; filename="md-suspend-deadlock.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A=0AARRAY_ID=3D0=0Awhile grep -q md$ARRAY_ID /proc/mdstat > /dev=
/null 2>&1; do=0A    ARRAY_ID=3D$(($ARRAY_ID + 1))=0Adone=0AARRAY=3D/dev/md=
$ARRAY_ID=0A[ -z "$TMP_DIR" ] && TMP_DIR=3D/tmp=0Als /dev/loop0 > /dev/null=
 2>&1 || modprobe loop=0ADRIVE_SIZE_MB=3D10=0A=0Asetup() {=0A    [ ! -f "$T=
MP_DIR/hd0" ] && dd if=3D/dev/zero bs=3D1M count=3D$DRIVE_SIZE_MB of=3D$TMP=
_DIR/hd0=0A    [ ! -f "$TMP_DIR/hd1" ] && dd if=3D/dev/zero bs=3D1M count=
=3D$DRIVE_SIZE_MB of=3D$TMP_DIR/hd1=0A    [ ! -f "$TMP_DIR/hd2" ] && dd if=
=3D/dev/zero bs=3D1M count=3D$DRIVE_SIZE_MB of=3D$TMP_DIR/hd2=0A    LOOP0=
=3D$(losetup -f); losetup $LOOP0 $TMP_DIR/hd0=0A    LOOP1=3D$(losetup -f); =
losetup $LOOP1 $TMP_DIR/hd1=0A    LOOP2=3D$(losetup -f); losetup $LOOP2 $TM=
P_DIR/hd2=0A}=0A=0Ateardown() {=0A    grep $ARRAY /proc/mounts && umount $A=
RRAY=0A    grep $ARRAY /proc/mdstat && mdadm --stop $ARRAY=0A    losetup | =
grep -q $LOOP0 && losetup -d $LOOP0=0A    losetup | grep -q $LOOP1 && loset=
up -d $LOOP1=0A    losetup | grep -q $LOOP2 && losetup -d $LOOP2=0A}=0A=0Ac=
reate() {=0A    echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> CREATE <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"=0A    mdad=
m --zero-superblock $LOOP0 $LOOP1 $LOOP2 > /dev/null 2>&1=0A    echo y | md=
adm --create $ARRAY -l1 -n2 -e1.0 --assume-clean $LOOP0 $LOOP1  > /dev/null=
 2>&1=0A    mkfs.ext2 -T ext4 $ARRAY > /dev/null 2>&1=0A    mount -t ext4 $=
ARRAY /mnt=0A    sleep 2=0A}=0A=0Amigrate() {=0A    echo "=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> MIGR=
ATE <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D"=0A    backup_file=3D$TMP_DIR/backup-$(basename $ARRA=
Y)=0A    [ -f "$backup_file" ] && rm $backup_file=0A    mdadm --add $ARRAY =
$LOOP2=0A    mdadm --grow $ARRAY -l5 -n3 --backup-file=3D$backup_file=0A   =
 mdadm --wait $ARRAY=0A    sleep 2=0A}=0A=0Adestroy() {=0A    echo "=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D> DESTROY <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"=0A    umount /mnt=0A    mdadm --stop $ARRAY=
=0A    while [ $? -ne 0 ]; do sleep 1; mdadm --stop $ARRAY; done=0A}=0A=0Ar=
un_test() {=0A    while true; do=0A        rmmod raid456 async_raid6_recov =
async_memcpy async_pq async_xor xor async_tx raid6_pq=0A        create=0A  =
      migrate=0A        destroy=0A    done=0A}=0Asetup=0Atrap teardown EXIT=
 INT TERM=0Arun_test=0A
--/2994txjAzEdQwm5--

--juZjCTNxrMaZdGZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlMoXNIACgkQgtp0PDeOcDpb2wCfVvo5dCOpaHDtGtLmnln6HhJO
W78AoJ8MZfyS4MsnuoODBlV4w0wYz4L6
=7Hw7
-----END PGP SIGNATURE-----

--juZjCTNxrMaZdGZC--
