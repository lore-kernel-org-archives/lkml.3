Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaLQDOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:14:55 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33837 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaLQDOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:14:54 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH] ARM: brcmstb: update CPU power management sequence
Date: Tue, 16 Dec 2014 19:13:50 -0800
Message-Id: <1418786030-23455-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The automatic CPU power state machine for B15 CPUs does not work
reliably as-is. This patch implements a manual sequence in software to
replace it.

This was tested successfully with over 10,000 hotplug cycles of
something like this:

  echo 0 > /sys/devices/system/cpu/cpu1/online
  echo 1 > /sys/devices/system/cpu/cpu1/online

whereas the existing sequence often locks up after a few hundred cycles.

Fixes: 62639c2f5332 ("ARM: brcmstb: reintroduce SMP support")
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
---
 arch/arm/mach-bcm/platsmp-brcmstb.c | 85 +++++++++++++++++++++++++++----------
 1 file changed, 63 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-bcm/platsmp-brcmstb.c b/arch/arm/mach-bcm/platsmp-brcmstb.c
index 31c87a284a34..e209e6fc7caf 100644
--- a/arch/arm/mach-bcm/platsmp-brcmstb.c
+++ b/arch/arm/mach-bcm/platsmp-brcmstb.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/jiffies.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/printk.h>
@@ -94,10 +95,35 @@ static u32 pwr_ctrl_rd(u32 cpu)
 	return readl_relaxed(base);
 }
 
-static void pwr_ctrl_wr(u32 cpu, u32 val)
+static void pwr_ctrl_set(unsigned int cpu, u32 val, u32 mask)
 {
 	void __iomem *base = pwr_ctrl_get_base(cpu);
-	writel(val, base);
+	writel((readl(base) & mask) | val, base);
+}
+
+static void pwr_ctrl_clr(unsigned int cpu, u32 val, u32 mask)
+{
+	void __iomem *base = pwr_ctrl_get_base(cpu);
+	writel((readl(base) & mask) & ~val, base);
+}
+
+#define POLL_TMOUT_MS 500
+static int pwr_ctrl_wait_tmout(unsigned int cpu, u32 set, u32 mask)
+{
+	const unsigned long timeo = jiffies + msecs_to_jiffies(POLL_TMOUT_MS);
+	u32 tmp;
+
+	do {
+		tmp = pwr_ctrl_rd(cpu) & mask;
+		if (!set == !tmp)
+			return 0;
+	} while (time_before(jiffies, timeo));
+
+	tmp = pwr_ctrl_rd(cpu) & mask;
+	if (!set == !tmp)
+		return 0;
+
+	return -ETIMEDOUT;
 }
 
 static void cpu_rst_cfg_set(u32 cpu, int set)
@@ -139,15 +165,22 @@ static void brcmstb_cpu_power_on(u32 cpu)
 	 * The secondary cores power was cut, so we must go through
 	 * power-on initialization.
 	 */
-	u32 tmp;
+	pwr_ctrl_set(cpu, ZONE_MAN_ISO_CNTL_MASK, 0xffffff00);
+	pwr_ctrl_set(cpu, ZONE_MANUAL_CONTROL_MASK, -1);
+	pwr_ctrl_set(cpu, ZONE_RESERVED_1_MASK, -1);
 
-	/* Request zone power up */
-	pwr_ctrl_wr(cpu, ZONE_PWR_UP_REQ_MASK);
+	pwr_ctrl_set(cpu, ZONE_MAN_MEM_PWR_MASK, -1);
 
-	/* Wait for the power up FSM to complete */
-	do {
-		tmp = pwr_ctrl_rd(cpu);
-	} while (!(tmp & ZONE_PWR_ON_STATE_MASK));
+	if (pwr_ctrl_wait_tmout(cpu, 1, ZONE_MEM_PWR_STATE_MASK))
+		panic("ZONE_MEM_PWR_STATE_MASK set timeout");
+
+	pwr_ctrl_set(cpu, ZONE_MAN_CLKEN_MASK, -1);
+
+	if (pwr_ctrl_wait_tmout(cpu, 1, ZONE_DPG_PWR_STATE_MASK))
+		panic("ZONE_DPG_PWR_STATE_MASK set timeout");
+
+	pwr_ctrl_clr(cpu, ZONE_MAN_ISO_CNTL_MASK, -1);
+	pwr_ctrl_set(cpu, ZONE_MAN_RESET_CNTL_MASK, -1);
 }
 
 static int brcmstb_cpu_get_power_state(u32 cpu)
@@ -174,25 +207,33 @@ static void brcmstb_cpu_die(u32 cpu)
 
 static int brcmstb_cpu_kill(u32 cpu)
 {
-	u32 tmp;
+	/*
+	 * Ordinarily, the hardware forbids power-down of CPU0 (which is good
+	 * because it is the boot CPU), but this is not true when using BPCM
+	 * manual mode.  Consequently, we must avoid turning off CPU0 here to
+	 * ensure that TI2C master reset will work.
+	 */
+	if (cpu == 0) {
+		pr_warn("SMP: refusing to power off CPU0\n");
+		return 1;
+	}
 
 	while (per_cpu_sw_state_rd(cpu))
 		;
 
-	/* Program zone reset */
-	pwr_ctrl_wr(cpu, ZONE_RESET_STATE_MASK | ZONE_BLK_RST_ASSERT_MASK |
-			      ZONE_PWR_DN_REQ_MASK);
+	pwr_ctrl_set(cpu, ZONE_MANUAL_CONTROL_MASK, -1);
+	pwr_ctrl_clr(cpu, ZONE_MAN_RESET_CNTL_MASK, -1);
+	pwr_ctrl_clr(cpu, ZONE_MAN_CLKEN_MASK, -1);
+	pwr_ctrl_set(cpu, ZONE_MAN_ISO_CNTL_MASK, -1);
+	pwr_ctrl_clr(cpu, ZONE_MAN_MEM_PWR_MASK, -1);
 
-	/* Verify zone reset */
-	tmp = pwr_ctrl_rd(cpu);
-	if (!(tmp & ZONE_RESET_STATE_MASK))
-		pr_err("%s: Zone reset bit for CPU %d not asserted!\n",
-			__func__, cpu);
+	if (pwr_ctrl_wait_tmout(cpu, 0, ZONE_MEM_PWR_STATE_MASK))
+		panic("ZONE_MEM_PWR_STATE_MASK clear timeout");
 
-	/* Wait for power down */
-	do {
-		tmp = pwr_ctrl_rd(cpu);
-	} while (!(tmp & ZONE_PWR_OFF_STATE_MASK));
+	pwr_ctrl_clr(cpu, ZONE_RESERVED_1_MASK, -1);
+
+	if (pwr_ctrl_wait_tmout(cpu, 0, ZONE_DPG_PWR_STATE_MASK))
+		panic("ZONE_DPG_PWR_STATE_MASK clear timeout");
 
 	/* Flush pipeline before resetting CPU */
 	mb();
-- 
1.9.1

