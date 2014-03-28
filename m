Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaC1LOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:14:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35354 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751613AbaC1LOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:14:14 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/11] ARM: mvebu: remove the address parameter for ll_set_cpu_coherent
Date: Fri, 28 Mar 2014 12:13:22 +0100
Message-Id: <1396005211-15573-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
References: <1396005211-15573-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to deal with the MMU enabled and the MMU disabled
cases, the base address of the coherency registers was passed to the
function. The address by itself was not interesting as it can't change
for a given SoC, the only thing we need is to have a distinction
between the physical or the virtual address.

This patch add a check of the MMU bit to choose the accurate address,
then the calling function doesn't have to pass this information.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/coherency.c    |  6 +++---
 arch/arm/mach-mvebu/coherency_ll.S | 22 ++++++++++++++++++++--
 arch/arm/mach-mvebu/headsmp.S      |  9 ---------
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 4e9d58148ca7..88dd507221fc 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -30,7 +30,7 @@
 #include "coherency.h"
 
 unsigned long coherency_phys_base;
-static void __iomem *coherency_base;
+void __iomem *coherency_base;
 static void __iomem *coherency_cpu_base;
 
 /* Coherency fabric registers */
@@ -44,7 +44,7 @@ static struct of_device_id of_coherency_table[] = {
 };
 
 /* Function defined in coherency_ll.S */
-int ll_set_cpu_coherent(void __iomem *base_addr, unsigned int hw_cpu_id);
+int ll_set_cpu_coherent(unsigned int hw_cpu_id);
 
 int set_cpu_coherent(unsigned int hw_cpu_id, int smp_group_id)
 {
@@ -54,7 +54,7 @@ int set_cpu_coherent(unsigned int hw_cpu_id, int smp_group_id)
 		return 1;
 	}
 
-	return ll_set_cpu_coherent(coherency_base, hw_cpu_id);
+	return ll_set_cpu_coherent(hw_cpu_id);
 }
 
 static inline void mvebu_hwcc_sync_io_barrier(void)
diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
index ee7598fe75db..1f2bcd4b5424 100644
--- a/arch/arm/mach-mvebu/coherency_ll.S
+++ b/arch/arm/mach-mvebu/coherency_ll.S
@@ -21,13 +21,27 @@
 #define ARMADA_XP_CFB_CFG_REG_OFFSET 0x4
 
 #include <asm/assembler.h>
+#include <asm/cp15.h>
 
 	.text
 /*
- * r0: Coherency fabric base register address
- * r1: HW CPU id
+ * r0: HW CPU id
  */
 ENTRY(ll_set_cpu_coherent)
+	mrc	p15, 0, r1, c1, c0, 0
+	tst	r1, #CR_M @ Check MMU bit enabled
+	bne	1f
+
+	/* use physical address of the coherency register*/
+	adr	r0, 3f
+	ldr	r3, [r0]
+	ldr	r0, [r0, r3]
+	b	2f
+1:
+	/* use virtual address of the coherency register*/
+	ldr	r0, =coherency_base
+	ldr	r0, [r0]
+2:
 	/* Create bit by cpu index */
 	mov	r3, #(1 << 24)
 	lsl	r1, r3, r1
@@ -56,3 +70,7 @@ ARM_BE8(rev	r1, r1)
 	mov	r0, #0
 	mov	pc, lr
 ENDPROC(ll_set_cpu_coherent)
+
+	.align 2
+3:
+	.long	coherency_phys_base - .
diff --git a/arch/arm/mach-mvebu/headsmp.S b/arch/arm/mach-mvebu/headsmp.S
index 3dd80df428f7..f30bc8d78871 100644
--- a/arch/arm/mach-mvebu/headsmp.S
+++ b/arch/arm/mach-mvebu/headsmp.S
@@ -31,11 +31,6 @@
 ENTRY(armada_xp_secondary_startup)
  ARM_BE8(setend	be )			@ go BE8 if entered LE
 
-	/* Get coherency fabric base physical address */
-	adr	r0, 1f
-	ldr	r1, [r0]
-	ldr	r0, [r0, r1]
-
 	/* Read CPU id */
 	mrc     p15, 0, r1, c0, c0, 5
 	and     r1, r1, #0xF
@@ -45,7 +40,3 @@ ENTRY(armada_xp_secondary_startup)
 	b	secondary_startup
 
 ENDPROC(armada_xp_secondary_startup)
-
-	.align 2
-1:
-	.long	coherency_phys_base - .
-- 
1.8.1.2

