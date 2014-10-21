Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbaJUUZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:25:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41362 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbaJUUZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:25:09 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: OMAP4+: PM: Program CPU logic power state
Date: Tue, 21 Oct 2014 15:24:36 -0500
Message-ID: <1413923076-26063-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU logic power state is never programmed in either the initialization
or the suspend/resume logic, instead, we depend on mpuss to program this
properly. However, this leaves CPU logic power state indeterminate and
most probably in reset configuration (If bootloader or other similar
software have'nt monkeyed with the register). This can make powerstate=
RET be either programmed for CSWR (logic=ret) or OSWR(logic = OFF) and
in OSWR, there can be context loss when the code does not expect it.

To prevent all these confusions, just support clearly ON, INA, CSWR,
OFF which is the intent of the existing code by explicitly programming
logic state.

NOTE: since this is a hot path (using in cpuidle), the exit path just
programs powerstate (logic state is immaterial when powerstate is ON).

Without doing this, we end up with lockups when CPUs enter OSWR and
multiple blocks loose context, when we expect them to hit CSWR.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 6944ae3..79f49d9 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -227,7 +227,7 @@ static void __init save_l2x0_context(void)
 int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
 {
 	struct omap4_cpu_pm_info *pm_info = &per_cpu(omap4_pm_info, cpu);
-	unsigned int save_state = 0;
+	unsigned int save_state = 0, cpu_logic_state = PWRDM_POWER_RET;
 	unsigned int wakeup_cpu;
 
 	if (omap_rev() == OMAP4430_REV_ES1_0)
@@ -239,6 +239,7 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
 		save_state = 0;
 		break;
 	case PWRDM_POWER_OFF:
+		cpu_logic_state = PWRDM_POWER_OFF;
 		save_state = 1;
 		break;
 	case PWRDM_POWER_RET:
@@ -270,6 +271,7 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
 
 	cpu_clear_prev_logic_pwrst(cpu);
 	pwrdm_set_next_pwrst(pm_info->pwrdm, power_state);
+	pwrdm_set_logic_retst(pm_info->pwrdm, cpu_logic_state);
 	set_cpu_wakeup_addr(cpu, virt_to_phys(omap_pm_ops.resume));
 	omap_pm_ops.scu_prepare(cpu, power_state);
 	l2x0_pwrst_prepare(cpu, save_state);
-- 
1.7.9.5

