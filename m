Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3GCCOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:14:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36486 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab3GCCNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:13:47 -0400
X-AuditID: 85900ec0-d42c9b900000151e-7a-51d388d82cd1
X-Mailbox-Line: From nobody Wed Jul  3 10:46:16 2013
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [RFC PATCH 3/5] tools/include: Add jhash.h
To: linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, kay@vrfy.org, davem@davemloft.net,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, "David S. Miller" <davem@davemloft.net>
Date: Wed, 03 Jul 2013 10:46:16 +0900
Message-ID: <20130703014616.18745.28678.stgit@localhost.localdomain>
In-Reply-To: <20130703014616.18745.34699.stgit@localhost.localdomain>
References: <20130703014616.18745.34699.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy include/linux/jhash.h to tools/include/tools/ for userland
tools.  The original jhash.h includes a couple of header files
which is not suitable for userland.  So unfold the only necessary
part in those header files to the copied jhash.h

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: "David S. Miller" <davem@davemloft.net>
---

 tools/include/tools/jhash.h |  192 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 192 insertions(+), 0 deletions(-)
 create mode 100644 tools/include/tools/jhash.h

diff --git a/tools/include/tools/jhash.h b/tools/include/tools/jhash.h
new file mode 100644
index 0000000..872d7f9
--- /dev/null
+++ b/tools/include/tools/jhash.h
@@ -0,0 +1,192 @@
+#ifndef _TOOLS_JHASH_H
+#define _TOOLS_JHASH_H
+
+/* jhash.h: Jenkins hash support.
+ *
+ * Copyright (C) 2006. Bob Jenkins (bob_jenkins@burtleburtle.net)
+ *
+ * http://burtleburtle.net/bob/hash/
+ *
+ * These are the credits from Bob's sources:
+ *
+ * lookup3.c, by Bob Jenkins, May 2006, Public Domain.
+ *
+ * These are functions for producing 32-bit hashes for hash table lookup.
+ * hashword(), hashlittle(), hashlittle2(), hashbig(), mix(), and final()
+ * are externally useful functions.  Routines to test the hash are included
+ * if SELF_TEST is defined.  You can use this free for any purpose.  It's in
+ * the public domain.  It has no warranty.
+ *
+ * Copyright (C) 2009-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
+ *
+ * I've modified Bob's hash to be useful in the Linux kernel, and
+ * any bugs present are my fault.
+ * Jozsef
+ */
+
+#define __packed	__attribute__((packed))
+
+/*
+ * __get_unaligned_cpu32 was copied from
+ * include/linux/unaligned/packed_struct.h
+ */
+struct __una_u32 { u32 x; } __packed;
+static inline u32 __get_unaligned_cpu32(const void *p)
+{
+	const struct __una_u32 *ptr = (const struct __una_u32 *)p;
+	return ptr->x;
+}
+
+/* rol32 was copied from include/linux/bitops.h */
+/**
+ * rol32 - rotate a 32-bit value left
+ * @word: value to rotate
+ * @shift: bits to roll
+ */
+static inline u32 rol32(u32 word, unsigned int shift)
+{
+	return (word << shift) | (word >> (32 - shift));
+}
+
+/* Best hash sizes are of power of two */
+#define jhash_size(n)   ((u32)1<<(n))
+/* Mask the hash value, i.e (value & jhash_mask(n)) instead of (value % n) */
+#define jhash_mask(n)   (jhash_size(n)-1)
+
+/* __jhash_mix -- mix 3 32-bit values reversibly. */
+#define __jhash_mix(a, b, c)			\
+{						\
+	a -= c;  a ^= rol32(c, 4);  c += b;	\
+	b -= a;  b ^= rol32(a, 6);  a += c;	\
+	c -= b;  c ^= rol32(b, 8);  b += a;	\
+	a -= c;  a ^= rol32(c, 16); c += b;	\
+	b -= a;  b ^= rol32(a, 19); a += c;	\
+	c -= b;  c ^= rol32(b, 4);  b += a;	\
+}
+
+/* __jhash_final - final mixing of 3 32-bit values (a,b,c) into c */
+#define __jhash_final(a, b, c)			\
+{						\
+	c ^= b; c -= rol32(b, 14);		\
+	a ^= c; a -= rol32(c, 11);		\
+	b ^= a; b -= rol32(a, 25);		\
+	c ^= b; c -= rol32(b, 16);		\
+	a ^= c; a -= rol32(c, 4);		\
+	b ^= a; b -= rol32(a, 14);		\
+	c ^= b; c -= rol32(b, 24);		\
+}
+
+/* An arbitrary initial parameter */
+#define JHASH_INITVAL		0xdeadbeef
+
+/* jhash - hash an arbitrary key
+ * @k: sequence of bytes as key
+ * @length: the length of the key
+ * @initval: the previous hash, or an arbitray value
+ *
+ * The generic version, hashes an arbitrary sequence of bytes.
+ * No alignment or length assumptions are made about the input key.
+ *
+ * Returns the hash value of the key. The result depends on endianness.
+ */
+static inline u32 jhash(const void *key, u32 length, u32 initval)
+{
+	u32 a, b, c;
+	const u8 *k = key;
+
+	/* Set up the internal state */
+	a = b = c = JHASH_INITVAL + length + initval;
+
+	/* All but the last block: affect some 32 bits of (a,b,c) */
+	while (length > 12) {
+		a += __get_unaligned_cpu32(k);
+		b += __get_unaligned_cpu32(k + 4);
+		c += __get_unaligned_cpu32(k + 8);
+		__jhash_mix(a, b, c);
+		length -= 12;
+		k += 12;
+	}
+	/* Last block: affect all 32 bits of (c) */
+	/* All the case statements fall through */
+	switch (length) {
+	case 12: c += (u32)k[11]<<24;
+	case 11: c += (u32)k[10]<<16;
+	case 10: c += (u32)k[9]<<8;
+	case 9:  c += k[8];
+	case 8:  b += (u32)k[7]<<24;
+	case 7:  b += (u32)k[6]<<16;
+	case 6:  b += (u32)k[5]<<8;
+	case 5:  b += k[4];
+	case 4:  a += (u32)k[3]<<24;
+	case 3:  a += (u32)k[2]<<16;
+	case 2:  a += (u32)k[1]<<8;
+	case 1:  a += k[0];
+		 __jhash_final(a, b, c);
+	case 0: /* Nothing left to add */
+		break;
+	}
+
+	return c;
+}
+
+/* jhash2 - hash an array of u32's
+ * @k: the key which must be an array of u32's
+ * @length: the number of u32's in the key
+ * @initval: the previous hash, or an arbitray value
+ *
+ * Returns the hash value of the key.
+ */
+static inline u32 jhash2(const u32 *k, u32 length, u32 initval)
+{
+	u32 a, b, c;
+
+	/* Set up the internal state */
+	a = b = c = JHASH_INITVAL + (length<<2) + initval;
+
+	/* Handle most of the key */
+	while (length > 3) {
+		a += k[0];
+		b += k[1];
+		c += k[2];
+		__jhash_mix(a, b, c);
+		length -= 3;
+		k += 3;
+	}
+
+	/* Handle the last 3 u32's: all the case statements fall through */
+	switch (length) {
+	case 3: c += k[2];
+	case 2: b += k[1];
+	case 1: a += k[0];
+		__jhash_final(a, b, c);
+	case 0:	/* Nothing left to add */
+		break;
+	}
+
+	return c;
+}
+
+
+/* jhash_3words - hash exactly 3, 2 or 1 word(s) */
+static inline u32 jhash_3words(u32 a, u32 b, u32 c, u32 initval)
+{
+	a += JHASH_INITVAL;
+	b += JHASH_INITVAL;
+	c += initval;
+
+	__jhash_final(a, b, c);
+
+	return c;
+}
+
+static inline u32 jhash_2words(u32 a, u32 b, u32 initval)
+{
+	return jhash_3words(a, b, 0, initval);
+}
+
+static inline u32 jhash_1word(u32 a, u32 initval)
+{
+	return jhash_3words(a, 0, 0, initval);
+}
+
+#endif /* _TOOLS_JHASH_H */


