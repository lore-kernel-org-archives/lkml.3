Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3LJN2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:28:09 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53527 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LJN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:28:03 -0500
Message-ID: <52A716E0.4080103@linaro.org>
Date: Tue, 10 Dec 2013 14:28:00 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Axel Lin <axel.lin@ingics.com>, Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL RESEND] clocksource/clockevents fixes for 3.13
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas, Ingo,

here are the fixes for 3.13 based on timers/urgent

  * Axel Lin added a missing dependency on CLKSRC_MMIO in the Kconfig 
for the time-efm32.

  * Dinh Nguyen fixed read_sched_clock to return the right value for the 
dw_apb_timer.

  * Ezequiel Garcia registered the sched clock after the counter, thus 
preventing time jump in the traces for the armada-370-xp.

  * Marc Zyngier stopped the timer before enabling the irq in order to 
prevent it to be fired before the clockevent is registered for the sunxi.

  * Thierry Reding removed a of_node_put in clksrc-of because the 
reference is not held.

Thanks

   -- Daniel

----------------------------------------------------------------

The following changes since commit 0e576acbc1d9600cf2d9b4a141a2554639959d50:

   nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off 
(2013-11-29 12:23:03 +0100)

are available in the git repository at:

   git://git.linaro.org/people/daniel.lezcano/linux.git clockevents/fixes

for you to fetch changes up to d28420aabbe4a7792c9ef4f5c4bd6e776414583f:

   clocksource: sunxi: Stop timer from ticking before enabling 
interrupts (2013-12-10 13:56:43 +0100)

----------------------------------------------------------------
Axel Lin (1):
       clocksource: time-efm32: Select CLKSRC_MMIO

Dinh Nguyen (2):
       clocksource: dw_apb_timer: Move timer defines to header file.
       clocksource: dw_apb_timer_of: Fix read_sched_clock

Ezequiel Garcia (1):
       clocksource: armada-370-xp: Register sched_clock after the 
counter res
Marc Zyngier (1):
       clocksource: sunxi: Stop timer from ticking before enabling 
interrupts

Thierry Reding (1):
       clocksource: clksrc-of: Do not drop unheld reference on device node

  drivers/clocksource/Kconfig              |    1 +
  drivers/clocksource/clksrc-of.c          |    1 -
  drivers/clocksource/dw_apb_timer.c       |   19 -------------------
  drivers/clocksource/dw_apb_timer_of.c    |    9 +++++----
  drivers/clocksource/sun4i_timer.c        |    3 +++
  drivers/clocksource/time-armada-370-xp.c |   10 +++++-----
  include/linux/dw_apb_timer.h             |   19 +++++++++++++++++++
  7 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 5c07a56..634c4d6 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -75,6 +75,7 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
  config CLKSRC_EFM32
  	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
  	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
+	select CLKSRC_MMIO
  	default ARCH_EFM32
  	help
  	  Support to use the timers of EFM32 SoCs as clock source and clock
diff --git a/drivers/clocksource/clksrc-of.c 
b/drivers/clocksource/clksrc-of.c
index 35639cf4..b9ddd9e 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -35,6 +35,5 @@ void __init clocksource_of_init(void)

  		init_func = match->data;
  		init_func(np);
-		of_node_put(np);
  	}
  }
diff --git a/drivers/clocksource/dw_apb_timer.c 
b/drivers/clocksource/dw_apb_timer.c
index e54ca10..c3a8f52 100644
--- a/drivers/clocksource/dw_apb_timer.c
+++ b/drivers/clocksource/dw_apb_timer.c
@@ -18,25 +18,6 @@
  #include <linux/io.h>
  #include <linux/slab.h>

-#define APBT_MIN_PERIOD			4
-#define APBT_MIN_DELTA_USEC		200
-
-#define APBTMR_N_LOAD_COUNT		0x00
-#define APBTMR_N_CURRENT_VALUE		0x04
-#define APBTMR_N_CONTROL		0x08
-#define APBTMR_N_EOI			0x0c
-#define APBTMR_N_INT_STATUS		0x10
-
-#define APBTMRS_INT_STATUS		0xa0
-#define APBTMRS_EOI			0xa4
-#define APBTMRS_RAW_INT_STATUS		0xa8
-#define APBTMRS_COMP_VERSION		0xac
-
-#define APBTMR_CONTROL_ENABLE		(1 << 0)
-/* 1: periodic, 0:free running. */
-#define APBTMR_CONTROL_MODE_PERIODIC	(1 << 1)
-#define APBTMR_CONTROL_INT		(1 << 2)
-
  static inline struct dw_apb_clock_event_device *
  ced_to_dw_apb_ced(struct clock_event_device *evt)
  {
diff --git a/drivers/clocksource/dw_apb_timer_of.c 
b/drivers/clocksource/dw_apb_timer_of.c
index 45ba8ae..c3fe17e 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -102,18 +102,17 @@ static void __init add_clocksource(struct 
device_node *source_timer)
  	 * timer is found. sched_io_base then points to the current_value
  	 * register of the clocksource timer.
  	 */
-	sched_io_base = iobase + 0x04;
+	sched_io_base = iobase;
  	sched_rate = rate;
  }

  static u64 read_sched_clock(void)
  {
-	return __raw_readl(sched_io_base);
+	return ~__raw_readl(sched_io_base + APBTMR_N_CURRENT_VALUE);
  }

  static const struct of_device_id sptimer_ids[] __initconst = {
  	{ .compatible = "picochip,pc3x2-rtc" },
-	{ .compatible = "snps,dw-apb-timer-sp" },
  	{ /* Sentinel */ },
  };

@@ -151,4 +150,6 @@ static void __init dw_apb_timer_init(struct 
device_node *timer)
  	num_called++;
  }
  CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", 
dw_apb_timer_init);
-CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", 
dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_osc, "snps,dw-apb-timer-osc", 
dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer_sp, "snps,dw-apb-timer-sp", 
dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer", dw_apb_timer_init);
diff --git a/drivers/clocksource/sun4i_timer.c 
b/drivers/clocksource/sun4i_timer.c
index 2fb4695..a4f6119 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -179,6 +179,9 @@ static void __init sun4i_timer_init(struct 
device_node *node)
  	writel(TIMER_CTL_CLK_SRC(TIMER_CTL_CLK_SRC_OSC24M),
  	       timer_base + TIMER_CTL_REG(0));

+	/* Make sure timer is stopped before playing with interrupts */
+	sun4i_clkevt_time_stop(0);
+
  	ret = setup_irq(irq, &sun4i_timer_irq);
  	if (ret)
  		pr_warn("failed to setup irq %d\n", irq);
diff --git a/drivers/clocksource/time-armada-370-xp.c 
b/drivers/clocksource/time-armada-370-xp.c
index d8e47e5..4e7f680 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -256,11 +256,6 @@ static void __init 
armada_370_xp_timer_common_init(struct device_node *np)
  	ticks_per_jiffy = (timer_clk + HZ / 2) / HZ;

  	/*
-	 * Set scale and timer for sched_clock.
-	 */
-	sched_clock_register(armada_370_xp_read_sched_clock, 32, timer_clk);
-
-	/*
  	 * Setup free-running clocksource timer (interrupts
  	 * disabled).
  	 */
@@ -270,6 +265,11 @@ static void __init 
armada_370_xp_timer_common_init(struct device_node *np)
  	timer_ctrl_clrset(0, TIMER0_EN | TIMER0_RELOAD_EN |
  			     TIMER0_DIV(TIMER_DIVIDER_SHIFT));

+	/*
+	 * Set scale and timer for sched_clock.
+	 */
+	sched_clock_register(armada_370_xp_read_sched_clock, 32, timer_clk);
+
  	clocksource_mmio_init(timer_base + TIMER0_VAL_OFF,
  			      "armada_370_xp_clocksource",
  			      timer_clk, 300, 32, clocksource_mmio_readl_down);
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 1f79b20..1d2b949 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -19,6 +19,25 @@

  #define APBTMRS_REG_SIZE       0x14

+#define APBT_MIN_PERIOD                 4
+#define APBT_MIN_DELTA_USEC             200
+
+#define APBTMR_N_LOAD_COUNT             0x00
+#define APBTMR_N_CURRENT_VALUE          0x04
+#define APBTMR_N_CONTROL                0x08
+#define APBTMR_N_EOI                    0x0c
+#define APBTMR_N_INT_STATUS             0x10
+
+#define APBTMRS_INT_STATUS              0xa0
+#define APBTMRS_EOI                     0xa4
+#define APBTMRS_RAW_INT_STATUS          0xa8
+#define APBTMRS_COMP_VERSION            0xac
+
+#define APBTMR_CONTROL_ENABLE           (1 << 0)
+/* 1: periodic, 0:free running. */
+#define APBTMR_CONTROL_MODE_PERIODIC    (1 << 1)
+#define APBTMR_CONTROL_INT              (1 << 2)
+
  struct dw_apb_timer {
  	void __iomem				*base;
  	unsigned long				freq;

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

