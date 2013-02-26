Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab3B0BFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:05:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760197Ab3BZX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:57:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Meelis Roos <mroos@linux.ee>, "David S. Miller" <davem@davemloft.net>
Subject: [ 063/150] sparc64: Fix huge PMD to PTE translation for sun4u in TLB miss handler.
Date: Tue, 26 Feb 2013 15:55:20 -0800
Message-Id: <20130226235530.745628251@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 76968ad2eac6456270353de168b21f04f4b3d1d3 ]

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

This fixes "git gc" crashes on sun4u machines.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/tsb.h |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/arch/sparc/include/asm/tsb.h
+++ b/arch/sparc/include/asm/tsb.h
@@ -157,17 +157,26 @@ extern struct tsb_phys_patch_entry __tsb
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
@@ -214,12 +223,13 @@ extern struct tsb_phys_patch_entry __tsb
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


