Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3H0DtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:49:21 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:47879 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3H0DtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:49:19 -0400
Date: Tue, 27 Aug 2013 07:48:43 +0400
From: Andrew Savchenko <bircoph@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, viro@zeniv.linux.org.uk,
        suspend-devel@lists.sourceforge.net
Subject: Re: [BUG] 3.7-rc regression bisected: s2disk fails to resume image:
 Processes could not be frozen, cannot continue resuming
Message-Id: <20130827074843.ba1b6f62cc0a6dca8e47c06c@gmail.com>
In-Reply-To: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com>
References: <20130812234415.7db639bb0d664e56b6ab2ab2@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Aug_2013_07_48_43_+0400_CL.jnCuWb39YUep0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_07_48_43_+0400_CL.jnCuWb39YUep0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, 12 Aug 2013 23:44:15 +0400 Andrew Savchenko wrote:
> after a kernel update from 3.5.7 to the latest stable I found that
> user-space resume (from suspend-1.0 aka uswsusp) no longer works.
> Kernel-space suspend and resume work fine (e.g. echo disk
> > /sys/power/state), problem is with user-space support. (I need
> user-space version because it supports image encryption.)
>=20
> After resume (essentially linuxrc) application loads image it fails
> to apply it:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> Processes could not be frozen, cannot continue resuming.
> Error 11: Resource temporarily unavailable
>=20
> You can now boot the system and lose the saved state
> or reboot and try again.
>=20
> [Notice that if you decide to reboot, you MUST NOT mount
> any filesystems before a successful resume.
> Resuming after some filesystems have been mounted
> will badly damage these filesystems.]
>=20
> Do you want to continue booting (Y/n)?
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>=20
> Error code wasn't originally showed, I added it to suspend tool to
> aid debugging. Essentially freeze ioctl on /dev/snapshot fails with
> this error.
>=20
> I bisected a commit which introduces this bug:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> commit ba4df2808a86f8b103c4db0b8807649383e9bd13=20
> Author: Al Viro <viro@zeniv.linux.org.uk>=20
> Date:   Tue Oct 2 15:29:10 2012 -0400=20
>=20
>     don't bother with kernel_thread/kernel_execve for launching
> linuxrc=20
>     exec_usermodehelper_fns() will do just fine...=20
>    =20
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>=20
> In fact this commit induced/triggered at least two bugs: the first one
> I'm facing now and the second one was fixed in commit
> f0de17c0babe7f29381892def6b37e9181a53410:
> make sure that /linuxrc has std{in,out,err}.
>=20
> As a temporarily workaround for this issue I reverted all changes for
> init/do_mounts_initrd.c up to the latest working commit
> cb450766bcafc7bd7d40e9a5a0050745e8c68b3e considering the kernel API
> changes (kernel_execve -> sys_execve). See linuxrc-workaround.patch.
> I understand this isn't a proper solution, I just want to show what
> code works for me.
>=20
> I also found an interesting LKML discussion about s2disk and freezer
> issue: http://www.spinics.net/lists/linux-nfs/msg38160.html
> Maybe it is related to this bug, but patch proposed there doesn't in
> my case.
>=20
> Kernel config which fails with
> ba4df2808a86f8b103c4db0b8807649383e9bd13 and works with
> f0de17c0babe7f29381892def6b37e9181a53410 is also attached.
>=20
> As this issue maybe hardware related, the system is 32-bit EEE PC
> 1000H with Atom N270, 2GB RAM, 750 GB SATA drive.
>=20
> Additional (but probably useless) information on this bug may be found
> here: https://forums.gentoo.org/viewtopic-p-7371120.html

This bug is still here with 3.11-rc7 and 3.10.9.
I opened a kernel bug 60802 for this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=3D60802

Any ideas?

Best regards,
Andrew Savchenko

--Signature=_Tue__27_Aug_2013_07_48_43_+0400_CL.jnCuWb39YUep0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJSHCG1AAoJEFZZU7lTcnVsIuMP+gO5gi9xzulMwXr+aVpVCP6B
gHn2QGE7MiX+KNuq+seG0fTbfdkXwJTFmHYGm0BnH8y5DMavMil0IFE+JtpTzW0U
CJ7/HxqA23cs7eDz6v+93rqAnhGy0q0MaUZ4+77A+lazy7kP9DdWuicxVaxTDBZq
ok/6dm675Emo2XuPSKWkyhcRnxkg0bgBpq7abayyyBlGZjIbf6F066xQ4sfR6KmX
Nl7+9lzkGKVo41loI1GVVVm3hzrVla2VuhfuD+NxZ93yicdTtUiqDLZ2JQzhMfmj
xQSJghcQsec1x87uedFr1QLg4m44+dBgnL6XKFTIo1YnDo/ABFQ7EV7W9Xc9B5zL
t6O4Ym941+d+XyZ2U6+YWwLyh2CEvvci5eVUQ03+EEn3p3BRdub79+Styc1yYVah
ru9bLnFrgywmH3W+vJtXSkz0gEHKObJo/NJKZaXCbw76IeTHK3SzFP1KJ8HUAq5n
Aqin2Sb4udbIckve2sS1iS+kg8zzqOkLsFVzjaJky8rwCyYTSIFGJig+BRkMsEc6
pGmrkmJTcCYIL0twuiDNpN8QI5aCfnmujtrrGfvFQhrhwcMoEs6kNanE3rgBF999
Vpz1kvPN/XKbFNB74gJuPhIa/2w4LuEEzaCdVKeilVDh9qJrXH0ex/SEq1harb9f
hLJp03ZXNyJjrYN1sBHA
=yoXa
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_07_48_43_+0400_CL.jnCuWb39YUep0--
