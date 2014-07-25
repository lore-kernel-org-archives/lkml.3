Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbaGYDeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 23:34:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaGYDd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 23:33:59 -0400
Date: Thu, 24 Jul 2014 22:33:53 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: avoid to access NULL pointer when write
 metadata in xattr
Message-ID: <20140725033353.GC8446@boyd>
References: <000001cfa721$57072880$05157980$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <000001cfa721$57072880$05157980$@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello and thanks for the patch!

On 2014-07-24 17:25:42, Chao Yu wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D41692

This actually isn't the bug that this patch fixes. It is a different bug
(that I don't think exists anymore) and someone happened to test for the
bug on a newer kernel and hit the oops that you're fixing here.

>=20
> Christopher Head 2014-06-28 05:26:20 UTC described:
> "I tried to reproduce this on 3.12.21. Instead, when I do "echo hello > f=
oo"
> in an ecryptfs mount with ecryptfs_xattr specified, I get a kernel crash:
>=20
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff8110eb39>] fsstack_copy_attr_all+0x2/0x61
> PGD d7840067 PUD b2c3c067 PMD 0=20
> Oops: 0002 [#1] SMP=20
> Modules linked in: nvidia(PO)
> CPU: 3 PID: 3566 Comm: bash Tainted: P           O 3.12.21-gentoo-r1 #2
> Hardware name: ASUSTek Computer Inc. G60JX/G60JX, BIOS 206 03/15/2010
> task: ffff8801948944c0 ti: ffff8800bad70000 task.ti: ffff8800bad70000
> RIP: 0010:[<ffffffff8110eb39>]  [<ffffffff8110eb39>] fsstack_copy_attr_al=
l+0x2/0x61
> RSP: 0018:ffff8800bad71c10  EFLAGS: 00010246
> RAX: 00000000000181a4 RBX: ffff880198648480 RCX: 0000000000000000
> RDX: 0000000000000004 RSI: ffff880172010450 RDI: 0000000000000000
> RBP: ffff880198490e40 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff880172010450 R11: ffffea0002c51e80 R12: 0000000000002000
> R13: 000000000000001a R14: 0000000000000000 R15: ffff880198490e40
> FS:  00007ff224caa700(0000) GS:ffff88019fcc0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000000bb07f000 CR4: 00000000000007e0
> Stack:
> ffffffff811826e8 ffff8800a39d8000 0000000000000000 000000000000001a
> ffff8800a01d0000 ffff8800a39d8000 ffffffff81185fd5 ffffffff81082c2c
> 00000001a39d8000 53d0abbc98490e40 0000000000000037 ffff8800a39d8220
> Call Trace:
> [<ffffffff811826e8>] ? ecryptfs_setxattr+0x40/0x52
> [<ffffffff81185fd5>] ? ecryptfs_write_metadata+0x1b3/0x223
> [<ffffffff81082c2c>] ? should_resched+0x5/0x23
> [<ffffffff8118322b>] ? ecryptfs_initialize_file+0xaf/0xd4
> [<ffffffff81183344>] ? ecryptfs_create+0xf4/0x142
> [<ffffffff810f8c0d>] ? vfs_create+0x48/0x71
> [<ffffffff810f9c86>] ? do_last.isra.68+0x559/0x952
> [<ffffffff810f7ce7>] ? link_path_walk+0xbd/0x458
> [<ffffffff810fa2a3>] ? path_openat+0x224/0x472
> [<ffffffff810fa7bd>] ? do_filp_open+0x2b/0x6f
> [<ffffffff81103606>] ? __alloc_fd+0xd6/0xe7
> [<ffffffff810ee6ab>] ? do_sys_open+0x65/0xe9
> [<ffffffff8157d022>] ? system_call_fastpath+0x16/0x1b
> RIP  [<ffffffff8110eb39>] fsstack_copy_attr_all+0x2/0x61
> RSP <ffff8800bad71c10>
> CR2: 0000000000000000
> ---[ end trace df9dba5f1ddb8565 ]---"
>=20
> If we create a file when we mount with ecryptfs_xattr_metadata option, we=
 will
> encounter a crash in this path:
> ->ecryptfs_create
>   ->ecryptfs_initialize_file
>     ->ecryptfs_write_metadata
>       ->ecryptfs_write_metadata_to_xattr
>         ->ecryptfs_setxattr
>           ->fsstack_copy_attr_all
> It's because our dentry->d_inode used in fsstack_copy_attr_all is NULL, a=
nd it
> will be initialized when ecryptfs_initialize_file finish.
>=20
> So we should skip copying attr from lower inode when the value of ->d_ino=
de is
> invalid.
>=20
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---

I wrote a patch to fix this bug last week, made the changes necessary to
run through all of the eCryptfs tests with the ecryptfs_xattr_metadata
mount option, tested the fix, and then forgot to send out the patch.
(doh!) But it worked out well because I think I like your patch better.

I moved the innards of ecryptfs_setxattr() into a new function that
accepts the lower_dentry and ecryptfs inode as separate arguments. That
way it can work regardless of the eCryptfs dentry not yet being
d_initialized().

After looking at your patch, I don't think that's necessary. Skipping
the fsstack_copy_attr_all() should be fine for brand new eCryptfs
inodes since the attr copy just happened in ecryptfs_inode_set().

I'll test your patch and then push it to the eCryptfs -next branch. I'll
also update the bug link to point to the specific comment rather than
the unrelated bug itself. Thanks!

Tyler

>  fs/ecryptfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index e67f9f0..436b7d8 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -1037,7 +1037,7 @@ ecryptfs_setxattr(struct dentry *dentry, const char=
 *name, const void *value,
>  	}
> =20
>  	rc =3D vfs_setxattr(lower_dentry, name, value, size, flags);
> -	if (!rc)
> +	if (!rc && dentry->d_inode)
>  		fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode);
>  out:
>  	return rc;
> --=20
> 2.0.1.474.g72c7794
>=20
>=20

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT0dAhAAoJENaSAD2qAscK8BYP/RCo0K1MrA2sFCXqmqANpfUp
1omA0pOP3AnbjMpkt8CCXIyooNW/A6/cDeLrbYt6H8JOVln8XeuNSUKShj/4Hyl4
h7swQvBojYrS3pYNx0XWLqPVP3cB5CXDEu1sckytqnio0trfmi+OxnC6yEZIzkfX
RTh4rs/4a8Djx514QpoICKErCYGvtOD7ddOJeIFFspNi5PV4jWmz1lurMNpUl6IH
l8niZH9PidQxHaJ3I1BrpLdoHpXtw7/1Xi8rdDWOPqCdnHVkjg6Uvtm5U9vuZPb+
8bDfKMRBb/xkbOmRn7oE1FpJXLX14oWJlXj1vJ0FR/Az2gK+adjFunmmQ61rmQjk
zKFy9Vi0F3uhykDiqfjoJ7H/+Lr4QP9Ku9SemUjvtiSKvRdng56MZOuX+G43BYGF
qg2OK0mT9kY9hKNsgGvVSsGKhNUqkRw/eiAuiCJwZ+J+ou1Zl/DWVH/J7xU9k6du
K2E2ModKnJ4KHDOANiPoNiskcpSQSl4TrsokYHthBzJFIYI+P2Y/XGkuJy8jev2g
biO4LeYeff7lNEIrfShfSuvHPA7O2K9vPAsO1+eVdwg2sqEmWmhe5xIMD7c2Yogi
UFGGBi9XvEnuHX4lUIEpX08/NwZvexvrx4913uPjy25nHx2WUNHlPky5egbIilUr
6r+vTJGRld8fy57Qo1vI
=jl10
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
