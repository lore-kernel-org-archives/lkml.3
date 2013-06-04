Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3FDJi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:38:59 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57518 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab3FDJiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:38:54 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH v2 4/4] clocksource: dw_apb_timer_of: use clocksource_of_init
Date: Tue, 4 Jun 2013 11:38:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
References: <201306041136.09566.heiko@sntech.de>
In-Reply-To: <201306041136.09566.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041138.42639.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dw_apb_timer_init used to search the devicetree for matching timer
devices, making calls to it from board files necessary.

Change the dw_apb_timer_init to work with CLOCKSOURCE_OF_DECLARE.
With this change the function gets called once for each timer node
and tracks these number of calls to attach clockevent and clocksource
devices to the nodes.

Also remove the calls to dw_apb_timer_init from all previous users, as
clocksource_of_init is the default for init_time now.

Tested on the upcoming rk3066 code.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-picoxcell/common.c      |    2 -
 arch/arm/mach-socfpga/socfpga.c       |    2 -
 drivers/clocksource/Kconfig           |    1 +
 drivers/clocksource/dw_apb_timer_of.c |   41 ++++++++++++++++-----------------
 include/linux/dw_apb_timer.h          |    1 -
 5 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
index 70b441a..7cde042 100644
--- a/arch/arm/mach-picoxcell/common.c
+++ b/arch/arm/mach-picoxcell/common.c
@@ -15,7 +15,6 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
-#include <linux/dw_apb_timer.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -88,7 +87,6 @@ DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
 	.map_io		= picoxcell_map_io,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= irqchip_init,
-	.init_time	= dw_apb_timer_init,
 	.init_machine	= picoxcell_init_machine,
 	.dt_compat	= picoxcell_dt_match,
 	.restart	= picoxcell_wdt_restart,
diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
index 46a0513..8ea11b47 100644
--- a/arch/arm/mach-socfpga/socfpga.c
+++ b/arch/arm/mach-socfpga/socfpga.c
@@ -14,7 +14,6 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#include <linux/dw_apb_timer.h>
 #include <linux/clk-provider.h>
 #include <linux/irqchip.h>
 #include <linux/of_address.h>
@@ -120,7 +119,6 @@ DT_MACHINE_START(SOCFPGA, "Altera SOCFPGA")
 	.smp		= smp_ops(socfpga_smp_ops),
 	.map_io		= socfpga_map_io,
 	.init_irq	= socfpga_init_irq,
-	.init_time	= dw_apb_timer_init,
 	.init_machine	= socfpga_cyclone5_init,
 	.restart	= socfpga_cyclone5_restart,
 	.dt_compat	= altera_dt_match,
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 48a0f2e..5871933 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -22,6 +22,7 @@ config DW_APB_TIMER
 config DW_APB_TIMER_OF
 	bool
 	select DW_APB_TIMER
+	select CLKSRC_OF
 
 config ARMADA_370_XP_TIMER
 	bool
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 1964f87..cef5544 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -133,27 +133,26 @@ static void init_sched_clock(void)
 	setup_sched_clock(read_sched_clock, 32, sched_rate);
 }
 
-static const struct of_device_id osctimer_ids[] __initconst = {
-	{ .compatible = "picochip,pc3x2-timer" },
-	{ .compatible = "snps,dw-apb-timer-osc" },
-	{},
-};
-
-void __init dw_apb_timer_init(void)
+static int num_called;
+static void __init dw_apb_timer_init(struct device_node *timer)
 {
-	struct device_node *event_timer, *source_timer;
-
-	event_timer = of_find_matching_node(NULL, osctimer_ids);
-	if (!event_timer)
-		panic("No timer for clockevent");
-	add_clockevent(event_timer);
-
-	source_timer = of_find_matching_node(event_timer, osctimer_ids);
-	if (!source_timer)
-		panic("No timer for clocksource");
-	add_clocksource(source_timer);
-
-	of_node_put(source_timer);
+	switch (num_called) {
+	case 0:
+		pr_debug("%s: found clockevent timer\n", __func__);
+		add_clockevent(timer);
+		of_node_put(timer);
+		break;
+	case 1:
+		pr_debug("%s: found clocksource timer\n", __func__);
+		add_clocksource(timer);
+		of_node_put(timer);
+		init_sched_clock();
+		break;
+	default:
+		break;
+	}
 
-	init_sched_clock();
+	num_called++;
 }
+CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", dw_apb_timer_init);
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index dd755ce..07261d5 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -53,5 +53,4 @@ void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
 
-extern void dw_apb_timer_init(void);
 #endif /* __DW_APB_TIMER_H__ */
-- 
1.7.2.3

