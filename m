Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaJ0TE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:04:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52902 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaJ0TE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 072/105] m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
Date: Mon, 27 Oct 2014 11:56:47 -0700
Message-Id: <1414436240-13879-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit e4dc601bf99ccd1c95b7e6eef1d3cf3c4b0d4961 upstream.

hwreg_present() and hwreg_write() temporarily change the VBR register to
another vector table. This table contains a valid bus error handler
only, all other entries point to arbitrary addresses.

If an interrupt comes in while the temporary table is active, the
processor will start executing at such an arbitrary address, and the
kernel will crash.

While most callers run early, before interrupts are enabled, or
explicitly disable interrupts, Finn Thain pointed out that macsonic has
one callsite that doesn't, causing intermittent boot crashes.
There's another unsafe callsite in hilkbd.

Fix this for good by disabling and restoring interrupts inside
hwreg_present() and hwreg_write().

Explicitly disabling interrupts can be removed from the callsites later.

Reported-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/m68k/mm/hwtest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/m68k/mm/hwtest.c b/arch/m68k/mm/hwtest.c
index 2c7dde3..2a5259f 100644
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

