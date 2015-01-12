Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbbALOw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:52:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:20998 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbbALOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:52:28 -0500
Message-ID: <54B3DFAA.9020804@atmel.com>
Date: Mon, 12 Jan 2015 15:52:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: board-dt-sama5: add phy_fixup to override
 NAND_Tree which improperly strapp-in during the reset period.
References: <1418283069-5648-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1418283069-5648-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/12/2014 08:31, Wenyou Yang a écrit :
> Appearance: On some SAMA5D4EK boards, after power up, the Eth1 doesn't work.
> 
> Reason: The PIOE2 pin is connected to the NAND_Tree# of KSZ8081,
> But it outputs LOW during the reset period, which cause the NAND_Tree# enabled.
> 
> Add phy_fixup() to disable NAND_Tree by overriding the Operation
> Mode Strap Override register(i.e. Register 16h) to clear the NAND_Tree bit.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Stacked on top of at91-3.19-fixes.

Bye,


> ---
>  arch/arm/mach-at91/board-dt-sama5.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 8fb9ef5..97f7367 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -17,6 +17,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/phy.h>
>  #include <linux/clk-provider.h>
> +#include <linux/phy.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
> @@ -26,8 +27,25 @@
>  
>  #include "generic.h"
>  
> +static int ksz8081_phy_fixup(struct phy_device *phy)
> +{
> +	int value;
> +
> +	value = phy_read(phy, 0x16);
> +	value &= ~0x20;
> +	phy_write(phy, 0x16, value);
> +
> +	return 0;
> +}
> +
>  static void __init sama5_dt_device_init(void)
>  {
> +	if (of_machine_is_compatible("atmel,sama5d4ek") &&
> +	   IS_ENABLED(CONFIG_PHYLIB)) {
> +		phy_register_fixup_for_id("fc028000.etherne:00",
> +						ksz8081_phy_fixup);
> +	}
> +
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
>  }
>  
> 


-- 
Nicolas Ferre
