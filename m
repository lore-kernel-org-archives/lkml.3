Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaD1BbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43036 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Will Deacon" <will.deacon@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.924226157@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 24/94] ARM: mm: introduce present, faulting entries
 for PAGE_NONE
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 26ffd0d43b186b0d5186354da8714a1c2d360df0 upstream.

PROT_NONE mappings apply the page protection attributes defined by _P000
which translate to PAGE_NONE for ARM. These attributes specify an XN,
RDONLY pte that is inaccessible to userspace. However, on kernels
configured without support for domains, such a pte *is* accessible to
the kernel and can be read via get_user, allowing tasks to read
PROT_NONE pages via syscalls such as read/write over a pipe.

This patch introduces a new software pte flag, L_PTE_NONE, that is set
to identify faulting, present entries.

Signed-off-by: Will Deacon <will.deacon@arm.com>
[bwh: Backported to 3.2 as dependency of commit b6ccb9803e90
 ('ARM: 7954/1: mm: remove remaining domain support from ARMv6'):
 - Drop 3-level changes
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -123,6 +123,7 @@
 #define L_PTE_USER		(_AT(pteval_t, 1) << 8)
 #define L_PTE_XN		(_AT(pteval_t, 1) << 9)
 #define L_PTE_SHARED		(_AT(pteval_t, 1) << 10)	/* shared(v6), coherent(xsc3) */
+#define L_PTE_NONE		(_AT(pteval_t, 1) << 11)
 
 /*
  * These are the memory types, defined to be compatible with
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -74,7 +74,7 @@ extern pgprot_t		pgprot_kernel;
 
 #define _MOD_PROT(p, b)	__pgprot(pgprot_val(p) | (b))
 
-#define PAGE_NONE		_MOD_PROT(pgprot_user, L_PTE_XN | L_PTE_RDONLY)
+#define PAGE_NONE		_MOD_PROT(pgprot_user, L_PTE_XN | L_PTE_RDONLY | L_PTE_NONE)
 #define PAGE_SHARED		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_XN)
 #define PAGE_SHARED_EXEC	_MOD_PROT(pgprot_user, L_PTE_USER)
 #define PAGE_COPY		_MOD_PROT(pgprot_user, L_PTE_USER | L_PTE_RDONLY | L_PTE_XN)
@@ -84,7 +84,7 @@ extern pgprot_t		pgprot_kernel;
 #define PAGE_KERNEL		_MOD_PROT(pgprot_kernel, L_PTE_XN)
 #define PAGE_KERNEL_EXEC	pgprot_kernel
 
-#define __PAGE_NONE		__pgprot(_L_PTE_DEFAULT | L_PTE_RDONLY | L_PTE_XN)
+#define __PAGE_NONE		__pgprot(_L_PTE_DEFAULT | L_PTE_RDONLY | L_PTE_XN | L_PTE_NONE)
 #define __PAGE_SHARED		__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_XN)
 #define __PAGE_SHARED_EXEC	__pgprot(_L_PTE_DEFAULT | L_PTE_USER)
 #define __PAGE_COPY		__pgprot(_L_PTE_DEFAULT | L_PTE_USER | L_PTE_RDONLY | L_PTE_XN)
@@ -279,7 +279,7 @@ static inline pte_t pte_mkspecial(pte_t
 
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	const pteval_t mask = L_PTE_XN | L_PTE_RDONLY | L_PTE_USER;
+	const pteval_t mask = L_PTE_XN | L_PTE_RDONLY | L_PTE_USER | L_PTE_NONE;
 	pte_val(pte) = (pte_val(pte) & ~mask) | (pgprot_val(newprot) & mask);
 	return pte;
 }
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -166,6 +166,10 @@
 	tst	r1, #L_PTE_YOUNG
 	tstne	r1, #L_PTE_PRESENT
 	moveq	r3, #0
+#ifndef CONFIG_CPU_USE_DOMAINS
+	tstne	r1, #L_PTE_NONE
+	movne	r3, #0
+#endif
 
 	str	r3, [r0]
 	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -171,6 +171,10 @@ ENTRY(cpu_v7_set_pte_ext)
 
 	tst	r1, #L_PTE_YOUNG
 	tstne	r1, #L_PTE_PRESENT
+#ifndef CONFIG_CPU_USE_DOMAINS
+	eorne	r1, r1, #L_PTE_NONE
+	tstne	r1, #L_PTE_NONE
+#endif
 	moveq	r3, #0
 
  ARM(	str	r3, [r0, #2048]! )

