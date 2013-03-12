Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3CLOfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:35:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49505 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab3CLOfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:35:38 -0400
Date: Tue, 12 Mar 2013 09:35:35 -0500
From: Nishanth Menon <nm@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        cpufreq <cpufreq@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: cpufreq-cpu0: support for clock which are
 not in DT yet.
Message-ID: <20130312143535.GA21599@kahuna>
References: <1363043130-30270-1-git-send-email-nm@ti.com>
 <1363043130-30270-2-git-send-email-nm@ti.com>
 <513EB704.8030907@ti.com>
 <513F3A88.5060903@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <513F3A88.5060903@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:24-20130312, Benoit Cousson wrote:
> Hi Guys,
> 
> On 03/12/2013 06:03 AM, Santosh Shilimkar wrote:
> > On Tuesday 12 March 2013 04:35 AM, Nishanth Menon wrote:
> >> On certain SoCs like variants of OMAP, the clock conversion to DT
> >> is not complete. In short, the ability to:
> >> cpus {
> >>     cpu@0 {
> >> 	clocks = <&cpuclk 0>;
> >>     };
> >>  };
> >> is not possible. However, the clock node is registered.
> >> Allow for clk names to be provided as string so as to be used when needed.
> >> Example (for OMAP3630):
> >> cpus {
> >>     cpu@0 {
> >> 	clock-name = "cpufreq_ck";
> >>     };
> >>  };
> >>
> >> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> >> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >> Cc: Shawn Guo <shawn.guo@linaro.org>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: cpufreq@vger.kernel.org
> >> Cc: linux-pm@vger.kernel.org
> >> Cc: linux-omap@vger.kernel.org
> >>
> >> Signed-off-by: Nishanth Menon <nm@ti.com>
> >> ---
> > Seems a reasonable to me.
> 
> No, it is not...
> 
> You cannot add a temp binding just because the OMAP support is not
> there, since the real binding already exist.
> 
> You need to register properly a clock provider to be able to reference
> it.
> If you do need a hacky temp code you could do it in OMAP code but not in
> the binding.

OK. My intent is to remove omap-cpufreq.c. So, I guess I could do
something like the following (not tested yet), but would that be the
right approach?

diff --git a/arch/arm/mach-omap2/cclock2420_data.c b/arch/arm/mach-omap2/cclock2420_data.c
index 0f0a97c..c3017deb 100644
--- a/arch/arm/mach-omap2/cclock2420_data.c
+++ b/arch/arm/mach-omap2/cclock2420_data.c
@@ -1885,7 +1885,7 @@ static struct omap_clk omap2420_clks[] = {
 	CLK(NULL,	"timer_32k_ck",	&func_32k_ck,	CK_242X),
 	CLK(NULL,	"timer_sys_ck",	&sys_ck,	CK_242X),
 	CLK(NULL,	"timer_ext_ck",	&alt_ck,	CK_242X),
-	CLK(NULL,	"cpufreq_ck",	&virt_prcm_set,	CK_242X),
+	CLK(NULL,	"cpufreq-cpu0.0",	&virt_prcm_set,	CK_242X),
 };
 
 
diff --git a/arch/arm/mach-omap2/cclock2430_data.c b/arch/arm/mach-omap2/cclock2430_data.c
index aed8f74..7000ca4 100644
--- a/arch/arm/mach-omap2/cclock2430_data.c
+++ b/arch/arm/mach-omap2/cclock2430_data.c
@@ -2001,7 +2001,7 @@ static struct omap_clk omap2430_clks[] = {
 	CLK(NULL,	"timer_32k_ck",  &func_32k_ck,   CK_243X),
 	CLK(NULL,	"timer_sys_ck",	&sys_ck,	CK_243X),
 	CLK(NULL,	"timer_ext_ck",	&alt_ck,	CK_243X),
-	CLK(NULL,	"cpufreq_ck",	&virt_prcm_set,	CK_243X),
+	CLK(NULL,	"cpufreq-cpu0.0",	&virt_prcm_set,	CK_243X),
 };
 
 static const char *enable_init_clks[] = {
diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 4579c3c..7a1dfde 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -3501,7 +3501,7 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"uart4_ick",	&uart4_ick_am35xx,	CK_AM35XX),
 	CLK(NULL,	"timer_32k_ck",	&omap_32k_fck,  CK_3XXX),
 	CLK(NULL,	"timer_sys_ck",	&sys_ck,	CK_3XXX),
-	CLK(NULL,	"cpufreq_ck",	&dpll1_ck,	CK_3XXX),
+	CLK(NULL,	"cpufreq-cpu0.0",	&dpll1_ck,	CK_3XXX),
 };
 
 static const char *enable_init_clks[] = {
diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index 3d58f33..5fad1da 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -1660,7 +1660,7 @@ static struct omap_clk omap44xx_clks[] = {
 	CLK("4013a000.timer",	"timer_sys_ck",	&syc_clk_div_ck,	CK_443X),
 	CLK("4013c000.timer",	"timer_sys_ck",	&syc_clk_div_ck,	CK_443X),
 	CLK("4013e000.timer",	"timer_sys_ck",	&syc_clk_div_ck,	CK_443X),
-	CLK(NULL,	"cpufreq_ck",	&dpll_mpu_ck,	CK_443X),
+	CLK(NULL,	"cpufreq-cpu0.0",	&dpll_mpu_ck,	CK_443X),
 };
 
 int __init omap4xxx_clk_init(void)
-- 
Regards,
Nishanth Menon
