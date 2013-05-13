Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab3EMU4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:56:53 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40610 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3EMU4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:56:51 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, "Steven J. Hill" <Steven.Hill@imgtec.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] Revert "MIPS: microMIPS: Support dynamic ASID sizing."
Date: Mon, 13 May 2013 13:56:43 -0700
Message-Id: <1368478604-14732-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This reverts commit f6b06d9361a008afb93b97fb3683a6e92d69d0f4.

The next revert depends on this one, so this has to go too.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/mm/tlbex.c | 34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 4d46d37..2ad41e9 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -309,32 +309,13 @@ static int check_for_high_segbits __cpuinitdata;
 static void __cpuinit insn_fixup(unsigned int **start, unsigned int **stop,
 					unsigned int i_const)
 {
-	unsigned int **p;
+	unsigned int **p, *ip;
 
 	for (p = start; p < stop; p++) {
-#ifndef CONFIG_CPU_MICROMIPS
-		unsigned int *ip;
-
 		ip = *p;
 		*ip = (*ip & 0xffff0000) | i_const;
-#else
-		unsigned short *ip;
-
-		ip = ((unsigned short *)((unsigned int)*p - 1));
-		if ((*ip & 0xf000) == 0x4000) {
-			*ip &= 0xfff1;
-			*ip |= (i_const << 1);
-		} else if ((*ip & 0xf000) == 0x6000) {
-			*ip &= 0xfff1;
-			*ip |= ((i_const >> 2) << 1);
-		} else {
-			ip++;
-			*ip = i_const;
-		}
-#endif
-		local_flush_icache_range((unsigned long)ip,
-					 (unsigned long)ip + sizeof(*ip));
 	}
+	local_flush_icache_range((unsigned long)*p, (unsigned long)((*p) + 1));
 }
 
 #define asid_insn_fixup(section, const)					\
@@ -354,14 +335,6 @@ static void __cpuinit setup_asid(unsigned int inc, unsigned int mask,
 	extern asmlinkage void handle_ri_rdhwr_vivt(void);
 	unsigned long *vivt_exc;
 
-#ifdef CONFIG_CPU_MICROMIPS
-	/*
-	 * Worst case optimised microMIPS addiu instructions support
-	 * only a 3-bit immediate value.
-	 */
-	if(inc > 7)
-		panic("Invalid ASID increment value!");
-#endif
 	asid_insn_fixup(__asid_inc, inc);
 	asid_insn_fixup(__asid_mask, mask);
 	asid_insn_fixup(__asid_version_mask, version_mask);
@@ -369,9 +342,6 @@ static void __cpuinit setup_asid(unsigned int inc, unsigned int mask,
 
 	/* Patch up the 'handle_ri_rdhwr_vivt' handler. */
 	vivt_exc = (unsigned long *) &handle_ri_rdhwr_vivt;
-#ifdef CONFIG_CPU_MICROMIPS
-	vivt_exc = (unsigned long *)((unsigned long) vivt_exc - 1);
-#endif
 	vivt_exc++;
 	*vivt_exc = (*vivt_exc & ~mask) | mask;
 
-- 
1.7.11.7

