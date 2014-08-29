Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaH2JOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:14:55 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36082 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaH2JOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:14:42 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v2 09/19] powerpc/8xx: Optimize verification in FixupDAR
Message-Id: <20140829091438.D8D851ABD67@localhost.localdomain>
Date: Fri, 29 Aug 2014 11:14:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By XORing the upper part of the instruction code, we get a value that can
directly be verified with the second test and we can remove the first test.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index e5a250c..5037420 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -542,10 +542,8 @@ FixupDAR:/* Entry point for dcbx workaround. */
 /* Check if it really is a dcbx instruction. */
 /* dcbt and dcbtst does not generate DTLB Misses/Errors,
  * no need to include them here */
-	srwi	r10, r11, 26	/* check if major OP code is 31 */
-	cmpwi	cr0, r10, 31
-	bne-	141f
-	rlwinm	r10, r11, 0, 21, 30
+	xoris	r10, r11, 0x7c00	/* check if major OP code is 31 */
+	rlwinm	r10, r10, 0, 21, 5
 	cmpwi	cr0, r10, 2028	/* Is dcbz? */
 	beq+	142f
 	cmpwi	cr0, r10, 940	/* Is dcbi? */
-- 
1.7.1

