Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaAFAPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 19:15:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaAFAPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 19:15:43 -0500
Date: Mon, 6 Jan 2014 11:15:29 +1100
From: NeilBrown <neilb@suse.de>
To: Andrea Mazzoleni <amadvance@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] lib: raid: New RAID library supporting up to six parities
Message-ID: <20140106111529.7bcff024@notabene.brown>
In-Reply-To: <1388742436-3754-1-git-send-email-amadvance@gmail.com>
References: <1388742436-3754-1-git-send-email-amadvance@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XAib6=fZd8RphMO6bZcWJ=I"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XAib6=fZd8RphMO6bZcWJ=I
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  3 Jan 2014 10:47:16 +0100 Andrea Mazzoleni <amadvance@gmail.com>
wrote:

> This patch adds a new lib/raid directory, containing a new RAID support
> based on a Cauchy matrix working for up to six parities, and backward
> compatible with the existing RAID6 support.

Hi Andrea,
 thanks for this.  I suspect it is probably a good idea to include this as =
we
 are very likely to get multi-parity RAID at some stage and having this will
 be a good first step.
 I don't really feel motivated to review all this code though... I'm hoping
 that someone(s) else might can could comment.

 Also, while there are some good comments in there, I feel there could be
 more :-)
 e.g: what function(s) do I actually call to create or check the extra pari=
ty
 blocks? I'm sure I could find out by reading the code but I'd rather read
 some documentation.
 And what is "raid_sort()" all about ... I didn't expect to find a sort
 function in there (that can sort an array of length up-to 6).

 Also though would ultimately need to be accessible via the 'async_tx'
 interface so that hardware-offload could be supported.  So I would need to
 know that the design will fit nicely into that interface.
 Providing the interface can certainly come later, but being sure that the
 current code a good match would help now.

 So: anyone out there keen to review this code at give me a
    Reviewed-by:=20
 ??

Thanks,
NeilBrown



>=20
> It was developed for kernel 3.13-rc4, but it should work with any other
> version because it's mostly formed of new files. The only modification
> is about adding a new CONFIG_RAID_CAUCHY option in the "lib" configuration
> section.
>=20
> The main interface is defined in include/linux/raid/raid.h and provides
> easy to use functions able to generate parities and to recover data.
> This interface is different than the one provided by the RAID6 library,
> because with more parities the number of recovering cases grows exponenti=
ally
> and it's not feasible to have a different function for each one.
>=20
> The library provides fast implementations using SSE2 and SSSE3 for x86/x64
> and a portable C implementation working everythere.
> If the RAID6 library is enabled in the kernel, its functionality is also =
used
> to maintain the existing level of performance for the first two parities =
in
> all the supported architectures.
>=20
> At startup the module runs a very fast self test (about 1ms) to ensure th=
at
> the used functions are correct.
> I verified that the module builds, loads and passes the self test in the =
x86,
> and x64 architectures. I expects no problems in other platforms, but at n=
ow
> they are not really tested. I only simulated similar conditions.
>=20
> In the lib/raid/test directory are present also some user mode test progr=
ams:
> selftest - Runs the same selftest executed at the module startup.
> fulltest - Runs a more extensive test that checks all the built-in functi=
ons.
> speetest - Runs a speed test in memory.
>=20
> As a reference, in my icore7 2.7GHz the speedtest program reports:
>=20
> ...
> Speed test using 16 data buffers of 4096 bytes, for a total of 64 KiB.
> Memory blocks have a displacement of 64 bytes to improve cache performanc=
e.
> The reported value is the aggregate bandwidth of all data blocks in MiB/s,
> not counting parity blocks.
>=20
> Memory write speed using the C memset() function:
>   memset   33518
>=20
> RAID functions used for computing the parity:
>             int8   int32   int64    sse2   sse2e   ssse3  ssse3e
>     par1           11762   21450   44621
>     par2            3520    6176   18100   20338
>     par3     848                                    8009    9210
>     par4     659                                    6518    7303
>     par5     531                                    4931    5363
>     par6     430                                    4069    4471
>=20
> RAID functions used for recovering:
>             int8   ssse3
>     rec1     591    1126
>     rec2     272     456
>     rec3      80     305
>     rec4      49     216
>     rec5      34     151
> ...
>=20
> Legend:
> parX functions to generate X parities
> recX functions to recover X data blocks
> int8 implemention based on 8 bits arithmetics
> int32 implemention based on 32 bits arithmetics
> int64 implemention based on 64 bits arithmetics
> sse2 implemention based on SSE2
> sse2e implemention based on SSE2 with 16 registers (x64)
> ssse3 implemention based on SSSE3
> ssse3e implemention based on SSSE3 with 16 registers (x64)
>=20
> Signed-off-by: Andrea Mazzoleni <amadvance@gmail.com>
> ---
> This a bunch of new code, and some context could help to understand what's
> going on.
>=20
> This is a port of the RAID engine that I'm currently using in my hobby pr=
oject
> called SnapRAID. This project was initially based on the Linux RAID6 libr=
ary,
> and then limited to support only two parities like the Linux kernel itsel=
f.
>=20
> How to extend the RAID6 logic to support more parities was not so obvious,
> and it was also a recurring argument in the linux-raid mailing list in the
> past years. Unfortunately, with no general solution ever proposed.
>=20
> It took some time, but finally I found a way to do it keeping backward
> compatibility with RAID6, using a specially built Cauchy matrix.
>=20
> After implementing this support for my hobby project I got this solution =
also
> discussed in the linux-raid/linux-btrfs mailing list in November in the t=
hread
> "Triple parity and beyond":
>=20
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/30159
>=20
> This patch is the implementation of such discussion, done porting my exis=
ting
> code to the kernel environment.
>=20
> The code compiles without warnings with gcc -Wall -Wextra, with the clang
> analyzer, and it runs cleany with valgrind.
> The checkpatch.pl robot still report some issues. The errors are all false
> positives that I was not able to workaround. The remaining warnings are
> intentionally not fixed because that would make the code more difficult t=
o read,
> or are others false positive.
>=20
> Please let me know what do you think. Any kind of feedback is welcome.
>=20
> Thanks,
> Andrea
>=20
>  include/linux/raid/raid.h |   86 +++
>  lib/Kconfig               |   12 +
>  lib/Makefile              |    1 +
>  lib/raid/Makefile         |   14 +
>  lib/raid/cpu.h            |   44 ++
>  lib/raid/gf.h             |  109 ++++
>  lib/raid/int.c            |  567 ++++++++++++++++
>  lib/raid/internal.h       |  146 +++++
>  lib/raid/mktables.c       |  338 ++++++++++
>  lib/raid/module.c         |  437 +++++++++++++
>  lib/raid/raid.c           |  425 ++++++++++++
>  lib/raid/sort.c           |   72 +++
>  lib/raid/test/Makefile    |   33 +
>  lib/raid/test/combo.h     |  155 +++++
>  lib/raid/test/fulltest.c  |   76 +++
>  lib/raid/test/memory.c    |   79 +++
>  lib/raid/test/memory.h    |   74 +++
>  lib/raid/test/selftest.c  |   41 ++
>  lib/raid/test/speedtest.c |  567 ++++++++++++++++
>  lib/raid/test/test.c      |  314 +++++++++
>  lib/raid/test/test.h      |   59 ++
>  lib/raid/test/usermode.h  |   83 +++
>  lib/raid/test/xor.c       |   41 ++
>  lib/raid/x86.c            | 1569 +++++++++++++++++++++++++++++++++++++++=
++++++
>  24 files changed, 5342 insertions(+)
>  create mode 100644 include/linux/raid/raid.h
>  create mode 100644 lib/raid/Makefile
>  create mode 100644 lib/raid/cpu.h
>  create mode 100644 lib/raid/gf.h
>  create mode 100644 lib/raid/int.c
>  create mode 100644 lib/raid/internal.h
>  create mode 100644 lib/raid/mktables.c
>  create mode 100644 lib/raid/module.c
>  create mode 100644 lib/raid/raid.c
>  create mode 100644 lib/raid/sort.c
>  create mode 100644 lib/raid/test/Makefile
>  create mode 100644 lib/raid/test/combo.h
>  create mode 100644 lib/raid/test/fulltest.c
>  create mode 100644 lib/raid/test/memory.c
>  create mode 100644 lib/raid/test/memory.h
>  create mode 100644 lib/raid/test/selftest.c
>  create mode 100644 lib/raid/test/speedtest.c
>  create mode 100644 lib/raid/test/test.c
>  create mode 100644 lib/raid/test/test.h
>  create mode 100644 lib/raid/test/usermode.h
>  create mode 100644 lib/raid/test/xor.c
>  create mode 100644 lib/raid/x86.c
>=20
> diff --git a/include/linux/raid/raid.h b/include/linux/raid/raid.h
> new file mode 100644
> index 0000000..9b5e441
> --- /dev/null
> +++ b/include/linux/raid/raid.h
> @@ -0,0 +1,86 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_H
> +#define __RAID_H
> +
> +#ifdef __KERNEL__ /* to build the user mode test */
> +#include <linux/types.h>
> +#endif
> +
> +/**
> + * Max number of parity disks supported.
> + */
> +#define RAID_PARITY_MAX 6
> +
> +/**
> + * Maximum number of data disks supported.
> + */
> +#define RAID_DATA_MAX 251
> +
> +/**
> + * Computes the parity.
> + *
> + * @nd Number of data blocks.
> + * @np Number of parities blocks to compute.
> + * @size Size of the blocks pointed by @v. It must be a multipler of 64.
> + * @v Vector of pointers to the blocks of data and parity.
> + *   It has (@nd + @np) elements. The starting elements are the blocks f=
or
> + *   data, following with the parity blocks.
> + *   Each blocks has @size bytes.
> + */
> +void raid_par(int nd, int np, size_t size, void **v);
> +
> +/**
> + * Recovers failures in data and parity blocks.
> + *
> + * All the data and parity blocks marked as bad in the @id and @ip vector
> + * are recovered and recomputed.
> + *
> + * The parities blocks to use for recovering are automatically selected =
from
> + * the ones NOT present in the @ip vector.
> + *
> + * Ensure to have @nrd + @nrp <=3D @np, otherwise recovering is not poss=
ible.
> + *
> + * @nrd Number of failed data blocks to recover.
> + * @id[] Vector of @nrd indexes of the data blocks to recover.
> + *   The indexes start from 0. They must be in order.
> + * @nrp Number of failed parity blocks to recover.
> + * @ip[] Vector of @nrp indexes of the parity blocks to recover.
> + *   The indexes start from 0. They must be in order.
> + *   All the parities not specified here are assumed correct, and they a=
re
> + *   not recomputed.
> + * @nd Number of data blocks.
> + * @np Number of parity blocks.
> + * @size Size of the blocks pointed by @v. It must be a multipler of 64.
> + * @v Vector of pointers to the blocks of data and parity.
> + *   It has (@nd + @np) elements. The starting elements are the blocks
> + *   for data, following with the parity blocks.
> + *   Each blocks has @size bytes.
> + */
> +void raid_rec(int nrd, int *id, int nrp, int *ip, int nd, int np, size_t=
 size, void **v);
> +
> +/**
> + * Sorts a small vector of integers.
> + *
> + * If you have block indexes not in order, you can use this function to =
sort
> + * them before callign raid_rec().
> + *
> + * @n Number of integers. No more than RAID_PARITY_MAX.
> + * @v Vector of integers.
> + */
> +void raid_sort(int n, int *v);
> +
> +#endif
> +
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 991c98b..a77ffbe 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -10,6 +10,18 @@ menu "Library routines"
>  config RAID6_PQ
>  	tristate
> =20
> +config RAID_CAUCHY
> +	tristate "RAID Cauchy functions"
> +	help
> +	  This option enables the RAID parity library based on a Cauchy matrix
> +	  that supports up to six parities, and it's compatible with the
> +	  existing RAID6 support.
> +	  This library provides optimized functions for architectures with
> +	  SSSE3 support.
> +	  If the RAID6 module is enabled, it's automatically used to
> +	  maintain the same performance level in all the architectures.
> +	  Module will be called raid_cauchy.
> +
>  config BITREVERSE
>  	tristate
> =20
> diff --git a/lib/Makefile b/lib/Makefile
> index a459c31..8b76716 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -79,6 +79,7 @@ obj-$(CONFIG_LZ4HC_COMPRESS) +=3D lz4/
>  obj-$(CONFIG_LZ4_DECOMPRESS) +=3D lz4/
>  obj-$(CONFIG_XZ_DEC) +=3D xz/
>  obj-$(CONFIG_RAID6_PQ) +=3D raid6/
> +obj-$(CONFIG_RAID_CAUCHY) +=3D raid/
> =20
>  lib-$(CONFIG_DECOMPRESS_GZIP) +=3D decompress_inflate.o
>  lib-$(CONFIG_DECOMPRESS_BZIP2) +=3D decompress_bunzip2.o
> diff --git a/lib/raid/Makefile b/lib/raid/Makefile
> new file mode 100644
> index 0000000..b8c1df5
> --- /dev/null
> +++ b/lib/raid/Makefile
> @@ -0,0 +1,14 @@
> +obj-$(CONFIG_RAID_CAUCHY) +=3D raid_cauchy.o
> +
> +raid_cauchy-y	+=3D module.o raid.o tables.o int.o
> +
> +raid_cauchy-$(CONFIG_X86) +=3D x86.o
> +
> +hostprogs-y	+=3D mktables
> +
> +quiet_cmd_mktable =3D TABLE   $@
> +      cmd_mktable =3D $(obj)/mktables > $@ || ( rm -f $@ && exit 1 )
> +
> +targets +=3D tables.c
> +$(obj)/tables.c: $(obj)/mktables FORCE
> +	$(call if_changed,mktable)
> diff --git a/lib/raid/cpu.h b/lib/raid/cpu.h
> new file mode 100644
> index 0000000..3202fa9
> --- /dev/null
> +++ b/lib/raid/cpu.h
> @@ -0,0 +1,44 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_CPU_H
> +#define __RAID_CPU_H
> +
> +#ifdef CONFIG_X86
> +static inline int raid_cpu_has_sse2(void)
> +{
> +	return boot_cpu_has(X86_FEATURE_XMM2);
> +}
> +
> +static inline int raid_cpu_has_ssse3(void)
> +{
> +	/* checks also for SSE2 */
> +	/* likely it's implicit but it doesn't harm */
> +	return boot_cpu_has(X86_FEATURE_XMM2)
> +		&& boot_cpu_has(X86_FEATURE_SSSE3);
> +}
> +
> +static inline int raid_cpu_has_avx2(void)
> +{
> +	/* checks also for SSE2 and SSSE3 */
> +	/* likely it's implicit but it doesn't harm */
> +	return boot_cpu_has(X86_FEATURE_XMM2)
> +		&& boot_cpu_has(X86_FEATURE_SSSE3)
> +		&& boot_cpu_has(X86_FEATURE_AVX)
> +		&& boot_cpu_has(X86_FEATURE_AVX2);
> +}
> +#endif
> +
> +#endif
> +
> diff --git a/lib/raid/gf.h b/lib/raid/gf.h
> new file mode 100644
> index 0000000..f444e63
> --- /dev/null
> +++ b/lib/raid/gf.h
> @@ -0,0 +1,109 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_GF_H
> +#define __RAID_GF_H
> +
> +/*
> + * Galois field operations.
> + *
> + * Basic range checks are implemented using BUG_ON().
> + */
> +
> +/*
> + * GF a*b.
> + */
> +static __always_inline uint8_t mul(uint8_t a, uint8_t b)
> +{
> +	return gfmul[a][b];
> +}
> +
> +/*
> + * GF 1/a.
> + * Not defined for a =3D=3D 0.
> + */
> +static __always_inline uint8_t inv(uint8_t v)
> +{
> +	BUG_ON(v =3D=3D 0); /* division by zero */
> +
> +	return gfinv[v];
> +}
> +
> +/*
> + * GF 2^a.
> + */
> +static __always_inline uint8_t pow2(int v)
> +{
> +	BUG_ON(v < 0 || v > 254); /* invalid exponent */
> +
> +	return gfexp[v];
> +}
> +
> +/*
> + * Gets the multiplication table for a specified value.
> + */
> +static __always_inline const uint8_t *table(uint8_t v)
> +{
> +	return gfmul[v];
> +}
> +
> +/*
> + * Gets the generator matrix coefficient for parity 'p' and disk 'd'.
> + */
> +static __always_inline uint8_t A(int p, int d)
> +{
> +	return gfgen[p][d];
> +}
> +
> +/*
> + * Dereference as uint8_t
> + */
> +#define v_8(p) (*(uint8_t *)&(p))
> +
> +/*
> + * Dereference as uint32_t
> + */
> +#define v_32(p) (*(uint32_t *)&(p))
> +
> +/*
> + * Dereference as uint64_t
> + */
> +#define v_64(p) (*(uint64_t *)&(p))
> +
> +/*
> + * Multiply each byte of a uint32 by 2 in the GF(2^8).
> + */
> +static __always_inline uint32_t x2_32(uint32_t v)
> +{
> +	uint32_t mask =3D v & 0x80808080U;
> +	mask =3D (mask << 1) - (mask >> 7);
> +	v =3D (v << 1) & 0xfefefefeU;
> +	v ^=3D mask & 0x1d1d1d1dU;
> +	return v;
> +}
> +
> +/*
> + * Multiply each byte of a uint64 by 2 in the GF(2^8).
> + */
> +static __always_inline uint64_t x2_64(uint64_t v)
> +{
> +	uint64_t mask =3D v & 0x8080808080808080ULL;
> +	mask =3D (mask << 1) - (mask >> 7);
> +	v =3D (v << 1) & 0xfefefefefefefefeULL;
> +	v ^=3D mask & 0x1d1d1d1d1d1d1d1dULL;
> +	return v;
> +}
> +
> +#endif
> +
> diff --git a/lib/raid/int.c b/lib/raid/int.c
> new file mode 100644
> index 0000000..cd1e147
> --- /dev/null
> +++ b/lib/raid/int.c
> @@ -0,0 +1,567 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "gf.h"
> +
> +/*
> + * PAR1 (RAID5 with xor) 32bit C implementation
> + */
> +void raid_par1_int32(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	int d, l;
> +	size_t i;
> +
> +	uint32_t p0;
> +	uint32_t p1;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +
> +	for (i =3D 0; i < size; i +=3D 8) {
> +		p0 =3D v_32(v[l][i]);
> +		p1 =3D v_32(v[l][i+4]);
> +		for (d =3D l-1; d >=3D 0; --d) {
> +			p0 ^=3D v_32(v[d][i]);
> +			p1 ^=3D v_32(v[d][i+4]);
> +		}
> +		v_32(p[i]) =3D p0;
> +		v_32(p[i+4]) =3D p1;
> +	}
> +}
> +
> +/*
> + * PAR1 (RAID5 with xor) 64bit C implementation
> + */
> +void raid_par1_int64(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	int d, l;
> +	size_t i;
> +
> +	uint64_t p0;
> +	uint64_t p1;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		p0 =3D v_64(v[l][i]);
> +		p1 =3D v_64(v[l][i+8]);
> +		for (d =3D l-1; d >=3D 0; --d) {
> +			p0 ^=3D v_64(v[d][i]);
> +			p1 ^=3D v_64(v[d][i+8]);
> +		}
> +		v_64(p[i]) =3D p0;
> +		v_64(p[i+8]) =3D p1;
> +	}
> +}
> +
> +/*
> + * PAR2 (RAID6 with powers of 2) 32bit C implementation
> + */
> +void raid_par2_int32(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	int d, l;
> +	size_t i;
> +
> +	uint32_t d0, q0, p0;
> +	uint32_t d1, q1, p1;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +
> +	for (i =3D 0; i < size; i +=3D 8) {
> +		q0 =3D p0 =3D v_32(v[l][i]);
> +		q1 =3D p1 =3D v_32(v[l][i+4]);
> +		for (d =3D l-1; d >=3D 0; --d) {
> +			d0 =3D v_32(v[d][i]);
> +			d1 =3D v_32(v[d][i+4]);
> +
> +			p0 ^=3D d0;
> +			p1 ^=3D d1;
> +
> +			q0 =3D x2_32(q0);
> +			q1 =3D x2_32(q1);
> +
> +			q0 ^=3D d0;
> +			q1 ^=3D d1;
> +		}
> +		v_32(p[i]) =3D p0;
> +		v_32(p[i+4]) =3D p1;
> +		v_32(q[i]) =3D q0;
> +		v_32(q[i+4]) =3D q1;
> +	}
> +}
> +
> +/*
> + * PAR2 (RAID6 with powers of 2) 64bit C implementation
> + */
> +void raid_par2_int64(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	int d, l;
> +	size_t i;
> +
> +	uint64_t d0, q0, p0;
> +	uint64_t d1, q1, p1;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		q0 =3D p0 =3D v_64(v[l][i]);
> +		q1 =3D p1 =3D v_64(v[l][i+8]);
> +		for (d =3D l-1; d >=3D 0; --d) {
> +			d0 =3D v_64(v[d][i]);
> +			d1 =3D v_64(v[d][i+8]);
> +
> +			p0 ^=3D d0;
> +			p1 ^=3D d1;
> +
> +			q0 =3D x2_64(q0);
> +			q1 =3D x2_64(q1);
> +
> +			q0 ^=3D d0;
> +			q1 ^=3D d1;
> +		}
> +		v_64(p[i]) =3D p0;
> +		v_64(p[i+8]) =3D p1;
> +		v_64(q[i]) =3D q0;
> +		v_64(q[i+8]) =3D q1;
> +	}
> +}
> +
> +/*
> + * PAR3 (triple parity with Cauchy matrix) 8bit C implementation
> + *
> + * Note that instead of a generic multiplication table, likely resulting
> + * in multiple cache misses, a precomputed table could be used.
> + * But this is only a kind of reference function, and we are not really
> + * interested in speed.
> + */
> +void raid_par3_int8(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	int d, l;
> +	size_t i;
> +
> +	uint8_t d0, r0, q0, p0;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +
> +	for (i =3D 0; i < size; i +=3D 1) {
> +		p0 =3D q0 =3D r0 =3D 0;
> +		for (d =3D l; d > 0; --d) {
> +			d0 =3D v_8(v[d][i]);
> +
> +			p0 ^=3D d0;
> +			q0 ^=3D gfmul[d0][gfgen[1][d]];
> +			r0 ^=3D gfmul[d0][gfgen[2][d]];
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		d0 =3D v_8(v[0][i]);
> +
> +		p0 ^=3D d0;
> +		q0 ^=3D d0;
> +		r0 ^=3D d0;
> +
> +		v_8(p[i]) =3D p0;
> +		v_8(q[i]) =3D q0;
> +		v_8(r[i]) =3D r0;
> +	}
> +}
> +
> +/*
> + * PAR4 (quad parity with Cauchy matrix) 8bit C implementation
> + *
> + * Note that instead of a generic multiplication table, likely resulting
> + * in multiple cache misses, a precomputed table could be used.
> + * But this is only a kind of reference function, and we are not really
> + * interested in speed.
> + */
> +void raid_par4_int8(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	int d, l;
> +	size_t i;
> +
> +	uint8_t d0, s0, r0, q0, p0;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +
> +	for (i =3D 0; i < size; i +=3D 1) {
> +		p0 =3D q0 =3D r0 =3D s0 =3D 0;
> +		for (d =3D l; d > 0; --d) {
> +			d0 =3D v_8(v[d][i]);
> +
> +			p0 ^=3D d0;
> +			q0 ^=3D gfmul[d0][gfgen[1][d]];
> +			r0 ^=3D gfmul[d0][gfgen[2][d]];
> +			s0 ^=3D gfmul[d0][gfgen[3][d]];
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		d0 =3D v_8(v[0][i]);
> +
> +		p0 ^=3D d0;
> +		q0 ^=3D d0;
> +		r0 ^=3D d0;
> +		s0 ^=3D d0;
> +
> +		v_8(p[i]) =3D p0;
> +		v_8(q[i]) =3D q0;
> +		v_8(r[i]) =3D r0;
> +		v_8(s[i]) =3D s0;
> +	}
> +}
> +
> +/*
> + * PAR5 (penta parity with Cauchy matrix) 8bit C implementation
> + *
> + * Note that instead of a generic multiplication table, likely resulting
> + * in multiple cache misses, a precomputed table could be used.
> + * But this is only a kind of reference function, and we are not really
> + * interested in speed.
> + */
> +void raid_par5_int8(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	uint8_t *t;
> +	int d, l;
> +	size_t i;
> +
> +	uint8_t d0, t0, s0, r0, q0, p0;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +	t =3D v[nd+4];
> +
> +	for (i =3D 0; i < size; i +=3D 1) {
> +		p0 =3D q0 =3D r0 =3D s0 =3D t0 =3D 0;
> +		for (d =3D l; d > 0; --d) {
> +			d0 =3D v_8(v[d][i]);
> +
> +			p0 ^=3D d0;
> +			q0 ^=3D gfmul[d0][gfgen[1][d]];
> +			r0 ^=3D gfmul[d0][gfgen[2][d]];
> +			s0 ^=3D gfmul[d0][gfgen[3][d]];
> +			t0 ^=3D gfmul[d0][gfgen[4][d]];
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		d0 =3D v_8(v[0][i]);
> +
> +		p0 ^=3D d0;
> +		q0 ^=3D d0;
> +		r0 ^=3D d0;
> +		s0 ^=3D d0;
> +		t0 ^=3D d0;
> +
> +		v_8(p[i]) =3D p0;
> +		v_8(q[i]) =3D q0;
> +		v_8(r[i]) =3D r0;
> +		v_8(s[i]) =3D s0;
> +		v_8(t[i]) =3D t0;
> +	}
> +}
> +
> +/*
> + * PAR6 (hexa parity with Cauchy matrix) 8bit C implementation
> + *
> + * Note that instead of a generic multiplication table, likely resulting
> + * in multiple cache misses, a precomputed table could be used.
> + * But this is only a kind of reference function, and we are not really
> + * interested in speed.
> + */
> +void raid_par6_int8(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	uint8_t *t;
> +	uint8_t *u;
> +	int d, l;
> +	size_t i;
> +
> +	uint8_t d0, u0, t0, s0, r0, q0, p0;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +	t =3D v[nd+4];
> +	u =3D v[nd+5];
> +
> +	for (i =3D 0; i < size; i +=3D 1) {
> +		p0 =3D q0 =3D r0 =3D s0 =3D t0 =3D u0 =3D 0;
> +		for (d =3D l; d > 0; --d) {
> +			d0 =3D v_8(v[d][i]);
> +
> +			p0 ^=3D d0;
> +			q0 ^=3D gfmul[d0][gfgen[1][d]];
> +			r0 ^=3D gfmul[d0][gfgen[2][d]];
> +			s0 ^=3D gfmul[d0][gfgen[3][d]];
> +			t0 ^=3D gfmul[d0][gfgen[4][d]];
> +			u0 ^=3D gfmul[d0][gfgen[5][d]];
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		d0 =3D v_8(v[0][i]);
> +
> +		p0 ^=3D d0;
> +		q0 ^=3D d0;
> +		r0 ^=3D d0;
> +		s0 ^=3D d0;
> +		t0 ^=3D d0;
> +		u0 ^=3D d0;
> +
> +		v_8(p[i]) =3D p0;
> +		v_8(q[i]) =3D q0;
> +		v_8(r[i]) =3D r0;
> +		v_8(s[i]) =3D s0;
> +		v_8(t[i]) =3D t0;
> +		v_8(u[i]) =3D u0;
> +	}
> +}
> +
> +/*
> + * Recover failure of one data block at index id[0] using parity at index
> + * ip[0] for any RAID level.
> + *
> + * Starting from the equation:
> + *
> + * Pd =3D A[ip[0],id[0]] * Dx
> + *
> + * and solving we get:
> + *
> + * Dx =3D A[ip[0],id[0]]^-1 * Pd
> + */
> +void raid_rec1_int8(int nr, int *id, int *ip, int nd, size_t size, void =
**vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *pa;
> +	const uint8_t *T;
> +	uint8_t G;
> +	uint8_t V;
> +	size_t i;
> +
> +	(void)nr; /* unused, it's always 1 */
> +
> +	/* if it's RAID5 uses the faster function */
> +	if (ip[0] =3D=3D 0) {
> +		raid_rec1_par1(id, nd, size, vv);
> +		return;
> +	}
> +
> +#ifdef RAID_USE_RAID6_PQ
> +	/* if it's RAID6 recovering with Q uses the faster function */
> +	if (ip[0] =3D=3D 1) {
> +		raid6_datap_recov(nd + 2, size, id[0], vv);
> +		return;
> +	}
> +#endif
> +
> +	/* setup the coefficients matrix */
> +	G =3D A(ip[0], id[0]);
> +
> +	/* invert it to solve the system of linear equations */
> +	V =3D inv(G);
> +
> +	/* get multiplication tables */
> +	T =3D table(V);
> +
> +	/* compute delta parity */
> +	raid_delta_gen(1, id, ip, nd, size, vv);
> +
> +	p =3D v[nd+ip[0]];
> +	pa =3D v[id[0]];
> +
> +	for (i =3D 0; i < size; ++i) {
> +		/* delta */
> +		uint8_t Pd =3D p[i] ^ pa[i];
> +
> +		/* reconstruct */
> +		pa[i] =3D T[Pd];
> +	}
> +}
> +
> +/*
> + * Recover failure of two data blocks at indexes id[0],id[1] using parit=
y at
> + * indexes ip[0],ip[1] for any RAID level.
> + *
> + * Starting from the equations:
> + *
> + * Pd =3D A[ip[0],id[0]] * Dx + A[ip[0],id[1]] * Dy
> + * Qd =3D A[ip[1],id[0]] * Dx + A[ip[1],id[1]] * Dy
> + *
> + * we solve inverting the coefficients matrix.
> + */
> +void raid_rec2_int8(int nr, int *id, int *ip, int nd, size_t size, void =
**vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *pa;
> +	uint8_t *q;
> +	uint8_t *qa;
> +	const int N =3D 2;
> +	const uint8_t *T[N][N];
> +	uint8_t G[N*N];
> +	uint8_t V[N*N];
> +	size_t i;
> +	int j, k;
> +
> +	(void)nr; /* unused, it's always 2 */
> +
> +	/* if it's RAID6 recovering with P and Q uses the faster function */
> +	if (ip[0] =3D=3D 0 && ip[1] =3D=3D 1) {
> +#ifdef RAID_USE_RAID6_PQ
> +		raid6_2data_recov(nd + 2, size, id[0], id[1], vv);
> +#else
> +		raid_rec2_par2(id, ip, nd, size, vv);
> +#endif
> +		return;
> +	}
> +
> +	/* setup the coefficients matrix */
> +	for (j =3D 0; j < N; ++j)
> +		for (k =3D 0; k < N; ++k)
> +			G[j*N+k] =3D A(ip[j], id[k]);
> +
> +	/* invert it to solve the system of linear equations */
> +	raid_invert(G, V, N);
> +
> +	/* get multiplication tables */
> +	for (j =3D 0; j < N; ++j)
> +		for (k =3D 0; k < N; ++k)
> +			T[j][k] =3D table(V[j*N+k]);
> +
> +	/* compute delta parity */
> +	raid_delta_gen(2, id, ip, nd, size, vv);
> +
> +	p =3D v[nd+ip[0]];
> +	q =3D v[nd+ip[1]];
> +	pa =3D v[id[0]];
> +	qa =3D v[id[1]];
> +
> +	for (i =3D 0; i < size; ++i) {
> +		/* delta */
> +		uint8_t Pd =3D p[i] ^ pa[i];
> +		uint8_t Qd =3D q[i] ^ qa[i];
> +
> +		/* reconstruct */
> +		pa[i] =3D T[0][0][Pd] ^ T[0][1][Qd];
> +		qa[i] =3D T[1][0][Pd] ^ T[1][1][Qd];
> +	}
> +}
> +
> +/*
> + * Recover failure of N data blocks at indexes id[N] using parity at ind=
exes
> + * ip[N] for any RAID level.
> + *
> + * Starting from the N equations, with 0<=3Di<N :
> + *
> + * PD[i] =3D sum(A[ip[i],id[j]] * D[i]) 0<=3Dj<N
> + *
> + * we solve inverting the coefficients matrix.
> + *
> + * Note that referring at previous equations you have:
> + * PD[0] =3D Pd, PD[1] =3D Qd, PD[2] =3D Rd, ...
> + * D[0] =3D Dx, D[1] =3D Dy, D[2] =3D Dz, ...
> + */
> +void raid_recX_int8(int nr, int *id, int *ip, int nd, size_t size, void =
**vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p[RAID_PARITY_MAX];
> +	uint8_t *pa[RAID_PARITY_MAX];
> +	const uint8_t *T[RAID_PARITY_MAX][RAID_PARITY_MAX];
> +	uint8_t G[RAID_PARITY_MAX*RAID_PARITY_MAX];
> +	uint8_t V[RAID_PARITY_MAX*RAID_PARITY_MAX];
> +	size_t i;
> +	int j, k;
> +
> +	/* setup the coefficients matrix */
> +	for (j =3D 0; j < nr; ++j)
> +		for (k =3D 0; k < nr; ++k)
> +			G[j*nr+k] =3D A(ip[j], id[k]);
> +
> +	/* invert it to solve the system of linear equations */
> +	raid_invert(G, V, nr);
> +
> +	/* get multiplication tables */
> +	for (j =3D 0; j < nr; ++j)
> +		for (k =3D 0; k < nr; ++k)
> +			T[j][k] =3D table(V[j*nr+k]);
> +
> +	/* compute delta parity */
> +	raid_delta_gen(nr, id, ip, nd, size, vv);
> +
> +	for (j =3D 0; j < nr; ++j) {
> +		p[j] =3D v[nd+ip[j]];
> +		pa[j] =3D v[id[j]];
> +	}
> +
> +	for (i =3D 0; i < size; ++i) {
> +		uint8_t PD[RAID_PARITY_MAX];
> +
> +		/* delta */
> +		for (j =3D 0; j < nr; ++j)
> +			PD[j] =3D p[j][i] ^ pa[j][i];
> +
> +		/* reconstruct */
> +		for (j =3D 0; j < nr; ++j) {
> +			uint8_t b =3D 0;
> +			for (k =3D 0; k < nr; ++k)
> +				b ^=3D T[j][k][PD[k]];
> +			pa[j][i] =3D b;
> +		}
> +	}
> +}
> +
> diff --git a/lib/raid/internal.h b/lib/raid/internal.h
> new file mode 100644
> index 0000000..7d84458
> --- /dev/null
> +++ b/lib/raid/internal.h
> @@ -0,0 +1,146 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_INTERNAL_H
> +#define __RAID_INTERNAL_H
> +
> +/*
> + * Includes anything required for compatibility.
> + */
> +#ifdef __KERNEL__ /* to build the user mode test */
> +
> +#include <linux/module.h>
> +#include <linux/kconfig.h> /* for IS_* macros */
> +#include <linux/export.h> /* for EXPORT_SYMBOL/EXPORT_SYMBOL_GPL */
> +#include <linux/bug.h> /* for BUG_ON */
> +#include <linux/gfp.h> /* for __get_free_pages */
> +#include <linux/raid/xor.h> /* for xor_blocks */
> +
> +#ifdef CONFIG_X86
> +#include <asm/i387.h> /* for kernel_fpu_begin/end() */
> +#endif
> +
> +/* if we can use the RAID6 library */
> +#if IS_BUILTIN(CONFIG_RAID6_PQ) \
> +	|| (IS_MODULE(CONFIG_RAID6_PQ) && IS_MODULE(CONFIG_RAID6_CAUCHY))
> +#define RAID_USE_RAID6_PQ 1
> +#include <linux/raid/pq.h> /* for tables/functions */
> +#endif
> +
> +#else
> +
> +#include "test/usermode.h"
> +
> +#endif
> +
> +/*
> + * Include the main header.
> + */
> +#include <linux/raid/raid.h>
> +
> +/*
> + * Internal functions.
> + *
> + * These are intented to provide access for testing.
> + */
> +void raid_init(void);
> +int raid_selftest(void);
> +int raid_speedtest(void);
> +void raid_par_ref(int nd, int np, size_t size, void **vv);
> +void raid_invert(uint8_t *M, uint8_t *V, int n);
> +void raid_delta_gen(int nr, int *id, int *ip, int nd, size_t size, void =
**v);
> +void raid_rec1_par1(int *id, int nd, size_t size, void **v);
> +void raid_rec2_par2(int *id, int *ip, int nd, size_t size, void **vv);
> +void raid_par1_xorblocks(int nd, size_t size, void **v);
> +void raid_par1_int32(int nd, size_t size, void **vv);
> +void raid_par1_int64(int nd, size_t size, void **vv);
> +void raid_par1_sse2(int nd, size_t size, void **vv);
> +void raid_par2_raid6(int nd, size_t size, void **vv);
> +void raid_par2_int32(int nd, size_t size, void **vv);
> +void raid_par2_int64(int nd, size_t size, void **vv);
> +void raid_par2_sse2(int nd, size_t size, void **vv);
> +void raid_par2_sse2ext(int nd, size_t size, void **vv);
> +void raid_par3_int8(int nd, size_t size, void **vv);
> +void raid_par3_ssse3(int nd, size_t size, void **vv);
> +void raid_par3_ssse3ext(int nd, size_t size, void **vv);
> +void raid_par4_int8(int nd, size_t size, void **vv);
> +void raid_par4_ssse3(int nd, size_t size, void **vv);
> +void raid_par4_ssse3ext(int nd, size_t size, void **vv);
> +void raid_par5_int8(int nd, size_t size, void **vv);
> +void raid_par5_ssse3(int nd, size_t size, void **vv);
> +void raid_par5_ssse3ext(int nd, size_t size, void **vv);
> +void raid_par6_int8(int nd, size_t size, void **vv);
> +void raid_par6_ssse3(int nd, size_t size, void **vv);
> +void raid_par6_ssse3ext(int nd, size_t size, void **vv);
> +void raid_rec1_int8(int nr, int *id, int *ip, int nd, size_t size, void =
**vv);
> +void raid_rec2_int8(int nr, int *id, int *ip, int nd, size_t size, void =
**vv);
> +void raid_recX_int8(int nr, int *id, int *ip, int nd, size_t size, void =
**vv);
> +void raid_rec1_ssse3(int nr, int *id, int *ip, int nd, size_t size, void=
 **vv);
> +void raid_rec2_ssse3(int nr, int *id, int *ip, int nd, size_t size, void=
 **vv);
> +void raid_recX_ssse3(int nr, int *id, int *ip, int nd, size_t size, void=
 **vv);
> +
> +/*
> + * Internal forwarders.
> + */
> +extern void (*raid_par_ptr[RAID_PARITY_MAX])(
> +	int nd, size_t size, void **vv);
> +extern void (*raid_rec_ptr[RAID_PARITY_MAX])(
> +	int nr, int *id, int *ip, int nd, size_t size, void **vv);
> +
> +/*
> + * Tables.
> + *
> + * Uses RAID6 tables if available, otherwise the ones in tables.c.
> + */
> +#ifdef RAID_USE_RAID6_PQ
> +#define gfmul raid6_gfmul
> +#define gfinv raid6_gfinv
> +#define gfexp raid6_gfexp
> +#else
> +extern const uint8_t raid_gfmul[256][256] __aligned(256);
> +extern const uint8_t raid_gfexp[256] __aligned(256);
> +extern const uint8_t raid_gfinv[256] __aligned(256);
> +#define gfmul raid_gfmul
> +#define gfexp raid_gfexp
> +#define gfinv raid_gfinv
> +#endif
> +
> +extern const uint8_t raid_gfcauchy[6][256] __aligned(256);
> +extern const uint8_t raid_gfcauchypshufb[251][4][2][16] __aligned(256);
> +extern const uint8_t raid_gfmulpshufb[256][2][16] __aligned(256);
> +#define gfgen raid_gfcauchy
> +#define gfgenpshufb raid_gfcauchypshufb
> +#define gfmulpshufb raid_gfmulpshufb
> +
> +/*
> + * Assembler blocks.
> + */
> +#ifdef __KERNEL__ /* to build the user mode test */
> +#define asm_begin() \
> +	kernel_fpu_begin()
> +
> +#define asm_end() \
> +	do { \
> +		asm volatile("sfence" : : : "memory"); \
> +		kernel_fpu_end(); \
> +	} while (0)
> +#else
> +#define asm_begin() \
> +	do { } while (0)
> +#define asm_end() \
> +	asm volatile("sfence" : : : "memory")
> +#endif
> +
> +#endif
> +
> diff --git a/lib/raid/mktables.c b/lib/raid/mktables.c
> new file mode 100644
> index 0000000..9c8e0e0
> --- /dev/null
> +++ b/lib/raid/mktables.c
> @@ -0,0 +1,338 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <stdio.h>
> +#include <stdint.h>
> +
> +/**
> + * Multiplication in GF(2^8).
> + */
> +static uint8_t gfmul(uint8_t a, uint8_t b)
> +{
> +	uint8_t v;
> +
> +	v =3D 0;
> +	while (b)  {
> +		if ((b & 1) !=3D 0)
> +			v ^=3D a;
> +
> +		if ((a & 0x80) !=3D 0) {
> +			a <<=3D 1;
> +			a ^=3D 0x1d;
> +		} else {
> +			a <<=3D 1;
> +		}
> +
> +		b >>=3D 1;
> +	}
> +
> +	return v;
> +}
> +
> +/**
> + * Inversion table in GF(2^8).
> + */
> +uint8_t gfinv[256];
> +
> +/**
> + * Number of parity.
> + * This is the number of rows of the generation matrix.
> + */
> +#define PARITY 6
> +
> +/**
> + * Number of disks.
> + * This is the number of columns of the generation matrix.
> + */
> +#define DISK (257-PARITY)
> +
> +/**
> + * Setup the Cauchy matrix used to generate the parity.
> + */
> +static void set_cauchy(uint8_t *matrix)
> +{
> +	int i, j;
> +	uint8_t inv_x, y;
> +
> +	/*
> +	 * First row is formed by all 1.
> +	 *
> +	 * This is an Extended Cauchy matrix built from a Cauchy matrix
> +	 * adding the first row of all 1.
> +	 */
> +	for (i =3D 0; i < DISK; ++i)
> +		matrix[0*DISK+i] =3D 1;
> +
> +	/*
> +	 * Second row is formed by power of 2^i.
> +	 *
> +	 * This is the first row of the Cauchy matrix.
> +	 *
> +	 * Each element of the Cauchy matrix is in the form 1/(xi+yj)
> +	 * where all xi, and yj must be different.
> +	 *
> +	 * Choosing xi =3D 2^-i and y0 =3D 0, we obtain for the first row:
> +	 *
> +	 * 1/(xi+y0) =3D 1/(2^-i + 0) =3D 2^i
> +	 *
> +	 * with 2^-i !=3D 0 for any i
> +	 */
> +	inv_x =3D 1;
> +	for (i =3D 0; i < DISK; ++i) {
> +		matrix[1*DISK+i] =3D inv_x;
> +		inv_x =3D gfmul(2, inv_x);
> +	}
> +
> +	/*
> +	 * Next rows of the Cauchy matrix.
> +	 *
> +	 * Continue forming the Cauchy matrix with yj =3D 2^j obtaining :
> +	 *
> +	 * 1/(xi+yj) =3D 1/(2^-i + 2^j)
> +	 *
> +	 * with xi !=3D yj for any i,j with i>=3D0,j>=3D1,i+j<255
> +	 */
> +	y =3D 2;
> +	for (j =3D 0; j < PARITY-2; ++j) {
> +		inv_x =3D 1;
> +		for (i =3D 0; i < DISK; ++i) {
> +			uint8_t x =3D gfinv[inv_x];
> +			matrix[(j+2)*DISK+i] =3D gfinv[y ^ x];
> +			inv_x =3D gfmul(2, inv_x);
> +		}
> +
> +		y =3D gfmul(2, y);
> +	}
> +
> +	/*
> +	 * Adjusts the matrix multipling each row for
> +	 * the inverse of the first element in the row.
> +	 *
> +	 * This operation doesn't invalidate the property that all the square
> +	 * submatrices are not singular.
> +	 */
> +	for (j =3D 0; j < PARITY-2; ++j) {
> +		uint8_t f =3D gfinv[matrix[(j+2)*DISK]];
> +
> +		for (i =3D 0; i < DISK; ++i)
> +			matrix[(j+2)*DISK+i] =3D gfmul(matrix[(j+2)*DISK+i], f);
> +	}
> +}
> +
> +/**
> + * Next power of 2.
> + */
> +static unsigned np(unsigned v)
> +{
> +	--v;
> +	v |=3D v >> 1;
> +	v |=3D v >> 2;
> +	v |=3D v >> 4;
> +	v |=3D v >> 8;
> +	v |=3D v >> 16;
> +	++v;
> +
> +	return v;
> +}
> +
> +int main(void)
> +{
> +	uint8_t v;
> +	int i, j, k, p;
> +	uint8_t matrix[PARITY * 256];
> +
> +	printf("/*\n");
> +	printf(" * Copyright (C) 2013 Andrea Mazzoleni\n");
> +	printf(" *\n");
> +	printf(" * This program is free software: you can redistribute it and/o=
r modify\n");
> +	printf(" * it under the terms of the GNU General Public License as publ=
ished by\n");
> +	printf(" * the Free Software Foundation, either version 2 of the Licens=
e, or\n");
> +	printf(" * (at your option) any later version.\n");
> +	printf(" *\n");
> +	printf(" * This program is distributed in the hope that it will be usef=
ul,\n");
> +	printf(" * but WITHOUT ANY WARRANTY; without even the implied warranty =
of\n");
> +	printf(" * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See th=
e\n");
> +	printf(" * GNU General Public License for more details.\n");
> +	printf(" */\n");
> +	printf("\n");
> +
> +	printf("#include \"internal.h\"\n");
> +	printf("\n");
> +
> +	/* a*b */
> +	printf("#ifndef RAID_USE_RAID6_PQ\n");
> +	printf("const uint8_t __aligned(256) raid_gfmul[256][256] =3D\n");
> +	printf("{\n");
> +	for (i =3D 0; i < 256; ++i) {
> +		printf("\t{\n");
> +		for (j =3D 0; j < 256; ++j) {
> +			if (j % 8 =3D=3D 0)
> +				printf("\t\t");
> +			v =3D gfmul(i, j);
> +			if (v =3D=3D 1)
> +				gfinv[i] =3D j;
> +			printf("0x%02x,", (unsigned)v);
> +			if (j % 8 =3D=3D 7)
> +				printf("\n");
> +			else
> +				printf(" ");
> +		}
> +		printf("\t},\n");
> +	}
> +	printf("};\n");
> +	printf("EXPORT_SYMBOL(raid_gfmul);\n");
> +	printf("#endif\n");
> +	printf("\n");
> +
> +	/* 2^a */
> +	printf("#ifndef RAID_USE_RAID6_PQ\n");
> +	printf("const uint8_t __aligned(256) raid_gfexp[256] =3D\n");
> +	printf("{\n");
> +	v =3D 1;
> +	for (i =3D 0; i < 256; ++i) {
> +		if (i % 8 =3D=3D 0)
> +			printf("\t");
> +		printf("0x%02x,", v);
> +		v =3D gfmul(v, 2);
> +		if (i % 8 =3D=3D 7)
> +			printf("\n");
> +		else
> +			printf(" ");
> +	}
> +	printf("};\n");
> +	printf("EXPORT_SYMBOL(raid_gfexp);\n");
> +	printf("#endif\n");
> +	printf("\n");
> +
> +	/* 1/a */
> +	printf("#ifndef RAID_USE_RAID6_PQ\n");
> +	printf("const uint8_t __aligned(256) raid_gfinv[256] =3D\n");
> +	printf("{\n");
> +	printf("\t/* note that the first element is not significative */\n");
> +	for (i =3D 0; i < 256; ++i) {
> +		if (i % 8 =3D=3D 0)
> +			printf("\t");
> +		if (i =3D=3D 0)
> +			v =3D 0;
> +		else
> +			v =3D gfinv[i];
> +		printf("0x%02x,", v);
> +		if (i % 8 =3D=3D 7)
> +			printf("\n");
> +		else
> +			printf(" ");
> +	}
> +	printf("};\n");
> +	printf("EXPORT_SYMBOL(raid_gfinv);\n");
> +	printf("#endif\n");
> +	printf("\n");
> +
> +	/* cauchy matrix */
> +	set_cauchy(matrix);
> +
> +	printf("/**\n");
> +	printf(" * Cauchy matrix used to generate parity.\n");
> +	printf(" * This matrix is valid for up to %u parity with %u data disks.=
\n", PARITY, DISK);
> +	printf(" *\n");
> +	for (p =3D 0; p < PARITY; ++p) {
> +		printf(" * ");
> +		for (i =3D 0; i < DISK; ++i)
> +			printf("%02x ", matrix[p*DISK+i]);
> +		printf("\n");
> +	}
> +	printf(" */\n");
> +	printf("const uint8_t __aligned(256) raid_gfcauchy[%u][256] =3D\n", PAR=
ITY);
> +	printf("{\n");
> +	for (p =3D 0; p < PARITY; ++p) {
> +		printf("\t{\n");
> +		for (i =3D 0; i < DISK; ++i) {
> +			if (i % 8 =3D=3D 0)
> +				printf("\t\t");
> +			printf("0x%02x,", matrix[p*DISK+i]);
> +			if (i % 8 =3D=3D 7)
> +				printf("\n");
> +			else
> +				printf(" ");
> +		}
> +		printf("\n\t},\n");
> +	}
> +	printf("};\n");
> +	printf("EXPORT_SYMBOL(raid_gfcauchy);\n");
> +	printf("\n");
> +
> +	printf("#ifdef CONFIG_X86\n");
> +	printf("/**\n");
> +	printf(" * PSHUFB tables for the Cauchy matrix.\n");
> +	printf(" *\n");
> +	printf(" * Indexes are [DISK][PARITY - 2][LH].\n");
> +	printf(" * Where DISK is from 0 to %u, PARITY from 2 to %u, LH from 0 t=
o 1.\n", DISK - 1, PARITY - 1);
> +	printf(" */\n");
> +	printf("const uint8_t __aligned(256) raid_gfcauchypshufb[%u][%u][2][16]=
 =3D\n", DISK, np(PARITY - 2));
> +	printf("{\n");
> +	for (i =3D 0; i < DISK; ++i) {
> +		printf("\t{\n");
> +		for (p =3D 2; p < PARITY; ++p) {
> +			printf("\t\t{\n");
> +			for (j =3D 0; j < 2; ++j) {
> +				printf("\t\t\t{ ");
> +				for (k =3D 0; k < 16; ++k) {
> +					v =3D gfmul(matrix[p*DISK+i], k);
> +					if (j =3D=3D 1)
> +						v =3D gfmul(v, 16);
> +					printf("0x%02x", (unsigned)v);
> +					if (k !=3D 15)
> +						printf(", ");
> +				}
> +				printf(" },\n");
> +			}
> +			printf("\t\t},\n");
> +		}
> +		printf("\t},\n");
> +	}
> +	printf("};\n");
> +	printf("EXPORT_SYMBOL(raid_gfcauchypshufb);\n");
> +	printf("#endif\n\n");
> +
> +	printf("#ifdef CONFIG_X86\n");
> +	printf("/**\n");
> +	printf(" * PSHUFB tables for generic multiplication.\n");
> +	printf(" *\n");
> +	printf(" * Indexes are [MULTIPLER][LH].\n");
> +	printf(" * Where MULTIPLER is from 0 to 255, LH from 0 to 1.\n");
> +	printf(" */\n");
> +	printf("const uint8_t __aligned(256) raid_gfmulpshufb[256][2][16] =3D\n=
");
> +	printf("{\n");
> +	for (i =3D 0; i < 256; ++i) {
> +		printf("\t{\n");
> +		for (j =3D 0; j < 2; ++j) {
> +			printf("\t\t{ ");
> +			for (k =3D 0; k < 16; ++k) {
> +				v =3D gfmul(i, k);
> +				if (j =3D=3D 1)
> +					v =3D gfmul(v, 16);
> +				printf("0x%02x", (unsigned)v);
> +				if (k !=3D 15)
> +					printf(", ");
> +			}
> +			printf(" },\n");
> +		}
> +		printf("\t},\n");
> +	}
> +	printf("};\n");
> +	printf("EXPORT_SYMBOL(raid_gfmulpshufb);\n");
> +	printf("#endif\n\n");
> +
> +	return 0;
> +}
> +
> diff --git a/lib/raid/module.c b/lib/raid/module.c
> new file mode 100644
> index 0000000..3a4fba3
> --- /dev/null
> +++ b/lib/raid/module.c
> @@ -0,0 +1,437 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "cpu.h"
> +
> +/*
> + * Initializes and selects the best algorithm.
> + */
> +void raid_init(void)
> +{
> +	/* setup parity functions */
> +	if (sizeof(void *) =3D=3D 8) {
> +		raid_par_ptr[0] =3D raid_par1_int64;
> +		raid_par_ptr[1] =3D raid_par2_int64;
> +	} else {
> +		raid_par_ptr[0] =3D raid_par1_int32;
> +		raid_par_ptr[1] =3D raid_par2_int32;
> +	}
> +	raid_par_ptr[2] =3D raid_par3_int8;
> +	raid_par_ptr[3] =3D raid_par4_int8;
> +	raid_par_ptr[4] =3D raid_par5_int8;
> +	raid_par_ptr[5] =3D raid_par6_int8;
> +
> +	/* in kernel mode use the optimized xor_blocks() */
> +#ifdef __KERNEL__
> +	raid_par_ptr[0] =3D raid_par1_xorblocks;
> +#endif
> +	/* if RAID6 is present, use it */
> +#ifdef RAID_USE_RAID6_PQ
> +	raid_par_ptr[1] =3D raid_par2_raid6;
> +#endif
> +
> +	/* optimized SSE2 functions */
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		raid_par_ptr[0] =3D raid_par1_sse2;
> +		raid_par_ptr[1] =3D raid_par2_sse2;
> +#ifdef CONFIG_X86_64
> +		raid_par_ptr[1] =3D raid_par2_sse2ext;
> +#endif
> +	}
> +#endif
> +
> +	/* optimized SSSE3 functions */
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		raid_par_ptr[2] =3D raid_par3_ssse3;
> +		raid_par_ptr[3] =3D raid_par4_ssse3;
> +		raid_par_ptr[4] =3D raid_par5_ssse3;
> +		raid_par_ptr[5] =3D raid_par6_ssse3;
> +#ifdef CONFIG_X86_64
> +		raid_par_ptr[2] =3D raid_par3_ssse3ext;
> +		raid_par_ptr[3] =3D raid_par4_ssse3ext;
> +		raid_par_ptr[4] =3D raid_par5_ssse3ext;
> +		raid_par_ptr[5] =3D raid_par6_ssse3ext;
> +#endif
> +	}
> +#endif
> +
> +	/* setup recovering functions */
> +	raid_rec_ptr[0] =3D raid_rec1_int8;
> +	raid_rec_ptr[1] =3D raid_rec2_int8;
> +	raid_rec_ptr[2] =3D raid_recX_int8;
> +	raid_rec_ptr[3] =3D raid_recX_int8;
> +	raid_rec_ptr[4] =3D raid_recX_int8;
> +	raid_rec_ptr[5] =3D raid_recX_int8;
> +
> +	/* optimized SSSE3 functions */
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		raid_rec_ptr[0] =3D raid_rec1_ssse3;
> +		raid_rec_ptr[1] =3D raid_rec2_ssse3;
> +		raid_rec_ptr[2] =3D raid_recX_ssse3;
> +		raid_rec_ptr[3] =3D raid_recX_ssse3;
> +		raid_rec_ptr[4] =3D raid_recX_ssse3;
> +		raid_rec_ptr[5] =3D raid_recX_ssse3;
> +	}
> +#endif
> +}
> +
> +/*
> + * Refence parity computation.
> + */
> +void raid_par_ref(int nd, int np, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	size_t i;
> +
> +	for (i =3D 0; i < size; ++i) {
> +		uint8_t p[RAID_PARITY_MAX];
> +		int j, d;
> +
> +		for (j =3D 0; j < np; ++j)
> +			p[j] =3D 0;
> +
> +		for (d =3D 0; d < nd; ++d) {
> +			uint8_t b =3D v[d][i];
> +
> +			for (j =3D 0; j < np; ++j)
> +				p[j] ^=3D gfmul[b][gfgen[j][d]];
> +		}
> +
> +		for (j =3D 0; j < np; ++j)
> +			v[nd + j][i] =3D p[j];
> +	}
> +}
> +
> +/*
> + * Size of the blocks to test.
> + */
> +#define TEST_SIZE PAGE_SIZE
> +
> +/*
> + * Number of data blocks to test.
> + */
> +#define TEST_COUNT (65536 / TEST_SIZE)
> +
> +/*
> + * Period for the speed test.
> + */
> +#ifdef __KERNEL__ /* to build the user mode test */
> +#define TEST_PERIOD 16
> +#else
> +#define TEST_PERIOD 512 /* more time in usermode */
> +#endif
> +
> +/*
> + * Parity generation test.
> + */
> +static int raid_test_par(int nd, int np, size_t size, void **v, void **r=
ef)
> +{
> +	int i;
> +	void *t[TEST_COUNT + RAID_PARITY_MAX];
> +
> +	/* setup data */
> +	for (i =3D 0; i < nd; ++i)
> +		t[i] =3D ref[i];
> +
> +	/* setup parity */
> +	for (i =3D 0; i < np; ++i)
> +		t[nd+i] =3D v[nd+i];
> +
> +	raid_par(nd, np, size, t);
> +
> +	/* compare parity */
> +	for (i =3D 0; i < np; ++i) {
> +		if (memcmp(t[nd+i], ref[nd+i], size) !=3D 0) {
> +			pr_err("raid: Self test failed!\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Recovering test.
> + */
> +static int raid_test_rec(int nrd, int *id, int nrp, int *ip, int nd, int=
 np, size_t size, void **v, void **ref)
> +{
> +	int i, j;
> +	void *t[TEST_COUNT + RAID_PARITY_MAX];
> +
> +	/* setup data */
> +	for (i =3D 0, j =3D 0; i < nd; ++i) {
> +		if (j < nrd && id[j] =3D=3D i) {
> +			t[i] =3D v[i];
> +			++j;
> +		} else {
> +			t[i] =3D ref[i];
> +		}
> +	}
> +
> +	/* setup parity */
> +	for (i =3D 0, j =3D 0; i < np; ++i) {
> +		if (j < nrp && ip[j] =3D=3D i) {
> +			t[nd+i] =3D v[nd+i];
> +			++j;
> +		} else {
> +			t[nd+i] =3D ref[nd+i];
> +		}
> +	}
> +
> +	raid_rec(nrd, id, nrp, ip, nd, np, size, t);
> +
> +	/* compare all data and parity */
> +	for (i =3D 0; i < nd+np; ++i) {
> +		if (t[i] !=3D ref[i] && memcmp(t[i], ref[i], size) !=3D 0) {
> +			pr_err("raid: Self test failed!\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Basic functionality self test.
> + */
> +int raid_selftest(void)
> +{
> +	const int nd =3D TEST_COUNT;
> +	const size_t size =3D TEST_SIZE;
> +	const int nv =3D nd + RAID_PARITY_MAX * 2;
> +	int order;
> +	uint8_t *pages;
> +	void *v[nd + RAID_PARITY_MAX * 2];
> +	void *ref[nd + RAID_PARITY_MAX];
> +	int id[RAID_PARITY_MAX];
> +	int ip[RAID_PARITY_MAX];
> +	int i, np;
> +	int ret =3D 0;
> +
> +	/* ensure to have enough space for data */
> +	BUG_ON(nd * size > 65536);
> +
> +	/* allocates pages for data and parity */
> +	order =3D get_order(nv * size);
> +	pages =3D (void *)__get_free_pages(GFP_KERNEL, order);
> +	if (!pages) {
> +		pr_err("raid: No memory available.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* setup working vector */
> +	for (i =3D 0; i < nv; ++i)
> +		v[i] =3D pages + size * i;
> +
> +	/* use the multiplication table as data */
> +	for (i =3D 0; i < nd; ++i)
> +		ref[i] =3D ((uint8_t *)gfmul) + size * i;
> +
> +	/* setup reference parity */
> +	for (i =3D 0; i < RAID_PARITY_MAX; ++i)
> +		ref[nd+i] =3D v[nd+RAID_PARITY_MAX+i];
> +
> +	/* compute reference parity */
> +	raid_par_ref(nd, RAID_PARITY_MAX, size, ref);
> +
> +	/* test for each parity level */
> +	for (np =3D 1; np <=3D RAID_PARITY_MAX; ++np) {
> +		/* test parity generation */
> +		ret =3D raid_test_par(nd, np, size, v, ref);
> +		if (ret !=3D 0)
> +			goto bail;
> +
> +		/* test recovering with full broken data disks */
> +		for (i =3D 0; i < np; ++i)
> +			id[i] =3D nd - np + i;
> +
> +		ret =3D raid_test_rec(np, id, 0, ip, nd, np, size, v, ref);
> +		if (ret !=3D 0)
> +			goto bail;
> +
> +		/* test recovering with half broken data and ending parity */
> +		for (i =3D 0; i < np / 2; ++i)
> +			id[i] =3D i;
> +
> +		for (i =3D 0; i < (np + 1) / 2; ++i)
> +			ip[i] =3D np - np / 2 + i;
> +
> +		ret =3D raid_test_rec(np / 2, id, np / 2, ip, nd, np, size, v, ref);
> +		if (ret !=3D 0)
> +			goto bail;
> +
> +		/* test recovering with half broken data and leading parity */
> +		for (i =3D 0; i < np / 2; ++i)
> +			id[i] =3D i;
> +
> +		for (i =3D 0; i < (np + 1) / 2; ++i)
> +			ip[i] =3D i;
> +
> +		ret =3D raid_test_rec(np / 2, id, np / 2, ip, nd, np, size, v, ref);
> +		if (ret !=3D 0)
> +			goto bail;
> +	}
> +
> +bail:
> +	free_pages((unsigned long)pages, order);
> +
> +	return ret;
> +}
> +
> +/*
> + * Test the speed of a single function.
> + */
> +static void raid_test_speed(
> +	void (*func)(int nd, size_t size, void **vv),
> +	const char *tag, const char *imp,
> +	void **vv)
> +{
> +	unsigned count;
> +	unsigned long j_start, j_stop;
> +	unsigned long speed;
> +
> +	count =3D 0;
> +
> +	preempt_disable();
> +
> +	j_start =3D jiffies;
> +	while (jiffies =3D=3D j_start)
> +		cpu_relax();
> +
> +	j_start =3D jiffies;
> +	j_stop =3D j_start + TEST_PERIOD;
> +	while (time_before(jiffies, j_stop)) {
> +		func(TEST_COUNT, TEST_SIZE, vv);
> +		++count;
> +	}
> +
> +	preempt_enable();
> +
> +	speed =3D count * HZ / (TEST_PERIOD * 1024 * 1024 / (TEST_SIZE * TEST_C=
OUNT));
> +
> +	pr_info("raid: %-4s %-6s %5ld MB/s\n", tag, imp, speed);
> +}
> +
> +/*
> + * Basic speed test.
> + */
> +int raid_speedtest(void)
> +{
> +	const int nd =3D TEST_COUNT;
> +	const size_t size =3D TEST_SIZE;
> +	int order;
> +	uint8_t *pages;
> +	void *v[nd + RAID_PARITY_MAX];
> +	int i;
> +
> +	/* ensure to have enough space for data */
> +	BUG_ON(nd * size > 65536);
> +
> +	/* allocates pages for parity */
> +	order =3D get_order(RAID_PARITY_MAX * size);
> +	pages =3D (void *)__get_free_pages(GFP_KERNEL, order);
> +	if (!pages) {
> +		pr_err("raid: No memory available.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* use the multiplication table as data */
> +	for (i =3D 0; i < nd; ++i)
> +		v[i] =3D ((uint8_t *)gfmul) + size * i;
> +
> +	/* setup parity */
> +	for (i =3D 0; i < RAID_PARITY_MAX; ++i)
> +		v[nd+i] =3D pages + size * i;
> +
> +	raid_test_speed(raid_par1_int32, "par1", "int32", v);
> +	raid_test_speed(raid_par2_int32, "par2", "int32", v);
> +	raid_test_speed(raid_par1_int64, "par1", "int64", v);
> +	raid_test_speed(raid_par2_int64, "par2", "int64", v);
> +	raid_test_speed(raid_par3_int8, "par3", "int8", v);
> +	raid_test_speed(raid_par4_int8, "par4", "int8", v);
> +	raid_test_speed(raid_par5_int8, "par5", "int8", v);
> +	raid_test_speed(raid_par6_int8, "par6", "int8", v);
> +#ifdef __KERNEL__
> +	raid_test_speed(raid_par1_xorblocks, "par1", "xor", v);
> +#endif
> +#ifdef RAID_USE_RAID6_PQ
> +	raid_test_speed(raid_par2_raid6, "par2", "raid6", v);
> +#endif
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		raid_test_speed(raid_par1_sse2, "par1", "sse2", v);
> +		raid_test_speed(raid_par2_sse2, "par2", "sse2", v);
> +	}
> +	if (raid_cpu_has_ssse3()) {
> +		raid_test_speed(raid_par3_ssse3, "par3", "ssse3", v);
> +		raid_test_speed(raid_par4_ssse3, "par4", "ssse3", v);
> +		raid_test_speed(raid_par5_ssse3, "par5", "ssse3", v);
> +		raid_test_speed(raid_par6_ssse3, "par6", "ssse3", v);
> +#ifdef CONFIG_X86_64
> +		raid_test_speed(raid_par2_sse2ext, "par2", "sse2e", v);
> +		raid_test_speed(raid_par3_ssse3ext, "par3", "ssse3e", v);
> +		raid_test_speed(raid_par4_ssse3ext, "par4", "ssse3e", v);
> +		raid_test_speed(raid_par5_ssse3ext, "par5", "ssse3e", v);
> +		raid_test_speed(raid_par6_ssse3ext, "par6", "ssse3e", v);
> +#endif
> +	}
> +#endif
> +
> +	free_pages((unsigned long)pages, order);
> +
> +	return 0;
> +}
> +
> +#ifdef __KERNEL__ /* to build the user mode test */
> +static int speedtest;
> +
> +int __init raid_cauchy_init(void)
> +{
> +	int ret;
> +
> +	raid_init();
> +
> +	ret =3D raid_selftest();
> +	if (ret !=3D 0)
> +		return ret;
> +
> +#ifdef RAID_USE_RAID6_PQ
> +	pr_info("raid: Self test passed (using raid6)\n");
> +#else
> +	pr_info("raid: Self test passed\n");
> +#endif
> +
> +	if (speedtest)
> +		raid_speedtest();
> +
> +	return 0;
> +}
> +
> +static void raid_cauchy_exit(void)
> +{
> +}
> +
> +subsys_initcall(raid_cauchy_init);
> +module_exit(raid_cauchy_exit);
> +module_param(speedtest, int, 0);
> +MODULE_PARM_DESC(speedtest, "Runs a startup speed test");
> +MODULE_AUTHOR("Andrea Mazzoleni <amadvance@gmail.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("RAID Cauchy functions");
> +#endif
> +
> diff --git a/lib/raid/raid.c b/lib/raid/raid.c
> new file mode 100644
> index 0000000..918cb67
> --- /dev/null
> +++ b/lib/raid/raid.c
> @@ -0,0 +1,425 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "gf.h"
> +
> +/*
> + * This is a RAID implementation working in the Galois Field GF(2^8) with
> + * the primitive polynomial x^8 + x^4 + x^3 + x^2 + 1 (285 decimal), and
> + * supporting up to six parity levels.
> + *
> + * For RAID5 and RAID6 it works as as described in the H. Peter Anvin's
> + * paper "The mathematics of RAID-6" [1]. Please refer to this paper for=
 a
> + * complete explanation.
> + *
> + * To support triple parity, it was first evaluated and then dropped, an
> + * extension of the same approach, with additional parity coefficients s=
et
> + * as powers of 2^-1, with equations:
> + *
> + * P =3D sum(Di)
> + * Q =3D sum(2^i * Di)
> + * R =3D sum(2^-i * Di) with 0<=3Di<N
> + *
> + * This approach works well for triple parity and it's very efficient,
> + * because we can implement very fast parallel multiplications and
> + * divisions by 2 in GF(2^8).
> + *
> + * It's also similar at the approach used by ZFS RAIDZ3, with the
> + * difference that ZFS uses powers of 4 instead of 2^-1.
> + *
> + * Unfortunately it doesn't work beyond triple parity, because whatever
> + * value we choose to generate the power coefficients to compute other
> + * parities, the resulting equations are not solvable for some
> + * combinations of missing disks.
> + *
> + * This is expected, because the Vandermonde matrix used to compute the
> + * parity has no guarantee to have all submatrices not singular
> + * [2, Chap 11, Problem 7] and this is a requirement to have
> + * a MDS (Maximum Distance Separable) code [2, Chap 11, Theorem 8].
> + *
> + * To overcome this limitation, we use a Cauchy matrix [3][4] to compute
> + * the parity. A Cauchy matrix has the property to have all the square
> + * submatrices not singular, resulting in always solvable equations,
> + * for any combination of missing disks.
> + *
> + * The problem of this approach is that it requires the use of
> + * generic multiplications, and not only by 2 or 2^-1, potentially
> + * affecting badly the performance.
> + *
> + * Hopefully there is a method to implement parallel multiplications
> + * using SSSE3 instructions [1][5]. Method competitive with the
> + * computation of triple parity using power coefficients.
> + *
> + * Another important property of the Cauchy matrix is that we can setup
> + * the first two rows with coeffients equal at the RAID5 and RAID6 appro=
ach
> + * decribed, resulting in a compatible extension, and requiring SSSE3
> + * instructions only if triple parity or beyond is used.
> + *
> + * The matrix is also adjusted, multipling each row by a constant factor
> + * to make the first column of all 1, to optimize the computation for
> + * the first disk.
> + *
> + * This results in the matrix A[row,col] defined as:
> + *
> + * 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01...
> + * 01 02 04 08 10 20 40 80 1d 3a 74 e8 cd 87 13 26 4c 98 2d 5a b4 75...
> + * 01 f5 d2 c4 9a 71 f1 7f fc 87 c1 c6 19 2f 40 55 3d ba 53 04 9c 61...
> + * 01 bb a6 d7 c7 07 ce 82 4a 2f a5 9b b6 60 f1 ad e7 f4 06 d2 df 2e...
> + * 01 97 7f 9c 7c 18 bd a2 58 1a da 74 70 a3 e5 47 29 07 f5 80 23 e9...
> + * 01 2b 3f cf 73 2c d6 ed cb 74 15 78 8a c1 17 c9 89 68 21 ab 76 3b...
> + *
> + * This matrix supports 6 level of parity, one for each row, for up to 2=
51
> + * data disks, one for each column, with all the 377,342,351,231 square
> + * submatrices not singular, verified also with brute-force.
> + *
> + * This matrix can be extended to support any number of parities, just
> + * adding additional rows, and removing one column for each new row.
> + * (see mktables.c for more details in how the matrix is generated)
> + *
> + * In details, parity is computed as:
> + *
> + * P =3D sum(Di)
> + * Q =3D sum(2^i *  Di)
> + * R =3D sum(A[2,i] * Di)
> + * S =3D sum(A[3,i] * Di)
> + * T =3D sum(A[4,i] * Di)
> + * U =3D sum(A[5,i] * Di) with 0<=3Di<N
> + *
> + * To recover from a failure of six disks at indexes x,y,z,h,v,w,
> + * with 0<=3Dx<y<z<h<v<w<N, we compute the parity of the available N-6
> + * disks as:
> + *
> + * Pa =3D sum(Di)
> + * Qa =3D sum(2^i * Di)
> + * Ra =3D sum(A[2,i] * Di)
> + * Sa =3D sum(A[3,i] * Di)
> + * Ta =3D sum(A[4,i] * Di)
> + * Ua =3D sum(A[5,i] * Di) with 0<=3Di<N,i!=3Dx,i!=3Dy,i!=3Dz,i!=3Dh,i!=
=3Dv,i!=3Dw.
> + *
> + * And if we define:
> + *
> + * Pd =3D Pa + P
> + * Qd =3D Qa + Q
> + * Rd =3D Ra + R
> + * Sd =3D Sa + S
> + * Td =3D Ta + T
> + * Ud =3D Ua + U
> + *
> + * we can sum these two sets of equations, obtaining:
> + *
> + * Pd =3D          Dx +          Dy +          Dz +          Dh +       =
   Dv +          Dw
> + * Qd =3D    2^x * Dx +    2^y * Dy +    2^z * Dz +    2^h * Dh +    2^v=
 * Dv +    2^w * Dw
> + * Rd =3D A[2,x] * Dx + A[2,y] * Dy + A[2,z] * Dz + A[2,h] * Dh + A[2,v]=
 * Dv + A[2,w] * Dw
> + * Sd =3D A[3,x] * Dx + A[3,y] * Dy + A[3,z] * Dz + A[3,h] * Dh + A[3,v]=
 * Dv + A[3,w] * Dw
> + * Td =3D A[4,x] * Dx + A[4,y] * Dy + A[4,z] * Dz + A[4,h] * Dh + A[4,v]=
 * Dv + A[4,w] * Dw
> + * Ud =3D A[5,x] * Dx + A[5,y] * Dy + A[5,z] * Dz + A[5,h] * Dh + A[5,v]=
 * Dv + A[5,w] * Dw
> + *
> + * A linear system always solvable because the coefficients matrix is
> + * always not singular due the properties of the matrix A[].
> + *
> + * Resulting speed in x64, with 16 data disks, using a stripe of 4 KiB,
> + * for a Core i7-3740QM CPU @ 2.7GHz is:
> + *
> + *           int8   int32   int64    sse2   sse2e   ssse3  ssse3e
> + *   par1           11469   21579   44743
> + *   par2            3474    6176   17930   20435
> + *   par3     850                                    7908    9069
> + *   par4     647                                    6357    7159
> + *   par5     527                                    5041    5412
> + *   par6     432                                    4094    4470
> + *
> + * Values are in MiB/s of data processed, not counting generated parity.
> + *
> + * References:
> + * [1] Anvin, "The mathematics of RAID-6", 2004
> + * [2] MacWilliams, Sloane, "The Theory of Error-Correcting Codes", 1977
> + * [3] Blomer, "An XOR-Based Erasure-Resilient Coding Scheme", 1995
> + * [4] Roth, "Introduction to Coding Theory", 2006
> + * [5] Plank, "Screaming Fast Galois Field Arithmetic Using Intel SIMD I=
nstructions", 2013
> + */
> +
> +#ifdef __KERNEL__ /* to build the user mode test */
> +/**
> + * Buffer filled with 0 used in recovering.
> + */
> +static uint8_t raid_zero_block[PAGE_SIZE] __aligned(256);
> +#else
> +extern uint8_t raid_zero_block[] __aligned(256);
> +#endif
> +
> +/*
> + * PAR1 (RAID5 with xor) implementation using the kernel xor_blocks()
> + * function.
> + */
> +void raid_par1_xorblocks(int nd, size_t size, void **v)
> +{
> +	int i;
> +
> +	/* copy the first block */
> +	memcpy(v[nd], v[0], size);
> +
> +	i =3D 1;
> +	while (i < nd) {
> +		int run =3D nd - i;
> +
> +		/* xor_blocks supports no more than MAX_XOR_BLOCKS blocks */
> +		if (run > MAX_XOR_BLOCKS)
> +			run =3D MAX_XOR_BLOCKS;
> +
> +		xor_blocks(run, size, v[nd], v + i);
> +
> +		i +=3D run;
> +	}
> +}
> +
> +#ifdef RAID_USE_RAID6_PQ
> +/**
> + * PAR2 (RAID6 with powers of 2) implementation using raid6 library.
> + */
> +void raid_par2_raid6(int nd, size_t size, void **vv)
> +{
> +	raid6_call.gen_syndrome(nd + 2, size, vv);
> +}
> +#endif
> +
> +/* internal forwarder */
> +void (*raid_par_ptr[RAID_PARITY_MAX])(int nd, size_t size, void **vv);
> +
> +void raid_par(int nd, int np, size_t size, void **v)
> +{
> +	BUG_ON(np < 1 || np > RAID_PARITY_MAX);
> +	BUG_ON(size % 64 !=3D 0);
> +
> +	raid_par_ptr[np - 1](nd, size, v);
> +}
> +EXPORT_SYMBOL_GPL(raid_par);
> +
> +/**
> + * Inverts the square matrix M of size nxn into V.
> + * We use Gauss elimination to invert.
> + */
> +void raid_invert(uint8_t *M, uint8_t *V, int n)
> +{
> +	int i, j, k;
> +
> +	/* set the identity matrix in V */
> +	for (i =3D 0; i < n; ++i)
> +		for (j =3D 0; j < n; ++j)
> +			V[i*n+j] =3D i =3D=3D j;
> +
> +	/* for each element in the diagonal */
> +	for (k =3D 0; k < n; ++k) {
> +		uint8_t f;
> +
> +		/* the diagonal element cannot be 0 because */
> +		/* we are inverting matrices with all the square submatrices */
> +		/* not singular */
> +		BUG_ON(M[k*n+k] =3D=3D 0);
> +
> +		/* make the diagonal element to be 1 */
> +		f =3D inv(M[k*n+k]);
> +		for (j =3D 0; j < n; ++j) {
> +			M[k*n+j] =3D mul(f, M[k*n+j]);
> +			V[k*n+j] =3D mul(f, V[k*n+j]);
> +		}
> +
> +		/* make all the elements over and under the diagonal to be 0 */
> +		for (i =3D 0; i < n; ++i) {
> +			if (i =3D=3D k)
> +				continue;
> +			f =3D M[i*n+k];
> +			for (j =3D 0; j < n; ++j) {
> +				M[i*n+j] ^=3D mul(f, M[k*n+j]);
> +				V[i*n+j] ^=3D mul(f, V[k*n+j]);
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * Computes the parity without the missing data blocks
> + * and store it in the buffers of such data blocks.
> + *
> + * This is the parity expressed as Pa,Qa,Ra,Sa,Ta,Ua
> + * in the equations.
> + *
> + * Note that all the other parities not in the ip[] vector
> + * are destroyed.
> + */
> +void raid_delta_gen(int nr, int *id, int *ip, int nd, size_t size, void =
**v)
> +{
> +	void *p[RAID_PARITY_MAX];
> +	void *pa[RAID_PARITY_MAX];
> +	int i;
> +
> +	for (i =3D 0; i < nr; ++i) {
> +		/* keep a copy of the parity buffer */
> +		p[i] =3D v[nd+ip[i]];
> +
> +		/* buffer for missing data blocks */
> +		pa[i] =3D v[id[i]];
> +
> +		/* set at zero the missing data blocks */
> +		v[id[i]] =3D raid_zero_block;
> +
> +		/* compute the parity over the missing data blocks */
> +		v[nd+ip[i]] =3D pa[i];
> +	}
> +
> +	/* recompute the minimal parity required */
> +	raid_par(nd, ip[nr - 1] + 1, size, v);
> +
> +	for (i =3D 0; i < nr; ++i) {
> +		/* restore disk buffers as before */
> +		v[id[i]] =3D pa[i];
> +
> +		/* restore parity buffers as before */
> +		v[nd+ip[i]] =3D p[i];
> +	}
> +}
> +
> +/**
> + * Recover failure of one data block for PAR1.
> + *
> + * Starting from the equation:
> + *
> + * Pd =3D Dx
> + *
> + * and solving we get:
> + *
> + * Dx =3D Pd
> + */
> +void raid_rec1_par1(int *id, int nd, size_t size, void **v)
> +{
> +	void *p;
> +	void *pa;
> +
> +	/* for PAR1 we can directly compute the missing block */
> +	/* and we don't need to use the zero buffer */
> +	p =3D v[nd];
> +	pa =3D v[id[0]];
> +
> +	/* use the parity as missing data block */
> +	v[id[0]] =3D p;
> +
> +	/* compute the parity over the missing data block */
> +	v[nd] =3D pa;
> +
> +	/* compute */
> +	raid_par(nd, 1, size, v);
> +
> +	/* restore as before */
> +	v[id[0]] =3D pa;
> +	v[nd] =3D p;
> +}
> +
> +/**
> + * Recover failure of two data blocks for PAR2.
> + *
> + * Starting from the equations:
> + *
> + * Pd =3D Dx + Dy
> + * Qd =3D 2^id[0] * Dx + 2^id[1] * Dy
> + *
> + * and solving we get:
> + *
> + *               1                     2^(-id[0])
> + * Dy =3D ------------------- * Pd + ------------------- * Qd
> + *      2^(id[1]-id[0]) + 1        2^(id[1]-id[0]) + 1
> + *
> + * Dx =3D Dy + Pd
> + *
> + * with conditions:
> + *
> + * 2^id[0] !=3D 0
> + * 2^(id[1]-id[0]) + 1 !=3D 0
> + *
> + * That are always satisfied for any 0<=3Did[0]<id[1]<255.
> + */
> +void raid_rec2_par2(int *id, int *ip, int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	size_t i;
> +	uint8_t *p;
> +	uint8_t *pa;
> +	uint8_t *q;
> +	uint8_t *qa;
> +	const uint8_t *T[2];
> +
> +	/* get multiplication tables */
> +	T[0] =3D table(inv(pow2(id[1]-id[0]) ^ 1));
> +	T[1] =3D table(inv(pow2(id[0]) ^ pow2(id[1])));
> +
> +	/* compute delta parity */
> +	raid_delta_gen(2, id, ip, nd, size, vv);
> +
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	pa =3D v[id[0]];
> +	qa =3D v[id[1]];
> +
> +	for (i =3D 0; i < size; ++i) {
> +		/* delta */
> +		uint8_t Pd =3D p[i] ^ pa[i];
> +		uint8_t Qd =3D q[i] ^ qa[i];
> +
> +		/* reconstruct */
> +		uint8_t Dy =3D T[0][Pd] ^ T[1][Qd];
> +		uint8_t Dx =3D Pd ^ Dy;
> +
> +		/* set */
> +		pa[i] =3D Dx;
> +		qa[i] =3D Dy;
> +	}
> +}
> +
> +/* internal forwarder */
> +void (*raid_rec_ptr[RAID_PARITY_MAX])(
> +	int nr, int *id, int *ip, int nd, size_t size, void **vv);
> +
> +void raid_rec(int nrd, int *id, int nrp, int *ip, int nd, int np, size_t=
 size, void **v)
> +{
> +	BUG_ON(nrd > nd);
> +	BUG_ON(nrd + nrp > np);
> +	BUG_ON(size % 64 !=3D 0);
> +	BUG_ON(size > PAGE_SIZE);
> +
> +	/* if failed data is present */
> +	if (nrd !=3D 0) {
> +		int iu[RAID_PARITY_MAX];
> +		int i, j, k;
> +
> +		/* setup the vector of parities to use */
> +		for (i =3D 0, j =3D 0, k =3D 0; i < np; ++i) {
> +			if (j < nrp && ip[j] =3D=3D i) {
> +				/* this parity has to be recovered */
> +				++j;
> +			} else {
> +				/* this parity is used for recovering */
> +				iu[k] =3D i;
> +				++k;
> +			}
> +		}
> +
> +		/* recover the data, and limit the parity use to needed ones */
> +		raid_rec_ptr[nrd - 1](nrd, id, iu, nd, size, v);
> +	}
> +
> +	/* recompute all the parities up to the last bad one */
> +	if (nrp !=3D 0)
> +		raid_par(nd, ip[nrp - 1] + 1, size, v);
> +}
> +EXPORT_SYMBOL_GPL(raid_rec);
> +
> diff --git a/lib/raid/sort.c b/lib/raid/sort.c
> new file mode 100644
> index 0000000..8afac72
> --- /dev/null
> +++ b/lib/raid/sort.c
> @@ -0,0 +1,72 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +
> +#define RAID_SWAP(a, b) \
> +	do { \
> +		if (v[a] > v[b]) { \
> +			int t =3D v[a]; \
> +			v[a] =3D v[b]; \
> +			v[b] =3D t; \
> +		} \
> +	} while (0)
> +
> +void raid_sort(int n, int *v)
> +{
> +	/* sorting networks generated with Batcher's Merge-Exchange */
> +	switch (n) {
> +	case 2:
> +		RAID_SWAP(0, 1);
> +		break;
> +	case 3:
> +		RAID_SWAP(0, 2);
> +		RAID_SWAP(0, 1);
> +		RAID_SWAP(1, 2);
> +		break;
> +	case 4:
> +		RAID_SWAP(0, 2);
> +		RAID_SWAP(1, 3);
> +		RAID_SWAP(0, 1);
> +		RAID_SWAP(2, 3);
> +		RAID_SWAP(1, 2);
> +		break;
> +	case 5:
> +		RAID_SWAP(0, 4);
> +		RAID_SWAP(0, 2);
> +		RAID_SWAP(1, 3);
> +		RAID_SWAP(2, 4);
> +		RAID_SWAP(0, 1);
> +		RAID_SWAP(2, 3);
> +		RAID_SWAP(1, 4);
> +		RAID_SWAP(1, 2);
> +		RAID_SWAP(3, 4);
> +		break;
> +	case 6:
> +		RAID_SWAP(0, 4);
> +		RAID_SWAP(1, 5);
> +		RAID_SWAP(0, 2);
> +		RAID_SWAP(1, 3);
> +		RAID_SWAP(2, 4);
> +		RAID_SWAP(3, 5);
> +		RAID_SWAP(0, 1);
> +		RAID_SWAP(2, 3);
> +		RAID_SWAP(4, 5);
> +		RAID_SWAP(1, 4);
> +		RAID_SWAP(1, 2);
> +		RAID_SWAP(3, 4);
> +		break;
> +	}
> +}
> +
> diff --git a/lib/raid/test/Makefile b/lib/raid/test/Makefile
> new file mode 100644
> index 0000000..04e8e1e
> --- /dev/null
> +++ b/lib/raid/test/Makefile
> @@ -0,0 +1,33 @@
> +#
> +# This is a simple Makefile to test some of the RAID code
> +# from userspace.
> +#
> +
> +CC  =3D gcc
> +CFLAGS =3D -I.. -I../../../include -Wall -Wextra -g -O2
> +LD =3D ld
> +OBJS =3D raid.o int.o x86.o tables.o memory.o test.o sort.o module.o xor=
.o
> +
> +.c.o:
> +	$(CC) $(CFLAGS) -c -o $@ $<
> +
> +%.c: ../%.c
> +	cp -f $< $@
> +
> +all: fulltest speedtest selftest
> +
> +fulltest: $(OBJS) fulltest.o
> +	$(CC) $(CFLAGS) -o fulltest $^
> +
> +speedtest: $(OBJS) speedtest.o
> +	$(CC) $(CFLAGS) -o speedtest $^
> +
> +selftest: $(OBJS) selftest.o
> +	$(CC) $(CFLAGS) -o selftest $^
> +
> +tables.c: mktables
> +	./mktables > tables.c
> +
> +clean:
> +	rm -f *.o mktables.c mktables tables.c fulltest speedtest selftest
> +
> diff --git a/lib/raid/test/combo.h b/lib/raid/test/combo.h
> new file mode 100644
> index 0000000..31530a2
> --- /dev/null
> +++ b/lib/raid/test/combo.h
> @@ -0,0 +1,155 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_COMBO_H
> +#define __RAID_COMBO_H
> +
> +#include <assert.h>
> +
> +/**
> + * Get the first permutation with repetition of r of n elements.
> + *
> + * Typical use is with permutation_next() in the form :
> + *
> + * int i[R];
> + * permutation_first(R, N, i);
> + * do {
> + *    code using i[0], i[1], ..., i[R-1]
> + * } while (permutation_next(R, N, i));
> + *
> + * It's equivalent at the code :
> + *
> + * for(i[0]=3D0;i[0]<N;++i[0])
> + *     for(i[1]=3D0;i[1]<N;++i[1])
> + *        ...
> + *            for(i[R-2]=3D0;i[R-2]<N;++i[R-2])
> + *                for(i[R-1]=3D0;i[R-1]<N;++i[R-1])
> + *                    code using i[0], i[1], ..., i[R-1]
> + */
> +static inline void permutation_first(int r, int n, int *c)
> +{
> +	int i;
> +
> +	(void)n; /* unused, but kept for clarity */
> +	assert(0 < r && r <=3D n);
> +
> +	for (i =3D 0; i < r; ++i)
> +		c[i] =3D 0;
> +}
> +
> +/**
> + * Get the next permutation with repetition of r of n elements.
> + * Return =3D=3D0 when finished.
> + */
> +static inline int permutation_next(int r, int n, int *c)
> +{
> +	int i =3D r - 1; /* present position */
> +
> +recurse:
> +	/* next element at position i */
> +	++c[i];
> +
> +	/* if the position has reached the max */
> +	if (c[i] >=3D n) {
> +
> +		/* if we are at the first level, we have finished */
> +		if (i =3D=3D 0)
> +			return 0;
> +
> +		/* increase the previous position */
> +		--i;
> +		goto recurse;
> +	}
> +
> +	++i;
> +
> +	/* initialize all the next positions, if any */
> +	while (i < r) {
> +		c[i] =3D 0;
> +		++i;
> +	}
> +
> +	return 1;
> +}
> +
> +/**
> + * Get the first combination without repetition of r of n elements.
> + *
> + * Typical use is with combination_next() in the form :
> + *
> + * int i[R];
> + * combination_first(R, N, i);
> + * do {
> + *    code using i[0], i[1], ..., i[R-1]
> + * } while (combination_next(R, N, i));
> + *
> + * It's equivalent at the code :
> + *
> + * for(i[0]=3D0;i[0]<N-(R-1);++i[0])
> + *     for(i[1]=3Di[0]+1;i[1]<N-(R-2);++i[1])
> + *        ...
> + *            for(i[R-2]=3Di[R-3]+1;i[R-2]<N-1;++i[R-2])
> + *                for(i[R-1]=3Di[R-2]+1;i[R-1]<N;++i[R-1])
> + *                    code using i[0], i[1], ..., i[R-1]
> + */
> +static inline void combination_first(int r, int n, int *c)
> +{
> +	int i;
> +
> +	(void)n; /* unused, but kept for clarity */
> +	assert(0 < r && r <=3D n);
> +
> +	for (i =3D 0; i < r; ++i)
> +		c[i] =3D i;
> +}
> +
> +/**
> + * Get the next combination without repetition of r of n elements.
> + * Return =3D=3D0 when finished.
> + */
> +static inline int combination_next(int r, int n, int *c)
> +{
> +	int i =3D r - 1; /* present position */
> +	int h =3D n; /* high limit for this position */
> +
> +recurse:
> +	/* next element at position i */
> +	++c[i];
> +
> +	/* if the position has reached the max */
> +	if (c[i] >=3D h) {
> +
> +		/* if we are at the first level, we have finished */
> +		if (i =3D=3D 0)
> +			return 0;
> +
> +		/* increase the previous position */
> +		--i;
> +		--h;
> +		goto recurse;
> +	}
> +
> +	++i;
> +
> +	/* initialize all the next positions, if any */
> +	while (i < r) {
> +		/* each position start at the next value of the previous one */
> +		c[i] =3D c[i-1] + 1;
> +		++i;
> +	}
> +
> +	return 1;
> +}
> +#endif
> +
> diff --git a/lib/raid/test/fulltest.c b/lib/raid/test/fulltest.c
> new file mode 100644
> index 0000000..fa7c3dd
> --- /dev/null
> +++ b/lib/raid/test/fulltest.c
> @@ -0,0 +1,76 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "test.h"
> +#include "cpu.h"
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +/*
> + * Size of the blocks to test.
> + */
> +#define TEST_SIZE 256
> +
> +uint8_t raid_zero_block[TEST_SIZE] __aligned(256);
> +
> +int main(void)
> +{
> +	raid_init();
> +
> +	printf("RAID Cauchy test suite\n\n");
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2())
> +		printf("Including x86 SSE2 functions\n");
> +	if (raid_cpu_has_ssse3())
> +		printf("Including x86 SSSE3 functions\n");
> +#endif
> +#ifdef CONFIG_X86_64
> +	printf("Including x64 extended SSE register set\n");
> +#endif
> +
> +	printf("\nPlease wait about 60 seconds...\n\n");
> +
> +	printf("Test sorting...\n");
> +	if (raid_test_sort() !=3D 0) {
> +		printf("FAILED!\n");
> +		exit(EXIT_FAILURE);
> +	}
> +	printf("Test combinations/permutations...\n");
> +	if (raid_test_combo() !=3D 0) {
> +		printf("FAILED!\n");
> +		exit(EXIT_FAILURE);
> +	}
> +	printf("Test parity generation with %u data disks...\n", RAID_DATA_MAX);
> +	if (raid_test_par(RAID_DATA_MAX, TEST_SIZE) !=3D 0) {
> +		printf("FAILED!\n");
> +		exit(EXIT_FAILURE);
> +	}
> +	printf("Test parity generation with 1 data disk...\n");
> +	if (raid_test_par(1, TEST_SIZE) !=3D 0) {
> +		printf("FAILED!\n");
> +		exit(EXIT_FAILURE);
> +	}
> +	printf("Test recovering with all combinations of 32 data and 6 parity b=
locks...\n");
> +	if (raid_test_rec(32, TEST_SIZE) !=3D 0) {
> +		printf("FAILED!\n");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	printf("OK\n");
> +	return 0;
> +}
> +
> diff --git a/lib/raid/test/memory.c b/lib/raid/test/memory.c
> new file mode 100644
> index 0000000..6807ee4
> --- /dev/null
> +++ b/lib/raid/test/memory.c
> @@ -0,0 +1,79 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "memory.h"
> +
> +void *raid_malloc_align(size_t size, void **freeptr)
> +{
> +	unsigned char *ptr;
> +	uintptr_t offset;
> +
> +	ptr =3D malloc(size + RAID_MALLOC_ALIGN);
> +	if (!ptr)
> +		return 0;
> +
> +	*freeptr =3D ptr;
> +
> +	offset =3D ((uintptr_t)ptr) % RAID_MALLOC_ALIGN;
> +
> +	if (offset !=3D 0)
> +		ptr +=3D RAID_MALLOC_ALIGN - offset;
> +
> +	return ptr;
> +}
> +
> +void **raid_malloc_vector(int nd, int n, size_t size, void **freeptr)
> +{
> +	void **v;
> +	unsigned char *va;
> +	int i;
> +
> +	v =3D malloc(n * sizeof(void *));
> +	if (!v)
> +		return 0;
> +
> +	va =3D raid_malloc_align(n * (size + RAID_MALLOC_DISPLACEMENT), freeptr=
);
> +	if (!va) {
> +		free(v);
> +		return 0;
> +	}
> +
> +	for (i =3D 0; i < n; ++i) {
> +		v[i] =3D va;
> +		va +=3D size + RAID_MALLOC_DISPLACEMENT;
> +	}
> +
> +	/* reverse order of the data blocks */
> +	/* because they are usually accessed from the last one */
> +	for (i =3D 0; i < nd/2; ++i) {
> +		void *ptr =3D v[i];
> +		v[i] =3D v[nd - 1 - i];
> +		v[nd - 1 - i] =3D ptr;
> +	}
> +
> +	return v;
> +}
> +
> +void raid_mrand_vector(int n, size_t size, void **vv)
> +{
> +	unsigned char **v =3D (unsigned char **)vv;
> +	int i;
> +	size_t j;
> +
> +	for (i =3D 0; i < n; ++i)
> +		for (j =3D 0; j < size; ++j)
> +			v[i][j] =3D rand();
> +}
> +
> diff --git a/lib/raid/test/memory.h b/lib/raid/test/memory.h
> new file mode 100644
> index 0000000..b5c4e9a
> --- /dev/null
> +++ b/lib/raid/test/memory.h
> @@ -0,0 +1,74 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_MEMORY_H
> +#define __RAID_MEMORY_H
> +
> +/**
> + * Memory alignment provided by raid_malloc_align().
> + *
> + * It should guarantee good cache performance everywhere.
> + */
> +#define RAID_MALLOC_ALIGN 256
> +
> +/**
> + * Memory displacement to avoid cache collisions on contiguous blocks,
> + * used by raid_malloc_vector().
> + *
> + * When allocating a sequence of blocks with a size of power of 2,
> + * there is the risk that the start of each block is mapped into the same
> + * cache line or prefetching prediction, resulting in collisions if you
> + * access all the blocks in parallel, from the start to the end.
> + *
> + * The selected value was choosen empirically with some speed tests
> + * with 16 data buffers of 4 KB.
> + *
> + * These are the results with no displacement:
> + *
> + *            int8   int32   int64    sse2   sse2e   ssse3  ssse3e
> + *    par1            6940   13971   29824
> + *    par2            2530    4675   14840   16485
> + *    par3     490                                    6859    7710
> + *
> + * These are the results with displacement resulting in improvments
> + * in the order of 20% or more:
> + *
> + *            int8   int32   int64    sse2   sse2e   ssse3  ssse3e
> + *    par1           11762   21450   44621
> + *    par2            3520    6176   18100   20338
> + *    par3     848                                    8009    9210
> + *
> + */
> +#define RAID_MALLOC_DISPLACEMENT 64
> +
> +/**
> + * Aligned malloc.
> + */
> +void *raid_malloc_align(size_t size, void **freeptr);
> +
> +/**
> + * Aligned vector allocation.
> + * Returns a vector of @n pointers, each one pointing to a block of
> + * the specified @size.
> + * The first @nd elements are reversed in order.
> + */
> +void **raid_malloc_vector(int nd, int n, size_t size, void **freeptr);
> +
> +/**
> + * Fills the memory vector with random data.
> + */
> +void raid_mrand_vector(int n, size_t size, void **vv);
> +
> +#endif
> +
> diff --git a/lib/raid/test/selftest.c b/lib/raid/test/selftest.c
> new file mode 100644
> index 0000000..c10db29
> --- /dev/null
> +++ b/lib/raid/test/selftest.c
> @@ -0,0 +1,41 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "cpu.h"
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +
> +uint8_t raid_zero_block[PAGE_SIZE] __aligned(256);
> +
> +int main(void)
> +{
> +	raid_init();
> +
> +	printf("RAID Cauchy selftest\n\n");
> +
> +	printf("Self test...\n");
> +	if (raid_selftest() !=3D 0) {
> +		printf("FAILED!\n");
> +		exit(EXIT_FAILURE);
> +	}
> +	printf("OK\n\n");
> +
> +	printf("Speed test...\n");
> +	raid_speedtest();
> +
> +	return 0;
> +}
> +
> diff --git a/lib/raid/test/speedtest.c b/lib/raid/test/speedtest.c
> new file mode 100644
> index 0000000..d3784c3
> --- /dev/null
> +++ b/lib/raid/test/speedtest.c
> @@ -0,0 +1,567 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "memory.h"
> +#include "cpu.h"
> +
> +#include <sys/time.h>
> +#include <stdio.h>
> +#include <inttypes.h>
> +
> +/*
> + * Size of the blocks to test.
> + */
> +#define TEST_SIZE PAGE_SIZE
> +
> +/*
> + * Number of data blocks to test.
> + */
> +#define TEST_COUNT (65536 / TEST_SIZE)
> +
> +uint8_t raid_zero_block[TEST_SIZE] __aligned(256);
> +
> +/**
> + * Differential us of two timeval.
> + */
> +static int64_t diffgettimeofday(struct timeval *start, struct timeval *s=
top)
> +{
> +	int64_t d;
> +
> +	d =3D 1000000LL * (stop->tv_sec - start->tv_sec);
> +	d +=3D stop->tv_usec - start->tv_usec;
> +
> +	return d;
> +}
> +
> +/**
> + * Start time measurement.
> + */
> +#define SPEED_START \
> +	count =3D 0; \
> +	gettimeofday(&start, 0); \
> +	do { \
> +		for (i =3D 0; i < delta; ++i)
> +
> +/**
> + * Stop time measurement.
> + */
> +#define SPEED_STOP \
> +		count +=3D delta; \
> +		gettimeofday(&stop, 0); \
> +	} while (diffgettimeofday(&start, &stop) < 1000000LL); \
> +	ds =3D size * (int64_t)count * nd; \
> +	dt =3D diffgettimeofday(&start, &stop);
> +
> +void speed(void)
> +{
> +	struct timeval start;
> +	struct timeval stop;
> +	int64_t ds;
> +	int64_t dt;
> +	int i, j;
> +	int id[RAID_PARITY_MAX];
> +	int ip[RAID_PARITY_MAX];
> +	int count;
> +	int delta =3D 10;
> +	int size =3D TEST_SIZE;
> +	int nd =3D TEST_COUNT;
> +	int nv;
> +	void *v_alloc;
> +	void **v;
> +
> +	nv =3D nd + RAID_PARITY_MAX;
> +
> +	v =3D raid_malloc_vector(nd, nv, size, &v_alloc);
> +
> +	/* initialize disks with fixed data */
> +	for (i =3D 0; i < nd; ++i)
> +		memset(v[i], i, size);
> +
> +	/* basic disks and parity mapping */
> +	for (i =3D 0; i < RAID_PARITY_MAX; ++i) {
> +		id[i] =3D i;
> +		ip[i] =3D i;
> +	}
> +
> +	printf("Speed test using %u data buffers of %u bytes, for a total of %u=
 KiB.\n", nd, size, nd * size / 1024);
> +	printf("Memory blocks have a displacement of %u bytes to improve cache =
performance.\n", RAID_MALLOC_DISPLACEMENT);
> +	printf("The reported value is the aggregate bandwidth of all data block=
s in MiB/s,\n");
> +	printf("not counting parity blocks.\n");
> +	printf("\n");
> +
> +	printf("Memory write speed using the C memset() function:\n");
> +	printf("%8s", "memset");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		for (j =3D 0; j < nd; ++j)
> +			memset(v[j], j, size);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	printf("\n");
> +	printf("\n");
> +
> +	/* RAID table */
> +	printf("RAID functions used for computing the parity:\n");
> +	printf("%8s", "");
> +	printf("%8s", "int8");
> +	printf("%8s", "int32");
> +	printf("%8s", "int64");
> +#ifdef CONFIG_X86
> +	printf("%8s", "sse2");
> +#ifdef CONFIG_X86_64
> +	printf("%8s", "sse2e");
> +#endif
> +	printf("%8s", "ssse3");
> +#ifdef CONFIG_X86_64
> +	printf("%8s", "ssse3e");
> +#endif
> +#endif
> +	printf("\n");
> +
> +	/* PAR1 */
> +	printf("%8s", "par1");
> +	fflush(stdout);
> +
> +	printf("%8s", "");
> +
> +	SPEED_START {
> +		raid_par1_int32(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		raid_par1_int64(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		SPEED_START {
> +			raid_par1_sse2(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +	}
> +#endif
> +	printf("\n");
> +
> +	/* PAR2 */
> +	printf("%8s", "par2");
> +	fflush(stdout);
> +
> +	printf("%8s", "");
> +
> +	SPEED_START {
> +		raid_par2_int32(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		raid_par2_int64(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		SPEED_START {
> +			raid_par2_sse2(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +
> +#ifdef CONFIG_X86_64
> +		SPEED_START {
> +			raid_par2_sse2ext(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +#endif
> +	}
> +#endif
> +	printf("\n");
> +
> +	/* PAR3 */
> +	printf("%8s", "par3");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		raid_par3_int8(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +	printf("%8s", "");
> +	printf("%8s", "");
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		printf("%8s", "");
> +
> +#ifdef CONFIG_X86_64
> +		printf("%8s", "");
> +#endif
> +	}
> +#endif
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			raid_par3_ssse3(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +
> +#ifdef CONFIG_X86_64
> +		SPEED_START {
> +			raid_par3_ssse3ext(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +#endif
> +	}
> +#endif
> +	printf("\n");
> +
> +	/* PAR4 */
> +	printf("%8s", "par4");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		raid_par4_int8(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +	printf("%8s", "");
> +	printf("%8s", "");
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		printf("%8s", "");
> +
> +#ifdef CONFIG_X86_64
> +		printf("%8s", "");
> +#endif
> +	}
> +#endif
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			raid_par4_ssse3(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +
> +#ifdef CONFIG_X86_64
> +		SPEED_START {
> +			raid_par4_ssse3ext(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +#endif
> +	}
> +#endif
> +	printf("\n");
> +
> +	/* PAR5 */
> +	printf("%8s", "par5");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		raid_par5_int8(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +	printf("%8s", "");
> +	printf("%8s", "");
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		printf("%8s", "");
> +
> +#ifdef CONFIG_X86_64
> +		printf("%8s", "");
> +#endif
> +	}
> +#endif
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			raid_par5_ssse3(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +
> +#ifdef CONFIG_X86_64
> +		SPEED_START {
> +			raid_par5_ssse3ext(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +#endif
> +	}
> +#endif
> +	printf("\n");
> +
> +	/* PAR6 */
> +	printf("%8s", "par6");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		raid_par6_int8(nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +	printf("%8s", "");
> +	printf("%8s", "");
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		printf("%8s", "");
> +
> +#ifdef CONFIG_X86_64
> +		printf("%8s", "");
> +#endif
> +	}
> +#endif
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			raid_par6_ssse3(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +
> +#ifdef CONFIG_X86_64
> +		SPEED_START {
> +			raid_par6_ssse3ext(nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +		fflush(stdout);
> +#endif
> +	}
> +#endif
> +	printf("\n");
> +	printf("\n");
> +
> +	/* recover table */
> +	printf("RAID functions used for recovering:\n");
> +	printf("%8s", "");
> +	printf("%8s", "int8");
> +#ifdef CONFIG_X86
> +	printf("%8s", "ssse3");
> +#endif
> +	printf("\n");
> +
> +	printf("%8s", "rec1");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		for (j =3D 0; j < nd; ++j)
> +			/* +1 to avoid PAR1 optimized case */
> +			raid_rec1_int8(1, id, ip + 1, nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			for (j =3D 0; j < nd; ++j)
> +				/* +1 to avoid PAR1 optimized case */
> +				raid_rec1_ssse3(1, id, ip + 1, nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +	}
> +#endif
> +	printf("\n");
> +
> +	printf("%8s", "rec2");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		for (j =3D 0; j < nd; ++j)
> +			/* +1 to avoid PAR2 optimized case */
> +			raid_rec2_int8(2, id, ip + 1, nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			for (j =3D 0; j < nd; ++j)
> +				/* +1 to avoid PAR2 optimized case */
> +				raid_rec2_ssse3(2, id, ip + 1, nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +	}
> +#endif
> +	printf("\n");
> +
> +	printf("%8s", "rec3");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		for (j =3D 0; j < nd; ++j)
> +			raid_recX_int8(3, id, ip, nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			for (j =3D 0; j < nd; ++j)
> +				raid_recX_ssse3(3, id, ip, nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +	}
> +#endif
> +	printf("\n");
> +
> +	printf("%8s", "rec4");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		for (j =3D 0; j < nd; ++j)
> +			raid_recX_int8(4, id, ip, nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			for (j =3D 0; j < nd; ++j)
> +				raid_recX_ssse3(4, id, ip, nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +	}
> +#endif
> +	printf("\n");
> +
> +	printf("%8s", "rec5");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		for (j =3D 0; j < nd; ++j)
> +			raid_recX_int8(5, id, ip, nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			for (j =3D 0; j < nd; ++j)
> +				raid_recX_ssse3(5, id, ip, nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +	}
> +#endif
> +	printf("\n");
> +
> +	printf("%8s", "rec6");
> +	fflush(stdout);
> +
> +	SPEED_START {
> +		for (j =3D 0; j < nd; ++j)
> +			raid_recX_int8(6, id, ip, nd, size, v);
> +	} SPEED_STOP
> +
> +	printf("%8"PRIu64, ds / dt);
> +	fflush(stdout);
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		SPEED_START {
> +			for (j =3D 0; j < nd; ++j)
> +				raid_recX_ssse3(6, id, ip, nd, size, v);
> +		} SPEED_STOP
> +
> +		printf("%8"PRIu64, ds / dt);
> +	}
> +#endif
> +	printf("\n");
> +	printf("\n");
> +
> +	free(v_alloc);
> +	free(v);
> +}
> +
> +int main(void)
> +{
> +	raid_init();
> +
> +	printf("RAID Cauchy speed test\n\n");
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2())
> +		printf("Including x86 SSE2 functions\n");
> +	if (raid_cpu_has_ssse3())
> +		printf("Including x86 SSSE3 functions\n");
> +#endif
> +#ifdef CONFIG_X86_64
> +	printf("Including x64 extended SSE register set\n");
> +#endif
> +
> +	printf("\nPlease wait about 30 seconds...\n\n");
> +
> +	speed();
> +
> +	return 0;
> +}
> +
> diff --git a/lib/raid/test/test.c b/lib/raid/test/test.c
> new file mode 100644
> index 0000000..69deacb
> --- /dev/null
> +++ b/lib/raid/test/test.c
> @@ -0,0 +1,314 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "cpu.h"
> +#include "combo.h"
> +#include "memory.h"
> +
> +/**
> + * Binomial coefficient of n over r.
> + */
> +static int ibc(int n, int r)
> +{
> +	if (r =3D=3D 0 || n =3D=3D r)
> +		return 1;
> +	else
> +		return ibc(n - 1, r - 1) + ibc(n - 1, r);
> +}
> +
> +/**
> + * Power n ^ r;
> + */
> +static int ipow(int n, int r)
> +{
> +	int v =3D 1;
> +	while (r) {
> +		v *=3D n;
> +		--r;
> +	}
> +	return v;
> +}
> +
> +int raid_test_combo(void)
> +{
> +	int r;
> +	int count;
> +	int p[RAID_PARITY_MAX];
> +
> +	for (r =3D 1; r <=3D RAID_PARITY_MAX; ++r) {
> +		/* count combination (r of RAID_PARITY_MAX) elements */
> +		count =3D 0;
> +		combination_first(r, RAID_PARITY_MAX, p);
> +
> +		do {
> +			++count;
> +		} while (combination_next(r, RAID_PARITY_MAX, p));
> +
> +		if (count !=3D ibc(RAID_PARITY_MAX, r))
> +			return -1;
> +	}
> +
> +	for (r =3D 1; r <=3D RAID_PARITY_MAX; ++r) {
> +		/* count permutation (r of RAID_PARITY_MAX) elements */
> +		count =3D 0;
> +		permutation_first(r, RAID_PARITY_MAX, p);
> +
> +		do {
> +			++count;
> +		} while (permutation_next(r, RAID_PARITY_MAX, p));
> +
> +		if (count !=3D ipow(RAID_PARITY_MAX, r))
> +			return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +int raid_test_sort(void)
> +{
> +	int p[RAID_PARITY_MAX];
> +	int r;
> +
> +	for (r =3D 1; r <=3D RAID_PARITY_MAX; ++r) {
> +		permutation_first(r, RAID_PARITY_MAX, p);
> +		do {
> +			int i[RAID_PARITY_MAX];
> +			int j;
> +
> +			/* make a copy */
> +			for (j =3D 0; j < r; ++j)
> +				i[j] =3D p[j];
> +
> +			raid_sort(r, i);
> +
> +			/* check order */
> +			for (j =3D 1; j < r; ++j)
> +				if (i[j-1] > i[j])
> +					return -1;
> +		} while (permutation_next(r, RAID_PARITY_MAX, p));
> +	}
> +
> +	return 0;
> +}
> +
> +int raid_test_rec(int nd, size_t size)
> +{
> +	void *v_alloc;
> +	void **v;
> +	void **data;
> +	void **parity;
> +	void **test;
> +	void *data_save[RAID_PARITY_MAX];
> +	void *parity_save[RAID_PARITY_MAX];
> +	void *waste;
> +	int nv;
> +	int id[RAID_PARITY_MAX];
> +	int ip[RAID_PARITY_MAX];
> +	int i;
> +	int j;
> +	int nr;
> +	void (*f[RAID_PARITY_MAX][4])(
> +		int nr, int *id, int *ip, int nd, size_t size, void **vbuf);
> +	int nf[RAID_PARITY_MAX];
> +	int np;
> +
> +	np =3D RAID_PARITY_MAX;
> +
> +	nv =3D nd + np * 2 + 1;
> +
> +	v =3D raid_malloc_vector(nd, nv, size, &v_alloc);
> +	if (!v)
> +		return -1;
> +
> +	data =3D v;
> +	parity =3D v + nd;
> +	test =3D v + nd + np;
> +
> +	for (i =3D 0; i < np; ++i)
> +		parity_save[i] =3D parity[i];
> +
> +	waste =3D v[nv-1];
> +
> +	/* fill data disk with random */
> +	raid_mrand_vector(nd, size, v);
> +
> +	/* setup recov functions */
> +	for (i =3D 0; i < np; ++i) {
> +		nf[i] =3D 0;
> +		if (i =3D=3D 0) {
> +			f[i][nf[i]++] =3D raid_rec1_int8;
> +#ifdef CONFIG_X86
> +			if (raid_cpu_has_ssse3())
> +				f[i][nf[i]++] =3D raid_rec1_ssse3;
> +#endif
> +		} else if (i =3D=3D 1) {
> +			f[i][nf[i]++] =3D raid_rec2_int8;
> +#ifdef CONFIG_X86
> +			if (raid_cpu_has_ssse3())
> +				f[i][nf[i]++] =3D raid_rec2_ssse3;
> +#endif
> +		} else {
> +			f[i][nf[i]++] =3D raid_recX_int8;
> +#ifdef CONFIG_X86
> +			if (raid_cpu_has_ssse3())
> +				f[i][nf[i]++] =3D raid_recX_ssse3;
> +#endif
> +		}
> +	}
> +
> +	/* compute the parity */
> +	raid_par_ref(nd, np, size, v);
> +
> +	/* set all the parity to the waste v */
> +	for (i =3D 0; i < np; ++i)
> +		parity[i] =3D waste;
> +
> +	/* all parity levels */
> +	for (nr =3D 1; nr <=3D np; ++nr) {
> +		/* all combinations (nr of nd) disks */
> +		combination_first(nr, nd, id);
> +		do {
> +			/* all combinations (nr of np) parities */
> +			combination_first(nr, np, ip);
> +			do {
> +				/* for each recover function */
> +				for (j =3D 0; j < nf[nr-1]; ++j) {
> +					/* set */
> +					for (i =3D 0; i < nr; ++i) {
> +						/* remove the missing data */
> +						data_save[i] =3D data[id[i]];
> +						data[id[i]] =3D test[i];
> +						/* set the parity to use */
> +						parity[ip[i]] =3D parity_save[ip[i]];
> +					}
> +
> +					/* recover */
> +					f[nr-1][j](nr, id, ip, nd, size, v);
> +
> +					/* check */
> +					for (i =3D 0; i < nr; ++i)
> +						if (memcmp(test[i], data_save[i], size) !=3D 0)
> +							goto bail;
> +
> +					/* restore */
> +					for (i =3D 0; i < nr; ++i) {
> +						/* restore the data */
> +						data[id[i]] =3D data_save[i];
> +						/* restore the parity */
> +						parity[ip[i]] =3D waste;
> +					}
> +				}
> +			} while (combination_next(nr, np, ip));
> +		} while (combination_next(nr, nd, id));
> +	}
> +
> +	free(v_alloc);
> +	free(v);
> +	return 0;
> +
> +bail:
> +	free(v_alloc);
> +	free(v);
> +	return -1;
> +}
> +
> +int raid_test_par(int nd, size_t size)
> +{
> +	void *v_alloc;
> +	void **v;
> +	int nv;
> +	int i, j;
> +	void (*f[64])(int nd, size_t size, void **vbuf);
> +	int nf;
> +	int np;
> +
> +	np =3D RAID_PARITY_MAX;
> +
> +	nv =3D nd + np * 2;
> +
> +	v =3D raid_malloc_vector(nd, nv, size, &v_alloc);
> +	if (!v)
> +		return -1;
> +
> +	/* fill with random */
> +	raid_mrand_vector(nv, size, v);
> +
> +	/* compute the parity */
> +	raid_par_ref(nd, np, size, v);
> +
> +	/* copy in back buffers */
> +	for (i =3D 0; i < np; ++i)
> +		memcpy(v[nd + np + i], v[nd + i], size);
> +
> +	/* load all the available functions */
> +	nf =3D 0;
> +
> +	f[nf++] =3D raid_par1_xorblocks;
> +	f[nf++] =3D raid_par1_int32;
> +	f[nf++] =3D raid_par1_int64;
> +	f[nf++] =3D raid_par2_int32;
> +	f[nf++] =3D raid_par2_int64;
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_sse2()) {
> +		f[nf++] =3D raid_par1_sse2;
> +		f[nf++] =3D raid_par2_sse2;
> +#ifdef CONFIG_X86_64
> +		f[nf++] =3D raid_par2_sse2ext;
> +#endif
> +	}
> +#endif
> +
> +	f[nf++] =3D raid_par3_int8;
> +	f[nf++] =3D raid_par4_int8;
> +	f[nf++] =3D raid_par5_int8;
> +	f[nf++] =3D raid_par6_int8;
> +
> +#ifdef CONFIG_X86
> +	if (raid_cpu_has_ssse3()) {
> +		f[nf++] =3D raid_par3_ssse3;
> +		f[nf++] =3D raid_par4_ssse3;
> +		f[nf++] =3D raid_par5_ssse3;
> +		f[nf++] =3D raid_par6_ssse3;
> +#ifdef CONFIG_X86_64
> +		f[nf++] =3D raid_par3_ssse3ext;
> +		f[nf++] =3D raid_par4_ssse3ext;
> +		f[nf++] =3D raid_par5_ssse3ext;
> +		f[nf++] =3D raid_par6_ssse3ext;
> +#endif
> +	}
> +#endif
> +
> +	/* check all the functions */
> +	for (j =3D 0; j < nf; ++j) {
> +		/* compute parity */
> +		f[j](nd, size, v);
> +
> +		/* check it */
> +		for (i =3D 0; i < np; ++i)
> +			if (memcmp(v[nd + np + i], v[nd + i], size) !=3D 0)
> +				goto bail;
> +	}
> +
> +	free(v_alloc);
> +	free(v);
> +	return 0;
> +
> +bail:
> +	free(v_alloc);
> +	free(v);
> +	return -1;
> +}
> +
> diff --git a/lib/raid/test/test.h b/lib/raid/test/test.h
> new file mode 100644
> index 0000000..67684fe
> --- /dev/null
> +++ b/lib/raid/test/test.h
> @@ -0,0 +1,59 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_TEST_H
> +#define __RAID_TEST_H
> +
> +/**
> + * Tests sorting functions.
> + *
> + * Test raid_sort() with all the possible combinations of elements to so=
rt.
> + *
> + * Returns 0 on success.
> + */
> +int raid_test_sort(void);
> +
> +/**
> + * Tests combination functions.
> + *
> + * Tests combination_first() and combination_next() for all the parity l=
evels.
> + *
> + * Returns 0 on success.
> + */
> +int raid_test_combo(void);
> +
> +/**
> + * Tests recovering functions.
> + *
> + * All the recovering functions are tested with all the combinations
> + * of failing disks and recovering parities.
> + *
> + * Take care that the test time grows exponentially with the number of d=
isks.
> + *
> + * Returns 0 on success.
> + */
> +int raid_test_rec(int nd, size_t size);
> +
> +/**
> + * Tests parity generation functions.
> + *
> + * All the parity generation functions are tested with the specified
> + * number of disks.
> + *
> + * Returns 0 on success.
> + */
> +int raid_test_par(int nd, size_t size);
> +
> +#endif
> +
> diff --git a/lib/raid/test/usermode.h b/lib/raid/test/usermode.h
> new file mode 100644
> index 0000000..0f73cec
> --- /dev/null
> +++ b/lib/raid/test/usermode.h
> @@ -0,0 +1,83 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __RAID_USERMODE_H
> +#define __RAID_USERMODE_H
> +
> +/*
> + * Compatibility layer for user mode applications.
> + */
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <assert.h>
> +#include <string.h>
> +#include <malloc.h>
> +#include <errno.h>
> +#include <sys/time.h>
> +
> +#define pr_err printf
> +#define pr_info printf
> +#define __aligned(a) __attribute__((aligned(a)))
> +#define PAGE_SIZE 4096
> +#define EXPORT_SYMBOL_GPL(a) int dummy_##a
> +#define EXPORT_SYMBOL(a) int dummy_##a
> +#if defined(__i386__)
> +#define CONFIG_X86 1
> +#define CONFIG_X86_32 1
> +#endif
> +#if defined(__x86_64__)
> +#define CONFIG_X86 1
> +#define CONFIG_X86_64 1
> +#endif
> +#define BUG_ON(a) assert(!(a))
> +#define MAX_XOR_BLOCKS 1
> +void xor_blocks(unsigned int count, unsigned int bytes, void *dest, void=
 **srcs);
> +#define GFP_KERNEL 0
> +#define get_order(x) 5
> +#define __get_free_pages(x, order) memalign(PAGE_SIZE, PAGE_SIZE * (1 <<=
 order))
> +#define free_pages(x, order) free((void *)x)
> +#define preempt_disable() do { } while (0)
> +#define preempt_enable() do { } while (0)
> +#define cpu_relax() do { } while (0)
> +#define HZ 1000
> +#define jiffies get_jiffies()
> +static inline unsigned long get_jiffies(void)
> +{
> +	struct timeval t;
> +	gettimeofday(&t, 0);
> +	return t.tv_sec * 1000 + t.tv_usec / 1000;
> +}
> +#define time_before(x, y) ((x) < (y))
> +
> +#ifdef CONFIG_X86
> +#define X86_FEATURE_XMM2 (0*32+26)
> +#define X86_FEATURE_SSSE3 (4*32+9)
> +#define X86_FEATURE_AVX (4*32+28)
> +#define X86_FEATURE_AVX2 (9*32+5)
> +
> +static inline int boot_cpu_has(int flag)
> +{
> +	uint32_t eax, ebx, ecx, edx;
> +
> +	eax =3D (flag & 0x100) ? 7 : (flag & 0x20) ? 0x80000001 : 1;
> +	ecx =3D 0;
> +
> +	asm volatile("cpuid" : "+a" (eax), "=3Db" (ebx), "=3Dd" (edx), "+c" (ec=
x));
> +
> +	return ((flag & 0x100 ? ebx : (flag & 0x80) ? ecx : edx) >> (flag & 31)=
) & 1;
> +}
> +#endif /* CONFIG_X86 */
> +
> +#endif
> +
> diff --git a/lib/raid/test/xor.c b/lib/raid/test/xor.c
> new file mode 100644
> index 0000000..2d68636
> --- /dev/null
> +++ b/lib/raid/test/xor.c
> @@ -0,0 +1,41 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +
> +/**
> + * Implementation of the kernel xor_blocks().
> + */
> +void xor_blocks(unsigned int count, unsigned int bytes, void *dest, void=
 **srcs)
> +{
> +	uint32_t *p1 =3D dest;
> +	uint32_t *p2 =3D srcs[0];
> +	long lines =3D bytes / (sizeof(uint32_t)) / 8;
> +
> +	BUG_ON(count !=3D 1);
> +
> +	do {
> +		p1[0] ^=3D p2[0];
> +		p1[1] ^=3D p2[1];
> +		p1[2] ^=3D p2[2];
> +		p1[3] ^=3D p2[3];
> +		p1[4] ^=3D p2[4];
> +		p1[5] ^=3D p2[5];
> +		p1[6] ^=3D p2[6];
> +		p1[7] ^=3D p2[7];
> +		p1 +=3D 8;
> +		p2 +=3D 8;
> +	} while (--lines > 0);
> +}
> +
> diff --git a/lib/raid/x86.c b/lib/raid/x86.c
> new file mode 100644
> index 0000000..fac8a67
> --- /dev/null
> +++ b/lib/raid/x86.c
> @@ -0,0 +1,1569 @@
> +/*
> + * Copyright (C) 2013 Andrea Mazzoleni
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "internal.h"
> +#include "gf.h"
> +
> +#ifdef CONFIG_X86
> +/*
> + * PAR1 (RAID5 with xor) SSE2 implementation
> + *
> + * Note that we don't have the corresponding x64 sse2ext function using =
more
> + * registers because processing a block of 64 bytes already fills
> + * the typical cache block, and processing 128 bytes doesn't increase
> + * performance.
> + */
> +void raid_par1_sse2(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +
> +	asm_begin();
> +
> +	for (i =3D 0; i < size; i +=3D 64) {
> +		asm volatile("movdqa %0,%%xmm0" : : "m" (v[l][i]));
> +		asm volatile("movdqa %0,%%xmm1" : : "m" (v[l][i+16]));
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (v[l][i+32]));
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (v[l][i+48]));
> +		for (d =3D l-1; d >=3D 0; --d) {
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +			asm volatile("movdqa %0,%%xmm5" : : "m" (v[d][i+16]));
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (v[d][i+32]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (v[d][i+48]));
> +			asm volatile("pxor %xmm4,%xmm0");
> +			asm volatile("pxor %xmm5,%xmm1");
> +			asm volatile("pxor %xmm6,%xmm2");
> +			asm volatile("pxor %xmm7,%xmm3");
> +		}
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (p[i+16]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (p[i+32]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (p[i+48]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +static const struct gfconst16 {
> +	uint8_t poly[16];
> +	uint8_t low4[16];
> +} gfconst16  __aligned(32) =3D {
> +	{ 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1=
d, 0x1d, 0x1d, 0x1d, 0x1d },
> +	{ 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0=
f, 0x0f, 0x0f, 0x0f, 0x0f },
> +};
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * PAR2 (RAID6 with powers of 2) SSE2 implementation
> + */
> +void raid_par2_sse2(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +
> +	asm_begin();
> +
> +	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 32) {
> +		asm volatile("movdqa %0,%%xmm0" : : "m" (v[l][i]));
> +		asm volatile("movdqa %0,%%xmm1" : : "m" (v[l][i+16]));
> +		asm volatile("movdqa %xmm0,%xmm2");
> +		asm volatile("movdqa %xmm1,%xmm3");
> +		for (d =3D l-1; d >=3D 0; --d) {
> +			asm volatile("pxor %xmm4,%xmm4");
> +			asm volatile("pxor %xmm5,%xmm5");
> +			asm volatile("pcmpgtb %xmm2,%xmm4");
> +			asm volatile("pcmpgtb %xmm3,%xmm5");
> +			asm volatile("paddb %xmm2,%xmm2");
> +			asm volatile("paddb %xmm3,%xmm3");
> +			asm volatile("pand %xmm7,%xmm4");
> +			asm volatile("pand %xmm7,%xmm5");
> +			asm volatile("pxor %xmm4,%xmm2");
> +			asm volatile("pxor %xmm5,%xmm3");
> +
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +			asm volatile("movdqa %0,%%xmm5" : : "m" (v[d][i+16]));
> +			asm volatile("pxor %xmm4,%xmm0");
> +			asm volatile("pxor %xmm5,%xmm1");
> +			asm volatile("pxor %xmm4,%xmm2");
> +			asm volatile("pxor %xmm5,%xmm3");
> +		}
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (p[i+16]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (q[i+16]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86_64
> +/*
> + * PAR2 (RAID6 with powers of 2) SSE2 implementation
> + *
> + * Note that it uses 16 registers, meaning that x64 is required.
> + */
> +void raid_par2_sse2ext(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +
> +	asm_begin();
> +
> +	asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.poly[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 64) {
> +		asm volatile("movdqa %0,%%xmm0" : : "m" (v[l][i]));
> +		asm volatile("movdqa %0,%%xmm1" : : "m" (v[l][i+16]));
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (v[l][i+32]));
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (v[l][i+48]));
> +		asm volatile("movdqa %xmm0,%xmm4");
> +		asm volatile("movdqa %xmm1,%xmm5");
> +		asm volatile("movdqa %xmm2,%xmm6");
> +		asm volatile("movdqa %xmm3,%xmm7");
> +		for (d =3D l-1; d >=3D 0; --d) {
> +			asm volatile("pxor %xmm8,%xmm8");
> +			asm volatile("pxor %xmm9,%xmm9");
> +			asm volatile("pxor %xmm10,%xmm10");
> +			asm volatile("pxor %xmm11,%xmm11");
> +			asm volatile("pcmpgtb %xmm4,%xmm8");
> +			asm volatile("pcmpgtb %xmm5,%xmm9");
> +			asm volatile("pcmpgtb %xmm6,%xmm10");
> +			asm volatile("pcmpgtb %xmm7,%xmm11");
> +			asm volatile("paddb %xmm4,%xmm4");
> +			asm volatile("paddb %xmm5,%xmm5");
> +			asm volatile("paddb %xmm6,%xmm6");
> +			asm volatile("paddb %xmm7,%xmm7");
> +			asm volatile("pand %xmm15,%xmm8");
> +			asm volatile("pand %xmm15,%xmm9");
> +			asm volatile("pand %xmm15,%xmm10");
> +			asm volatile("pand %xmm15,%xmm11");
> +			asm volatile("pxor %xmm8,%xmm4");
> +			asm volatile("pxor %xmm9,%xmm5");
> +			asm volatile("pxor %xmm10,%xmm6");
> +			asm volatile("pxor %xmm11,%xmm7");
> +
> +			asm volatile("movdqa %0,%%xmm8" : : "m" (v[d][i]));
> +			asm volatile("movdqa %0,%%xmm9" : : "m" (v[d][i+16]));
> +			asm volatile("movdqa %0,%%xmm10" : : "m" (v[d][i+32]));
> +			asm volatile("movdqa %0,%%xmm11" : : "m" (v[d][i+48]));
> +			asm volatile("pxor %xmm8,%xmm0");
> +			asm volatile("pxor %xmm9,%xmm1");
> +			asm volatile("pxor %xmm10,%xmm2");
> +			asm volatile("pxor %xmm11,%xmm3");
> +			asm volatile("pxor %xmm8,%xmm4");
> +			asm volatile("pxor %xmm9,%xmm5");
> +			asm volatile("pxor %xmm10,%xmm6");
> +			asm volatile("pxor %xmm11,%xmm7");
> +		}
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (p[i+16]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (p[i+32]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (p[i+48]));
> +		asm volatile("movntdq %%xmm4,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm5,%0" : "=3Dm" (q[i+16]));
> +		asm volatile("movntdq %%xmm6,%0" : "=3Dm" (q[i+32]));
> +		asm volatile("movntdq %%xmm7,%0" : "=3Dm" (q[i+48]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * PAR3 (triple parity with Cauchy matrix) SSSE3 implementation
> + */
> +void raid_par3_ssse3(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 3; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	asm volatile("movdqa %0,%%xmm3" : : "m" (gfconst16.poly[0]));
> +	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
> +
> +		asm volatile("movdqa %xmm4,%xmm0");
> +		asm volatile("movdqa %xmm4,%xmm1");
> +
> +		asm volatile("movdqa %xmm4,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm6");
> +		asm volatile("pxor   %xmm6,%xmm2");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +
> +			asm volatile("pxor %xmm5,%xmm5");
> +			asm volatile("pcmpgtb %xmm1,%xmm5");
> +			asm volatile("paddb %xmm1,%xmm1");
> +			asm volatile("pand %xmm3,%xmm5");
> +			asm volatile("pxor %xmm5,%xmm1");
> +
> +			asm volatile("pxor %xmm4,%xmm0");
> +			asm volatile("pxor %xmm4,%xmm1");
> +
> +			asm volatile("movdqa %xmm4,%xmm5");
> +			asm volatile("psrlw  $4,%xmm5");
> +			asm volatile("pand   %xmm7,%xmm4");
> +			asm volatile("pand   %xmm7,%xmm5");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pxor   %xmm6,%xmm2");
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("pshufb %xmm5,%xmm6");
> +			asm volatile("pxor   %xmm6,%xmm2");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
> +
> +		asm volatile("pxor %xmm5,%xmm5");
> +		asm volatile("pcmpgtb %xmm1,%xmm5");
> +		asm volatile("paddb %xmm1,%xmm1");
> +		asm volatile("pand %xmm3,%xmm5");
> +		asm volatile("pxor %xmm5,%xmm1");
> +
> +		asm volatile("pxor %xmm4,%xmm0");
> +		asm volatile("pxor %xmm4,%xmm1");
> +		asm volatile("pxor %xmm4,%xmm2");
> +
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (r[i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86_64
> +/*
> + * PAR3 (triple parity with Cauchy matrix) SSSE3 implementation
> + *
> + * Note that it uses 16 registers, meaning that x64 is required.
> + */
> +void raid_par3_ssse3ext(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 3; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	asm volatile("movdqa %0,%%xmm3" : : "m" (gfconst16.poly[0]));
> +	asm volatile("movdqa %0,%%xmm11" : : "m" (gfconst16.low4[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 32) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
> +		asm volatile("movdqa %0,%%xmm12" : : "m" (v[l][i+16]));
> +
> +		asm volatile("movdqa %xmm4,%xmm0");
> +		asm volatile("movdqa %xmm4,%xmm1");
> +		asm volatile("movdqa %xmm12,%xmm8");
> +		asm volatile("movdqa %xmm12,%xmm9");
> +
> +		asm volatile("movdqa %xmm4,%xmm5");
> +		asm volatile("movdqa %xmm12,%xmm13");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("psrlw  $4,%xmm13");
> +		asm volatile("pand   %xmm11,%xmm4");
> +		asm volatile("pand   %xmm11,%xmm12");
> +		asm volatile("pand   %xmm11,%xmm5");
> +		asm volatile("pand   %xmm11,%xmm13");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("movdqa %xmm2,%xmm10");
> +		asm volatile("movdqa %xmm7,%xmm15");
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm12,%xmm10");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pshufb %xmm13,%xmm15");
> +		asm volatile("pxor   %xmm7,%xmm2");
> +		asm volatile("pxor   %xmm15,%xmm10");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (v[d][i+16]));
> +
> +			asm volatile("pxor %xmm5,%xmm5");
> +			asm volatile("pxor %xmm13,%xmm13");
> +			asm volatile("pcmpgtb %xmm1,%xmm5");
> +			asm volatile("pcmpgtb %xmm9,%xmm13");
> +			asm volatile("paddb %xmm1,%xmm1");
> +			asm volatile("paddb %xmm9,%xmm9");
> +			asm volatile("pand %xmm3,%xmm5");
> +			asm volatile("pand %xmm3,%xmm13");
> +			asm volatile("pxor %xmm5,%xmm1");
> +			asm volatile("pxor %xmm13,%xmm9");
> +
> +			asm volatile("pxor %xmm4,%xmm0");
> +			asm volatile("pxor %xmm4,%xmm1");
> +			asm volatile("pxor %xmm12,%xmm8");
> +			asm volatile("pxor %xmm12,%xmm9");
> +
> +			asm volatile("movdqa %xmm4,%xmm5");
> +			asm volatile("movdqa %xmm12,%xmm13");
> +			asm volatile("psrlw  $4,%xmm5");
> +			asm volatile("psrlw  $4,%xmm13");
> +			asm volatile("pand   %xmm11,%xmm4");
> +			asm volatile("pand   %xmm11,%xmm12");
> +			asm volatile("pand   %xmm11,%xmm5");
> +			asm volatile("pand   %xmm11,%xmm13");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("movdqa %xmm6,%xmm14");
> +			asm volatile("movdqa %xmm7,%xmm15");
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm12,%xmm14");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pshufb %xmm13,%xmm15");
> +			asm volatile("pxor   %xmm6,%xmm2");
> +			asm volatile("pxor   %xmm14,%xmm10");
> +			asm volatile("pxor   %xmm7,%xmm2");
> +			asm volatile("pxor   %xmm15,%xmm10");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
> +		asm volatile("movdqa %0,%%xmm12" : : "m" (v[0][i+16]));
> +
> +		asm volatile("pxor %xmm5,%xmm5");
> +		asm volatile("pxor %xmm13,%xmm13");
> +		asm volatile("pcmpgtb %xmm1,%xmm5");
> +		asm volatile("pcmpgtb %xmm9,%xmm13");
> +		asm volatile("paddb %xmm1,%xmm1");
> +		asm volatile("paddb %xmm9,%xmm9");
> +		asm volatile("pand %xmm3,%xmm5");
> +		asm volatile("pand %xmm3,%xmm13");
> +		asm volatile("pxor %xmm5,%xmm1");
> +		asm volatile("pxor %xmm13,%xmm9");
> +
> +		asm volatile("pxor %xmm4,%xmm0");
> +		asm volatile("pxor %xmm4,%xmm1");
> +		asm volatile("pxor %xmm4,%xmm2");
> +		asm volatile("pxor %xmm12,%xmm8");
> +		asm volatile("pxor %xmm12,%xmm9");
> +		asm volatile("pxor %xmm12,%xmm10");
> +
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm8,%0" : "=3Dm" (p[i+16]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm9,%0" : "=3Dm" (q[i+16]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (r[i]));
> +		asm volatile("movntdq %%xmm10,%0" : "=3Dm" (r[i+16]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * PAR4 (quad parity with Cauchy matrix) SSSE3 implementation
> + */
> +void raid_par4_ssse3(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 4; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
> +
> +		asm volatile("movdqa %xmm4,%xmm0");
> +		asm volatile("movdqa %xmm4,%xmm1");
> +
> +		asm volatile("movdqa %xmm4,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm2");
> +
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm3");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm3");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +
> +			asm volatile("pxor %xmm5,%xmm5");
> +			asm volatile("pcmpgtb %xmm1,%xmm5");
> +			asm volatile("paddb %xmm1,%xmm1");
> +			asm volatile("pand %xmm7,%xmm5");
> +			asm volatile("pxor %xmm5,%xmm1");
> +
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +
> +			asm volatile("pxor %xmm4,%xmm0");
> +			asm volatile("pxor %xmm4,%xmm1");
> +
> +			asm volatile("movdqa %xmm4,%xmm5");
> +			asm volatile("psrlw  $4,%xmm5");
> +			asm volatile("pand   %xmm7,%xmm4");
> +			asm volatile("pand   %xmm7,%xmm5");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm2");
> +			asm volatile("pxor   %xmm7,%xmm2");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm3");
> +			asm volatile("pxor   %xmm7,%xmm3");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
> +
> +		asm volatile("pxor %xmm5,%xmm5");
> +		asm volatile("pcmpgtb %xmm1,%xmm5");
> +		asm volatile("paddb %xmm1,%xmm1");
> +		asm volatile("pand %xmm7,%xmm5");
> +		asm volatile("pxor %xmm5,%xmm1");
> +
> +		asm volatile("pxor %xmm4,%xmm0");
> +		asm volatile("pxor %xmm4,%xmm1");
> +		asm volatile("pxor %xmm4,%xmm2");
> +		asm volatile("pxor %xmm4,%xmm3");
> +
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (r[i]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (s[i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86_64
> +/*
> + * PAR4 (quad parity with Cauchy matrix) SSSE3 implementation
> + *
> + * Note that it uses 16 registers, meaning that x64 is required.
> + */
> +void raid_par4_ssse3ext(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 4; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	for (i =3D 0; i < size; i +=3D 32) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
> +		asm volatile("movdqa %0,%%xmm12" : : "m" (v[l][i+16]));
> +
> +		asm volatile("movdqa %xmm4,%xmm0");
> +		asm volatile("movdqa %xmm4,%xmm1");
> +		asm volatile("movdqa %xmm12,%xmm8");
> +		asm volatile("movdqa %xmm12,%xmm9");
> +
> +		asm volatile("movdqa %xmm4,%xmm5");
> +		asm volatile("movdqa %xmm12,%xmm13");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("psrlw  $4,%xmm13");
> +		asm volatile("pand   %xmm15,%xmm4");
> +		asm volatile("pand   %xmm15,%xmm12");
> +		asm volatile("pand   %xmm15,%xmm5");
> +		asm volatile("pand   %xmm15,%xmm13");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("movdqa %xmm2,%xmm10");
> +		asm volatile("movdqa %xmm7,%xmm15");
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm12,%xmm10");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pshufb %xmm13,%xmm15");
> +		asm volatile("pxor   %xmm7,%xmm2");
> +		asm volatile("pxor   %xmm15,%xmm10");
> +
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
> +		asm volatile("movdqa %xmm3,%xmm11");
> +		asm volatile("movdqa %xmm7,%xmm15");
> +		asm volatile("pshufb %xmm4,%xmm3");
> +		asm volatile("pshufb %xmm12,%xmm11");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pshufb %xmm13,%xmm15");
> +		asm volatile("pxor   %xmm7,%xmm3");
> +		asm volatile("pxor   %xmm15,%xmm11");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +			asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (v[d][i+16]));
> +
> +			asm volatile("pxor %xmm5,%xmm5");
> +			asm volatile("pxor %xmm13,%xmm13");
> +			asm volatile("pcmpgtb %xmm1,%xmm5");
> +			asm volatile("pcmpgtb %xmm9,%xmm13");
> +			asm volatile("paddb %xmm1,%xmm1");
> +			asm volatile("paddb %xmm9,%xmm9");
> +			asm volatile("pand %xmm7,%xmm5");
> +			asm volatile("pand %xmm7,%xmm13");
> +			asm volatile("pxor %xmm5,%xmm1");
> +			asm volatile("pxor %xmm13,%xmm9");
> +
> +			asm volatile("pxor %xmm4,%xmm0");
> +			asm volatile("pxor %xmm4,%xmm1");
> +			asm volatile("pxor %xmm12,%xmm8");
> +			asm volatile("pxor %xmm12,%xmm9");
> +
> +			asm volatile("movdqa %xmm4,%xmm5");
> +			asm volatile("movdqa %xmm12,%xmm13");
> +			asm volatile("psrlw  $4,%xmm5");
> +			asm volatile("psrlw  $4,%xmm13");
> +			asm volatile("pand   %xmm15,%xmm4");
> +			asm volatile("pand   %xmm15,%xmm12");
> +			asm volatile("pand   %xmm15,%xmm5");
> +			asm volatile("pand   %xmm15,%xmm13");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("movdqa %xmm6,%xmm14");
> +			asm volatile("movdqa %xmm7,%xmm15");
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm12,%xmm14");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pshufb %xmm13,%xmm15");
> +			asm volatile("pxor   %xmm6,%xmm2");
> +			asm volatile("pxor   %xmm14,%xmm10");
> +			asm volatile("pxor   %xmm7,%xmm2");
> +			asm volatile("pxor   %xmm15,%xmm10");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
> +			asm volatile("movdqa %xmm6,%xmm14");
> +			asm volatile("movdqa %xmm7,%xmm15");
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm12,%xmm14");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pshufb %xmm13,%xmm15");
> +			asm volatile("pxor   %xmm6,%xmm3");
> +			asm volatile("pxor   %xmm14,%xmm11");
> +			asm volatile("pxor   %xmm7,%xmm3");
> +			asm volatile("pxor   %xmm15,%xmm11");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +		asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
> +		asm volatile("movdqa %0,%%xmm12" : : "m" (v[0][i+16]));
> +
> +		asm volatile("pxor %xmm5,%xmm5");
> +		asm volatile("pxor %xmm13,%xmm13");
> +		asm volatile("pcmpgtb %xmm1,%xmm5");
> +		asm volatile("pcmpgtb %xmm9,%xmm13");
> +		asm volatile("paddb %xmm1,%xmm1");
> +		asm volatile("paddb %xmm9,%xmm9");
> +		asm volatile("pand %xmm7,%xmm5");
> +		asm volatile("pand %xmm7,%xmm13");
> +		asm volatile("pxor %xmm5,%xmm1");
> +		asm volatile("pxor %xmm13,%xmm9");
> +
> +		asm volatile("pxor %xmm4,%xmm0");
> +		asm volatile("pxor %xmm4,%xmm1");
> +		asm volatile("pxor %xmm4,%xmm2");
> +		asm volatile("pxor %xmm4,%xmm3");
> +		asm volatile("pxor %xmm12,%xmm8");
> +		asm volatile("pxor %xmm12,%xmm9");
> +		asm volatile("pxor %xmm12,%xmm10");
> +		asm volatile("pxor %xmm12,%xmm11");
> +
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm8,%0" : "=3Dm" (p[i+16]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm9,%0" : "=3Dm" (q[i+16]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (r[i]));
> +		asm volatile("movntdq %%xmm10,%0" : "=3Dm" (r[i+16]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (s[i]));
> +		asm volatile("movntdq %%xmm11,%0" : "=3Dm" (s[i+16]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * PAR5 (penta parity with Cauchy matrix) SSSE3 implementation
> + */
> +void raid_par5_ssse3(int nd, size_t size, void **vv)
> +/* ensures that stack is aligned at 16 bytes because we allocate SSE reg=
isters in it */
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	uint8_t *t;
> +	int d, l;
> +	size_t i;
> +	uint8_t p0[16] __aligned(16);
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +	t =3D v[nd+4];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 5; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
> +
> +		asm volatile("movdqa %xmm4,%xmm0");
> +		asm volatile("movdqa %%xmm4,%0" : "=3Dm" (p0[0]));
> +
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +		asm volatile("movdqa %xmm4,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +
> +		asm volatile("movdqa %0,%%xmm1" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm1");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm1");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][1][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm2");
> +
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][2][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][2][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm3");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm3");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (p0[0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +
> +			asm volatile("pxor %xmm5,%xmm5");
> +			asm volatile("pcmpgtb %xmm0,%xmm5");
> +			asm volatile("paddb %xmm0,%xmm0");
> +			asm volatile("pand %xmm7,%xmm5");
> +			asm volatile("pxor %xmm5,%xmm0");
> +
> +			asm volatile("pxor %xmm4,%xmm0");
> +			asm volatile("pxor %xmm4,%xmm6");
> +			asm volatile("movdqa %%xmm6,%0" : "=3Dm" (p0[0]));
> +
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +			asm volatile("movdqa %xmm4,%xmm5");
> +			asm volatile("psrlw  $4,%xmm5");
> +			asm volatile("pand   %xmm7,%xmm4");
> +			asm volatile("pand   %xmm7,%xmm5");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm1");
> +			asm volatile("pxor   %xmm7,%xmm1");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm2");
> +			asm volatile("pxor   %xmm7,%xmm2");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][2][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][2][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm3");
> +			asm volatile("pxor   %xmm7,%xmm3");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
> +		asm volatile("movdqa %0,%%xmm6" : : "m" (p0[0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +
> +		asm volatile("pxor %xmm5,%xmm5");
> +		asm volatile("pcmpgtb %xmm0,%xmm5");
> +		asm volatile("paddb %xmm0,%xmm0");
> +		asm volatile("pand %xmm7,%xmm5");
> +		asm volatile("pxor %xmm5,%xmm0");
> +
> +		asm volatile("pxor %xmm4,%xmm0");
> +		asm volatile("pxor %xmm4,%xmm1");
> +		asm volatile("pxor %xmm4,%xmm2");
> +		asm volatile("pxor %xmm4,%xmm3");
> +		asm volatile("pxor %xmm4,%xmm6");
> +
> +		asm volatile("movntdq %%xmm6,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (r[i]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (s[i]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (t[i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86_64
> +/*
> + * PAR5 (penta parity with Cauchy matrix) SSSE3 implementation
> + *
> + * Note that it uses 16 registers, meaning that x64 is required.
> + */
> +void raid_par5_ssse3ext(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	uint8_t *t;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +	t =3D v[nd+4];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 5; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	asm volatile("movdqa %0,%%xmm14" : : "m" (gfconst16.poly[0]));
> +	asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm10" : : "m" (v[l][i]));
> +
> +		asm volatile("movdqa %xmm10,%xmm0");
> +		asm volatile("movdqa %xmm10,%xmm1");
> +
> +		asm volatile("movdqa %xmm10,%xmm11");
> +		asm volatile("psrlw  $4,%xmm11");
> +		asm volatile("pand   %xmm15,%xmm10");
> +		asm volatile("pand   %xmm15,%xmm11");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("pshufb %xmm10,%xmm2");
> +		asm volatile("pshufb %xmm11,%xmm13");
> +		asm volatile("pxor   %xmm13,%xmm2");
> +
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
> +		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][1][1][0]));
> +		asm volatile("pshufb %xmm10,%xmm3");
> +		asm volatile("pshufb %xmm11,%xmm13");
> +		asm volatile("pxor   %xmm13,%xmm3");
> +
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (gfgenpshufb[l][2][0][0]));
> +		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][2][1][0]));
> +		asm volatile("pshufb %xmm10,%xmm4");
> +		asm volatile("pshufb %xmm11,%xmm13");
> +		asm volatile("pxor   %xmm13,%xmm4");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm10" : : "m" (v[d][i]));
> +
> +			asm volatile("pxor %xmm11,%xmm11");
> +			asm volatile("pcmpgtb %xmm1,%xmm11");
> +			asm volatile("paddb %xmm1,%xmm1");
> +			asm volatile("pand %xmm14,%xmm11");
> +			asm volatile("pxor %xmm11,%xmm1");
> +
> +			asm volatile("pxor %xmm10,%xmm0");
> +			asm volatile("pxor %xmm10,%xmm1");
> +
> +			asm volatile("movdqa %xmm10,%xmm11");
> +			asm volatile("psrlw  $4,%xmm11");
> +			asm volatile("pand   %xmm15,%xmm10");
> +			asm volatile("pand   %xmm15,%xmm11");
> +
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("pshufb %xmm10,%xmm12");
> +			asm volatile("pshufb %xmm11,%xmm13");
> +			asm volatile("pxor   %xmm12,%xmm2");
> +			asm volatile("pxor   %xmm13,%xmm2");
> +
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][1][0][0]));
> +			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][1][1][0]));
> +			asm volatile("pshufb %xmm10,%xmm12");
> +			asm volatile("pshufb %xmm11,%xmm13");
> +			asm volatile("pxor   %xmm12,%xmm3");
> +			asm volatile("pxor   %xmm13,%xmm3");
> +
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][2][0][0]));
> +			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][2][1][0]));
> +			asm volatile("pshufb %xmm10,%xmm12");
> +			asm volatile("pshufb %xmm11,%xmm13");
> +			asm volatile("pxor   %xmm12,%xmm4");
> +			asm volatile("pxor   %xmm13,%xmm4");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm10" : : "m" (v[0][i]));
> +
> +		asm volatile("pxor %xmm11,%xmm11");
> +		asm volatile("pcmpgtb %xmm1,%xmm11");
> +		asm volatile("paddb %xmm1,%xmm1");
> +		asm volatile("pand %xmm14,%xmm11");
> +		asm volatile("pxor %xmm11,%xmm1");
> +
> +		asm volatile("pxor %xmm10,%xmm0");
> +		asm volatile("pxor %xmm10,%xmm1");
> +		asm volatile("pxor %xmm10,%xmm2");
> +		asm volatile("pxor %xmm10,%xmm3");
> +		asm volatile("pxor %xmm10,%xmm4");
> +
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (r[i]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (s[i]));
> +		asm volatile("movntdq %%xmm4,%0" : "=3Dm" (t[i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * PAR6 (hexa parity with Cauchy matrix) SSSE3 implementation
> + */
> +void raid_par6_ssse3(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	uint8_t *t;
> +	uint8_t *u;
> +	int d, l;
> +	size_t i;
> +	uint8_t p0[16] __aligned(16);
> +	uint8_t q0[16] __aligned(16);
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +	t =3D v[nd+4];
> +	u =3D v[nd+5];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 6; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
> +
> +		asm volatile("movdqa %%xmm4,%0" : "=3Dm" (p0[0]));
> +		asm volatile("movdqa %%xmm4,%0" : "=3Dm" (q0[0]));
> +
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +		asm volatile("movdqa %xmm4,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +
> +		asm volatile("movdqa %0,%%xmm0" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm0");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm0");
> +
> +		asm volatile("movdqa %0,%%xmm1" : : "m" (gfgenpshufb[l][1][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm1");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm1");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][2][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][2][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm2");
> +
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][3][0][0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][3][1][0]));
> +		asm volatile("pshufb %xmm4,%xmm3");
> +		asm volatile("pshufb %xmm5,%xmm7");
> +		asm volatile("pxor   %xmm7,%xmm3");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm5" : : "m" (p0[0]));
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (q0[0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +
> +			asm volatile("pxor %xmm4,%xmm4");
> +			asm volatile("pcmpgtb %xmm6,%xmm4");
> +			asm volatile("paddb %xmm6,%xmm6");
> +			asm volatile("pand %xmm7,%xmm4");
> +			asm volatile("pxor %xmm4,%xmm6");
> +
> +			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
> +
> +			asm volatile("pxor %xmm4,%xmm5");
> +			asm volatile("pxor %xmm4,%xmm6");
> +			asm volatile("movdqa %%xmm5,%0" : "=3Dm" (p0[0]));
> +			asm volatile("movdqa %%xmm6,%0" : "=3Dm" (q0[0]));
> +
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +			asm volatile("movdqa %xmm4,%xmm5");
> +			asm volatile("psrlw  $4,%xmm5");
> +			asm volatile("pand   %xmm7,%xmm4");
> +			asm volatile("pand   %xmm7,%xmm5");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm0");
> +			asm volatile("pxor   %xmm7,%xmm0");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm1");
> +			asm volatile("pxor   %xmm7,%xmm1");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][2][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][2][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm2");
> +			asm volatile("pxor   %xmm7,%xmm2");
> +
> +			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][3][0][0]));
> +			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][3][1][0]));
> +			asm volatile("pshufb %xmm4,%xmm6");
> +			asm volatile("pshufb %xmm5,%xmm7");
> +			asm volatile("pxor   %xmm6,%xmm3");
> +			asm volatile("pxor   %xmm7,%xmm3");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm5" : : "m" (p0[0]));
> +		asm volatile("movdqa %0,%%xmm6" : : "m" (q0[0]));
> +		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
> +
> +		asm volatile("pxor %xmm4,%xmm4");
> +		asm volatile("pcmpgtb %xmm6,%xmm4");
> +		asm volatile("paddb %xmm6,%xmm6");
> +		asm volatile("pand %xmm7,%xmm4");
> +		asm volatile("pxor %xmm4,%xmm6");
> +
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
> +		asm volatile("pxor %xmm4,%xmm0");
> +		asm volatile("pxor %xmm4,%xmm1");
> +		asm volatile("pxor %xmm4,%xmm2");
> +		asm volatile("pxor %xmm4,%xmm3");
> +		asm volatile("pxor %xmm4,%xmm5");
> +		asm volatile("pxor %xmm4,%xmm6");
> +
> +		asm volatile("movntdq %%xmm5,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm6,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (r[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (s[i]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (t[i]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (u[i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86_64
> +/*
> + * PAR6 (hexa parity with Cauchy matrix) SSSE3 implementation
> + *
> + * Note that it uses 16 registers, meaning that x64 is required.
> + */
> +void raid_par6_ssse3ext(int nd, size_t size, void **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *q;
> +	uint8_t *r;
> +	uint8_t *s;
> +	uint8_t *t;
> +	uint8_t *u;
> +	int d, l;
> +	size_t i;
> +
> +	l =3D nd - 1;
> +	p =3D v[nd];
> +	q =3D v[nd+1];
> +	r =3D v[nd+2];
> +	s =3D v[nd+3];
> +	t =3D v[nd+4];
> +	u =3D v[nd+5];
> +
> +	/* special case with only one data disk */
> +	if (l =3D=3D 0) {
> +		for (i =3D 0; i < 6; ++i)
> +			memcpy(v[1+i], v[0], size);
> +		return;
> +	}
> +
> +	asm_begin();
> +
> +	/* generic case with at least two data disks */
> +	asm volatile("movdqa %0,%%xmm14" : : "m" (gfconst16.poly[0]));
> +	asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		/* last disk without the by two multiplication */
> +		asm volatile("movdqa %0,%%xmm10" : : "m" (v[l][i]));
> +
> +		asm volatile("movdqa %xmm10,%xmm0");
> +		asm volatile("movdqa %xmm10,%xmm1");
> +
> +		asm volatile("movdqa %xmm10,%xmm11");
> +		asm volatile("psrlw  $4,%xmm11");
> +		asm volatile("pand   %xmm15,%xmm10");
> +		asm volatile("pand   %xmm15,%xmm11");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
> +		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][0][1][0]));
> +		asm volatile("pshufb %xmm10,%xmm2");
> +		asm volatile("pshufb %xmm11,%xmm13");
> +		asm volatile("pxor   %xmm13,%xmm2");
> +
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
> +		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][1][1][0]));
> +		asm volatile("pshufb %xmm10,%xmm3");
> +		asm volatile("pshufb %xmm11,%xmm13");
> +		asm volatile("pxor   %xmm13,%xmm3");
> +
> +		asm volatile("movdqa %0,%%xmm4" : : "m" (gfgenpshufb[l][2][0][0]));
> +		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][2][1][0]));
> +		asm volatile("pshufb %xmm10,%xmm4");
> +		asm volatile("pshufb %xmm11,%xmm13");
> +		asm volatile("pxor   %xmm13,%xmm4");
> +
> +		asm volatile("movdqa %0,%%xmm5" : : "m" (gfgenpshufb[l][3][0][0]));
> +		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][3][1][0]));
> +		asm volatile("pshufb %xmm10,%xmm5");
> +		asm volatile("pshufb %xmm11,%xmm13");
> +		asm volatile("pxor   %xmm13,%xmm5");
> +
> +		/* intermediate disks */
> +		for (d =3D l-1; d > 0; --d) {
> +			asm volatile("movdqa %0,%%xmm10" : : "m" (v[d][i]));
> +
> +			asm volatile("pxor %xmm11,%xmm11");
> +			asm volatile("pcmpgtb %xmm1,%xmm11");
> +			asm volatile("paddb %xmm1,%xmm1");
> +			asm volatile("pand %xmm14,%xmm11");
> +			asm volatile("pxor %xmm11,%xmm1");
> +
> +			asm volatile("pxor %xmm10,%xmm0");
> +			asm volatile("pxor %xmm10,%xmm1");
> +
> +			asm volatile("movdqa %xmm10,%xmm11");
> +			asm volatile("psrlw  $4,%xmm11");
> +			asm volatile("pand   %xmm15,%xmm10");
> +			asm volatile("pand   %xmm15,%xmm11");
> +
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][0][0][0]));
> +			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][0][1][0]));
> +			asm volatile("pshufb %xmm10,%xmm12");
> +			asm volatile("pshufb %xmm11,%xmm13");
> +			asm volatile("pxor   %xmm12,%xmm2");
> +			asm volatile("pxor   %xmm13,%xmm2");
> +
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][1][0][0]));
> +			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][1][1][0]));
> +			asm volatile("pshufb %xmm10,%xmm12");
> +			asm volatile("pshufb %xmm11,%xmm13");
> +			asm volatile("pxor   %xmm12,%xmm3");
> +			asm volatile("pxor   %xmm13,%xmm3");
> +
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][2][0][0]));
> +			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][2][1][0]));
> +			asm volatile("pshufb %xmm10,%xmm12");
> +			asm volatile("pshufb %xmm11,%xmm13");
> +			asm volatile("pxor   %xmm12,%xmm4");
> +			asm volatile("pxor   %xmm13,%xmm4");
> +
> +			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][3][0][0]));
> +			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][3][1][0]));
> +			asm volatile("pshufb %xmm10,%xmm12");
> +			asm volatile("pshufb %xmm11,%xmm13");
> +			asm volatile("pxor   %xmm12,%xmm5");
> +			asm volatile("pxor   %xmm13,%xmm5");
> +		}
> +
> +		/* first disk with all coefficients at 1 */
> +		asm volatile("movdqa %0,%%xmm10" : : "m" (v[0][i]));
> +
> +		asm volatile("pxor %xmm11,%xmm11");
> +		asm volatile("pcmpgtb %xmm1,%xmm11");
> +		asm volatile("paddb %xmm1,%xmm1");
> +		asm volatile("pand %xmm14,%xmm11");
> +		asm volatile("pxor %xmm11,%xmm1");
> +
> +		asm volatile("pxor %xmm10,%xmm0");
> +		asm volatile("pxor %xmm10,%xmm1");
> +		asm volatile("pxor %xmm10,%xmm2");
> +		asm volatile("pxor %xmm10,%xmm3");
> +		asm volatile("pxor %xmm10,%xmm4");
> +		asm volatile("pxor %xmm10,%xmm5");
> +
> +		asm volatile("movntdq %%xmm0,%0" : "=3Dm" (p[i]));
> +		asm volatile("movntdq %%xmm1,%0" : "=3Dm" (q[i]));
> +		asm volatile("movntdq %%xmm2,%0" : "=3Dm" (r[i]));
> +		asm volatile("movntdq %%xmm3,%0" : "=3Dm" (s[i]));
> +		asm volatile("movntdq %%xmm4,%0" : "=3Dm" (t[i]));
> +		asm volatile("movntdq %%xmm5,%0" : "=3Dm" (u[i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * RAID recovering for one disk SSSE3 implementation
> + */
> +void raid_rec1_ssse3(int nr, int *id, int *ip, int nd, size_t size, void=
 **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	uint8_t *p;
> +	uint8_t *pa;
> +	uint8_t G;
> +	uint8_t V;
> +	size_t i;
> +
> +	(void)nr; /* unused, it's always 1 */
> +
> +	/* if it's RAID5 uses the faster function */
> +	if (ip[0] =3D=3D 0) {
> +		raid_rec1_par1(id, nd, size, vv);
> +		return;
> +	}
> +
> +#ifdef RAID_USE_RAID6_PQ
> +	/* if it's RAID6 recovering with Q uses the faster function */
> +	if (ip[0] =3D=3D 1) {
> +		raid6_datap_recov(nd + 2, size, id[0], vv);
> +		return;
> +	}
> +#endif
> +
> +	/* setup the coefficients matrix */
> +	G =3D A(ip[0], id[0]);
> +
> +	/* invert it to solve the system of linear equations */
> +	V =3D inv(G);
> +
> +	/* compute delta parity */
> +	raid_delta_gen(1, id, ip, nd, size, vv);
> +
> +	p =3D v[nd+ip[0]];
> +	pa =3D v[id[0]];
> +
> +	asm_begin();
> +
> +	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +	asm volatile("movdqa %0,%%xmm4" : : "m" (gfmulpshufb[V][0][0]));
> +	asm volatile("movdqa %0,%%xmm5" : : "m" (gfmulpshufb[V][1][0]));
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		asm volatile("movdqa %0,%%xmm0" : : "m" (p[i]));
> +		asm volatile("movdqa %0,%%xmm1" : : "m" (pa[i]));
> +		asm volatile("movdqa %xmm4,%xmm2");
> +		asm volatile("movdqa %xmm5,%xmm3");
> +		asm volatile("pxor   %xmm0,%xmm1");
> +		asm volatile("movdqa %xmm1,%xmm0");
> +		asm volatile("psrlw  $4,%xmm1");
> +		asm volatile("pand   %xmm7,%xmm0");
> +		asm volatile("pand   %xmm7,%xmm1");
> +		asm volatile("pshufb %xmm0,%xmm2");
> +		asm volatile("pshufb %xmm1,%xmm3");
> +		asm volatile("pxor   %xmm3,%xmm2");
> +		asm volatile("movdqa %%xmm2,%0" : "=3Dm" (pa[i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * RAID recovering for two disks SSSE3 implementation
> + */
> +void raid_rec2_ssse3(int nr, int *id, int *ip, int nd, size_t size, void=
 **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	const int N =3D 2;
> +	uint8_t *p[N];
> +	uint8_t *pa[N];
> +	uint8_t G[N*N];
> +	uint8_t V[N*N];
> +	size_t i;
> +	int j, k;
> +
> +	(void)nr; /* unused, it's always 2 */
> +
> +#ifdef RAID_USE_RAID6_PQ
> +	/* if it's RAID6 recovering with P and Q uses the faster function */
> +	if (ip[0] =3D=3D 0 && ip[1] =3D=3D 1) {
> +		raid6_2data_recov(nd + 2, size, id[0], id[1], vv);
> +		return;
> +	}
> +#endif
> +
> +	/* setup the coefficients matrix */
> +	for (j =3D 0; j < N; ++j)
> +		for (k =3D 0; k < N; ++k)
> +			G[j*N+k] =3D A(ip[j], id[k]);
> +
> +	/* invert it to solve the system of linear equations */
> +	raid_invert(G, V, N);
> +
> +	/* compute delta parity */
> +	raid_delta_gen(N, id, ip, nd, size, vv);
> +
> +	for (j =3D 0; j < N; ++j) {
> +		p[j] =3D v[nd+ip[j]];
> +		pa[j] =3D v[id[j]];
> +	}
> +
> +	asm_begin();
> +
> +	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		asm volatile("movdqa %0,%%xmm0" : : "m" (p[0][i]));
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (pa[0][i]));
> +		asm volatile("movdqa %0,%%xmm1" : : "m" (p[1][i]));
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (pa[1][i]));
> +		asm volatile("pxor   %xmm2,%xmm0");
> +		asm volatile("pxor   %xmm3,%xmm1");
> +
> +		asm volatile("pxor %xmm6,%xmm6");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[0]][0][0]));
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[0]][1][0]));
> +		asm volatile("movdqa %xmm0,%xmm4");
> +		asm volatile("movdqa %xmm0,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm3");
> +		asm volatile("pxor   %xmm2,%xmm6");
> +		asm volatile("pxor   %xmm3,%xmm6");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[1]][0][0]));
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[1]][1][0]));
> +		asm volatile("movdqa %xmm1,%xmm4");
> +		asm volatile("movdqa %xmm1,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm3");
> +		asm volatile("pxor   %xmm2,%xmm6");
> +		asm volatile("pxor   %xmm3,%xmm6");
> +
> +		asm volatile("movdqa %%xmm6,%0" : "=3Dm" (pa[0][i]));
> +
> +		asm volatile("pxor %xmm6,%xmm6");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[2]][0][0]));
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[2]][1][0]));
> +		asm volatile("movdqa %xmm0,%xmm4");
> +		asm volatile("movdqa %xmm0,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm3");
> +		asm volatile("pxor   %xmm2,%xmm6");
> +		asm volatile("pxor   %xmm3,%xmm6");
> +
> +		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[3]][0][0]));
> +		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[3]][1][0]));
> +		asm volatile("movdqa %xmm1,%xmm4");
> +		asm volatile("movdqa %xmm1,%xmm5");
> +		asm volatile("psrlw  $4,%xmm5");
> +		asm volatile("pand   %xmm7,%xmm4");
> +		asm volatile("pand   %xmm7,%xmm5");
> +		asm volatile("pshufb %xmm4,%xmm2");
> +		asm volatile("pshufb %xmm5,%xmm3");
> +		asm volatile("pxor   %xmm2,%xmm6");
> +		asm volatile("pxor   %xmm3,%xmm6");
> +
> +		asm volatile("movdqa %%xmm6,%0" : "=3Dm" (pa[1][i]));
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +
> +#ifdef CONFIG_X86
> +/*
> + * RAID recovering SSSE3 implementation
> + */
> +void raid_recX_ssse3(int nr, int *id, int *ip, int nd, size_t size, void=
 **vv)
> +{
> +	uint8_t **v =3D (uint8_t **)vv;
> +	int N =3D nr;
> +	uint8_t *p[RAID_PARITY_MAX];
> +	uint8_t *pa[RAID_PARITY_MAX];
> +	uint8_t G[RAID_PARITY_MAX*RAID_PARITY_MAX];
> +	uint8_t V[RAID_PARITY_MAX*RAID_PARITY_MAX];
> +	size_t i;
> +	int j, k;
> +
> +	/* setup the coefficients matrix */
> +	for (j =3D 0; j < N; ++j)
> +		for (k =3D 0; k < N; ++k)
> +			G[j*N+k] =3D A(ip[j], id[k]);
> +
> +	/* invert it to solve the system of linear equations */
> +	raid_invert(G, V, N);
> +
> +	/* compute delta parity */
> +	raid_delta_gen(N, id, ip, nd, size, vv);
> +
> +	for (j =3D 0; j < N; ++j) {
> +		p[j] =3D v[nd+ip[j]];
> +		pa[j] =3D v[id[j]];
> +	}
> +
> +	asm_begin();
> +
> +	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
> +
> +	for (i =3D 0; i < size; i +=3D 16) {
> +		uint8_t PD[RAID_PARITY_MAX][16] __aligned(16);
> +
> +		/* delta */
> +		for (j =3D 0; j < N; ++j) {
> +			asm volatile("movdqa %0,%%xmm0" : : "m" (p[j][i]));
> +			asm volatile("movdqa %0,%%xmm1" : : "m" (pa[j][i]));
> +			asm volatile("pxor   %xmm1,%xmm0");
> +			asm volatile("movdqa %%xmm0,%0" : "=3Dm" (PD[j][0]));
> +		}
> +
> +		/* reconstruct */
> +		for (j =3D 0; j < N; ++j) {
> +			asm volatile("pxor %xmm0,%xmm0");
> +			asm volatile("pxor %xmm1,%xmm1");
> +
> +			for (k =3D 0; k < N; ++k) {
> +				uint8_t m =3D V[j*N+k];
> +
> +				asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[m][0][0]));
> +				asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[m][1][0]));
> +				asm volatile("movdqa %0,%%xmm4" : : "m" (PD[k][0]));
> +				asm volatile("movdqa %xmm4,%xmm5");
> +				asm volatile("psrlw  $4,%xmm5");
> +				asm volatile("pand   %xmm7,%xmm4");
> +				asm volatile("pand   %xmm7,%xmm5");
> +				asm volatile("pshufb %xmm4,%xmm2");
> +				asm volatile("pshufb %xmm5,%xmm3");
> +				asm volatile("pxor   %xmm2,%xmm0");
> +				asm volatile("pxor   %xmm3,%xmm1");
> +			}
> +
> +			asm volatile("pxor %xmm1,%xmm0");
> +			asm volatile("movdqa %%xmm0,%0" : "=3Dm" (pa[j][i]));
> +		}
> +	}
> +
> +	asm_end();
> +}
> +#endif
> +


--Sig_/XAib6=fZd8RphMO6bZcWJ=I
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsn1oTnsnt1WYoG5AQJJRw//aWiGCP1+Ou9BILPWceJUNnyIkHeQ3Nf9
dyLFWMBhUgW59NwNZ9/ReczY0Z7FsG0mPM8fUyyepV1aFFXVlHMh3pV878LqwHUa
/om8V+6bKXH4OQhMA+vYxMEdhIvAgpPpMYJgJVBuQuwdZ/VwZb80jHqMOtGSgY5v
5l5Ef9rBtguK1lESDgOhz/XWmBx/T1H9YNwUdcEOTBvejjJTq+KRF5P0LxGxOJ+2
5wuJcqdpVA+b+yZoLeLaZNR84s64jHF4V9rQilalrFyCwsNEi3zy8lu5jhKTKj3J
czrdjxNokY0shJCLS5yNEALfAnWLPXOhZigceGT3xEyWZXoi4PmmE6bNj+RgFU5A
bvOEXYythVwhE+CKlhZUgWZsZYiOh4fyivV3T93ka9dRxtBJRK4+Rt75OPoY6FO0
yc4jYa6xO7cfif2YM9hS4YPyUC3M+Nkis+9PqdeSYliEo/7lmA+91oGQSnaeBDq3
FmxTmbBhaPxQhcIaBChmO0P9KikLq6rUwU9mviVuPRQltEyC2V/18+VzKk2jRdpV
9ABSbWxC6H1yEdZ1FgXIiQk8Dy8gSeNtAhAK+KFjE9tvlK93QDkmt2AIsaYk/fhp
IaT5YnnjVryx5DhFSL4cFyFaiM6IbgdpyO+m50ZdhGl79XDIfjVCimwIVgz5C6Bc
K7CJMWJKrPQ=
=qTzv
-----END PGP SIGNATURE-----

--Sig_/XAib6=fZd8RphMO6bZcWJ=I--
