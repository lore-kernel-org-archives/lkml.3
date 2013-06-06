Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3FFHPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:15:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48876 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3FFHPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:15:49 -0400
Date: Thu, 6 Jun 2013 17:15:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Glauber Costa <glommer@openvz.org>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20130606171536.4e1ee85adf1e12d2551bed74@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_17_15_36_+1000_GfOmtNty6329InaM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jun_2013_17_15_36_+1000_GfOmtNty6329InaM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

In file included from arch/sparc/include/asm/pgtable.h:6:0,
                 from include/linux/mm.h:50,
                 from include/linux/memcontrol.h:27,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from init/do_mounts.c:16:
arch/sparc/include/asm/pgtable_32.h:357:40: error: unknown type name 'swp_e=
ntry_t'
arch/sparc/include/asm/pgtable_32.h:362:42: error: unknown type name 'swp_e=
ntry_t'
arch/sparc/include/asm/pgtable_32.h:367:1: error: unknown type name 'swp_en=
try_t'
arch/sparc/include/asm/pgtable_32.h: In function '__swp_entry':
arch/sparc/include/asm/pgtable_32.h:369:10: error: 'swp_entry_t' undeclared=
 (first use in this function)
arch/sparc/include/asm/pgtable_32.h:369:10: note: each undeclared identifie=
r is reported only once for each function it appears in
arch/sparc/include/asm/pgtable_32.h:369:23: error: expected ';' before '{' =
token
In file included from include/linux/memcontrol.h:27:0,
                 from include/linux/swap.h:8,
                 from arch/sparc/include/asm/pgtable_32.h:17,
                 from arch/sparc/include/asm/pgtable.h:6,
                 from arch/sparc/kernel/traps_32.c:23:
include/linux/mm.h: In function 'is_vmalloc_addr':
include/linux/mm.h:322:17: error: 'VMALLOC_START' undeclared (first use in =
this function)
include/linux/mm.h:322:17: note: each undeclared identifier is reported onl=
y once for each function it appears in
include/linux/mm.h:322:41: error: 'VMALLOC_END' undeclared (first use in th=
is function)
include/linux/mm.h: In function 'maybe_mkwrite':
include/linux/mm.h:527:3: error: implicit declaration of function 'pte_mkwr=
ite' [-Werror=3Dimplicit-function-declaration]
In file included from arch/sparc/include/asm/pgtable.h:6:0,
                 from arch/sparc/kernel/traps_32.c:23:
arch/sparc/include/asm/pgtable_32.h: At top level:
arch/sparc/include/asm/pgtable_32.h:251:21: error: conflicting types for 'p=
te_mkwrite'
include/linux/mm.h:527:9: note: previous implicit declaration of 'pte_mkwri=
te' was here

Caused by commit 41aed1ec2e09 ("lru: add an element to a memcg list")
from the akpm tree.  This patch added an include of linux/mm.h to
linux/memcontrol.h, but that was unneeded as the rest of the patch only
added dependencies on pointers to struct page and struct mem_cgroup -
both of which are already declared in this header.

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Jun 2013 16:52:42 +1000
Subject: [PATCH] lru: memcontrol.h does not need mm.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/memcontrol.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c8b1412..57b8c2b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -24,7 +24,6 @@
 #include <linux/hardirq.h>
 #include <linux/jump_label.h>
 #include <linux/list_lru.h>
-#include <linux/mm.h>
=20
 struct mem_cgroup;
 struct page_cgroup;
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Jun_2013_17_15_36_+1000_GfOmtNty6329InaM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsDcfAAoJEECxmPOUX5FEKOkP/3u2/pj50jecRDqGMKc+RQSM
dte9PKxeMbJ34zg8110PKIEHx18Wli7to3lMIEmuvGwKAOQfOMKn8haZyx/1tDio
E1T7Mektr7J2tcmfgGWtxPRI62ip9FBUVLlwgpNTJM3AA/diKDneJxEcQeRTwl4A
20j+wObyev0+MZQx5nqS+KJvVzvLoEzISa2ZmHUGtNhSx2W/MGFQXDdvelPXbe9J
7TZ2IO/mdQXpHfEV/KoU6FwAa75B3MONkHxvv+iMysbmj0NEwLV9s+Rhz9PeHsq1
mI3X1myAVMeC/CoWTrvjH6aAwRTMtvYD8orLSuncNvNbCFQRj0QzAqIr07KaCvyn
u8cJ8X1p2FI8lUq4cn6wOd2f+MkSGB3KpnO0EUjrVwm3lQ4M+p0qzzo4kVqyXtXa
Cm83Dbndv7ax6DQ753bx/UZn2aiSzgWnp4uHym2tN2dUrHaUyRrnnx0gJ21iUJ3u
49sD9lpKrHheZ8CYNAOljDgJCgfFsZvwOBA5uD5ibuQ10+lujSX0Xto8GM0jxtej
P3MsEyh4D/IrQ14UAiosv+J4DDVfpG6rq1rakSm6QEYNBplkbN6rcDPOHsG5giVC
lF02O4IMbbgJaidlXTffRg1nCAJtP33wbnNMmImfq0sVewy9EXKxbRjC37oLB/VZ
NQ081hEeIyLozwC81ucI
=pbte
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_17_15_36_+1000_GfOmtNty6329InaM--
