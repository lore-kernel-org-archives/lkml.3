Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaAOB6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:58:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaAOB5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:57:52 -0500
Date: Wed, 15 Jan 2014 12:57:40 +1100
From: NeilBrown <neilb@suse.de>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: livelock during MD device open
Message-ID: <20140115125740.160e8998@notabene.brown>
In-Reply-To: <52D57086.1000508@freebox.fr>
References: <52D57086.1000508@freebox.fr>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hD6jsUlw5zaVqdeWk1=GsA1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hD6jsUlw5zaVqdeWk1=GsA1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Jan 2014 18:14:46 +0100 Nicolas Schichan <nschichan@freebox.fr>
wrote:

>=20
>=20
> Hi,
>=20
> I have recently been trying to find the cause a livelock occurring during=
 MD=20
> device open.
>=20
> The livelock happens when a process tries to open an MD device for the
> first time and another opens the same MD device and sends an invalid
> ioctl:
>=20
> Process 1				Process 2
> ---------				---------
>=20
> md_alloc()
>    mddev_find()
>    -> returns a new mddev with
>       hold_active =3D=3D UNTIL_IOCTL
>    add_disk()
>    -> sends KOBJ_ADD uevent
>=20
> 					(sees KOBJ_ADD uevent for device)
> 					md_open()
> 					md_ioctl(INVALID_IOCTL)
> 					-> returns ENODEV and clears
> 					   mddev->hold_active
> 					md_release()
> 					  md_put()
> 					  -> deletes the mddev as
> 					     hold_active is 0
>=20
> md_open()
>    mddev_find()
>    -> returns a newly
>      allocated mddev with
>      mddev->gendisk =3D=3D NULL
> -> returns with ERESTARTSYS
>     (kernel restarts the open syscall)
>=20
>=20
> As to how to fix this, I see two possibilities:
>=20
> - don't set hold_active to 0 if err is -ENODEV in the abort_unlock
>    path in md_ioctl().
>=20
> - check cmd parameter early in md_ioctl() and return -ENOTTY if the
>    cmd parameter is not a valid MD ioctl.
>=20
> Please advise on the preferred way to fix this, I'll be glad to send a
> patch for whatever is the preferred solution.
>=20
> I have also a simple C program that I can send should you want to reprodu=
ce=20
> the issue.
>=20
> Regards,
>=20

That's a very small race you are consistently losing - if I understand
correctly.

In __blkdev_get:

 restart:

	ret =3D -ENXIO;
	disk =3D get_gendisk(bdev->bd_dev, &partno);
	if (!disk)
		goto out;
	owner =3D disk->fops->owner;

	disk_block_events(disk);
	mutex_lock_nested(&bdev->bd_mutex, for_part);


The "get_gendisk" calls into md_alloc (via md_probe) and then add_disk(),
which generates a uevent which is handled by udev.
And before the above code gets to the mutex_lock_nexted(), the process run =
by
udev must have opened the device (executing all that code above and more) a=
nd
issued the ioctl.

I guess it is possible, but happening every time to produce a live-lock
suggests that the scheduler must be encouraging that behaviour.  Presumably
this is a virtual machine with just one CPU ??

I suppose the best fix is, as you suggest, to avoid clearing hold_active for
invalid ioctls.  It feels a bit like papering over a bug, but I think the
only way to really fix it is to add extra locking to the above code sequence
and I don't want to do that.

Of your two suggestions I much prefer the second.  It will be more code, but
it is also more obviously correct.  The current code is rather messy with
respect to invalid ioctl commands.

I would be happy to accept a patch which aborted md_ioctl if the cmd wasn't
one of those known to md.

Thanks,
NeilBrown



--Sig_/hD6jsUlw5zaVqdeWk1=GsA1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtXrFDnsnt1WYoG5AQJBPg//VXLG99cKCH2fs5Qcxv1ZD3N4eoPj2W1B
waj5JozhBqc0s0hpcOmU4DdYDT3WSLzUpVBgYVnhHEr6zybtDZQiAelrKUkkWdtA
yJ17tyRds8UC+B39kSMXGk4EfRAoJjhFiaU0TJPm7vSSNxLIv5nGLseG3IWHrVzj
7pmZBIOO/y+wHRoxUX7cWJe2UBmQrlp5aolXCdF49ZYiZ1CNvlQP0p+DiGCYJeug
FoBOvUoIlJrHktmu0BFzwXq6p7yLrrPboXWNW7objh6A7UPMcVLhw5bumjrkWD5R
gsczGytQNcoQgMParUburY5tbKvh0z1BSsLRbdtSUxuLUBlX+/44yxaIHXz/R8Ya
Be5pwadjrOnR6g0DLhgAq3J/HieKpvJ5SiMSjF+lsXjAa1Y8oBn0TNz9AV4ZKqBM
Z22VE4YDkZbvH7p+1AUwwknl6rANpyod9s3ni3lSTdBkIriTgyK657Uou0sVRWpP
yXeFRmz+p4MnLhgOhO3RFGpCtDMFXYIcvI9eC+l6HqTHBA5bzaiq225kBBYO4r42
I7FH703BQdzh5pFUWO9LukYf3Jea7CKikFwmr5Gnz3CpNnA/wvEafvM15PQdM9cm
1U4aCzuENIm++HfnrTtoywKEoFhdHC7QdFok/CrIwdFAN+Jdi9x9mbocbQwTNkvb
asBJs1sYn1M=
=buwX
-----END PGP SIGNATURE-----

--Sig_/hD6jsUlw5zaVqdeWk1=GsA1--
