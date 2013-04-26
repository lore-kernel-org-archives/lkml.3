Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3DZMlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:41:35 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49429 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3DZMlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:41:32 -0400
Date: Fri, 26 Apr 2013 13:41:28 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Pavel Machek <pavel@denx.de>
Cc: dinguyen@altera.com, wd@denx.de, jamie@jamieiles.com,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net, arnd@arndb.de,
        johnstul@us.ibm.com, tglx@linutronix.de,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: dw_apb_timer_of.c: remove parts that were picoxcell-specific
Message-ID: <20130426124128.GB6946@page>
References: <20130426121433.GA16249@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426121433.GA16249@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Fri, Apr 26, 2013 at 02:14:34PM +0200, Pavel Machek wrote:
> diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
> index 70b441a..22759f5 100644
> --- a/arch/arm/mach-picoxcell/common.c
> +++ b/arch/arm/mach-picoxcell/common.c
> @@ -84,11 +84,39 @@ static void picoxcell_wdt_restart(char mode, const char *cmd)
>  	}
>  }
>  
> +static const struct of_device_id picochip_rtc_ids[] __initconst = {
> +        { .compatible = "picochip,pc3x2-rtc" },
> +        { /* Sentinel */ },
> +};
> +
> +static void __iomem *sched_io_base;
> +
> +static u32 read_sched_clock(void)
> +{
> +        return __raw_readl(sched_io_base);
> +}
> +
> +static void __init timer_init(void)
> +{
> +	u32 rate;
> +
> +	dw_apb_timer_init(0);
> +
> +	sched_timer = of_find_matching_node(timer, osctimer_ids);
> +	if (!sched_timer)
> +		panic("No suitable timer for scheduler clock\n");
> +
> +	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
> +	of_node_put(sched_timer);

This doesn't work as osctimer_ids is private to the dw_apb_timer files 
as is timer_get_base_and_rate.  The other timer is unused in picoxcell 
though so dw_apb_timer_init(1), something like the patch below on top of 
yours.

Thanks,

Jamie


diff --git i/arch/arm/mach-picoxcell/common.c w/arch/arm/mach-picoxcell/common.c
index 1484841..a92d203 100644
--- i/arch/arm/mach-picoxcell/common.c
+++ w/arch/arm/mach-picoxcell/common.c
@@ -82,32 +82,9 @@ static void picoxcell_wdt_restart(char mode, const char *cmd)
 	}
 }
 
-static const struct of_device_id picochip_rtc_ids[] __initconst = {
-        { .compatible = "picochip,pc3x2-rtc" },
-        { /* Sentinel */ },
-};
-
-static void __iomem *sched_io_base;
-
-static u32 read_sched_clock(void)
-{
-        return __raw_readl(sched_io_base);
-}
-
 static void __init timer_init(void)
 {
-	u32 rate;
-
-	dw_apb_timer_init(0);
-
-	sched_timer = of_find_matching_node(timer, osctimer_ids);
-	if (!sched_timer)
-		panic("No suitable timer for scheduler clock\n");
-
-	timer_get_base_and_rate(sched_timer, &sched_io_base, &rate);
-	of_node_put(sched_timer);
-
-	setup_sched_clock(read_sched_clock, 32, rate);
+	dw_apb_timer_init(1);
 }
 
 DT_MACHINE_START(PICOXCELL, "Picochip picoXcell")
