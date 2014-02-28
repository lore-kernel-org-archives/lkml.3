Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaB1XAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:00:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45061 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaB1XAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:00:18 -0500
Date: Fri, 28 Feb 2014 18:00:17 -0500
From: Kyle McMartin <kyle@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: lasse.collin@tukaani.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: [PATCH] xz: make XZ_DEC_BCJ filters non-optional
Message-ID: <20140228230017.GE14970@merlin.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Having these optional is more trouble than is justified by the
negligible increase in code size to lib/xz/ if they're all compiled in.
Their optional status ends up necessitating rebuilds of the kernel
in order to be able to decompress XZ-compressed squashfs images which
use non-native BCJ filters (ie: you need to enable XZ_DEC_POWERPC on
x86_64 in order to loop-mount a ppc64 squashfs that uses it.)

So save ourselves the trouble and build them all into xz_dec_bcj.o to
begin with. (I could conceivably see a case where CONFIG_EXPERT made
these selectable, but again, even on embedded platforms, the .text
increase we're talking about is noise...)

text	data	bss	dec	hex	filename
1239	0	0	1239	4d7	xz_dec_bcj.o
2263	0	0	2263	8d7	xz_dec_bcj.o.2

regards, Kyle

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/lib/xz/Kconfig
+++ b/lib/xz/Kconfig
@@ -6,44 +6,6 @@ config XZ_DEC
 	  the .xz file format as the container. For integrity checking,
 	  CRC32 is supported. See Documentation/xz.txt for more information.
 
-if XZ_DEC
-
-config XZ_DEC_X86
-	bool "x86 BCJ filter decoder"
-	default y if X86
-	select XZ_DEC_BCJ
-
-config XZ_DEC_POWERPC
-	bool "PowerPC BCJ filter decoder"
-	default y if PPC
-	select XZ_DEC_BCJ
-
-config XZ_DEC_IA64
-	bool "IA-64 BCJ filter decoder"
-	default y if IA64
-	select XZ_DEC_BCJ
-
-config XZ_DEC_ARM
-	bool "ARM BCJ filter decoder"
-	default y if ARM
-	select XZ_DEC_BCJ
-
-config XZ_DEC_ARMTHUMB
-	bool "ARM-Thumb BCJ filter decoder"
-	default y if (ARM && ARM_THUMB)
-	select XZ_DEC_BCJ
-
-config XZ_DEC_SPARC
-	bool "SPARC BCJ filter decoder"
-	default y if SPARC
-	select XZ_DEC_BCJ
-
-endif
-
-config XZ_DEC_BCJ
-	bool
-	default n
-
 config XZ_DEC_TEST
 	tristate "XZ decompressor tester"
 	default n
diff --git a/lib/xz/Makefile b/lib/xz/Makefile
index a7fa769..4f209f7 100644
--- a/lib/xz/Makefile
+++ b/lib/xz/Makefile
@@ -1,5 +1,4 @@
 obj-$(CONFIG_XZ_DEC) += xz_dec.o
-xz_dec-y := xz_dec_syms.o xz_dec_stream.o xz_dec_lzma2.o
-xz_dec-$(CONFIG_XZ_DEC_BCJ) += xz_dec_bcj.o
+xz_dec-y := xz_dec_syms.o xz_dec_stream.o xz_dec_lzma2.o xz_dec_bcj.o
 
 obj-$(CONFIG_XZ_DEC_TEST) += xz_dec_test.o
diff --git a/lib/xz/xz_dec_bcj.c b/lib/xz/xz_dec_bcj.c
index a768e6d..e2ac55c 100644
--- a/lib/xz/xz_dec_bcj.c
+++ b/lib/xz/xz_dec_bcj.c
@@ -10,12 +10,6 @@
 
 #include "xz_private.h"
 
-/*
- * The rest of the file is inside this ifdef. It makes things a little more
- * convenient when building without support for any BCJ filters.
- */
-#ifdef XZ_DEC_BCJ
-
 struct xz_dec_bcj {
 	/* Type of the BCJ filter being used */
 	enum {
@@ -75,7 +69,6 @@ struct xz_dec_bcj {
 	} temp;
 };
 
-#ifdef XZ_DEC_X86
 /*
  * This is used to test the most significant byte of a memory address
  * in an x86 instruction.
@@ -154,9 +147,7 @@ static size_t bcj_x86(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 	s->x86_prev_mask = prev_pos > 3 ? 0 : prev_mask << (prev_pos - 1);
 	return i;
 }
-#endif
 
-#ifdef XZ_DEC_POWERPC
 static size_t bcj_powerpc(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 {
 	size_t i;
@@ -175,9 +166,7 @@ static size_t bcj_powerpc(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 
 	return i;
 }
-#endif
 
-#ifdef XZ_DEC_IA64
 static size_t bcj_ia64(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 {
 	static const uint8_t branch_table[32] = {
@@ -259,9 +248,7 @@ static size_t bcj_ia64(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 
 	return i;
 }
-#endif
 
-#ifdef XZ_DEC_ARM
 static size_t bcj_arm(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 {
 	size_t i;
@@ -282,9 +269,7 @@ static size_t bcj_arm(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 
 	return i;
 }
-#endif
 
-#ifdef XZ_DEC_ARMTHUMB
 static size_t bcj_armthumb(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 {
 	size_t i;
@@ -310,9 +295,7 @@ static size_t bcj_armthumb(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 
 	return i;
 }
-#endif
 
-#ifdef XZ_DEC_SPARC
 static size_t bcj_sparc(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 {
 	size_t i;
@@ -332,7 +315,6 @@ static size_t bcj_sparc(struct xz_dec_bcj *s, uint8_t *buf, size_t size)
 
 	return i;
 }
-#endif
 
 /*
  * Apply the selected BCJ filter. Update *pos and s->pos to match the amount
@@ -351,36 +333,24 @@ static void bcj_apply(struct xz_dec_bcj *s,
 	size -= *pos;
 
 	switch (s->type) {
-#ifdef XZ_DEC_X86
 	case BCJ_X86:
 		filtered = bcj_x86(s, buf, size);
 		break;
-#endif
-#ifdef XZ_DEC_POWERPC
 	case BCJ_POWERPC:
 		filtered = bcj_powerpc(s, buf, size);
 		break;
-#endif
-#ifdef XZ_DEC_IA64
 	case BCJ_IA64:
 		filtered = bcj_ia64(s, buf, size);
 		break;
-#endif
-#ifdef XZ_DEC_ARM
 	case BCJ_ARM:
 		filtered = bcj_arm(s, buf, size);
 		break;
-#endif
-#ifdef XZ_DEC_ARMTHUMB
 	case BCJ_ARMTHUMB:
 		filtered = bcj_armthumb(s, buf, size);
 		break;
-#endif
-#ifdef XZ_DEC_SPARC
 	case BCJ_SPARC:
 		filtered = bcj_sparc(s, buf, size);
 		break;
-#endif
 	default:
 		/* Never reached but silence compiler warnings. */
 		filtered = 0;
@@ -536,24 +506,12 @@ XZ_EXTERN struct xz_dec_bcj *xz_dec_bcj_create(bool single_call)
 XZ_EXTERN enum xz_ret xz_dec_bcj_reset(struct xz_dec_bcj *s, uint8_t id)
 {
 	switch (id) {
-#ifdef XZ_DEC_X86
 	case BCJ_X86:
-#endif
-#ifdef XZ_DEC_POWERPC
 	case BCJ_POWERPC:
-#endif
-#ifdef XZ_DEC_IA64
 	case BCJ_IA64:
-#endif
-#ifdef XZ_DEC_ARM
 	case BCJ_ARM:
-#endif
-#ifdef XZ_DEC_ARMTHUMB
 	case BCJ_ARMTHUMB:
-#endif
-#ifdef XZ_DEC_SPARC
 	case BCJ_SPARC:
-#endif
 		break;
 
 	default:
@@ -571,4 +529,3 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_reset(struct xz_dec_bcj *s, uint8_t id)
 	return XZ_OK;
 }
 
-#endif
diff --git a/lib/xz/xz_dec_stream.c b/lib/xz/xz_dec_stream.c
index ac809b1..a1ce0f7 100644
--- a/lib/xz/xz_dec_stream.c
+++ b/lib/xz/xz_dec_stream.c
@@ -130,10 +130,8 @@ struct xz_dec {
 
 	struct xz_dec_lzma2 *lzma2;
 
-#ifdef XZ_DEC_BCJ
 	struct xz_dec_bcj *bcj;
 	bool bcj_active;
-#endif
 };
 
 #ifdef XZ_DEC_ANY_CHECK
@@ -222,11 +220,9 @@ static enum xz_ret dec_block(struct xz_dec *s, struct xz_buf *b)
 	s->in_start = b->in_pos;
 	s->out_start = b->out_pos;
 
-#ifdef XZ_DEC_BCJ
 	if (s->bcj_active)
 		ret = xz_dec_bcj_run(s->bcj, s->lzma2, b);
 	else
-#endif
 		ret = xz_dec_lzma2_run(s->lzma2, b);
 
 	s->block.compressed += b->in_pos - s->in_start;
@@ -465,11 +461,7 @@ static enum xz_ret dec_block_header(struct xz_dec *s)
 	 * Catch unsupported Block Flags. We support only one or two filters
 	 * in the chain, so we catch that with the same test.
 	 */
-#ifdef XZ_DEC_BCJ
 	if (s->temp.buf[1] & 0x3E)
-#else
-	if (s->temp.buf[1] & 0x3F)
-#endif
 		return XZ_OPTIONS_ERROR;
 
 	/* Compressed Size */
@@ -494,7 +486,6 @@ static enum xz_ret dec_block_header(struct xz_dec *s)
 		s->block_header.uncompressed = VLI_UNKNOWN;
 	}
 
-#ifdef XZ_DEC_BCJ
 	/* If there are two filters, the first one must be a BCJ filter. */
 	s->bcj_active = s->temp.buf[1] & 0x01;
 	if (s->bcj_active) {
@@ -512,7 +503,6 @@ static enum xz_ret dec_block_header(struct xz_dec *s)
 		if (s->temp.buf[s->temp.pos++] != 0x00)
 			return XZ_OPTIONS_ERROR;
 	}
-#endif
 
 	/* Valid Filter Flags always take at least two bytes. */
 	if (s->temp.size - s->temp.pos < 2)
@@ -775,11 +765,9 @@ XZ_EXTERN struct xz_dec *xz_dec_init(enum xz_mode mode, uint32_t dict_max)
 
 	s->mode = mode;
 
-#ifdef XZ_DEC_BCJ
 	s->bcj = xz_dec_bcj_create(DEC_IS_SINGLE(mode));
 	if (s->bcj == NULL)
 		goto error_bcj;
-#endif
 
 	s->lzma2 = xz_dec_lzma2_create(mode, dict_max);
 	if (s->lzma2 == NULL)
@@ -789,10 +777,8 @@ XZ_EXTERN struct xz_dec *xz_dec_init(enum xz_mode mode, uint32_t dict_max)
 	return s;
 
 error_lzma2:
-#ifdef XZ_DEC_BCJ
 	xz_dec_bcj_end(s->bcj);
 error_bcj:
-#endif
 	kfree(s);
 	return NULL;
 }
@@ -813,9 +799,7 @@ XZ_EXTERN void xz_dec_end(struct xz_dec *s)
 {
 	if (s != NULL) {
 		xz_dec_lzma2_end(s->lzma2);
-#ifdef XZ_DEC_BCJ
 		xz_dec_bcj_end(s->bcj);
-#endif
 		kfree(s);
 	}
 }
diff --git a/lib/xz/xz_private.h b/lib/xz/xz_private.h
index 482b90f..72334af 100644
--- a/lib/xz/xz_private.h
+++ b/lib/xz/xz_private.h
@@ -19,24 +19,6 @@
 #		include <linux/slab.h>
 #		include <linux/vmalloc.h>
 #		include <linux/string.h>
-#		ifdef CONFIG_XZ_DEC_X86
-#			define XZ_DEC_X86
-#		endif
-#		ifdef CONFIG_XZ_DEC_POWERPC
-#			define XZ_DEC_POWERPC
-#		endif
-#		ifdef CONFIG_XZ_DEC_IA64
-#			define XZ_DEC_IA64
-#		endif
-#		ifdef CONFIG_XZ_DEC_ARM
-#			define XZ_DEC_ARM
-#		endif
-#		ifdef CONFIG_XZ_DEC_ARMTHUMB
-#			define XZ_DEC_ARMTHUMB
-#		endif
-#		ifdef CONFIG_XZ_DEC_SPARC
-#			define XZ_DEC_SPARC
-#		endif
 #		define memeq(a, b, size) (memcmp(a, b, size) == 0)
 #		define memzero(buf, size) memset(buf, 0, size)
 #	endif
@@ -90,19 +72,6 @@
 #endif
 
 /*
- * If any of the BCJ filter decoders are wanted, define XZ_DEC_BCJ.
- * XZ_DEC_BCJ is used to enable generic support for BCJ decoders.
- */
-#ifndef XZ_DEC_BCJ
-#	if defined(XZ_DEC_X86) || defined(XZ_DEC_POWERPC) \
-			|| defined(XZ_DEC_IA64) || defined(XZ_DEC_ARM) \
-			|| defined(XZ_DEC_ARM) || defined(XZ_DEC_ARMTHUMB) \
-			|| defined(XZ_DEC_SPARC)
-#		define XZ_DEC_BCJ
-#	endif
-#endif
-
-/*
  * Allocate memory for LZMA2 decoder. xz_dec_lzma2_reset() must be used
  * before calling xz_dec_lzma2_run().
  */
@@ -125,7 +94,6 @@ XZ_EXTERN enum xz_ret xz_dec_lzma2_run(struct xz_dec_lzma2 *s,
 /* Free the memory allocated for the LZMA2 decoder. */
 XZ_EXTERN void xz_dec_lzma2_end(struct xz_dec_lzma2 *s);
 
-#ifdef XZ_DEC_BCJ
 /*
  * Allocate memory for BCJ decoders. xz_dec_bcj_reset() must be used before
  * calling xz_dec_bcj_run().
@@ -151,6 +119,5 @@ XZ_EXTERN enum xz_ret xz_dec_bcj_run(struct xz_dec_bcj *s,
 
 /* Free the memory allocated for the BCJ filters. */
 #define xz_dec_bcj_end(s) kfree(s)
-#endif
 
 #endif
