Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314Ab3HGUlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:41:02 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60711 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3HGUk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:40:58 -0400
Message-ID: <201308072040.r77Kevx4016119@farm-0012.internal.tilera.com>
From: Ken Steele <ken@tilera.com>
Date: Wed, 7 Aug 2013 12:39:56 -0400
Subject: [PATCH] RAID: add tilegx SIMD implementation of raid6
To: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds TILE-Gx SIMD instructions to the software raid
(md), modeling the Altivec implementation. This is only for Syndrome
generation; there is more that could be done to improve recovery,
as in the recent Intel SSE3 recovery implementation.

The code unrolls 8 times; this turns out to be the best on tilegx
hardware among the set 1, 2, 4, 8 or 16.  The code reads one
cache-line of data from each disk, stores P and Q then goes to the
next cache-line.

The test code in sys/linux/lib/raid6/test reports 2008 MB/s data
read rate for syndrome generation using 18 disks (16 data and 2
parity). It was 1512 MB/s before this SIMD optimizations. This is
running on 1 core with all the data in cache.

This is based on the paper The Mathematics of RAID-6.
(http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf).

Signed-off-by: Ken Steele <ken@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 include/linux/raid/pq.h |  1 +
 lib/raid6/Makefile      |  6 ++++
 lib/raid6/algos.c       |  3 ++
 lib/raid6/test/Makefile |  7 ++++
 lib/raid6/tilegx.uc     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 103 insertions(+)
 create mode 100644 lib/raid6/tilegx.uc

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 8dfaa2c..6d5df8a 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -101,6 +101,7 @@ extern const struct raid6_calls raid6_altivec8;
 extern const struct raid6_calls raid6_avx2x1;
 extern const struct raid6_calls raid6_avx2x2;
 extern const struct raid6_calls raid6_avx2x4;
+extern const struct raid6_calls raid6_tilegx8;
 
 struct raid6_recov_calls {
 	void (*data2)(int, size_t, int, int, void **);
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 9f7c184..e5e9021 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -5,6 +5,7 @@ raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
 
 raid6_pq-$(CONFIG_X86) += recov_ssse3.o recov_avx2.o mmx.o sse1.o sse2.o avx2.o
 raid6_pq-$(CONFIG_ALTIVEC) += altivec1.o altivec2.o altivec4.o altivec8.o
+raid6_pq-$(CONFIG_TILEGX) += tilegx8.o
 
 hostprogs-y	+= mktables
 
@@ -70,6 +71,11 @@ $(obj)/altivec8.c:   UNROLL := 8
 $(obj)/altivec8.c:   $(src)/altivec.uc $(src)/unroll.awk FORCE
 	$(call if_changed,unroll)
 
+targets += tilegx8.c
+$(obj)/tilegx8.c:   UNROLL := 8
+$(obj)/tilegx8.c:   $(src)/tilegx.uc $(src)/unroll.awk FORCE
+	$(call if_changed,unroll)
+
 quiet_cmd_mktable = TABLE   $@
       cmd_mktable = $(obj)/mktables > $@ || ( rm -f $@ && exit 1 )
 
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 6d7316f..b9f3401 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -66,6 +66,9 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_altivec4,
 	&raid6_altivec8,
 #endif
+#if defined(CONFIG_TILEGX)
+	&raid6_tilegx8,
+#endif
 	&raid6_intx1,
 	&raid6_intx2,
 	&raid6_intx4,
diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index 087332d..96b4637 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -35,6 +35,9 @@ else
                 OBJS += altivec1.o altivec2.o altivec4.o altivec8.o
         endif
 endif
+ifeq ($(ARCH),tilegx)
+OBJS += tilegx8.o
+endif
 
 .c.o:
 	$(CC) $(CFLAGS) -c -o $@ $<
@@ -85,11 +88,15 @@ int16.c: int.uc ../unroll.awk
 int32.c: int.uc ../unroll.awk
 	$(AWK) ../unroll.awk -vN=32 < int.uc > $@
 
+tilegx8.c: tilegx.uc ../unroll.awk
+	$(AWK) ../unroll.awk -vN=8 < tilegx.uc > $@
+
 tables.c: mktables
 	./mktables > tables.c
 
 clean:
 	rm -f *.o *.a mktables mktables.c *.uc int*.c altivec*.c tables.c raid6test
+	rm tilegx*.c
 
 spotless: clean
 	rm -f *~
diff --git a/lib/raid6/tilegx.uc b/lib/raid6/tilegx.uc
new file mode 100644
index 0000000..e7c2945
--- /dev/null
+++ b/lib/raid6/tilegx.uc
@@ -0,0 +1,86 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright 2002 H. Peter Anvin - All Rights Reserved
+ *   Copyright 2012 Tilera Corporation - All Rights Reserved
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
+ *   Boston MA 02111-1307, USA; either version 2 of the License, or
+ *   (at your option) any later version; incorporated herein by reference.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * tilegx$#.c
+ *
+ * $#-way unrolled TILE-Gx SIMD for RAID-6 math.
+ *
+ * This file is postprocessed using unroll.awk.
+ *
+ */
+
+#include <linux/raid/pq.h>
+
+/* Create 8 byte copies of constant byte */
+# define NBYTES(x) (__insn_v1addi(0, x))
+# define NSIZE  8
+
+/*
+ * The SHLBYTE() operation shifts each byte left by 1, *not*
+ * rolling over into the next byte
+ */
+static inline __attribute_const__ u64 SHLBYTE(u64 v)
+{
+	/* Vector One Byte Shift Left Immediate. */
+	return __insn_v1shli(v, 1);
+}
+
+/*
+ * The MASK() operation returns 0xFF in any byte for which the high
+ * bit is 1, 0x00 for any byte for which the high bit is 0.
+ */
+static inline __attribute_const__ u64 MASK(u64 v)
+{
+	/* Vector One Byte Shift Right Signed Immediate. */
+	return __insn_v1shrsi(v, 7);
+}
+
+
+void raid6_tilegx$#_gen_syndrome(int disks, size_t bytes, void **ptrs)
+{
+	u8 **dptr = (u8 **)ptrs;
+	u64 *p, *q;
+	int d, z, z0;
+
+	u64 wd$$, wq$$, wp$$, w1$$, w2$$;
+	u64 x1d = NBYTES(0x1d);
+	u64 * z0ptr;
+
+	z0 = disks - 3;			/* Highest data disk */
+	p = (u64 *)dptr[z0+1];	/* XOR parity */
+	q = (u64 *)dptr[z0+2];	/* RS syndrome */
+
+	z0ptr = (u64 *)&dptr[z0][0];
+	for ( d = 0 ; d < bytes ; d += NSIZE*$# ) {
+		wq$$ = wp$$ = *z0ptr++;
+		for ( z = z0-1 ; z >= 0 ; z-- ) {
+			wd$$ = *(u64 *)&dptr[z][d+$$*NSIZE];
+			wp$$ = wp$$ ^ wd$$;
+			w2$$ = MASK(wq$$);
+			w1$$ = SHLBYTE(wq$$);
+			w2$$ = w2$$ & x1d;
+			w1$$ = w1$$ ^ w2$$;
+			wq$$ = w1$$ ^ wd$$;
+		}
+		*p++ = wp$$;
+		*q++ = wq$$;
+	}
+}
+
+const struct raid6_calls raid6_tilegx$# = {
+	raid6_tilegx$#_gen_syndrome,
+	NULL,
+	"tilegx$#",
+	0
+};
-- 
1.8.3.1

