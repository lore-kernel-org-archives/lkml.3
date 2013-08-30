Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3H3HzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:55:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33042 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab3H3HzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:55:21 -0400
Date: Fri, 30 Aug 2013 17:55:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the aio tree
Message-Id: <20130830175509.39d7fbfd96a4e726ba739d26@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Aug_2013_17_55_09_+1000_N.h9sUw_.IFiCQk4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Aug_2013_17_55_09_+1000_N.h9sUw_.IFiCQk4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benjamin,

After merging the aio tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/kernel.h:13:0,
                 from fs/aio.c:13:
fs/aio.c: In function 'aio_free_ring':
fs/aio.c:188:32: error: 'struct dentry' has no member named 'd_count'
    aio_ring_file->f_path.dentry->d_count,
                                ^
include/linux/printk.h:246:38: note: in definition of macro 'pr_debug'
  no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
                                      ^

Caused by commit 36bc08cc0170 ("s/aio: Add support to aio ring pages
migration") interacting with commit 98474236f72e ("vfs: make the dentry
cache use the lockref infrastructure") from Linus' tree.

I applied the following (probably suboptimal) fix and can carry it as
necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 30 Aug 2013 17:49:10 +1000
Subject: [PATCH] aio: fixup for lockref changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/aio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9f783e3..6d00cd9 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -185,7 +185,7 @@ static void aio_free_ring(struct kioctx *ctx)
 		truncate_setsize(aio_ring_file->f_inode, 0);
 		pr_debug("pid(%d) i_nlink=3D%u d_count=3D%d d_unhashed=3D%d i_count=3D%d=
\n",
 			current->pid, aio_ring_file->f_inode->i_nlink,
-			aio_ring_file->f_path.dentry->d_count,
+			aio_ring_file->f_path.dentry->d_lockref.count,
 			d_unhashed(aio_ring_file->f_path.dentry),
 			atomic_read(&aio_ring_file->f_inode->i_count));
 		fput(aio_ring_file);
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Aug_2013_17_55_09_+1000_N.h9sUw_.IFiCQk4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIE/hAAoJEECxmPOUX5FEGE8P/jbCHZJQc0DWNfoZIyYkfysP
iytbMCWl4my8iiD8JFDXcxqtGwsEv9gOHBZyG5t4BgfU5uZymxnEtd0FwM6IZAyB
cmyY7Ai1JPWtDcS3XPJOuW3v9wTFQSkBMXVqlqvkJJHigHeM0gPbOmk8XMqY3rZ3
gil2qIzakOOcC75lgQsobbY5XQbOlWRcLgeZotKh51FMOE54m1gr8LWtv1iALuEb
i562dvJEC2y7V0+bPZvj5gp0XV3Be7UDVPr1lN7pzjh9XySTX9nu/UftDRAQwNVT
K5T9q20VqTvywCFz9I24a80omkWljxVsBGVXDxRt1gcwl7Rr9j1QMzo1GeM8Kecz
yjdd8INml+N2ex+iYZP8qt/ACjIoGWStHt1Ohu9YHWo5W71QSxRlSERTQ/BZCGOn
p++NGF8jCZVTf8hthpPu7OakSDMMNlPdKIS1Uutyd71F/7PAt8A9lCiBFtQwHUR7
ADkQcJSQT1ogfYpS9F8k4wpTLopO4r2iai9xlqTun1fSpvF+jNUcd+J1RrINI5HB
pzLusyjojPjBCnHnTxCLx0/jG9i2aaf2t9Vt+/qpw8/bSp0P4Cf56QtliEXntVHM
u7ZLVbskZMca/7sfRNnmHaSogFFbpnRQhjheaMtTSzdmLgFpThKtAFeBRz5T0nhN
5vV/0Va2GwveRRGo9JGs
=nURK
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Aug_2013_17_55_09_+1000_N.h9sUw_.IFiCQk4--
