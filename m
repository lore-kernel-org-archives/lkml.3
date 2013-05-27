Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3E0MFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:05:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:50310 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3E0MFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:05:14 -0400
Message-ID: <51A34BF9.5000905@atmel.com>
Date: Mon, 27 May 2013 14:05:13 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/2013 12:48, Alexandre Belloni :
> Fixes:
> arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
> :(.text+0x1174): undefined reference to `mdiobus_write'
> :(.text+0x1188): undefined reference to `mdiobus_write'
> :(.text+0x119c): undefined reference to `mdiobus_write'
> :(.text+0x11b0): undefined reference to `mdiobus_write'
> arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
> :(.init.text+0x1e34): undefined reference to `phy_register_fixup_for_uid'
>
> when CONFIG_PHYLIB is not selected.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> ---
> Changes in v3:
> 	added SoB
> 	added Acked-By

A v3 is not needed simply for this. Thanks, anyway!

One question though: why not just add

         select PHYLIB

In Kconfig entry:

  config MACH_SAMA5_DT

?

(note that I like to play with everybody's nerves ;-))

Bye,

> Changes in v2:
> 	use IS_BUILTIN
> 	use CONFIG_PHYLIB and not CONFIG_PHY
>
>   arch/arm/mach-at91/board-dt-sama5.c | 22 ++++++++++++----------
>   1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 705305e..e9ce541 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -47,22 +47,24 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
>   #define GMII_ERCR	11
>   #define GMII_ERDWR	12
>
> -	/* Set delay values */
> -	value = GMII_RCCPSR | 0x8000;
> -	phy_write(phy, GMII_ERCR, value);
> -	value = 0xF2F4;
> -	phy_write(phy, GMII_ERDWR, value);
> -	value = GMII_RRDPSR | 0x8000;
> -	phy_write(phy, GMII_ERCR, value);
> -	value = 0x2222;
> -	phy_write(phy, GMII_ERDWR, value);
> +	if (IS_BUILTIN(CONFIG_PHYLIB)) {
> +		/* Set delay values */
> +		value = GMII_RCCPSR | 0x8000;
> +		phy_write(phy, GMII_ERCR, value);
> +		value = 0xF2F4;
> +		phy_write(phy, GMII_ERDWR, value);
> +		value = GMII_RRDPSR | 0x8000;
> +		phy_write(phy, GMII_ERCR, value);
> +		value = 0x2222;
> +		phy_write(phy, GMII_ERDWR, value);
> +	}
>
>   	return 0;
>   }
>
>   static void __init sama5_dt_device_init(void)
>   {
> -	if (of_machine_is_compatible("atmel,sama5d3xcm"))
> +	if (of_machine_is_compatible("atmel,sama5d3xcm") && IS_BUILTIN(CONFIG_PHYLIB))
>   		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
>   			ksz9021rn_phy_fixup);
>
>


-- 
Nicolas Ferre
