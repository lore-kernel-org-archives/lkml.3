Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbbALIkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:40:42 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:39489 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbALIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:40:27 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "David S. Miller" <davem@davemloft.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 5/5] m68k/atari: Remove obsolete IRQ_TYPE_*
Date: Mon, 12 Jan 2015 09:40:21 +0100
Message-Id: <1421052021-12560-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
References: <1421052021-12560-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ_TYPE_SLOW, IRQ_TYPE_FAST, and IRQ_TYPE_PRIO are no longer used by
the Atari platform interrupt code since commit 734085651c9b80aa
("[PATCH] m68k: convert atari irq code") in v2.6.18-rc1, so drop them.

Note that their values have been reused for different purposes
(IRQ_TYPE_NONE, IRQ_TYPE_EDGE_RISING, and IRQ_TYPE_EDGE_FALLING) since
commit 6a6de9ef5850d063 ("[PATCH] genirq: core") in v2.6.18-rc1.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/atakeyb.c         | 5 ++---
 arch/m68k/atari/stdma.c           | 2 +-
 arch/m68k/atari/time.c            | 3 +--
 arch/m68k/include/asm/atariints.h | 5 -----
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 7bea01ceff55785f..264db11268039329 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -504,9 +504,8 @@ int atari_keyb_init(void)
 	kb_state.state = KEYBOARD;
 	kb_state.len = 0;
 
-	error = request_irq(IRQ_MFP_ACIA, atari_keyboard_interrupt,
-			    IRQ_TYPE_SLOW, "keyboard,mouse,MIDI",
-			    atari_keyboard_interrupt);
+	error = request_irq(IRQ_MFP_ACIA, atari_keyboard_interrupt, 0,
+			    "keyboard,mouse,MIDI", atari_keyboard_interrupt);
 	if (error)
 		return error;
 
diff --git a/arch/m68k/atari/stdma.c b/arch/m68k/atari/stdma.c
index e5a66596b116dc76..ba65f942d0c789c5 100644
--- a/arch/m68k/atari/stdma.c
+++ b/arch/m68k/atari/stdma.c
@@ -198,7 +198,7 @@ EXPORT_SYMBOL(stdma_islocked);
 void __init stdma_init(void)
 {
 	stdma_isr = NULL;
-	if (request_irq(IRQ_MFP_FDC, stdma_int, IRQ_TYPE_SLOW | IRQF_SHARED,
+	if (request_irq(IRQ_MFP_FDC, stdma_int, IRQF_SHARED,
 			"ST-DMA floppy,ACSI,IDE,Falcon-SCSI", stdma_int))
 		pr_err("Couldn't register ST-DMA interrupt\n");
 }
diff --git a/arch/m68k/atari/time.c b/arch/m68k/atari/time.c
index da8f981c36d647ea..c549b48174ec8342 100644
--- a/arch/m68k/atari/time.c
+++ b/arch/m68k/atari/time.c
@@ -32,8 +32,7 @@ atari_sched_init(irq_handler_t timer_routine)
     /* start timer C, div = 1:100 */
     st_mfp.tim_ct_cd = (st_mfp.tim_ct_cd & 15) | 0x60;
     /* install interrupt service routine for MFP Timer C */
-    if (request_irq(IRQ_MFP_TIMC, timer_routine, IRQ_TYPE_SLOW,
-		    "timer", timer_routine))
+    if (request_irq(IRQ_MFP_TIMC, timer_routine, 0, "timer", timer_routine))
 	pr_err("Couldn't register timer interrupt\n");
 }
 
diff --git a/arch/m68k/include/asm/atariints.h b/arch/m68k/include/asm/atariints.h
index 953e0ac6855eed9e..6321c44956206f00 100644
--- a/arch/m68k/include/asm/atariints.h
+++ b/arch/m68k/include/asm/atariints.h
@@ -40,11 +40,6 @@
 /* convert irq_handler index to vector number */
 #define IRQ_SOURCE_TO_VECTOR(i)	((i) + ((i) < 8 ? 0x18 : (0x40-8)))
 
-/* interrupt service types */
-#define IRQ_TYPE_SLOW     0
-#define IRQ_TYPE_FAST     1
-#define IRQ_TYPE_PRIO     2
-
 /* ST-MFP interrupts */
 #define IRQ_MFP_BUSY      (8)
 #define IRQ_MFP_DCD       (9)
-- 
1.9.1

