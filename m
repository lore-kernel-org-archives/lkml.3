Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbaJ1Fya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 01:54:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582AbaJ1DwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3.10 21/43] m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
Date: Tue, 28 Oct 2014 11:36:19 +0800
Message-Id: <20141028033524.317126810@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m68k/mm/hwtest.c |    6 ++++++
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


