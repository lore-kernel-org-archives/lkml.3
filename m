Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaJXI0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:26:12 -0400
Received: from mail-bn1on0055.outbound.protection.outlook.com ([157.56.110.55]:39264
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932690AbaJXI0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:26:06 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v5 19/29] nios2: Library functions
Date: Fri, 24 Oct 2014 16:24:21 +0800
Message-ID: <1414139071-3818-20-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1414139071-3818-1-git-send-email-lftan@altera.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(76482002)(92566001)(89996001)(120916001)(85852003)(2201001)(87286001)(76176999)(77096002)(50986999)(50466002)(31966008)(87936001)(85306004)(77156001)(88136002)(80022003)(46102003)(15202345003)(99396003)(36756003)(86362001)(50226001)(48376002)(93916002)(575784001)(92726001)(44976005)(19580405001)(6806004)(64706001)(21056001)(47776003)(20776003)(106466001)(68736004)(19580395003)(4396001)(97736003)(42186005)(95666004)(84676001)(229853001)(107046002)(15975445006)(104166001)(33646002)(105596002)(102836001)(62966002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB216;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB216;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optimised library functions for nios2.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/checksum.h |  78 +++++++++++++++
 arch/nios2/include/asm/string.h   |  24 +++++
 arch/nios2/lib/memcpy.c           | 199 ++++++++++++++++++++++++++++++++++++++
 arch/nios2/lib/memmove.c          |  82 ++++++++++++++++
 arch/nios2/lib/memset.c           |  81 ++++++++++++++++
 5 files changed, 464 insertions(+)
 create mode 100644 arch/nios2/include/asm/checksum.h
 create mode 100644 arch/nios2/include/asm/string.h
 create mode 100644 arch/nios2/lib/memcpy.c
 create mode 100644 arch/nios2/lib/memmove.c
 create mode 100644 arch/nios2/lib/memset.c

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
new file mode 100644
index 0000000..6bc1f0d
--- /dev/null
+++ b/arch/nios2/include/asm/checksum.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS_CHECKSUM_H
+#define _ASM_NIOS_CHECKSUM_H
+
+/* Take these from lib/checksum.c */
+extern __wsum csum_partial(const void *buff, int len, __wsum sum);
+extern __wsum csum_partial_copy(const void *src, void *dst, int len,
+				__wsum sum);
+extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
+					int len, __wsum sum, int *csum_err);
+#define csum_partial_copy_nocheck(src, dst, len, sum)	\
+	csum_partial_copy((src), (dst), (len), (sum))
+
+extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+extern __sum16 ip_compute_csum(const void *buff, int len);
+
+/*
+ * Fold a partial checksum
+ */
+static inline __sum16 csum_fold(__wsum sum)
+{
+	__asm__ __volatile__(
+		"add	%0, %1, %0\n"
+		"cmpltu	r8, %0, %1\n"
+		"srli	%0, %0, 16\n"
+		"add	%0, %0, r8\n"
+		"nor	%0, %0, %0\n"
+		: "=r" (sum)
+		: "r" (sum << 16), "0" (sum)
+		: "r8");
+	return (__force __sum16) sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+#define csum_tcpudp_nofold csum_tcpudp_nofold
+static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
+					unsigned short len,
+					unsigned short proto,
+					__wsum sum)
+{
+	__asm__ __volatile__(
+		"add	%0, %1, %0\n"
+		"cmpltu	r8, %0, %1\n"
+		"add	%0, %0, r8\n"	/* add carry */
+		"add	%0, %2, %0\n"
+		"cmpltu	r8, %0, %2\n"
+		"add	%0, %0, r8\n"	/* add carry */
+		"add	%0, %3, %0\n"
+		"cmpltu	r8, %0, %3\n"
+		"add	%0, %0, r8\n"	/* add carry */
+		: "=r" (sum), "=r" (saddr)
+		: "r" (daddr), "r" ((ntohs(len) << 16) + (proto * 256)),
+		  "0" (sum),
+		  "1" (saddr)
+		: "r8");
+
+	return sum;
+}
+
+static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
+					unsigned short len,
+					unsigned short proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+#endif /* _ASM_NIOS_CHECKSUM_H */
diff --git a/arch/nios2/include/asm/string.h b/arch/nios2/include/asm/string.h
new file mode 100644
index 0000000..14dd570
--- /dev/null
+++ b/arch/nios2/include/asm/string.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_STRING_H
+#define _ASM_NIOS2_STRING_H
+
+#ifdef __KERNEL__
+
+#define __HAVE_ARCH_MEMSET
+#define __HAVE_ARCH_MEMCPY
+#define __HAVE_ARCH_MEMMOVE
+
+extern void *memset(void *s, int c, size_t count);
+extern void *memcpy(void *d, const void *s, size_t count);
+extern void *memmove(void *d, const void *s, size_t count);
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_NIOS2_STRING_H */
diff --git a/arch/nios2/lib/memcpy.c b/arch/nios2/lib/memcpy.c
new file mode 100644
index 0000000..ac7eec4
--- /dev/null
+++ b/arch/nios2/lib/memcpy.c
@@ -0,0 +1,199 @@
+/* Extracted from GLIBC memcpy.c and memcopy.h, which is:
+   Copyright (C) 1991, 1992, 1993, 1997, 2004 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Torbjorn Granlund (tege@sics.se).
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#include <linux/types.h>
+
+/* Type to use for aligned memory operations.
+   This should normally be the biggest type supported by a single load
+   and store.  */
+#define	op_t	unsigned long int
+#define OPSIZ	(sizeof(op_t))
+
+/* Optimal type for storing bytes in registers.  */
+#define	reg_char	char
+
+#define MERGE(w0, sh_1, w1, sh_2) (((w0) >> (sh_1)) | ((w1) << (sh_2)))
+
+/* Copy exactly NBYTES bytes from SRC_BP to DST_BP,
+   without any assumptions about alignment of the pointers.  */
+#define BYTE_COPY_FWD(dst_bp, src_bp, nbytes)				\
+do {									\
+	size_t __nbytes = (nbytes);					\
+	while (__nbytes > 0) {						\
+		unsigned char __x = ((unsigned char *) src_bp)[0];	\
+		src_bp += 1;						\
+		__nbytes -= 1;						\
+		((unsigned char *) dst_bp)[0] = __x;			\
+		dst_bp += 1;						\
+	}								\
+} while (0)
+
+/* Copy *up to* NBYTES bytes from SRC_BP to DST_BP, with
+   the assumption that DST_BP is aligned on an OPSIZ multiple.  If
+   not all bytes could be easily copied, store remaining number of bytes
+   in NBYTES_LEFT, otherwise store 0.  */
+/* extern void _wordcopy_fwd_aligned __P ((long int, long int, size_t)); */
+/* extern void _wordcopy_fwd_dest_aligned __P ((long int, long int, size_t)); */
+#define WORD_COPY_FWD(dst_bp, src_bp, nbytes_left, nbytes)		\
+do {									\
+	if (src_bp % OPSIZ == 0)					\
+		_wordcopy_fwd_aligned(dst_bp, src_bp, (nbytes) / OPSIZ);\
+	else								\
+		_wordcopy_fwd_dest_aligned(dst_bp, src_bp, (nbytes) / OPSIZ);\
+	src_bp += (nbytes) & -OPSIZ;					\
+	dst_bp += (nbytes) & -OPSIZ;					\
+	(nbytes_left) = (nbytes) % OPSIZ;				\
+} while (0)
+
+
+/* Threshold value for when to enter the unrolled loops.  */
+#define	OP_T_THRES	16
+
+/* _wordcopy_fwd_aligned -- Copy block beginning at SRCP to
+   block beginning at DSTP with LEN `op_t' words (not LEN bytes!).
+   Both SRCP and DSTP should be aligned for memory operations on `op_t's.  */
+/* stream-lined (read x8 + write x8) */
+static void _wordcopy_fwd_aligned(long int dstp, long int srcp, size_t len)
+{
+	while (len > 7) {
+		register op_t a0, a1, a2, a3, a4, a5, a6, a7;
+		a0 = ((op_t *) srcp)[0];
+		a1 = ((op_t *) srcp)[1];
+		a2 = ((op_t *) srcp)[2];
+		a3 = ((op_t *) srcp)[3];
+		a4 = ((op_t *) srcp)[4];
+		a5 = ((op_t *) srcp)[5];
+		a6 = ((op_t *) srcp)[6];
+		a7 = ((op_t *) srcp)[7];
+		((op_t *) dstp)[0] = a0;
+		((op_t *) dstp)[1] = a1;
+		((op_t *) dstp)[2] = a2;
+		((op_t *) dstp)[3] = a3;
+		((op_t *) dstp)[4] = a4;
+		((op_t *) dstp)[5] = a5;
+		((op_t *) dstp)[6] = a6;
+		((op_t *) dstp)[7] = a7;
+
+		srcp += 8 * OPSIZ;
+		dstp += 8 * OPSIZ;
+		len -= 8;
+	}
+	while (len > 0) {
+		*(op_t *)dstp = *(op_t *)srcp;
+
+		srcp += OPSIZ;
+		dstp += OPSIZ;
+		len -= 1;
+	}
+}
+
+/* _wordcopy_fwd_dest_aligned -- Copy block beginning at SRCP to
+   block beginning at DSTP with LEN `op_t' words (not LEN bytes!).
+   DSTP should be aligned for memory operations on `op_t's, but SRCP must
+   *not* be aligned.  */
+/* stream-lined (read x4 + write x4) */
+static void _wordcopy_fwd_dest_aligned(long int dstp, long int srcp,
+					size_t len)
+{
+	op_t ap;
+	int sh_1, sh_2;
+
+	/* Calculate how to shift a word read at the memory operation
+	aligned srcp to make it aligned for copy. */
+
+	sh_1 = 8 * (srcp % OPSIZ);
+	sh_2 = 8 * OPSIZ - sh_1;
+
+	/* Make SRCP aligned by rounding it down to the beginning of the `op_t'
+	it points in the middle of. */
+	srcp &= -OPSIZ;
+	ap = ((op_t *) srcp)[0];
+	srcp += OPSIZ;
+
+	while (len > 3) {
+		op_t a0, a1, a2, a3;
+		a0 = ((op_t *) srcp)[0];
+		a1 = ((op_t *) srcp)[1];
+		a2 = ((op_t *) srcp)[2];
+		a3 = ((op_t *) srcp)[3];
+		((op_t *) dstp)[0] = MERGE(ap, sh_1, a0, sh_2);
+		((op_t *) dstp)[1] = MERGE(a0, sh_1, a1, sh_2);
+		((op_t *) dstp)[2] = MERGE(a1, sh_1, a2, sh_2);
+		((op_t *) dstp)[3] = MERGE(a2, sh_1, a3, sh_2);
+
+		ap = a3;
+		srcp += 4 * OPSIZ;
+		dstp += 4 * OPSIZ;
+		len -= 4;
+	}
+	while (len > 0) {
+		register op_t a0;
+		a0 = ((op_t *) srcp)[0];
+		((op_t *) dstp)[0] = MERGE(ap, sh_1, a0, sh_2);
+
+		ap = a0;
+		srcp += OPSIZ;
+		dstp += OPSIZ;
+		len -= 1;
+	}
+}
+
+void *memcpy(void *dstpp, const void *srcpp, size_t len)
+{
+	unsigned long int dstp = (long int) dstpp;
+	unsigned long int srcp = (long int) srcpp;
+
+	/* Copy from the beginning to the end.  */
+
+	/* If there not too few bytes to copy, use word copy.  */
+	if (len >= OP_T_THRES) {
+		/* Copy just a few bytes to make DSTP aligned.  */
+		len -= (-dstp) % OPSIZ;
+		BYTE_COPY_FWD(dstp, srcp, (-dstp) % OPSIZ);
+
+		/* Copy whole pages from SRCP to DSTP by virtual address
+		   manipulation, as much as possible.  */
+
+		/* PAGE_COPY_FWD_MAYBE (dstp, srcp, len, len); */
+
+		/* Copy from SRCP to DSTP taking advantage of the known
+		   alignment of DSTP. Number of bytes remaining is put in the
+		   third argument, i.e. in LEN.  This number may vary from
+		   machine to machine. */
+
+		WORD_COPY_FWD(dstp, srcp, len, len);
+
+		/* Fall out and copy the tail. */
+	}
+
+	/* There are just a few bytes to copy.  Use byte memory operations. */
+	BYTE_COPY_FWD(dstp, srcp, len);
+
+	return dstpp;
+}
+
+void *memcpyb(void *dstpp, const void *srcpp, unsigned len)
+{
+	unsigned long int dstp = (long int) dstpp;
+	unsigned long int srcp = (long int) srcpp;
+
+	BYTE_COPY_FWD(dstp, srcp, len);
+
+	return dstpp;
+}
diff --git a/arch/nios2/lib/memmove.c b/arch/nios2/lib/memmove.c
new file mode 100644
index 0000000..c65ef51
--- /dev/null
+++ b/arch/nios2/lib/memmove.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+#ifdef __HAVE_ARCH_MEMMOVE
+void *memmove(void *d, const void *s, size_t count)
+{
+	unsigned long dst, src;
+
+	if (!count)
+		return d;
+
+	if (d < s) {
+		dst = (unsigned long) d;
+		src = (unsigned long) s;
+
+		if ((count < 8) || ((dst ^ src) & 3))
+			goto restup;
+
+		if (dst & 1) {
+			*(char *)dst++ = *(char *)src++;
+			count--;
+		}
+		if (dst & 2) {
+			*(short *)dst = *(short *)src;
+			src += 2;
+			dst += 2;
+			count -= 2;
+		}
+		while (count > 3) {
+			*(long *)dst = *(long *)src;
+			src += 4;
+			dst += 4;
+			count -= 4;
+		}
+restup:
+		while (count--)
+			*(char *)dst++ = *(char *)src++;
+	} else {
+		dst = (unsigned long) d + count;
+		src = (unsigned long) s + count;
+
+		if ((count < 8) || ((dst ^ src) & 3))
+			goto restdown;
+
+		if (dst & 1) {
+			src--;
+			dst--;
+			count--;
+			*(char *)dst = *(char *)src;
+		}
+		if (dst & 2) {
+			src -= 2;
+			dst -= 2;
+			count -= 2;
+			*(short *)dst = *(short *)src;
+		}
+		while (count > 3) {
+			src -= 4;
+			dst -= 4;
+			count -= 4;
+			*(long *)dst = *(long *)src;
+		}
+restdown:
+		while (count--) {
+			src--;
+			dst--;
+			*(char *)dst = *(char *)src;
+		}
+	}
+
+	return d;
+}
+#endif /* __HAVE_ARCH_MEMMOVE */
diff --git a/arch/nios2/lib/memset.c b/arch/nios2/lib/memset.c
new file mode 100644
index 0000000..65e9780
--- /dev/null
+++ b/arch/nios2/lib/memset.c
@@ -0,0 +1,81 @@
+/*
+ * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+#ifdef __HAVE_ARCH_MEMSET
+void *memset(void *s, int c, size_t count)
+{
+	int destptr, charcnt, dwordcnt, fill8reg, wrkrega;
+
+	if (!count)
+		return s;
+
+	c &= 0xFF;
+
+	if (count <= 8) {
+		char *xs = (char *) s;
+
+		while (count--)
+			*xs++ = c;
+		return s;
+	}
+
+	__asm__ __volatile__ (
+		/* fill8 %3, %5 (c & 0xff) */
+		"	slli	%4, %5, 8\n"
+		"	or	%4, %4, %5\n"
+		"	slli    %3, %4, 16\n"
+		"	or	%3, %3, %4\n"
+		/* Word-align %0 (s) if necessary */
+		"	andi	%4, %0, 0x01\n"
+		"	beq	%4, zero, 1f\n"
+		"	addi	%1, %1, -1\n"
+		"	stb	%3, 0(%0)\n"
+		"	addi	%0, %0, 1\n"
+		"1:	mov	%2, %1\n"
+		/* Dword-align %0 (s) if necessary */
+		"	andi	%4, %0, 0x02\n"
+		"	beq	%4, zero, 2f\n"
+		"	addi	%1, %1, -2\n"
+		"	sth	%3, 0(%0)\n"
+		"	addi	%0, %0, 2\n"
+		"	mov	%2, %1\n"
+		/* %1 and %2 are how many more bytes to set */
+		"2:	srli	%2, %2, 2\n"
+		/* %2 is how many dwords to set */
+		"3:	stw	%3, 0(%0)\n"
+		"	addi	%0, %0, 4\n"
+		"	addi    %2, %2, -1\n"
+		"	bne	%2, zero, 3b\n"
+		/* store residual word and/or byte if necessary */
+		"	andi	%4, %1, 0x02\n"
+		"	beq	%4, zero, 4f\n"
+		"	sth	%3, 0(%0)\n"
+		"	addi	%0, %0, 2\n"
+		/* store residual byte if necessary */
+		"4:	andi	%4, %1, 0x01\n"
+		"	beq	%4, zero, 5f\n"
+		"	stb	%3, 0(%0)\n"
+		"5:\n"
+		: "=r" (destptr),	/* %0  Output */
+		  "=r" (charcnt),	/* %1  Output */
+		  "=r" (dwordcnt),	/* %2  Output */
+		  "=r" (fill8reg),	/* %3  Output */
+		  "=r" (wrkrega)	/* %4  Output */
+		: "r" (c),		/* %5  Input */
+		  "0" (s),		/* %0  Input/Output */
+		  "1" (count)		/* %1  Input/Output */
+		: "memory"		/* clobbered */
+	);
+
+	return s;
+}
+#endif /* __HAVE_ARCH_MEMSET */
-- 
1.8.2.1

