Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762324AbbA1FQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:16:03 -0500
Received: from mail.kernel.org ([198.145.29.136]:37974 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933828AbbA1ERF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:17:05 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 039/177] m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
Date: Wed, 28 Jan 2015 12:07:25 +0800
Message-Id: <1422418236-12852-78-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
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

