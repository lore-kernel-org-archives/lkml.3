Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaDHLUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:20:06 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:45422 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbaDHLUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:20:03 -0400
Message-ID: <5343DB50.3030805@synopsys.com>
Date: Tue, 8 Apr 2014 16:49:44 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Paul Bolle <pebolle@tiscali.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC: Remove ISS_SMP_EXTN entirely
References: <1396947368.26620.2.camel@x220>	 <C2D7FE5348E1B147BCA15975FBA230751AC602@IN01WEMBXA.internal.synopsys.com> <1396953743.26620.23.camel@x220> <C2D7FE5348E1B147BCA15975FBA230751AC680@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA230751AC680@IN01WEMBXA.internal.synopsys.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2014 04:19 PM, Vineet Gupta wrote:
> 
> I'll push a patch later today - which will hopefully hit mainline within this
> merge window - if not in one of the rcs.


Here's the patch I want to push - care to take a look.

Note that it might still seem that ISS_SMP_EXTN symbol is uselss (and alias for
SMP) because the code for SMP_EXTN_2 is still in works and will take some more
time to hit upstream. So you see the motivation of this change now ?

--------------------->
>From c7f4c1084d2563def0f5bc5dc2b1b857bc4b50f0 Mon Sep 17 00:00:00 2001
From: Vineet Gupta <vgupta@synopsys.com>
Date: Fri, 28 Feb 2014 16:13:44 +0800
Subject: [PATCH] ARC: [SMP] ISS SMP extension bitrot

* Move extension specific code out of common SMP code
* Don't enable it by default for SMP

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/irq.h       |  2 --
 arch/arc/kernel/irq.c            | 18 ------------------
 arch/arc/plat-arcfpga/Makefile   |  2 +-
 arch/arc/plat-arcfpga/platform.c |  4 ++--
 arch/arc/plat-arcfpga/smp.c      | 18 ++++++++++++++++++
 5 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index 291a70db68b8..781f57f25bd8 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -19,8 +19,6 @@
 #include <asm-generic/irq.h>

 extern void arc_init_IRQ(void);
-extern int get_hw_config_num_irq(void);
-
 void arc_local_timer_setup(unsigned int cpu);

 #endif
diff --git a/arch/arc/kernel/irq.c b/arch/arc/kernel/irq.c
index a4b141ee9a6a..7d653c0d0773 100644
--- a/arch/arc/kernel/irq.c
+++ b/arch/arc/kernel/irq.c
@@ -150,24 +150,6 @@ void arch_do_IRQ(unsigned int irq, struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }

-int get_hw_config_num_irq(void)
-{
-	uint32_t val = read_aux_reg(ARC_REG_VECBASE_BCR);
-
-	switch (val & 0x03) {
-	case 0:
-		return 16;
-	case 1:
-		return 32;
-	case 2:
-		return 8;
-	default:
-		return 0;
-	}
-
-	return 0;
-}
-
 /*
  * arch_local_irq_enable - Enable interrupts.
  *
diff --git a/arch/arc/plat-arcfpga/Makefile b/arch/arc/plat-arcfpga/Makefile
index a44e22ebc1b7..4d1bddc34b5b 100644
--- a/arch/arc/plat-arcfpga/Makefile
+++ b/arch/arc/plat-arcfpga/Makefile
@@ -9,4 +9,4 @@
 KBUILD_CFLAGS	+= -Iarch/arc/plat-arcfpga/include

 obj-y := platform.o irq.o
-obj-$(CONFIG_SMP)		+= smp.o
+obj-$(CONFIG_ISS_SMP_EXTN)		+= smp.o
diff --git a/arch/arc/plat-arcfpga/platform.c b/arch/arc/plat-arcfpga/platform.c
index 19b76b61f44b..213394a15cd2 100644
--- a/arch/arc/plat-arcfpga/platform.c
+++ b/arch/arc/plat-arcfpga/platform.c
@@ -169,7 +169,7 @@ static void __init plat_fpga_early_init(void)

 	arc_fpga_serial_init();

-#ifdef CONFIG_SMP
+#ifdef CONFIG_ISS_SMP_EXTN
 	iss_model_init_early_smp();
 #endif
 }
@@ -211,7 +211,7 @@ MACHINE_START(ANGEL4, "angel4")
 	.init_early	= plat_fpga_early_init,
 	.init_machine	= plat_fpga_populate_dev,
 	.init_irq	= plat_fpga_init_IRQ,
-#ifdef CONFIG_SMP
+#ifdef CONFIG_ISS_SMP_EXTN
 	.init_smp	= iss_model_init_smp,
 #endif
 MACHINE_END
diff --git a/arch/arc/plat-arcfpga/smp.c b/arch/arc/plat-arcfpga/smp.c
index 8a12741f5f7a..92bad9122077 100644
--- a/arch/arc/plat-arcfpga/smp.c
+++ b/arch/arc/plat-arcfpga/smp.c
@@ -42,6 +42,24 @@ static void iss_model_smp_wakeup_cpu(int cpu, unsigned long pc)

 }

+static inline int get_hw_config_num_irq(void)
+{
+	uint32_t val = read_aux_reg(ARC_REG_VECBASE_BCR);
+
+	switch (val & 0x03) {
+	case 0:
+		return 16;
+	case 1:
+		return 32;
+	case 2:
+		return 8;
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
 /*
  * Any SMP specific init any CPU does when it comes up.
  * Here we setup the CPU to enable Inter-Processor-Interrupts
-- 
1.8.3.2



