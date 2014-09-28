Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaI1J0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:26:39 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:54495 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbaI1J0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:26:35 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>, linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/5] m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
Date: Sun, 28 Sep 2014 11:26:21 +0200
Message-Id: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwreg_present() and hwreg_write() temporarily change the VBR register to
another vector table. This table contains a valid bus error handler
only, all other entries point to arbitrary addresses.

If an interrupt comes in while the temporary table is active, the
processor will start executing at such an arbitrary address, and the
kernel will crash.

While most callers run early, before interrupt are disabled, or
explicitly disable interrupts, Finn Thain pointed out that macsonic has
one callsite that doesn't, causing intermittent boot crashes.
There's another unsafe callsite in hilkbd.

Fix this for good by disabling and restoring interrupts inside
hwreg_present() and hwreg_write().

Explicitly disabling interrupts can be removed from the callsites later.

Reported-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org
---
 arch/m68k/mm/hwtest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/m68k/mm/hwtest.c b/arch/m68k/mm/hwtest.c
index 2c7dde3c6430fc3b..2a5259fd23ebc532 100644
--- a/arch/m68k/mm/hwtest.c
+++ b/arch/m68k/mm/hwtest.c
@@ -28,9 +28,11 @@
 int hwreg_present( volatile void *regp )
 {
     int	ret = 0;
+    unsigned long flags;
     long	save_sp, save_vbr;
     long	tmp_vectors[3];
 
+    local_irq_save(flags);
     __asm__ __volatile__
 	(	"movec	%/vbr,%2\n\t"
 		"movel	#Lberr1,%4@(8)\n\t"
@@ -46,6 +48,7 @@ int hwreg_present( volatile void *regp )
 		: "=&d" (ret), "=&r" (save_sp), "=&r" (save_vbr)
 		: "a" (regp), "a" (tmp_vectors)
                 );
+    local_irq_restore(flags);
 
     return( ret );
 }
@@ -58,9 +61,11 @@ EXPORT_SYMBOL(hwreg_present);
 int hwreg_write( volatile void *regp, unsigned short val )
 {
 	int		ret;
+	unsigned long flags;
 	long	save_sp, save_vbr;
 	long	tmp_vectors[3];
 
+	local_irq_save(flags);
 	__asm__ __volatile__
 	(	"movec	%/vbr,%2\n\t"
 		"movel	#Lberr2,%4@(8)\n\t"
@@ -78,6 +83,7 @@ int hwreg_write( volatile void *regp, unsigned short val )
 		: "=&d" (ret), "=&r" (save_sp), "=&r" (save_vbr)
 		: "a" (regp), "a" (tmp_vectors), "g" (val)
 	);
+	local_irq_restore(flags);
 
 	return( ret );
 }
-- 
1.9.1

