Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaAYINq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 03:13:46 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55807 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaAYINa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 03:13:30 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: neilb@suse.de
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        amadvance@gmail.com
Subject: [RFC v4 1/3] lib: raid: New RAID library supporting up to six parities
Date: Sat, 25 Jan 2014 09:12:47 +0100
Message-Id: <1390637569-22551-2-git-send-email-amadvance@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1390637569-22551-1-git-send-email-amadvance@gmail.com>
References: <1390637569-22551-1-git-send-email-amadvance@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new lib/raid directory, containing a new RAID support
based on a Cauchy matrix working for up to six parities, and backward
compatible with the existing RAID6 support.

It was developed for kernel 3.13, but it should work with any other
version because it's formed only of new files. The only modification
is about adding a new CONFIG_RAID_CAUCHY option in the "lib" configuration
section.

The interface is defined in include/linux/raid/raid.h and provides two new
functions raid_gen() and raid_rec() that can handle parity generation and
data recovering for up to six level of redundancy, and replace the previous
RAID6 interface.

The library provides fast implementations using SSE2 and SSSE3 for x86/x64
and a portable C implementation working everythere.
If the RAID6 library is enabled in the kernel, its functionality is also used
to maintain the existing level of performance for the first two parities in
architectures different than x86.

At startup the module runs a very fast self test (about 1ms) to ensure that
the used functions are correct.
You can also enable a speed test similar at the one used by raid6, using the
"speedtest=1" argument when loading the module.

In the lib/raid/test directory are present also some user mode test programs:
selftest - Runs the same selftest and speedtest executed at the module startup.
fulltest - Runs a more extensive test that checks all the built-in functions.
speetest - Runs a more complete speed test.
invtest - Runs an extensive matrix inversion test of all the 377.342.351.231
          possible square submatrices of the Cauchy matrix used.
covtest - Runs a coverage test using lcov.

As a reference, in my icore7 2.7GHz the speedtest program reports:

...
Speed test using 16 data buffers of 4096 bytes, for a total of 64 KiB.
Memory blocks have a displacement of 64 bytes to improve cache performance.
The reported value is the aggregate bandwidth of all data blocks in MiB/s,
not counting parity blocks.

Memory write speed using the C memset() function:
  memset   33518

RAID functions used for computing the parity:
            int8   int32   int64    sse2   sse2e   ssse3  ssse3e
    gen1           11762   21450   44621
    gen2            3520    6176   18100   20338
    gen3     848                                    8009    9210
    gen4     659                                    6518    7303
    gen5     531                                    4931    5363
    gen6     430                                    4069    4471

RAID functions used for recovering:
            int8   ssse3
    rec1     591    1126
    rec2     272     456
    rec3      80     305
    rec4      49     216
    rec5      34     151
...

Legend:
genX functions to generate X parities
recX functions to recover X data blocks
int8 implemention based on 8 bits arithmetics
int32 implemention based on 32 bits arithmetics
int64 implemention based on 64 bits arithmetics
sse2 implemention based on SSE2
sse2e implemention based on SSE2 with 16 registers (x64)
ssse3 implemention based on SSSE3
ssse3e implemention based on SSSE3 with 16 registers (x64)

Signed-off-by: Andrea Mazzoleni <amadvance@gmail.com>
---
 include/linux/raid/helper.h |   32 +
 include/linux/raid/raid.h   |   87 +++
 lib/Kconfig                 |   17 +
 lib/Makefile                |    1 +
 lib/raid/.gitignore         |    3 +
 lib/raid/Makefile           |   14 +
 lib/raid/cpu.h              |   44 ++
 lib/raid/gf.h               |  109 +++
 lib/raid/helper.c           |   38 ++
 lib/raid/int.c              |  567 ++++++++++++++++
 lib/raid/internal.h         |  148 ++++
 lib/raid/mktables.c         |  338 ++++++++++
 lib/raid/module.c           |  458 +++++++++++++
 lib/raid/raid.c             |  492 ++++++++++++++
 lib/raid/test/Makefile      |   72 ++
 lib/raid/test/combo.h       |  155 +++++
 lib/raid/test/fulltest.c    |   79 +++
 lib/raid/test/invtest.c     |  172 +++++
 lib/raid/test/memory.c      |   79 +++
 lib/raid/test/memory.h      |   78 +++
 lib/raid/test/selftest.c    |   44 ++
 lib/raid/test/speedtest.c   |  578 ++++++++++++++++
 lib/raid/test/test.c        |  314 +++++++++
 lib/raid/test/test.h        |   59 ++
 lib/raid/test/usermode.h    |   95 +++
 lib/raid/test/xor.c         |   41 ++
 lib/raid/x86.c              | 1565 +++++++++++++++++++++++++++++++++++++++++++
 27 files changed, 5679 insertions(+)
 create mode 100644 include/linux/raid/helper.h
 create mode 100644 include/linux/raid/raid.h
 create mode 100644 lib/raid/.gitignore
 create mode 100644 lib/raid/Makefile
 create mode 100644 lib/raid/cpu.h
 create mode 100644 lib/raid/gf.h
 create mode 100644 lib/raid/helper.c
 create mode 100644 lib/raid/int.c
 create mode 100644 lib/raid/internal.h
 create mode 100644 lib/raid/mktables.c
 create mode 100644 lib/raid/module.c
 create mode 100644 lib/raid/raid.c
 create mode 100644 lib/raid/test/Makefile
 create mode 100644 lib/raid/test/combo.h
 create mode 100644 lib/raid/test/fulltest.c
 create mode 100644 lib/raid/test/invtest.c
 create mode 100644 lib/raid/test/memory.c
 create mode 100644 lib/raid/test/memory.h
 create mode 100644 lib/raid/test/selftest.c
 create mode 100644 lib/raid/test/speedtest.c
 create mode 100644 lib/raid/test/test.c
 create mode 100644 lib/raid/test/test.h
 create mode 100644 lib/raid/test/usermode.h
 create mode 100644 lib/raid/test/xor.c
 create mode 100644 lib/raid/x86.c

diff --git a/include/linux/raid/helper.h b/include/linux/raid/helper.h
new file mode 100644
index 0000000..4787df9
--- /dev/null
+++ b/include/linux/raid/helper.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_HELPER_H
+#define __RAID_HELPER_H
+
+/**
+ * Inserts an integer in a sorted vector.
+ *
+ * This function can be used to insert indexes in order, ready to be used for
+ * calling raid_rec().
+ *
+ * @n Number of integers currently in the vector.
+ * @v Vector of integers already sorted.
+ *   It must have extra space for the new elemet at the end.
+ * @i Value to insert.
+ */
+void raid_insert(int n, int *v, int i);
+
+#endif
+
diff --git a/include/linux/raid/raid.h b/include/linux/raid/raid.h
new file mode 100644
index 0000000..ef61846
--- /dev/null
+++ b/include/linux/raid/raid.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_H
+#define __RAID_H
+
+#ifdef __KERNEL__ /* to build the user mode test */
+#include <linux/types.h> /* for size_t */
+#endif
+
+/**
+ * Maximum number of parity disks supported.
+ */
+#define RAID_PARITY_MAX 6
+
+/**
+ * Maximum number of data disks supported.
+ */
+#define RAID_DATA_MAX 251
+
+/**
+ * Computes the parity blocks.
+ *
+ * This function computes the specified number of parity blocks of the
+ * provided set of data blocks.
+ *
+ * Each parity block, will allow to recover on data block.
+ *
+ * @nd Number of data blocks.
+ * @np Number of parities blocks to compute.
+ * @size Size of the blocks pointed by @v. It must be a multipler of 64.
+ * @v Vector of pointers to the blocks of data and parity.
+ *   It has (@nd + @np) elements. The starting elements are the blocks for
+ *   data, following with the parity blocks.
+ *   Data blocks are only read and not modified. Parity blocks are written.
+ *   Each block has @size bytes.
+ */
+void raid_gen(int nd, int np, size_t size, void **v);
+
+/**
+ * Recovers failures in data and parity blocks.
+ *
+ * This function recovers all the data and parity blocks marked as bad
+ * in the @ir vector.
+ *
+ * Ensure to have @nr <= @np, otherwise recovering is not possible.
+ *
+ * The parities blocks used for recovering are automatically selected from
+ * the ones NOT present in the @ir vector.
+ *
+ * In case there are more parity blocks than needed to recover, the parities
+ * at lower indexes are used in the recovering, and the others are ignored.
+ *
+ * Note that no internal integrity check is done when recovering. If the
+ * provided parities are correct the resulting data will be also correct.
+ * If parities are wrong, also the resulting recovered data will be wrong.
+ * This happens even in the case you have more parities blocks than needed,
+ * and some form of integrity verification is possible.
+ *
+ * @nr Number of failed data and parity blocks to recover.
+ * @ir[] Vector of @nr indexes of the data and parity blocks to recover.
+ *   The indexes start from 0. They must be in order.
+ *   The first parity is represented with value @nd, the second with value
+ *   @nd + 1, just like positions in the @v vector.
+ * @nd Number of data blocks.
+ * @np Number of parity blocks.
+ * @size Size of the blocks pointed by @v. It must be a multipler of 64.
+ * @v Vector of pointers to the blocks of data and parity.
+ *   It has (@nd + @np) elements. The starting elements are the blocks
+ *   for data, following with the parity blocks.
+ *   Each block has @size bytes.
+ */
+void raid_rec(int nr, int *ir, int nd, int np, size_t size, void **v);
+
+#endif
+
diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98b..9865862 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -10,6 +10,23 @@ menu "Library routines"
 config RAID6_PQ
 	tristate
 
+config RAID_CAUCHY
+	tristate "RAID Cauchy functions"
+	help
+	  This option enables the RAID parity library based on a Cauchy matrix
+	  that supports up to six parities, and it's compatible with the
+	  existing RAID6 support.
+
+	  This library provides optimized functions for triple parity and
+	  beyond for architectures with SSSE3 support.
+
+	  The new interface is defined in the linux/raid/raid.h file.
+	  If the RAID6 module is enabled, it's used to maintain the same
+	  performance level for RAID5 and RAID6 in all the architectures
+	  when using the new interface.
+
+	  Module will be called raid_cauchy.
+
 config BITREVERSE
 	tristate
 
diff --git a/lib/Makefile b/lib/Makefile
index a459c31..8b76716 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -79,6 +79,7 @@ obj-$(CONFIG_LZ4HC_COMPRESS) += lz4/
 obj-$(CONFIG_LZ4_DECOMPRESS) += lz4/
 obj-$(CONFIG_XZ_DEC) += xz/
 obj-$(CONFIG_RAID6_PQ) += raid6/
+obj-$(CONFIG_RAID_CAUCHY) += raid/
 
 lib-$(CONFIG_DECOMPRESS_GZIP) += decompress_inflate.o
 lib-$(CONFIG_DECOMPRESS_BZIP2) += decompress_bunzip2.o
diff --git a/lib/raid/.gitignore b/lib/raid/.gitignore
new file mode 100644
index 0000000..aef693b
--- /dev/null
+++ b/lib/raid/.gitignore
@@ -0,0 +1,3 @@
+mktables
+tables.c
+
diff --git a/lib/raid/Makefile b/lib/raid/Makefile
new file mode 100644
index 0000000..9eedf4a
--- /dev/null
+++ b/lib/raid/Makefile
@@ -0,0 +1,14 @@
+obj-$(CONFIG_RAID_CAUCHY) += raid_cauchy.o
+
+raid_cauchy-y	+= module.o raid.o tables.o int.o helper.o
+
+raid_cauchy-$(CONFIG_X86) += x86.o
+
+hostprogs-y	+= mktables
+
+quiet_cmd_mktable = TABLE   $@
+      cmd_mktable = $(obj)/mktables > $@ || ( rm -f $@ && exit 1 )
+
+targets += tables.c
+$(obj)/tables.c: $(obj)/mktables FORCE
+	$(call if_changed,mktable)
diff --git a/lib/raid/cpu.h b/lib/raid/cpu.h
new file mode 100644
index 0000000..4295aa7
--- /dev/null
+++ b/lib/raid/cpu.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_CPU_H
+#define __RAID_CPU_H
+
+#ifdef CONFIG_X86
+static inline int raid_cpu_has_sse2(void)
+{
+	return boot_cpu_has(X86_FEATURE_XMM2);
+}
+
+static inline int raid_cpu_has_ssse3(void)
+{
+	/* checks also for SSE2 */
+	/* likely it's implicit, but just to be sure */
+	return boot_cpu_has(X86_FEATURE_XMM2)
+		&& boot_cpu_has(X86_FEATURE_SSSE3);
+}
+
+static inline int raid_cpu_has_avx2(void)
+{
+	/* checks also for SSE2 and SSSE3 */
+	/* likely it's implicit, but just to be sure */
+	return boot_cpu_has(X86_FEATURE_XMM2)
+		&& boot_cpu_has(X86_FEATURE_SSSE3)
+		&& boot_cpu_has(X86_FEATURE_AVX)
+		&& boot_cpu_has(X86_FEATURE_AVX2);
+}
+#endif
+
+#endif
+
diff --git a/lib/raid/gf.h b/lib/raid/gf.h
new file mode 100644
index 0000000..f444e63
--- /dev/null
+++ b/lib/raid/gf.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_GF_H
+#define __RAID_GF_H
+
+/*
+ * Galois field operations.
+ *
+ * Basic range checks are implemented using BUG_ON().
+ */
+
+/*
+ * GF a*b.
+ */
+static __always_inline uint8_t mul(uint8_t a, uint8_t b)
+{
+	return gfmul[a][b];
+}
+
+/*
+ * GF 1/a.
+ * Not defined for a == 0.
+ */
+static __always_inline uint8_t inv(uint8_t v)
+{
+	BUG_ON(v == 0); /* division by zero */
+
+	return gfinv[v];
+}
+
+/*
+ * GF 2^a.
+ */
+static __always_inline uint8_t pow2(int v)
+{
+	BUG_ON(v < 0 || v > 254); /* invalid exponent */
+
+	return gfexp[v];
+}
+
+/*
+ * Gets the multiplication table for a specified value.
+ */
+static __always_inline const uint8_t *table(uint8_t v)
+{
+	return gfmul[v];
+}
+
+/*
+ * Gets the generator matrix coefficient for parity 'p' and disk 'd'.
+ */
+static __always_inline uint8_t A(int p, int d)
+{
+	return gfgen[p][d];
+}
+
+/*
+ * Dereference as uint8_t
+ */
+#define v_8(p) (*(uint8_t *)&(p))
+
+/*
+ * Dereference as uint32_t
+ */
+#define v_32(p) (*(uint32_t *)&(p))
+
+/*
+ * Dereference as uint64_t
+ */
+#define v_64(p) (*(uint64_t *)&(p))
+
+/*
+ * Multiply each byte of a uint32 by 2 in the GF(2^8).
+ */
+static __always_inline uint32_t x2_32(uint32_t v)
+{
+	uint32_t mask = v & 0x80808080U;
+	mask = (mask << 1) - (mask >> 7);
+	v = (v << 1) & 0xfefefefeU;
+	v ^= mask & 0x1d1d1d1dU;
+	return v;
+}
+
+/*
+ * Multiply each byte of a uint64 by 2 in the GF(2^8).
+ */
+static __always_inline uint64_t x2_64(uint64_t v)
+{
+	uint64_t mask = v & 0x8080808080808080ULL;
+	mask = (mask << 1) - (mask >> 7);
+	v = (v << 1) & 0xfefefefefefefefeULL;
+	v ^= mask & 0x1d1d1d1d1d1d1d1dULL;
+	return v;
+}
+
+#endif
+
diff --git a/lib/raid/helper.c b/lib/raid/helper.c
new file mode 100644
index 0000000..03f7ecc
--- /dev/null
+++ b/lib/raid/helper.c
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+
+void raid_insert(int n, int *v, int i)
+{
+	/* we don't use binary search because this is intended */
+	/* for very small vectors and we want to optimize the case */
+	/* of elements inserted already in order */
+
+	/* insert at the end */
+	v[n] = i;
+
+	/* swap until in the correct position */
+	while (n > 0 && v[n-1] > v[n]) {
+		/* swap */
+		int t = v[n-1];
+		v[n-1] = v[n];
+		v[n] = t;
+
+		/* previous position */
+		--n;
+	}
+}
+EXPORT_SYMBOL_GPL(raid_insert);
+
diff --git a/lib/raid/int.c b/lib/raid/int.c
new file mode 100644
index 0000000..bd03b52
--- /dev/null
+++ b/lib/raid/int.c
@@ -0,0 +1,567 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+#include "gf.h"
+
+/*
+ * GEN1 (RAID5 with xor) 32bit C implementation
+ */
+void raid_gen1_int32(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	int d, l;
+	size_t i;
+
+	uint32_t p0;
+	uint32_t p1;
+
+	l = nd - 1;
+	p = v[nd];
+
+	for (i = 0; i < size; i += 8) {
+		p0 = v_32(v[l][i]);
+		p1 = v_32(v[l][i+4]);
+		for (d = l-1; d >= 0; --d) {
+			p0 ^= v_32(v[d][i]);
+			p1 ^= v_32(v[d][i+4]);
+		}
+		v_32(p[i]) = p0;
+		v_32(p[i+4]) = p1;
+	}
+}
+
+/*
+ * GEN1 (RAID5 with xor) 64bit C implementation
+ */
+void raid_gen1_int64(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	int d, l;
+	size_t i;
+
+	uint64_t p0;
+	uint64_t p1;
+
+	l = nd - 1;
+	p = v[nd];
+
+	for (i = 0; i < size; i += 16) {
+		p0 = v_64(v[l][i]);
+		p1 = v_64(v[l][i+8]);
+		for (d = l-1; d >= 0; --d) {
+			p0 ^= v_64(v[d][i]);
+			p1 ^= v_64(v[d][i+8]);
+		}
+		v_64(p[i]) = p0;
+		v_64(p[i+8]) = p1;
+	}
+}
+
+/*
+ * GEN2 (RAID6 with powers of 2) 32bit C implementation
+ */
+void raid_gen2_int32(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	int d, l;
+	size_t i;
+
+	uint32_t d0, q0, p0;
+	uint32_t d1, q1, p1;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+
+	for (i = 0; i < size; i += 8) {
+		q0 = p0 = v_32(v[l][i]);
+		q1 = p1 = v_32(v[l][i+4]);
+		for (d = l-1; d >= 0; --d) {
+			d0 = v_32(v[d][i]);
+			d1 = v_32(v[d][i+4]);
+
+			p0 ^= d0;
+			p1 ^= d1;
+
+			q0 = x2_32(q0);
+			q1 = x2_32(q1);
+
+			q0 ^= d0;
+			q1 ^= d1;
+		}
+		v_32(p[i]) = p0;
+		v_32(p[i+4]) = p1;
+		v_32(q[i]) = q0;
+		v_32(q[i+4]) = q1;
+	}
+}
+
+/*
+ * GEN2 (RAID6 with powers of 2) 64bit C implementation
+ */
+void raid_gen2_int64(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	int d, l;
+	size_t i;
+
+	uint64_t d0, q0, p0;
+	uint64_t d1, q1, p1;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+
+	for (i = 0; i < size; i += 16) {
+		q0 = p0 = v_64(v[l][i]);
+		q1 = p1 = v_64(v[l][i+8]);
+		for (d = l-1; d >= 0; --d) {
+			d0 = v_64(v[d][i]);
+			d1 = v_64(v[d][i+8]);
+
+			p0 ^= d0;
+			p1 ^= d1;
+
+			q0 = x2_64(q0);
+			q1 = x2_64(q1);
+
+			q0 ^= d0;
+			q1 ^= d1;
+		}
+		v_64(p[i]) = p0;
+		v_64(p[i+8]) = p1;
+		v_64(q[i]) = q0;
+		v_64(q[i+8]) = q1;
+	}
+}
+
+/*
+ * GEN3 (triple parity with Cauchy matrix) 8bit C implementation
+ *
+ * Note that instead of a generic multiplication table, likely resulting
+ * in multiple cache misses, a precomputed table could be used.
+ * But this is only a kind of reference function, and we are not really
+ * interested in speed.
+ */
+void raid_gen3_int8(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	int d, l;
+	size_t i;
+
+	uint8_t d0, r0, q0, p0;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+
+	for (i = 0; i < size; i += 1) {
+		p0 = q0 = r0 = 0;
+		for (d = l; d > 0; --d) {
+			d0 = v_8(v[d][i]);
+
+			p0 ^= d0;
+			q0 ^= gfmul[d0][gfgen[1][d]];
+			r0 ^= gfmul[d0][gfgen[2][d]];
+		}
+
+		/* first disk with all coefficients at 1 */
+		d0 = v_8(v[0][i]);
+
+		p0 ^= d0;
+		q0 ^= d0;
+		r0 ^= d0;
+
+		v_8(p[i]) = p0;
+		v_8(q[i]) = q0;
+		v_8(r[i]) = r0;
+	}
+}
+
+/*
+ * GEN4 (quad parity with Cauchy matrix) 8bit C implementation
+ *
+ * Note that instead of a generic multiplication table, likely resulting
+ * in multiple cache misses, a precomputed table could be used.
+ * But this is only a kind of reference function, and we are not really
+ * interested in speed.
+ */
+void raid_gen4_int8(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	int d, l;
+	size_t i;
+
+	uint8_t d0, s0, r0, q0, p0;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+
+	for (i = 0; i < size; i += 1) {
+		p0 = q0 = r0 = s0 = 0;
+		for (d = l; d > 0; --d) {
+			d0 = v_8(v[d][i]);
+
+			p0 ^= d0;
+			q0 ^= gfmul[d0][gfgen[1][d]];
+			r0 ^= gfmul[d0][gfgen[2][d]];
+			s0 ^= gfmul[d0][gfgen[3][d]];
+		}
+
+		/* first disk with all coefficients at 1 */
+		d0 = v_8(v[0][i]);
+
+		p0 ^= d0;
+		q0 ^= d0;
+		r0 ^= d0;
+		s0 ^= d0;
+
+		v_8(p[i]) = p0;
+		v_8(q[i]) = q0;
+		v_8(r[i]) = r0;
+		v_8(s[i]) = s0;
+	}
+}
+
+/*
+ * GEN5 (penta parity with Cauchy matrix) 8bit C implementation
+ *
+ * Note that instead of a generic multiplication table, likely resulting
+ * in multiple cache misses, a precomputed table could be used.
+ * But this is only a kind of reference function, and we are not really
+ * interested in speed.
+ */
+void raid_gen5_int8(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	uint8_t *t;
+	int d, l;
+	size_t i;
+
+	uint8_t d0, t0, s0, r0, q0, p0;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+	t = v[nd+4];
+
+	for (i = 0; i < size; i += 1) {
+		p0 = q0 = r0 = s0 = t0 = 0;
+		for (d = l; d > 0; --d) {
+			d0 = v_8(v[d][i]);
+
+			p0 ^= d0;
+			q0 ^= gfmul[d0][gfgen[1][d]];
+			r0 ^= gfmul[d0][gfgen[2][d]];
+			s0 ^= gfmul[d0][gfgen[3][d]];
+			t0 ^= gfmul[d0][gfgen[4][d]];
+		}
+
+		/* first disk with all coefficients at 1 */
+		d0 = v_8(v[0][i]);
+
+		p0 ^= d0;
+		q0 ^= d0;
+		r0 ^= d0;
+		s0 ^= d0;
+		t0 ^= d0;
+
+		v_8(p[i]) = p0;
+		v_8(q[i]) = q0;
+		v_8(r[i]) = r0;
+		v_8(s[i]) = s0;
+		v_8(t[i]) = t0;
+	}
+}
+
+/*
+ * GEN6 (hexa parity with Cauchy matrix) 8bit C implementation
+ *
+ * Note that instead of a generic multiplication table, likely resulting
+ * in multiple cache misses, a precomputed table could be used.
+ * But this is only a kind of reference function, and we are not really
+ * interested in speed.
+ */
+void raid_gen6_int8(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	uint8_t *t;
+	uint8_t *u;
+	int d, l;
+	size_t i;
+
+	uint8_t d0, u0, t0, s0, r0, q0, p0;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+	t = v[nd+4];
+	u = v[nd+5];
+
+	for (i = 0; i < size; i += 1) {
+		p0 = q0 = r0 = s0 = t0 = u0 = 0;
+		for (d = l; d > 0; --d) {
+			d0 = v_8(v[d][i]);
+
+			p0 ^= d0;
+			q0 ^= gfmul[d0][gfgen[1][d]];
+			r0 ^= gfmul[d0][gfgen[2][d]];
+			s0 ^= gfmul[d0][gfgen[3][d]];
+			t0 ^= gfmul[d0][gfgen[4][d]];
+			u0 ^= gfmul[d0][gfgen[5][d]];
+		}
+
+		/* first disk with all coefficients at 1 */
+		d0 = v_8(v[0][i]);
+
+		p0 ^= d0;
+		q0 ^= d0;
+		r0 ^= d0;
+		s0 ^= d0;
+		t0 ^= d0;
+		u0 ^= d0;
+
+		v_8(p[i]) = p0;
+		v_8(q[i]) = q0;
+		v_8(r[i]) = r0;
+		v_8(s[i]) = s0;
+		v_8(t[i]) = t0;
+		v_8(u[i]) = u0;
+	}
+}
+
+/*
+ * Recover failure of one data block at index id[0] using parity at index
+ * ip[0] for any RAID level.
+ *
+ * Starting from the equation:
+ *
+ * Pd = A[ip[0],id[0]] * Dx
+ *
+ * and solving we get:
+ *
+ * Dx = A[ip[0],id[0]]^-1 * Pd
+ */
+void raid_rec1_int8(int nr, int *id, int *ip, int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *pa;
+	const uint8_t *T;
+	uint8_t G;
+	uint8_t V;
+	size_t i;
+
+	(void)nr; /* unused, it's always 1 */
+
+	/* if it's RAID5 uses the faster function */
+	if (ip[0] == 0) {
+		raid_rec1of1(id, nd, size, vv);
+		return;
+	}
+
+#ifdef RAID_USE_RAID6_PQ
+	/* if it's RAID6 recovering with Q uses the faster function */
+	if (ip[0] == 1) {
+		raid6_datap_recov(nd + 2, size, id[0], vv);
+		return;
+	}
+#endif
+
+	/* setup the coefficients matrix */
+	G = A(ip[0], id[0]);
+
+	/* invert it to solve the system of linear equations */
+	V = inv(G);
+
+	/* get multiplication tables */
+	T = table(V);
+
+	/* compute delta parity */
+	raid_delta_gen(1, id, ip, nd, size, vv);
+
+	p = v[nd+ip[0]];
+	pa = v[id[0]];
+
+	for (i = 0; i < size; ++i) {
+		/* delta */
+		uint8_t Pd = p[i] ^ pa[i];
+
+		/* reconstruct */
+		pa[i] = T[Pd];
+	}
+}
+
+/*
+ * Recover failure of two data blocks at indexes id[0],id[1] using parity at
+ * indexes ip[0],ip[1] for any RAID level.
+ *
+ * Starting from the equations:
+ *
+ * Pd = A[ip[0],id[0]] * Dx + A[ip[0],id[1]] * Dy
+ * Qd = A[ip[1],id[0]] * Dx + A[ip[1],id[1]] * Dy
+ *
+ * we solve inverting the coefficients matrix.
+ */
+void raid_rec2_int8(int nr, int *id, int *ip, int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *pa;
+	uint8_t *q;
+	uint8_t *qa;
+	const int N = 2;
+	const uint8_t *T[N][N];
+	uint8_t G[N*N];
+	uint8_t V[N*N];
+	size_t i;
+	int j, k;
+
+	(void)nr; /* unused, it's always 2 */
+
+	/* if it's RAID6 recovering with P and Q uses the faster function */
+	if (ip[0] == 0 && ip[1] == 1) {
+#ifdef RAID_USE_RAID6_PQ
+		raid6_2data_recov(nd + 2, size, id[0], id[1], vv);
+#else
+		raid_rec2of2_int8(id, ip, nd, size, vv);
+#endif
+		return;
+	}
+
+	/* setup the coefficients matrix */
+	for (j = 0; j < N; ++j)
+		for (k = 0; k < N; ++k)
+			G[j*N+k] = A(ip[j], id[k]);
+
+	/* invert it to solve the system of linear equations */
+	raid_invert(G, V, N);
+
+	/* get multiplication tables */
+	for (j = 0; j < N; ++j)
+		for (k = 0; k < N; ++k)
+			T[j][k] = table(V[j*N+k]);
+
+	/* compute delta parity */
+	raid_delta_gen(2, id, ip, nd, size, vv);
+
+	p = v[nd+ip[0]];
+	q = v[nd+ip[1]];
+	pa = v[id[0]];
+	qa = v[id[1]];
+
+	for (i = 0; i < size; ++i) {
+		/* delta */
+		uint8_t Pd = p[i] ^ pa[i];
+		uint8_t Qd = q[i] ^ qa[i];
+
+		/* reconstruct */
+		pa[i] = T[0][0][Pd] ^ T[0][1][Qd];
+		qa[i] = T[1][0][Pd] ^ T[1][1][Qd];
+	}
+}
+
+/*
+ * Recover failure of N data blocks at indexes id[N] using parity at indexes
+ * ip[N] for any RAID level.
+ *
+ * Starting from the N equations, with 0<=i<N :
+ *
+ * PD[i] = sum(A[ip[i],id[j]] * D[i]) 0<=j<N
+ *
+ * we solve inverting the coefficients matrix.
+ *
+ * Note that referring at previous equations you have:
+ * PD[0] = Pd, PD[1] = Qd, PD[2] = Rd, ...
+ * D[0] = Dx, D[1] = Dy, D[2] = Dz, ...
+ */
+void raid_recX_int8(int nr, int *id, int *ip, int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p[RAID_PARITY_MAX];
+	uint8_t *pa[RAID_PARITY_MAX];
+	const uint8_t *T[RAID_PARITY_MAX][RAID_PARITY_MAX];
+	uint8_t G[RAID_PARITY_MAX*RAID_PARITY_MAX];
+	uint8_t V[RAID_PARITY_MAX*RAID_PARITY_MAX];
+	size_t i;
+	int j, k;
+
+	/* setup the coefficients matrix */
+	for (j = 0; j < nr; ++j)
+		for (k = 0; k < nr; ++k)
+			G[j*nr+k] = A(ip[j], id[k]);
+
+	/* invert it to solve the system of linear equations */
+	raid_invert(G, V, nr);
+
+	/* get multiplication tables */
+	for (j = 0; j < nr; ++j)
+		for (k = 0; k < nr; ++k)
+			T[j][k] = table(V[j*nr+k]);
+
+	/* compute delta parity */
+	raid_delta_gen(nr, id, ip, nd, size, vv);
+
+	for (j = 0; j < nr; ++j) {
+		p[j] = v[nd+ip[j]];
+		pa[j] = v[id[j]];
+	}
+
+	for (i = 0; i < size; ++i) {
+		uint8_t PD[RAID_PARITY_MAX];
+
+		/* delta */
+		for (j = 0; j < nr; ++j)
+			PD[j] = p[j][i] ^ pa[j][i];
+
+		/* reconstruct */
+		for (j = 0; j < nr; ++j) {
+			uint8_t b = 0;
+			for (k = 0; k < nr; ++k)
+				b ^= T[j][k][PD[k]];
+			pa[j][i] = b;
+		}
+	}
+}
+
diff --git a/lib/raid/internal.h b/lib/raid/internal.h
new file mode 100644
index 0000000..b3bf9e5
--- /dev/null
+++ b/lib/raid/internal.h
@@ -0,0 +1,148 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_INTERNAL_H
+#define __RAID_INTERNAL_H
+
+/*
+ * Includes anything required for compatibility.
+ */
+#ifdef __KERNEL__ /* to build the user mode test */
+
+#include <linux/module.h>
+#include <linux/kconfig.h> /* for IS_* macros */
+#include <linux/export.h> /* for EXPORT_SYMBOL/EXPORT_SYMBOL_GPL */
+#include <linux/bug.h> /* for BUG_ON */
+#include <linux/gfp.h> /* for __get_free_pages */
+
+#ifdef CONFIG_X86
+#include <asm/i387.h> /* for kernel_fpu_begin/end() */
+#endif
+
+/* if we can use the XOR_BLOCKS library */
+#if IS_BUILTIN(CONFIG_XOR_BLOCKS) \
+	|| (IS_MODULE(CONFIG_XOR_BLOCKS) && IS_MODULE(CONFIG_RAID6_CAUCHY))
+#define RAID_USE_XOR_BLOCKS 1
+#include <linux/raid/xor.h> /* for xor_blocks */
+#endif
+
+/* if we can use the RAID6 library */
+#if IS_BUILTIN(CONFIG_RAID6_PQ) \
+	|| (IS_MODULE(CONFIG_RAID6_PQ) && IS_MODULE(CONFIG_RAID6_CAUCHY))
+#define RAID_USE_RAID6_PQ 1
+#include <linux/raid/pq.h> /* for tables/functions */
+#endif
+
+#else /* __KERNEL__ */
+#include "test/usermode.h"
+#endif /* __KERNEL__ */
+
+/*
+ * Includes the headers.
+ */
+#include <linux/raid/raid.h>
+#include <linux/raid/helper.h>
+
+/*
+ * Internal functions.
+ *
+ * These are intented to provide access for testing.
+ */
+void raid_init(void);
+int raid_selftest(void);
+int raid_speedtest(int displacement);
+void raid_gen_ref(int nd, int np, size_t size, void **vv);
+void raid_invert(uint8_t *M, uint8_t *V, int n);
+void raid_delta_gen(int nr, int *id, int *ip, int nd, size_t size, void **v);
+void raid_rec1of1(int *id, int nd, size_t size, void **v);
+void raid_rec2of2_int8(int *id, int *ip, int nd, size_t size, void **vv);
+void raid_gen1_xorblocks(int nd, size_t size, void **v);
+void raid_gen1_int32(int nd, size_t size, void **vv);
+void raid_gen1_int64(int nd, size_t size, void **vv);
+void raid_gen1_sse2(int nd, size_t size, void **vv);
+void raid_gen2_raid6(int nd, size_t size, void **vv);
+void raid_gen2_int32(int nd, size_t size, void **vv);
+void raid_gen2_int64(int nd, size_t size, void **vv);
+void raid_gen2_sse2(int nd, size_t size, void **vv);
+void raid_gen2_sse2ext(int nd, size_t size, void **vv);
+void raid_gen3_int8(int nd, size_t size, void **vv);
+void raid_gen3_ssse3(int nd, size_t size, void **vv);
+void raid_gen3_ssse3ext(int nd, size_t size, void **vv);
+void raid_gen4_int8(int nd, size_t size, void **vv);
+void raid_gen4_ssse3(int nd, size_t size, void **vv);
+void raid_gen4_ssse3ext(int nd, size_t size, void **vv);
+void raid_gen5_int8(int nd, size_t size, void **vv);
+void raid_gen5_ssse3(int nd, size_t size, void **vv);
+void raid_gen5_ssse3ext(int nd, size_t size, void **vv);
+void raid_gen6_int8(int nd, size_t size, void **vv);
+void raid_gen6_ssse3(int nd, size_t size, void **vv);
+void raid_gen6_ssse3ext(int nd, size_t size, void **vv);
+void raid_rec1_int8(int nr, int *id, int *ip, int nd, size_t size, void **vv);
+void raid_rec2_int8(int nr, int *id, int *ip, int nd, size_t size, void **vv);
+void raid_recX_int8(int nr, int *id, int *ip, int nd, size_t size, void **vv);
+void raid_rec1_ssse3(int nr, int *id, int *ip, int nd, size_t size, void **vv);
+void raid_rec2_ssse3(int nr, int *id, int *ip, int nd, size_t size, void **vv);
+void raid_recX_ssse3(int nr, int *id, int *ip, int nd, size_t size, void **vv);
+
+/*
+ * Internal forwarders.
+ */
+extern void (*raid_gen_ptr[RAID_PARITY_MAX])(
+	int nd, size_t size, void **vv);
+extern void (*raid_rec_ptr[RAID_PARITY_MAX])(
+	int nr, int *id, int *ip, int nd, size_t size, void **vv);
+
+/*
+ * Tables.
+ *
+ * Uses RAID6 tables if available, otherwise the ones in tables.c.
+ */
+#ifdef RAID_USE_RAID6_PQ
+#define gfmul raid6_gfmul
+#define gfinv raid6_gfinv
+#define gfexp raid6_gfexp
+#else
+extern const uint8_t raid_gfmul[256][256] __aligned(256);
+extern const uint8_t raid_gfexp[256] __aligned(256);
+extern const uint8_t raid_gfinv[256] __aligned(256);
+#define gfmul raid_gfmul
+#define gfexp raid_gfexp
+#define gfinv raid_gfinv
+#endif
+
+extern const uint8_t raid_gfcauchy[6][256] __aligned(256);
+extern const uint8_t raid_gfcauchypshufb[251][4][2][16] __aligned(256);
+extern const uint8_t raid_gfmulpshufb[256][2][16] __aligned(256);
+#define gfgen raid_gfcauchy
+#define gfgenpshufb raid_gfcauchypshufb
+#define gfmulpshufb raid_gfmulpshufb
+
+/*
+ * Assembler blocks.
+ */
+#ifdef CONFIG_X86
+static __always_inline void raid_asm_begin(void)
+{
+	kernel_fpu_begin();
+}
+
+static __always_inline void raid_asm_end(void)
+{
+	asm volatile("sfence" : : : "memory");
+	kernel_fpu_end();
+}
+#endif
+
+#endif
+
diff --git a/lib/raid/mktables.c b/lib/raid/mktables.c
new file mode 100644
index 0000000..9c8e0e0
--- /dev/null
+++ b/lib/raid/mktables.c
@@ -0,0 +1,338 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <stdio.h>
+#include <stdint.h>
+
+/**
+ * Multiplication in GF(2^8).
+ */
+static uint8_t gfmul(uint8_t a, uint8_t b)
+{
+	uint8_t v;
+
+	v = 0;
+	while (b)  {
+		if ((b & 1) != 0)
+			v ^= a;
+
+		if ((a & 0x80) != 0) {
+			a <<= 1;
+			a ^= 0x1d;
+		} else {
+			a <<= 1;
+		}
+
+		b >>= 1;
+	}
+
+	return v;
+}
+
+/**
+ * Inversion table in GF(2^8).
+ */
+uint8_t gfinv[256];
+
+/**
+ * Number of parity.
+ * This is the number of rows of the generation matrix.
+ */
+#define PARITY 6
+
+/**
+ * Number of disks.
+ * This is the number of columns of the generation matrix.
+ */
+#define DISK (257-PARITY)
+
+/**
+ * Setup the Cauchy matrix used to generate the parity.
+ */
+static void set_cauchy(uint8_t *matrix)
+{
+	int i, j;
+	uint8_t inv_x, y;
+
+	/*
+	 * First row is formed by all 1.
+	 *
+	 * This is an Extended Cauchy matrix built from a Cauchy matrix
+	 * adding the first row of all 1.
+	 */
+	for (i = 0; i < DISK; ++i)
+		matrix[0*DISK+i] = 1;
+
+	/*
+	 * Second row is formed by power of 2^i.
+	 *
+	 * This is the first row of the Cauchy matrix.
+	 *
+	 * Each element of the Cauchy matrix is in the form 1/(xi+yj)
+	 * where all xi, and yj must be different.
+	 *
+	 * Choosing xi = 2^-i and y0 = 0, we obtain for the first row:
+	 *
+	 * 1/(xi+y0) = 1/(2^-i + 0) = 2^i
+	 *
+	 * with 2^-i != 0 for any i
+	 */
+	inv_x = 1;
+	for (i = 0; i < DISK; ++i) {
+		matrix[1*DISK+i] = inv_x;
+		inv_x = gfmul(2, inv_x);
+	}
+
+	/*
+	 * Next rows of the Cauchy matrix.
+	 *
+	 * Continue forming the Cauchy matrix with yj = 2^j obtaining :
+	 *
+	 * 1/(xi+yj) = 1/(2^-i + 2^j)
+	 *
+	 * with xi != yj for any i,j with i>=0,j>=1,i+j<255
+	 */
+	y = 2;
+	for (j = 0; j < PARITY-2; ++j) {
+		inv_x = 1;
+		for (i = 0; i < DISK; ++i) {
+			uint8_t x = gfinv[inv_x];
+			matrix[(j+2)*DISK+i] = gfinv[y ^ x];
+			inv_x = gfmul(2, inv_x);
+		}
+
+		y = gfmul(2, y);
+	}
+
+	/*
+	 * Adjusts the matrix multipling each row for
+	 * the inverse of the first element in the row.
+	 *
+	 * This operation doesn't invalidate the property that all the square
+	 * submatrices are not singular.
+	 */
+	for (j = 0; j < PARITY-2; ++j) {
+		uint8_t f = gfinv[matrix[(j+2)*DISK]];
+
+		for (i = 0; i < DISK; ++i)
+			matrix[(j+2)*DISK+i] = gfmul(matrix[(j+2)*DISK+i], f);
+	}
+}
+
+/**
+ * Next power of 2.
+ */
+static unsigned np(unsigned v)
+{
+	--v;
+	v |= v >> 1;
+	v |= v >> 2;
+	v |= v >> 4;
+	v |= v >> 8;
+	v |= v >> 16;
+	++v;
+
+	return v;
+}
+
+int main(void)
+{
+	uint8_t v;
+	int i, j, k, p;
+	uint8_t matrix[PARITY * 256];
+
+	printf("/*\n");
+	printf(" * Copyright (C) 2013 Andrea Mazzoleni\n");
+	printf(" *\n");
+	printf(" * This program is free software: you can redistribute it and/or modify\n");
+	printf(" * it under the terms of the GNU General Public License as published by\n");
+	printf(" * the Free Software Foundation, either version 2 of the License, or\n");
+	printf(" * (at your option) any later version.\n");
+	printf(" *\n");
+	printf(" * This program is distributed in the hope that it will be useful,\n");
+	printf(" * but WITHOUT ANY WARRANTY; without even the implied warranty of\n");
+	printf(" * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n");
+	printf(" * GNU General Public License for more details.\n");
+	printf(" */\n");
+	printf("\n");
+
+	printf("#include \"internal.h\"\n");
+	printf("\n");
+
+	/* a*b */
+	printf("#ifndef RAID_USE_RAID6_PQ\n");
+	printf("const uint8_t __aligned(256) raid_gfmul[256][256] =\n");
+	printf("{\n");
+	for (i = 0; i < 256; ++i) {
+		printf("\t{\n");
+		for (j = 0; j < 256; ++j) {
+			if (j % 8 == 0)
+				printf("\t\t");
+			v = gfmul(i, j);
+			if (v == 1)
+				gfinv[i] = j;
+			printf("0x%02x,", (unsigned)v);
+			if (j % 8 == 7)
+				printf("\n");
+			else
+				printf(" ");
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+	printf("EXPORT_SYMBOL(raid_gfmul);\n");
+	printf("#endif\n");
+	printf("\n");
+
+	/* 2^a */
+	printf("#ifndef RAID_USE_RAID6_PQ\n");
+	printf("const uint8_t __aligned(256) raid_gfexp[256] =\n");
+	printf("{\n");
+	v = 1;
+	for (i = 0; i < 256; ++i) {
+		if (i % 8 == 0)
+			printf("\t");
+		printf("0x%02x,", v);
+		v = gfmul(v, 2);
+		if (i % 8 == 7)
+			printf("\n");
+		else
+			printf(" ");
+	}
+	printf("};\n");
+	printf("EXPORT_SYMBOL(raid_gfexp);\n");
+	printf("#endif\n");
+	printf("\n");
+
+	/* 1/a */
+	printf("#ifndef RAID_USE_RAID6_PQ\n");
+	printf("const uint8_t __aligned(256) raid_gfinv[256] =\n");
+	printf("{\n");
+	printf("\t/* note that the first element is not significative */\n");
+	for (i = 0; i < 256; ++i) {
+		if (i % 8 == 0)
+			printf("\t");
+		if (i == 0)
+			v = 0;
+		else
+			v = gfinv[i];
+		printf("0x%02x,", v);
+		if (i % 8 == 7)
+			printf("\n");
+		else
+			printf(" ");
+	}
+	printf("};\n");
+	printf("EXPORT_SYMBOL(raid_gfinv);\n");
+	printf("#endif\n");
+	printf("\n");
+
+	/* cauchy matrix */
+	set_cauchy(matrix);
+
+	printf("/**\n");
+	printf(" * Cauchy matrix used to generate parity.\n");
+	printf(" * This matrix is valid for up to %u parity with %u data disks.\n", PARITY, DISK);
+	printf(" *\n");
+	for (p = 0; p < PARITY; ++p) {
+		printf(" * ");
+		for (i = 0; i < DISK; ++i)
+			printf("%02x ", matrix[p*DISK+i]);
+		printf("\n");
+	}
+	printf(" */\n");
+	printf("const uint8_t __aligned(256) raid_gfcauchy[%u][256] =\n", PARITY);
+	printf("{\n");
+	for (p = 0; p < PARITY; ++p) {
+		printf("\t{\n");
+		for (i = 0; i < DISK; ++i) {
+			if (i % 8 == 0)
+				printf("\t\t");
+			printf("0x%02x,", matrix[p*DISK+i]);
+			if (i % 8 == 7)
+				printf("\n");
+			else
+				printf(" ");
+		}
+		printf("\n\t},\n");
+	}
+	printf("};\n");
+	printf("EXPORT_SYMBOL(raid_gfcauchy);\n");
+	printf("\n");
+
+	printf("#ifdef CONFIG_X86\n");
+	printf("/**\n");
+	printf(" * PSHUFB tables for the Cauchy matrix.\n");
+	printf(" *\n");
+	printf(" * Indexes are [DISK][PARITY - 2][LH].\n");
+	printf(" * Where DISK is from 0 to %u, PARITY from 2 to %u, LH from 0 to 1.\n", DISK - 1, PARITY - 1);
+	printf(" */\n");
+	printf("const uint8_t __aligned(256) raid_gfcauchypshufb[%u][%u][2][16] =\n", DISK, np(PARITY - 2));
+	printf("{\n");
+	for (i = 0; i < DISK; ++i) {
+		printf("\t{\n");
+		for (p = 2; p < PARITY; ++p) {
+			printf("\t\t{\n");
+			for (j = 0; j < 2; ++j) {
+				printf("\t\t\t{ ");
+				for (k = 0; k < 16; ++k) {
+					v = gfmul(matrix[p*DISK+i], k);
+					if (j == 1)
+						v = gfmul(v, 16);
+					printf("0x%02x", (unsigned)v);
+					if (k != 15)
+						printf(", ");
+				}
+				printf(" },\n");
+			}
+			printf("\t\t},\n");
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+	printf("EXPORT_SYMBOL(raid_gfcauchypshufb);\n");
+	printf("#endif\n\n");
+
+	printf("#ifdef CONFIG_X86\n");
+	printf("/**\n");
+	printf(" * PSHUFB tables for generic multiplication.\n");
+	printf(" *\n");
+	printf(" * Indexes are [MULTIPLER][LH].\n");
+	printf(" * Where MULTIPLER is from 0 to 255, LH from 0 to 1.\n");
+	printf(" */\n");
+	printf("const uint8_t __aligned(256) raid_gfmulpshufb[256][2][16] =\n");
+	printf("{\n");
+	for (i = 0; i < 256; ++i) {
+		printf("\t{\n");
+		for (j = 0; j < 2; ++j) {
+			printf("\t\t{ ");
+			for (k = 0; k < 16; ++k) {
+				v = gfmul(i, k);
+				if (j == 1)
+					v = gfmul(v, 16);
+				printf("0x%02x", (unsigned)v);
+				if (k != 15)
+					printf(", ");
+			}
+			printf(" },\n");
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+	printf("EXPORT_SYMBOL(raid_gfmulpshufb);\n");
+	printf("#endif\n\n");
+
+	return 0;
+}
+
diff --git a/lib/raid/module.c b/lib/raid/module.c
new file mode 100644
index 0000000..8d45ab4
--- /dev/null
+++ b/lib/raid/module.c
@@ -0,0 +1,458 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+#include "cpu.h"
+
+/*
+ * Initializes and selects the best algorithm.
+ */
+void raid_init(void)
+{
+	/* setup parity functions */
+	if (sizeof(void *) == 8) {
+		raid_gen_ptr[0] = raid_gen1_int64;
+		raid_gen_ptr[1] = raid_gen2_int64;
+	} else {
+		raid_gen_ptr[0] = raid_gen1_int32;
+		raid_gen_ptr[1] = raid_gen2_int32;
+	}
+	raid_gen_ptr[2] = raid_gen3_int8;
+	raid_gen_ptr[3] = raid_gen4_int8;
+	raid_gen_ptr[4] = raid_gen5_int8;
+	raid_gen_ptr[5] = raid_gen6_int8;
+
+	/* if XOR_BLOCKS is present, use it */
+#ifdef RAID_USE_XOR_BLOCKS
+	raid_gen_ptr[0] = raid_gen1_xorblocks;
+#endif
+	/* if RAID6 is present, use it */
+#ifdef RAID_USE_RAID6_PQ
+	raid_gen_ptr[1] = raid_gen2_raid6;
+#endif
+
+	/* optimized SSE2 functions */
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		raid_gen_ptr[0] = raid_gen1_sse2;
+		raid_gen_ptr[1] = raid_gen2_sse2;
+#ifdef CONFIG_X86_64
+		raid_gen_ptr[1] = raid_gen2_sse2ext;
+#endif
+	}
+#endif
+
+	/* optimized SSSE3 functions */
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		raid_gen_ptr[2] = raid_gen3_ssse3;
+		raid_gen_ptr[3] = raid_gen4_ssse3;
+		raid_gen_ptr[4] = raid_gen5_ssse3;
+		raid_gen_ptr[5] = raid_gen6_ssse3;
+#ifdef CONFIG_X86_64
+		raid_gen_ptr[2] = raid_gen3_ssse3ext;
+		raid_gen_ptr[3] = raid_gen4_ssse3ext;
+		raid_gen_ptr[4] = raid_gen5_ssse3ext;
+		raid_gen_ptr[5] = raid_gen6_ssse3ext;
+#endif
+	}
+#endif
+
+	/* setup recovering functions */
+	raid_rec_ptr[0] = raid_rec1_int8;
+	raid_rec_ptr[1] = raid_rec2_int8;
+	raid_rec_ptr[2] = raid_recX_int8;
+	raid_rec_ptr[3] = raid_recX_int8;
+	raid_rec_ptr[4] = raid_recX_int8;
+	raid_rec_ptr[5] = raid_recX_int8;
+
+	/* optimized SSSE3 functions */
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		raid_rec_ptr[0] = raid_rec1_ssse3;
+		raid_rec_ptr[1] = raid_rec2_ssse3;
+		raid_rec_ptr[2] = raid_recX_ssse3;
+		raid_rec_ptr[3] = raid_recX_ssse3;
+		raid_rec_ptr[4] = raid_recX_ssse3;
+		raid_rec_ptr[5] = raid_recX_ssse3;
+	}
+#endif
+}
+
+/*
+ * Refence parity computation.
+ */
+void raid_gen_ref(int nd, int np, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	size_t i;
+
+	for (i = 0; i < size; ++i) {
+		uint8_t p[RAID_PARITY_MAX];
+		int j, d;
+
+		for (j = 0; j < np; ++j)
+			p[j] = 0;
+
+		for (d = 0; d < nd; ++d) {
+			uint8_t b = v[d][i];
+
+			for (j = 0; j < np; ++j)
+				p[j] ^= gfmul[b][gfgen[j][d]];
+		}
+
+		for (j = 0; j < np; ++j)
+			v[nd + j][i] = p[j];
+	}
+}
+
+/*
+ * Size of the blocks to test.
+ */
+#define TEST_SIZE PAGE_SIZE
+
+/*
+ * Number of data blocks to test.
+ */
+#define TEST_COUNT (65536 / TEST_SIZE)
+
+/*
+ * Period for the speed test.
+ */
+#ifdef __KERNEL__ /* to build the user mode test */
+#define TEST_PERIOD 16
+#else
+#ifdef COVERAGE
+#define TEST_PERIOD 100 /* fast in coverage test */
+#else
+#define TEST_PERIOD 512 /* more time in usermode */
+#endif
+#endif
+
+/*
+ * Parity generation test.
+ */
+static int raid_test_par(int nd, int np, size_t size, void **v, void **ref)
+{
+	int i;
+	void *t[TEST_COUNT + RAID_PARITY_MAX];
+
+	/* setup data */
+	for (i = 0; i < nd; ++i)
+		t[i] = ref[i];
+
+	/* setup parity */
+	for (i = 0; i < np; ++i)
+		t[nd+i] = v[nd+i];
+
+	raid_gen(nd, np, size, t);
+
+	/* compare parity */
+	for (i = 0; i < np; ++i) {
+		if (memcmp(t[nd+i], ref[nd+i], size) != 0) {
+			pr_err("raid: Self test failed!\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Recovering test.
+ */
+static int raid_test_rec(int nr, int *ir, int nd, int np, size_t size, void **v, void **ref)
+{
+	int i, j;
+	void *t[TEST_COUNT + RAID_PARITY_MAX];
+
+	/* setup vector */
+	for (i = 0, j = 0; i < nd+np; ++i) {
+		if (j < nr && ir[j] == i) {
+			/* this block has to be recovered */
+			t[i] = v[i];
+			++j;
+		} else {
+			/* this block is left unchanged */
+			t[i] = ref[i];
+		}
+	}
+
+	raid_rec(nr, ir, nd, np, size, t);
+
+	/* compare all data and parity */
+	for (i = 0; i < nd+np; ++i) {
+		if (t[i] != ref[i] && memcmp(t[i], ref[i], size) != 0) {
+			pr_err("raid: Self test failed!\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Basic functionality self test.
+ */
+int raid_selftest(void)
+{
+	const int nd = TEST_COUNT;
+	const size_t size = TEST_SIZE;
+	const int nv = nd + RAID_PARITY_MAX * 2;
+	uint8_t *pages;
+	void *v[nd + RAID_PARITY_MAX * 2];
+	void *ref[nd + RAID_PARITY_MAX];
+	int ir[RAID_PARITY_MAX];
+	int i, np;
+	int ret = 0;
+
+	/* ensure to have enough space for data */
+	BUG_ON(nd * size > 65536);
+
+	/* allocates pages for data and parity */
+	pages = alloc_pages_exact(nv * size, GFP_KERNEL);
+	if (!pages) {
+		pr_err("raid: No memory available.\n");
+		return -ENOMEM;
+	}
+
+	/* setup working vector */
+	for (i = 0; i < nv; ++i)
+		v[i] = pages + size * i;
+
+	/* use the multiplication table as data */
+	for (i = 0; i < nd; ++i)
+		ref[i] = ((uint8_t *)gfmul) + size * i;
+
+	/* setup reference parity */
+	for (i = 0; i < RAID_PARITY_MAX; ++i)
+		ref[nd+i] = v[nd+RAID_PARITY_MAX+i];
+
+	/* compute reference parity */
+	raid_gen_ref(nd, RAID_PARITY_MAX, size, ref);
+
+	/* test for each parity level */
+	for (np = 1; np <= RAID_PARITY_MAX; ++np) {
+		/* test parity generation */
+		ret = raid_test_par(nd, np, size, v, ref);
+		if (ret != 0)
+			goto bail;
+
+		/* test recovering with full broken data disks */
+		for (i = 0; i < np; ++i)
+			ir[i] = nd - np + i;
+
+		ret = raid_test_rec(np, ir, nd, np, size, v, ref);
+		if (ret != 0)
+			goto bail;
+
+		/* test recovering with half broken data and leading parity */
+		for (i = 0; i < np / 2; ++i)
+			ir[i] = i;
+
+		for (i = 0; i < (np + 1) / 2; ++i)
+			ir[np / 2 + i] = nd + i;
+
+		ret = raid_test_rec(np, ir, nd, np, size, v, ref);
+		if (ret != 0)
+			goto bail;
+
+		/* test recovering with half broken data and ending parity */
+		for (i = 0; i < np / 2; ++i)
+			ir[i] = i;
+
+		for (i = 0; i < (np + 1) / 2; ++i)
+			ir[np / 2 + i] = nd + np - (np + 1) / 2 + i;
+
+		ret = raid_test_rec(np, ir, nd, np, size, v, ref);
+		if (ret != 0)
+			goto bail;
+	}
+
+bail:
+	free_pages_exact(pages, nv * size);
+
+	return ret;
+}
+
+/*
+ * Test the speed of a single function.
+ */
+static void raid_test_speed(
+	void (*func)(int nd, size_t size, void **vv),
+	const char *tag, const char *imp,
+	void **vv)
+{
+	unsigned count;
+	unsigned long j_start, j_stop;
+	unsigned long speed;
+
+	count = 0;
+
+	preempt_disable();
+
+	j_start = jiffies;
+	while ((j_stop = jiffies) == j_start)
+		cpu_relax();
+
+	j_stop += TEST_PERIOD;
+	while (time_before(jiffies, j_stop)) {
+#ifdef __KERNEL__
+		func(TEST_COUNT, TEST_SIZE, vv);
+		++count;
+#else
+		/* in usermode reading jiffies is a slow operation */
+		unsigned i;
+		for (i = 0; i < 16; ++i) {
+			func(TEST_COUNT, TEST_SIZE, vv);
+			++count;
+		}
+#endif
+	}
+
+	preempt_enable();
+
+	speed = count * HZ / (TEST_PERIOD * 1024 * 1024 / (TEST_SIZE * TEST_COUNT));
+
+	pr_info("raid: %-4s %-6s %5ld MB/s\n", tag, imp, speed);
+}
+
+/*
+ * Basic speed test.
+ *
+ * @displacement Memory displacement to use to improve cache coloring.
+ *   Use 0 for not optimized memory layout.
+ */
+int raid_speedtest(int displacement)
+{
+	const int nd = TEST_COUNT;
+	const size_t size = TEST_SIZE;
+	const int nv = nd + RAID_PARITY_MAX;
+	uint8_t *pages;
+	void *v[nd + RAID_PARITY_MAX];
+	int i;
+
+	/* ensure to have enough space for data */
+	BUG_ON(nd * size > 65536);
+
+	/* allocates pages for parity */
+	pages = alloc_pages_exact(nv * (size + displacement), GFP_KERNEL);
+	if (!pages) {
+		pr_err("raid: No memory available.\n");
+		return -ENOMEM;
+	}
+
+	/* setup working vector */
+	for (i = 0; i < nv; ++i)
+		v[i] = pages + (size + displacement) * i;
+
+	/* if we use optimized memory layout */
+	if (displacement != 0) {
+		/* reverse the data buffers because they are accessed */
+		/* in reverse order */
+		for (i = 0; i < nd / 2; ++i) {
+			void *t = v[i];
+			v[i] = v[nd-1-i];
+			v[nd-1-i] = t;
+		}
+	}
+
+	/* use the multiplication table as data */
+	for (i = 0; i < nd; ++i)
+		memcpy(v[i], ((uint8_t *)gfmul) + size * i, size);
+
+	raid_test_speed(raid_gen1_int32, "gen1", "int32", v);
+	raid_test_speed(raid_gen2_int32, "gen2", "int32", v);
+	raid_test_speed(raid_gen1_int64, "gen1", "int64", v);
+	raid_test_speed(raid_gen2_int64, "gen2", "int64", v);
+	raid_test_speed(raid_gen3_int8, "gen3", "int8", v);
+	raid_test_speed(raid_gen4_int8, "gen4", "int8", v);
+	raid_test_speed(raid_gen5_int8, "gen5", "int8", v);
+	raid_test_speed(raid_gen6_int8, "gen6", "int8", v);
+#ifdef RAID_USE_XOR_BLOCKS
+	raid_test_speed(raid_gen1_xorblocks, "gen1", "xor", v);
+#endif
+#ifdef RAID_USE_RAID6_PQ
+	raid_test_speed(raid_gen2_raid6, "gen2", "raid6", v);
+#endif
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		raid_test_speed(raid_gen1_sse2, "gen1", "sse2", v);
+		raid_test_speed(raid_gen2_sse2, "gen2", "sse2", v);
+	}
+	if (raid_cpu_has_ssse3()) {
+		raid_test_speed(raid_gen3_ssse3, "gen3", "ssse3", v);
+		raid_test_speed(raid_gen4_ssse3, "gen4", "ssse3", v);
+		raid_test_speed(raid_gen5_ssse3, "gen5", "ssse3", v);
+		raid_test_speed(raid_gen6_ssse3, "gen6", "ssse3", v);
+#ifdef CONFIG_X86_64
+		raid_test_speed(raid_gen2_sse2ext, "gen2", "sse2e", v);
+		raid_test_speed(raid_gen3_ssse3ext, "gen3", "ssse3e", v);
+		raid_test_speed(raid_gen4_ssse3ext, "gen4", "ssse3e", v);
+		raid_test_speed(raid_gen5_ssse3ext, "gen5", "ssse3e", v);
+		raid_test_speed(raid_gen6_ssse3ext, "gen6", "ssse3e", v);
+#endif
+	}
+#endif
+
+	free_pages_exact(pages, nv * (size + displacement));
+
+	return 0;
+}
+
+#ifdef __KERNEL__ /* to build the user mode test */
+static int speedtest;
+
+int __init raid_cauchy_init(void)
+{
+	int ret;
+
+	raid_init();
+
+#ifdef RAID_USE_XOR_BLOCKS
+	pr_info("raid: Using xor_blocks\n");
+#endif
+#ifdef RAID_USE_RAID6_PQ
+	pr_info("raid: Using raid6\n");
+#endif
+
+	ret = raid_selftest();
+	if (ret != 0)
+		return ret;
+
+	pr_info("raid: Self test passed\n");
+
+	if (speedtest) {
+		pr_info("raid: Speed test\n");
+		raid_speedtest(0);
+		pr_info("raid: Speed test with optimized memory layout\n");
+		raid_speedtest(64); /* 64 is the typical cache line size */
+	}
+
+	return 0;
+}
+
+static void raid_cauchy_exit(void)
+{
+}
+
+subsys_initcall(raid_cauchy_init);
+module_exit(raid_cauchy_exit);
+module_param(speedtest, int, 0);
+MODULE_PARM_DESC(speedtest, "Runs a startup speed test");
+MODULE_AUTHOR("Andrea Mazzoleni <amadvance@gmail.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RAID Cauchy functions");
+#endif
+
diff --git a/lib/raid/raid.c b/lib/raid/raid.c
new file mode 100644
index 0000000..e1b1660
--- /dev/null
+++ b/lib/raid/raid.c
@@ -0,0 +1,492 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+#include "gf.h"
+
+/*
+ * This is a RAID implementation working in the Galois Field GF(2^8) with
+ * the primitive polynomial x^8 + x^4 + x^3 + x^2 + 1 (285 decimal), and
+ * supporting up to six parity levels.
+ *
+ * For RAID5 and RAID6 it works as as described in the H. Peter Anvin's
+ * paper "The mathematics of RAID-6" [1]. Please refer to this paper for a
+ * complete explanation.
+ *
+ * To support triple parity, it was first evaluated and then dropped, an
+ * extension of the same approach, with additional parity coefficients set
+ * as powers of 2^-1, with equations:
+ *
+ * P = sum(Di)
+ * Q = sum(2^i * Di)
+ * R = sum(2^-i * Di) with 0<=i<N
+ *
+ * This approach works well for triple parity and it's very efficient,
+ * because we can implement very fast parallel multiplications and
+ * divisions by 2 in GF(2^8).
+ *
+ * It's also similar at the approach used by ZFS RAIDZ3, with the
+ * difference that ZFS uses powers of 4 instead of 2^-1.
+ *
+ * Unfortunately it doesn't work beyond triple parity, because whatever
+ * value we choose to generate the power coefficients to compute other
+ * parities, the resulting equations are not solvable for some
+ * combinations of missing disks.
+ *
+ * This is expected, because the Vandermonde matrix used to compute the
+ * parity has no guarantee to have all submatrices not singular
+ * [2, Chap 11, Problem 7] and this is a requirement to have
+ * a MDS (Maximum Distance Separable) code [2, Chap 11, Theorem 8].
+ *
+ * To overcome this limitation, we use a Cauchy matrix [3][4] to compute
+ * the parity. A Cauchy matrix has the property to have all the square
+ * submatrices not singular, resulting in always solvable equations,
+ * for any combination of missing disks.
+ *
+ * The problem of this approach is that it requires the use of
+ * generic multiplications, and not only by 2 or 2^-1, potentially
+ * affecting badly the performance.
+ *
+ * Hopefully there is a method to implement parallel multiplications
+ * using SSSE3 instructions [1][5]. Method competitive with the
+ * computation of triple parity using power coefficients.
+ *
+ * Another important property of the Cauchy matrix is that we can setup
+ * the first two rows with coeffients equal at the RAID5 and RAID6 approach
+ * decribed, resulting in a compatible extension, and requiring SSSE3
+ * instructions only if triple parity or beyond is used.
+ *
+ * The matrix is also adjusted, multipling each row by a constant factor
+ * to make the first column of all 1, to optimize the computation for
+ * the first disk.
+ *
+ * This results in the matrix A[row,col] defined as:
+ *
+ * 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01...
+ * 01 02 04 08 10 20 40 80 1d 3a 74 e8 cd 87 13 26 4c 98 2d 5a b4 75...
+ * 01 f5 d2 c4 9a 71 f1 7f fc 87 c1 c6 19 2f 40 55 3d ba 53 04 9c 61...
+ * 01 bb a6 d7 c7 07 ce 82 4a 2f a5 9b b6 60 f1 ad e7 f4 06 d2 df 2e...
+ * 01 97 7f 9c 7c 18 bd a2 58 1a da 74 70 a3 e5 47 29 07 f5 80 23 e9...
+ * 01 2b 3f cf 73 2c d6 ed cb 74 15 78 8a c1 17 c9 89 68 21 ab 76 3b...
+ *
+ * This matrix supports 6 level of parity, one for each row, for up to 251
+ * data disks, one for each column, with all the 377,342,351,231 square
+ * submatrices not singular, verified also with brute-force.
+ *
+ * This matrix can be extended to support any number of parities, just
+ * adding additional rows, and removing one column for each new row.
+ * (see mktables.c for more details in how the matrix is generated)
+ *
+ * In details, parity is computed as:
+ *
+ * P = sum(Di)
+ * Q = sum(2^i *  Di)
+ * R = sum(A[2,i] * Di)
+ * S = sum(A[3,i] * Di)
+ * T = sum(A[4,i] * Di)
+ * U = sum(A[5,i] * Di) with 0<=i<N
+ *
+ * To recover from a failure of six disks at indexes x,y,z,h,v,w,
+ * with 0<=x<y<z<h<v<w<N, we compute the parity of the available N-6
+ * disks as:
+ *
+ * Pa = sum(Di)
+ * Qa = sum(2^i * Di)
+ * Ra = sum(A[2,i] * Di)
+ * Sa = sum(A[3,i] * Di)
+ * Ta = sum(A[4,i] * Di)
+ * Ua = sum(A[5,i] * Di) with 0<=i<N,i!=x,i!=y,i!=z,i!=h,i!=v,i!=w.
+ *
+ * And if we define:
+ *
+ * Pd = Pa + P
+ * Qd = Qa + Q
+ * Rd = Ra + R
+ * Sd = Sa + S
+ * Td = Ta + T
+ * Ud = Ua + U
+ *
+ * we can sum these two sets of equations, obtaining:
+ *
+ * Pd =          Dx +          Dy +          Dz +          Dh +          Dv +          Dw
+ * Qd =    2^x * Dx +    2^y * Dy +    2^z * Dz +    2^h * Dh +    2^v * Dv +    2^w * Dw
+ * Rd = A[2,x] * Dx + A[2,y] * Dy + A[2,z] * Dz + A[2,h] * Dh + A[2,v] * Dv + A[2,w] * Dw
+ * Sd = A[3,x] * Dx + A[3,y] * Dy + A[3,z] * Dz + A[3,h] * Dh + A[3,v] * Dv + A[3,w] * Dw
+ * Td = A[4,x] * Dx + A[4,y] * Dy + A[4,z] * Dz + A[4,h] * Dh + A[4,v] * Dv + A[4,w] * Dw
+ * Ud = A[5,x] * Dx + A[5,y] * Dy + A[5,z] * Dz + A[5,h] * Dh + A[5,v] * Dv + A[5,w] * Dw
+ *
+ * A linear system always solvable because the coefficients matrix is
+ * always not singular due the properties of the matrix A[].
+ *
+ * Resulting speed in x64, with 16 data disks, using a stripe of 4 KiB,
+ * for a Core i7-3740QM CPU @ 2.7GHz is:
+ *
+ *           int8   int32   int64    sse2   sse2e   ssse3  ssse3e
+ *   gen1           11469   21579   44743
+ *   gen2            3474    6176   17930   20435
+ *   gen3     850                                    7908    9069
+ *   gen4     647                                    6357    7159
+ *   gen5     527                                    5041    5412
+ *   gen6     432                                    4094    4470
+ *
+ * Values are in MiB/s of data processed, not counting generated parity.
+ *
+ * References:
+ * [1] Anvin, "The mathematics of RAID-6", 2004
+ * [2] MacWilliams, Sloane, "The Theory of Error-Correcting Codes", 1977
+ * [3] Blomer, "An XOR-Based Erasure-Resilient Coding Scheme", 1995
+ * [4] Roth, "Introduction to Coding Theory", 2006
+ * [5] Plank, "Screaming Fast Galois Field Arithmetic Using Intel SIMD Instructions", 2013
+ */
+
+/**
+ * Buffer filled with 0 used in recovering.
+ */
+uint8_t raid_zero_block[PAGE_SIZE] __aligned(256);
+
+#ifdef RAID_USE_XOR_BLOCKS
+/*
+ * PAR1 (RAID5 with xor) implementation using the kernel xor_blocks()
+ * function.
+ */
+void raid_gen1_xorblocks(int nd, size_t size, void **v)
+{
+	int i;
+
+	/* copy the first block */
+	memcpy(v[nd], v[0], size);
+
+	i = 1;
+	while (i < nd) {
+		int run = nd - i;
+
+		/* xor_blocks supports no more than MAX_XOR_BLOCKS blocks */
+		if (run > MAX_XOR_BLOCKS)
+			run = MAX_XOR_BLOCKS;
+
+		xor_blocks(run, size, v[nd], v + i);
+
+		i += run;
+	}
+}
+#endif
+
+#ifdef RAID_USE_RAID6_PQ
+/**
+ * PAR2 (RAID6 with powers of 2) implementation using raid6 library.
+ */
+void raid_gen2_raid6(int nd, size_t size, void **vv)
+{
+	raid6_call.gen_syndrome(nd + 2, size, vv);
+}
+#endif
+
+/*
+ * Forwarders for parity computation.
+ *
+ * These functions compute the parity blocks from the provided data.
+ *
+ * The number of parities to compute is implicit in the position in the
+ * forwarder vector. Position at index #i, computes (#i+1) parities.
+ *
+ * @nd Number of data blocks
+ * @size Size of the blocks pointed by @v. It must be a multipler of 64.
+ * @v Vector of pointers to the blocks of data and parity.
+ *   It has (@nd + #parities) elements. The starting elements are the blocks for
+ *   data, following with the parity blocks.
+ *   Each block has @size bytes.
+ */
+void (*raid_gen_ptr[RAID_PARITY_MAX])(int nd, size_t size, void **v);
+
+void raid_gen(int nd, int np, size_t size, void **v)
+{
+	BUG_ON(np < 1 || np > RAID_PARITY_MAX);
+	BUG_ON(size % 64 != 0);
+
+	raid_gen_ptr[np - 1](nd, size, v);
+}
+EXPORT_SYMBOL_GPL(raid_gen);
+
+/**
+ * Inverts the square matrix M of size nxn into V.
+ *
+ * This is not a general matrix inversion because we assume the matrix M
+ * to have all the square submatrix not singular.
+ * We use Gauss elimination to invert.
+ *
+ * @M Matrix to invert with @n rows and @n columns.
+ * @V Destination matrix where the result is put.
+ * @n Number of rows and columns of the matrix.
+ */
+void raid_invert(uint8_t *M, uint8_t *V, int n)
+{
+	int i, j, k;
+
+	/* set the identity matrix in V */
+	for (i = 0; i < n; ++i)
+		for (j = 0; j < n; ++j)
+			V[i*n+j] = i == j;
+
+	/* for each element in the diagonal */
+	for (k = 0; k < n; ++k) {
+		uint8_t f;
+
+		/* the diagonal element cannot be 0 because */
+		/* we are inverting matrices with all the square */
+		/* submatrices not singular */
+		BUG_ON(M[k*n+k] == 0);
+
+		/* make the diagonal element to be 1 */
+		f = inv(M[k*n+k]);
+		for (j = 0; j < n; ++j) {
+			M[k*n+j] = mul(f, M[k*n+j]);
+			V[k*n+j] = mul(f, V[k*n+j]);
+		}
+
+		/* make all the elements over and under the diagonal */
+		/* to be zero */
+		for (i = 0; i < n; ++i) {
+			if (i == k)
+				continue;
+			f = M[i*n+k];
+			for (j = 0; j < n; ++j) {
+				M[i*n+j] ^= mul(f, M[k*n+j]);
+				V[i*n+j] ^= mul(f, V[k*n+j]);
+			}
+		}
+	}
+}
+
+/**
+ * Computes the parity without the missing data blocks
+ * and store it in the buffers of such data blocks.
+ *
+ * This is the parity expressed as Pa,Qa,Ra,Sa,Ta,Ua
+ * in the equations.
+ *
+ * Note that all the other parities not in the ip[] vector
+ * are destroyed.
+ */
+void raid_delta_gen(int nr, int *id, int *ip, int nd, size_t size, void **v)
+{
+	void *p[RAID_PARITY_MAX];
+	void *pa[RAID_PARITY_MAX];
+	int i;
+
+	for (i = 0; i < nr; ++i) {
+		/* keep a copy of the parity buffer */
+		p[i] = v[nd+ip[i]];
+
+		/* buffer for missing data blocks */
+		pa[i] = v[id[i]];
+
+		/* set at zero the missing data blocks */
+		v[id[i]] = raid_zero_block;
+
+		/* compute the parity over the missing data blocks */
+		v[nd+ip[i]] = pa[i];
+	}
+
+	/* recompute the minimal parity required */
+	raid_gen(nd, ip[nr - 1] + 1, size, v);
+
+	for (i = 0; i < nr; ++i) {
+		/* restore disk buffers as before */
+		v[id[i]] = pa[i];
+
+		/* restore parity buffers as before */
+		v[nd+ip[i]] = p[i];
+	}
+}
+
+/**
+ * Recover failure of one data block for PAR1.
+ *
+ * Starting from the equation:
+ *
+ * Pd = Dx
+ *
+ * and solving we get:
+ *
+ * Dx = Pd
+ */
+void raid_rec1of1(int *id, int nd, size_t size, void **v)
+{
+	void *p;
+	void *pa;
+
+	/* for PAR1 we can directly compute the missing block */
+	/* and we don't need to use the zero buffer */
+	p = v[nd];
+	pa = v[id[0]];
+
+	/* use the parity as missing data block */
+	v[id[0]] = p;
+
+	/* compute the parity over the missing data block */
+	v[nd] = pa;
+
+	/* compute */
+	raid_gen(nd, 1, size, v);
+
+	/* restore as before */
+	v[id[0]] = pa;
+	v[nd] = p;
+}
+
+/**
+ * Recover failure of two data blocks for PAR2.
+ *
+ * Starting from the equations:
+ *
+ * Pd = Dx + Dy
+ * Qd = 2^id[0] * Dx + 2^id[1] * Dy
+ *
+ * and solving we get:
+ *
+ *               1                     2^(-id[0])
+ * Dy = ------------------- * Pd + ------------------- * Qd
+ *      2^(id[1]-id[0]) + 1        2^(id[1]-id[0]) + 1
+ *
+ * Dx = Dy + Pd
+ *
+ * with conditions:
+ *
+ * 2^id[0] != 0
+ * 2^(id[1]-id[0]) + 1 != 0
+ *
+ * That are always satisfied for any 0<=id[0]<id[1]<255.
+ */
+void raid_rec2of2_int8(int *id, int *ip, int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	size_t i;
+	uint8_t *p;
+	uint8_t *pa;
+	uint8_t *q;
+	uint8_t *qa;
+	const uint8_t *T[2];
+
+	/* get multiplication tables */
+	T[0] = table(inv(pow2(id[1]-id[0]) ^ 1));
+	T[1] = table(inv(pow2(id[0]) ^ pow2(id[1])));
+
+	/* compute delta parity */
+	raid_delta_gen(2, id, ip, nd, size, vv);
+
+	p = v[nd];
+	q = v[nd+1];
+	pa = v[id[0]];
+	qa = v[id[1]];
+
+	for (i = 0; i < size; ++i) {
+		/* delta */
+		uint8_t Pd = p[i] ^ pa[i];
+		uint8_t Qd = q[i] ^ qa[i];
+
+		/* reconstruct */
+		uint8_t Dy = T[0][Pd] ^ T[1][Qd];
+		uint8_t Dx = Pd ^ Dy;
+
+		/* set */
+		pa[i] = Dx;
+		qa[i] = Dy;
+	}
+}
+
+/*
+ * Forwarders for data recovery.
+ *
+ * These functions recover data blocks using the specified parity
+ * to recompute the missing data.
+ *
+ * Note that the format of vectors @id/@ip is different than raid_rec().
+ * For example, in the vector @ip the first parity is represented with the
+ * value 0 and not @nd.
+ *
+ * @nr Number of failed data blocks to recover.
+ * @id[] Vector of @nr indexes of the data blocks to recover.
+ *   The indexes start from 0. They must be in order.
+ * @ip[] Vector of @nr indexes of the parity blocks to use in the recovering.
+ *   The indexes start from 0. They must be in order.
+ * @nd Number of data blocks.
+ * @np Number of parity blocks.
+ * @size Size of the blocks pointed by @v. It must be a multipler of 64.
+ * @v Vector of pointers to the blocks of data and parity.
+ *   It has (@nd + @np) elements. The starting elements are the blocks
+ *   for data, following with the parity blocks.
+ *   Each block has @size bytes.
+ */
+void (*raid_rec_ptr[RAID_PARITY_MAX])(
+	int nr, int *id, int *ip, int nd, size_t size, void **vv);
+
+void raid_rec(int nr, int *ir, int nd, int np, size_t size, void **v)
+{
+	int nrd; /* number of data blocks to recover */
+	int nrp; /* number of parity blocks to recover */
+
+	/* enforce limits on size */
+	BUG_ON(size % 64 != 0);
+	BUG_ON(size > PAGE_SIZE);
+
+	/* enforce the order in the index vector */
+	BUG_ON(nr >= 2 && ir[0] > ir[1]);
+	BUG_ON(nr >= 3 && ir[1] > ir[2]);
+	BUG_ON(nr >= 4 && ir[2] > ir[3]);
+	BUG_ON(nr >= 5 && ir[3] > ir[4]);
+	BUG_ON(nr >= 6 && ir[4] > ir[5]);
+
+	/* counts the number of data blocks to recover */
+	nrd = 0;
+	while (nrd < nr && ir[nrd] < nd)
+		++nrd;
+
+	/* all the remaining are parity */
+	nrp = nr - nrd;
+
+	/* enforce basic sanity in arguments */
+	BUG_ON(nrd > nd);
+	BUG_ON(nrp > np);
+
+	/* ensure that we have enough parity to recover */
+	BUG_ON(nrd + nrp > np);
+
+	/* if failed data is present */
+	if (nrd != 0) {
+		int ip[RAID_PARITY_MAX];
+		int i, j, k;
+
+		/* setup the vector of parities to use */
+		for (i = 0, j = 0, k = 0; i < np; ++i) {
+			if (j < nrp && ir[nrd + j] == nd + i) {
+				/* this parity has to be recovered */
+				++j;
+			} else {
+				/* this parity is used for recovering */
+				ip[k] = i;
+				++k;
+			}
+		}
+
+		/* recover the nrd data blocks specified in ir[], */
+		/* using the first nrd parity in ip[] for recovering */
+		raid_rec_ptr[nrd - 1](nrd, ir, ip, nd, size, v);
+	}
+
+	/* recompute all the parities up to the last bad one */
+	if (nrp != 0)
+		raid_gen(nd, ir[nr - 1] - nd + 1, size, v);
+}
+EXPORT_SYMBOL_GPL(raid_rec);
+
diff --git a/lib/raid/test/Makefile b/lib/raid/test/Makefile
new file mode 100644
index 0000000..d19fe29
--- /dev/null
+++ b/lib/raid/test/Makefile
@@ -0,0 +1,72 @@
+#
+# Test programs for the RAID library
+#
+# selftest - Runs the same selftest and speedtest executed at the module startup.
+# fulltest - Runs a more extensive test that checks all the built-in functions.
+# speetest - Runs a more complete speed test.
+# invtest - Runs an extensive matrix inversion test of all the 377.342.351.231
+#           possible square submatrices of the Cauchy matrix used.
+# covtest - Runs a coverage test.
+#
+
+CC  = gcc
+CFLAGS = -I.. -I../../../include -Wall -Wextra -g
+ifeq ($(COVERAGE),)
+CFLAGS += -O2
+else
+CFLAGS += -O0 --coverage -DCOVERAGE=1
+endif
+LD = ld
+OBJS = raid.o int.o x86.o tables.o memory.o test.o helper.o module.o xor.o
+
+%.o: ../%.c
+	$(CC) $(CFLAGS) -c -o $@ $<
+
+all: fulltest speedtest selftest invtest
+
+fulltest: $(OBJS) fulltest.o
+	$(CC) $(CFLAGS) -o fulltest $^
+
+speedtest: $(OBJS) speedtest.o
+	$(CC) $(CFLAGS) -o speedtest $^
+
+selftest: $(OBJS) selftest.o
+	$(CC) $(CFLAGS) -o selftest $^
+
+invtest: $(OBJS) invtest.o
+	$(CC) $(CFLAGS) -o invtest $^
+
+mktables: mktables.o
+	$(CC) $(CFLAGS) -o mktables $^
+
+tables.c: mktables
+	./mktables > tables.c
+
+# Use this target to run a coverage test using lcov
+covtest:
+	$(MAKE) clean
+	$(MAKE) lcov_reset
+	$(MAKE) COVERAGE=1 all
+	./fulltest
+	./selftest
+	./speedtest
+	$(MAKE) lcov_capture
+	$(MAKE) lcov_html
+
+lcov_reset:
+	lcov --directory . -z
+	rm -f lcov.info
+
+lcov_capture:
+	lcov --directory . --capture --rc lcov_branch_coverage=1 -o lcov.info
+
+lcov_html:
+	rm -rf coverage
+	mkdir coverage
+	genhtml --branch-coverage -o coverage lcov.info
+
+clean:
+	rm -f *.o mktables.c mktables tables.c fulltest speedtest selftest invtest
+	rm -f *.gcda *.gcno lcov.info
+	rm -rf coverage
+
diff --git a/lib/raid/test/combo.h b/lib/raid/test/combo.h
new file mode 100644
index 0000000..30ae7b7
--- /dev/null
+++ b/lib/raid/test/combo.h
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_COMBO_H
+#define __RAID_COMBO_H
+
+#include <assert.h>
+
+/**
+ * Get the first permutation with repetition of r of n elements.
+ *
+ * Typical use is with permutation_next() in the form :
+ *
+ * int i[R];
+ * permutation_first(R, N, i);
+ * do {
+ *    code using i[0], i[1], ..., i[R-1]
+ * } while (permutation_next(R, N, i));
+ *
+ * It's equivalent at the code :
+ *
+ * for(i[0]=0;i[0]<N;++i[0])
+ *     for(i[1]=0;i[1]<N;++i[1])
+ *        ...
+ *            for(i[R-2]=0;i[R-2]<N;++i[R-2])
+ *                for(i[R-1]=0;i[R-1]<N;++i[R-1])
+ *                    code using i[0], i[1], ..., i[R-1]
+ */
+static __always_inline void permutation_first(int r, int n, int *c)
+{
+	int i;
+
+	(void)n; /* unused, but kept for clarity */
+	assert(0 < r && r <= n);
+
+	for (i = 0; i < r; ++i)
+		c[i] = 0;
+}
+
+/**
+ * Get the next permutation with repetition of r of n elements.
+ * Return ==0 when finished.
+ */
+static __always_inline int permutation_next(int r, int n, int *c)
+{
+	int i = r - 1; /* present position */
+
+recurse:
+	/* next element at position i */
+	++c[i];
+
+	/* if the position has reached the max */
+	if (c[i] >= n) {
+
+		/* if we are at the first level, we have finished */
+		if (i == 0)
+			return 0;
+
+		/* increase the previous position */
+		--i;
+		goto recurse;
+	}
+
+	++i;
+
+	/* initialize all the next positions, if any */
+	while (i < r) {
+		c[i] = 0;
+		++i;
+	}
+
+	return 1;
+}
+
+/**
+ * Get the first combination without repetition of r of n elements.
+ *
+ * Typical use is with combination_next() in the form :
+ *
+ * int i[R];
+ * combination_first(R, N, i);
+ * do {
+ *    code using i[0], i[1], ..., i[R-1]
+ * } while (combination_next(R, N, i));
+ *
+ * It's equivalent at the code :
+ *
+ * for(i[0]=0;i[0]<N-(R-1);++i[0])
+ *     for(i[1]=i[0]+1;i[1]<N-(R-2);++i[1])
+ *        ...
+ *            for(i[R-2]=i[R-3]+1;i[R-2]<N-1;++i[R-2])
+ *                for(i[R-1]=i[R-2]+1;i[R-1]<N;++i[R-1])
+ *                    code using i[0], i[1], ..., i[R-1]
+ */
+static __always_inline void combination_first(int r, int n, int *c)
+{
+	int i;
+
+	(void)n; /* unused, but kept for clarity */
+	assert(0 < r && r <= n);
+
+	for (i = 0; i < r; ++i)
+		c[i] = i;
+}
+
+/**
+ * Get the next combination without repetition of r of n elements.
+ * Return ==0 when finished.
+ */
+static __always_inline int combination_next(int r, int n, int *c)
+{
+	int i = r - 1; /* present position */
+	int h = n; /* high limit for this position */
+
+recurse:
+	/* next element at position i */
+	++c[i];
+
+	/* if the position has reached the max */
+	if (c[i] >= h) {
+
+		/* if we are at the first level, we have finished */
+		if (i == 0)
+			return 0;
+
+		/* increase the previous position */
+		--i;
+		--h;
+		goto recurse;
+	}
+
+	++i;
+
+	/* initialize all the next positions, if any */
+	while (i < r) {
+		/* each position start at the next value of the previous one */
+		c[i] = c[i-1] + 1;
+		++i;
+	}
+
+	return 1;
+}
+#endif
+
diff --git a/lib/raid/test/fulltest.c b/lib/raid/test/fulltest.c
new file mode 100644
index 0000000..0923ff4
--- /dev/null
+++ b/lib/raid/test/fulltest.c
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Full sanity test for the RAID library */
+
+#include "internal.h"
+#include "test.h"
+#include "cpu.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+
+/*
+ * Size of the blocks to test.
+ */
+#define TEST_SIZE 256
+
+/**
+ * Number of disks in the long parity test.
+ */
+#ifdef COVERAGE
+#define TEST_COUNT 10
+#else
+#define TEST_COUNT 32
+#endif
+
+int main(void)
+{
+	printf("Full sanity test for the RAID Cauchy library\n\n");
+
+	raid_init();
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2())
+		printf("Including x86 SSE2 functions\n");
+	if (raid_cpu_has_ssse3())
+		printf("Including x86 SSSE3 functions\n");
+#endif
+#ifdef CONFIG_X86_64
+	printf("Including x64 extended SSE register set\n");
+#endif
+
+	printf("\nPlease wait about 60 seconds...\n\n");
+
+	printf("Test insertion...\n");
+	if (raid_test_insert() != 0)
+		goto bail;
+	printf("Test combinations/permutations...\n");
+	if (raid_test_combo() != 0)
+		goto bail;
+	printf("Test parity generation with %u data disks...\n", RAID_DATA_MAX);
+	if (raid_test_par(RAID_DATA_MAX, TEST_SIZE) != 0)
+		goto bail;
+	printf("Test parity generation with 1 data disk...\n");
+	if (raid_test_par(1, TEST_SIZE) != 0)
+		goto bail;
+	printf("Test recovering with all combinations of %u data and 6 parity blocks...\n", TEST_COUNT);
+	if (raid_test_rec(TEST_COUNT, TEST_SIZE) != 0)
+		goto bail;
+
+	printf("OK\n");
+	return 0;
+
+bail:
+	printf("FAILED!\n");
+	exit(EXIT_FAILURE);
+}
+
diff --git a/lib/raid/test/invtest.c b/lib/raid/test/invtest.c
new file mode 100644
index 0000000..180a052
--- /dev/null
+++ b/lib/raid/test/invtest.c
@@ -0,0 +1,172 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Matrix inversion test for the RAID library */
+
+#include "internal.h"
+
+#include "combo.h"
+#include "gf.h"
+
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+/**
+ * Like raid_invert() but optimized to only check if the matrix is
+ * invertible.
+ */
+static __always_inline int raid_invert_fast(uint8_t *M, int n)
+{
+	int i, j, k;
+
+	/* for each element in the diagonal */
+	for (k = 0; k < n; ++k) {
+		uint8_t f;
+
+		/* the diagonal element cannot be 0 because */
+		/* we are inverting matrices with all the square */
+		/* submatrices not singular */
+		if (M[k*n+k] == 0)
+			return -1;
+
+		/* make the diagonal element to be 1 */
+		f = inv(M[k*n+k]);
+		for (j = 0; j < n; ++j)
+			M[k*n+j] = mul(f, M[k*n+j]);
+
+		/* make all the elements over and under the diagonal */
+		/* to be zero */
+		for (i = 0; i < n; ++i) {
+			if (i == k)
+				continue;
+			f = M[i*n+k];
+			for (j = 0; j < n; ++j)
+				M[i*n+j] ^= mul(f, M[k*n+j]);
+		}
+	}
+
+	return 0;
+}
+
+#define TEST_REFRESH (4*1024*1024)
+
+/**
+ * Precomputed number of square submatrices of size nr.
+ *
+ * It's bc(np,nr) * bc(nd,nr)
+ *
+ * With 1<=nr<=6 and bc(n, r) == binomial coefficient of (n over r).
+ */
+long long EXPECTED[RAID_PARITY_MAX] = {
+	1506LL,
+	470625LL,
+	52082500LL,
+	2421836250LL,
+	47855484300LL,
+	327012476050LL
+};
+
+static __always_inline int test_sub_matrix(int nr, long long *total)
+{
+	uint8_t M[RAID_PARITY_MAX * RAID_PARITY_MAX];
+	int np = RAID_PARITY_MAX;
+	int nd = RAID_DATA_MAX;
+	int ip[RAID_PARITY_MAX];
+	int id[RAID_DATA_MAX];
+	long long count;
+	long long expected;
+
+	printf("\n%ux%u\n", nr, nr);
+
+	count = 0;
+	expected = EXPECTED[nr - 1];
+
+	/* all combinations (nr of nd) disks */
+	combination_first(nr, nd, id);
+	do {
+		/* all combinations (nr of np) parities */
+		combination_first(nr, np, ip);
+		do {
+			int i, j;
+
+			/* setup the submatrix */
+			for (i = 0; i < nr; ++i)
+				for (j = 0; j < nr; ++j)
+					M[i*nr+j] = gfgen[ip[i]][id[j]];
+
+			/* invert */
+			if (raid_invert_fast(M, nr) != 0)
+				return -1;
+
+			if (++count % TEST_REFRESH == 0) {
+				printf("\r%.3f %%", count * (double)100 / expected);
+				fflush(stdout);
+			}
+		} while (combination_next(nr, np, ip));
+	} while (combination_next(nr, nd, id));
+
+	if (count != expected)
+		return -1;
+
+	printf("\rTested %lld matrix\n", count);
+
+	*total += count;
+
+	return 0;
+}
+
+int test_all_sub_matrix(void)
+{
+	long long total;
+
+	printf("Invert all square submatrices of the %dx%d Cauchy matrix\n",
+		RAID_PARITY_MAX, RAID_DATA_MAX);
+
+	printf("\nPlease wait about 2 days...\n");
+
+	total = 0;
+
+	/* force inlining of everything */
+	if (test_sub_matrix(1, &total) != 0)
+		return -1;
+	if (test_sub_matrix(2, &total) != 0)
+		return -1;
+	if (test_sub_matrix(3, &total) != 0)
+		return -1;
+	if (test_sub_matrix(4, &total) != 0)
+		return -1;
+	if (test_sub_matrix(5, &total) != 0)
+		return -1;
+	if (test_sub_matrix(6, &total) != 0)
+		return -1;
+
+	printf("\nTested in total %lld matrix\n", total);
+
+	return 0;
+}
+
+int main(void)
+{
+	printf("Matrix inversion test for the RAID Cauchy library\n\n");
+
+	if (test_all_sub_matrix() != 0) {
+		printf("FAILED!\n");
+		exit(EXIT_FAILURE);
+	}
+	printf("OK\n");
+
+	return 0;
+}
+
diff --git a/lib/raid/test/memory.c b/lib/raid/test/memory.c
new file mode 100644
index 0000000..6807ee4
--- /dev/null
+++ b/lib/raid/test/memory.c
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+#include "memory.h"
+
+void *raid_malloc_align(size_t size, void **freeptr)
+{
+	unsigned char *ptr;
+	uintptr_t offset;
+
+	ptr = malloc(size + RAID_MALLOC_ALIGN);
+	if (!ptr)
+		return 0;
+
+	*freeptr = ptr;
+
+	offset = ((uintptr_t)ptr) % RAID_MALLOC_ALIGN;
+
+	if (offset != 0)
+		ptr += RAID_MALLOC_ALIGN - offset;
+
+	return ptr;
+}
+
+void **raid_malloc_vector(int nd, int n, size_t size, void **freeptr)
+{
+	void **v;
+	unsigned char *va;
+	int i;
+
+	v = malloc(n * sizeof(void *));
+	if (!v)
+		return 0;
+
+	va = raid_malloc_align(n * (size + RAID_MALLOC_DISPLACEMENT), freeptr);
+	if (!va) {
+		free(v);
+		return 0;
+	}
+
+	for (i = 0; i < n; ++i) {
+		v[i] = va;
+		va += size + RAID_MALLOC_DISPLACEMENT;
+	}
+
+	/* reverse order of the data blocks */
+	/* because they are usually accessed from the last one */
+	for (i = 0; i < nd/2; ++i) {
+		void *ptr = v[i];
+		v[i] = v[nd - 1 - i];
+		v[nd - 1 - i] = ptr;
+	}
+
+	return v;
+}
+
+void raid_mrand_vector(int n, size_t size, void **vv)
+{
+	unsigned char **v = (unsigned char **)vv;
+	int i;
+	size_t j;
+
+	for (i = 0; i < n; ++i)
+		for (j = 0; j < size; ++j)
+			v[i][j] = rand();
+}
+
diff --git a/lib/raid/test/memory.h b/lib/raid/test/memory.h
new file mode 100644
index 0000000..44f4b15
--- /dev/null
+++ b/lib/raid/test/memory.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_MEMORY_H
+#define __RAID_MEMORY_H
+
+/**
+ * Memory alignment provided by raid_malloc_align().
+ *
+ * It should guarantee good cache performance everywhere.
+ */
+#define RAID_MALLOC_ALIGN 256
+
+/**
+ * Memory displacement to avoid cache address sharing on contiguous blocks,
+ * used by raid_malloc_vector().
+ *
+ * When allocating a sequence of blocks with a size of power of 2,
+ * there is the risk that the addresses of each block are mapped into the
+ * same cache line and prefetching predictor, resulting in a lot of cache
+ * sharing if you access all the blocks in parallel, from the start to the
+ * end.
+ *
+ * To avoid this effect, it's better if all the blocks are allocated
+ * with a fixed displacement trying to reduce the cache addresses sharing.
+ *
+ * The selected displacement was choosen empirically with some speed tests
+ * with 16 data buffers of 4 KB.
+ *
+ * These are the results in MB/s with no displacement:
+ *
+ *            int8   int32   int64    sse2   sse2e   ssse3  ssse3e
+ *    gen1            6940   13971   29824
+ *    gen2            2530    4675   14840   16485
+ *    gen3     490                                    6859    7710
+ *
+ * These are the results with displacement resulting in improvments
+ * from 20% to up of 50%:
+ *
+ *            int8   int32   int64    sse2   sse2e   ssse3  ssse3e
+ *    gen1           11762   21450   44621
+ *    gen2            3520    6176   18100   20338
+ *    gen3     848                                    8009    9210
+ *
+ */
+#define RAID_MALLOC_DISPLACEMENT 64
+
+/**
+ * Aligned malloc.
+ */
+void *raid_malloc_align(size_t size, void **freeptr);
+
+/**
+ * Aligned vector allocation.
+ * Returns a vector of @n pointers, each one pointing to a block of
+ * the specified @size.
+ * The first @nd elements are reversed in order.
+ */
+void **raid_malloc_vector(int nd, int n, size_t size, void **freeptr);
+
+/**
+ * Fills the memory vector with random data.
+ */
+void raid_mrand_vector(int n, size_t size, void **vv);
+
+#endif
+
diff --git a/lib/raid/test/selftest.c b/lib/raid/test/selftest.c
new file mode 100644
index 0000000..57ef059
--- /dev/null
+++ b/lib/raid/test/selftest.c
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Self sanity test for the RAID library */
+
+#include "internal.h"
+#include "cpu.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+
+int main(void)
+{
+	printf("Self sanity test for the RAID Cauchy library\n\n");
+
+	raid_init();
+
+	printf("Self test...\n");
+	if (raid_selftest() != 0) {
+		printf("FAILED!\n");
+		exit(EXIT_FAILURE);
+	}
+	printf("OK\n\n");
+
+	printf("Speed test...\n");
+	raid_speedtest(0);
+
+	printf("\nSpeed test with optimized memory layout...\n");
+	raid_speedtest(64);
+
+	return 0;
+}
+
diff --git a/lib/raid/test/speedtest.c b/lib/raid/test/speedtest.c
new file mode 100644
index 0000000..e52ba64
--- /dev/null
+++ b/lib/raid/test/speedtest.c
@@ -0,0 +1,578 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Speed test for the RAID library */
+
+#include "internal.h"
+#include "memory.h"
+#include "cpu.h"
+
+#include <sys/time.h>
+#include <stdio.h>
+#include <inttypes.h>
+
+/*
+ * Size of the blocks to test.
+ */
+#define TEST_SIZE PAGE_SIZE
+
+/*
+ * Number of data blocks to test.
+ */
+#define TEST_COUNT (65536 / TEST_SIZE)
+
+/**
+ * Differential us of two timeval.
+ */
+static int64_t diffgettimeofday(struct timeval *start, struct timeval *stop)
+{
+	int64_t d;
+
+	d = 1000000LL * (stop->tv_sec - start->tv_sec);
+	d += stop->tv_usec - start->tv_usec;
+
+	return d;
+}
+
+/**
+ * Test period.
+ */
+#ifdef COVERAGE
+#define TEST_PERIOD 100000LL
+#define TEST_DELTA 1
+#else
+#define TEST_PERIOD 1000000LL
+#define TEST_DELTA 10
+#endif
+
+/**
+ * Start time measurement.
+ */
+#define SPEED_START \
+	count = 0; \
+	gettimeofday(&start, 0); \
+	do { \
+		for (i = 0; i < delta; ++i)
+
+/**
+ * Stop time measurement.
+ */
+#define SPEED_STOP \
+		count += delta; \
+		gettimeofday(&stop, 0); \
+	} while (diffgettimeofday(&start, &stop) < TEST_PERIOD); \
+	ds = size * (int64_t)count * nd; \
+	dt = diffgettimeofday(&start, &stop);
+
+void speed(void)
+{
+	struct timeval start;
+	struct timeval stop;
+	int64_t ds;
+	int64_t dt;
+	int i, j;
+	int id[RAID_PARITY_MAX];
+	int ip[RAID_PARITY_MAX];
+	int count;
+	int delta = TEST_DELTA;
+	int size = TEST_SIZE;
+	int nd = TEST_COUNT;
+	int nv;
+	void *v_alloc;
+	void **v;
+
+	nv = nd + RAID_PARITY_MAX;
+
+	v = raid_malloc_vector(nd, nv, size, &v_alloc);
+
+	/* initialize disks with fixed data */
+	for (i = 0; i < nd; ++i)
+		memset(v[i], i, size);
+
+	/* basic disks and parity mapping */
+	for (i = 0; i < RAID_PARITY_MAX; ++i) {
+		id[i] = i;
+		ip[i] = i;
+	}
+
+	printf("Speed test using %u data buffers of %u bytes, for a total of %u KiB.\n", nd, size, nd * size / 1024);
+	printf("Memory blocks have a displacement of %u bytes to improve cache performance.\n", RAID_MALLOC_DISPLACEMENT);
+	printf("The reported value is the aggregate bandwidth of all data blocks in MiB/s,\n");
+	printf("not counting parity blocks.\n");
+	printf("\n");
+
+	printf("Memory write speed using the C memset() function:\n");
+	printf("%8s", "memset");
+	fflush(stdout);
+
+	SPEED_START {
+		for (j = 0; j < nd; ++j)
+			memset(v[j], j, size);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	printf("\n");
+	printf("\n");
+
+	/* RAID table */
+	printf("RAID functions used for computing the parity:\n");
+	printf("%8s", "");
+	printf("%8s", "int8");
+	printf("%8s", "int32");
+	printf("%8s", "int64");
+#ifdef CONFIG_X86
+	printf("%8s", "sse2");
+#ifdef CONFIG_X86_64
+	printf("%8s", "sse2e");
+#endif
+	printf("%8s", "ssse3");
+#ifdef CONFIG_X86_64
+	printf("%8s", "ssse3e");
+#endif
+#endif
+	printf("\n");
+
+	/* GEN1 */
+	printf("%8s", "gen1");
+	fflush(stdout);
+
+	printf("%8s", "");
+
+	SPEED_START {
+		raid_gen1_int32(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+	SPEED_START {
+		raid_gen1_int64(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		SPEED_START {
+			raid_gen1_sse2(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+	}
+#endif
+	printf("\n");
+
+	/* GEN2 */
+	printf("%8s", "gen2");
+	fflush(stdout);
+
+	printf("%8s", "");
+
+	SPEED_START {
+		raid_gen2_int32(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+	SPEED_START {
+		raid_gen2_int64(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		SPEED_START {
+			raid_gen2_sse2(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+
+#ifdef CONFIG_X86_64
+		SPEED_START {
+			raid_gen2_sse2ext(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+#endif
+	}
+#endif
+	printf("\n");
+
+	/* GEN3 */
+	printf("%8s", "gen3");
+	fflush(stdout);
+
+	SPEED_START {
+		raid_gen3_int8(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+	printf("%8s", "");
+	printf("%8s", "");
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		printf("%8s", "");
+
+#ifdef CONFIG_X86_64
+		printf("%8s", "");
+#endif
+	}
+#endif
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			raid_gen3_ssse3(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+
+#ifdef CONFIG_X86_64
+		SPEED_START {
+			raid_gen3_ssse3ext(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+#endif
+	}
+#endif
+	printf("\n");
+
+	/* GEN4 */
+	printf("%8s", "gen4");
+	fflush(stdout);
+
+	SPEED_START {
+		raid_gen4_int8(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+	printf("%8s", "");
+	printf("%8s", "");
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		printf("%8s", "");
+
+#ifdef CONFIG_X86_64
+		printf("%8s", "");
+#endif
+	}
+#endif
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			raid_gen4_ssse3(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+
+#ifdef CONFIG_X86_64
+		SPEED_START {
+			raid_gen4_ssse3ext(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+#endif
+	}
+#endif
+	printf("\n");
+
+	/* GEN5 */
+	printf("%8s", "gen5");
+	fflush(stdout);
+
+	SPEED_START {
+		raid_gen5_int8(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+	printf("%8s", "");
+	printf("%8s", "");
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		printf("%8s", "");
+
+#ifdef CONFIG_X86_64
+		printf("%8s", "");
+#endif
+	}
+#endif
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			raid_gen5_ssse3(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+
+#ifdef CONFIG_X86_64
+		SPEED_START {
+			raid_gen5_ssse3ext(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+#endif
+	}
+#endif
+	printf("\n");
+
+	/* GEN6 */
+	printf("%8s", "gen6");
+	fflush(stdout);
+
+	SPEED_START {
+		raid_gen6_int8(nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+	printf("%8s", "");
+	printf("%8s", "");
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		printf("%8s", "");
+
+#ifdef CONFIG_X86_64
+		printf("%8s", "");
+#endif
+	}
+#endif
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			raid_gen6_ssse3(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+
+#ifdef CONFIG_X86_64
+		SPEED_START {
+			raid_gen6_ssse3ext(nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+		fflush(stdout);
+#endif
+	}
+#endif
+	printf("\n");
+	printf("\n");
+
+	/* recover table */
+	printf("RAID functions used for recovering:\n");
+	printf("%8s", "");
+	printf("%8s", "int8");
+#ifdef CONFIG_X86
+	printf("%8s", "ssse3");
+#endif
+	printf("\n");
+
+	printf("%8s", "rec1");
+	fflush(stdout);
+
+	SPEED_START {
+		for (j = 0; j < nd; ++j)
+			/* +1 to avoid GEN1 optimized case */
+			raid_rec1_int8(1, id, ip + 1, nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			for (j = 0; j < nd; ++j)
+				/* +1 to avoid GEN1 optimized case */
+				raid_rec1_ssse3(1, id, ip + 1, nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+	}
+#endif
+	printf("\n");
+
+	printf("%8s", "rec2");
+	fflush(stdout);
+
+	SPEED_START {
+		for (j = 0; j < nd; ++j)
+			/* +1 to avoid GEN2 optimized case */
+			raid_rec2_int8(2, id, ip + 1, nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			for (j = 0; j < nd; ++j)
+				/* +1 to avoid GEN2 optimized case */
+				raid_rec2_ssse3(2, id, ip + 1, nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+	}
+#endif
+	printf("\n");
+
+	printf("%8s", "rec3");
+	fflush(stdout);
+
+	SPEED_START {
+		for (j = 0; j < nd; ++j)
+			raid_recX_int8(3, id, ip, nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			for (j = 0; j < nd; ++j)
+				raid_recX_ssse3(3, id, ip, nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+	}
+#endif
+	printf("\n");
+
+	printf("%8s", "rec4");
+	fflush(stdout);
+
+	SPEED_START {
+		for (j = 0; j < nd; ++j)
+			raid_recX_int8(4, id, ip, nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			for (j = 0; j < nd; ++j)
+				raid_recX_ssse3(4, id, ip, nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+	}
+#endif
+	printf("\n");
+
+	printf("%8s", "rec5");
+	fflush(stdout);
+
+	SPEED_START {
+		for (j = 0; j < nd; ++j)
+			raid_recX_int8(5, id, ip, nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			for (j = 0; j < nd; ++j)
+				raid_recX_ssse3(5, id, ip, nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+	}
+#endif
+	printf("\n");
+
+	printf("%8s", "rec6");
+	fflush(stdout);
+
+	SPEED_START {
+		for (j = 0; j < nd; ++j)
+			raid_recX_int8(6, id, ip, nd, size, v);
+	} SPEED_STOP
+
+	printf("%8"PRIu64, ds / dt);
+	fflush(stdout);
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		SPEED_START {
+			for (j = 0; j < nd; ++j)
+				raid_recX_ssse3(6, id, ip, nd, size, v);
+		} SPEED_STOP
+
+		printf("%8"PRIu64, ds / dt);
+	}
+#endif
+	printf("\n");
+	printf("\n");
+
+	free(v_alloc);
+	free(v);
+}
+
+int main(void)
+{
+	printf("Speed test for the RAID Cauchy library\n\n");
+
+	raid_init();
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2())
+		printf("Including x86 SSE2 functions\n");
+	if (raid_cpu_has_ssse3())
+		printf("Including x86 SSSE3 functions\n");
+#endif
+#ifdef CONFIG_X86_64
+	printf("Including x64 extended SSE register set\n");
+#endif
+
+	printf("\nPlease wait about 30 seconds...\n\n");
+
+	speed();
+
+	return 0;
+}
+
diff --git a/lib/raid/test/test.c b/lib/raid/test/test.c
new file mode 100644
index 0000000..248fbec
--- /dev/null
+++ b/lib/raid/test/test.c
@@ -0,0 +1,314 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+#include "cpu.h"
+#include "combo.h"
+#include "memory.h"
+
+/**
+ * Binomial coefficient of n over r.
+ */
+static int ibc(int n, int r)
+{
+	if (r == 0 || n == r)
+		return 1;
+	else
+		return ibc(n - 1, r - 1) + ibc(n - 1, r);
+}
+
+/**
+ * Power n ^ r;
+ */
+static int ipow(int n, int r)
+{
+	int v = 1;
+	while (r) {
+		v *= n;
+		--r;
+	}
+	return v;
+}
+
+int raid_test_combo(void)
+{
+	int r;
+	int count;
+	int p[RAID_PARITY_MAX];
+
+	for (r = 1; r <= RAID_PARITY_MAX; ++r) {
+		/* count combination (r of RAID_PARITY_MAX) elements */
+		count = 0;
+		combination_first(r, RAID_PARITY_MAX, p);
+
+		do {
+			++count;
+		} while (combination_next(r, RAID_PARITY_MAX, p));
+
+		if (count != ibc(RAID_PARITY_MAX, r))
+			return -1;
+	}
+
+	for (r = 1; r <= RAID_PARITY_MAX; ++r) {
+		/* count permutation (r of RAID_PARITY_MAX) elements */
+		count = 0;
+		permutation_first(r, RAID_PARITY_MAX, p);
+
+		do {
+			++count;
+		} while (permutation_next(r, RAID_PARITY_MAX, p));
+
+		if (count != ipow(RAID_PARITY_MAX, r))
+			return -1;
+	}
+
+	return 0;
+}
+
+int raid_test_insert(void)
+{
+	int p[RAID_PARITY_MAX];
+	int r;
+
+	for (r = 1; r <= RAID_PARITY_MAX; ++r) {
+		permutation_first(r, RAID_PARITY_MAX, p);
+		do {
+			int i[RAID_PARITY_MAX];
+			int j;
+
+			/* insert in order */
+			for (j = 0; j < r; ++j)
+				raid_insert(j, i, p[j]);
+
+			/* check order */
+			for (j = 1; j < r; ++j)
+				if (i[j-1] > i[j])
+					return -1;
+		} while (permutation_next(r, RAID_PARITY_MAX, p));
+	}
+
+	return 0;
+}
+
+int raid_test_rec(int nd, size_t size)
+{
+	void *v_alloc;
+	void **v;
+	void **data;
+	void **parity;
+	void **test;
+	void *data_save[RAID_PARITY_MAX];
+	void *parity_save[RAID_PARITY_MAX];
+	void *waste;
+	int nv;
+	int id[RAID_PARITY_MAX];
+	int ip[RAID_PARITY_MAX];
+	int i;
+	int j;
+	int nr;
+	void (*f[RAID_PARITY_MAX][4])(
+		int nr, int *id, int *ip, int nd, size_t size, void **vbuf);
+	int nf[RAID_PARITY_MAX];
+	int np;
+
+	np = RAID_PARITY_MAX;
+
+	nv = nd + np * 2 + 1;
+
+	v = raid_malloc_vector(nd, nv, size, &v_alloc);
+	if (!v)
+		return -1;
+
+	data = v;
+	parity = v + nd;
+	test = v + nd + np;
+
+	for (i = 0; i < np; ++i)
+		parity_save[i] = parity[i];
+
+	waste = v[nv-1];
+
+	/* fill data disk with random */
+	raid_mrand_vector(nd, size, v);
+
+	/* setup recov functions */
+	for (i = 0; i < np; ++i) {
+		nf[i] = 0;
+		if (i == 0) {
+			f[i][nf[i]++] = raid_rec1_int8;
+#ifdef CONFIG_X86
+			if (raid_cpu_has_ssse3())
+				f[i][nf[i]++] = raid_rec1_ssse3;
+#endif
+		} else if (i == 1) {
+			f[i][nf[i]++] = raid_rec2_int8;
+#ifdef CONFIG_X86
+			if (raid_cpu_has_ssse3())
+				f[i][nf[i]++] = raid_rec2_ssse3;
+#endif
+		} else {
+			f[i][nf[i]++] = raid_recX_int8;
+#ifdef CONFIG_X86
+			if (raid_cpu_has_ssse3())
+				f[i][nf[i]++] = raid_recX_ssse3;
+#endif
+		}
+	}
+
+	/* compute the parity */
+	raid_gen_ref(nd, np, size, v);
+
+	/* set all the parity to the waste v */
+	for (i = 0; i < np; ++i)
+		parity[i] = waste;
+
+	/* all parity levels */
+	for (nr = 1; nr <= np; ++nr) {
+		/* all combinations (nr of nd) disks */
+		combination_first(nr, nd, id);
+		do {
+			/* all combinations (nr of np) parities */
+			combination_first(nr, np, ip);
+			do {
+				/* for each recover function */
+				for (j = 0; j < nf[nr-1]; ++j) {
+					/* set */
+					for (i = 0; i < nr; ++i) {
+						/* remove the missing data */
+						data_save[i] = data[id[i]];
+						data[id[i]] = test[i];
+						/* set the parity to use */
+						parity[ip[i]] = parity_save[ip[i]];
+					}
+
+					/* recover */
+					f[nr-1][j](nr, id, ip, nd, size, v);
+
+					/* check */
+					for (i = 0; i < nr; ++i)
+						if (memcmp(test[i], data_save[i], size) != 0)
+							goto bail;
+
+					/* restore */
+					for (i = 0; i < nr; ++i) {
+						/* restore the data */
+						data[id[i]] = data_save[i];
+						/* restore the parity */
+						parity[ip[i]] = waste;
+					}
+				}
+			} while (combination_next(nr, np, ip));
+		} while (combination_next(nr, nd, id));
+	}
+
+	free(v_alloc);
+	free(v);
+	return 0;
+
+bail:
+	free(v_alloc);
+	free(v);
+	return -1;
+}
+
+int raid_test_par(int nd, size_t size)
+{
+	void *v_alloc;
+	void **v;
+	int nv;
+	int i, j;
+	void (*f[64])(int nd, size_t size, void **vbuf);
+	int nf;
+	int np;
+
+	np = RAID_PARITY_MAX;
+
+	nv = nd + np * 2;
+
+	v = raid_malloc_vector(nd, nv, size, &v_alloc);
+	if (!v)
+		return -1;
+
+	/* fill with random */
+	raid_mrand_vector(nv, size, v);
+
+	/* compute the parity */
+	raid_gen_ref(nd, np, size, v);
+
+	/* copy in back buffers */
+	for (i = 0; i < np; ++i)
+		memcpy(v[nd + np + i], v[nd + i], size);
+
+	/* load all the available functions */
+	nf = 0;
+
+#ifdef RAID_USE_XOR_BLOCKS
+	f[nf++] = raid_gen1_xorblocks;
+#endif
+	f[nf++] = raid_gen1_int32;
+	f[nf++] = raid_gen1_int64;
+	f[nf++] = raid_gen2_int32;
+	f[nf++] = raid_gen2_int64;
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_sse2()) {
+		f[nf++] = raid_gen1_sse2;
+		f[nf++] = raid_gen2_sse2;
+#ifdef CONFIG_X86_64
+		f[nf++] = raid_gen2_sse2ext;
+#endif
+	}
+#endif
+
+	f[nf++] = raid_gen3_int8;
+	f[nf++] = raid_gen4_int8;
+	f[nf++] = raid_gen5_int8;
+	f[nf++] = raid_gen6_int8;
+
+#ifdef CONFIG_X86
+	if (raid_cpu_has_ssse3()) {
+		f[nf++] = raid_gen3_ssse3;
+		f[nf++] = raid_gen4_ssse3;
+		f[nf++] = raid_gen5_ssse3;
+		f[nf++] = raid_gen6_ssse3;
+#ifdef CONFIG_X86_64
+		f[nf++] = raid_gen3_ssse3ext;
+		f[nf++] = raid_gen4_ssse3ext;
+		f[nf++] = raid_gen5_ssse3ext;
+		f[nf++] = raid_gen6_ssse3ext;
+#endif
+	}
+#endif
+
+	/* check all the functions */
+	for (j = 0; j < nf; ++j) {
+		/* compute parity */
+		f[j](nd, size, v);
+
+		/* check it */
+		for (i = 0; i < np; ++i)
+			if (memcmp(v[nd + np + i], v[nd + i], size) != 0)
+				goto bail;
+	}
+
+	free(v_alloc);
+	free(v);
+	return 0;
+
+bail:
+	free(v_alloc);
+	free(v);
+	return -1;
+}
+
diff --git a/lib/raid/test/test.h b/lib/raid/test/test.h
new file mode 100644
index 0000000..7ca48af
--- /dev/null
+++ b/lib/raid/test/test.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_TEST_H
+#define __RAID_TEST_H
+
+/**
+ * Tests insertion function.
+ *
+ * Test raid_insert() with all the possible combinations of elements to insert.
+ *
+ * Returns 0 on success.
+ */
+int raid_test_insert(void);
+
+/**
+ * Tests combination functions.
+ *
+ * Tests combination_first() and combination_next() for all the parity levels.
+ *
+ * Returns 0 on success.
+ */
+int raid_test_combo(void);
+
+/**
+ * Tests recovering functions.
+ *
+ * All the recovering functions are tested with all the combinations
+ * of failing disks and recovering parities.
+ *
+ * Take care that the test time grows exponentially with the number of disks.
+ *
+ * Returns 0 on success.
+ */
+int raid_test_rec(int nd, size_t size);
+
+/**
+ * Tests parity generation functions.
+ *
+ * All the parity generation functions are tested with the specified
+ * number of disks.
+ *
+ * Returns 0 on success.
+ */
+int raid_test_par(int nd, size_t size);
+
+#endif
+
diff --git a/lib/raid/test/usermode.h b/lib/raid/test/usermode.h
new file mode 100644
index 0000000..732cbc5
--- /dev/null
+++ b/lib/raid/test/usermode.h
@@ -0,0 +1,95 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __RAID_USERMODE_H
+#define __RAID_USERMODE_H
+
+/*
+ * Compatibility layer for user mode applications.
+ */
+#include <stdlib.h>
+#include <stdint.h>
+#include <assert.h>
+#include <string.h>
+#include <malloc.h>
+#include <errno.h>
+#include <sys/time.h>
+
+#define pr_err printf
+#define pr_info printf
+#define __aligned(a) __attribute__((aligned(a)))
+#define PAGE_SIZE 4096
+#define EXPORT_SYMBOL_GPL(a) int dummy_##a
+#define EXPORT_SYMBOL(a) int dummy_##a
+#if defined(__i386__)
+#define CONFIG_X86 1
+#define CONFIG_X86_32 1
+#endif
+#if defined(__x86_64__)
+#define CONFIG_X86 1
+#define CONFIG_X86_64 1
+#endif
+#ifdef COVERAGE
+#define BUG_ON(a) do { } while (0)
+#else
+#define BUG_ON(a) assert(!(a))
+#endif
+#define RAID_USE_XOR_BLOCKS 1
+#define MAX_XOR_BLOCKS 1
+void xor_blocks(unsigned count, unsigned size, void *dest, void **srcs);
+#define GFP_KERNEL 0
+#define alloc_pages_exact(size, x) memalign(PAGE_SIZE, size)
+#define free_pages_exact(p, size) free(p)
+#define preempt_disable() do { } while (0)
+#define preempt_enable() do { } while (0)
+#define cpu_relax() do { } while (0)
+#define HZ 1000
+#define jiffies get_jiffies()
+static inline unsigned long get_jiffies(void)
+{
+	struct timeval t;
+	gettimeofday(&t, 0);
+	return t.tv_sec * 1000 + t.tv_usec / 1000;
+}
+#define time_before(x, y) ((x) < (y))
+
+#ifdef CONFIG_X86
+#define X86_FEATURE_XMM2 (0*32+26)
+#define X86_FEATURE_SSSE3 (4*32+9)
+#define X86_FEATURE_AVX (4*32+28)
+#define X86_FEATURE_AVX2 (9*32+5)
+
+static inline int boot_cpu_has(int flag)
+{
+	uint32_t eax, ebx, ecx, edx;
+
+	eax = (flag & 0x100) ? 7 : (flag & 0x20) ? 0x80000001 : 1;
+	ecx = 0;
+
+	asm volatile("cpuid" : "+a" (eax), "=b" (ebx), "=d" (edx), "+c" (ecx));
+
+	return ((flag & 0x100 ? ebx : (flag & 0x80) ? ecx : edx) >> (flag & 31)) & 1;
+}
+
+static inline void kernel_fpu_begin(void)
+{
+}
+
+static inline void kernel_fpu_end(void)
+{
+}
+#endif /* CONFIG_X86 */
+
+#endif
+
diff --git a/lib/raid/test/xor.c b/lib/raid/test/xor.c
new file mode 100644
index 0000000..2d68636
--- /dev/null
+++ b/lib/raid/test/xor.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+
+/**
+ * Implementation of the kernel xor_blocks().
+ */
+void xor_blocks(unsigned int count, unsigned int bytes, void *dest, void **srcs)
+{
+	uint32_t *p1 = dest;
+	uint32_t *p2 = srcs[0];
+	long lines = bytes / (sizeof(uint32_t)) / 8;
+
+	BUG_ON(count != 1);
+
+	do {
+		p1[0] ^= p2[0];
+		p1[1] ^= p2[1];
+		p1[2] ^= p2[2];
+		p1[3] ^= p2[3];
+		p1[4] ^= p2[4];
+		p1[5] ^= p2[5];
+		p1[6] ^= p2[6];
+		p1[7] ^= p2[7];
+		p1 += 8;
+		p2 += 8;
+	} while (--lines > 0);
+}
+
diff --git a/lib/raid/x86.c b/lib/raid/x86.c
new file mode 100644
index 0000000..a2a8f0d
--- /dev/null
+++ b/lib/raid/x86.c
@@ -0,0 +1,1565 @@
+/*
+ * Copyright (C) 2013 Andrea Mazzoleni
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "internal.h"
+#include "gf.h"
+
+#ifdef CONFIG_X86
+/*
+ * GEN1 (RAID5 with xor) SSE2 implementation
+ *
+ * Intentionally don't process more than 64 bytes because 64 is the typical
+ * cache block, and processing 128 bytes doesn't increase performance, and in
+ * some cases it even decreases it.
+ */
+void raid_gen1_sse2(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+
+	raid_asm_begin();
+
+	for (i = 0; i < size; i += 64) {
+		asm volatile("movdqa %0,%%xmm0" : : "m" (v[l][i]));
+		asm volatile("movdqa %0,%%xmm1" : : "m" (v[l][i+16]));
+		asm volatile("movdqa %0,%%xmm2" : : "m" (v[l][i+32]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (v[l][i+48]));
+		for (d = l-1; d >= 0; --d) {
+			asm volatile("pxor %0,%%xmm0" : : "m" (v[d][i]));
+			asm volatile("pxor %0,%%xmm1" : : "m" (v[d][i+16]));
+			asm volatile("pxor %0,%%xmm2" : : "m" (v[d][i+32]));
+			asm volatile("pxor %0,%%xmm3" : : "m" (v[d][i+48]));
+		}
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (p[i+16]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (p[i+32]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (p[i+48]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+static const struct gfconst16 {
+	uint8_t poly[16];
+	uint8_t low4[16];
+} gfconst16  __aligned(32) = {
+	{ 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d,
+	  0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d, 0x1d },
+	{ 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
+	  0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f },
+};
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * GEN2 (RAID6 with powers of 2) SSE2 implementation
+ */
+void raid_gen2_sse2(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+
+	raid_asm_begin();
+
+	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+
+	for (i = 0; i < size; i += 32) {
+		asm volatile("movdqa %0,%%xmm0" : : "m" (v[l][i]));
+		asm volatile("movdqa %0,%%xmm1" : : "m" (v[l][i+16]));
+		asm volatile("movdqa %xmm0,%xmm2");
+		asm volatile("movdqa %xmm1,%xmm3");
+		for (d = l-1; d >= 0; --d) {
+			asm volatile("pxor %xmm4,%xmm4");
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pcmpgtb %xmm2,%xmm4");
+			asm volatile("pcmpgtb %xmm3,%xmm5");
+			asm volatile("paddb %xmm2,%xmm2");
+			asm volatile("paddb %xmm3,%xmm3");
+			asm volatile("pand %xmm7,%xmm4");
+			asm volatile("pand %xmm7,%xmm5");
+			asm volatile("pxor %xmm4,%xmm2");
+			asm volatile("pxor %xmm5,%xmm3");
+
+			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
+			asm volatile("movdqa %0,%%xmm5" : : "m" (v[d][i+16]));
+			asm volatile("pxor %xmm4,%xmm0");
+			asm volatile("pxor %xmm5,%xmm1");
+			asm volatile("pxor %xmm4,%xmm2");
+			asm volatile("pxor %xmm5,%xmm3");
+		}
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (p[i+16]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (q[i+16]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86_64
+/*
+ * GEN2 (RAID6 with powers of 2) SSE2 implementation
+ *
+ * Note that it uses 16 registers, meaning that x64 is required.
+ */
+void raid_gen2_sse2ext(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+
+	raid_asm_begin();
+
+	asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.poly[0]));
+
+	for (i = 0; i < size; i += 64) {
+		asm volatile("movdqa %0,%%xmm0" : : "m" (v[l][i]));
+		asm volatile("movdqa %0,%%xmm1" : : "m" (v[l][i+16]));
+		asm volatile("movdqa %0,%%xmm2" : : "m" (v[l][i+32]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (v[l][i+48]));
+		asm volatile("movdqa %xmm0,%xmm4");
+		asm volatile("movdqa %xmm1,%xmm5");
+		asm volatile("movdqa %xmm2,%xmm6");
+		asm volatile("movdqa %xmm3,%xmm7");
+		for (d = l-1; d >= 0; --d) {
+			asm volatile("pxor %xmm8,%xmm8");
+			asm volatile("pxor %xmm9,%xmm9");
+			asm volatile("pxor %xmm10,%xmm10");
+			asm volatile("pxor %xmm11,%xmm11");
+			asm volatile("pcmpgtb %xmm4,%xmm8");
+			asm volatile("pcmpgtb %xmm5,%xmm9");
+			asm volatile("pcmpgtb %xmm6,%xmm10");
+			asm volatile("pcmpgtb %xmm7,%xmm11");
+			asm volatile("paddb %xmm4,%xmm4");
+			asm volatile("paddb %xmm5,%xmm5");
+			asm volatile("paddb %xmm6,%xmm6");
+			asm volatile("paddb %xmm7,%xmm7");
+			asm volatile("pand %xmm15,%xmm8");
+			asm volatile("pand %xmm15,%xmm9");
+			asm volatile("pand %xmm15,%xmm10");
+			asm volatile("pand %xmm15,%xmm11");
+			asm volatile("pxor %xmm8,%xmm4");
+			asm volatile("pxor %xmm9,%xmm5");
+			asm volatile("pxor %xmm10,%xmm6");
+			asm volatile("pxor %xmm11,%xmm7");
+
+			asm volatile("movdqa %0,%%xmm8" : : "m" (v[d][i]));
+			asm volatile("movdqa %0,%%xmm9" : : "m" (v[d][i+16]));
+			asm volatile("movdqa %0,%%xmm10" : : "m" (v[d][i+32]));
+			asm volatile("movdqa %0,%%xmm11" : : "m" (v[d][i+48]));
+			asm volatile("pxor %xmm8,%xmm0");
+			asm volatile("pxor %xmm9,%xmm1");
+			asm volatile("pxor %xmm10,%xmm2");
+			asm volatile("pxor %xmm11,%xmm3");
+			asm volatile("pxor %xmm8,%xmm4");
+			asm volatile("pxor %xmm9,%xmm5");
+			asm volatile("pxor %xmm10,%xmm6");
+			asm volatile("pxor %xmm11,%xmm7");
+		}
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (p[i+16]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (p[i+32]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (p[i+48]));
+		asm volatile("movntdq %%xmm4,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm5,%0" : "=m" (q[i+16]));
+		asm volatile("movntdq %%xmm6,%0" : "=m" (q[i+32]));
+		asm volatile("movntdq %%xmm7,%0" : "=m" (q[i+48]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * GEN3 (triple parity with Cauchy matrix) SSSE3 implementation
+ */
+void raid_gen3_ssse3(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 3; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	asm volatile("movdqa %0,%%xmm3" : : "m" (gfconst16.poly[0]));
+	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+
+	for (i = 0; i < size; i += 16) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
+
+		asm volatile("movdqa %xmm4,%xmm0");
+		asm volatile("movdqa %xmm4,%xmm1");
+
+		asm volatile("movdqa %xmm4,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm6");
+		asm volatile("pxor   %xmm6,%xmm2");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
+
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pcmpgtb %xmm1,%xmm5");
+			asm volatile("paddb %xmm1,%xmm1");
+			asm volatile("pand %xmm3,%xmm5");
+			asm volatile("pxor %xmm5,%xmm1");
+
+			asm volatile("pxor %xmm4,%xmm0");
+			asm volatile("pxor %xmm4,%xmm1");
+
+			asm volatile("movdqa %xmm4,%xmm5");
+			asm volatile("psrlw  $4,%xmm5");
+			asm volatile("pand   %xmm7,%xmm4");
+			asm volatile("pand   %xmm7,%xmm5");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pxor   %xmm6,%xmm2");
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("pshufb %xmm5,%xmm6");
+			asm volatile("pxor   %xmm6,%xmm2");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
+
+		asm volatile("pxor %xmm5,%xmm5");
+		asm volatile("pcmpgtb %xmm1,%xmm5");
+		asm volatile("paddb %xmm1,%xmm1");
+		asm volatile("pand %xmm3,%xmm5");
+		asm volatile("pxor %xmm5,%xmm1");
+
+		asm volatile("pxor %xmm4,%xmm0");
+		asm volatile("pxor %xmm4,%xmm1");
+		asm volatile("pxor %xmm4,%xmm2");
+
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (r[i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86_64
+/*
+ * GEN3 (triple parity with Cauchy matrix) SSSE3 implementation
+ *
+ * Note that it uses 16 registers, meaning that x64 is required.
+ */
+void raid_gen3_ssse3ext(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 3; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	asm volatile("movdqa %0,%%xmm3" : : "m" (gfconst16.poly[0]));
+	asm volatile("movdqa %0,%%xmm11" : : "m" (gfconst16.low4[0]));
+
+	for (i = 0; i < size; i += 32) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
+		asm volatile("movdqa %0,%%xmm12" : : "m" (v[l][i+16]));
+
+		asm volatile("movdqa %xmm4,%xmm0");
+		asm volatile("movdqa %xmm4,%xmm1");
+		asm volatile("movdqa %xmm12,%xmm8");
+		asm volatile("movdqa %xmm12,%xmm9");
+
+		asm volatile("movdqa %xmm4,%xmm5");
+		asm volatile("movdqa %xmm12,%xmm13");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("psrlw  $4,%xmm13");
+		asm volatile("pand   %xmm11,%xmm4");
+		asm volatile("pand   %xmm11,%xmm12");
+		asm volatile("pand   %xmm11,%xmm5");
+		asm volatile("pand   %xmm11,%xmm13");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("movdqa %xmm2,%xmm10");
+		asm volatile("movdqa %xmm7,%xmm15");
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm12,%xmm10");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pshufb %xmm13,%xmm15");
+		asm volatile("pxor   %xmm7,%xmm2");
+		asm volatile("pxor   %xmm15,%xmm10");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
+			asm volatile("movdqa %0,%%xmm12" : : "m" (v[d][i+16]));
+
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pxor %xmm13,%xmm13");
+			asm volatile("pcmpgtb %xmm1,%xmm5");
+			asm volatile("pcmpgtb %xmm9,%xmm13");
+			asm volatile("paddb %xmm1,%xmm1");
+			asm volatile("paddb %xmm9,%xmm9");
+			asm volatile("pand %xmm3,%xmm5");
+			asm volatile("pand %xmm3,%xmm13");
+			asm volatile("pxor %xmm5,%xmm1");
+			asm volatile("pxor %xmm13,%xmm9");
+
+			asm volatile("pxor %xmm4,%xmm0");
+			asm volatile("pxor %xmm4,%xmm1");
+			asm volatile("pxor %xmm12,%xmm8");
+			asm volatile("pxor %xmm12,%xmm9");
+
+			asm volatile("movdqa %xmm4,%xmm5");
+			asm volatile("movdqa %xmm12,%xmm13");
+			asm volatile("psrlw  $4,%xmm5");
+			asm volatile("psrlw  $4,%xmm13");
+			asm volatile("pand   %xmm11,%xmm4");
+			asm volatile("pand   %xmm11,%xmm12");
+			asm volatile("pand   %xmm11,%xmm5");
+			asm volatile("pand   %xmm11,%xmm13");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("movdqa %xmm6,%xmm14");
+			asm volatile("movdqa %xmm7,%xmm15");
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm12,%xmm14");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pshufb %xmm13,%xmm15");
+			asm volatile("pxor   %xmm6,%xmm2");
+			asm volatile("pxor   %xmm14,%xmm10");
+			asm volatile("pxor   %xmm7,%xmm2");
+			asm volatile("pxor   %xmm15,%xmm10");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
+		asm volatile("movdqa %0,%%xmm12" : : "m" (v[0][i+16]));
+
+		asm volatile("pxor %xmm5,%xmm5");
+		asm volatile("pxor %xmm13,%xmm13");
+		asm volatile("pcmpgtb %xmm1,%xmm5");
+		asm volatile("pcmpgtb %xmm9,%xmm13");
+		asm volatile("paddb %xmm1,%xmm1");
+		asm volatile("paddb %xmm9,%xmm9");
+		asm volatile("pand %xmm3,%xmm5");
+		asm volatile("pand %xmm3,%xmm13");
+		asm volatile("pxor %xmm5,%xmm1");
+		asm volatile("pxor %xmm13,%xmm9");
+
+		asm volatile("pxor %xmm4,%xmm0");
+		asm volatile("pxor %xmm4,%xmm1");
+		asm volatile("pxor %xmm4,%xmm2");
+		asm volatile("pxor %xmm12,%xmm8");
+		asm volatile("pxor %xmm12,%xmm9");
+		asm volatile("pxor %xmm12,%xmm10");
+
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm8,%0" : "=m" (p[i+16]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm9,%0" : "=m" (q[i+16]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (r[i]));
+		asm volatile("movntdq %%xmm10,%0" : "=m" (r[i+16]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * GEN4 (quad parity with Cauchy matrix) SSSE3 implementation
+ */
+void raid_gen4_ssse3(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 4; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	for (i = 0; i < size; i += 16) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
+
+		asm volatile("movdqa %xmm4,%xmm0");
+		asm volatile("movdqa %xmm4,%xmm1");
+
+		asm volatile("movdqa %xmm4,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm2");
+
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
+		asm volatile("pshufb %xmm4,%xmm3");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm3");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
+
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pcmpgtb %xmm1,%xmm5");
+			asm volatile("paddb %xmm1,%xmm1");
+			asm volatile("pand %xmm7,%xmm5");
+			asm volatile("pxor %xmm5,%xmm1");
+
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+
+			asm volatile("pxor %xmm4,%xmm0");
+			asm volatile("pxor %xmm4,%xmm1");
+
+			asm volatile("movdqa %xmm4,%xmm5");
+			asm volatile("psrlw  $4,%xmm5");
+			asm volatile("pand   %xmm7,%xmm4");
+			asm volatile("pand   %xmm7,%xmm5");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm2");
+			asm volatile("pxor   %xmm7,%xmm2");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm3");
+			asm volatile("pxor   %xmm7,%xmm3");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
+
+		asm volatile("pxor %xmm5,%xmm5");
+		asm volatile("pcmpgtb %xmm1,%xmm5");
+		asm volatile("paddb %xmm1,%xmm1");
+		asm volatile("pand %xmm7,%xmm5");
+		asm volatile("pxor %xmm5,%xmm1");
+
+		asm volatile("pxor %xmm4,%xmm0");
+		asm volatile("pxor %xmm4,%xmm1");
+		asm volatile("pxor %xmm4,%xmm2");
+		asm volatile("pxor %xmm4,%xmm3");
+
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (r[i]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (s[i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86_64
+/*
+ * GEN4 (quad parity with Cauchy matrix) SSSE3 implementation
+ *
+ * Note that it uses 16 registers, meaning that x64 is required.
+ */
+void raid_gen4_ssse3ext(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 4; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	for (i = 0; i < size; i += 32) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
+		asm volatile("movdqa %0,%%xmm12" : : "m" (v[l][i+16]));
+
+		asm volatile("movdqa %xmm4,%xmm0");
+		asm volatile("movdqa %xmm4,%xmm1");
+		asm volatile("movdqa %xmm12,%xmm8");
+		asm volatile("movdqa %xmm12,%xmm9");
+
+		asm volatile("movdqa %xmm4,%xmm5");
+		asm volatile("movdqa %xmm12,%xmm13");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("psrlw  $4,%xmm13");
+		asm volatile("pand   %xmm15,%xmm4");
+		asm volatile("pand   %xmm15,%xmm12");
+		asm volatile("pand   %xmm15,%xmm5");
+		asm volatile("pand   %xmm15,%xmm13");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("movdqa %xmm2,%xmm10");
+		asm volatile("movdqa %xmm7,%xmm15");
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm12,%xmm10");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pshufb %xmm13,%xmm15");
+		asm volatile("pxor   %xmm7,%xmm2");
+		asm volatile("pxor   %xmm15,%xmm10");
+
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
+		asm volatile("movdqa %xmm3,%xmm11");
+		asm volatile("movdqa %xmm7,%xmm15");
+		asm volatile("pshufb %xmm4,%xmm3");
+		asm volatile("pshufb %xmm12,%xmm11");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pshufb %xmm13,%xmm15");
+		asm volatile("pxor   %xmm7,%xmm3");
+		asm volatile("pxor   %xmm15,%xmm11");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+			asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
+			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
+			asm volatile("movdqa %0,%%xmm12" : : "m" (v[d][i+16]));
+
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pxor %xmm13,%xmm13");
+			asm volatile("pcmpgtb %xmm1,%xmm5");
+			asm volatile("pcmpgtb %xmm9,%xmm13");
+			asm volatile("paddb %xmm1,%xmm1");
+			asm volatile("paddb %xmm9,%xmm9");
+			asm volatile("pand %xmm7,%xmm5");
+			asm volatile("pand %xmm7,%xmm13");
+			asm volatile("pxor %xmm5,%xmm1");
+			asm volatile("pxor %xmm13,%xmm9");
+
+			asm volatile("pxor %xmm4,%xmm0");
+			asm volatile("pxor %xmm4,%xmm1");
+			asm volatile("pxor %xmm12,%xmm8");
+			asm volatile("pxor %xmm12,%xmm9");
+
+			asm volatile("movdqa %xmm4,%xmm5");
+			asm volatile("movdqa %xmm12,%xmm13");
+			asm volatile("psrlw  $4,%xmm5");
+			asm volatile("psrlw  $4,%xmm13");
+			asm volatile("pand   %xmm15,%xmm4");
+			asm volatile("pand   %xmm15,%xmm12");
+			asm volatile("pand   %xmm15,%xmm5");
+			asm volatile("pand   %xmm15,%xmm13");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("movdqa %xmm6,%xmm14");
+			asm volatile("movdqa %xmm7,%xmm15");
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm12,%xmm14");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pshufb %xmm13,%xmm15");
+			asm volatile("pxor   %xmm6,%xmm2");
+			asm volatile("pxor   %xmm14,%xmm10");
+			asm volatile("pxor   %xmm7,%xmm2");
+			asm volatile("pxor   %xmm15,%xmm10");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
+			asm volatile("movdqa %xmm6,%xmm14");
+			asm volatile("movdqa %xmm7,%xmm15");
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm12,%xmm14");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pshufb %xmm13,%xmm15");
+			asm volatile("pxor   %xmm6,%xmm3");
+			asm volatile("pxor   %xmm14,%xmm11");
+			asm volatile("pxor   %xmm7,%xmm3");
+			asm volatile("pxor   %xmm15,%xmm11");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+		asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
+		asm volatile("movdqa %0,%%xmm12" : : "m" (v[0][i+16]));
+
+		asm volatile("pxor %xmm5,%xmm5");
+		asm volatile("pxor %xmm13,%xmm13");
+		asm volatile("pcmpgtb %xmm1,%xmm5");
+		asm volatile("pcmpgtb %xmm9,%xmm13");
+		asm volatile("paddb %xmm1,%xmm1");
+		asm volatile("paddb %xmm9,%xmm9");
+		asm volatile("pand %xmm7,%xmm5");
+		asm volatile("pand %xmm7,%xmm13");
+		asm volatile("pxor %xmm5,%xmm1");
+		asm volatile("pxor %xmm13,%xmm9");
+
+		asm volatile("pxor %xmm4,%xmm0");
+		asm volatile("pxor %xmm4,%xmm1");
+		asm volatile("pxor %xmm4,%xmm2");
+		asm volatile("pxor %xmm4,%xmm3");
+		asm volatile("pxor %xmm12,%xmm8");
+		asm volatile("pxor %xmm12,%xmm9");
+		asm volatile("pxor %xmm12,%xmm10");
+		asm volatile("pxor %xmm12,%xmm11");
+
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm8,%0" : "=m" (p[i+16]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm9,%0" : "=m" (q[i+16]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (r[i]));
+		asm volatile("movntdq %%xmm10,%0" : "=m" (r[i+16]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (s[i]));
+		asm volatile("movntdq %%xmm11,%0" : "=m" (s[i+16]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * GEN5 (penta parity with Cauchy matrix) SSSE3 implementation
+ */
+void raid_gen5_ssse3(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	uint8_t *t;
+	int d, l;
+	size_t i;
+	uint8_t p0[16] __aligned(16);
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+	t = v[nd+4];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 5; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	for (i = 0; i < size; i += 16) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
+
+		asm volatile("movdqa %xmm4,%xmm0");
+		asm volatile("movdqa %%xmm4,%0" : "=m" (p0[0]));
+
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+		asm volatile("movdqa %xmm4,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+
+		asm volatile("movdqa %0,%%xmm1" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("pshufb %xmm4,%xmm1");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm1");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][1][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm2");
+
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][2][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][2][1][0]));
+		asm volatile("pshufb %xmm4,%xmm3");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm3");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
+			asm volatile("movdqa %0,%%xmm6" : : "m" (p0[0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+
+			asm volatile("pxor %xmm5,%xmm5");
+			asm volatile("pcmpgtb %xmm0,%xmm5");
+			asm volatile("paddb %xmm0,%xmm0");
+			asm volatile("pand %xmm7,%xmm5");
+			asm volatile("pxor %xmm5,%xmm0");
+
+			asm volatile("pxor %xmm4,%xmm0");
+			asm volatile("pxor %xmm4,%xmm6");
+			asm volatile("movdqa %%xmm6,%0" : "=m" (p0[0]));
+
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+			asm volatile("movdqa %xmm4,%xmm5");
+			asm volatile("psrlw  $4,%xmm5");
+			asm volatile("pand   %xmm7,%xmm4");
+			asm volatile("pand   %xmm7,%xmm5");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm1");
+			asm volatile("pxor   %xmm7,%xmm1");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm2");
+			asm volatile("pxor   %xmm7,%xmm2");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][2][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][2][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm3");
+			asm volatile("pxor   %xmm7,%xmm3");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
+		asm volatile("movdqa %0,%%xmm6" : : "m" (p0[0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+
+		asm volatile("pxor %xmm5,%xmm5");
+		asm volatile("pcmpgtb %xmm0,%xmm5");
+		asm volatile("paddb %xmm0,%xmm0");
+		asm volatile("pand %xmm7,%xmm5");
+		asm volatile("pxor %xmm5,%xmm0");
+
+		asm volatile("pxor %xmm4,%xmm0");
+		asm volatile("pxor %xmm4,%xmm1");
+		asm volatile("pxor %xmm4,%xmm2");
+		asm volatile("pxor %xmm4,%xmm3");
+		asm volatile("pxor %xmm4,%xmm6");
+
+		asm volatile("movntdq %%xmm6,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm0,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (r[i]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (s[i]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (t[i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86_64
+/*
+ * GEN5 (penta parity with Cauchy matrix) SSSE3 implementation
+ *
+ * Note that it uses 16 registers, meaning that x64 is required.
+ */
+void raid_gen5_ssse3ext(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	uint8_t *t;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+	t = v[nd+4];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 5; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	asm volatile("movdqa %0,%%xmm14" : : "m" (gfconst16.poly[0]));
+	asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
+
+	for (i = 0; i < size; i += 16) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm10" : : "m" (v[l][i]));
+
+		asm volatile("movdqa %xmm10,%xmm0");
+		asm volatile("movdqa %xmm10,%xmm1");
+
+		asm volatile("movdqa %xmm10,%xmm11");
+		asm volatile("psrlw  $4,%xmm11");
+		asm volatile("pand   %xmm15,%xmm10");
+		asm volatile("pand   %xmm15,%xmm11");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("pshufb %xmm10,%xmm2");
+		asm volatile("pshufb %xmm11,%xmm13");
+		asm volatile("pxor   %xmm13,%xmm2");
+
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
+		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][1][1][0]));
+		asm volatile("pshufb %xmm10,%xmm3");
+		asm volatile("pshufb %xmm11,%xmm13");
+		asm volatile("pxor   %xmm13,%xmm3");
+
+		asm volatile("movdqa %0,%%xmm4" : : "m" (gfgenpshufb[l][2][0][0]));
+		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][2][1][0]));
+		asm volatile("pshufb %xmm10,%xmm4");
+		asm volatile("pshufb %xmm11,%xmm13");
+		asm volatile("pxor   %xmm13,%xmm4");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm10" : : "m" (v[d][i]));
+
+			asm volatile("pxor %xmm11,%xmm11");
+			asm volatile("pcmpgtb %xmm1,%xmm11");
+			asm volatile("paddb %xmm1,%xmm1");
+			asm volatile("pand %xmm14,%xmm11");
+			asm volatile("pxor %xmm11,%xmm1");
+
+			asm volatile("pxor %xmm10,%xmm0");
+			asm volatile("pxor %xmm10,%xmm1");
+
+			asm volatile("movdqa %xmm10,%xmm11");
+			asm volatile("psrlw  $4,%xmm11");
+			asm volatile("pand   %xmm15,%xmm10");
+			asm volatile("pand   %xmm15,%xmm11");
+
+			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("pshufb %xmm10,%xmm12");
+			asm volatile("pshufb %xmm11,%xmm13");
+			asm volatile("pxor   %xmm12,%xmm2");
+			asm volatile("pxor   %xmm13,%xmm2");
+
+			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][1][0][0]));
+			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][1][1][0]));
+			asm volatile("pshufb %xmm10,%xmm12");
+			asm volatile("pshufb %xmm11,%xmm13");
+			asm volatile("pxor   %xmm12,%xmm3");
+			asm volatile("pxor   %xmm13,%xmm3");
+
+			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][2][0][0]));
+			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][2][1][0]));
+			asm volatile("pshufb %xmm10,%xmm12");
+			asm volatile("pshufb %xmm11,%xmm13");
+			asm volatile("pxor   %xmm12,%xmm4");
+			asm volatile("pxor   %xmm13,%xmm4");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm10" : : "m" (v[0][i]));
+
+		asm volatile("pxor %xmm11,%xmm11");
+		asm volatile("pcmpgtb %xmm1,%xmm11");
+		asm volatile("paddb %xmm1,%xmm1");
+		asm volatile("pand %xmm14,%xmm11");
+		asm volatile("pxor %xmm11,%xmm1");
+
+		asm volatile("pxor %xmm10,%xmm0");
+		asm volatile("pxor %xmm10,%xmm1");
+		asm volatile("pxor %xmm10,%xmm2");
+		asm volatile("pxor %xmm10,%xmm3");
+		asm volatile("pxor %xmm10,%xmm4");
+
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (r[i]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (s[i]));
+		asm volatile("movntdq %%xmm4,%0" : "=m" (t[i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * GEN6 (hexa parity with Cauchy matrix) SSSE3 implementation
+ */
+void raid_gen6_ssse3(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	uint8_t *t;
+	uint8_t *u;
+	int d, l;
+	size_t i;
+	uint8_t p0[16] __aligned(16);
+	uint8_t q0[16] __aligned(16);
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+	t = v[nd+4];
+	u = v[nd+5];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 6; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	for (i = 0; i < size; i += 16) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[l][i]));
+
+		asm volatile("movdqa %%xmm4,%0" : "=m" (p0[0]));
+		asm volatile("movdqa %%xmm4,%0" : "=m" (q0[0]));
+
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+		asm volatile("movdqa %xmm4,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+
+		asm volatile("movdqa %0,%%xmm0" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("pshufb %xmm4,%xmm0");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm0");
+
+		asm volatile("movdqa %0,%%xmm1" : : "m" (gfgenpshufb[l][1][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][1][1][0]));
+		asm volatile("pshufb %xmm4,%xmm1");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm1");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][2][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][2][1][0]));
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm2");
+
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][3][0][0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[l][3][1][0]));
+		asm volatile("pshufb %xmm4,%xmm3");
+		asm volatile("pshufb %xmm5,%xmm7");
+		asm volatile("pxor   %xmm7,%xmm3");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm5" : : "m" (p0[0]));
+			asm volatile("movdqa %0,%%xmm6" : : "m" (q0[0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+
+			asm volatile("pxor %xmm4,%xmm4");
+			asm volatile("pcmpgtb %xmm6,%xmm4");
+			asm volatile("paddb %xmm6,%xmm6");
+			asm volatile("pand %xmm7,%xmm4");
+			asm volatile("pxor %xmm4,%xmm6");
+
+			asm volatile("movdqa %0,%%xmm4" : : "m" (v[d][i]));
+
+			asm volatile("pxor %xmm4,%xmm5");
+			asm volatile("pxor %xmm4,%xmm6");
+			asm volatile("movdqa %%xmm5,%0" : "=m" (p0[0]));
+			asm volatile("movdqa %%xmm6,%0" : "=m" (q0[0]));
+
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+			asm volatile("movdqa %xmm4,%xmm5");
+			asm volatile("psrlw  $4,%xmm5");
+			asm volatile("pand   %xmm7,%xmm4");
+			asm volatile("pand   %xmm7,%xmm5");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm0");
+			asm volatile("pxor   %xmm7,%xmm0");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][1][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][1][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm1");
+			asm volatile("pxor   %xmm7,%xmm1");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][2][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][2][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm2");
+			asm volatile("pxor   %xmm7,%xmm2");
+
+			asm volatile("movdqa %0,%%xmm6" : : "m" (gfgenpshufb[d][3][0][0]));
+			asm volatile("movdqa %0,%%xmm7" : : "m" (gfgenpshufb[d][3][1][0]));
+			asm volatile("pshufb %xmm4,%xmm6");
+			asm volatile("pshufb %xmm5,%xmm7");
+			asm volatile("pxor   %xmm6,%xmm3");
+			asm volatile("pxor   %xmm7,%xmm3");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm5" : : "m" (p0[0]));
+		asm volatile("movdqa %0,%%xmm6" : : "m" (q0[0]));
+		asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.poly[0]));
+
+		asm volatile("pxor %xmm4,%xmm4");
+		asm volatile("pcmpgtb %xmm6,%xmm4");
+		asm volatile("paddb %xmm6,%xmm6");
+		asm volatile("pand %xmm7,%xmm4");
+		asm volatile("pxor %xmm4,%xmm6");
+
+		asm volatile("movdqa %0,%%xmm4" : : "m" (v[0][i]));
+		asm volatile("pxor %xmm4,%xmm0");
+		asm volatile("pxor %xmm4,%xmm1");
+		asm volatile("pxor %xmm4,%xmm2");
+		asm volatile("pxor %xmm4,%xmm3");
+		asm volatile("pxor %xmm4,%xmm5");
+		asm volatile("pxor %xmm4,%xmm6");
+
+		asm volatile("movntdq %%xmm5,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm6,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm0,%0" : "=m" (r[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (s[i]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (t[i]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (u[i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86_64
+/*
+ * GEN6 (hexa parity with Cauchy matrix) SSSE3 implementation
+ *
+ * Note that it uses 16 registers, meaning that x64 is required.
+ */
+void raid_gen6_ssse3ext(int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *q;
+	uint8_t *r;
+	uint8_t *s;
+	uint8_t *t;
+	uint8_t *u;
+	int d, l;
+	size_t i;
+
+	l = nd - 1;
+	p = v[nd];
+	q = v[nd+1];
+	r = v[nd+2];
+	s = v[nd+3];
+	t = v[nd+4];
+	u = v[nd+5];
+
+	/* special case with only one data disk */
+	if (l == 0) {
+		for (i = 0; i < 6; ++i)
+			memcpy(v[1+i], v[0], size);
+		return;
+	}
+
+	raid_asm_begin();
+
+	/* generic case with at least two data disks */
+	asm volatile("movdqa %0,%%xmm14" : : "m" (gfconst16.poly[0]));
+	asm volatile("movdqa %0,%%xmm15" : : "m" (gfconst16.low4[0]));
+
+	for (i = 0; i < size; i += 16) {
+		/* last disk without the by two multiplication */
+		asm volatile("movdqa %0,%%xmm10" : : "m" (v[l][i]));
+
+		asm volatile("movdqa %xmm10,%xmm0");
+		asm volatile("movdqa %xmm10,%xmm1");
+
+		asm volatile("movdqa %xmm10,%xmm11");
+		asm volatile("psrlw  $4,%xmm11");
+		asm volatile("pand   %xmm15,%xmm10");
+		asm volatile("pand   %xmm15,%xmm11");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfgenpshufb[l][0][0][0]));
+		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][0][1][0]));
+		asm volatile("pshufb %xmm10,%xmm2");
+		asm volatile("pshufb %xmm11,%xmm13");
+		asm volatile("pxor   %xmm13,%xmm2");
+
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfgenpshufb[l][1][0][0]));
+		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][1][1][0]));
+		asm volatile("pshufb %xmm10,%xmm3");
+		asm volatile("pshufb %xmm11,%xmm13");
+		asm volatile("pxor   %xmm13,%xmm3");
+
+		asm volatile("movdqa %0,%%xmm4" : : "m" (gfgenpshufb[l][2][0][0]));
+		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][2][1][0]));
+		asm volatile("pshufb %xmm10,%xmm4");
+		asm volatile("pshufb %xmm11,%xmm13");
+		asm volatile("pxor   %xmm13,%xmm4");
+
+		asm volatile("movdqa %0,%%xmm5" : : "m" (gfgenpshufb[l][3][0][0]));
+		asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[l][3][1][0]));
+		asm volatile("pshufb %xmm10,%xmm5");
+		asm volatile("pshufb %xmm11,%xmm13");
+		asm volatile("pxor   %xmm13,%xmm5");
+
+		/* intermediate disks */
+		for (d = l-1; d > 0; --d) {
+			asm volatile("movdqa %0,%%xmm10" : : "m" (v[d][i]));
+
+			asm volatile("pxor %xmm11,%xmm11");
+			asm volatile("pcmpgtb %xmm1,%xmm11");
+			asm volatile("paddb %xmm1,%xmm1");
+			asm volatile("pand %xmm14,%xmm11");
+			asm volatile("pxor %xmm11,%xmm1");
+
+			asm volatile("pxor %xmm10,%xmm0");
+			asm volatile("pxor %xmm10,%xmm1");
+
+			asm volatile("movdqa %xmm10,%xmm11");
+			asm volatile("psrlw  $4,%xmm11");
+			asm volatile("pand   %xmm15,%xmm10");
+			asm volatile("pand   %xmm15,%xmm11");
+
+			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][0][0][0]));
+			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][0][1][0]));
+			asm volatile("pshufb %xmm10,%xmm12");
+			asm volatile("pshufb %xmm11,%xmm13");
+			asm volatile("pxor   %xmm12,%xmm2");
+			asm volatile("pxor   %xmm13,%xmm2");
+
+			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][1][0][0]));
+			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][1][1][0]));
+			asm volatile("pshufb %xmm10,%xmm12");
+			asm volatile("pshufb %xmm11,%xmm13");
+			asm volatile("pxor   %xmm12,%xmm3");
+			asm volatile("pxor   %xmm13,%xmm3");
+
+			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][2][0][0]));
+			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][2][1][0]));
+			asm volatile("pshufb %xmm10,%xmm12");
+			asm volatile("pshufb %xmm11,%xmm13");
+			asm volatile("pxor   %xmm12,%xmm4");
+			asm volatile("pxor   %xmm13,%xmm4");
+
+			asm volatile("movdqa %0,%%xmm12" : : "m" (gfgenpshufb[d][3][0][0]));
+			asm volatile("movdqa %0,%%xmm13" : : "m" (gfgenpshufb[d][3][1][0]));
+			asm volatile("pshufb %xmm10,%xmm12");
+			asm volatile("pshufb %xmm11,%xmm13");
+			asm volatile("pxor   %xmm12,%xmm5");
+			asm volatile("pxor   %xmm13,%xmm5");
+		}
+
+		/* first disk with all coefficients at 1 */
+		asm volatile("movdqa %0,%%xmm10" : : "m" (v[0][i]));
+
+		asm volatile("pxor %xmm11,%xmm11");
+		asm volatile("pcmpgtb %xmm1,%xmm11");
+		asm volatile("paddb %xmm1,%xmm1");
+		asm volatile("pand %xmm14,%xmm11");
+		asm volatile("pxor %xmm11,%xmm1");
+
+		asm volatile("pxor %xmm10,%xmm0");
+		asm volatile("pxor %xmm10,%xmm1");
+		asm volatile("pxor %xmm10,%xmm2");
+		asm volatile("pxor %xmm10,%xmm3");
+		asm volatile("pxor %xmm10,%xmm4");
+		asm volatile("pxor %xmm10,%xmm5");
+
+		asm volatile("movntdq %%xmm0,%0" : "=m" (p[i]));
+		asm volatile("movntdq %%xmm1,%0" : "=m" (q[i]));
+		asm volatile("movntdq %%xmm2,%0" : "=m" (r[i]));
+		asm volatile("movntdq %%xmm3,%0" : "=m" (s[i]));
+		asm volatile("movntdq %%xmm4,%0" : "=m" (t[i]));
+		asm volatile("movntdq %%xmm5,%0" : "=m" (u[i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * RAID recovering for one disk SSSE3 implementation
+ */
+void raid_rec1_ssse3(int nr, int *id, int *ip, int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	uint8_t *p;
+	uint8_t *pa;
+	uint8_t G;
+	uint8_t V;
+	size_t i;
+
+	(void)nr; /* unused, it's always 1 */
+
+	/* if it's RAID5 uses the faster function */
+	if (ip[0] == 0) {
+		raid_rec1of1(id, nd, size, vv);
+		return;
+	}
+
+#ifdef RAID_USE_RAID6_PQ
+	/* if it's RAID6 recovering with Q uses the faster function */
+	if (ip[0] == 1) {
+		raid6_datap_recov(nd + 2, size, id[0], vv);
+		return;
+	}
+#endif
+
+	/* setup the coefficients matrix */
+	G = A(ip[0], id[0]);
+
+	/* invert it to solve the system of linear equations */
+	V = inv(G);
+
+	/* compute delta parity */
+	raid_delta_gen(1, id, ip, nd, size, vv);
+
+	p = v[nd+ip[0]];
+	pa = v[id[0]];
+
+	raid_asm_begin();
+
+	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+	asm volatile("movdqa %0,%%xmm4" : : "m" (gfmulpshufb[V][0][0]));
+	asm volatile("movdqa %0,%%xmm5" : : "m" (gfmulpshufb[V][1][0]));
+
+	for (i = 0; i < size; i += 16) {
+		asm volatile("movdqa %0,%%xmm0" : : "m" (p[i]));
+		asm volatile("movdqa %0,%%xmm1" : : "m" (pa[i]));
+		asm volatile("movdqa %xmm4,%xmm2");
+		asm volatile("movdqa %xmm5,%xmm3");
+		asm volatile("pxor   %xmm0,%xmm1");
+		asm volatile("movdqa %xmm1,%xmm0");
+		asm volatile("psrlw  $4,%xmm1");
+		asm volatile("pand   %xmm7,%xmm0");
+		asm volatile("pand   %xmm7,%xmm1");
+		asm volatile("pshufb %xmm0,%xmm2");
+		asm volatile("pshufb %xmm1,%xmm3");
+		asm volatile("pxor   %xmm3,%xmm2");
+		asm volatile("movdqa %%xmm2,%0" : "=m" (pa[i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * RAID recovering for two disks SSSE3 implementation
+ */
+void raid_rec2_ssse3(int nr, int *id, int *ip, int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	const int N = 2;
+	uint8_t *p[N];
+	uint8_t *pa[N];
+	uint8_t G[N*N];
+	uint8_t V[N*N];
+	size_t i;
+	int j, k;
+
+	(void)nr; /* unused, it's always 2 */
+
+#ifdef RAID_USE_RAID6_PQ
+	/* if it's RAID6 recovering with P and Q uses the faster function */
+	if (ip[0] == 0 && ip[1] == 1) {
+		raid6_2data_recov(nd + 2, size, id[0], id[1], vv);
+		return;
+	}
+#endif
+
+	/* setup the coefficients matrix */
+	for (j = 0; j < N; ++j)
+		for (k = 0; k < N; ++k)
+			G[j*N+k] = A(ip[j], id[k]);
+
+	/* invert it to solve the system of linear equations */
+	raid_invert(G, V, N);
+
+	/* compute delta parity */
+	raid_delta_gen(N, id, ip, nd, size, vv);
+
+	for (j = 0; j < N; ++j) {
+		p[j] = v[nd+ip[j]];
+		pa[j] = v[id[j]];
+	}
+
+	raid_asm_begin();
+
+	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+
+	for (i = 0; i < size; i += 16) {
+		asm volatile("movdqa %0,%%xmm0" : : "m" (p[0][i]));
+		asm volatile("movdqa %0,%%xmm2" : : "m" (pa[0][i]));
+		asm volatile("movdqa %0,%%xmm1" : : "m" (p[1][i]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (pa[1][i]));
+		asm volatile("pxor   %xmm2,%xmm0");
+		asm volatile("pxor   %xmm3,%xmm1");
+
+		asm volatile("pxor %xmm6,%xmm6");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[0]][0][0]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[0]][1][0]));
+		asm volatile("movdqa %xmm0,%xmm4");
+		asm volatile("movdqa %xmm0,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm3");
+		asm volatile("pxor   %xmm2,%xmm6");
+		asm volatile("pxor   %xmm3,%xmm6");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[1]][0][0]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[1]][1][0]));
+		asm volatile("movdqa %xmm1,%xmm4");
+		asm volatile("movdqa %xmm1,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm3");
+		asm volatile("pxor   %xmm2,%xmm6");
+		asm volatile("pxor   %xmm3,%xmm6");
+
+		asm volatile("movdqa %%xmm6,%0" : "=m" (pa[0][i]));
+
+		asm volatile("pxor %xmm6,%xmm6");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[2]][0][0]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[2]][1][0]));
+		asm volatile("movdqa %xmm0,%xmm4");
+		asm volatile("movdqa %xmm0,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm3");
+		asm volatile("pxor   %xmm2,%xmm6");
+		asm volatile("pxor   %xmm3,%xmm6");
+
+		asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[V[3]][0][0]));
+		asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[V[3]][1][0]));
+		asm volatile("movdqa %xmm1,%xmm4");
+		asm volatile("movdqa %xmm1,%xmm5");
+		asm volatile("psrlw  $4,%xmm5");
+		asm volatile("pand   %xmm7,%xmm4");
+		asm volatile("pand   %xmm7,%xmm5");
+		asm volatile("pshufb %xmm4,%xmm2");
+		asm volatile("pshufb %xmm5,%xmm3");
+		asm volatile("pxor   %xmm2,%xmm6");
+		asm volatile("pxor   %xmm3,%xmm6");
+
+		asm volatile("movdqa %%xmm6,%0" : "=m" (pa[1][i]));
+	}
+
+	raid_asm_end();
+}
+#endif
+
+#ifdef CONFIG_X86
+/*
+ * RAID recovering SSSE3 implementation
+ */
+void raid_recX_ssse3(int nr, int *id, int *ip, int nd, size_t size, void **vv)
+{
+	uint8_t **v = (uint8_t **)vv;
+	int N = nr;
+	uint8_t *p[RAID_PARITY_MAX];
+	uint8_t *pa[RAID_PARITY_MAX];
+	uint8_t G[RAID_PARITY_MAX*RAID_PARITY_MAX];
+	uint8_t V[RAID_PARITY_MAX*RAID_PARITY_MAX];
+	size_t i;
+	int j, k;
+
+	/* setup the coefficients matrix */
+	for (j = 0; j < N; ++j)
+		for (k = 0; k < N; ++k)
+			G[j*N+k] = A(ip[j], id[k]);
+
+	/* invert it to solve the system of linear equations */
+	raid_invert(G, V, N);
+
+	/* compute delta parity */
+	raid_delta_gen(N, id, ip, nd, size, vv);
+
+	for (j = 0; j < N; ++j) {
+		p[j] = v[nd+ip[j]];
+		pa[j] = v[id[j]];
+	}
+
+	raid_asm_begin();
+
+	asm volatile("movdqa %0,%%xmm7" : : "m" (gfconst16.low4[0]));
+
+	for (i = 0; i < size; i += 16) {
+		uint8_t PD[RAID_PARITY_MAX][16] __aligned(16);
+
+		/* delta */
+		for (j = 0; j < N; ++j) {
+			asm volatile("movdqa %0,%%xmm0" : : "m" (p[j][i]));
+			asm volatile("movdqa %0,%%xmm1" : : "m" (pa[j][i]));
+			asm volatile("pxor   %xmm1,%xmm0");
+			asm volatile("movdqa %%xmm0,%0" : "=m" (PD[j][0]));
+		}
+
+		/* reconstruct */
+		for (j = 0; j < N; ++j) {
+			asm volatile("pxor %xmm0,%xmm0");
+			asm volatile("pxor %xmm1,%xmm1");
+
+			for (k = 0; k < N; ++k) {
+				uint8_t m = V[j*N+k];
+
+				asm volatile("movdqa %0,%%xmm2" : : "m" (gfmulpshufb[m][0][0]));
+				asm volatile("movdqa %0,%%xmm3" : : "m" (gfmulpshufb[m][1][0]));
+				asm volatile("movdqa %0,%%xmm4" : : "m" (PD[k][0]));
+				asm volatile("movdqa %xmm4,%xmm5");
+				asm volatile("psrlw  $4,%xmm5");
+				asm volatile("pand   %xmm7,%xmm4");
+				asm volatile("pand   %xmm7,%xmm5");
+				asm volatile("pshufb %xmm4,%xmm2");
+				asm volatile("pshufb %xmm5,%xmm3");
+				asm volatile("pxor   %xmm2,%xmm0");
+				asm volatile("pxor   %xmm3,%xmm1");
+			}
+
+			asm volatile("pxor %xmm1,%xmm0");
+			asm volatile("movdqa %%xmm0,%0" : "=m" (pa[j][i]));
+		}
+	}
+
+	raid_asm_end();
+}
+#endif
+
-- 
1.7.12.1

