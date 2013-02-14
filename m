Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab3BNL4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:56:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44170 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379Ab3BNL4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:56:39 -0500
Message-ID: <511CD0EC.6070200@pengutronix.de>
Date: Thu, 14 Feb 2013 12:56:28 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: SELinux + ubifs: possible circular locking dependency
References: <51123C80.2050400@pengutronix.de>   <5115076E.3070703@pengutronix.de>  <1360759673.12703.147.camel@sauron.fi.intel.com>  <511BA51E.9000606@pengutronix.de> <1360826119.12703.155.camel@sauron.fi.intel.com>
In-Reply-To: <1360826119.12703.155.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2RJSIJWESRBKEJLANCBSP"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2RJSIJWESRBKEJLANCBSP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/14/2013 08:15 AM, Artem Bityutskiy wrote:
> Mark, how about this one? I compiled it and ran on my fedora 16 with
> SElinux enabled, no obvious issues.
>=20
> From a19350097200570571aa522afebb96b34db534f4 Mon Sep 17 00:00:00 2001
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Date: Thu, 14 Feb 2013 09:07:36 +0200
> Subject: [PATCH] selinux: do not confuse lockdep
>=20
> Selinux has per-inode mutexes called 'isec->lock', and they are initial=
ized in
> the same place, which makes lockdep treat all of the them as if they we=
re
> identical. However, locking rules may be a little bit different dependi=
ng on
> the file-system, so we should put these locks to separate classes, just=
 like we
> do for 'i_mutex'. Namely, we should put them to per-FS type classes, wh=
ich is
> exactly what this patch does.
>=20
> The problem this patch intends to fix is a strange lockdep warning, whi=
ch I,
> frankly speaking, do not really understand, but I believe the root-caus=
e should
> be fixed by this patch.

Thanks, this works with mainline, but not with my xattr patch series
applied.

I get this warnings:

> [   13.659593] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   13.665781] [ INFO: possible circular locking dependency detected ]
> [   13.672062] 3.8.0-rc7-00011-gd50987e #113 Not tainted
> [   13.677125] -------------------------------------------------------
> [   13.683406] touch/81 is trying to acquire lock:
> [   13.687968]  (&sb->s_type->i_mutex_key#10){+.+...}, at: [<c0178330>]=
 ubifs_init_security+0x24/0x5c
> [   13.697031]
> [   13.697031] but task is already holding lock:
> [   13.702906]  (&ui->ui_mutex){+.+...}, at: [<c0152a98>] ubifs_create+=
0xb4/0x1ec
> [   13.710218]
> [   13.710218] which lock already depends on the new lock.
> [   13.710218]
> [   13.718406]
> [   13.718406] the existing dependency chain (in reverse order) is:
> [   13.725906]
> -> #1 (&ui->ui_mutex){+.+...}:
> [   13.730250]        [<c00548f0>] lock_acquire+0x64/0x78
> [   13.735437]        [<c035ea74>] mutex_lock_nested+0x5c/0x2ec
> [   13.741156]        [<c014f510>] ubifs_write_begin+0x314/0x500
> [   13.746937]        [<c0084998>] generic_file_buffered_write+0x1b4/0x=
288
> [   13.753625]        [<c0086704>] __generic_file_aio_write+0x1bc/0x434=

> [   13.760000]        [<c00869e4>] generic_file_aio_write+0x68/0xd8
> [   13.766031]        [<c014eaec>] ubifs_aio_write+0xf8/0x194
> [   13.771562]        [<c00b8994>] do_sync_write+0x94/0xc8
> [   13.776843]        [<c00b9148>] vfs_write+0xa0/0x17c
> [   13.781843]        [<c00b9450>] sys_write+0x3c/0x70
> [   13.786750]        [<c000e400>] ret_fast_syscall+0x0/0x38
> [   13.792187]
> -> #0 (&sb->s_type->i_mutex_key#10){+.+...}:
> [   13.797781]        [<c0053e50>] __lock_acquire+0x14ec/0x1b08
> [   13.803468]        [<c00548f0>] lock_acquire+0x64/0x78
> [   13.808625]        [<c035ea74>] mutex_lock_nested+0x5c/0x2ec
> [   13.814343]        [<c0178330>] ubifs_init_security+0x24/0x5c
> [   13.820125]        [<c0152b10>] ubifs_create+0x12c/0x1ec
> [   13.825468]        [<c00c40a0>] vfs_create+0xa8/0x118
> [   13.830562]        [<c00c6594>] do_last+0x930/0xd4c
> [   13.835468]        [<c00c6a58>] path_openat+0xa8/0x4b8
> [   13.840625]        [<c00c7168>] do_filp_open+0x2c/0x80
> [   13.845812]        [<c00b86e4>] do_sys_open+0xe4/0x170
> [   13.850968]        [<c000e400>] ret_fast_syscall+0x0/0x38
> [   13.856406]
> [   13.856406] other info that might help us debug this:
> [   13.856406]
> [   13.864437]  Possible unsafe locking scenario:
> [   13.864437]
> [   13.870375]        CPU0                    CPU1
> [   13.874906]        ----                    ----
> [   13.879468]   lock(&ui->ui_mutex);
> [   13.882906]                                lock(&sb->s_type->i_mutex=
_key#10);
> [   13.890093]                                lock(&ui->ui_mutex);
> [   13.896031]   lock(&sb->s_type->i_mutex_key#10);
> [   13.900718]
> [   13.900718]  *** DEADLOCK ***
> [   13.900718]
> [   13.906656] 3 locks held by touch/81:
> [   13.910312]  #0:  (sb_writers#3){.+.+.+}, at: [<c00d4e68>] mnt_want_=
write+0x18/0x3c
> [   13.918093]  #1:  (&type->i_mutex_dir_key){+.+.+.}, at: [<c00c5fcc>]=
 do_last+0x368/0xd4c
> [   13.926281]  #2:  (&ui->ui_mutex){+.+...}, at: [<c0152a98>] ubifs_cr=
eate+0xb4/0x1ec
> [   13.934031]
> [   13.934031] stack backtrace:
> [   13.938468] [<c00124f0>] (unwind_backtrace+0x0/0xf0) from [<c035a670=
>] (print_circular_bug+0x25c/0x2a8)
> [   13.947906] [<c035a670>] (print_circular_bug+0x25c/0x2a8) from [<c00=
53e50>] (__lock_acquire+0x14ec/0x1b08)
> [   13.957593] [<c0053e50>] (__lock_acquire+0x14ec/0x1b08) from [<c0054=
8f0>] (lock_acquire+0x64/0x78)
> [   13.966593] [<c00548f0>] (lock_acquire+0x64/0x78) from [<c035ea74>] =
(mutex_lock_nested+0x5c/0x2ec)
> [   13.975593] [<c035ea74>] (mutex_lock_nested+0x5c/0x2ec) from [<c0178=
330>] (ubifs_init_security+0x24/0x5c)
> [   13.985187] [<c0178330>] (ubifs_init_security+0x24/0x5c) from [<c015=
2b10>] (ubifs_create+0x12c/0x1ec)
> [   13.994437] [<c0152b10>] (ubifs_create+0x12c/0x1ec) from [<c00c40a0>=
] (vfs_create+0xa8/0x118)
> [   14.003000] [<c00c40a0>] (vfs_create+0xa8/0x118) from [<c00c6594>] (=
do_last+0x930/0xd4c)
> [   14.011125] [<c00c6594>] (do_last+0x930/0xd4c) from [<c00c6a58>] (pa=
th_openat+0xa8/0x4b8)
> [   14.019343] [<c00c6a58>] (path_openat+0xa8/0x4b8) from [<c00c7168>] =
(do_filp_open+0x2c/0x80)
> [   14.027812] [<c00c7168>] (do_filp_open+0x2c/0x80) from [<c00b86e4>] =
(do_sys_open+0xe4/0x170)
> [   14.036281] [<c00b86e4>] (do_sys_open+0xe4/0x170) from [<c000e400>] =
(ret_fast_syscall+0x0/0x38)

or this:

> [   54.994687]
> [   54.996218] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   55.002437] [ INFO: possible circular locking dependency detected ]
> [   55.008718] 3.8.0-rc7-00011-gd50987e #113 Not tainted
> [   55.013781] -------------------------------------------------------
> [   55.020062] semodule/427 is trying to acquire lock:
> [   55.024937]  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<c0178330>]=
 ubifs_init_security+0x24/0x5c
> [   55.034031]
> [   55.034031] but task is already holding lock:
> [   55.039875]  (&ui->ui_mutex){+.+...}, at: [<c0152614>] ubifs_mkdir+0=
x98/0x204
> [   55.047125]
> [   55.047125] which lock already depends on the new lock.
> [   55.047125]
> [   55.055312]
> [   55.055312] the existing dependency chain (in reverse order) is:
> [   55.062812]
> -> #1 (&ui->ui_mutex){+.+...}:
> [   55.067156]        [<c00548f0>] lock_acquire+0x64/0x78
> [   55.072343]        [<c035ea74>] mutex_lock_nested+0x5c/0x2ec
> [   55.078031]        [<c014ffb8>] ubifs_setattr+0x2c8/0x3f8
> [   55.083500]        [<c00d1b14>] notify_change+0x1dc/0x330
> [   55.088937]        [<c00b7838>] do_truncate+0x78/0x9c
> [   55.094031]        [<c00c6318>] do_last+0x6b4/0xd4c
> [   55.098937]        [<c00c6a58>] path_openat+0xa8/0x4b8
> [   55.104125]        [<c00c7168>] do_filp_open+0x2c/0x80
> [   55.109281]        [<c00b86e4>] do_sys_open+0xe4/0x170
> [   55.114468]        [<c000e400>] ret_fast_syscall+0x0/0x38
> [   55.119906]
> -> #0 (&sb->s_type->i_mutex_key#12){+.+.+.}:
> [   55.125468]        [<c0053e50>] __lock_acquire+0x14ec/0x1b08
> [   55.131187]        [<c00548f0>] lock_acquire+0x64/0x78
> [   55.136343]        [<c035ea74>] mutex_lock_nested+0x5c/0x2ec
> [   55.142062]        [<c0178330>] ubifs_init_security+0x24/0x5c
> [   55.147843]        [<c01526b4>] ubifs_mkdir+0x138/0x204
> [   55.153093]        [<c00c3e50>] vfs_mkdir+0xb8/0x138
> [   55.158093]        [<c00c74bc>] sys_mkdirat+0x5c/0xb0
> [   55.163187]        [<c000e400>] ret_fast_syscall+0x0/0x38
> [   55.168625]
> [   55.168625] other info that might help us debug this:
> [   55.168625]
> [   55.176625]  Possible unsafe locking scenario:
> [   55.176625]
> [   55.182562]        CPU0                    CPU1
> [   55.187125]        ----                    ----
> [   55.191656]   lock(&ui->ui_mutex);
> [   55.195093]                                lock(&sb->s_type->i_mutex=
_key#12);
> [   55.202281]                                lock(&ui->ui_mutex);
> [   55.208218]   lock(&sb->s_type->i_mutex_key#12);
> [   55.212906]
> [   55.212906]  *** DEADLOCK ***
> [   55.212906]
> [   55.218843] 3 locks held by semodule/427:
> [   55.222875]  #0:  (sb_writers#3){.+.+.+}, at: [<c00d4e68>] mnt_want_=
write+0x18/0x3c
> [   55.230656]  #1:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<c00c4ed0=
>] kern_path_create+0x6c/0x11c
> [   55.239718]  #2:  (&ui->ui_mutex){+.+...}, at: [<c0152614>] ubifs_mk=
dir+0x98/0x204
> [   55.247375]
> [   55.247375] stack backtrace:
> [   55.251812] [<c00124f0>] (unwind_backtrace+0x0/0xf0) from [<c035a670=
>] (print_circular_bug+0x25c/0x2a8)
> [   55.261250] [<c035a670>] (print_circular_bug+0x25c/0x2a8) from [<c00=
53e50>] (__lock_acquire+0x14ec/0x1b08)
> [   55.270937] [<c0053e50>] (__lock_acquire+0x14ec/0x1b08) from [<c0054=
8f0>] (lock_acquire+0x64/0x78)
> [   55.279937] [<c00548f0>] (lock_acquire+0x64/0x78) from [<c035ea74>] =
(mutex_lock_nested+0x5c/0x2ec)
> [   55.288937] [<c035ea74>] (mutex_lock_nested+0x5c/0x2ec) from [<c0178=
330>] (ubifs_init_security+0x24/0x5c)
> [   55.298531] [<c0178330>] (ubifs_init_security+0x24/0x5c) from [<c015=
26b4>] (ubifs_mkdir+0x138/0x204)
> [   55.307687] [<c01526b4>] (ubifs_mkdir+0x138/0x204) from [<c00c3e50>]=
 (vfs_mkdir+0xb8/0x138)
> [   55.316062] [<c00c3e50>] (vfs_mkdir+0xb8/0x138) from [<c00c74bc>] (s=
ys_mkdirat+0x5c/0xb0)
> [   55.324281] [<c00c74bc>] (sys_mkdirat+0x5c/0xb0) from [<c000e400>] (=
ret_fast_syscall+0x0/0x38)


Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2RJSIJWESRBKEJLANCBSP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEc0O8ACgkQjTAFq1RaXHPF4QCeKw2Lom4CkEZ+tbAmpcl8b02Q
6S8AnRAQRGVjrNfvovDJ8LAM7LH/Luyu
=CaTy
-----END PGP SIGNATURE-----

------enig2RJSIJWESRBKEJLANCBSP--
