Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3E0L1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:27:03 -0400
Received: from 19.mo5.mail-out.ovh.net ([46.105.35.78]:49840 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755866Ab3E0L1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:27:01 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com>
Date: Mon, 27 May 2013 19:26:47 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E0B30581-DD0A-46C5-B541-08F389F17018@jcrosoft.com>
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
X-Mailer: Apple Mail (2.1503)
X-Ovh-Tracer-Id: 4827858802210286483
X-Ovh-Remote: 116.230.102.237 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedruddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedruddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 27, 2013, at 6:48 PM, Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

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

no for this change

add an inline version of phy_register_fixup_for_uid

this will do the same for every platform

> ---
> Changes in v3:
> 	added SoB
> 	added Acked-By
> 
> Changes in v2:
> 	use IS_BUILTIN
> 	use CONFIG_PHYLIB and not CONFIG_PHY
> 
> arch/arm/mach-at91/board-dt-sama5.c | 22 ++++++++++++----------
> 1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 705305e..e9ce541 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -47,22 +47,24 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
> #define GMII_ERCR	11
> #define GMII_ERDWR	12
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
> 	return 0;
> }
> 
> static void __init sama5_dt_device_init(void)
> {
> -	if (of_machine_is_compatible("atmel,sama5d3xcm"))
> +	if (of_machine_is_compatible("atmel,sama5d3xcm") && IS_BUILTIN(CONFIG_PHYLIB))
> 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> 			ksz9021rn_phy_fixup);
> 
> -- 
> 1.8.1.2
> 

