Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3EAAzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 20:55:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55713 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760258Ab3EAAyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 20:54:39 -0400
X-IronPort-AV: E=Sophos;i="4.87,584,1363158000"; 
   d="scan'208";a="42999965"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/4] sched: Make ARM's sched_clock generic for all architectures
Date: Tue, 30 Apr 2013 17:54:34 -0700
Message-Id: <1367369675-13535-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc0.10.g8974033
In-Reply-To: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the patch to make sched_clock generic. I didn't know
where to put it so I just made a new file in kernel/sched
for now.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

 arch/arm/Kconfig                                      | 1 +
 arch/arm/common/timer-sp.c                            | 2 +-
 arch/arm/kernel/Makefile                              | 2 +-
 arch/arm/kernel/arch_timer.c                          | 2 +-
 arch/arm/kernel/time.c                                | 4 +---
 arch/arm/mach-davinci/time.c                          | 2 +-
 arch/arm/mach-imx/time.c                              | 2 +-
 arch/arm/mach-integrator/integrator_ap.c              | 2 +-
 arch/arm/mach-ixp4xx/common.c                         | 2 +-
 arch/arm/mach-mmp/time.c                              | 2 +-
 arch/arm/mach-msm/timer.c                             | 2 +-
 arch/arm/mach-omap1/time.c                            | 2 +-
 arch/arm/mach-omap2/timer.c                           | 2 +-
 arch/arm/mach-pxa/time.c                              | 2 +-
 arch/arm/mach-sa1100/time.c                           | 2 +-
 arch/arm/mach-u300/timer.c                            | 2 +-
 arch/arm/plat-iop/time.c                              | 2 +-
 arch/arm/plat-omap/counter_32k.c                      | 2 +-
 arch/arm/plat-orion/time.c                            | 2 +-
 arch/arm/plat-samsung/samsung-time.c                  | 2 +-
 arch/arm/plat-versatile/sched-clock.c                 | 2 +-
 drivers/clocksource/bcm2835_timer.c                   | 2 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c             | 3 +--
 drivers/clocksource/dw_apb_timer_of.c                 | 2 +-
 drivers/clocksource/mxs_timer.c                       | 2 +-
 drivers/clocksource/nomadik-mtu.c                     | 2 +-
 drivers/clocksource/tegra20_timer.c                   | 2 +-
 drivers/clocksource/time-armada-370-xp.c              | 2 +-
 drivers/clocksource/timer-marco.c                     | 2 +-
 drivers/clocksource/timer-prima2.c                    | 2 +-
 {arch/arm/include/asm => include/linux}/sched_clock.h | 9 +++++++--
 init/Kconfig                                          | 3 +++
 init/main.c                                           | 2 ++
 kernel/sched/Makefile                                 | 1 +
 {arch/arm/kernel => kernel/sched}/sched_clock.c       | 3 +--
 35 files changed, 44 insertions(+), 36 deletions(-)
 rename {arch/arm/include/asm => include/linux}/sched_clock.h (76%)
 rename {arch/arm/kernel => kernel/sched}/sched_clock.c (99%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 10c3466..ce1a020 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
+	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_IDLE_LOOP
 	select GENERIC_IDLE_POLL_SETUP
diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index ddc7407..023ee63 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -28,8 +28,8 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/hardware/arm_timer.h>
 #include <asm/hardware/timer-sp.h>
 
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 00d703c..44ea2de 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -16,7 +16,7 @@ CFLAGS_REMOVE_return_address.o = -pg
 # Object file lists.
 
 obj-y		:= elf.o entry-common.o irq.o opcodes.o \
-		   process.o ptrace.o return_address.o sched_clock.o \
+		   process.o ptrace.o return_address.o \
 		   setup.o signal.o stacktrace.o sys_arm.o time.o traps.o
 
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index b45250b..e1ea2bf 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -11,9 +11,9 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/sched_clock.h>
 
 #include <asm/delay.h>
-#include <asm/sched_clock.h>
 
 #include <clocksource/arm_arch_timer.h>
 
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index abff4e9..98aee32 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -24,9 +24,9 @@
 #include <linux/timer.h>
 #include <linux/clocksource.h>
 #include <linux/irq.h>
+#include <linux/sched_clock.h>
 
 #include <asm/thread_info.h>
-#include <asm/sched_clock.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
@@ -120,6 +120,4 @@ void __init time_init(void)
 		machine_desc->init_time();
 	else
 		clocksource_of_init();
-
-	sched_clock_postinit();
 }
diff --git a/arch/arm/mach-davinci/time.c b/arch/arm/mach-davinci/time.c
index bad361e..7a55b5c 100644
--- a/arch/arm/mach-davinci/time.c
+++ b/arch/arm/mach-davinci/time.c
@@ -18,8 +18,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
 
diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
index fea9131..cd46529 100644
--- a/arch/arm/mach-imx/time.c
+++ b/arch/arm/mach-imx/time.c
@@ -26,8 +26,8 @@
 #include <linux/clockchips.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/mach/time.h>
 
 #include "common.h"
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index b23c8e4..aa43462 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -41,6 +41,7 @@
 #include <linux/stat.h>
 #include <linux/sys_soc.h>
 #include <linux/termios.h>
+#include <linux/sched_clock.h>
 #include <video/vga.h>
 
 #include <mach/hardware.h>
@@ -49,7 +50,6 @@
 #include <asm/setup.h>
 #include <asm/param.h>		/* HZ */
 #include <asm/mach-types.h>
-#include <asm/sched_clock.h>
 
 #include <mach/lm.h>
 #include <mach/irqs.h>
diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 6600cff..58307cf 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -30,6 +30,7 @@
 #include <linux/export.h>
 #include <linux/gpio.h>
 #include <linux/cpu.h>
+#include <linux/sched_clock.h>
 
 #include <mach/udc.h>
 #include <mach/hardware.h>
@@ -38,7 +39,6 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/irq.h>
-#include <asm/sched_clock.h>
 #include <asm/system_misc.h>
 
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 86a18b3..7ac41e8 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -28,8 +28,8 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <mach/addr-map.h>
 #include <mach/regs-timers.h>
 #include <mach/regs-apbc.h>
diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 284313f..b6418fd 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -23,10 +23,10 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
 #include <asm/localtimer.h>
-#include <asm/sched_clock.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 726ec23..80603d2 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -43,9 +43,9 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/io.h>
+#include <linux/sched_clock.h>
 
 #include <asm/irq.h>
-#include <asm/sched_clock.h>
 
 #include <mach/hardware.h>
 #include <asm/mach/irq.h>
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index ce57228..6e7885e 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -41,10 +41,10 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/dmtimer-omap.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
-#include <asm/sched_clock.h>
 
 #include "omap_hwmod.h"
 #include "omap_device.h"
diff --git a/arch/arm/mach-pxa/time.c b/arch/arm/mach-pxa/time.c
index 8f1ee92..9aa852a 100644
--- a/arch/arm/mach-pxa/time.c
+++ b/arch/arm/mach-pxa/time.c
@@ -16,11 +16,11 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/clockchips.h>
+#include <linux/sched_clock.h>
 
 #include <asm/div64.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 #include <mach/regs-ost.h>
 #include <mach/irqs.h>
 
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index a59a13a..713c86c 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -14,9 +14,9 @@
 #include <linux/irq.h>
 #include <linux/timex.h>
 #include <linux/clockchips.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 
diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index d9e7320..af771b7 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -18,12 +18,12 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/irq.h>
+#include <linux/sched_clock.h>
 
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 
 /* Generic stuff */
-#include <asm/sched_clock.h>
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
 
diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 837a2d5..29606bd7 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -22,9 +22,9 @@
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/export.h>
+#include <linux/sched_clock.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/sched_clock.h>
 #include <asm/uaccess.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/plat-omap/counter_32k.c b/arch/arm/plat-omap/counter_32k.c
index 5b0b86b..d9bc98e 100644
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@ -18,9 +18,9 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/clocksource.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 
 #include <plat/counter-32k.h>
 
diff --git a/arch/arm/plat-orion/time.c b/arch/arm/plat-orion/time.c
index 5d5ac0f..9d2b2ac 100644
--- a/arch/arm/plat-orion/time.c
+++ b/arch/arm/plat-orion/time.c
@@ -16,7 +16,7 @@
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 /*
  * MBus bridge block registers.
diff --git a/arch/arm/plat-samsung/samsung-time.c b/arch/arm/plat-samsung/samsung-time.c
index f899cbc..2957075 100644
--- a/arch/arm/plat-samsung/samsung-time.c
+++ b/arch/arm/plat-samsung/samsung-time.c
@@ -15,12 +15,12 @@
 #include <linux/clk.h>
 #include <linux/clockchips.h>
 #include <linux/platform_device.h>
+#include <linux/sched_clock.h>
 
 #include <asm/smp_twd.h>
 #include <asm/mach/time.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
-#include <asm/sched_clock.h>
 
 #include <mach/map.h>
 #include <plat/devs.h>
diff --git a/arch/arm/plat-versatile/sched-clock.c b/arch/arm/plat-versatile/sched-clock.c
index b33b74c..51b109e 100644
--- a/arch/arm/plat-versatile/sched-clock.c
+++ b/arch/arm/plat-versatile/sched-clock.c
@@ -20,8 +20,8 @@
  */
 #include <linux/kernel.h>
 #include <linux/io.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <plat/sched_clock.h>
 
 static void __iomem *ctr;
diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index 766611d..07ea7ce 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -28,8 +28,8 @@
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/irq.h>
 
 #define REG_CONTROL	0x00
diff --git a/drivers/clocksource/clksrc-dbx500-prcmu.c b/drivers/clocksource/clksrc-dbx500-prcmu.c
index 54f3d11..0a7fb24 100644
--- a/drivers/clocksource/clksrc-dbx500-prcmu.c
+++ b/drivers/clocksource/clksrc-dbx500-prcmu.c
@@ -14,8 +14,7 @@
  */
 #include <linux/clockchips.h>
 #include <linux/clksrc-dbx500-prcmu.h>
-
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 #define RATE_32K		32768
 
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index ab09ed3..f417e50 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -20,9 +20,9 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 
 static void timer_get_base_and_rate(struct device_node *np,
 				    void __iomem **base, u32 *rate)
diff --git a/drivers/clocksource/mxs_timer.c b/drivers/clocksource/mxs_timer.c
index 02af420..0f5e65f 100644
--- a/drivers/clocksource/mxs_timer.c
+++ b/drivers/clocksource/mxs_timer.c
@@ -29,9 +29,9 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/stmp_device.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 
 /*
  * There are 2 versions of the timrot on Freescale MXS-based SoCs.
diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index 071f6ea..e747fb1 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -18,8 +18,8 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/platform_data/clocksource-nomadik-mtu.h>
+#include <linux/sched_clock.h>
 #include <asm/mach/time.h>
-#include <asm/sched_clock.h>
 
 /*
  * The MTU device hosts four different counters, with 4 set of
diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index ae877b0..9396170 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -26,10 +26,10 @@
 #include <linux/io.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/sched_clock.h>
 
 #include <asm/mach/time.h>
 #include <asm/smp_twd.h>
-#include <asm/sched_clock.h>
 
 #define RTC_SECONDS            0x08
 #define RTC_SHADOW_SECONDS     0x0c
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 47a6730..efdca32 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -27,8 +27,8 @@
 #include <linux/of_address.h>
 #include <linux/irq.h>
 #include <linux/module.h>
+#include <linux/sched_clock.h>
 
-#include <asm/sched_clock.h>
 #include <asm/localtimer.h>
 #include <linux/percpu.h>
 /*
diff --git a/drivers/clocksource/timer-marco.c b/drivers/clocksource/timer-marco.c
index 97738db..e5dc912 100644
--- a/drivers/clocksource/timer-marco.c
+++ b/drivers/clocksource/timer-marco.c
@@ -17,7 +17,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 #include <asm/localtimer.h>
 #include <asm/mach/time.h>
 
diff --git a/drivers/clocksource/timer-prima2.c b/drivers/clocksource/timer-prima2.c
index 7608826..ef3cfb2 100644
--- a/drivers/clocksource/timer-prima2.c
+++ b/drivers/clocksource/timer-prima2.c
@@ -18,7 +18,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 #include <asm/mach/time.h>
 
 #define SIRFSOC_TIMER_COUNTER_LO	0x0000
diff --git a/arch/arm/include/asm/sched_clock.h b/include/linux/sched_clock.h
similarity index 76%
rename from arch/arm/include/asm/sched_clock.h
rename to include/linux/sched_clock.h
index e6f765a..495d4c6 100644
--- a/arch/arm/include/asm/sched_clock.h
+++ b/include/linux/sched_clock.h
@@ -5,10 +5,15 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#ifndef ASM_SCHED_CLOCK
-#define ASM_SCHED_CLOCK
+#ifndef LINUX_SCHED_CLOCK
+#define LINUX_SCHED_CLOCK
 
+#ifdef CONFIG_GENERIC_SCHED_CLOCK
 extern void sched_clock_postinit(void);
+#else
+static inline void sched_clock_postinit(void) { }
+#endif
+
 extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
 extern void setup_sched_clock_64(u64 (*read)(void), int bits,
 				 unsigned long rate);
diff --git a/init/Kconfig b/init/Kconfig
index 346cd1b..19237b6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -772,6 +772,9 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+config GENERIC_SCHED_CLOCK
+	bool
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
diff --git a/init/main.c b/init/main.c
index b3bc3c9..0e5504e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -72,6 +72,7 @@
 #include <linux/ptrace.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
+#include <linux/sched_clock.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -552,6 +553,7 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	sched_clock_postinit();
 	profile_init();
 	call_function_init();
 	WARN(!irqs_disabled(), "Interrupts were enabled early\n");
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index deaf90e..35abe4a 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
 obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
+obj-$(CONFIG_GENERIC_SCHED_CLOCK) += sched_clock.o
diff --git a/arch/arm/kernel/sched_clock.c b/kernel/sched/sched_clock.c
similarity index 99%
rename from arch/arm/kernel/sched_clock.c
rename to kernel/sched/sched_clock.c
index b6067d8..7556349 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/kernel/sched/sched_clock.c
@@ -13,8 +13,7 @@
 #include <linux/sched.h>
 #include <linux/syscore_ops.h>
 #include <linux/timer.h>
-
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 struct clock_data {
 	u64 epoch_ns;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

