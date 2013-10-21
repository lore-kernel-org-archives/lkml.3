Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3JUIwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:52:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39700 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754056Ab3JUIwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Anton Blanchard" <anton@samba.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.608207689@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 098/149] powerpc: Restore registers on error exit from
 csum_partial_copy_generic()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

commit 8f21bd0090052e740944f9397e2be5ac7957ded7 upstream.

The csum_partial_copy_generic() function saves the PowerPC non-volatile
r14, r15, and r16 registers for the main checksum-and-copy loop.
Unfortunately, it fails to restore them upon error exit from this loop,
which results in silent corruption of these registers in the presumably
rare event of an access exception within that loop.

This commit therefore restores these register on error exit from the loop.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[bwh: Backported to 3.2: register name macros use lower-case 'r']
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/lib/checksum_64.S | 54 +++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 14 deletions(-)

--- a/arch/powerpc/lib/checksum_64.S
+++ b/arch/powerpc/lib/checksum_64.S
@@ -229,19 +229,35 @@ _GLOBAL(csum_partial)
 	blr
 
 
-	.macro source
+	.macro srcnr
 100:
 	.section __ex_table,"a"
 	.align 3
-	.llong 100b,.Lsrc_error
+	.llong 100b,.Lsrc_error_nr
 	.previous
 	.endm
 
-	.macro dest
+	.macro source
+150:
+	.section __ex_table,"a"
+	.align 3
+	.llong 150b,.Lsrc_error
+	.previous
+	.endm
+
+	.macro dstnr
 200:
 	.section __ex_table,"a"
 	.align 3
-	.llong 200b,.Ldest_error
+	.llong 200b,.Ldest_error_nr
+	.previous
+	.endm
+
+	.macro dest
+250:
+	.section __ex_table,"a"
+	.align 3
+	.llong 250b,.Ldest_error
 	.previous
 	.endm
 
@@ -277,11 +293,11 @@ _GLOBAL(csum_partial_copy_generic)
 	mtctr	r6
 
 1:
-source;	lhz	r6,0(r3)		/* align to doubleword */
+srcnr;	lhz	r6,0(r3)		/* align to doubleword */
 	subi	r5,r5,2
 	addi	r3,r3,2
 	adde	r0,r0,r6
-dest;	sth	r6,0(r4)
+dstnr;	sth	r6,0(r4)
 	addi	r4,r4,2
 	bdnz	1b
 
@@ -395,10 +411,10 @@ dest;	std	r16,56(r4)
 
 	mtctr	r6
 3:
-source;	ld	r6,0(r3)
+srcnr;	ld	r6,0(r3)
 	addi	r3,r3,8
 	adde	r0,r0,r6
-dest;	std	r6,0(r4)
+dstnr;	std	r6,0(r4)
 	addi	r4,r4,8
 	bdnz	3b
 
@@ -408,10 +424,10 @@ dest;	std	r6,0(r4)
 	srdi.	r6,r5,2
 	beq	.Lcopy_tail_halfword
 
-source;	lwz	r6,0(r3)
+srcnr;	lwz	r6,0(r3)
 	addi	r3,r3,4
 	adde	r0,r0,r6
-dest;	stw	r6,0(r4)
+dstnr;	stw	r6,0(r4)
 	addi	r4,r4,4
 	subi	r5,r5,4
 
@@ -419,10 +435,10 @@ dest;	stw	r6,0(r4)
 	srdi.	r6,r5,1
 	beq	.Lcopy_tail_byte
 
-source;	lhz	r6,0(r3)
+srcnr;	lhz	r6,0(r3)
 	addi	r3,r3,2
 	adde	r0,r0,r6
-dest;	sth	r6,0(r4)
+dstnr;	sth	r6,0(r4)
 	addi	r4,r4,2
 	subi	r5,r5,2
 
@@ -430,10 +446,10 @@ dest;	sth	r6,0(r4)
 	andi.	r6,r5,1
 	beq	.Lcopy_finish
 
-source;	lbz	r6,0(r3)
+srcnr;	lbz	r6,0(r3)
 	sldi	r9,r6,8			/* Pad the byte out to 16 bits */
 	adde	r0,r0,r9
-dest;	stb	r6,0(r4)
+dstnr;	stb	r6,0(r4)
 
 .Lcopy_finish:
 	addze	r0,r0			/* add in final carry */
@@ -443,6 +459,11 @@ dest;	stb	r6,0(r4)
 	blr
 
 .Lsrc_error:
+	ld	r14,STK_REG(r14)(r1)
+	ld	r15,STK_REG(r15)(r1)
+	ld	r16,STK_REG(r16)(r1)
+	addi	r1,r1,STACKFRAMESIZE
+.Lsrc_error_nr:
 	cmpdi	0,r7,0
 	beqlr
 	li	r6,-EFAULT
@@ -450,6 +471,11 @@ dest;	stb	r6,0(r4)
 	blr
 
 .Ldest_error:
+	ld	r14,STK_REG(r14)(r1)
+	ld	r15,STK_REG(r15)(r1)
+	ld	r16,STK_REG(r16)(r1)
+	addi	r1,r1,STACKFRAMESIZE
+.Ldest_error_nr:
 	cmpdi	0,r8,0
 	beqlr
 	li	r6,-EFAULT

