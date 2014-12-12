Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbaLLGX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:23:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51806 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759457AbaLLGRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:12 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Finn Thain" <fthain@telegraphics.com.au>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.163741933@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 043/164] m68k: Disable/restore interrupts in
 hwreg_present()/hwreg_write()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m68k/mm/hwtest.c | 6 ++++++
 1 file changed, 6 insertions(+)

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
@@ -78,6 +83,7 @@ int hwreg_write( volatile void *regp, un
 		: "=&d" (ret), "=&r" (save_sp), "=&r" (save_vbr)
 		: "a" (regp), "a" (tmp_vectors), "g" (val)
 	);
+	local_irq_restore(flags);
 
 	return( ret );
 }

