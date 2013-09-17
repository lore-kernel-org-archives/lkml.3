Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3IQMoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:44:54 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34263 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3IQMoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:16 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 11/11] ARM: OMAP2+: AM33XX: Basic suspend resume support
Date: Tue, 17 Sep 2013 05:43:37 -0700
Message-Id: <1379421817-15759-12-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Bedia <vaibhav.bedia@ti.com>

AM335x supports various low power modes as documented
in section 8.1.4.3 of the AM335x TRM which is available
@ http://www.ti.com/litv/pdf/spruh73f

DeepSleep0 mode offers the lowest power mode with limited
wakeup sources without a system reboot and is mapped as
the suspend state in the kernel. In this state, MPU and
PER domains are turned off with the internal RAM held in
retention to facilitate resume process. As part of the boot
process, the assembly code is copied over to OCMCRAM using
the OMAP SRAM code.

AM335x has a Cortex-M3 (WKUP_M3) which assists the MPU
in DeepSleep0 entry and exit. WKUP_M3 takes care of the
clockdomain and powerdomain transitions based on the
intended low power state. MPU needs to load the appropriate
WKUP_M3 binary onto the WKUP_M3 memory space before it can
leverage any of the PM features like DeepSleep.

The IPC mechanism between MPU and WKUP_M3 uses a mailbox
sub-module and 8 IPC registers in the Control module. MPU
uses the assigned Mailbox for issuing an interrupt to
WKUP_M3 which then goes and checks the IPC registers for
the payload. WKUP_M3 has the ability to trigger on interrupt
to MPU by executing the "sev" instruction.

In the current implementation when the suspend process
is initiated MPU interrupts the WKUP_M3 to let it know about
the intent of entering DeepSleep0 and waits for an ACK. When
the ACK is received MPU continues with its suspend process
to suspend all the drivers and then jumps to assembly in
OCMC RAM. The assembly code puts the PLLs in bypass, puts the
external RAM in self-refresh mode and then finally execute the
WFI instruction. Execution of the WFI instruction triggers another
interrupt to the WKUP_M3 which then continues wiht the power down
sequence wherein the clockdomain and powerdomain transition takes
place. As part of the sleep sequence, WKUP_M3 unmasks the interrupt
lines for the wakeup sources. WFI execution on WKUP_M3 causes the
hardware to disable the main oscillator of the SoC.

When a wakeup event occurs, WKUP_M3 starts the power-up
sequence by switching on the power domains and finally
enabling the clock to MPU. Since the MPU gets powered down
as part of the sleep sequence in the resume path ROM code
starts executing. The ROM code detects a wakeup from sleep
and then jumps to the resume location in OCMC which was
populated in one of the IPC registers as part of the suspend
sequence.

The low level code in OCMC relocks the PLLs, enables access
to external RAM and then jumps to the cpu_resume code of
the kernel to finish the resume process.

Signed-off-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Cc: Tony Lingren <tony@atomide.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Benoit Cousson <benoit.cousson@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/mach-omap2/Kconfig         |   7 +-
 arch/arm/mach-omap2/Makefile        |   2 +
 arch/arm/mach-omap2/board-generic.c |   1 +
 arch/arm/mach-omap2/common.h        |  10 +
 arch/arm/mach-omap2/io.c            |   5 +
 arch/arm/mach-omap2/pm.c            |   3 +-
 arch/arm/mach-omap2/pm33xx.c        | 486 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/pm33xx.h        |  68 +++++
 arch/arm/mach-omap2/sleep33xx.c     | 314 +++++++++++++++++++++++
 arch/arm/mach-omap2/wkup_m3.c       | 183 ++++++++++++++
 10 files changed, 1076 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-omap2/pm33xx.c
 create mode 100644 arch/arm/mach-omap2/pm33xx.h
 create mode 100644 arch/arm/mach-omap2/sleep33xx.c
 create mode 100644 arch/arm/mach-omap2/wkup_m3.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 3eed000..ef3fe40 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -67,11 +67,14 @@ config SOC_OMAP5
 config SOC_AM33XX
 	bool "AM33XX support"
 	depends on ARCH_MULTI_V7
-	select ARCH_OMAP2PLUS
+	default y
 	select ARM_CPU_SUSPEND if PM
+	select COMMON_CLK
 	select CPU_V7
+	select MAILBOX if PM
 	select MULTI_IRQ_HANDLER
-	select COMMON_CLK
+	select OMAP_MBOX_FWK if PM
+	select OMAP2PLUS_MBOX if PM
 
 config SOC_AM43XX
 	bool "TI AM43x"
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index d4f6715..42442c4 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_ARCH_OMAP2)		+= sleep24xx.o
 obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o
 obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o omap-mpuss-lowpower.o
 obj-$(CONFIG_SOC_OMAP5)			+= omap-mpuss-lowpower.o
+obj-$(CONFIG_SOC_AM33XX)		+= pm33xx.o sleep33xx.o wkup_m3.o
 obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
 
 obj-$(CONFIG_POWER_AVS_OMAP)		+= sr_device.o
@@ -94,6 +95,7 @@ obj-$(CONFIG_POWER_AVS_OMAP_CLASS3)    += smartreflex-class3.o
 
 AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
 AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
+CFLAGS_sleep33xx.o			:=-march=armv7-a
 
 endif
 
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index aed750c..3f2d6a7 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -159,6 +159,7 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
 	.reserve	= am33xx_reserve,
 	.map_io		= am33xx_map_io,
 	.init_early	= am33xx_init_early,
+	.init_late	= am33xx_init_late,
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 6b8ef74..80bf0da 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -69,6 +69,15 @@ static inline int omap4_pm_init(void)
 }
 #endif
 
+#if defined(CONFIG_PM) && defined(CONFIG_SOC_AM33XX)
+int am33xx_pm_init(void);
+#else
+static inline int am33xx_pm_init(void)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_OMAP_MUX
 int omap_mux_late_init(void);
 #else
@@ -107,6 +116,7 @@ void omap2430_init_late(void);
 void omap3430_init_late(void);
 void omap35xx_init_late(void);
 void omap3630_init_late(void);
+void am33xx_init_late(void);
 void am35xx_init_late(void);
 void ti81xx_init_late(void);
 int omap2_common_pm_late_init(void);
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 11583a6d..fca216d 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -567,6 +567,11 @@ void __init am33xx_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap_clk_init = am33xx_clk_init;
 }
+
+void __init am33xx_init_late(void)
+{
+	am33xx_pm_init();
+}
 #endif
 
 #ifdef CONFIG_SOC_AM43XX
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index e742118..f8bd883 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -305,7 +305,8 @@ int __init omap2_common_pm_late_init(void)
 	}
 
 #ifdef CONFIG_SUSPEND
-	suspend_set_ops(&omap_pm_ops);
+	if (!soc_is_am33xx())
+		suspend_set_ops(&omap_pm_ops);
 #endif
 
 	return 0;
diff --git a/arch/arm/mach-omap2/pm33xx.c b/arch/arm/mach-omap2/pm33xx.c
new file mode 100644
index 0000000..11d3173
--- /dev/null
+++ b/arch/arm/mach-omap2/pm33xx.c
@@ -0,0 +1,486 @@
+/*
+ * AM33XX Power Management Routines
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Vaibhav Bedia <vaibhav.bedia@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/firmware.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/suspend.h>
+#include <linux/completion.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/ti_emif.h>
+#include <linux/pie.h>
+#include <linux/genalloc.h>
+#include <linux/omap-mailbox.h>
+
+#include <asm/suspend.h>
+#include <asm/proc-fns.h>
+#include <asm/sizes.h>
+#include <asm/fncpy.h>
+#include <asm/system_misc.h>
+
+#include "pm.h"
+#include "cm33xx.h"
+#include "pm33xx.h"
+#include "control.h"
+#include "common.h"
+#include "clockdomain.h"
+#include "powerdomain.h"
+#include "omap_hwmod.h"
+#include "omap_device.h"
+#include "soc.h"
+
+static unsigned long am33xx_mem_type;
+static void __iomem *am33xx_emif_base;
+static struct pie_chunk *am33xx_pie_chunk;
+static struct powerdomain *cefuse_pwrdm, *gfx_pwrdm, *per_pwrdm, *mpu_pwrdm;
+static struct clockdomain *gfx_l4ls_clkdm;
+
+struct wakeup_src wakeups[] = {
+	{.irq_nr = 35,	.src = "USB0_PHY"},
+	{.irq_nr = 36,	.src = "USB1_PHY"},
+	{.irq_nr = 40,	.src = "I2C0"},
+	{.irq_nr = 41,	.src = "RTC Timer"},
+	{.irq_nr = 42,	.src = "RTC Alarm"},
+	{.irq_nr = 43,	.src = "Timer0"},
+	{.irq_nr = 44,	.src = "Timer1"},
+	{.irq_nr = 45,	.src = "UART"},
+	{.irq_nr = 46,	.src = "GPIO0"},
+	{.irq_nr = 48,	.src = "MPU_WAKE"},
+	{.irq_nr = 49,	.src = "WDT0"},
+	{.irq_nr = 50,	.src = "WDT1"},
+	{.irq_nr = 51,	.src = "ADC_TSC"},
+};
+
+struct forced_standby_module am33xx_mod[] = {
+	{.oh_name = "usb_otg_hs"},
+	{.oh_name = "tptc0"},
+	{.oh_name = "tptc1"},
+	{.oh_name = "tptc2"},
+	{.oh_name = "cpgmac0"},
+};
+
+static struct am33xx_pm_context *am33xx_pm;
+
+static DECLARE_COMPLETION(am33xx_pm_sync);
+
+#ifdef CONFIG_SUSPEND
+
+static int am33xx_pm_suspend(void)
+{
+	int i, j, ret = 0;
+
+	int status = 0;
+	struct platform_device *pdev;
+	struct omap_device *od;
+
+	/*
+	 * By default the following IPs do not have MSTANDBY asserted
+	 * which is necessary for PER domain transition. If the drivers
+	 * are not compiled into the kernel HWMOD code will not change the
+	 * state of the IPs if the IP was not never enabled. To ensure
+	 * that there no issues with or without the drivers being compiled
+	 * in the kernel, we forcefully put these IPs to idle.
+	 */
+	for (i = 0; i < ARRAY_SIZE(am33xx_mod); i++) {
+		pdev = to_platform_device(am33xx_mod[i].dev);
+		od = to_omap_device(pdev);
+		if (od->_driver_status != BUS_NOTIFY_BOUND_DRIVER) {
+			omap_device_enable_hwmods(od);
+			omap_device_idle_hwmods(od);
+		}
+	}
+
+	/* Try to put GFX to sleep */
+	omap_set_pwrdm_state(gfx_pwrdm, PWRDM_POWER_OFF);
+	ret = cpu_suspend(am33xx_mem_type, am33xx_suspend);
+
+	status = pwrdm_read_prev_pwrst(gfx_pwrdm);
+	if (status != PWRDM_POWER_OFF)
+		pr_err("PM: GFX domain did not transition\n");
+	else
+		pr_info("PM: GFX domain entered low power state\n");
+
+	/*
+	 * BUG: GFX_L4LS clock domain needs to be woken up to
+	 * ensure thet L4LS clock domain does not get stuck in transition
+	 * If that happens L3 module does not get disabled, thereby leading
+	 * to PER power domain transition failing
+	 */
+	clkdm_wakeup(gfx_l4ls_clkdm);
+	clkdm_sleep(gfx_l4ls_clkdm);
+
+	if (ret) {
+		pr_err("PM: Kernel suspend failure\n");
+	} else {
+		i = am33xx_pm_status();
+		switch (i) {
+		case 0:
+			pr_info("PM: Successfully put all powerdomains to target state\n");
+
+			/*
+			 * The PRCM registers on AM335x do not contain previous state
+			 * information like those present on OMAP4 so we must manually
+			 * indicate transition so state counters are properly incremented
+			 */
+			pwrdm_post_transition(mpu_pwrdm);
+			pwrdm_post_transition(per_pwrdm);
+			break;
+		case 1:
+			pr_err("PM: Could not transition all powerdomains to target state\n");
+			ret = -1;
+			break;
+		default:
+			pr_err("PM: CM3 returned unknown result :(\nStatus = %d\n", i);
+			ret = -1;
+		}
+
+		/* print the wakeup reason */
+		i = am33xx_pm_wake_src();
+		for (j = 0; j < ARRAY_SIZE(wakeups); j++) {
+			if (wakeups[j].irq_nr == i) {
+				pr_info("PM: Wakeup source %s\n", wakeups[j].src);
+				break;
+			}
+		}
+
+		if (j == ARRAY_SIZE(wakeups))
+			pr_info("PM: Unknown wakeup source %d!\n", i);
+	}
+
+	return ret;
+}
+
+static int am33xx_pm_enter(suspend_state_t suspend_state)
+{
+	int ret = 0;
+
+	switch (suspend_state) {
+	case PM_SUSPEND_STANDBY:
+	case PM_SUSPEND_MEM:
+		ret = am33xx_pm_suspend();
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/* returns the error code from msg_send - 0 for success, failure otherwise */
+static int am33xx_ping_wkup_m3(void)
+{
+	int ret = 0;
+
+	/*
+	 * Write a dummy message to the mailbox in order to trigger the RX
+	 * interrupt to alert the M3 that data is available in the IPC
+	 * registers.
+	 */
+	ret = omap_mbox_msg_send(am33xx_pm->mbox, 0xABCDABCD);
+
+	return ret;
+}
+
+static void am33xx_m3_state_machine_reset(void)
+{
+	int i;
+
+	am33xx_pm->ipc.sleep_mode = IPC_CMD_RESET;
+
+	am33xx_pm_ipc_cmd(&am33xx_pm->ipc);
+
+	am33xx_pm->state = M3_STATE_MSG_FOR_RESET;
+
+	pr_info("PM: Sending message for resetting M3 state machine\n");
+
+	if (!am33xx_ping_wkup_m3()) {
+		i = wait_for_completion_timeout(&am33xx_pm_sync,
+					msecs_to_jiffies(500));
+		if (WARN(i == 0, "PM: MPU<->CM3 sync failure\n"))
+			am33xx_pm->state = M3_STATE_UNKNOWN;
+	} else {
+		pr_warn("PM: Unable to ping CM3\n");
+	}
+}
+
+static int am33xx_pm_begin(suspend_state_t state)
+{
+	int i;
+
+	cpu_idle_poll_ctrl(true);
+
+	am33xx_pm->ipc.sleep_mode	= IPC_CMD_DS0;
+	am33xx_pm->ipc.param1		= DS_IPC_DEFAULT;
+	am33xx_pm->ipc.param2		= DS_IPC_DEFAULT;
+
+	am33xx_pm_ipc_cmd(&am33xx_pm->ipc);
+
+	am33xx_pm->state = M3_STATE_MSG_FOR_LP;
+
+	pr_info("PM: Sending message for entering DeepSleep mode\n");
+
+	if (!am33xx_ping_wkup_m3()) {
+		i = wait_for_completion_timeout(&am33xx_pm_sync,
+					msecs_to_jiffies(500));
+		if (WARN(i == 0, "PM: MPU<->CM3 sync failure\n"))
+			return -1;
+	} else {
+		pr_warn("PM: Unable to ping CM3\n");
+	}
+
+	return 0;
+}
+
+static void am33xx_pm_end(void)
+{
+	am33xx_m3_state_machine_reset();
+
+	cpu_idle_poll_ctrl(false);
+
+	return;
+}
+
+static struct platform_suspend_ops am33xx_pm_ops = {
+	.begin		= am33xx_pm_begin,
+	.end		= am33xx_pm_end,
+	.enter		= am33xx_pm_enter,
+};
+
+/*
+ * Dummy notifier for the mailbox
+ */
+
+static int wkup_mbox_msg(struct notifier_block *self, unsigned long len,
+		void *msg)
+{
+	return 0;
+}
+
+static struct notifier_block wkup_mbox_notifier = {
+	.notifier_call = wkup_mbox_msg,
+};
+
+void am33xx_txev_handler(void)
+{
+	switch (am33xx_pm->state) {
+	case M3_STATE_RESET:
+		am33xx_pm->state = M3_STATE_INITED;
+		am33xx_pm->ver = am33xx_pm_version_get();
+		if (am33xx_pm->ver == M3_VERSION_UNKNOWN ||
+			am33xx_pm->ver < M3_BASELINE_VERSION) {
+			pr_warn("PM: CM3 Firmware Version %x not supported\n",
+						am33xx_pm->ver);
+		} else {
+			pr_info("PM: CM3 Firmware Version = 0x%x\n",
+						am33xx_pm->ver);
+			am33xx_pm_ops.valid = suspend_valid_only_mem;
+		}
+		break;
+	case M3_STATE_MSG_FOR_RESET:
+		am33xx_pm->state = M3_STATE_INITED;
+		complete(&am33xx_pm_sync);
+		break;
+	case M3_STATE_MSG_FOR_LP:
+		complete(&am33xx_pm_sync);
+		break;
+	case M3_STATE_UNKNOWN:
+		pr_warn("PM: Unknown CM3 State\n");
+	}
+
+	return;
+}
+
+static void am33xx_pm_firmware_cb(const struct firmware *fw, void *context)
+{
+	struct am33xx_pm_context *am33xx_pm = context;
+	int ret = 0;
+	unsigned long pie_trampoline;
+
+	/* no firmware found */
+	if (!fw) {
+		pr_err("PM: request_firmware failed\n");
+		return;
+	}
+
+	wkup_m3_copy_code(fw->data, fw->size);
+
+	wkup_m3_register_txev_handler(am33xx_txev_handler);
+
+	pr_info("PM: Copied the M3 firmware to UMEM\n");
+
+	/*
+	 * Invalidate M3 firmware version before hardreset.
+	 * Write invalid version in lower 4 nibbles of parameter
+	 * register (ipc_regs + 0x8).
+	 */
+	am33xx_pm_version_clear();
+
+	am33xx_pm->state = M3_STATE_RESET;
+
+	ret = wkup_m3_prepare();
+	if (ret) {
+		pr_err("PM: Could not prepare WKUP_M3\n");
+		return;
+	}
+
+	/* Physical resume address to be used by ROM code */
+	pie_trampoline = (long) fn_to_pie(am33xx_pie_chunk,
+				&am33xx_resume_trampoline);
+	am33xx_pm->ipc.resume_addr = pie_to_phys(am33xx_pie_chunk,
+				pie_trampoline);
+
+	am33xx_pm->mbox = omap_mbox_get("wkup_m3", &wkup_mbox_notifier);
+
+	if (IS_ERR(am33xx_pm->mbox)) {
+		ret = -EBUSY;
+		pr_err("PM: IPC Request for A8->M3 Channel failed!\n");
+		return;
+	} else {
+		suspend_set_ops(&am33xx_pm_ops);
+	}
+
+	return;
+}
+
+#endif /* CONFIG_SUSPEND */
+
+static int __init am33xx_map_emif(void)
+{
+	am33xx_emif_base = ioremap(AM33XX_EMIF_BASE, SZ_32K);
+
+	if (!am33xx_emif_base)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int __init am33xx_pie_chunk_init(void)
+{
+	struct device_node *np;
+	struct gen_pool *pool;
+
+	np = of_find_compatible_node(NULL, NULL, "ti,omap3-mpu");
+	if (!np)
+		return -ENOENT;
+
+	pool = of_get_named_gen_pool(np, "sram", 0);
+	if (!pool)
+		return -ENOENT;
+
+	am33xx_pie_chunk = pie_load_sections(pool, am33xx);
+	if (!IS_ERR(am33xx_pie_chunk))
+		am33xx_pie_init(am33xx_pie_chunk, am33xx_emif_base,
+					am33xx_dram_sync);
+
+	return PTR_RET(am33xx_pie_chunk);
+}
+
+int __init am33xx_pm_init(void)
+{
+	int ret;
+	u32 temp;
+	struct device_node *np;
+	int i;
+
+	if (!soc_is_am33xx())
+		return -ENODEV;
+
+	pr_info("Power Management for AM33XX family\n");
+
+	/*
+	 * By default the following IPs do not have MSTANDBY asserted
+	 * which is necessary for PER domain transition. If the drivers
+	 * are not compiled into the kernel HWMOD code will not change the
+	 * state of the IPs if the IP was not never enabled
+	 */
+	for (i = 0; i < ARRAY_SIZE(am33xx_mod); i++)
+		am33xx_mod[i].dev = omap_device_get_by_hwmod_name(am33xx_mod[i].oh_name);
+
+	gfx_pwrdm = pwrdm_lookup("gfx_pwrdm");
+	per_pwrdm = pwrdm_lookup("per_pwrdm");
+	mpu_pwrdm = pwrdm_lookup("mpu_pwrdm");
+
+	gfx_l4ls_clkdm = clkdm_lookup("gfx_l4ls_gfx_clkdm");
+
+	if ((!gfx_pwrdm) || (!per_pwrdm) || (!mpu_pwrdm) || (!gfx_l4ls_clkdm)) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	am33xx_pm = kzalloc(sizeof(*am33xx_pm), GFP_KERNEL);
+	if (!am33xx_pm) {
+		pr_err("Memory allocation failed\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = am33xx_map_emif();
+	if (ret) {
+		pr_err("PM: Could not ioremap EMIF\n");
+		goto err;
+	}
+	/* Determine Memory Type */
+	temp = readl(am33xx_emif_base + EMIF_SDRAM_CONFIG);
+	temp = (temp & SDRAM_TYPE_MASK) >> SDRAM_TYPE_SHIFT;
+	/* Parameters to pass to aseembly code */
+	am33xx_mem_type = temp;
+	am33xx_pm->ipc.param3 = temp;
+
+	np = of_find_compatible_node(NULL, NULL, "ti,am3353-wkup-m3");
+	if (np) {
+		if (of_find_property(np, "ti,needs_vtt_toggle", NULL) &&
+		    (!(of_property_read_u32(np, "vtt-gpio-pin",
+							&temp)))) {
+			if (temp >= 0 && temp <= 31)
+				am33xx_pm->ipc.param3 |=
+					((1 << VTT_STAT_SHIFT) |
+					(temp << VTT_GPIO_PIN_SHIFT));
+		}
+	}
+
+	ret = am33xx_pie_chunk_init();
+	if (ret) {
+		pr_err("PM: Could not load suspend/resume code into SRAM\n");
+		goto err;
+	}
+
+	(void) clkdm_for_each(omap_pm_clkdms_setup, NULL);
+
+	/* CEFUSE domain can be turned off post bootup */
+	cefuse_pwrdm = pwrdm_lookup("cefuse_pwrdm");
+	if (cefuse_pwrdm)
+		omap_set_pwrdm_state(cefuse_pwrdm, PWRDM_POWER_OFF);
+	else
+		pr_err("PM: Failed to get cefuse_pwrdm\n");
+
+#ifdef CONFIG_SUSPEND
+	pr_info("PM: Trying to load am335x-pm-firmware.bin");
+
+	/* We don't want to delay boot */
+	request_firmware_nowait(THIS_MODULE, 0, "am335x-pm-firmware.bin",
+				NULL, GFP_KERNEL, am33xx_pm,
+				am33xx_pm_firmware_cb);
+#endif /* CONFIG_SUSPEND */
+
+err:
+	return ret;
+}
diff --git a/arch/arm/mach-omap2/pm33xx.h b/arch/arm/mach-omap2/pm33xx.h
new file mode 100644
index 0000000..b470fa5
--- /dev/null
+++ b/arch/arm/mach-omap2/pm33xx.h
@@ -0,0 +1,68 @@
+/*
+ * AM33XX Power Management Routines
+ *
+ * Copyright (C) 2012 Texas Instruments Inc.
+ * Vaibhav Bedia <vaibhav.bedia@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef __ARCH_ARM_MACH_OMAP2_PM33XX_H
+#define __ARCH_ARM_MACH_OMAP2_PM33XX_H
+
+#include <linux/kernel.h>
+
+#include "control.h"
+
+struct am33xx_pm_context {
+	struct am33xx_ipc_data	ipc;
+	struct firmware		*firmware;
+	struct omap_mbox	*mbox;
+	u8			state;
+	u32			ver;
+};
+
+struct wakeup_src {
+	int irq_nr;
+	char src[10];
+};
+
+struct forced_standby_module {
+	char oh_name[15];
+	struct device *dev;
+};
+
+struct pie_chunk;
+
+int wkup_m3_copy_code(const u8 *data, size_t size);
+int wkup_m3_prepare(void);
+void wkup_m3_register_txev_handler(void (*txev_handler)(void));
+int am33xx_suspend(long unsigned int flags);
+void am33xx_resume_trampoline(void);
+void am33xx_pie_init(struct pie_chunk *chunk, void __iomem *emif_base,
+				void __iomem *dram_sync);
+
+#define	IPC_CMD_DS0			0x4
+#define IPC_CMD_RESET                   0xe
+#define DS_IPC_DEFAULT			0xffffffff
+#define M3_VERSION_UNKNOWN		0x0000ffff
+#define M3_BASELINE_VERSION		0x21
+
+#define M3_STATE_UNKNOWN		0
+#define M3_STATE_RESET			1
+#define M3_STATE_INITED			2
+#define M3_STATE_MSG_FOR_LP		3
+#define M3_STATE_MSG_FOR_RESET		4
+
+#define AM33XX_OCMC_END			0x40310000
+#define AM33XX_EMIF_BASE		0x4C000000
+
+#define MEM_TYPE_DDR2		2
+
+#endif
diff --git a/arch/arm/mach-omap2/sleep33xx.c b/arch/arm/mach-omap2/sleep33xx.c
new file mode 100644
index 0000000..2a4322c
--- /dev/null
+++ b/arch/arm/mach-omap2/sleep33xx.c
@@ -0,0 +1,314 @@
+/*
+ * AM33XX Power Management Routines
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Vaibhav Bedia <vaibhav.bedia@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/ti_emif.h>
+#include <linux/platform_data/emif_plat.h>
+#include <linux/pie.h>
+
+#include <asm/suspend.h>
+#include <asm/cp15.h>
+#include <asm/pie.h>
+
+#include "pm33xx.h"
+#include "cm33xx.h"
+#include "cm-regbits-33xx.h"
+#include "omap_hwmod.h"
+
+#define CLKCTRL_IDLEST_FUNCTIONAL	0x0
+#define CLKCTRL_IDLEST_DISABLED		0x3
+
+struct emif_regs {
+	u32 sdcfg;
+	u32 ref_ctrl;
+	u32 timing1;
+	u32 timing2;
+	u32 timing3;
+	u32 pmcr;
+	u32 pmcr_shdw;
+	u32 zqcfg;
+	u32 rd_lat;
+};
+
+extern int call_with_stack(int (*fn)(void *), void *arg, void *sp);
+extern void v7_flush_dcache_all(void);
+
+void (*__abs_v7_flush_dcache_all)(void) __pie_data(am33xx);
+char sram_stack[1024] __pie_data(am33xx);
+void __noreturn (*__cpu_resume_phys)(void) __pie_data(am33xx);
+void __iomem *emif_virt_base __pie_data(am33xx);
+void __iomem *dram_sync_addr __pie_data(am33xx);
+
+EXPORT_PIE_SYMBOL(__abs_v7_flush_dcache_all);
+EXPORT_PIE_SYMBOL(sram_stack);
+EXPORT_PIE_SYMBOL(__cpu_resume_phys);
+EXPORT_PIE_SYMBOL(emif_virt_base);
+EXPORT_PIE_SYMBOL(dram_sync_addr);
+
+static struct emif_regs emif_regs __pie_data(am33xx);
+static void __iomem *emif_base __pie_data(am33xx);
+static u32 mem_type __pie_data(am33xx);
+static u32 cm_offset __pie_data(am33xx);
+
+static struct pie_chunk *am33xx_chunk;
+
+static inline void flush_dcache_all(void)
+{
+	__asm__ __volatile__("" : : : "r0", "r1", "r2", "r3", "r4", "r5",
+				"r5", "r6", "r7", "r9", "r10", "r11");
+	__abs_v7_flush_dcache_all();
+}
+
+static u32 __pie(am33xx) emif_read(u16 idx)
+{
+	return __raw_readl(emif_base + idx);
+}
+
+static void __pie(am33xx) emif_write(u32 val, u16 idx)
+{
+	__raw_writel(val, emif_base + idx);
+}
+
+static inline void am33xx_wkup_write(u32 val, void __iomem *reg)
+{
+	__raw_writel(val, reg + cm_offset);
+}
+
+static inline u32 am33xx_wkup_read(void __iomem *reg)
+{
+	return __raw_readl(reg + cm_offset);
+}
+
+static void __pie(am33xx) am33xx_module_set(u16 mode, void __iomem *reg)
+{
+	u32 val = am33xx_wkup_read(reg) & ~AM33XX_MODULEMODE_MASK;
+	am33xx_wkup_write(val | mode, reg);
+}
+
+static void __pie(am33xx) am33xx_module_disable(void __iomem *reg)
+{
+	am33xx_module_set(0, reg);
+}
+
+static void __pie(am33xx) am33xx_module_disable_wait(void __iomem *reg)
+{
+	u32 val;
+	am33xx_module_disable(reg);
+	do {
+		val = am33xx_wkup_read(reg) & AM33XX_IDLEST_MASK;
+		val >>= AM33XX_IDLEST_SHIFT;
+	} while (val != CLKCTRL_IDLEST_DISABLED);
+}
+
+static void __pie(am33xx) am33xx_module_enable(void __iomem *reg)
+{
+	am33xx_module_set(MODULEMODE_SWCTRL, reg);
+}
+
+static void __pie(am33xx) am33xx_module_enable_wait(void __iomem *reg)
+{
+	u32 val;
+	am33xx_module_enable(reg);
+	do {
+		val = am33xx_wkup_read(reg) & AM33XX_IDLEST_MASK;
+		val >>= AM33XX_IDLEST_SHIFT;
+	} while (val != CLKCTRL_IDLEST_FUNCTIONAL);
+}
+
+static void __pie(am33xx) noinline am33xx_enable_sr(void)
+{
+	u32 val;
+
+	emif_regs.sdcfg = emif_read(EMIF_SDRAM_CONFIG);
+	val = emif_read(EMIF_POWER_MANAGEMENT_CONTROL);
+	val &= ~SR_TIM_MASK;
+	val |= 0xa << SR_TIM_SHIFT;
+	emif_write(val, EMIF_POWER_MANAGEMENT_CONTROL);
+	emif_write(val, EMIF_POWER_MANAGEMENT_CTRL_SHDW);
+
+	__raw_readl(dram_sync_addr);
+	val &= ~LP_MODE_MASK;
+	val |= EMIF_LP_MODE_SELF_REFRESH << LP_MODE_SHIFT;
+	emif_write(val, EMIF_POWER_MANAGEMENT_CONTROL);
+}
+
+static void __pie(am33xx) noinline am33xx_disable_sr(void)
+{
+	u32 val;
+
+	val = emif_read(EMIF_POWER_MANAGEMENT_CONTROL);
+	val &= ~LP_MODE_MASK;
+	val |= EMIF_LP_MODE_DISABLE << LP_MODE_SHIFT;
+	emif_write(val, EMIF_POWER_MANAGEMENT_CONTROL);
+	emif_write(val, EMIF_POWER_MANAGEMENT_CTRL_SHDW);
+
+	/*
+	 * A write to SDRAM CONFIG register triggers
+	 * an init sequence and hence it must be done
+	 * at the end for DDR2
+	 */
+	emif_write(emif_regs.sdcfg, EMIF_SDRAM_CONFIG);
+}
+
+static void __pie(am33xx) noinline am33xx_emif_save(void)
+{
+	emif_regs.ref_ctrl = emif_read(EMIF_SDRAM_REFRESH_CONTROL);
+	emif_regs.timing1 = emif_read(EMIF_SDRAM_TIMING_1);
+	emif_regs.timing2 = emif_read(EMIF_SDRAM_TIMING_2);
+	emif_regs.timing3 = emif_read(EMIF_SDRAM_TIMING_3);
+	emif_regs.pmcr = emif_read(EMIF_POWER_MANAGEMENT_CONTROL);
+	emif_regs.pmcr_shdw = emif_read(EMIF_POWER_MANAGEMENT_CTRL_SHDW);
+	emif_regs.zqcfg = emif_read(EMIF_SDRAM_OUTPUT_IMPEDANCE_CALIBRATION_CONFIG);
+	emif_regs.rd_lat = emif_read(EMIF_DDR_PHY_CTRL_1);
+}
+
+static void __pie(am33xx) noinline am33xx_emif_restore(void)
+{
+	emif_write(emif_regs.rd_lat, EMIF_DDR_PHY_CTRL_1);
+	emif_write(emif_regs.rd_lat, EMIF_DDR_PHY_CTRL_1_SHDW);
+	emif_write(emif_regs.timing1, EMIF_SDRAM_TIMING_1);
+	emif_write(emif_regs.timing1, EMIF_SDRAM_TIMING_1_SHDW);
+	emif_write(emif_regs.timing2, EMIF_SDRAM_TIMING_2);
+	emif_write(emif_regs.timing2, EMIF_SDRAM_TIMING_2_SHDW);
+	emif_write(emif_regs.timing3, EMIF_SDRAM_TIMING_3);
+	emif_write(emif_regs.timing3, EMIF_SDRAM_TIMING_3_SHDW);
+	emif_write(emif_regs.ref_ctrl, EMIF_SDRAM_REFRESH_CONTROL);
+	emif_write(emif_regs.ref_ctrl, EMIF_SDRAM_REFRESH_CTRL_SHDW);
+	emif_write(emif_regs.pmcr, EMIF_POWER_MANAGEMENT_CONTROL);
+	emif_write(emif_regs.pmcr_shdw, EMIF_POWER_MANAGEMENT_CTRL_SHDW);
+	/*
+	 * Output impedence calib needed only for DDR3
+	 * but since the initial state of this will be
+	 * disabled for DDR2 no harm in restoring the
+	 * old configuration
+	 */
+	emif_write(emif_regs.zqcfg, EMIF_SDRAM_OUTPUT_IMPEDANCE_CALIBRATION_CONFIG);
+
+	/* Write to SDRAM_CONFIG only for DDR2 */
+	if (mem_type == MEM_TYPE_DDR2)
+		emif_write(emif_regs.sdcfg, EMIF_SDRAM_CONFIG);
+}
+
+int __pie(am33xx) am33xx_wfi_sram(void *data)
+{
+	mem_type = (unsigned long) data;
+	emif_base = emif_virt_base;
+	cm_offset = 0;
+
+	/*
+	 * Flush all data from the L1 data cache before disabling
+	 * SCTLR.C bit.
+	 */
+	flush_dcache_all();
+	/*
+	 * Clear the SCTLR.C bit to prevent further data cache
+	 * allocation. Clearing SCTLR.C would make all the data
+	 * accesses strongly ordered and would not hit the cache.
+	 */
+	set_cr(get_cr() & ~CR_C);
+	/*
+	 * Invalidate L1 data cache. Even though only invalidate is
+	 * necessary exported flush API is used here. Doing clean
+	 * on already clean cache would be almost NOP.
+	 */
+	flush_dcache_all();
+
+	am33xx_emif_save();
+	am33xx_enable_sr();
+
+	am33xx_module_disable_wait(AM33XX_CM_PER_EMIF_CLKCTRL);
+
+	/*
+	 * For the MPU WFI to be registered as an interrupt
+	 * to WKUP_M3, MPU_CLKCTRL.MODULEMODE needs to be set
+	 * to DISABLED
+	 */
+	am33xx_module_disable(AM33XX_CM_MPU_MPU_CLKCTRL);
+
+	__asm__ __volatile__ (
+		/*
+		 * Execute an ISB instruction to ensure that all of the
+		 * CP15 register changes have been committed.
+		 */
+		"isb\n\t"
+		/*
+		 * Execute a barrier instruction to ensure that all cache,
+		 * TLB and branch predictor maintenance operations issued
+		 * have completed.
+		 */
+		"dsb\n\t"
+		"dmb\n\t"
+		/*
+		 * Execute a WFI instruction and wait until the
+		 * STANDBYWFI output is asserted to indicate that the
+		 * CPU is in idle and low power state. CPU can specualatively
+		 * prefetch the instructions so add NOPs after WFI. Thirteen
+		 * NOPs as per Cortex-A8 pipeline.
+		 */
+		"wfi\n\t"
+		".rept 13\n\t"
+		"nop\n\t"
+		".endr" : : : "memory");
+
+	/* We come here in case of an abort due to a late interrupt */
+
+	am33xx_module_enable(AM33XX_CM_MPU_MPU_CLKCTRL);
+
+	am33xx_module_enable_wait(AM33XX_CM_PER_EMIF_CLKCTRL);
+	am33xx_disable_sr();
+	/* Set SCTLR.C bit to allow data cache allocation */
+	set_cr(get_cr() | CR_C);
+
+	/* Let the suspend code know about the abort */
+	return 1;
+}
+EXPORT_PIE_SYMBOL(am33xx_wfi_sram);
+
+int am33xx_suspend(long unsigned int mem_type)
+{
+	pie_relocate_from_kern(am33xx_chunk);
+	return call_with_stack(fn_to_pie(am33xx_chunk, &am33xx_wfi_sram),
+			(void *) mem_type,
+			kern_to_pie(am33xx_chunk, (char *) sram_stack) +
+				sizeof(sram_stack));
+}
+
+static void __pie(am33xx) __noreturn noinline am33xx_resume(void)
+{
+	emif_base = (void *) AM33XX_EMIF_BASE;
+	/* Undo the offset built into the register defines */
+	cm_offset = -AM33XX_L4_WK_IO_OFFSET;
+
+	am33xx_module_enable_wait(AM33XX_CM_PER_EMIF_CLKCTRL);
+	am33xx_emif_restore();
+
+	/* We are back. Branch to the common CPU resume routine */
+	__cpu_resume_phys();
+}
+
+ARM_PIE_RESUME(am33xx, am33xx_resume, sram_stack + ARRAY_SIZE(sram_stack));
+
+void am33xx_pie_init(struct pie_chunk *chunk, void __iomem *emif_base,
+						void __iomem *dram_sync)
+{
+	am33xx_chunk = chunk;
+
+	*kern_to_pie(chunk, &__abs_v7_flush_dcache_all) = v7_flush_dcache_all;
+	*kern_to_pie(chunk, &__cpu_resume_phys) =
+					(void *) virt_to_phys(cpu_resume);
+	*kern_to_pie(chunk, &emif_virt_base) = emif_base;
+	*kern_to_pie(chunk, &dram_sync_addr) = dram_sync;
+}
diff --git a/arch/arm/mach-omap2/wkup_m3.c b/arch/arm/mach-omap2/wkup_m3.c
new file mode 100644
index 0000000..8eaa7f3
--- /dev/null
+++ b/arch/arm/mach-omap2/wkup_m3.c
@@ -0,0 +1,183 @@
+/*
+ * AM33XX Power Management Routines
+ *
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ * Vaibhav Bedia <vaibhav.bedia@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/cpu.h>
+#include <linux/err.h>
+#include <linux/firmware.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+
+#include "pm33xx.h"
+#include "control.h"
+#include "omap_device.h"
+#include "soc.h"
+
+struct wkup_m3_context {
+	struct device	*dev;
+	void __iomem	*code;
+	void (*txev_handler)(void);
+};
+
+struct wkup_m3_context *wkup_m3;
+
+int wkup_m3_copy_code(const u8 *data, size_t size)
+{
+	if (size > SZ_16K)
+		return -ENOMEM;
+
+	memcpy_toio(wkup_m3->code, data, size);
+
+	return 0;
+}
+
+
+void wkup_m3_register_txev_handler(void (*txev_handler)(void))
+{
+	wkup_m3->txev_handler = txev_handler;
+}
+
+/* have platforms do what they want in atomic context over here? */
+static irqreturn_t wkup_m3_txev_handler(int irq, void *unused)
+{
+	am33xx_txev_eoi();
+
+	/* callback to be executed in atomic context */
+	/* return 0 implies IRQ_HANDLED else IRQ_NONE */
+	wkup_m3->txev_handler();
+
+	am33xx_txev_enable();
+
+	return IRQ_HANDLED;
+}
+
+int wkup_m3_prepare(void)
+{
+	struct platform_device *pdev = to_platform_device(wkup_m3->dev);
+
+	/* check that the code is loaded */
+	omap_device_deassert_hardreset(pdev, "wkup_m3");
+
+	return 0;
+}
+
+static int wkup_m3_probe(struct platform_device *pdev)
+{
+	int irq, ret = 0;
+	struct resource *mem;
+
+	pm_runtime_enable(&pdev->dev);
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (IS_ERR_VALUE(ret)) {
+		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
+		return ret;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (!irq) {
+		dev_err(wkup_m3->dev, "no irq resource\n");
+		ret = -ENXIO;
+		goto err;
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(wkup_m3->dev, "no memory resource\n");
+		ret = -ENXIO;
+		goto err;
+	}
+
+	wkup_m3 = kzalloc(sizeof(*wkup_m3), GFP_KERNEL);
+	if (!wkup_m3) {
+		pr_err("Memory allocation failed\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	wkup_m3->dev = &pdev->dev;
+
+	wkup_m3->code = devm_request_and_ioremap(wkup_m3->dev, mem);
+	if (!wkup_m3->code) {
+		dev_err(wkup_m3->dev, "could not ioremap\n");
+		ret = -EADDRNOTAVAIL;
+		goto err;
+	}
+
+	ret = devm_request_irq(wkup_m3->dev, irq, wkup_m3_txev_handler,
+		  IRQF_DISABLED, "wkup_m3_txev", NULL);
+	if (ret) {
+		dev_err(wkup_m3->dev, "request_irq failed\n");
+		goto err;
+	}
+
+err:
+	return ret;
+}
+
+static int wkup_m3_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct of_device_id wkup_m3_dt_ids[] = {
+	{ .compatible = "ti,am3353-wkup-m3" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wkup_m3_dt_ids);
+
+static int wkup_m3_rpm_suspend(struct device *dev)
+{
+	return -EBUSY;
+}
+
+static int wkup_m3_rpm_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops wkup_m3_ops = {
+	SET_RUNTIME_PM_OPS(wkup_m3_rpm_suspend, wkup_m3_rpm_resume, NULL)
+};
+
+static struct platform_driver wkup_m3_driver = {
+	.probe		= wkup_m3_probe,
+	.remove		= wkup_m3_remove,
+	.driver		= {
+		.name	= "wkup_m3",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(wkup_m3_dt_ids),
+		.pm	= &wkup_m3_ops,
+	},
+};
+
+static __init int wkup_m3_init(void)
+{
+	return platform_driver_register(&wkup_m3_driver);
+}
+
+static __exit void wkup_m3_exit(void)
+{
+	platform_driver_unregister(&wkup_m3_driver);
+}
+omap_postcore_initcall(wkup_m3_init);
+module_exit(wkup_m3_exit);
-- 
1.8.3.2

