Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaLATVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:21:53 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36197 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117AbaLATVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:21:52 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Chris Zhong <zyw@rock-chips.com>
Cc: Kevin Hilman <khilman@linaro.org>, Sonny Rao <sonnyrao@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, russ.dill@gmail.com,
        olof@lixom.net, Doug Anderson <dianders@chromium.org>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: rockchip: Convert resume code to C
Date: Mon,  1 Dec 2014 11:21:34 -0800
Message-Id: <1417461694-5129-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This CL introduces the concept of "embedded blobs" for Rockchip, which
allows you to compile some C code into a binary blob that is linked
into the kernel.  This binary blob is self contained and is intended
to run in cases where SDRAM (and thus the rest of Linux) isn't
available.  Resume is a prime candiate for this as is the planned
DDRFreq code.

We convert the existing assembly resume code into C as proof that this
works and to prepare for linking in SDRAM reinit code.

At the moment suspend/resume is only implemented for rk3288 and I'm
told that suspend/resume on older Rockchip variants is very limited
(can't shut off the ARM?), so I haven't tried to make this generic.
When we have more than one Rockchip SoC doing S2R we can adjust.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
A few ground rules...

I'm aware of the patches from Russ Dill adding support for Embeddable
PIE [0], but I have chosen not to try to take over those patches or
base my patch atop them.  Why?

1. The selfish reason that I just don't have time to try to address
   all comments and land an 11-part patch series that's been sitting
   idle for 1+ years.

2. Dave Martin had some good questions about the embedded PIE patches
   [1] that made me question whether they were the right away to go.
   Among other things he pointed out similarities between them and the
   preexsiting module loader.

3. This code is small, simple, and I think it matches the approach
   taken elsewhere in the kernel for things like the decompressor stub.

I could certainly expect that others might not agree with my decision
and I'm half expecting a NAK of this patch asking for me to come up
with a more general solution.  As you could probably guess from #1
above, I won't be upset by such a response but it will lead to me
dropping this patch.  ;) Minor or even medium-sized requests will be
happily addressed, however.

OK, with that out of the way...

These patches are based atop v10 of Chris Zhong's Rockchip
suspend/resume patches.  They were tested atop next-20141201 on
rk3288-evb-rk808.  Total patches atop that version of Linux were:

1. https://patchwork.kernel.org/patch/5051881/ - clocksource:
   arch_timer: Allow the device tree to specify uninitialized timer
   registers

2. https://patchwork.kernel.org/patch/5363671/ - clocksource:
   arch_timer: Fix code to use physical timers when requested

3. https://patchwork.kernel.org/patch/5382141/ - ARM: dts: rk3288: add
   arm,cpu-registers-not-fw-configured

4. Revert (b77d439 ARM: dts: rockchip: temporarily disable smp on
   rk3288)

5. https://patchwork.kernel.org/patch/5325111/ - usb: dwc2: resume
   root hub when device detect with suspend state

6. https://patchwork.kernel.org/patch/5410611/ - ARM: rockchip: add
   suspend and resume for RK3288

7. https://patchwork.kernel.org/patch/5410621/ - ARM: rockchip: Add
   pmu-sram binding

8. https://patchwork.kernel.org/patch/5410631/ - ARM: dts: add RK3288
   suspend support

9. https://patchwork.kernel.org/patch/5410641/ - ARM: dts: rockchip:
   add suspend settings for rk3288-evb-rk808

It looks like my pinctrl patches might be dropped due to cross
dependency problems, so tomorrow's linux-next will probably also need
(https://patchwork.kernel.org/patch/5344551/ - pinctrl: rockchip:
Handle wakeup pins).

I've also got a local hack to the Rockchip "pm.c" to replace the usage
of "PMU_ARMINT_WAKEUP_EN" with 0x0e.  There seems to be some sort of
ARM Interrupt waking us up all the time right when we go to sleep and
the above will hack it so that only GPIOs + SDMMC Card Detect can wake
us up.  Someone should track down what's going on there, but for now
I've used the hack to prove that the basic code actually works.  The
issue happens both with and without my patch.

[0]: https://lkml.org/lkml/2013/9/17/193
[1]: https://lkml.org/lkml/2013/11/8/351

 arch/arm/mach-rockchip/Makefile                    |  4 +-
 arch/arm/mach-rockchip/embedded/.gitignore         |  1 +
 arch/arm/mach-rockchip/embedded/Makefile           | 53 +++++++++++++
 arch/arm/mach-rockchip/embedded/rk3288_resume.c    | 92 ++++++++++++++++++++++
 arch/arm/mach-rockchip/embedded/rk3288_resume.h    | 44 +++++++++++
 .../arm/mach-rockchip/embedded/rk3288_resume.lds.S | 40 ++++++++++
 .../embedded/rk3288_resume_embedded.h              | 17 ++++
 arch/arm/mach-rockchip/pm.c                        | 37 ++++++---
 arch/arm/mach-rockchip/pm.h                        |  8 --
 arch/arm/mach-rockchip/sleep.S                     | 73 -----------------
 10 files changed, 275 insertions(+), 94 deletions(-)
 create mode 100644 arch/arm/mach-rockchip/embedded/.gitignore
 create mode 100644 arch/arm/mach-rockchip/embedded/Makefile
 create mode 100644 arch/arm/mach-rockchip/embedded/rk3288_resume.c
 create mode 100644 arch/arm/mach-rockchip/embedded/rk3288_resume.h
 create mode 100644 arch/arm/mach-rockchip/embedded/rk3288_resume.lds.S
 create mode 100644 arch/arm/mach-rockchip/embedded/rk3288_resume_embedded.h
 delete mode 100644 arch/arm/mach-rockchip/sleep.S

diff --git a/arch/arm/mach-rockchip/Makefile b/arch/arm/mach-rockchip/Makefile
index 5c3a9b2..ad2b56e 100644
--- a/arch/arm/mach-rockchip/Makefile
+++ b/arch/arm/mach-rockchip/Makefile
@@ -1,5 +1,7 @@
 CFLAGS_platsmp.o := -march=armv7-a
 
 obj-$(CONFIG_ARCH_ROCKCHIP) += rockchip.o
-obj-$(CONFIG_PM_SLEEP) += pm.o sleep.o
+obj-$(CONFIG_PM_SLEEP) += pm.o
 obj-$(CONFIG_SMP) += headsmp.o platsmp.o
+
+obj-y += embedded/
diff --git a/arch/arm/mach-rockchip/embedded/.gitignore b/arch/arm/mach-rockchip/embedded/.gitignore
new file mode 100644
index 0000000..84709d7
--- /dev/null
+++ b/arch/arm/mach-rockchip/embedded/.gitignore
@@ -0,0 +1 @@
+rk3288_resume.lds
diff --git a/arch/arm/mach-rockchip/embedded/Makefile b/arch/arm/mach-rockchip/embedded/Makefile
new file mode 100644
index 0000000..2e5a253
--- /dev/null
+++ b/arch/arm/mach-rockchip/embedded/Makefile
@@ -0,0 +1,53 @@
+# Makefile for embedded code blobs for Rockchip SoCs
+#
+# These code blobs are emedded into vmlinux and copied into SRAM
+# at times when SDRAM is not available.  Each blob is self contained.
+#
+# Some blobs may be linked to expect to run at a very specific address.
+# A good example is resume code blobs that always expect to run in a
+# very specific bit of SRAM that keeps power during sleep.  This code
+# is also running with the cache off so it can predict the address it
+# will be at.
+#
+# Other blobs may be linked with -fpic (by adding CFLAGS_file.o := -fpic).
+# These can be located anywhere.  I believe gcc will support this by
+# assuming that the .text and .data sections are relative to each other.
+#
+# That brings up the point that all blobs here:
+# - Are generally very small
+# - Generally have code and data jammed together in one blob.
+# - Generally have "parameters" at the beginning that are filled in by
+#   the kernel.
+
+obj-$(CONFIG_PM_SLEEP) += rk3288_resume.bin.o
+
+targets := rk3288_resume.o \
+	rk3288_resume.elf rk3288_resume.lds \
+	rk3288_resume.bin rk3288_resume.bin.o
+
+# Reset objcopy flags, ARM puts "-O binary" here.
+OBJCOPYFLAGS :=
+
+# Our embedded code can't handle this flag.
+ifeq ($(CONFIG_FUNCTION_TRACER),y)
+ORIG_CFLAGS := $(KBUILD_CFLAGS)
+KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
+endif
+
+KBUILD_CFLAGS += -fno-stack-protector
+
+# This is the ELF for the embedded binary
+LDFLAGS_rk3288_resume.elf := -Bstatic -nostdlib -T
+$(obj)/rk3288_resume.elf: $(obj)/rk3288_resume.lds $(obj)/rk3288_resume.o \
+			  FORCE
+	$(call if_changed,ld)
+
+# Create binary data for the kernel
+OBJCOPYFLAGS_rk3288_resume.bin := -O binary
+$(obj)/rk3288_resume.bin: $(obj)/rk3288_resume.elf FORCE
+	$(call if_changed,objcopy)
+
+# Import the data into the kernel
+OBJCOPYFLAGS_rk3288_resume.bin.o += -B $(ARCH) -I binary -O elf32-littlearm
+$(obj)/rk3288_resume.bin.o: $(obj)/rk3288_resume.bin FORCE
+	$(call if_changed,objcopy)
diff --git a/arch/arm/mach-rockchip/embedded/rk3288_resume.c b/arch/arm/mach-rockchip/embedded/rk3288_resume.c
new file mode 100644
index 0000000..997f874
--- /dev/null
+++ b/arch/arm/mach-rockchip/embedded/rk3288_resume.c
@@ -0,0 +1,92 @@
+/*
+ * Rockchip rk3288 resume code
+ *
+ * This code is intended to be linked into the embedded resume binary
+ * for the rk3288 SoC
+ *
+ * Copyright (c) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+
+#include "rk3288_resume.h"
+#include "rk3288_resume_embedded.h"
+
+#define INIT_CPSR	(PSR_I_BIT | PSR_F_BIT | SVC_MODE)
+
+static __noreturn void rk3288_resume(void);
+
+/* Parameters of early board initialization in SPL */
+struct rk3288_resume_params rk3288_resume_params
+		__attribute__((section(".resume_params"))) = {
+	.resume_loc	= rk3288_resume,
+};
+
+/**
+ * rk3288_resume_c - Main C entry point for rk3288 at resume time
+ *
+ * This function is called by rk3288_resume() and does the brunt of
+ * any resume processing.  After it's done it will call the kernel's
+ * cpu_resume() function (which it finds through its params structure).
+ *
+ * At the time this function is called:
+ * - We know we're on CPU0.
+ * - Interrupts are disabled.
+ * - We've got a stack.
+ * - The cache is turned off, so all addresses are physical.
+ * - SDRAM hasn't been restored yet (if it was off).
+ *
+ * WARNING: This code, the stack and the params structure are all sitting in
+ * PMU SRAM.  If you try to write to that memory using an 8-bit access (or even
+ * 16-bit) you'll get an imprecise data abort and it will be very hard to debug.
+ * Keep everything in here as 32-bit wide and aligned.  YOU'VE BEEN WARNED.
+ */
+static void __noreturn rk3288_resume_c(void)
+{
+	if (rk3288_resume_params.l2ctlr_f)
+		asm("mcr p15, 1, %0, c9, c0, 2" : :
+			"r" (rk3288_resume_params.l2ctlr));
+
+	rk3288_resume_params.cpu_resume();
+}
+
+/**
+ * rk3288_resume - First entry point for rk3288 at resume time
+ *
+ * A pointer to this function is stored in rk3288_resume_params.  The
+ * kernel uses the pointer in that structure to find this function and
+ * to put its (physical) address in a location that it will get jumped
+ * to at resume time.
+ *
+ * There is no stack at the time this function is called, so this
+ * function is in charge of setting it up.  We get to a function with
+ * a normal stack pointer ASAP.
+ */
+static void __naked __noreturn rk3288_resume(void)
+{
+	/* Make sure we're on CPU0, no IRQs and get a stack setup */
+	asm volatile (
+			"msr	cpsr_cxf, %0\n"
+
+			/* Only cpu0 continues to run, the others halt here */
+			"mrc	p15, 0, r1, c0, c0, 5\n"
+			"and	r1, r1, #0xf\n"
+			"cmp	r1, #0\n"
+			"beq	cpu0run\n"
+		"secondary_loop:\n"
+			"wfe\n"
+			"b	secondary_loop\n"
+
+		"cpu0run:\n"
+			"mov	sp, %1\n"
+		:
+		: "i" (INIT_CPSR), "r" (&__stack_start)
+		: "cc", "r1", "sp");
+
+	/* Now get into a normal function that can use a stack */
+	rk3288_resume_c();
+}
diff --git a/arch/arm/mach-rockchip/embedded/rk3288_resume.h b/arch/arm/mach-rockchip/embedded/rk3288_resume.h
new file mode 100644
index 0000000..9d3cfc6
--- /dev/null
+++ b/arch/arm/mach-rockchip/embedded/rk3288_resume.h
@@ -0,0 +1,44 @@
+/*
+ * Rockchip resume header (API from kernel to embedded code)
+ *
+ * Copyright (c) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_ROCKCHIP_RK3288_RESUME_H
+#define __MACH_ROCKCHIP_RK3288_RESUME_H
+
+/**
+ * rk3288_resume_params - Parameter space for the resume code
+ *
+ * This structure is at the start of the resume blob and is used to communicate
+ * between the resume blob and the callers.
+ *
+ * WARNING: This structure is sitting in PMU SRAM.  If you try to write to that
+ * memory using an 8-bit access (or even 16-bit) you'll get an imprecise data
+ * abort and it will be very hard to debug.  Keep everything in here as 32-bit
+ * wide and aligned.  YOU'VE BEEN WARNED.
+ *
+ * @resume_loc:		The value here should be the resume address that the CPU
+ *			is programmed to go to at resume time.
+ *
+ * @l2ctlr_f:		If non-zero we'll set l2ctlr at resume time.
+ * @l2ctlr:		The value to set l2ctlr to at resume time.
+ *
+ * @cpu_resume:		The function to jump to when we're all done.
+ */
+struct rk3288_resume_params {
+	/* This is compiled in and can be read to find the resume location */
+	__noreturn void (*resume_loc)(void);
+
+	/* Filled in by the client of the resume code */
+	u32 l2ctlr_f;		/* u32 not bool to avoid 8-bit SRAM access */
+	u32 l2ctlr;
+
+	__noreturn void (*cpu_resume)(void);
+};
+
+#endif /* __MACH_ROCKCHIP_RK3288_RESUME_H */
diff --git a/arch/arm/mach-rockchip/embedded/rk3288_resume.lds.S b/arch/arm/mach-rockchip/embedded/rk3288_resume.lds.S
new file mode 100644
index 0000000..0643169
--- /dev/null
+++ b/arch/arm/mach-rockchip/embedded/rk3288_resume.lds.S
@@ -0,0 +1,40 @@
+MEMORY {
+	pmu_sram_code  : ORIGIN = 0xff720000, LENGTH = 0xf00
+	pmu_sram_stack : ORIGIN = 0xff720f00, LENGTH = 0x100
+}
+
+OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
+OUTPUT_ARCH(arm)
+
+SECTIONS
+{
+	/* Don't need unwind tables */
+	/DISCARD/ : {
+		*(.ARM.exidx*)
+		*(.ARM.extab*)
+	}
+
+	/* Kernel code finds params because it knows they are first */
+	.params : { *(.resume_params*) } > pmu_sram_code
+	. = ALIGN(4);
+
+	.text : { *(.text*) } > pmu_sram_code
+	. = ALIGN(4);
+
+	.rodata : { *(SORT_BY_ALIGNMENT(.rodata*)) } > pmu_sram_code
+	. = ALIGN(4);
+
+	.data : {
+		*(SORT_BY_ALIGNMENT(.data*))
+		. = ALIGN(4);
+
+		/* We purposely put bss as part of data to avoid initting */
+		*(SORT_BY_ALIGNMENT(.bss*))
+		. = ALIGN(4);
+	} > pmu_sram_code
+
+	.stack : {
+		. += LENGTH(pmu_sram_stack) - 8;
+		__stack_start = .;
+	} > pmu_sram_stack
+}
diff --git a/arch/arm/mach-rockchip/embedded/rk3288_resume_embedded.h b/arch/arm/mach-rockchip/embedded/rk3288_resume_embedded.h
new file mode 100644
index 0000000..923d88a
--- /dev/null
+++ b/arch/arm/mach-rockchip/embedded/rk3288_resume_embedded.h
@@ -0,0 +1,17 @@
+/*
+ * Rockchip resume header (API between files in embedded code)
+ *
+ * Copyright (c) 2014 Google, Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_ROCKCHIP_RK3288_RESUME_EMBEDDED_H
+#define __MACH_ROCKCHIP_RK3288_RESUME_EMBEDDED_H
+
+/* Defined in the linker script */
+extern u32 *__stack_start;
+
+#endif /* __MACH_ROCKCHIP_RK3288_RESUME_EMBEDDED_H */
diff --git a/arch/arm/mach-rockchip/pm.c b/arch/arm/mach-rockchip/pm.c
index 50cb781..f213caa 100644
--- a/arch/arm/mach-rockchip/pm.c
+++ b/arch/arm/mach-rockchip/pm.c
@@ -28,6 +28,7 @@
 #include <asm/suspend.h>
 
 #include "pm.h"
+#include "embedded/rk3288_resume.h"
 
 /* These enum are option of low power mode */
 enum {
@@ -57,17 +58,33 @@ static inline u32 rk3288_l2_config(void)
 	return l2ctlr;
 }
 
-static void rk3288_config_bootdata(void)
+static void __init rk3288_init_pmu_sram(void)
 {
-	rkpm_bootdata_cpusp = rk3288_bootram_phy + (SZ_4K - 8);
-	rkpm_bootdata_cpu_code = virt_to_phys(cpu_resume);
+	extern char _binary_arch_arm_mach_rockchip_embedded_rk3288_resume_bin_start;
+	extern char _binary_arch_arm_mach_rockchip_embedded_rk3288_resume_bin_end;
+	u32 size = &_binary_arch_arm_mach_rockchip_embedded_rk3288_resume_bin_end -
+		   &_binary_arch_arm_mach_rockchip_embedded_rk3288_resume_bin_start;
+	struct rk3288_resume_params *params;
 
-	rkpm_bootdata_l2ctlr_f  = 1;
-	rkpm_bootdata_l2ctlr = rk3288_l2_config();
+	/* move resume code and data to PMU sram */
+	memcpy(rk3288_bootram_base,
+	       &_binary_arch_arm_mach_rockchip_embedded_rk3288_resume_bin_start,
+	       size);
+
+	/* setup the params that we know at boot time */
+	params = (struct rk3288_resume_params *)rk3288_bootram_base;
+
+	params->cpu_resume = (void *)virt_to_phys(cpu_resume);
+
+	params->l2ctlr_f = 1;
+	params->l2ctlr = rk3288_l2_config();
 }
 
 static void rk3288_slp_mode_set(int level)
 {
+	struct rk3288_resume_params *params =
+		(struct rk3288_resume_params *)rk3288_bootram_base;
+
 	u32 mode_set, mode_set1;
 
 	regmap_read(sgrf_regmap, RK3288_SGRF_SOC_CON0, &rk3288_sgrf_soc_con0);
@@ -81,7 +98,7 @@ static void rk3288_slp_mode_set(int level)
 
 	/* booting address of resuming system is from this register value */
 	regmap_write(sgrf_regmap, RK3288_SGRF_FAST_BOOT_ADDR,
-		     rk3288_bootram_phy);
+		     (u32)params->resume_loc);
 
 	regmap_write(pmu_regmap, RK3288_PMU_WAKEUP_CFG1,
 		     PMU_ARMINT_WAKEUP_EN);
@@ -162,7 +179,7 @@ static void rk3288_suspend_finish(void)
 		pr_err("%s: Suspend finish failed\n", __func__);
 }
 
-static int rk3288_suspend_init(struct device_node *np)
+static int __init rk3288_suspend_init(struct device_node *np)
 {
 	struct device_node *sram_np;
 	struct resource res;
@@ -203,11 +220,7 @@ static int rk3288_suspend_init(struct device_node *np)
 
 	of_node_put(sram_np);
 
-	rk3288_config_bootdata();
-
-	/* copy resume code and data to bootsram */
-	memcpy(rk3288_bootram_base, rockchip_slp_cpu_resume,
-	       rk3288_bootram_sz);
+	rk3288_init_pmu_sram();
 
 	return 0;
 }
diff --git a/arch/arm/mach-rockchip/pm.h b/arch/arm/mach-rockchip/pm.h
index 99722d0..0d1f127 100644
--- a/arch/arm/mach-rockchip/pm.h
+++ b/arch/arm/mach-rockchip/pm.h
@@ -15,14 +15,6 @@
 #ifndef __MACH_ROCKCHIP_PM_H
 #define __MACH_ROCKCHIP_PM_H
 
-extern unsigned long rkpm_bootdata_cpusp;
-extern unsigned long rkpm_bootdata_cpu_code;
-extern unsigned long rkpm_bootdata_l2ctlr_f;
-extern unsigned long rkpm_bootdata_l2ctlr;
-extern unsigned long rkpm_bootdata_ddr_code;
-extern unsigned long rkpm_bootdata_ddr_data;
-extern unsigned long rk3288_bootram_sz;
-
 void rockchip_slp_cpu_resume(void);
 void __init rockchip_suspend_init(void);
 
diff --git a/arch/arm/mach-rockchip/sleep.S b/arch/arm/mach-rockchip/sleep.S
deleted file mode 100644
index 2eec9a3..0000000
--- a/arch/arm/mach-rockchip/sleep.S
+++ /dev/null
@@ -1,73 +0,0 @@
-/*
- * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
- * Author: Tony Xie <tony.xie@rock-chips.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- */
-
-#include <linux/linkage.h>
-#include <asm/assembler.h>
-#include <asm/memory.h>
-
-.data
-/*
- * this code will be copied from
- * ddr to sram for system resumeing.
- * so it is ".data section".
- */
-.align
-
-ENTRY(rockchip_slp_cpu_resume)
-	setmode	PSR_I_BIT | PSR_F_BIT | SVC_MODE, r1  @ set svc, irqs off
-	mrc	p15, 0, r1, c0, c0, 5
-	and	r1, r1, #0xf
-	cmp	r1, #0
-	/* olny cpu0 can continue to run, the others is halt here */
-	beq	cpu0run
-secondary_loop:
-	wfe
-	b	secondary_loop
-cpu0run:
-	ldr	r3, rkpm_bootdata_l2ctlr_f
-	cmp	r3, #0
-	beq	sp_set
-	ldr	r3, rkpm_bootdata_l2ctlr
-	mcr	p15, 1, r3, c9, c0, 2
-sp_set:
-	ldr	sp, rkpm_bootdata_cpusp
-	ldr	r1, rkpm_bootdata_cpu_code
-	bx	r1
-ENDPROC(rockchip_slp_cpu_resume)
-
-/* Parameters filled in by the kernel */
-
-/* Flag for whether to restore L2CTLR on resume */
-	.global rkpm_bootdata_l2ctlr_f
-rkpm_bootdata_l2ctlr_f:
-	.long 0
-
-/* Saved L2CTLR to restore on resume */
-	.global rkpm_bootdata_l2ctlr
-rkpm_bootdata_l2ctlr:
-	.long 0
-
-/* CPU resume SP addr */
-	.globl rkpm_bootdata_cpusp
-rkpm_bootdata_cpusp:
-	.long 0
-
-/* CPU resume function (physical address) */
-	.globl rkpm_bootdata_cpu_code
-rkpm_bootdata_cpu_code:
-	.long 0
-
-ENTRY(rk3288_bootram_sz)
-        .word   . - rockchip_slp_cpu_resume
-- 
2.2.0.rc0.207.ga3a616c

