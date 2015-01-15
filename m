Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbbAORBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:01:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55592 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752164AbbAORBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:01:37 -0500
Date: Thu, 15 Jan 2015 18:01:34 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 5/8] ARM: at91: move the restart function to the
 system timer driver
Message-ID: <20150115170134.GU3843@piout.net>
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421077023-30954-6-git-send-email-alexandre.belloni@free-electrons.com>
 <54B7ED29.9060700@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B7ED29.9060700@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 15/01/2015 at 17:39:05 +0100, Daniel Lezcano wrote :
> On 01/12/2015 04:37 PM, Alexandre Belloni wrote:
> >Restarting on an at91rm9200 is handled by using the system timer. Move that
> >function to the system timer driver.
> >
> >Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> >Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> >---
> >  arch/arm/mach-at91/at91rm9200.c      | 11 -----------
> >  drivers/clocksource/timer-atmel-st.c | 12 ++++++++++++
> >  2 files changed, 12 insertions(+), 11 deletions(-)
> >
> >diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
> >index b52916947535..4ea889cd6091 100644
> >--- a/arch/arm/mach-at91/at91rm9200.c
> >+++ b/arch/arm/mach-at91/at91rm9200.c
> >@@ -15,7 +15,6 @@
> >
> >  #include <asm/mach/map.h>
> >  #include <asm/system_misc.h>
> >-#include <mach/at91_st.h>
> >  #include <mach/hardware.h>
> >
> >  #include "soc.h"
> >@@ -30,15 +29,6 @@ static void at91rm9200_idle(void)
> >  	at91_pmc_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> >  }
> >
> >-static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
> >-{
> >-	/*
> >-	 * Perform a hardware reset with the use of the Watchdog timer.
> >-	 */
> >-	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
> >-	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
> >-}
> >-
> >  /* --------------------------------------------------------------------
> >   *  AT91RM9200 processor initialization
> >   * -------------------------------------------------------------------- */
> >@@ -51,7 +41,6 @@ static void __init at91rm9200_map_io(void)
> >  static void __init at91rm9200_initialize(void)
> >  {
> >  	arm_pm_idle = at91rm9200_idle;
> >-	arm_pm_restart = at91rm9200_restart;
> >  }
> >
> >
> >diff --git a/drivers/clocksource/timer-atmel-st.c b/drivers/clocksource/timer-atmel-st.c
> >index 51761f8927b7..522583d6cc78 100644
> >--- a/drivers/clocksource/timer-atmel-st.c
> >+++ b/drivers/clocksource/timer-atmel-st.c
> >@@ -29,6 +29,7 @@
> >  #include <linux/of_irq.h>
> >
> >  #include <asm/mach/time.h>
> >+#include <asm/system_misc.h>
> >
> >  #include <mach/at91_st.h>
> >  #include <mach/hardware.h>
> >@@ -180,6 +181,15 @@ static struct clock_event_device clkevt = {
> >  	.set_mode	= clkevt32k_mode,
> >  };
> >
> >+static void at91rm9200_restart(enum reboot_mode reboot_mode, const char *cmd)
> >+{
> >+	/*
> >+	 * Perform a hardware reset with the use of the Watchdog timer.
> >+	 */
> >+	at91_st_write(AT91_ST_WDMR, AT91_ST_RSTEN | AT91_ST_EXTEN | 1);
> >+	at91_st_write(AT91_ST_CR, AT91_ST_WDRST);
> >+}
> >+
> >  void __iomem *at91_st_base;
> >  EXPORT_SYMBOL_GPL(at91_st_base);
> >
> >@@ -248,4 +258,6 @@ void __init at91rm9200_timer_init(void)
> >
> >  	/* register clocksource */
> >  	clocksource_register_hz(&clk32k, AT91_SLOW_CLOCK);
> >+
> >+	arm_pm_restart = at91rm9200_restart;
> >  }
> 
> Mmh, I can't clearly explain why but I have a problem with that.
> 
> Can you explain why restart code falls in the clockevents driver ?
> 
> 

That is a temporary location before getting rid of it by writing a
proper reset driver that will use the same syscon.

The main goal is to remove mach/at91_st.h and direct accesses to the
system timer registers.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
