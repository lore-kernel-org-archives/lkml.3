Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab3BHOLH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:11:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58204 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3BHOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:11:04 -0500
Message-ID: <5115076E.3070703@pengutronix.de>
Date: Fri, 08 Feb 2013 15:10:54 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-mtd@lists.infradead.org
CC: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: SELinux + ubifs: possible circular locking dependency
References: <51123C80.2050400@pengutronix.de>
In-Reply-To: <51123C80.2050400@pengutronix.de>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2XAMMBVJASNIMPQKCGWLH"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XAMMBVJASNIMPQKCGWLH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,

I'm on a arm imx28 v3.8-rc6 (+ a handfull of patches to support the
custom board) but no modifications on ubifs, selinux or the vfs layer.
And not including the xattr patches by Subodh Nijsure.

When booting with SELinux and lockdep enabled I see this _possible_
circular locking dependency:

This warning shows up every boot, but not again later. Is lockep
automatically disabled after the first circular lockdep warning?

This particular situation, where the dependency chain is occurs as far
as I understand only at boot. Three functions in this chain are only
called once:
- pinctrl_init()
- clk_debug_init()
- mount_block_root()

Another critical ingredient is security_load_policy().

Is this really an uncritical catch of the lock validator? If so, is it
possible to annotate this, so that the system boot up quietly?

> [    5.390312] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    5.396500] [ INFO: possible circular locking dependency detected ]
> [    5.402781] 3.8.0-rc6-00005-g4f7e39d #49 Not tainted
> [    5.407750] -------------------------------------------------------
> [    5.414031] systemd/1 is trying to acquire lock:
> [    5.418656]  (&c->tnc_mutex){+.+...}, at: [<c01552d0>] ubifs_tnc_loc=
ate+0x30/0x198
> [    5.426343]
> [    5.426343] but task is already holding lock:
> [    5.432218]  (&isec->lock){+.+.+.}, at: [<c018e298>] inode_doinit_wi=
th_dentry+0x8c/0x55c
> [    5.440375]
> [    5.440375] which lock already depends on the new lock.
> [    5.440375]
> [    5.448593]
> [    5.448593] the existing dependency chain (in reverse order) is:
> [    5.456093]
> -> #4 (&isec->lock){+.+.+.}:
> [    5.460250]        [<c004e8e8>] lock_acquire+0x64/0x78
> [    5.465437]        [<c0355d5c>] mutex_lock_nested+0x5c/0x2ec
> [    5.471125]        [<c018e298>] inode_doinit_with_dentry+0x8c/0x55c
> [    5.477437]        [<c0189bd8>] security_d_instantiate+0x1c/0x34
> [    5.483500]        [<c017a614>] debugfs_mknod.part.15.constprop.18+0=
x94/0x128
> [    5.490656]        [<c017a858>] __create_file+0x1b0/0x25c
> [    5.496093]        [<c017a98c>] debugfs_create_dir+0x1c/0x28
> [    5.501781]        [<c0491ce8>] pinctrl_init+0x1c/0xd0
> [    5.506968]        [<c0008900>] do_one_initcall+0x108/0x17c
> [    5.512593]        [<c0483858>] kernel_init_freeable+0xec/0x1b4
> [    5.518562]        [<c034f398>] kernel_init+0x8/0xe4
> [    5.523562]        [<c0009448>] ret_from_fork+0x14/0x2c
> [    5.528812]
> -> #3 (&sb->s_type->i_mutex_key#2){+.+.+.}:
> [    5.534312]        [<c004e8e8>] lock_acquire+0x64/0x78
> [    5.539468]        [<c0355d5c>] mutex_lock_nested+0x5c/0x2ec
> [    5.545187]        [<c017a6f8>] __create_file+0x50/0x25c
> [    5.550531]        [<c017a98c>] debugfs_create_dir+0x1c/0x28
> [    5.556218]        [<c026cfc4>] clk_debug_create_subtree+0x1c/0x108
> [    5.562500]        [<c0495bfc>] clk_debug_init+0x68/0xc0
> [    5.567875]        [<c0008900>] do_one_initcall+0x108/0x17c
> [    5.573468]        [<c0483858>] kernel_init_freeable+0xec/0x1b4
> [    5.579437]        [<c034f398>] kernel_init+0x8/0xe4
> [    5.584437]        [<c0009448>] ret_from_fork+0x14/0x2c
> [    5.589687]
> -> #2 (prepare_lock){+.+.+.}:
> [    5.593937]        [<c004e8e8>] lock_acquire+0x64/0x78
> [    5.599125]        [<c0355d5c>] mutex_lock_nested+0x5c/0x2ec
> [    5.604812]        [<c026d400>] clk_prepare+0x18/0x38
> [    5.609906]        [<c023a2f8>] __gpmi_enable_clk+0x30/0xb0
> [    5.615531]        [<c023a7bc>] gpmi_begin+0x18/0x530
> [    5.620625]        [<c0239244>] gpmi_select_chip+0x3c/0x54
> [    5.626156]        [<c02341ac>] nand_do_read_ops+0x7c/0x3e4
> [    5.631750]        [<c023483c>] nand_read+0x50/0x74
> [    5.636656]        [<c02198e4>] part_read+0x5c/0xa4
> [    5.641593]        [<c0217404>] mtd_read+0x84/0xb8
> [    5.646406]        [<c02450cc>] ubi_io_read+0xa0/0x2c0
> [    5.651593]        [<c0242640>] ubi_eba_read_leb+0x190/0x424
> [    5.657281]        [<c0241b18>] ubi_leb_read+0xac/0x120
> [    5.662562]        [<c01503e4>] ubifs_leb_read+0x28/0x8c
> [    5.667906]        [<c0151f74>] ubifs_read_node+0x98/0x2a0
> [    5.673437]        [<c014e780>] ubifs_read_sb_node+0x54/0x78
> [    5.679125]        [<c014f444>] ubifs_read_superblock+0xc60/0x163c
> [    5.685343]        [<c014d64c>] ubifs_mount+0x800/0x171c
> [    5.690687]        [<c00b5740>] mount_fs+0x44/0x184
> [    5.695593]        [<c00cd7ec>] vfs_kern_mount+0x4c/0xc0
> [    5.700968]        [<c00cf394>] do_mount+0x18c/0x8d0
> [    5.705968]        [<c00cfb5c>] sys_mount+0x84/0xb8
> [    5.710875]        [<c0483bc8>] mount_block_root+0x118/0x258
> [    5.716562]        [<c0483eac>] prepare_namespace+0x8c/0x17c
> [    5.722281]        [<c034f398>] kernel_init+0x8/0xe4
> [    5.727281]        [<c0009448>] ret_from_fork+0x14/0x2c
> [    5.732531]
> -> #1 (&le->mutex){++++..}:
> [    5.736625]        [<c004e8e8>] lock_acquire+0x64/0x78
> [    5.741812]        [<c0356468>] down_read+0x40/0x54
> [    5.746718]        [<c02424e4>] ubi_eba_read_leb+0x34/0x424
> [    5.752312]        [<c0241b18>] ubi_leb_read+0xac/0x120
> [    5.757562]        [<c01503e4>] ubifs_leb_read+0x28/0x8c
> [    5.762937]        [<c0151f74>] ubifs_read_node+0x98/0x2a0
> [    5.768437]        [<c016edc0>] ubifs_load_znode+0x88/0x560
> [    5.774062]        [<c0155254>] ubifs_lookup_level0+0x190/0x1dc
> [    5.780031]        [<c01552e4>] ubifs_tnc_locate+0x44/0x198
> [    5.785656]        [<c014c614>] ubifs_iget+0x6c/0x8a4
> [    5.790718]        [<c014da64>] ubifs_mount+0xc18/0x171c
> [    5.796093]        [<c00b5740>] mount_fs+0x44/0x184
> [    5.801000]        [<c00cd7ec>] vfs_kern_mount+0x4c/0xc0
> [    5.806343]        [<c00cf394>] do_mount+0x18c/0x8d0
> [    5.811343]        [<c00cfb5c>] sys_mount+0x84/0xb8
> [    5.816250]        [<c0483bc8>] mount_block_root+0x118/0x258
> [    5.821968]        [<c0483eac>] prepare_namespace+0x8c/0x17c
> [    5.827656]        [<c034f398>] kernel_init+0x8/0xe4
> [    5.832656]        [<c0009448>] ret_from_fork+0x14/0x2c
> [    5.837906]
> -> #0 (&c->tnc_mutex){+.+...}:
> [    5.842250]        [<c004de48>] __lock_acquire+0x14ec/0x1b08
> [    5.847968]        [<c004e8e8>] lock_acquire+0x64/0x78
> [    5.853125]        [<c0355d5c>] mutex_lock_nested+0x5c/0x2ec
> [    5.858812]        [<c01552d0>] ubifs_tnc_locate+0x30/0x198
> [    5.864437]        [<c0155a48>] ubifs_tnc_lookup_nm+0x28/0x150
> [    5.870312]        [<c016fc18>] ubifs_getxattr+0xc0/0x254
> [    5.875750]        [<c018e468>] inode_doinit_with_dentry+0x25c/0x55c=

> [    5.882125]        [<c018f1a8>] sb_finish_set_opts+0xa4/0x21c
> [    5.887906]        [<c019055c>] selinux_set_mnt_opts+0x2ec/0x4b8
> [    5.893968]        [<c01907dc>] superblock_doinit+0xb4/0xc0
> [    5.899562]        [<c00b51f4>] iterate_supers+0xb4/0xdc
> [    5.904906]        [<c01a02e8>] security_load_policy+0x248/0x3c4
> [    5.910968]        [<c0194994>] sel_write_load+0x9c/0x6a0
> [    5.916406]        [<c00b2148>] vfs_write+0xa0/0x17c
> [    5.921406]        [<c00b2450>] sys_write+0x3c/0x70
> [    5.926343]        [<c00093a0>] ret_fast_syscall+0x0/0x38
> [    5.931781]
> [    5.931781] other info that might help us debug this:
> [    5.931781]
> [    5.939781] Chain exists of:
>   &c->tnc_mutex --> &sb->s_type->i_mutex_key#2 --> &isec->lock
> [    5.948500]  Possible unsafe locking scenario:
> [    5.948500]
> [    5.954437]        CPU0                    CPU1
> [    5.958968]        ----                    ----
> [    5.963500]   lock(&isec->lock);
> [    5.966781]                                lock(&sb->s_type->i_mutex=
_key#2);
> [    5.973843]                                lock(&isec->lock);
> [    5.979625]   lock(&c->tnc_mutex);
> [    5.983062]
> [    5.983062]  *** DEADLOCK ***
> [    5.983062]
> [    5.989000] 4 locks held by systemd/1:
> [    5.992781]  #0:  (sel_mutex){+.+.+.}, at: [<c0194918>] sel_write_lo=
ad+0x20/0x6a0
> [    6.000343]  #1:  (&type->s_umount_key#26){.+.+..}, at: [<c00b51d0>]=
 iterate_supers+0x90/0xdc
> [    6.008968]  #2:  (&sbsec->lock){+.+.+.}, at: [<c01902d4>] selinux_s=
et_mnt_opts+0x64/0x4b8
> [    6.017343]  #3:  (&isec->lock){+.+.+.}, at: [<c018e298>] inode_doin=
it_with_dentry+0x8c/0x55c
> [    6.025937]
> [    6.025937] stack backtrace:
> [    6.030375] [<c000d0f0>] (unwind_backtrace+0x0/0xf0) from [<c0351a2c=
>] (print_circular_bug+0x25c/0x2a8)
> [    6.039843] [<c0351a2c>] (print_circular_bug+0x25c/0x2a8) from [<c00=
4de48>] (__lock_acquire+0x14ec/0x1b08)
> [    6.049531] [<c004de48>] (__lock_acquire+0x14ec/0x1b08) from [<c004e=
8e8>] (lock_acquire+0x64/0x78)
> [    6.058531] [<c004e8e8>] (lock_acquire+0x64/0x78) from [<c0355d5c>] =
(mutex_lock_nested+0x5c/0x2ec)
> [    6.067531] [<c0355d5c>] (mutex_lock_nested+0x5c/0x2ec) from [<c0155=
2d0>] (ubifs_tnc_locate+0x30/0x198)
> [    6.076968] [<c01552d0>] (ubifs_tnc_locate+0x30/0x198) from [<c0155a=
48>] (ubifs_tnc_lookup_nm+0x28/0x150)
> [    6.086593] [<c0155a48>] (ubifs_tnc_lookup_nm+0x28/0x150) from [<c01=
6fc18>] (ubifs_getxattr+0xc0/0x254)
> [    6.096031] [<c016fc18>] (ubifs_getxattr+0xc0/0x254) from [<c018e468=
>] (inode_doinit_with_dentry+0x25c/0x55c)
> [    6.105968] [<c018e468>] (inode_doinit_with_dentry+0x25c/0x55c) from=
 [<c018f1a8>] (sb_finish_set_opts+0xa4/0x21c)
> [    6.116281] [<c018f1a8>] (sb_finish_set_opts+0xa4/0x21c) from [<c019=
055c>] (selinux_set_mnt_opts+0x2ec/0x4b8)
> [    6.126218] [<c019055c>] (selinux_set_mnt_opts+0x2ec/0x4b8) from [<c=
01907dc>] (superblock_doinit+0xb4/0xc0)
> [    6.136000] [<c01907dc>] (superblock_doinit+0xb4/0xc0) from [<c00b51=
f4>] (iterate_supers+0xb4/0xdc)
> [    6.145093] [<c00b51f4>] (iterate_supers+0xb4/0xdc) from [<c01a02e8>=
] (security_load_policy+0x248/0x3c4)
> [    6.154625] [<c01a02e8>] (security_load_policy+0x248/0x3c4) from [<c=
0194994>] (sel_write_load+0x9c/0x6a0)
> [    6.164218] [<c0194994>] (sel_write_load+0x9c/0x6a0) from [<c00b2148=
>] (vfs_write+0xa0/0x17c)
> [    6.172781] [<c00b2148>] (vfs_write+0xa0/0x17c) from [<c00b2450>] (s=
ys_write+0x3c/0x70)
> [    6.180843] [<c00b2450>] (sys_write+0x3c/0x70) from [<c00093a0>] (re=
t_fast_syscall+0x0/0x38)

regards,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2XAMMBVJASNIMPQKCGWLH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEVB3EACgkQjTAFq1RaXHNQTgCggZbDGtVvk7xMMjhXwxkNSowk
LrQAnjrkEBJy6wbKmf0JvO7sV7vpWS03
=0dZH
-----END PGP SIGNATURE-----

------enig2XAMMBVJASNIMPQKCGWLH--
