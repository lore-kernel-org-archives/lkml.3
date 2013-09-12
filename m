Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3ILIN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:13:59 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:62375 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3ILINz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:13:55 -0400
Message-ID: <523177B0.30203@synopsys.com>
Date: Thu, 12 Sep 2013 13:43:36 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>, Noam Camus <noamc@ezchip.com>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: ARC Fix for 3.12-rc1
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Noam found a bug in SMP bootup so it's fairly urgent. Please apply for 3.12-rc1

Thx,
-Vineet

---
>From fa9486bf1867b4e16bb03f55f0d77c68edb327e9 Mon Sep 17 00:00:00 2001
From: Noam Camus <noamc@ezchip.com>
Date: Thu, 12 Sep 2013 13:07:39 +0530
Subject: [PATCH] ARC: SMP failed to boot due to missing IVT setup

Commit 05b016ecf5e7a "ARC: Setup Vector Table Base in early boot" moved
the Interrupt vector Table setup out of arc_init_IRQ() which is called
for all CPUs, to entry point of boot cpu only, breaking booting of others.

Fix by adding the same to entry point of non-boot CPUs too.

read_arc_build_cfg_regs() printing IVT Base Register didn't help the
casue since it prints a synthetic value if zero which is totally bogus,
so fix that to print the exact Register.

[vgupta: Remove the now stale comment from header of arc_init_IRQ and
also added the commentary for halt-on-reset]

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Cc: <stable@vger.kernel.org> #3.11
Signed-off-by: Noam Camus <noamc@ezchip.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/sections.h | 1 -
 arch/arc/kernel/head.S          | 5 +++++
 arch/arc/kernel/irq.c           | 1 -
 arch/arc/kernel/setup.c         | 3 ---
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arc/include/asm/sections.h b/arch/arc/include/asm/sections.h
index 6fc1159..764f1e3 100644
--- a/arch/arc/include/asm/sections.h
+++ b/arch/arc/include/asm/sections.h
@@ -11,7 +11,6 @@

 #include <asm-generic/sections.h>

-extern char _int_vec_base_lds[];
 extern char __arc_dccm_base[];
 extern char __dtb_start[];

diff --git a/arch/arc/kernel/head.S b/arch/arc/kernel/head.S
index 2a913f8..0f944f0 100644
--- a/arch/arc/kernel/head.S
+++ b/arch/arc/kernel/head.S
@@ -34,6 +34,9 @@ stext:
 	;	IDENTITY Reg [ 3  2  1  0 ]
 	;	(cpu-id)             ^^^	=> Zero for UP ARC700
 	;					=> #Core-ID if SMP (Master 0)
+	; Note that non-boot CPUs might not land here if halt-on-reset and
+	; instead breath life from @first_lines_of_secondary, but we still
+	; need to make sure only boot cpu takes this path.
 	GET_CPU_ID  r5
 	cmp	r5, 0
 	jnz	arc_platform_smp_wait_to_boot
@@ -98,6 +101,8 @@ stext:

 first_lines_of_secondary:

+	sr	@_int_vec_base_lds, [AUX_INTR_VEC_BASE]
+
 	; setup per-cpu idle task as "current" on this CPU
 	ld	r0, [@secondary_idle_tsk]
 	SET_CURR_TASK_ON_CPU  r0, r1
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index 305b3f8..5fc9245 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -24,7 +24,6 @@
  * -Needed for each CPU (hence not foldable into init_IRQ)
  *
  * what it does ?
- * -setup Vector Table Base Reg - in case Linux not linked at 0x8000_0000
  * -Disable all IRQs (on CPU side)
  * -Optionally, setup the High priority Interrupts as Level 2 IRQs
  */
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index cd74625..d9e15f1 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -46,10 +46,7 @@ static void read_arc_build_cfg_regs(void)
 	READ_BCR(AUX_IDENTITY, cpu->core);

 	cpu->timers = read_aux_reg(ARC_REG_TIMERS_BCR);
-
 	cpu->vec_base = read_aux_reg(AUX_INTR_VEC_BASE);
-	if (cpu->vec_base == 0)
-		cpu->vec_base = (unsigned int)_int_vec_base_lds;

 	READ_BCR(ARC_REG_D_UNCACH_BCR, uncached_space);
 	cpu->uncached_base = uncached_space.start << 24;
-- 
1.8.1.2
