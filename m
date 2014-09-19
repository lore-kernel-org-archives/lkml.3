Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaISN65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:58:57 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:57507 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810AbaISN57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:57:59 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: powerpc32: rearrange instructions order in ip_fast_csum()
Message-Id: <20140919135756.DF2251AB26E@localhost.localdomain>
Date: Fri, 19 Sep 2014 15:57:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC_8xx, lwz has a 2 cycles latency, and branching also takes 2 cycles.
As the size of the header is minimum 5 words, we can unroll the loop for the
first words to reduce number of branching, and we can re-order the instructions
to limit loading latency.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/lib/checksum_32.S | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/lib/checksum_32.S b/arch/powerpc/lib/checksum_32.S
index 6d67e05..5500704 100644
--- a/arch/powerpc/lib/checksum_32.S
+++ b/arch/powerpc/lib/checksum_32.S
@@ -26,13 +26,17 @@
 _GLOBAL(ip_fast_csum)
 	lwz	r0,0(r3)
 	lwzu	r5,4(r3)
-	addic.	r4,r4,-2
+	addic.	r4,r4,-4
 	addc	r0,r0,r5
 	mtctr	r4
 	blelr-
-1:	lwzu	r4,4(r3)
-	adde	r0,r0,r4
+	lwzu	r5,4(r3)
+	lwzu	r4,4(r3)
+	adde	r0,r0,r5
+1:	adde	r0,r0,r4
+	lwzu	r4,4(r3)
 	bdnz	1b
+	adde	r0,r0,r4
 	addze	r0,r0		/* add in final carry */
 	rlwinm	r3,r0,16,0,31	/* fold two halves together */
 	add	r3,r0,r3
-- 
2.1.0

