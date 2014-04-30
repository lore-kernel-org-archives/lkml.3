Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaD3Cy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:54:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60996 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaD3Cy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:54:28 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Joel Fernandes <joelf@ti.com>, Dave Martin <Dave.Martin@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Nishanth Menon <nm@ti.com>,
        "open list:OMAP SUPPORT" <linux-omap@vger.kernel.org>,
        "moderated list:ARM SUB-ARCHITECT..." 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: OMAP5: Redo THUMB mode switch on secondary CPU
Date: Tue, 29 Apr 2014 21:53:47 -0500
Message-ID: <1398826427-17200-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a redo of the patch [1] that effectively does the same
thing but is the right way to do things by using ENDPROC instead.
The firmware correctly switches to THUMB before entry.

The patch applies ontop of the earlier patch [1].

[1] https://lkml.org/lkml/2014/4/22/1044

Suggested-by: Dave Martin <Dave.Martin@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Joel Fernandes <joelf@ti.com>
---

Tony, the earlier patch went into your fixes, and can remain. This patch is just a simple redo of the same and can go in for v3.16, no problem. Thanks.

 arch/arm/mach-omap2/omap-headsmp.S |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-headsmp.S b/arch/arm/mach-omap2/omap-headsmp.S
index 1809dce..bf36f26 100644
--- a/arch/arm/mach-omap2/omap-headsmp.S
+++ b/arch/arm/mach-omap2/omap-headsmp.S
@@ -31,10 +31,6 @@
  * register AuxCoreBoot0.
  */
 ENTRY(omap5_secondary_startup)
-.arm
-THUMB( adr     r9, BSYM(wait)  )       @ CPU may be entered in ARM mode.
-THUMB( bx      r9              )       @ If this is a Thumb-2 kernel,
-THUMB( .thumb                  )       @ switch to Thumb now.
 wait:	ldr	r2, =AUX_CORE_BOOT0_PA	@ read from AuxCoreBoot0
 	ldr	r0, [r2]
 	mov	r0, r0, lsr #5
@@ -43,7 +39,7 @@ wait:	ldr	r2, =AUX_CORE_BOOT0_PA	@ read from AuxCoreBoot0
 	cmp	r0, r4
 	bne	wait
 	b	secondary_startup
-END(omap5_secondary_startup)
+ENDPROC(omap5_secondary_startup)
 /*
  * OMAP4 specific entry point for secondary CPU to jump from ROM
  * code.  This routine also provides a holding flag into which
-- 
1.7.9.5

