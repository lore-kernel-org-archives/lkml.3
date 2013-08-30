Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3H3IpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:45:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35434 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3H3IpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:45:07 -0400
Date: Fri, 30 Aug 2013 18:44:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130830184456.ff4ceef498f429420c3e079d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Aug_2013_18_44_56_+1000_/6Z8FxZwRV+0qCR9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Aug_2013_18_44_56_+1000_/6Z8FxZwRV+0qCR9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
between commit 98474236f72e ("vfs: make the dentry cache use the lockref
infrastructure") from Linus' tree and commit "dcache: remove dentries
from LRU before putting on dispose list" from the akpm tree.

I fixed it up (I think - please check, see below and also check the final
result when I publish) and can carry the fix as necessary (no action is
required).

I also added this fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 30 Aug 2013 18:38:42 +1000
Subject: [PATCH] dcache: fix up for lockref changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 58c5e4b..39939f1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -837,7 +837,7 @@ dentry_lru_isolate(struct list_head *item, spinlock_t *=
lru_lock, void *arg)
 	 * counts, just remove them from the LRU. Otherwise give them
 	 * another pass through the LRU.
 	 */
-	if (dentry->d_count) {
+	if (dentry->d_lockref.count) {
 		list_del_init(&dentry->d_lru);
 		spin_unlock(&dentry->d_lock);
 		return LRU_REMOVED;
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/dcache.c
index 0fe810f,f5f8924..0000000
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -780,10 -801,15 +794,11 @@@ static struct dentry * try_prune_one_de
  	/* Prune ancestors. */
  	dentry =3D parent;
  	while (dentry) {
 -		spin_lock(&dentry->d_lock);
 -		if (dentry->d_count > 1) {
 -			dentry->d_count--;
 -			spin_unlock(&dentry->d_lock);
 +		if (lockref_put_or_lock(&dentry->d_lockref))
- 			return;
- 		dentry =3D dentry_kill(dentry, 1);
+ 			return NULL;
 -		}
+ 		dentry =3D dentry_kill(dentry, 1, 1);
  	}
+ 	return NULL;
  }
 =20
  static void shrink_dentry_list(struct list_head *list)
@@@ -802,12 -828,18 +817,18 @@@
  		}
 =20
  		/*
+ 		 * The dispose list is isolated and dentries are not accounted
+ 		 * to the LRU here, so we can simply remove it from the list
+ 		 * here regardless of whether it is referenced or not.
+ 		 */
+ 		list_del_init(&dentry->d_lru);
+ 		dentry->d_flags &=3D ~DCACHE_SHRINK_LIST;
+=20
+ 		/*
  		 * We found an inuse dentry which was not removed from
- 		 * the LRU because of laziness during lookup.  Do not free
- 		 * it - just keep it off the LRU list.
+ 		 * the LRU because of laziness during lookup. Do not free it.
  		 */
 -		if (dentry->d_count) {
 +		if (dentry->d_lockref.count) {
- 			dentry_lru_del(dentry);
  			spin_unlock(&dentry->d_lock);
  			continue;
  		}

--Signature=_Fri__30_Aug_2013_18_44_56_+1000_/6Z8FxZwRV+0qCR9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIFuMAAoJEECxmPOUX5FEMXMP/0rbJLjxsuSAYtlipldf8gc6
amMzVrvYbJCn7JOD752OQt2SHGyGVa8Nc+TbKMA/r69Y9BJtUd3p6/+Wr4vPhDoD
FapVvkcIMMWSJHdlb/7qzB3Hn7JtLebYJMgLqAwp/On6HdQSYuZXQYCVjqpdkcZt
AWHi0i/i0AxhP8T16lvxFgukNVigFMsq2OtjTdxDDDsGGv7JghBhJmneJDNystxW
QT+7796D19CgLtviXd8E4h7Q/cPoeBtAf5Yg5JUssX2TPaGyFRjRtNKoo29u/iJp
O7GbiEWH1348hXQQh3Z5eLGDUH38I3kY1kZjB2g7Q5tHbxuUOH+0uQ0IlCtEqtsn
FQgJ9QddlHVZeb61IEvCd/y17zqVAdUku10w2P6jVjTJus6gomYuL1UG2AipgAwc
DVLMzFIr+njwM7bLHIiBHv8H0FQYL+C01/5Yy9++sumb1oPgIBIzM9mg9C88dJdb
3Cke3UyFgAt07ik4PqW3L0BT/0M94fAbEz3yqiDEDCEa+l7NAULzC0t1tyf2pwN4
2Bx6iZWalmqxfCfWfC3QeDvLPSvEfdVd2S8wl2I48ZEfz4CMBCky3iJ+BJ+XscE0
LJGlQTyKDkHdf4taJcn29NThNile9msEASqCImC8CpF/fCJR/33OvIe3VPFYh28O
Xn8nnNdvUsfhfRz/1LcU
=i4EZ
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Aug_2013_18_44_56_+1000_/6Z8FxZwRV+0qCR9--
