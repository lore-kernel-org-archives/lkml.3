Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102AbaDXDv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 23:51:57 -0400
Received: from ozlabs.org ([103.22.144.67]:47261 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaDXDvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 23:51:55 -0400
Date: Thu, 24 Apr 2014 13:51:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20140424135147.81821116c74c49c07e5a3ed8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Apr_2014_13_51_47_+1000_4mvso6e6+xc1pQJc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Apr_2014_13_51_47_+1000_4mvso6e6+xc1pQJc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from arch/arm/include/asm/outercache.h:24:0,
                 from arch/arm/include/asm/barrier.h:5,
                 from arch/arm/include/asm/bitops.h:28,
                 from include/linux/bitops.h:33,
                 from include/linux/kernel.h:10,
                 from include/asm-generic/bug.h:13,
                 from arch/arm/include/asm/bug.h:61,
                 from arch/arm/include/asm/div64.h:63,
                 from include/linux/math64.h:5,
                 from include/linux/jiffies.h:4,
                 from init/calibrate.c:7:
include/linux/bug.h:91:47: warning: 'struct bug_entry' declared inside para=
meter list [enabled by default]
include/linux/bug.h:91:47: warning: its scope is only this definition or de=
claration, which is probably not what you want [enabled by default]
include/linux/bug.h: In function 'is_warning_bug':
include/linux/bug.h:93:12: error: dereferencing pointer to incomplete type
In file included from include/linux/kernel.h:11:0,
                 from include/asm-generic/bug.h:13,
                 from arch/arm/include/asm/bug.h:61,
                 from include/linux/bug.h:4,
                 from arch/arm/include/asm/outercache.h:24,
                 from arch/arm/include/asm/barrier.h:5,
                 from arch/arm/include/asm/bitops.h:28,
                 from include/linux/bitops.h:33,
                 from include/linux/signal.h:35,
                 from arch/arm/kernel/signal.c:12:
include/linux/log2.h: In function '__ilog2_u32':
include/linux/log2.h:34:2: error: implicit declaration of function 'fls' [-=
Werror=3Dimplicit-function-declaration]
include/linux/log2.h: In function '__ilog2_u64':
include/linux/log2.h:42:2: error: implicit declaration of function 'fls64' =
[-Werror=3Dimplicit-function-declaration]
include/linux/log2.h: In function '__roundup_pow_of_two':
include/linux/log2.h:63:2: error: implicit declaration of function 'fls_lon=
g' [-Werror=3Dimplicit-function-declaration]
In file included from include/linux/bitops.h:33:0,
                 from include/linux/signal.h:35,
                 from arch/arm/kernel/signal.c:12:
arch/arm/include/asm/bitops.h: At top level:
arch/arm/include/asm/bitops.h:273:19: error: static declaration of 'fls' fo=
llows non-static declaration
include/linux/log2.h:34:9: note: previous implicit declaration of 'fls' was=
 here

And many more ...

Guessing ... caused by commit febdbfe8a91c ("arch: Prepare for smp_mb__
{before,after}_atomic()") and following interacting with commit
735e532e0f25 ("ARM: outer cache: add WARN_ON() to outer_disable()") from
the arm tree?

I applied this fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 24 Apr 2014 13:46:08 +1000
Subject: [PATCH] ARM: outer cache: remove include of linux/bug.h from outer=
cache.h

It causes a circular inclusion and looks like it is not necessary anyway.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/include/asm/outercache.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outer=
cache.h
index eaa8a28c6871..891a56b35bcf 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -21,7 +21,6 @@
 #ifndef __ASM_OUTERCACHE_H
 #define __ASM_OUTERCACHE_H
=20
-#include <linux/bug.h>
 #include <linux/types.h>
=20
 struct outer_cache_fns {
--=20
2.0.0.rc0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_Apr_2014_13_51_47_+1000_4mvso6e6+xc1pQJc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTWIpYAAoJEMDTa8Ir7ZwVw68P/1U1pSrQJwkjfEWRWIsmm4XL
fREE6QT4vE9j67EOjPhOQI0c1fCNQXrQJVK3IzqmejuwwNwRg30jmHbMqHTgeU4n
aE8bsnZMjqgWh2x+eizECZSeBNrn7CQaI4R3Gu5IH5BT9RsT2qEfqMfHBQcW+7hZ
YXx7neU2ucDDKM47uVIB9XAuFjkmelPLENxAS5xFFYr6yplkjd1Qhy+g9DKiODly
xYKgjNMiancy4kd10ISoGUoLOgNAvtGzr6ceSUqYWjcqm7nHrhOyLoB9TXKe2r1C
6ljrd5UTTupRjz9A9XkJXbwfxbUNHOnX+UWr9qpqWp1XfhavfAN1djnTfWGeAhtN
MOeZpNi/fWfuULHBN8CGtw+c4RARe1K1pfDlO2CtSu/TSazLANzdEOwgMLN8Pho8
XbaAAYD4gwR7CzpP8CA9t/h7qIe0tlK+l3cxvP8JTQ0Ln0i7WNUScSUPa77hfIZD
+w9Juee6znirbuhUFlXMyMnGltUlAVBEPTZMU2wFHotoYnnvtlkcEqmqP5WPn+vI
2o6gwVoRtl2pShRK926fvWDEQ2JGP4xz8fEWg3GGBee+WrEbcnXu3pS45fs3rWDq
SH2mnL2gF8mU1Voc5vqlaTpkVe0+8y5ve+3xf7fD/GXh2Uc50Zv9S9htS9tnDDk6
Hv/E9l/R9gJml5ZPoWwl
=hQHv
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Apr_2014_13_51_47_+1000_4mvso6e6+xc1pQJc--
