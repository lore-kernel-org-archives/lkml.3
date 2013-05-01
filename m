Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab3EACWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 22:22:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50072 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab3EACWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 22:22:36 -0400
Date: Wed, 1 May 2013 12:22:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simo Sorce <simo@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20130501122227.4c1d5cd6f2f2f98e35706f44@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_May_2013_12_22_27_+1000_czbbo7U8=qgoZhAh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_May_2013_12_22_27_+1000_czbbo7U8=qgoZhAh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/sunrpc/auth_gss/svcauth_gss.c: In function 'write_gssp':
net/sunrpc/auth_gss/svcauth_gss.c:1329:9: error: implicit declaration of fu=
nction 'PDE' [-Werror=3Dimplicit-function-declaration]
net/sunrpc/auth_gss/svcauth_gss.c:1329:53: error: invalid type argument of =
'->' (have 'int')
net/sunrpc/auth_gss/svcauth_gss.c: In function 'read_gssp':
net/sunrpc/auth_gss/svcauth_gss.c:1357:53: error: invalid type argument of =
'->' (have 'int')

Caused by commit 030d794bf498 ("SUNRPC: Use gssproxy upcall for server
RPCGSS authentication") from the nfsd tree interacting with commit
c3f2cb25be4f ("proc: Make the PROC_I() and PDE() macros internal to
procfs") from the vfs tree.

I applied the following merge fix patch (there may be a better way).

=46rom 62a0e3a08844eeeb6d85fb45d85c2f80d7de2797 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 1 May 2013 12:19:43 +1000
Subject: [PATCH] SUNRPC: update for PDE removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcaut=
h_gss.c
index b70ac1c..89ef709 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1326,7 +1326,7 @@ static int wait_for_gss_proxy(struct net *net)
 static ssize_t write_gssp(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	struct net *net =3D PDE(file->f_path.dentry->d_inode)->data;
+	struct net *net =3D PDE_DATA(file->f_path.dentry->d_inode);
 	char tbuf[20];
 	unsigned long i;
 	int res;
@@ -1354,7 +1354,7 @@ static ssize_t write_gssp(struct file *file, const ch=
ar __user *buf,
 static ssize_t read_gssp(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
-	struct net *net =3D PDE(file->f_path.dentry->d_inode)->data;
+	struct net *net =3D PDE_DATA(file->f_path.dentry->d_inode);
 	unsigned long p =3D *ppos;
 	char tbuf[10];
 	size_t len;
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__1_May_2013_12_22_27_+1000_czbbo7U8=qgoZhAh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRgHxjAAoJEECxmPOUX5FEKN0P/R1fuHFrMuJoLb8GCWwkK5x5
AQ1jaXodogazT43rGkgDqJmB+zcwDUGbsJBDYg3fQN1QfU5cPQBLFrjDlTcyA0+6
/n/2dQ9ytQzlSj8RzsK97o1zFYxApNw1DWKyCXR58OFmki24cdsh6PArahmGzoe7
xXk2DL2E6TUELVFWi3B7aSZQKjzjwsDC1nsq8EwZjvOAp+4JKhns3godjy3Q96RH
cwJCtgpv1VxT7w537nNfpnUVz1NGSTjdyzBC+aRbWEpPztzlq9UWr7Scwgt6EjWF
zazveLRdOG/xJesweI1SiL0ntIj8SS7hzGtpLwzOyj2czEUmSIXaHJuehMVuDb7E
mPxvFdX2zW1g0e0iBT64JM/wOdnHD09YXeCVv0N5qu7D/L5FOpqaM3rFOR3wFVH/
ewijxoTbOcb1EXi+IivV7WZeG/v3WbVZP7BYrBtLIryZ4orNqZOxW4vwmq1LfsOd
QkTspzaySC+IVdWVo2adF3NtdbxwKOQzY61BBSs1q50ejBMz8+p3XIrPJP54rIFD
lyB8Jaiw2x0BwCLywItY4Kp0bUebUua2zvn85Yy09n/26wwlGqvk3T/itU82q8dm
6GC/aDj7O4C2rwLuaCQFAcGHn12TLDyeWBU8eXzF322F7z9dYGkUWnjAzp1E/XU/
UYP+hW6E4Mo2ZJ7H43zI
=Dqfy
-----END PGP SIGNATURE-----

--Signature=_Wed__1_May_2013_12_22_27_+1000_czbbo7U8=qgoZhAh--
