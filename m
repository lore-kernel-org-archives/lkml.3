Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaIEVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:16:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46763 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaIEVQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:16:25 -0400
Date: Fri, 5 Sep 2014 16:15:58 -0500
From: Nishanth Menon <nm@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH 07/10] ARM: OMAP5 / DRA7: Enable CPU RET on suspend
Message-ID: <20140905211558.GA31011@kahuna>
References: <1408716154-26101-1-git-send-email-nm@ti.com>
 <1408716154-26101-8-git-send-email-nm@ti.com>
 <7hbnr5dake.fsf@paris.lan>
 <53FE2BF2.3020006@ti.com>
 <20140827194156.GE16006@atomide.com>
 <53FE34D7.7040004@ti.com>
 <53FE3551.2080806@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53FE3551.2080806@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:45-20140827, Nishanth Menon wrote:
> On 08/27/2014 02:43 PM, Santosh Shilimkar wrote:
> > On Wednesday 27 August 2014 03:41 PM, Tony Lindgren wrote:
> >> * Nishanth Menon <nm@ti.com> [140827 12:05]:
> >>> On 08/27/2014 01:58 PM, Kevin Hilman wrote:
> >>>> Nishanth Menon <nm@ti.com> writes:
> >>>>
> >>>>> From: Rajendra Nayak <rnayak@ti.com>
> >>>>>
> >>>>> On OMAP5 / DRA7, prevent a CPU powerdomain OFF and resulting MPU OSWR
> >>>>> and instead attempt a CPU RET and side effect, MPU RET in suspend.
> >>>>>
> >>>>> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> >>>>> [nm@ti.com: update to do save_state only on DRA7]
> >>>>> Signed-off-by: Nishanth Menon <nm@ti.com>
> >>>>> ---
> >>>>>  arch/arm/mach-omap2/omap-mpuss-lowpower.c |    4 ++++
> >>>>>  arch/arm/mach-omap2/omap-wakeupgen.c      |    2 +-
> >>>>>  arch/arm/mach-omap2/pm44xx.c              |    9 +++++++--
> >>>>>  3 files changed, 12 insertions(+), 3 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> >>>>> index 207fce2..0d640eb 100644
> >>>>> --- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> >>>>> +++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> >>>>> @@ -242,6 +242,10 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
> >>>>>  		save_state = 1;
> >>>>>  		break;
> >>>>>  	case PWRDM_POWER_RET:
> >>>>> +		if (soc_is_omap54xx() || soc_is_dra7xx()) {
> >>>>
> >>>> Aren't we trying to get away from these soc_* checks for anything other
> >>>> than init code?
> >>>
> >>> I would expect that to take place in stages as part of which the next
> >>> level of cleanup is to move PRM into drivers. Currently our wakeupgen,
> >>> prm code does have quiet a few needs of dealing with soc_is checks
> >>> primarily from having to re-architect code in two different directions
> >>> - we want to move into just one direction eventually - to prm drivers
> >>> and as less code in mach-omap2 which is already in the works.
> >>
> >> Why don't you just set some flag at init time based on the
> >> soc_is check and then test that here? That limits the use of
> >> soc_is to init code only which makes it easier to phase it
> >> out completely eventually.
> >>
> > Indeed. Infact the version of the code I tried posting last year was
> > using a flag which was initialised during init. Same can be
> > done her.
> 
> OK. will try something along that line in the next rev.


Hi,

Updated patch below:
Do let me know if this is ok with folks.

---8<----
>From 1b9e11834dac2bd75c396aa7495c806b027653fe Mon Sep 17 00:00:00 2001
From: Rajendra Nayak <rnayak@ti.com>
Date: Mon, 27 May 2013 15:46:44 +0530
Subject: [PATCH V2 7/10] ARM: OMAP5 / DRA7: Enable CPU RET on suspend

On OMAP5 / DRA7, prevent a CPU powerdomain OFF and resulting MPU OSWR
and instead attempt a CPU RET and side effect, MPU RET in suspend.

NOTE: the hardware was originally designed to be capable of achieving
deep power states such as OFF and OSWR, however due to various issues
and risks, deepest valid state was determined to be CSWR - hence we use
the errata framework to handle this case.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
[nm@ti.com: updates]
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |    4 ++++
 arch/arm/mach-omap2/omap-wakeupgen.c      |    3 ++-
 arch/arm/mach-omap2/pm.h                  |    1 +
 arch/arm/mach-omap2/pm44xx.c              |   12 ++++++++++--
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 207fce2..297352f 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -242,6 +242,10 @@ int omap4_enter_lowpower(unsigned int cpu, unsigned int power_state)
 		save_state = 1;
 		break;
 	case PWRDM_POWER_RET:
+		if (IS_PM44XX_ERRATUM(PM_OMAP4_CPU_OSWR_DISABLE)) {
+			save_state = 0;
+			break;
+		}
 	default:
 		/*
 		 * CPUx CSWR is invalid hardware state. Also CPUx OSWR
diff --git a/arch/arm/mach-omap2/omap-wakeupgen.c b/arch/arm/mach-omap2/omap-wakeupgen.c
index e844e16..f961c46 100644
--- a/arch/arm/mach-omap2/omap-wakeupgen.c
+++ b/arch/arm/mach-omap2/omap-wakeupgen.c
@@ -32,6 +32,7 @@
 #include "soc.h"
 #include "omap4-sar-layout.h"
 #include "common.h"
+#include "pm.h"
 
 #define AM43XX_NR_REG_BANKS	7
 #define AM43XX_IRQS		224
@@ -381,7 +382,7 @@ static struct notifier_block irq_notifier_block = {
 static void __init irq_pm_init(void)
 {
 	/* FIXME: Remove this when MPU OSWR support is added */
-	if (!soc_is_omap54xx())
+	if (!IS_PM44XX_ERRATUM(PM_OMAP4_CPU_OSWR_DISABLE))
 		cpu_pm_register_notifier(&irq_notifier_block);
 }
 #else
diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index e150102..425bfcd 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -101,6 +101,7 @@ static inline void enable_omap3630_toggle_l2_on_restore(void) { }
 #endif		/* defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP3) */
 
 #define PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD	(1 << 0)
+#define PM_OMAP4_CPU_OSWR_DISABLE		(1 << 1)
 
 #if defined(CONFIG_PM) && defined(CONFIG_ARCH_OMAP4)
 extern u16 pm44xx_errata;
diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index b6f243d..64df620 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -36,6 +36,8 @@ struct power_state {
 	struct list_head node;
 };
 
+static u32 cpu_suspend_state = PWRDM_POWER_OFF;
+
 static LIST_HEAD(pwrst_list);
 
 #ifdef CONFIG_SUSPEND
@@ -66,7 +68,7 @@ static int omap4_pm_suspend(void)
 	 * domain CSWR is not supported by hardware.
 	 * More details can be found in OMAP4430 TRM section 4.3.4.2.
 	 */
-	omap4_enter_lowpower(cpu_id, PWRDM_POWER_OFF);
+	omap4_enter_lowpower(cpu_id, cpu_suspend_state);
 
 	/* Restore next powerdomain state */
 	list_for_each_entry(pwrst, &pwrst_list, node) {
@@ -112,8 +114,11 @@ static int __init pwrdms_setup(struct powerdomain *pwrdm, void *unused)
 	 * through hotplug path and CPU0 explicitly programmed
 	 * further down in the code path
 	 */
-	if (!strncmp(pwrdm->name, "cpu", 3))
+	if (!strncmp(pwrdm->name, "cpu", 3)) {
+		if (IS_PM44XX_ERRATUM(PM_OMAP4_CPU_OSWR_DISABLE))
+			cpu_suspend_state = PWRDM_POWER_RET;
 		return 0;
+	}
 
 	pwrst = kmalloc(sizeof(struct power_state), GFP_ATOMIC);
 	if (!pwrst)
@@ -238,6 +243,9 @@ int __init omap4_pm_init_early(void)
 	if (cpu_is_omap446x())
 		pm44xx_errata |= PM_OMAP4_ROM_SMP_BOOT_ERRATUM_GICD;
 
+	if (soc_is_omap54xx() || soc_is_dra7xx())
+		pm44xx_errata |= PM_OMAP4_CPU_OSWR_DISABLE;
+
 	return 0;
 }
 
-- 
1.7.9.5

-- 
Regards,
Nishanth Menon
