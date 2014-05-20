Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaETRzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:55:53 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:64791 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750826AbaETRzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:55:52 -0400
Message-ID: <1400608550.4912.48.camel@x220>
Subject: [PATCH] powerpc: remove checks for CONFIG_BOOK3E_MMU_TLB_STATS
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 20 May 2014 19:55:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 May 2014 17:55:51.0064 (UTC) FILETIME=[BCCCB180:01CF7454]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three checks for CONFIG_BOOK3E_MMU_TLB_STATS were added in v2.6.32. But
the related Kconfig symbol was never added. These checks have always
evaluated to false. Remove them.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

A second order cleanup is now possible (ie, TLB_MISS_PROLOG_STATS and
friends are, well, defined away). Perhaps it is preferable to include
that cleanup in this patch.

 arch/powerpc/include/asm/exception-64e.h | 38 --------------------------------
 arch/powerpc/mm/tlb_low_64e.S            | 10 ---------
 2 files changed, 48 deletions(-)

diff --git a/arch/powerpc/include/asm/exception-64e.h b/arch/powerpc/include/asm/exception-64e.h
index a563d9afd179..74004771baed 100644
--- a/arch/powerpc/include/asm/exception-64e.h
+++ b/arch/powerpc/include/asm/exception-64e.h
@@ -69,14 +69,7 @@
 #define EX_TLB_ESR	( 9 * 8) /* Level 0 and 2 only */
 #define EX_TLB_SRR0	(10 * 8)
 #define EX_TLB_SRR1	(11 * 8)
-#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
-#define EX_TLB_R8	(12 * 8)
-#define EX_TLB_R9	(13 * 8)
-#define EX_TLB_LR	(14 * 8)
-#define EX_TLB_SIZE	(15 * 8)
-#else
 #define EX_TLB_SIZE	(12 * 8)
-#endif
 
 #define	START_EXCEPTION(label)						\
 	.globl exc_##label##_book3e;					\
@@ -161,36 +154,6 @@ exc_##label##_book3e:
 	addi	r11,r13,PACA_EXTLB;					    \
 	TLB_MISS_RESTORE(r11)
 
-#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
-#define TLB_MISS_PROLOG_STATS						    \
-	mflr	r10;							    \
-	std	r8,EX_TLB_R8(r12);					    \
-	std	r9,EX_TLB_R9(r12);					    \
-	std	r10,EX_TLB_LR(r12);
-#define TLB_MISS_RESTORE_STATS					            \
-	ld	r16,EX_TLB_LR(r12);					    \
-	ld	r9,EX_TLB_R9(r12);					    \
-	ld	r8,EX_TLB_R8(r12);					    \
-	mtlr	r16;
-#define TLB_MISS_STATS_D(name)						    \
-	addi	r9,r13,MMSTAT_DSTATS+name;				    \
-	bl	.tlb_stat_inc;
-#define TLB_MISS_STATS_I(name)						    \
-	addi	r9,r13,MMSTAT_ISTATS+name;				    \
-	bl	.tlb_stat_inc;
-#define TLB_MISS_STATS_X(name)						    \
-	ld	r8,PACA_EXTLB+EX_TLB_ESR(r13);				    \
-	cmpdi	cr2,r8,-1;						    \
-	beq	cr2,61f;						    \
-	addi	r9,r13,MMSTAT_DSTATS+name;				    \
-	b	62f;							    \
-61:	addi	r9,r13,MMSTAT_ISTATS+name;				    \
-62:	bl	.tlb_stat_inc;
-#define TLB_MISS_STATS_SAVE_INFO					    \
-	std	r14,EX_TLB_ESR(r12);	/* save ESR */
-#define TLB_MISS_STATS_SAVE_INFO_BOLTED					    \
-	std	r14,PACA_EXTLB+EX_TLB_ESR(r13);	/* save ESR */
-#else
 #define TLB_MISS_PROLOG_STATS
 #define TLB_MISS_RESTORE_STATS
 #define TLB_MISS_PROLOG_STATS_BOLTED
@@ -201,7 +164,6 @@ exc_##label##_book3e:
 #define TLB_MISS_STATS_Y(name)
 #define TLB_MISS_STATS_SAVE_INFO
 #define TLB_MISS_STATS_SAVE_INFO_BOLTED
-#endif
 
 #define SET_IVOR(vector_number, vector_offset)	\
 	li	r3,vector_offset@l; 		\
diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64e.S
index 356e8b41fb09..7e25fe472801 100644
--- a/arch/powerpc/mm/tlb_low_64e.S
+++ b/arch/powerpc/mm/tlb_low_64e.S
@@ -1159,13 +1159,3 @@ tlb_load_linear_fault:
 	b	exc_data_storage_book3e
 1:	TLB_MISS_EPILOG_ERROR_SPECIAL
 	b	exc_instruction_storage_book3e
-
-
-#ifdef CONFIG_BOOK3E_MMU_TLB_STATS
-.tlb_stat_inc:
-1:	ldarx	r8,0,r9
-	addi	r8,r8,1
-	stdcx.	r8,0,r9
-	bne-	1b
-	blr
-#endif
-- 
1.9.0

