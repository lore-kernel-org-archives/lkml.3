Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991Ab3EBUs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:48:29 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34459 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761785Ab3EBUs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:48:27 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonas Gorski <jogo@openwrt.org>
Subject: [PATCH] MIPS: Enable interrupts before WAIT instruction.
Date: Thu,  2 May 2013 13:48:12 -0700
Message-Id: <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <CA+55aFwDGyHOzu=Qh7SJOBK6QvAwAh7pMDL6LfMUE=AW_kapAw@mail.gmail.com>
References: <CA+55aFwDGyHOzu=Qh7SJOBK6QvAwAh7pMDL6LfMUE=AW_kapAw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

As noted by Thomas Gleixner:

   commit cdbedc61c8 (mips: Use generic idle loop) broke MIPS as I did
   not realize that MIPS wants to invoke the wait instructions with
   interrupts enabled.

Instead of enabling interrupts in arch_cpu_idle() as Thomas' initial
patch does, we follow Linus' suggestion of doing it in the assembly
code to prevent the compiler from rearranging things.

Signed-off-by: David Daney <david.daney@cavium.com>
Reported-by: EunBong Song <eunb.song@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonas Gorski <jogo@openwrt.org>
---

This is only very lightly tested, we need more testing before
declaring it the definitive fix.

 arch/mips/kernel/genex.S | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index ecb347c..57cda9a 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -132,12 +132,13 @@ LEAF(r4k_wait)
 	.set	noreorder
 	/* start of rollback region */
 	LONG_L	t0, TI_FLAGS($28)
-	nop
 	andi	t0, _TIF_NEED_RESCHED
 	bnez	t0, 1f
 	 nop
-	nop
-	nop
+	/* Enable interrupts so WAIT will complete */
+	mfc0	t0, CP0_STATUS
+	ori	t0, ST0_IE
+	mtc0	t0, CP0_STATUS
 	.set	mips3
 	wait
 	/* end of rollback region (the region size must be power of two) */
-- 
1.7.11.7

