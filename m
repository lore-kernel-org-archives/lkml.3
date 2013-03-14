Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab3CNKqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:46:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab3CNKh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 61/88] ARM: 7657/1: head: fix swapper and idmap population with LPAE and big-endian
Date: Thu, 14 Mar 2013 10:35:54 +0000
Message-Id: <1363257381-15900-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit d61947a164760ac520cb416768afdf38c33d60e7 upstream.

The LPAE page table format uses 64-bit descriptors, so we need to take
endianness into account when populating the swapper and idmap tables
during early initialisation.

This patch ensures that we store the two words making up each page table
entry in the correct order when running big-endian.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/head.S | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 458b8d3..f47f770 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -188,13 +188,22 @@ __create_page_tables:
 	orr	r3, r3, #3			@ PGD block type
 	mov	r6, #4				@ PTRS_PER_PGD
 	mov	r7, #1 << (55 - 32)		@ L_PGD_SWAPPER
-1:	str	r3, [r0], #4			@ set bottom PGD entry bits
+1:
+#ifdef CONFIG_CPU_ENDIAN_BE8
 	str	r7, [r0], #4			@ set top PGD entry bits
+	str	r3, [r0], #4			@ set bottom PGD entry bits
+#else
+	str	r3, [r0], #4			@ set bottom PGD entry bits
+	str	r7, [r0], #4			@ set top PGD entry bits
+#endif
 	add	r3, r3, #0x1000			@ next PMD table
 	subs	r6, r6, #1
 	bne	1b
 
 	add	r4, r4, #0x1000			@ point to the PMD tables
+#ifdef CONFIG_CPU_ENDIAN_BE8
+	add	r4, r4, #4			@ we only write the bottom word
+#endif
 #endif
 
 	ldr	r7, [r10, #PROCINFO_MM_MMUFLAGS] @ mm_mmuflags
@@ -267,6 +276,11 @@ __create_page_tables:
 	add	r6, r6, #1 << SECTION_SHIFT
 	str	r6, [r3]
 
+#if defined(CONFIG_LPAE) && defined(CONFIG_CPU_ENDIAN_BE8)
+	sub	r4, r4, #4			@ Fixup page table pointer
+						@ for 64-bit descriptors
+#endif
+
 #ifdef CONFIG_DEBUG_LL
 #if !defined(CONFIG_DEBUG_ICEDCC) && !defined(CONFIG_DEBUG_SEMIHOSTING)
 	/*
@@ -285,13 +299,17 @@ __create_page_tables:
 	orr	r3, r7, r3, lsl #SECTION_SHIFT
 #ifdef CONFIG_ARM_LPAE
 	mov	r7, #1 << (54 - 32)		@ XN
+#ifdef CONFIG_CPU_ENDIAN_BE8
+	str	r7, [r0], #4
+	str	r3, [r0], #4
 #else
-	orr	r3, r3, #PMD_SECT_XN
-#endif
 	str	r3, [r0], #4
-#ifdef CONFIG_ARM_LPAE
 	str	r7, [r0], #4
 #endif
+#else
+	orr	r3, r3, #PMD_SECT_XN
+	str	r3, [r0], #4
+#endif
 
 #else /* CONFIG_DEBUG_ICEDCC || CONFIG_DEBUG_SEMIHOSTING */
 	/* we don't need any serial debugging mappings */
-- 
1.8.1.2

