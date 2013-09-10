Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3IJEJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:09:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43609 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3IJEJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:09:33 -0400
Date: Tue, 10 Sep 2013 14:09:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130910140923.5a75463c9f8803afe14c4498@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Sep_2013_14_09_23_+1000_kB.GLPHwKc56J=u7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Sep_2013_14_09_23_+1000_kB.GLPHwKc56J=u7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
between commit 8aab6a27332b ("vfs: reorganize dput() memory accesses")
from Linus' tree and commit "dentry: move to per-sb LRU locks" from the
akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/dcache.c
index 664554e,6e212bd..0000000
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -362,9 -332,8 +361,9 @@@ static void dentry_unlink_inode(struct=20
   */
  static void dentry_lru_add(struct dentry *dentry)
  {
 -	if (list_empty(&dentry->d_lru)) {
 +	if (unlikely(!(dentry->d_flags & DCACHE_LRU_LIST))) {
- 		spin_lock(&dcache_lru_lock);
+ 		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
 +		dentry->d_flags |=3D DCACHE_LRU_LIST;
  		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
  		dentry->d_sb->s_nr_dentry_unused++;
  		this_cpu_inc(nr_dentry_unused);
@@@ -394,9 -363,8 +393,9 @@@ static void dentry_lru_del(struct dentr
 =20
  static void dentry_lru_move_list(struct dentry *dentry, struct list_head =
*list)
  {
- 	spin_lock(&dcache_lru_lock);
+ 	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
  	if (list_empty(&dentry->d_lru)) {
 +		dentry->d_flags |=3D DCACHE_LRU_LIST;
  		list_add_tail(&dentry->d_lru, list);
  		dentry->d_sb->s_nr_dentry_unused++;
  		this_cpu_inc(nr_dentry_unused);

--Signature=_Tue__10_Sep_2013_14_09_23_+1000_kB.GLPHwKc56J=u7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLpt4AAoJEECxmPOUX5FEyfwP/jaxEdevtgDZsoNhaVtqr4hQ
YqEAujdrs19MZ2YJ0VPXlNIFQHRUyb6ZvmmT6DeT+4lIU0dIDJ0Mn66pH4PB+lhq
84yQ8L2896k3ptUxj5ohiFax7Ec6EQM2zurU2wbaKXJHqpmrhk8pmNtS4nfJ/s0t
B8SBrU+EoLe+rgxbjCfBSWEYzLvo8x4Z6sVnHXinf5GnuDAx/gMG3xRqio7p3Zjh
PHKE2X3vx51AVDXaD/OxPq/UuYAJshew63MwCsPBpfX2h6QgIeAeZQqw/bLTWd6v
0MID+3Fizj8th9hTC6jJjABW8nAWPyKM9z1QqO9Pxh8fSQOycbCF5IahXxrp6q2O
32o8T5lSOwcgZe1iHxRE2RjAvkBcd4YODott1D7224xPtGR1APRCBqZGIFPHVF7y
qPqI8VdNyv4Z5DMWb/acPrUNQMS/KoUMkgxkniilOJFWDYA7Bqj+S8+H7ymkGy4h
VU/zaFg/CIOTeWcc+oG1HJRLeixh/cl7EKiJJyt16tPTS4kl2ylOsezpD1btX9MF
x7hYJXlN6bShiLT4sDsc0UigfaxI7iYVIFT7ggYOkxWfuKKbL+31YaDECmbMAMgm
vtLJNfliyRuTYOQoHNan+DyMv2gdA+EqJVi80W91Q8A4qu9wSCPx5MfWsjU49Yt+
zq8jrE43CRWa8Dhb8tpv
=uH32
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Sep_2013_14_09_23_+1000_kB.GLPHwKc56J=u7--
