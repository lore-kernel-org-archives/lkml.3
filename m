Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaKFLYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 06:24:09 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42243 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaKFLYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 06:24:04 -0500
Date: Thu, 6 Nov 2014 12:24:00 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20141106112359.GJ26297@ulmo>
References: <20141106193618.461c3ae7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
Content-Disposition: inline
In-Reply-To: <20141106193618.461c3ae7@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qo8f1a4rgWw9S/zY
Content-Type: multipart/mixed; boundary="BOmey7/79ja+7F5w"
Content-Disposition: inline


--BOmey7/79ja+7F5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 07:36:18PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
>=20
> After merging the akpm tree, today's linux-next build (sparc defconfig)
> failed like this:
>=20
> mm/slab.c: In function 'slab_alloc':
> mm/slab.c:3260:4: error: implicit declaration of function 'slab_free' [-W=
error=3Dimplicit-function-declaration]
>     slab_free(cachep, objp);
>     ^
> mm/slab.c: At top level:
> mm/slab.c:3534:29: warning: conflicting types for 'slab_free'
>  static __always_inline void slab_free(struct kmem_cache *cachep, void *o=
bjp)
>                              ^
> mm/slab.c:3534:29: error: static declaration of 'slab_free' follows non-s=
tatic declaration
> mm/slab.c:3260:4: note: previous implicit declaration of 'slab_free' was =
here
>     slab_free(cachep, objp);
>     ^
>=20
> I am not sure what caused this, but it is something in the akpm-current
> or akpm trees (possibly interacting with something else).

I fixed this using the attached patch.

Thierry

--BOmey7/79ja+7F5w
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="0001-mm-slab-Always-predeclare-slab_free.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a9ec6cfacb892e044a5f76dce3b7fc9a3337d01a Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <treding@nvidia.com>
Date: Thu, 6 Nov 2014 11:59:23 +0100
Subject: [PATCH] mm/slab: Always predeclare slab_free()

Commit 5da1c3c725ab ("slab: recharge slab pages to the allocating memory
cgroup") added a predeclaration of the new slab_free() helper so that it
can be used in slab_alloc_node() and slab_alloc(). However the prototype
is added in an #ifdef CONFIG_NUMA protected section of code, which works
fine for slab_alloc_node() but fails for slab_alloc().

Fixes the following build warnings and errors:

	mm/slab.c: In function 'slab_alloc':
	mm/slab.c:3260:4: error: implicit declaration of function 'slab_free' [-We=
rror=3Dimplicit-function-declaration]
	    slab_free(cachep, objp);
	    ^
	mm/slab.c: At top level:
	mm/slab.c:3534:29: warning: conflicting types for 'slab_free'
	 static __always_inline void slab_free(struct kmem_cache *cachep, void *ob=
jp)
				     ^
	mm/slab.c:3534:29: error: static declaration of 'slab_free' follows non-st=
atic declaration
	mm/slab.c:3260:4: note: previous implicit declaration of 'slab_free' was h=
ere
	    slab_free(cachep, objp);
	    ^

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 mm/slab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 61b01c2ae1d9..00cd028404cb 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2961,6 +2961,8 @@ out:
 	return objp;
 }
=20
+static __always_inline void slab_free(struct kmem_cache *cachep, void *obj=
p);
+
 #ifdef CONFIG_NUMA
 /*
  * Try allocating on another node if PFA_SPREAD_SLAB is a mempolicy is set.
@@ -3133,8 +3135,6 @@ done:
 	return obj;
 }
=20
-static __always_inline void slab_free(struct kmem_cache *cachep, void *obj=
p);
-
 static __always_inline void *
 slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 		   unsigned long caller)
--=20
2.1.3


--BOmey7/79ja+7F5w--

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUW1pPAAoJEN0jrNd/PrOh4yUP/3RJxro5l7lPp/gdJx/qFCRR
hiN782iIOu/v0EIecz/gYuX7EGR1uClkWYMouKGXdiW4easjKdf6Zv2msY2FuRAi
webFkxRAzx9Ap5knAagG9myXKCixzhTM+A9HbSkzYXwB4sMNgVOo0RgqZtmf1ab8
xrlPEf3jDfqgxH5qcDkdcfwIPiq4rJJyh7ArXmfI7appQPaLfutkpWjKMCvpyQL0
FzSzlUEMLMaMC6Uk5gZPrnyfXYR30iBbCznkqEKJZ5kRzkhU8VV69Z49Ax14aU5O
pES1XCDazIjJXBGz2FS6hVG2vdCWAIFIPZboXb2JibLPVoN+Gg6I1Hq2KG8D7/50
ssE4y4glxFJ7RRq7NLE5+NjM6wJmJ7nnhz4cX1O+ReckTA7pV8A4+t0acDP9Eaep
wsWPvBU0zpdfF9D8T9mBRjPqFFlcU8Sn0cRxW/hmbnpHGAgR+7HMkGB8/a3qjYXo
iww6WJvxISrkl1R8jykyRnTRqc3ZzQVzao5mDzk8pyzkk3bFVwJcb84WXw5ZA2hP
2TuX9/xSbZ+bc5IGa/4zGL2XW34oasilF66LpmJGp7Gzww/9uhYvleZBsk4VCVCA
wm0jTRKOD/cxYvcKshrmG35PNEK0JiIppwCSVmoV8LhEi540bCFb1O63tBV92SqW
4cRyqXoA2FVcjfcWzsSY
=v0+H
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
