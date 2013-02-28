Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3B1CTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 21:19:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40193 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab3B1CTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 21:19:41 -0500
Date: Thu, 28 Feb 2013 13:19:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: oe Thornber <ejt@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>,
        Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: linux-next: build failure after merge of the final tree
 (device-mapper tree related)
Message-Id: <20130228131930.7d1f440a4c671e887253a2e4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Feb_2013_13_19_30_+1100_aylyw6bWy90j0Yn9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Feb_2013_13_19_30_+1100_aylyw6bWy90j0Yn9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/md/dm-cache-policy-cleaner.c: In function 'alloc_hash':
drivers/md/dm-cache-policy-cleaner.c:87:2: error: implicit declaration of f=
unction 'vzalloc' [-Werror=3Dimplicit-function-declaration]
drivers/md/dm-cache-policy-cleaner.c:87:14: warning: assignment makes point=
er from integer without a cast [enabled by default]
drivers/md/dm-cache-policy-cleaner.c: In function 'free_hash':
drivers/md/dm-cache-policy-cleaner.c:94:2: error: implicit declaration of f=
unction 'vfree' [-Werror=3Dimplicit-function-declaration]
drivers/md/dm-cache-policy-cleaner.c: In function 'alloc_cache_blocks_with_=
hash':
drivers/md/dm-cache-policy-cleaner.c:101:13: warning: assignment makes poin=
ter from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[3]: *** [drivers/md/dm-cache-policy-cleaner.o] Error 1
drivers/md/dm-cache-policy-mq.c: In function 'alloc_bitset':
drivers/md/dm-cache-policy-mq.c:32:2: error: implicit declaration of functi=
on 'vzalloc' [-Werror=3Dimplicit-function-declaration]
drivers/md/dm-cache-policy-mq.c:32:2: warning: return makes pointer from in=
teger without a cast [enabled by default]
drivers/md/dm-cache-policy-mq.c: In function 'free_bitset':
drivers/md/dm-cache-policy-mq.c:37:2: error: implicit declaration of functi=
on 'vfree' [-Werror=3Dimplicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/md/dm-cache-policy-mq.o] Error 1
drivers/md/dm-cache-target.c: In function 'alloc_bitset':
drivers/md/dm-cache-target.c:46:2: error: implicit declaration of function =
'vzalloc' [-Werror=3Dimplicit-function-declaration]
drivers/md/dm-cache-target.c:46:2: warning: return makes pointer from integ=
er without a cast [enabled by default]
drivers/md/dm-cache-target.c: In function 'free_bitset':
drivers/md/dm-cache-target.c:57:2: error: implicit declaration of function =
'vfree' [-Werror=3Dimplicit-function-declaration]

Caused by commits d5d224ab22e4 ("Add a target that allows a fast device
such as an SSD to be used as a"), b5dc50616996 ("A cache policy that uses
a multiqueue ordered by recent hit") and 9c44464a0aed ("A simple cache
policy that writes back all data to the origin") from the device-mapper
tree.

I added the following fix patch for today:

=46rom 0fe0a64ba2a600a10725318998c19e0b3820e6d7 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 28 Feb 2013 13:11:49 +1100
Subject: [PATCH] md: use of vmalloc et al needs vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/dm-cache-policy-cleaner.c | 1 +
 drivers/md/dm-cache-policy-mq.c      | 1 +
 drivers/md/dm-cache-target.c         | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/md/dm-cache-policy-cleaner.c b/drivers/md/dm-cache-pol=
icy-cleaner.c
index 43c270a..f43896f 100644
--- a/drivers/md/dm-cache-policy-cleaner.c
+++ b/drivers/md/dm-cache-policy-cleaner.c
@@ -12,6 +12,7 @@
 #include <linux/hash.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
=20
 /*----------------------------------------------------------------*/
=20
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-m=
q.c
index 63ec258..d62d0c1 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
=20
 #define DM_MSG_PREFIX "cache-policy-mq"
 #define MQ_VERSION	"1.0.0"
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 630f769..1215050 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -14,6 +14,7 @@
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
=20
 #define DM_MSG_PREFIX "cache"
=20
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__28_Feb_2013_13_19_30_+1100_aylyw6bWy90j0Yn9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRLr6yAAoJEECxmPOUX5FEFyIQAJAfSXyMYGaECzNyc58RhPnF
dnODB251ERZbtydmMtZEkDmdLrEsZGwRrEkYQK6X23xotc0o5SJtCX9Vo9PpkOHQ
B2lLez22q+D0IBw3AoWIOgcVI3sYByyjvayv9pNDZJkUl8AD0kkI84bgY5jnngWY
cE3qG8cxYlzHi8DAHOHPRDUB635MZiUWGu4JH+D/upumlfR0wCYciXcR4NUDh9Bo
4uh3jt4P8J/CsOyu5SeHdpc2Ni06gxqit+glOOeBw5PVdPnhyvGstvRyUs+sLbX5
GAVv0Nc64fHuXPtrZDgwl78wVdGNMzXbHMkS0Y7/Qkl8yB5iDn2mJKsKK/jsKDtt
2jCwVOvaskTyH4uFt59alC3FUtShI9OfUgWNvgUK/gzET8gn/y1ZSrRXYyuxqDZP
jyfjg8T25gcpZEFCFz2ijsUfmQgaSEDirKmfO9b8w+T7jjurYxluXRR9U9mSHUsF
+1S5KMSjgWND7lAkYIKfngvpYuOHy8l08S7cdO7DyE3ly9u7YO61wWhjfSNdi/3O
5NLkR9fX2Y1xT9ubGep39pksWarjGAMzB+VShyI5bkSRoc9T2TJGlnXn0FkIQvWr
PRCSE7+RrGYwn+BkaXid6ahxZxxsnvdo5SKqUVeJ0FS0dKroZZqC5TfSxuGkOiSg
eJBR34rZFrKk0jO7U1hg
=lfZo
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Feb_2013_13_19_30_+1100_aylyw6bWy90j0Yn9--
