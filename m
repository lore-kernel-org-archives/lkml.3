Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3EYUKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 16:10:16 -0400
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:60151 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757904Ab3EYUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 16:10:11 -0400
Date: Sat, 25 May 2013 22:05:57 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v2] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
Message-ID: <20130525200557.GO24476@game.jcrosoft.org>
References: <1369467542-25519-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369467542-25519-1-git-send-email-alexandre.belloni@free-electrons.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1947525364200680339
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:39 Sat 25 May     , Alexandre Belloni wrote:
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
> ---
> Changes in v2:
> 	use IS_BUILTIN
> 	use CONFIG_PHYLIB and not CONFIG_PHY
> 

I do not like this, I prefer we just drop the fixup by adding the dt support
to the micrel phy as done for broadcom

if !PHYLIB just add an inline declaration of 
phy_register_fixup_for_uid

so gcc will drop ksz9021rn_phy_fixup automatically

Best Regards,
J.
> 
>  arch/arm/mach-at91/board-dt-sama5.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> index 705305e..e9ce541 100644
> --- a/arch/arm/mach-at91/board-dt-sama5.c
> +++ b/arch/arm/mach-at91/board-dt-sama5.c
> @@ -47,22 +47,24 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
>  #define GMII_ERCR	11
>  #define GMII_ERDWR	12
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
>  	return 0;
>  }
>  
>  static void __init sama5_dt_device_init(void)
>  {
> -	if (of_machine_is_compatible("atmel,sama5d3xcm"))
> +	if (of_machine_is_compatible("atmel,sama5d3xcm") && IS_BUILTIN(CONFIG_PHYLIB))
>  		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
>  			ksz9021rn_phy_fixup);
>  
> -- 
> 1.8.1.2
> 
