Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaI2LwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:52:17 -0400
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:21604
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751913AbaI2LwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:52:15 -0400
Date: Mon, 29 Sep 2014 19:51:41 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <festevam@gmail.com>, <jingchang.lu@freescale.com>,
        <bpringlemeir@nbsps.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] ARM: vf610: Add ARM Global Timer clocksource
 option
Message-ID: <20140929115122.GA14087@tiger>
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
 <1411575610-20895-4-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1411575610-20895-4-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [221.225.208.47]
X-ClientProxiedBy: SINPR01CA010.apcprd01.prod.exchangelabs.com (10.242.48.20)
 To BY2PR03MB345.namprd03.prod.outlook.com (10.141.139.11)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB345;
X-Forefront-PRVS: 034902F5BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(51704005)(189002)(120916001)(4396001)(42186005)(47776003)(83072002)(92566001)(92726001)(83322001)(19580395003)(99396003)(110136001)(85852003)(87976001)(85306004)(19580405001)(83506001)(107046002)(64706001)(20776003)(23726002)(33656002)(86362001)(575784001)(90102001)(101416001)(66066001)(21056001)(33716001)(97736003)(95666004)(76482002)(46406003)(97756001)(106356001)(77096002)(10300001)(50986999)(54356999)(76176999)(50466002)(80022003)(74662003)(79102003)(105586002)(74502003)(77982003)(46102003)(31966008)(81542003)(81342003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB345;H:tiger;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 06:20:10PM +0200, Stefan Agner wrote:
> Add the ARM Global Timer as clocksource/scheduler clock option and
> use it as default scheduler clock. This leaves the PIT timer for
> other users e.g. the secondary Cortex-M4 core. Also, the Global Timer
> has double the precission (running at pheripheral clock compared to
> IPG clock) and a 64-bit incrementing counter register. We still keep
> the PIT timer as an secondary option in case the ARM Global Timer is
> not available.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/mach-imx/Kconfig | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index 11b2957..9482f58 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -633,12 +633,29 @@ config SOC_VF610
>  	bool "Vybrid Family VF610 support"
>  	select ARM_GIC
>  	select PINCTRL_VF610
> -	select VF_PIT_TIMER
>  	select PL310_ERRATA_769419 if CACHE_L2X0
>  
>  	help
>  	  This enable support for Freescale Vybrid VF610 processor.
>  
> +choice
> +	prompt "Clocksource for scheduler clock"
> +	depends on SOC_VF610
> +	default ARM_GLOBAL_TIMER
> +
> +	config ARM_GLOBAL_TIMER
> +		bool "Use ARM Global Timer"
> +		select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
> +		help
> +		  Use the ARM Global Timer as clocksource
> +
> +	config VF_PIT_TIMER
> +		bool "Use PIT timer"
> +		help
> +		  Use SoC Periodic Interrupt Timer (PIT) as clocksource
> +
> +endchoice
> +

As per the report from 0-DAY kernel build test (thanks), the change
causes the following warning on a particular config.

warning: (ARCH_ROCKCHIP && ARCH_BCM_5301X) selects CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK which has unmet direct dependencies (ARM_GLOBAL_TIMER)

It looks the redefinition of ARM_GLOBAL_TIMER is the cause for that
warning.  I think it's more safer to use new config symbols for choosing
the clocksource device for VF610.  I propose the following change to fix
the warning.  If there is no objection, I will squash it into the
original commit soon.

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 9482f5837b7e..e26b0fdd72db 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -641,16 +641,18 @@ config SOC_VF610
 choice
        prompt "Clocksource for scheduler clock"
        depends on SOC_VF610
-       default ARM_GLOBAL_TIMER
+       default VF_USE_ARM_GLOBAL_TIMER
 
-       config ARM_GLOBAL_TIMER
+       config VF_USE_ARM_GLOBAL_TIMER
                bool "Use ARM Global Timer"
+               select ARM_GLOBAL_TIMER
                select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
                help
                  Use the ARM Global Timer as clocksource
 
-       config VF_PIT_TIMER
+       config VF_USE_PIT_TIMER
                bool "Use PIT timer"
+               select VF_PIT_TIMER
                help
                  Use SoC Periodic Interrupt Timer (PIT) as clocksource
 

