Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3FBGkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 02:40:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35576 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3FBGjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 02:39:49 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv2 3/6] sched_clock: Make ARM's sched_clock generic for all architectures
Date: Sat,  1 Jun 2013 23:39:40 -0700
Message-Id: <1370155183-31421-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc3.8.g5e49f30.dirty
In-Reply-To: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing about the sched_clock implementation in the ARM port is
specific to the architecture. Generalize the code so that other
architectures can use it by selecting GENERIC_SCHED_CLOCK.

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
 drivers/clocksource/samsung_pwm_timer.c               | 2 +-
 drivers/clocksource/tegra20_timer.c                   | 2 +-
 drivers/clocksource/time-armada-370-xp.c              | 2 +-
 drivers/clocksource/timer-marco.c                     | 2 +-
 drivers/clocksource/timer-prima2.c                    | 2 +-
 {arch/arm/include/asm => include/linux}/sched_clock.h | 9 +++++++--
 init/Kconfig                                          | 3 +++
 init/main.c                                           | 2 ++
 kernel/time/Makefile                                  | 1 +
 {arch/arm/kernel => kernel/time}/sched_clock.c        | 3 +--
 36 files changed, 45 insertions(+), 37 deletions(-)
 rename {arch/arm/include/asm => include/linux}/sched_clock.h (75%)
 rename {arch/arm/kernel => kernel/time}/sched_clock.c (99%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 49d993c..53d3a35 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
+	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_STRNCPY_FROM_USER
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
index 5f3338e..97cb057 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -16,7 +16,7 @@ CFLAGS_REMOVE_return_address.o = -pg
 # Object file lists.
 
 obj-y		:= elf.o entry-armv.o entry-common.o irq.o opcodes.o \
-		   process.o ptrace.o return_address.o sched_clock.o \
+		   process.o ptrace.o return_address.o \
 		   setup.o signal.o stacktrace.o sys_arm.o time.o traps.o
 
 obj-$(CONFIG_ATAGS)		+= atags_parse.o
diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index 59dcdce..221f07b 100644
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
index f8b23b8..4c069b0 100644
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
index e405531..8864c17 100644
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
diff --git a/drivers/clocksource/samsung_pwm_timer.c b/drivers/clocksource/samsung_pwm_timer.c
index 0234c8d..584b547 100644
--- a/drivers/clocksource/samsung_pwm_timer.c
+++ b/drivers/clocksource/samsung_pwm_timer.c
@@ -21,10 +21,10 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sched_clock.h>
 
 #include <clocksource/samsung_pwm.h>
 
-#include <asm/sched_clock.h>
 
 /*
  * Clocksource driver
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
similarity index 75%
rename from arch/arm/include/asm/sched_clock.h
rename to include/linux/sched_clock.h
index 3d520dd..fa7922c 100644
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
 
 extern unsigned long long (*sched_clock_func)(void);
diff --git a/init/Kconfig b/init/Kconfig
index 9d3a788..1a3f933 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -757,6 +757,9 @@ config LOG_BUF_SHIFT
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
+config GENERIC_SCHED_CLOCK
+	bool
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
diff --git a/init/main.c b/init/main.c
index 9484f4b..bef4a6a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -74,6 +74,7 @@
 #include <linux/ptrace.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
+#include <linux/sched_clock.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -555,6 +556,7 @@ asmlinkage void __init start_kernel(void)
 	softirq_init();
 	timekeeping_init();
 	time_init();
+	sched_clock_postinit();
 	profile_init();
 	call_function_init();
 	WARN(!irqs_disabled(), "Interrupts were enabled early\n");
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index ff7d9d2..6644658 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -4,6 +4,7 @@ obj-y += timeconv.o posix-clock.o alarmtimer.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o
+obj-$(CONFIG_GENERIC_SCHED_CLOCK)		+= sched_clock.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
 obj-$(CONFIG_TIMER_STATS)			+= timer_stats.o
diff --git a/arch/arm/kernel/sched_clock.c b/kernel/time/sched_clock.c
similarity index 99%
rename from arch/arm/kernel/sched_clock.c
rename to kernel/time/sched_clock.c
index a781c59..aad1ae6 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/kernel/time/sched_clock.c
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

