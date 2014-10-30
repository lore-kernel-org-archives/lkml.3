Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbaJ3Lkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:40:41 -0400
Received: from down.free-electrons.com ([37.187.137.238]:50027 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758827AbaJ3Ljw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:39:52 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] ARM: mvebu: Move SCU power up in a function
Date: Thu, 30 Oct 2014 12:39:42 +0100
Message-Id: <1414669184-16785-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow reusing the same function in the secondary_startup
for the Cortex A9 SoC.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/pmsu_ll.S | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-mvebu/pmsu_ll.S b/arch/arm/mach-mvebu/pmsu_ll.S
index a945756cfb45..83d014698314 100644
--- a/arch/arm/mach-mvebu/pmsu_ll.S
+++ b/arch/arm/mach-mvebu/pmsu_ll.S
@@ -12,6 +12,18 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
+
+ENTRY(armada_38x_scu_power_up)
+	mrc     p15, 4, r1, c15, c0	@ get SCU base address
+	orr	r1, r1, #0x8		@ SCU CPU Power Status Register
+	mrc	15, 0, r0, cr0, cr0, 5	@ get the CPU ID
+	and	r0, r0, #15
+	add	r1, r1, r0
+	mov	r0, #0x0
+	strb	r0, [r1]		@ switch SCU power state to Normal mode
+	ret	lr
+ENDPROC(armada_38x_scu_power_up)
+
 /*
  * This is the entry point through which CPUs exiting cpuidle deep
  * idle state are going.
@@ -27,13 +39,7 @@ ENTRY(armada_38x_cpu_resume)
 	/* do we need it for Armada 38x*/
 ARM_BE8(setend	be )			@ go BE8 if entered LE
 	bl	v7_invalidate_l1
-	mrc     p15, 4, r1, c15, c0	@ get SCU base address
-	orr	r1, r1, #0x8		@ SCU CPU Power Status Register
-	mrc	15, 0, r0, cr0, cr0, 5	@ get the CPU ID
-	and	r0, r0, #15
-	add	r1, r1, r0
-	mov	r0, #0x0
-	strb	r0, [r1]		@ switch SCU power state to Normal mode
+	bl	armada_38x_scu_power_up
 	b	cpu_resume
 ENDPROC(armada_38x_cpu_resume)
 
-- 
1.9.1

