Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab3BTVec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:34:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50418 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab3BTVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:34:31 -0500
Date: Wed, 20 Feb 2013 16:34:23 -0500 (EST)
Message-Id: <20130220.163423.1512055704917729172.davem@davemloft.net>
To: mroos@linux.ee
Cc: rientjes@google.com, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1302201437190.20165@math.ut.ee>
References: <20130219.144608.1425049879680985441.davem@davemloft.net>
	<20130220.014137.1184382041985855584.davem@davemloft.net>
	<alpine.SOC.1.00.1302201437190.20165@math.ut.ee>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Feb 2013 13:34:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 20 Feb 2013 15:35:52 +0200 (EET)

> Works much better. aptitude worked fine, as did 5 times
> cp -a linux test; rm -r linux
> 
> However, "git gc" in a copy of the repository hung the machine hard, 
> nothing in the logs.
> 
> 3.8.0 with THP disabled can run both cp;rm and git gc several 
> times without a problem.

Ok, I think this patch will fix the problem, at least it fixes
"git gc" crashes for me on UltraSPARC-IIIi:

====================
[PATCH] sparc64: Fix huge PMD to PTE translation for sun4u in TLB miss handler.

When we set the sun4u version of the PTE execute bit, it's:

	or	REG, _PAGE_EXEC_4U, REG

_PAGE_EXEC_4U is 0x1000, unfortunately the immedate field of the
'or' instruction is a signed 13-bit value.  So the above actually
assembles into:

	or	REG, -4096, REG

completely corrupting the final PTE value.

Set it with a:

	sethi	%hi(_PAGE_EXEC_4U), TMP
	or	REG, TMP, REG

sequence instead.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/tsb.h | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/tsb.h b/arch/sparc/include/asm/tsb.h
index b4c258d..e696432 100644
--- a/arch/sparc/include/asm/tsb.h
+++ b/arch/sparc/include/asm/tsb.h
@@ -157,17 +157,26 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, __tsb_phys_patch_end;
 	andn		REG2, 0x7, REG2; \
 	add		REG1, REG2, REG1;
 
-	/* This macro exists only to make the PMD translator below easier
-	 * to read.  It hides the ELF section switch for the sun4v code
-	 * patching.
+	/* These macros exists only to make the PMD translator below
+	 * easier to read.  It hides the ELF section switch for the
+	 * sun4v code patching.
 	 */
-#define OR_PTE_BIT(REG, NAME)				\
+#define OR_PTE_BIT_1INSN(REG, NAME)			\
 661:	or		REG, _PAGE_##NAME##_4U, REG;	\
 	.section	.sun4v_1insn_patch, "ax";	\
 	.word		661b;				\
 	or		REG, _PAGE_##NAME##_4V, REG;	\
 	.previous;
 
+#define OR_PTE_BIT_2INSN(REG, TMP, NAME)		\
+661:	sethi		%hi(_PAGE_##NAME##_4U), TMP;	\
+	or		REG, TMP, REG;			\
+	.section	.sun4v_2insn_patch, "ax";	\
+	.word		661b;				\
+	mov		-1, TMP;			\
+	or		REG, _PAGE_##NAME##_4V, REG;	\
+	.previous;
+
 	/* Load into REG the PTE value for VALID, CACHE, and SZHUGE.  */
 #define BUILD_PTE_VALID_SZHUGE_CACHE(REG)				   \
 661:	sethi		%uhi(_PAGE_VALID|_PAGE_SZHUGE_4U), REG;		   \
@@ -214,12 +223,13 @@ extern struct tsb_phys_patch_entry __tsb_phys_patch, __tsb_phys_patch_end;
 	 andn		REG1, PMD_HUGE_PROTBITS, REG2;			      \
 	sllx		REG2, PMD_PADDR_SHIFT, REG2;			      \
 	/* REG2 now holds PFN << PAGE_SHIFT */				      \
-	andcc		REG1, PMD_HUGE_EXEC, %g0;			      \
-	bne,a,pt	%xcc, 1f;					      \
-	 OR_PTE_BIT(REG2, EXEC);					      \
-1:	andcc		REG1, PMD_HUGE_WRITE, %g0;			      \
+	andcc		REG1, PMD_HUGE_WRITE, %g0;			      \
 	bne,a,pt	%xcc, 1f;					      \
-	 OR_PTE_BIT(REG2, W);						      \
+	 OR_PTE_BIT_1INSN(REG2, W);					      \
+1:	andcc		REG1, PMD_HUGE_EXEC, %g0;			      \
+	be,pt		%xcc, 1f;					      \
+	 nop;								      \
+	OR_PTE_BIT_2INSN(REG2, REG1, EXEC);				      \
 	/* REG1 can now be clobbered, build final PTE */		      \
 1:	BUILD_PTE_VALID_SZHUGE_CACHE(REG1);				      \
 	ba,pt		%xcc, PTE_LABEL;				      \
-- 
1.8.1.2

