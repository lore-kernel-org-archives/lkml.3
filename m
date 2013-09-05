Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935542Ab3IEC72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:59:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46844 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3IEC71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:59:27 -0400
Date: Thu, 5 Sep 2013 12:59:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        Linus <torvalds@linux-foundation.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20130905125924.7010902154740d512679367f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Sep_2013_12_59_24_+1000_ndXY2G6=vp7+964Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Sep_2013_12_59_24_+1000_ndXY2G6=vp7+964Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/dcache.c
between commit 98474236f72e ("vfs: make the dentry cache use the lockref
infrastructure") from Linus' tree and commit 590fb51f1cf9 ("vfs: call
d_op->d_prune() before unhashing dentry") from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/dcache.c
index 96655f4,2e5f9ca..0000000
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -726,7 -718,15 +726,15 @@@ restart
  	spin_lock(&inode->i_lock);
  	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
  		spin_lock(&dentry->d_lock);
 -		if (!dentry->d_count) {
 +		if (!dentry->d_lockref.count) {
+ 			/*
+ 			 * inform the fs via d_prune that this dentry
+ 			 * is about to be unhashed and destroyed.
+ 			 */
+ 			if ((dentry->d_flags & DCACHE_OP_PRUNE) &&
+ 			    !d_unhashed(dentry))
+ 				dentry->d_op->d_prune(dentry);
+=20
  			__dget_dlock(dentry);
  			__d_drop(dentry);
  			spin_unlock(&dentry->d_lock);

--Signature=_Thu__5_Sep_2013_12_59_24_+1000_ndXY2G6=vp7+964Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJ/ONAAoJEECxmPOUX5FE3zIP/iRrkn9MIQstQi0FCyu7ANF7
oqnV6pWpfhiKaRdVCedIGl8Fi6eaapANXB/uLfaUWMqVEb8pLZLWoguHBMx+zr1E
FQL2+9X3f13NHPb269QEgZTIR4SYrDOfFEy7Qla3K+WQ1OA7rd1cLoszO8wc06gK
UERkEKPFN1Knb/xKoYuIWehJu4lGpIB2bMHbC2NCgli07i89BNmZ+WVdu0eM7ize
ZECRJRneU9RAcOpFO5M5FdaNo7vdPg5ZHx9z1Qo/AJVUZ5fIGNRD9FB4PwykUd5M
YggTSlbEwFp8uNNeYJIk68o8kRwa2uGL/sKBSGGOxfMsxdKm/J0jCOun8EzXTC6y
AIKybO+VLpfMfiQlkmd22l8cJ61aULnHwSGp+p1+WXMgyFJ94jGcD7DEqzcpJHln
DjKAP2EHCPeEZUttqQUgl5USpTKNIQYB2ylb4v7uFPxweLuUzE/TbX9hDIUPAveI
dopgyGd3yZOS2b2YearLDTczKZef5yZvRKBydAZ1sOkXXa2OaK9U1XiTOEL66a2N
GX9MLKP76v7rFNwknQHV2P9nccU3X33jIeqHTYfgjGJwtB9Jsxk4rzRkNc+4J4af
mqrkS+231+Ayyr0pxN0jKU1oEkdRAjtgdDM98pZrzZD+w4ca7PQf13OUKOl0xZLH
9REok6k5bpsDxrpB7fDd
=/qVV
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Sep_2013_12_59_24_+1000_ndXY2G6=vp7+964Z--
