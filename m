Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaCYWtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:49:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49827 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755873AbaCYWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:48:54 -0400
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
Subject: [PATCH v5 05/14] ARM: mvebu: Split low level functions to manipulate HW coherency
Date: Tue, 25 Mar 2014 23:48:16 +0100
Message-Id: <1395787705-31061-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
References: <1395787705-31061-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually enabling coherency and adding a CPU on a SMP group are two
different operations which can be done separately. This patch splits
this in two functions.

Moreover as they use common pattern, this patch also creates local low
level functions (ll_get_coherency_base and ll_get_cpuid) to be used by
the exposed functions (ll_add_cpu_to_smp_group and
ll_enable_coherency)

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/coherency.c    |  8 ++--
 arch/arm/mach-mvebu/coherency_ll.S | 94 +++++++++++++++++++++++++-------------
 arch/arm/mach-mvebu/headsmp.S      |  6 ++-
 3 files changed, 72 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index ad61251f7faf..6718193ebd3f 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -43,8 +43,9 @@ static struct of_device_id of_coherency_table[] = {
 	{ /* end of list */ },
 };
 
-/* Function defined in coherency_ll.S */
-int ll_set_cpu_coherent(void);
+/* Functions defined in coherency_ll.S */
+int ll_enable_coherency(void);
+void ll_add_cpu_to_smp_group(void);
 
 int set_cpu_coherent(void)
 {
@@ -54,7 +55,8 @@ int set_cpu_coherent(void)
 		return 1;
 	}
 
-	return ll_set_cpu_coherent();
+	ll_add_cpu_to_smp_group();
+	return ll_enable_coherency();
 }
 
 static inline void mvebu_hwcc_sync_io_barrier(void)
diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
index 6cb26b919787..c7179a03891d 100644
--- a/arch/arm/mach-mvebu/coherency_ll.S
+++ b/arch/arm/mach-mvebu/coherency_ll.S
@@ -24,52 +24,84 @@
 #include <asm/cp15.h>
 
 	.text
-
-ENTRY(ll_set_cpu_coherent)
+/* Returns with the coherency address in r1 (r0 is untouched)*/
+ENTRY(ll_get_coherency_base)
 	mrc	p15, 0, r1, c1, c0, 0
 	tst	r1, #CR_M @ Check MMU bit enabled
 	bne	1f
 
-	/* use physical address of the coherency register*/
-	adr	r0, 3f
-	ldr	r3, [r0]
-	ldr	r0, [r0, r3]
+	/* use physical address of the coherency register */
+	adr	r1, 3f
+	ldr	r3, [r1]
+	ldr	r1, [r1, r3]
 	b	2f
 1:
-	/* use virtual address of the coherency register*/
-	ldr	r0, =coherency_base
-	ldr	r0, [r0]
+	/* use virtual address of the coherency register */
+	ldr	r1, =coherency_base
+	ldr	r1, [r1]
 2:
-	/* Create bit by cpu index */
-	mrc	15, 0, r1, cr0, cr0, 5
-	and	r1, r1, #15
+	mov	pc, lr
+ENDPROC(ll_get_coherency_base)
+
+/* Returns with the CPU ID in r3 (r0 is untouched)*/
+ENTRY(ll_get_cpuid)
+	mrc	15, 0, r3, cr0, cr0, 5
+	and	r3, r3, #15
 	mov	r2, #(1 << 24)
-	lsl	r1, r2, r1
-	ARM_BE8(rev	r1, r1)
+	lsl	r3, r2, r3
+	ARM_BE8(rev	r3, r3)
+	mov	pc, lr
+ENDPROC(ll_get_cpuid)
 
-	/* Add CPU to SMP group - Atomic */
-	add	r3, r0, #ARMADA_XP_CFB_CTL_REG_OFFSET
-1:
-	ldrex	r2, [r3]
-	orr	r2, r2, r1
-	strex 	r0, r2, [r3]
-	cmp	r0, #0
-	bne 1b
+/* ll_add_cpu_to_smp_group, ll_enable_coherency and
+ * ll_disable_coherency use strex/ldrex whereas MMU can be off. The
+ * Armada XP SoC has an exclusive monitor that can track transactions
+ * to Device and/or SO and as such also when MMU is disabled the
+ * exclusive transactions will be functional
+ */
 
-	/* Enable coherency on CPU - Atomic */
-	add	r3, r3, #ARMADA_XP_CFB_CFG_REG_OFFSET
+ENTRY(ll_add_cpu_to_smp_group)
+	/*
+	 * r0 being untouched in ll_get_coherency_base and
+	 * ll_get_cpuid, we can use it to save lr modifing it with the
+	 * following bl
+	 */
+	mov r0, lr
+	bl	ll_get_coherency_base
+	bl	ll_get_cpuid
+	mov lr, r0
+	add	r0, r1, #ARMADA_XP_CFB_CFG_REG_OFFSET
 1:
-	ldrex	r2, [r3]
-	orr	r2, r2, r1
-	strex	r0, r2, [r3]
-	cmp	r0, #0
-	bne 1b
+	ldrex	r2, [r0]
+	orr	r2, r2, r3
+	strex	r1, r2, [r0]
+	cmp	r1, #0
+	bne	1b
+	mov	pc, lr
+ENDPROC(ll_add_cpu_to_smp_group)
 
+ENTRY(ll_enable_coherency)
+	/*
+	 * r0 being untouched in ll_get_coherency_base and
+	 * ll_get_cpuid, we can use it to save lr modifing it with the
+	 * following bl
+	 */
+	mov r0, lr
+	bl	ll_get_coherency_base
+	bl	ll_get_cpuid
+	mov lr, r0
+	add	r0, r1, #ARMADA_XP_CFB_CTL_REG_OFFSET
+1:
+	ldrex	r2, [r0]
+	orr	r2, r2, r3
+	strex	r1, r2, [r0]
+	cmp	r1, #0
+	bne	1b
 	dsb
-
 	mov	r0, #0
 	mov	pc, lr
-ENDPROC(ll_set_cpu_coherent)
+ENDPROC(ll_enable_coherency)
+
 
 	.align 2
 3:
diff --git a/arch/arm/mach-mvebu/headsmp.S b/arch/arm/mach-mvebu/headsmp.S
index cf7abe6554f7..2c4032e368ba 100644
--- a/arch/arm/mach-mvebu/headsmp.S
+++ b/arch/arm/mach-mvebu/headsmp.S
@@ -31,8 +31,10 @@
 ENTRY(armada_xp_secondary_startup)
  ARM_BE8(setend	be )			@ go BE8 if entered LE
 
-	/* Add CPU to coherency fabric */
-	bl	ll_set_cpu_coherent
+	bl	ll_add_cpu_to_smp_group
+
+	bl	ll_enable_coherency
+
 	b	secondary_startup
 
 ENDPROC(armada_xp_secondary_startup)
-- 
1.8.1.2

