Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbaIOVAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:00:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbaIOT1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Burton <paul.burton@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3.16 075/158] MIPS: Malta: EVA: Rename eva_entry to platform_eva_init
Date: Mon, 15 Sep 2014 12:25:14 -0700
Message-Id: <20140915192545.151324529@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit ca4d24f7954f3746742ba350c2276ff777f21173 upstream.

Rename 'eva_entry' to 'platform_eva_init' as required by the new
'eva_init' macro in the eva.h header. Since this macro is now used
in a platform dependent way, it must not depend on its caller so move
the t1 register initialization inside this macro. Also set the .reorder
assembler option in case the caller may have previously set .noreorder.
This may allow a few assembler optimizations. Finally include missing
headers and document the register usage for this macro.

Reviewed-by: Paul Burton <paul.burton@imgtec.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: http://patchwork.linux-mips.org/patch/7423/
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/mach-malta/kernel-entry-init.h |   22 +++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/mips/include/asm/mach-malta/kernel-entry-init.h
+++ b/arch/mips/include/asm/mach-malta/kernel-entry-init.h
@@ -10,14 +10,15 @@
 #ifndef __ASM_MACH_MIPS_KERNEL_ENTRY_INIT_H
 #define __ASM_MACH_MIPS_KERNEL_ENTRY_INIT_H
 
+#include <asm/regdef.h>
+#include <asm/mipsregs.h>
+
 	/*
 	 * Prepare segments for EVA boot:
 	 *
 	 * This is in case the processor boots in legacy configuration
 	 * (SI_EVAReset is de-asserted and CONFIG5.K == 0)
 	 *
-	 * On entry, t1 is loaded with CP0_CONFIG
-	 *
 	 * ========================= Mappings =============================
 	 * Virtual memory           Physical memory           Mapping
 	 * 0x00000000 - 0x7fffffff  0x80000000 - 0xfffffffff   MUSUK (kuseg)
@@ -30,12 +31,20 @@
 	 *
 	 *
 	 * Lowmem is expanded to 2GB
+	 *
+	 * The following code uses the t0, t1, t2 and ra registers without
+	 * previously preserving them.
+	 *
 	 */
-	.macro	eva_entry
+	.macro	platform_eva_init
+
+	.set	push
+	.set	reorder
 	/*
 	 * Get Config.K0 value and use it to program
 	 * the segmentation registers
 	 */
+	mfc0    t1, CP0_CONFIG
 	andi	t1, 0x7 /* CCA */
 	move	t2, t1
 	ins	t2, t1, 16, 3
@@ -77,6 +86,8 @@
 	mtc0    t0, $16, 5
 	sync
 	jal	mips_ihb
+
+	.set	pop
 	.endm
 
 	.macro	kernel_entry_setup
@@ -95,7 +106,7 @@
 	sll     t0, t0, 6   /* SC bit */
 	bgez    t0, 9f
 
-	eva_entry
+	platform_eva_init
 	b       0f
 9:
 	/* Assume we came from YAMON... */
@@ -127,8 +138,7 @@ nonsc_processor:
 #ifdef CONFIG_EVA
 	sync
 	ehb
-	mfc0    t1, CP0_CONFIG
-	eva_entry
+	platform_eva_init
 #endif
 	.endm
 


