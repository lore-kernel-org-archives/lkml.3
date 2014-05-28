Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaE1OkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:40:04 -0400
Received: from ns.horizon.com ([71.41.210.147]:14384 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753458AbaE1OkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:40:02 -0400
Date: 28 May 2014 10:40:00 -0400
Message-ID: <20140528144000.28686.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: herbert@gondor.apana.org.au, JBeulich@suse.com, tim.c.chen@linux.intel.com
Subject: [RFC PATCH] crypto: crc32c-pclmul - Use pmovzxdq to shrink K_table
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, sandyw@twitter.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While following a number of tangents in the code (I was figuring out
how to edit lib/Kconfig; don't ask), I came across a table of 256 64-bit
words, all of which had the high half set to zero.

Since the code depends on both pclmulq and crc32, SSE 4.1 is obviously
present, so it could use pmovzxdq and save 1K of kernel data.

The following patch obviously lacks the kludges for old binutils,
but should convey the general idea.

Jan: Is support for SLE10's pre-2.18 binutils still required?
Your PEXTRD fix was only a year ago, so I expect, but I wanted to ask.

Two other minor additional changes:

1. The current code unnecessarily puts the table in the read-write
   .data section.  Moved to .text.
2. I'm also not sure why it's necessary to force such large alignment
   on K_table.  Comments on reducing it?

Signed-off-by: George Spelvin <linux@horizon.com>


diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index dbc4339b..9f885ee4 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -216,15 +216,11 @@ LABEL crc_ %i
 	## 4) Combine three results:
 	################################################################
 
-	lea	(K_table-16)(%rip), bufp	# first entry is for idx 1
+	lea	(K_table-8)(%rip), bufp		# first entry is for idx 1
 	shlq    $3, %rax			# rax *= 8
-	subq    %rax, tmp			# tmp -= rax*8
-	shlq    $1, %rax
-	subq    %rax, tmp			# tmp -= rax*16
-						# (total tmp -= rax*24)
-	addq    %rax, bufp
-
-	movdqa  (bufp), %xmm0			# 2 consts: K1:K2
+	pmovzxdq (bufp,%rax), %xmm0		# 2 consts: K1:K2
+	leal	(%eax,%eax,2), %eax		# rax *= 3 (total *24)
+	subq    %rax, tmp			# tmp -= rax*24
 
 	movq    crc_init, %xmm1			# CRC for block 1
 	PCLMULQDQ 0x00,%xmm0,%xmm1		# Multiply by K2
@@ -331,136 +327,135 @@ ENDPROC(crc_pcl)
 
 	################################################################
 	## PCLMULQDQ tables
-	## Table is 128 entries x 2 quad words each
+	## Table is 128 entries x 2 words (8 bytes) each
 	################################################################
-.data
-.align 64
+.align 8
 K_table:
-        .quad 0x14cd00bd6,0x105ec76f0
+        .long 0x14cd00bd6,0x105ec76f0
-        .quad 0x0ba4fc28e,0x14cd00bd6
+        .long 0x0ba4fc28e,0x14cd00bd6
-        .quad 0x1d82c63da,0x0f20c0dfe
+        .long 0x1d82c63da,0x0f20c0dfe
-        .quad 0x09e4addf8,0x0ba4fc28e
+        .long 0x09e4addf8,0x0ba4fc28e
-        .quad 0x039d3b296,0x1384aa63a
+        .long 0x039d3b296,0x1384aa63a
-        .quad 0x102f9b8a2,0x1d82c63da
+        .long 0x102f9b8a2,0x1d82c63da
-        .quad 0x14237f5e6,0x01c291d04
+        .long 0x14237f5e6,0x01c291d04
-        .quad 0x00d3b6092,0x09e4addf8
+        .long 0x00d3b6092,0x09e4addf8

(Remaining boring bits of this hunk elided.)
