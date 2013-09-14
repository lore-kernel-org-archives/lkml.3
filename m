Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3INGbJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 02:31:09 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57196 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3INGbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 02:31:07 -0400
Date: Sat, 14 Sep 2013 10:31:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org, mingo@elte.hu,
        tglx@linutronix.de, Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] mm: Unify pte_to_pgoff and pgoff_to_pte helpers
Message-ID: <20130914063103.GA1761@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use unified pte_bitop helper to manipulate bits in pte/pgoff bitfield,
and convert pte_to_pgoff/pgoff_to_pte to inlines.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/pgtable-2level.h |  100 ++++++++++++++++++++--------------
 1 file changed, 59 insertions(+), 41 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/pgtable-2level.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/pgtable-2level.h
+++ linux-2.6.git/arch/x86/include/asm/pgtable-2level.h
@@ -55,6 +55,13 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+/* Bit manipulation helper on pte/pgoff entry */
+static inline unsigned long pte_bitop(unsigned long value, unsigned int rightshift,
+				      unsigned long mask, unsigned int leftshift)
+{
+	return ((value >> rightshift) & mask) << leftshift;
+}
+
 #ifdef CONFIG_MEM_SOFT_DIRTY
 
 /*
@@ -71,31 +78,34 @@ static inline pmd_t native_pmdp_get_and_
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 #define PTE_FILE_BITS3		(PTE_FILE_SHIFT4 - PTE_FILE_SHIFT3 - 1)
 
-#define pte_to_pgoff(pte)						\
-	((((pte).pte_low >> (PTE_FILE_SHIFT1))				\
-	  & ((1U << PTE_FILE_BITS1) - 1)))				\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT2))			\
-	    & ((1U << PTE_FILE_BITS2) - 1))				\
-	   << (PTE_FILE_BITS1))						\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT3))			\
-	    & ((1U << PTE_FILE_BITS3) - 1))				\
-	   << (PTE_FILE_BITS1 + PTE_FILE_BITS2))			\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT4)))			\
-	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3))
-
-#define pgoff_to_pte(off)						\
-	((pte_t) { .pte_low =						\
-	 ((((off)) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
-	 + ((((off) >> PTE_FILE_BITS1)					\
-	     & ((1U << PTE_FILE_BITS2) - 1))				\
-	    << PTE_FILE_SHIFT2)						\
-	 + ((((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
-	     & ((1U << PTE_FILE_BITS3) - 1))				\
-	    << PTE_FILE_SHIFT3)						\
-	 + ((((off) >>							\
-	      (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)))	\
-	    << PTE_FILE_SHIFT4)						\
-	 + _PAGE_FILE })
+#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
+#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
+#define PTE_FILE_MASK3		((1U << PTE_FILE_BITS3) - 1)
+
+#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
+#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
+#define PTE_FILE_LSHIFT4	(PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)
+
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3, PTE_FILE_MASK3,  PTE_FILE_LSHIFT3) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT4,           -1UL,  PTE_FILE_LSHIFT4));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bitop(off, PTE_FILE_LSHIFT3, PTE_FILE_MASK3,  PTE_FILE_SHIFT3) +
+			pte_bitop(off, PTE_FILE_LSHIFT4,           -1UL,  PTE_FILE_SHIFT4) +
+			_PAGE_FILE,
+	};
+}
 
 #else /* CONFIG_MEM_SOFT_DIRTY */
 
@@ -115,22 +125,30 @@ static inline pmd_t native_pmdp_get_and_
 #define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 
-#define pte_to_pgoff(pte)						\
-	((((pte).pte_low >> PTE_FILE_SHIFT1)				\
-	  & ((1U << PTE_FILE_BITS1) - 1))				\
-	 + ((((pte).pte_low >> PTE_FILE_SHIFT2)				\
-	     & ((1U << PTE_FILE_BITS2) - 1)) << PTE_FILE_BITS1)		\
-	 + (((pte).pte_low >> PTE_FILE_SHIFT3)				\
-	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2)))
-
-#define pgoff_to_pte(off)						\
-	((pte_t) { .pte_low =						\
-	 (((off) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
-	 + ((((off) >> PTE_FILE_BITS1) & ((1U << PTE_FILE_BITS2) - 1))	\
-	    << PTE_FILE_SHIFT2)						\
-	 + (((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
-	    << PTE_FILE_SHIFT3)						\
-	 + _PAGE_FILE })
+#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
+#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
+
+#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
+#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
+
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3,           -1UL,  PTE_FILE_LSHIFT3));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bitop(off, PTE_FILE_LSHIFT3,           -1UL,  PTE_FILE_SHIFT3) +
+			_PAGE_FILE,
+	};
+}
 
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
