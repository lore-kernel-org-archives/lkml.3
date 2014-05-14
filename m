Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaENHr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:47:59 -0400
Received: from ozlabs.org ([103.22.144.67]:37389 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaENHr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:47:57 -0400
Date: Wed, 14 May 2014 17:47:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140514174749.1ec4d37f@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Kq._m=Eyug.o66EvUr4vXOx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Kq._m=Eyug.o66EvUr4vXOx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

mm/memcontrol.c: In function 'mem_cgroup_write':
mm/memcontrol.c:5088:45: error: 'buffer' undeclared (first use in this func=
tion)
   ret =3D res_counter_memparse_write_strategy(buffer, &val);
                                             ^
mm/memcontrol.c: At top level:
/scratch/sfr/next/mm/memcontrol.c:6029:3: error: unknown field 'write_strin=
g' specified in initializer
   .write_string =3D mem_cgroup_write,
   ^

Caused by commit a4bf584ed8c2 ("memcg: allow setting low_limit")
interacting with commit 451af504df0c ("cgroup: replace
cftype->write_string() with cftype->write()") from the cgroup tree.
(I love API changes and unnecessary variable renaming :-()

I applied the following merge fix patch and can carry it as necessary:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 14 May 2014 17:42:00 +1000
Subject: [PATCH] memcg: update for change from write_string() to write()

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 493175e616e3..98e38b50cc82 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5085,7 +5085,7 @@ static ssize_t mem_cgroup_write(struct kernfs_open_fi=
le *of,
 			ret =3D -EINVAL;
 			break;
 		}
-		ret =3D res_counter_memparse_write_strategy(buffer, &val);
+		ret =3D res_counter_memparse_write_strategy(buf, &val);
 		if (ret)
 			break;
 		if (type =3D=3D _MEM) {
@@ -6026,7 +6026,7 @@ static struct cftype mem_cgroup_files[] =3D {
 	{
 		.name =3D "low_limit_in_bytes",
 		.private =3D MEMFILE_PRIVATE(_MEM, RES_LOW_LIMIT),
-		.write_string =3D mem_cgroup_write,
+		.write =3D mem_cgroup_write,
 		.read_u64 =3D mem_cgroup_read_u64,
 	},
 	{
--=20
2.0.0.rc2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Kq._m=Eyug.o66EvUr4vXOx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcx+qAAoJEMDTa8Ir7ZwVa/IP/07w47tDfmobz+LvBHefnRVu
TlMbUPc+G76iSupuIkwMwqrZSQ7L6WkbX1/iXDl6VJC/58bOZIMTKIptgDuvbuKP
ND0FKKseEXLWgvAUwiKZJeIHLW6yPasgq9t5C0z9AqYH4B3NHbp0ZP/7632Xtq1t
tMugasjTmE93N5d7jkUj0pZ6b9BqM/RO3LRCGotdROjhiNwx4z1vtNXDr7e0xfe9
MOjyLmbPgwrb0w36Q1dq+4es2YE2WVUA9nK9hcgx7YF7duyEhBHLv5W47BIBXb6v
fr34IEiBNMGWhwdtPFAK8OfzSVVhNNTuHokajQTb0zp4hjJXrQF1M7bLXZ/Ri6jX
PO8dNdosbzjyjVmwzIPvw5DTKSELsXgtoyEaBML6WCLY2YmRTnJmY3vcN/hxw6A5
byRpGxdzGyCIlOm4aR9KC/fPFiNL9fKkydqCvnm1hmv5WNvut9rlOZ7N/T931MRF
SSWMxLTIKpW9nNYbLzxTT1GhGZkOFSqF8bsSQbkXmKNRFw3iR6XHsZs6CGvtwRcE
carNi+jtHNX9TZTrMZRr1ndgcOawfvsG3fnhsVpbzsn4KMq3kWsRkBV9NrLolBep
m9HJIaqhIL9ZWLWuQWnPYvivXgpPwlwivjV+debgg5Mq0ZnI06f+mIXf7AWUHCCs
wBJltZtq3tSinL4o6k8b
=7YfV
-----END PGP SIGNATURE-----

--Sig_/Kq._m=Eyug.o66EvUr4vXOx--
