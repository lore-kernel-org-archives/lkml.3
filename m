Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaDBRIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:08:20 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41880 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932516AbaDBRIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:08:16 -0400
Date: Wed, 2 Apr 2014 18:07:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joe Sylve <joe.sylve@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] AArch64: TCR_TG1_64K incorrectly sets TCR_EL1 bits
 [31:30]
Message-ID: <20140402170747.GC24018@arm.com>
References: <CAHWCVW+cH6MwhQj-JGWN63AqseFYuDPoftv+zGJU8UDfAgueEQ@mail.gmail.com>
 <20140402123844.GE31892@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402123844.GE31892@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 01:38:44PM +0100, Catalin Marinas wrote:
> On Wed, Apr 02, 2014 at 05:00:38AM +0100, Joe Sylve wrote:
> > Section D7.2.83 TCR_EL1, Translation Control Register (EL1) of the
> > latest ARM Architecture Reference Manual, ARMv8, for ARMv8-A states
> > that TCR_EL1 TG1 (bits [31:30]) should be set to 11 for a 64KB
> > TTBR1_EL1 granule size. The mainline 3.14 kernel incorrectly sets
> > those bits to 01 (which is a 16KB granule size).
> > 
> > Signed-off-by: Joe Sylve <joe.sylve@gmail.com>
> > ---
> > 
> > --- a/arch/arm64/include/asm/pgtable-hwdef.h 2014-04-01 22:13:22.619868978 -0500
> > +++ b/arch/arm64/include/asm/pgtable-hwdef.h 2014-04-01 22:13:58.071869886 -0500
> > @@ -121,7 +121,7 @@
> >  #define TCR_ORGN_MASK ((UL(3) << 10) | (UL(3) << 26))
> >  #define TCR_SHARED ((UL(3) << 12) | (UL(3) << 28))
> >  #define TCR_TG0_64K (UL(1) << 14)
> > -#define TCR_TG1_64K (UL(1) << 30)
> > +#define TCR_TG1_64K (UL(3) << 30)
> >  #define TCR_IPS_40BIT (UL(2) << 32)
> >  #define TCR_ASID16 (UL(1) << 36)
> >  #define TCR_TBI0 (UL(1) << 37)
> 
> According to the spec, 4K pages is also wrong. The strange thing is that
> it works fine on the model. I'll ask internally for clarification
> whether it's a typo in the manual or Linux needs fixing.

You scared me first but the Linux code is *correct* because it sets bit
31 to 1 in proc.S explicitly. The reason is that the code pre-dates the
16K addition to the spec where bit 31 was RES1 and TG0/TG1 were one bit
wide and had the same value. Anyway, it's worth updating the kernel as
at some point will add 16K pages support. Something like below:

--------8<---------------

>From d43ca2701b5d66ab467ba3f8db52ee02020d38a2 Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 2 Apr 2014 17:55:40 +0100
Subject: [PATCH] arm64: Update the TCR_EL1 translation granule definitions
 for 16K pages

The current TCR register setting in arch/arm64/mm/proc.S assumes that
TCR_EL1.TG* fields are one bit wide and bit 31 is RES1 (reserved, set to
1). With the addition of 16K pages (currently unsupported in the
kernel), the TCR_EL1.TG* fields have been extended to two bits. This
patch updates the corresponding Linux definitions and drops the bit 31
setting in proc.S in favour of the new macros.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Joe Sylve <joe.sylve@gmail.com>
---
 arch/arm64/include/asm/pgtable-hwdef.h |  6 +++++-
 arch/arm64/mm/proc.S                   | 25 ++++++++++++++-----------
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index f7af66b54cb2..5fc8a66c3924 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -120,8 +120,12 @@
 #define TCR_ORGN_WBnWA		((UL(3) << 10) | (UL(3) << 26))
 #define TCR_ORGN_MASK		((UL(3) << 10) | (UL(3) << 26))
 #define TCR_SHARED		((UL(3) << 12) | (UL(3) << 28))
+#define TCR_TG0_4K		(UL(0) << 14)
 #define TCR_TG0_64K		(UL(1) << 14)
-#define TCR_TG1_64K		(UL(1) << 30)
+#define TCR_TG0_16K		(UL(2) << 14)
+#define TCR_TG1_16K		(UL(1) << 30)
+#define TCR_TG1_4K		(UL(2) << 30)
+#define TCR_TG1_64K		(UL(3) << 30)
 #define TCR_ASID16		(UL(1) << 36)
 #define TCR_TBI0		(UL(1) << 37)
 
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index e085ee6ef4e2..9042aff5e9e3 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -28,14 +28,21 @@
 
 #include "proc-macros.S"
 
-#ifndef CONFIG_SMP
-/* PTWs cacheable, inner/outer WBWA not shareable */
-#define TCR_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA
+#ifdef CONFIG_ARM64_64K_PAGES
+#define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
+#else
+#define TCR_TG_FLAGS	TCR_TG0_4K | TCR_TG1_4K
+#endif
+
+#ifdef CONFIG_SMP
+#define TCR_SMP_FLAGS	TCR_SHARED
 #else
-/* PTWs cacheable, inner/outer WBWA shareable */
-#define TCR_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA | TCR_SHARED
+#define TCR_SMP_FLAGS	0
 #endif
 
+/* PTWs cacheable, inner/outer WBWA */
+#define TCR_CACHE_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA
+
 #define MAIR(attr, mt)	((attr) << ((mt) * 8))
 
 /*
@@ -209,18 +216,14 @@ ENTRY(__cpu_setup)
 	 * Set/prepare TCR and TTBR. We use 512GB (39-bit) address range for
 	 * both user and kernel.
 	 */
-	ldr	x10, =TCR_TxSZ(VA_BITS) | TCR_FLAGS | \
-		      TCR_ASID16 | TCR_TBI0 | (1 << 31)
+	ldr	x10, =TCR_TxSZ(VA_BITS) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
+			TCR_TG_FLAGS | TCR_ASID16 | TCR_TBI0
 	/*
 	 * Read the PARange bits from ID_AA64MMFR0_EL1 and set the IPS bits in
 	 * TCR_EL1.
 	 */
 	mrs	x9, ID_AA64MMFR0_EL1
 	bfi	x10, x9, #32, #3
-#ifdef CONFIG_ARM64_64K_PAGES
-	orr	x10, x10, TCR_TG0_64K
-	orr	x10, x10, TCR_TG1_64K
-#endif
 	msr	tcr_el1, x10
 	ret					// return to head.S
 ENDPROC(__cpu_setup)
