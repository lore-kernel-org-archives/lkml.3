Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3B1BPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 20:15:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41331 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3B1BPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 20:15:32 -0500
Date: Thu, 28 Feb 2013 12:15:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, Joe Thornber <ejt@redhat.com>,
        Heinz Mauelshagen <mauelshagen@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130228121522.b13a9a9aad4d8aceeb70edf0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Feb_2013_12_15_22_+1100_m7tVkt1j_Kljw6+H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Feb_2013_12_15_22_+1100_m7tVkt1j_Kljw6+H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/md/dm-cache-policy-cleaner.c: In function 'lookup_cache_entry':
drivers/md/dm-cache-policy-cleaner.c:148:46: error: macro "hlist_for_each_e=
ntry" passed 4 arguments, but takes just 3
drivers/md/dm-cache-policy-cleaner.c:148:2: error: 'hlist_for_each_entry' u=
ndeclared (first use in this function)
drivers/md/dm-cache-policy-cleaner.c:148:2: note: each undeclared identifie=
r is reported only once for each function it appears in
drivers/md/dm-cache-policy-cleaner.c:148:48: error: expected ';' before '{'=
 token
drivers/md/dm-cache-policy-cleaner.c:146:21: warning: unused variable 'buck=
et' [-Wunused-variable]
drivers/md/dm-cache-policy-cleaner.c:145:21: warning: unused variable 'tmp'=
 [-Wunused-variable]
drivers/md/dm-cache-policy-cleaner.c:144:25: warning: unused variable 'cur'=
 [-Wunused-variable]
drivers/md/dm-cache-policy-cleaner.c:158:1: warning: no return statement in=
 function returning non-void [-Wreturn-type]
drivers/md/dm-cache-policy-mq.c: In function 'hash_lookup':
drivers/md/dm-cache-policy-mq.c:375:44: error: macro "hlist_for_each_entry"=
 passed 4 arguments, but takes just 3
drivers/md/dm-cache-policy-mq.c:375:2: error: 'hlist_for_each_entry' undecl=
ared (first use in this function)
drivers/md/dm-cache-policy-mq.c:375:2: note: each undeclared identifier is =
reported only once for each function it appears in
drivers/md/dm-cache-policy-mq.c:376:3: error: expected ';' before 'if'
drivers/md/dm-cache-policy-mq.c:373:16: warning: unused variable 'e' [-Wunu=
sed-variable]
drivers/md/dm-cache-policy-mq.c:372:21: warning: unused variable 'tmp' [-Wu=
nused-variable]
drivers/md/dm-cache-policy-mq.c:371:21: warning: unused variable 'bucket' [=
-Wunused-variable]
drivers/md/dm-cache-policy-mq.c:383:1: warning: no return statement in func=
tion returning non-void [-Wreturn-type]

Caused by commit "hlist: drop the node parameter from iterators" from the
akpm tree interacting with commits b5dc50616996 ("A cache policy that
uses a multiqueue ordered by recent hit") and 9c44464a0aed ("A simple
cache policy that writes back all data to the origin") from the
device-mapper tree.

I applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 28 Feb 2013 12:09:42 +1100
Subject: [PATCH] hlist-drop-the-node-parameter-from-iterators-dm-cache-poli=
cy-fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/dm-cache-policy-cleaner.c | 3 +--
 drivers/md/dm-cache-policy-mq.c      | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-policy-cleaner.c b/drivers/md/dm-cache-pol=
icy-cleaner.c
index 6b0fdb0..43c270a 100644
--- a/drivers/md/dm-cache-policy-cleaner.c
+++ b/drivers/md/dm-cache-policy-cleaner.c
@@ -142,10 +142,9 @@ static struct wb_cache_entry *lookup_cache_entry(struc=
t policy *p, dm_oblock_t o
 	struct hash *hash =3D &p->chash;
 	unsigned h =3D hash_64(from_oblock(oblock), hash->hash_bits);
 	struct wb_cache_entry *cur;
-	struct hlist_node *tmp;
 	struct hlist_head *bucket =3D &hash->table[h];
=20
-	hlist_for_each_entry(cur, tmp, bucket, hlist) {
+	hlist_for_each_entry(cur, bucket, hlist) {
 		if (cur->oblock =3D=3D oblock) {
 			/* Move upfront bucket for faster access. */
 			hlist_del(&cur->hlist);
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-m=
q.c
index cd4582d..63ec258 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -369,10 +369,9 @@ static struct entry *hash_lookup(struct mq_policy *mq,=
 dm_oblock_t oblock)
 {
 	unsigned h =3D hash_64(from_oblock(oblock), mq->hash_bits);
 	struct hlist_head *bucket =3D mq->table + h;
-	struct hlist_node *tmp;
 	struct entry *e;
=20
-	hlist_for_each_entry(e, tmp, bucket, hlist)
+	hlist_for_each_entry(e, bucket, hlist)
 		if (e->oblock =3D=3D oblock) {
 			hlist_del(&e->hlist);
 			hlist_add_head(&e->hlist, bucket);
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Feb_2013_12_15_22_+1100_m7tVkt1j_Kljw6+H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRLq+qAAoJEECxmPOUX5FEYBUQAKJw8Eo6oHoDosCplPGgQ9PG
6IV675L6c7+5ULIKyZzeCRUujiNxDxT1Ncdgiv8w8ye2BjUCoVfnmqtYG9MZLV8b
Cn7FsVNZgnYQ07ZBTEW0JcSSfBexpT7yLW0Ts6GcYcmgt6g+Fb/+1DsHm6GpMWMo
h9mwzHibzXEm5H4U84yi1xkzTBWfsORaO+9h0peu305FNkrJsFW5CHaBNNohID0L
qs47/32R4DVdILeJjKcZAFB/VquYJU+ERbFMS2jGehotMSKLSvEffXrGfrPndPgB
8GiVqiPPCNHgOSqkCFL5xOtqMiwt22hMv6aZ1JTLAlb3Z4E4q7HVRlkosiCgrhSX
dTHWco1v10g2D/e4lRF/C5c4lGilTmcBJXHtbPQtShcYovclbJ+p5v1huPdaxhaE
54uIEdb8yzqplLFKi8Kfhm4KNsYTVWJpWqr00XDIAw+DkS6+fwBWZlRyBTnTS8aF
5cwE3r3w83OrIj2kowGDX2XulAI+FRjgQLY5PvTAUlJXtRbjyeuzKtLo6Y5SJy+0
fK8aeHbBm3V4/+HF3xKQi6HDxLDfaru0DGUs9T6bBfsnrzN0U+0BNLokaBUaFThh
oYfH2U2yhtKk4XHKRm8IURRCP0LwQ5e0+BGEqbBeOwW4W8QWKbRDdt7Wnc571U+b
udEu3PIst5Hfhp25AVyL
=Oh+w
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Feb_2013_12_15_22_+1100_m7tVkt1j_Kljw6+H--
