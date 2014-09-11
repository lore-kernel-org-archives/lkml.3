Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaIKI3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:29:34 -0400
Received: from [207.46.100.136] ([207.46.100.136]:13136 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752960AbaIKI3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:29:32 -0400
Date: Thu, 11 Sep 2014 16:29:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Robin Gong <b38343@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] ARM: imx6: add pm_power_off support for i.mx6 chips
Message-ID: <20140911082905.GI18566@dragon>
References: <1410417667-6436-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410417667-6436-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(51704005)(26826002)(81342001)(21056001)(102836001)(33656002)(81542001)(4396001)(83072002)(85852003)(80022001)(92566001)(92726001)(47776003)(87936001)(20776003)(64706001)(86362001)(23726002)(31966008)(74662001)(57986006)(90102001)(74502001)(6806004)(85306004)(19580395003)(83322001)(19580405001)(50466002)(44976005)(84676001)(83506001)(95666004)(68736004)(46406003)(33716001)(77982001)(97756001)(110136001)(54356999)(76176999)(50986999)(106466001)(76482001)(104016003)(46102001)(105606002)(107046002)(99396002)(97736003)(79102001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB038;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 02:41:07PM +0800, Robin Gong wrote:
> All chips of i.mx6 can be powered off by programming SNVS.
> For example :
> On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> pmic ON/OFF pin, that will cause the whole PMIC powered off
> except VSNVS. And system can restart once PMIC_ON_REQ goes
> high by push POWRER key.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  arch/arm/mach-imx/common.h      |  1 +
>  arch/arm/mach-imx/mach-imx6q.c  |  2 ++
>  arch/arm/mach-imx/mach-imx6sl.c |  2 ++
>  arch/arm/mach-imx/mach-imx6sx.c |  2 ++
>  arch/arm/mach-imx/system.c      | 22 +++++++++++++++++++++-
>  5 files changed, 28 insertions(+), 1 deletion(-)

I think we'd better add a little poweroff driver under
drivers/power/reset/ rather than having it in platform code.

Shawn

> 
> diff --git a/arch/arm/mach-imx/common.h b/arch/arm/mach-imx/common.h
> index 1dabf43..baca11a 100644
> --- a/arch/arm/mach-imx/common.h
> +++ b/arch/arm/mach-imx/common.h
> @@ -62,6 +62,7 @@ void mxc_set_cpu_type(unsigned int type);
>  void mxc_restart(enum reboot_mode, const char *);
>  void mxc_arch_reset_init(void __iomem *);
>  void mxc_arch_reset_init_dt(void);
> +void mxc_power_off_init(void);
>  int mx51_revision(void);
>  int mx53_revision(void);
>  void imx_set_aips(void __iomem *);
> diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
> index d51c6e9..3d6610d 100644
> --- a/arch/arm/mach-imx/mach-imx6q.c
> +++ b/arch/arm/mach-imx/mach-imx6q.c
> @@ -270,6 +270,8 @@ static void __init imx6q_init_machine(void)
>  
>  	mxc_arch_reset_init_dt();
>  
> +	mxc_power_off_init();
> +
>  	parent = imx_soc_device_init();
>  	if (parent == NULL)
>  		pr_warn("failed to initialize soc device\n");
> diff --git a/arch/arm/mach-imx/mach-imx6sl.c b/arch/arm/mach-imx/mach-imx6sl.c
> index ed263a2..c07e6e8 100644
> --- a/arch/arm/mach-imx/mach-imx6sl.c
> +++ b/arch/arm/mach-imx/mach-imx6sl.c
> @@ -50,6 +50,8 @@ static void __init imx6sl_init_machine(void)
>  
>  	mxc_arch_reset_init_dt();
>  
> +	mxc_power_off_init();
> +
>  	parent = imx_soc_device_init();
>  	if (parent == NULL)
>  		pr_warn("failed to initialize soc device\n");
> diff --git a/arch/arm/mach-imx/mach-imx6sx.c b/arch/arm/mach-imx/mach-imx6sx.c
> index 3de3b73..68ea070 100644
> --- a/arch/arm/mach-imx/mach-imx6sx.c
> +++ b/arch/arm/mach-imx/mach-imx6sx.c
> @@ -20,6 +20,8 @@ static void __init imx6sx_init_machine(void)
>  
>  	mxc_arch_reset_init_dt();
>  
> +	mxc_power_off_init();
> +
>  	parent = imx_soc_device_init();
>  	if (parent == NULL)
>  		pr_warn("failed to initialize soc device\n");
> diff --git a/arch/arm/mach-imx/system.c b/arch/arm/mach-imx/system.c
> index d14c33f..925fb29 100644
> --- a/arch/arm/mach-imx/system.c
> +++ b/arch/arm/mach-imx/system.c
> @@ -23,6 +23,7 @@
>  #include <linux/delay.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/pm.h>
>  
>  #include <asm/system_misc.h>
>  #include <asm/proc-fns.h>
> @@ -32,7 +33,9 @@
>  #include "common.h"
>  #include "hardware.h"
>  
> -static void __iomem *wdog_base;
> +#define SNVS_LPCR               0x04
> +
> +static void __iomem *wdog_base, *snvs_base;
>  static struct clk *wdog_clk;
>  
>  /*
> @@ -104,6 +107,23 @@ void __init mxc_arch_reset_init_dt(void)
>  		clk_prepare(wdog_clk);
>  }
>  
> +static void power_off_snvs(void)
> +{
> +	 u32 value = readl(snvs_base + SNVS_LPCR);
> +	/* set TOP and DP_EN bit */
> +	writel(value | 0x60, snvs_base + SNVS_LPCR);
> +}
> +
> +void __init mxc_power_off_init(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0-mon-rtc-lp");
> +	snvs_base = of_iomap(np, 0);
> +	WARN_ON(!snvs_base);
> +	pm_power_off = power_off_snvs;
> +}
> +
>  #ifdef CONFIG_CACHE_L2X0
>  void __init imx_init_l2cache(void)
>  {
> -- 
> 1.9.1
> 
