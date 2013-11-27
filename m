Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3K0Ecl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:32:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52803 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab3K0Eci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:32:38 -0500
Message-ID: <5295758C.2030907@ti.com>
Date: Wed, 27 Nov 2013 10:01:08 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mark.rutland@arm.com>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <galak@kernel.crashing.org>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <grygorii.strashko@ti.com>
Subject: Re: [PATCH v3 1/6] watchdog: davinci: change driver to use WDT core
References: <1385388285-10553-1-git-send-email-ivan.khoronzhuk@ti.com> <1385388285-10553-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385388285-10553-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 November 2013 07:34 PM, Ivan Khoronzhuk wrote:
> To reduce code duplicate and increase code readability use WDT core
> code to handle WDT interface.
> 
> Remove io_lock as the WDT core uses mutex to lock each wdt device.
> Remove wdt_state as the WDT core tracks state with its own variable.
> 
> The watchdog_init_timeout() can read timeout value from timeout-sec
> property if the passed value is out of bounds. The heartbeat is
> initialized in next way. If heartbeat is not set thought module
> parameter, try to read it's value from WDT node timeout-sec property.
> If node has no one, use default value.
> 
> The heartbeat is hold in wdd->timeout by WDT core, so use it in
> order to set timeout period.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

So this still causes a regression because the clk_get()
fails due to the changed device name. Please fold this
patch in (tested on DM365, compiled on rest).

Also, the change in device name (while needed) does not seem
to be related to usage of wdt core. Can you may be split
that change into a separate patch?

Thanks,
Sekhar

---8<---
diff --git a/arch/arm/mach-davinci/da830.c b/arch/arm/mach-davinci/da830.c
index 0813b51..82c6013 100644
--- a/arch/arm/mach-davinci/da830.c
+++ b/arch/arm/mach-davinci/da830.c
@@ -385,7 +385,7 @@ static struct clk_lookup da830_clks[] = {
 	CLK(NULL,		"pll0_sysclk7",	&pll0_sysclk7),
 	CLK("i2c_davinci.1",	NULL,		&i2c0_clk),
 	CLK(NULL,		"timer0",	&timerp64_0_clk),
-	CLK("watchdog",		NULL,		&timerp64_1_clk),
+	CLK("davinci-wdt",	NULL,		&timerp64_1_clk),
 	CLK(NULL,		"arm_rom",	&arm_rom_clk),
 	CLK(NULL,		"scr0_ss",	&scr0_ss_clk),
 	CLK(NULL,		"scr1_ss",	&scr1_ss_clk),
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 352984e..ccb2f58 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -443,7 +443,7 @@ static struct clk_lookup da850_clks[] = {
 	CLK(NULL,		"pll1_sysclk3",	&pll1_sysclk3),
 	CLK("i2c_davinci.1",	NULL,		&i2c0_clk),
 	CLK(NULL,		"timer0",	&timerp64_0_clk),
-	CLK("watchdog",		NULL,		&timerp64_1_clk),
+	CLK("davinci-wdt",	NULL,		&timerp64_1_clk),
 	CLK(NULL,		"arm_rom",	&arm_rom_clk),
 	CLK(NULL,		"tpcc0",	&tpcc0_clk),
 	CLK(NULL,		"tptc0",	&tptc0_clk),
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index ef9ff1f..4bb8132 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -375,7 +375,7 @@ static struct clk_lookup dm355_clks[] = {
 	CLK(NULL, "pwm3", &pwm3_clk),
 	CLK(NULL, "timer0", &timer0_clk),
 	CLK(NULL, "timer1", &timer1_clk),
-	CLK("watchdog", NULL, &timer2_clk),
+	CLK("davinci-wdt", NULL, &timer2_clk),
 	CLK(NULL, "timer3", &timer3_clk),
 	CLK(NULL, "rto", &rto_clk),
 	CLK(NULL, "usb", &usb_clk),
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 1511a06..b0e8df3 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -473,7 +473,7 @@ static struct clk_lookup dm365_clks[] = {
 	CLK(NULL, "pwm3", &pwm3_clk),
 	CLK(NULL, "timer0", &timer0_clk),
 	CLK(NULL, "timer1", &timer1_clk),
-	CLK("watchdog", NULL, &timer2_clk),
+	CLK("davinci-wdt", NULL, &timer2_clk),
 	CLK(NULL, "timer3", &timer3_clk),
 	CLK(NULL, "usb", &usb_clk),
 	CLK("davinci_emac.1", NULL, &emac_clk),
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 143a321..aeaad95 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -322,7 +322,7 @@ static struct clk_lookup dm644x_clks[] = {
 	CLK(NULL, "pwm2", &pwm2_clk),
 	CLK(NULL, "timer0", &timer0_clk),
 	CLK(NULL, "timer1", &timer1_clk),
-	CLK("watchdog", NULL, &timer2_clk),
+	CLK("davinci-wdt", NULL, &timer2_clk),
 	CLK(NULL, NULL, NULL),
 };
 
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 2a73f29..a56779b 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -356,7 +356,7 @@ static struct clk_lookup dm646x_clks[] = {
 	CLK(NULL, "pwm1", &pwm1_clk),
 	CLK(NULL, "timer0", &timer0_clk),
 	CLK(NULL, "timer1", &timer1_clk),
-	CLK("watchdog", NULL, &timer2_clk),
+	CLK("davinci-wdt", NULL, &timer2_clk),
 	CLK("palm_bk3710", NULL, &ide_clk),
 	CLK(NULL, "vpif0", &vpif0_clk),
 	CLK(NULL, "vpif1", &vpif1_clk),

