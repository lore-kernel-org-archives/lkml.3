Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967451Ab3HIB6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967372Ab3HIB63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 012/102] ARM: 7784/1: mm: ensure SMP alternates assemble to exactly 4 bytes with Thumb-2
Date: Thu,  8 Aug 2013 18:56:48 -0700
Message-Id: <20130809015013.107731780@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit bf3f0f332f76a85ff3a0b393aaded5a8533769c0 upstream.

Commit ae8a8b9553bd ("ARM: 7691/1: mm: kill unused TLB_CAN_READ_FROM_L1_CACHE
and use ALT_SMP instead") added early function returns for page table
cache flushing operations on ARMv7 SMP CPUs.

Unfortunately, when targetting Thumb-2, these `mov pc, lr' sequences
assemble to 2 bytes which can lead to corruption of the instruction
stream after code patching.

This patch fixes the alternates to use wide (32-bit) instructions for
Thumb-2, therefore ensuring that the patching code works correctly.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/proc-v7-2level.S |    2 +-
 arch/arm/mm/proc-v7-3level.S |    2 +-
 arch/arm/mm/proc-v7.S        |   11 ++++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -110,7 +110,7 @@ ENTRY(cpu_v7_set_pte_ext)
  ARM(	str	r3, [r0, #2048]! )
  THUMB(	add	r0, r0, #2048 )
  THUMB(	str	r3, [r0] )
-	ALT_SMP(mov	pc,lr)
+	ALT_SMP(W(nop))
 	ALT_UP (mcr	p15, 0, r0, c7, c10, 1)		@ flush_pte
 #endif
 	mov	pc, lr
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -73,7 +73,7 @@ ENTRY(cpu_v7_set_pte_ext)
 	tst	r3, #1 << (55 - 32)		@ L_PTE_DIRTY
 	orreq	r2, #L_PTE_RDONLY
 1:	strd	r2, r3, [r0]
-	ALT_SMP(mov	pc, lr)
+	ALT_SMP(W(nop))
 	ALT_UP (mcr	p15, 0, r0, c7, c10, 1)		@ flush_pte
 #endif
 	mov	pc, lr
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -75,13 +75,14 @@ ENTRY(cpu_v7_do_idle)
 ENDPROC(cpu_v7_do_idle)
 
 ENTRY(cpu_v7_dcache_clean_area)
-	ALT_SMP(mov	pc, lr)			@ MP extensions imply L1 PTW
-	ALT_UP(W(nop))
-	dcache_line_size r2, r3
-1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
+	ALT_SMP(W(nop))			@ MP extensions imply L1 PTW
+	ALT_UP_B(1f)
+	mov	pc, lr
+1:	dcache_line_size r2, r3
+2:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
 	add	r0, r0, r2
 	subs	r1, r1, r2
-	bhi	1b
+	bhi	2b
 	dsb
 	mov	pc, lr
 ENDPROC(cpu_v7_dcache_clean_area)


