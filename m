Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3H1ELk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 00:11:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50007 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3H1ELj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 00:11:39 -0400
Date: Wed, 28 Aug 2013 14:11:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>, Ken Steele <ken@tilera.com>
Subject: linux-next: manual merge of the md tree with the arm tree
Message-Id: <20130828141126.8a59cb1f0bee3a5977ad3821@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Aug_2013_14_11_26_+1000_HGQ0FQNMjmin/lWN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Aug_2013_14_11_26_+1000_HGQ0FQNMjmin/lWN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next merge of the md tree got conflicts in
lib/raid6/Makefile and lib/raid6/test/Makefile between commit
7d11965ddb9b ("lib/raid6: add ARM-NEON accelerated syndrome calculation")
from the arm tree and commit ae77cbc1e7b9 ("RAID: add tilegx SIMD
implementation of raid6") from the md tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/raid6/Makefile
index b462578,e5e9021..0000000
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@@ -5,7 -5,7 +5,8 @@@ raid6_pq-y	+=3D algos.o recov.o tables.o=20
 =20
  raid6_pq-$(CONFIG_X86) +=3D recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.=
o avx2.o
  raid6_pq-$(CONFIG_ALTIVEC) +=3D altivec1.o altivec2.o altivec4.o altivec8=
.o
 +raid6_pq-$(CONFIG_KERNEL_MODE_NEON) +=3D neon.o neon1.o neon2.o neon4.o n=
eon8.o
+ raid6_pq-$(CONFIG_TILEGX) +=3D tilegx8.o
 =20
  hostprogs-y	+=3D mktables
 =20
@@@ -86,28 -71,9 +87,32 @@@ $(obj)/altivec8.c:   UNROLL :=3D=20
  $(obj)/altivec8.c:   $(src)/altivec.uc $(src)/unroll.awk FORCE
  	$(call if_changed,unroll)
 =20
 +CFLAGS_neon1.o +=3D $(NEON_FLAGS)
 +targets +=3D neon1.c
 +$(obj)/neon1.c:   UNROLL :=3D 1
 +$(obj)/neon1.c:   $(src)/neon.uc $(src)/unroll.awk FORCE
 +	$(call if_changed,unroll)
 +
 +CFLAGS_neon2.o +=3D $(NEON_FLAGS)
 +targets +=3D neon2.c
 +$(obj)/neon2.c:   UNROLL :=3D 2
 +$(obj)/neon2.c:   $(src)/neon.uc $(src)/unroll.awk FORCE
 +	$(call if_changed,unroll)
 +
 +CFLAGS_neon4.o +=3D $(NEON_FLAGS)
 +targets +=3D neon4.c
 +$(obj)/neon4.c:   UNROLL :=3D 4
 +$(obj)/neon4.c:   $(src)/neon.uc $(src)/unroll.awk FORCE
 +	$(call if_changed,unroll)
 +
 +CFLAGS_neon8.o +=3D $(NEON_FLAGS)
 +targets +=3D neon8.c
 +$(obj)/neon8.c:   UNROLL :=3D 8
 +$(obj)/neon8.c:   $(src)/neon.uc $(src)/unroll.awk FORCE
++
+ targets +=3D tilegx8.c
+ $(obj)/tilegx8.c:   UNROLL :=3D 8
+ $(obj)/tilegx8.c:   $(src)/tilegx.uc $(src)/unroll.awk FORCE
  	$(call if_changed,unroll)
 =20
  quiet_cmd_mktable =3D TABLE   $@
diff --cc lib/raid6/test/Makefile
index 28afa1a,cf49592..0000000
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@@ -36,11 -27,8 +36,11 @@@ ifeq ($(IS_X86),yes
          CFLAGS +=3D $(shell echo "vpbroadcastb %xmm0, %ymm1" |	\
                      gcc -c -x assembler - >&/dev/null &&	\
                      rm ./-.o && echo -DCONFIG_AS_AVX2=3D1)
 +else ifeq ($(HAS_NEON),yes)
 +        OBJS   +=3D neon.o neon1.o neon2.o neon4.o neon8.o
 +        CFLAGS +=3D -DCONFIG_KERNEL_MODE_NEON=3D1
  else
-         HAS_ALTIVEC :=3D $(shell echo -e '\#include <altivec.h>\nvector i=
nt a;' |\
+         HAS_ALTIVEC :=3D $(shell printf '\#include <altivec.h>\nvector in=
t a;\n' |\
                           gcc -c -x c - >&/dev/null && \
                           rm ./-.o && echo yes)
          ifeq ($(HAS_ALTIVEC),yes)
@@@ -113,7 -95,8 +119,8 @@@ tables.c: mktable
  	./mktables > tables.c
 =20
  clean:
 -	rm -f *.o *.a mktables mktables.c *.uc int*.c altivec*.c tables.c raid6t=
est
 +	rm -f *.o *.a mktables mktables.c *.uc int*.c altivec*.c neon*.c tables.=
c raid6test
+ 	rm -f tilegx*.c
 =20
  spotless: clean
  	rm -f *~

--Signature=_Wed__28_Aug_2013_14_11_26_+1000_HGQ0FQNMjmin/lWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHXhyAAoJEECxmPOUX5FEBVEQAJfVC8i1FiA5MfZzbuOwMbwW
D9CdbFaeH8CYrgKmV7ngTIUAXxcJkZDgR5vVMRX2yo/BhA9LIeTY/ckJ9GA48OBL
YZt5kUomyZtKQU8hj9XvtqhG2f0T0RDv6cgW2Hy8YBGDtMHqkBCFkJCVx4Tdfndk
QJgcFhQXjIJNvs7MaSGsJ4MIi7BWcyI2f/FFyEOweOKk5Uk0i/buq5jGWYoD3mOu
PzJKFyhu2IbvA8LSs2jCn7LN3qYaYAaqgEbuPRMeuJ1jtLYUnTrVLmvRDczGLkOY
6LGhOkiYZWsH18crd7fhhpRm34CEfNvHoHDCqJ2j8D9PHWtP2mSHdM5I61ONUyKp
XHQmZfJs3aGXV7Iq+vcbFt9llT9D+xKnsDy5jAiME/FLWsD4kLEwi6Z6JnaDwhBh
OX6L+3g0jRHQ4mICeVfcWIK/tvBKxYe+83IiAyrIaZao1ARsVEzFJx6+WL+QV7mg
T8L1xHwMjH2eO1jdA6XXo4kxFJip7tVUpaZ3+Igdln2W62taWwnJps0FFXBgdMHG
20QVy+4ZP+oqQxqO7l8Hah1i5XrzLVA1mToKpzMqK8JNdm6qCou7UlfBRcpO1qwq
H7xZ6YcPpAUh2s+HDX2Fk+qjCGjl+0t+ku7itQ8/Ruf8A39ydOmHlbfgBVFQtihB
hfPo9H0R2s7BmgmzKvON
=2lPu
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Aug_2013_14_11_26_+1000_HGQ0FQNMjmin/lWN--
