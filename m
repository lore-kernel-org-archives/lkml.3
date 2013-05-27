Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3E0Mot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:44:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab3E0Mor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:44:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
Date: Mon, 27 May 2013 14:42:12 +0200
Message-ID: <6343931.uK9ItNlUFg@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-21-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <51A34BF9.5000905@atmel.com>
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com> <51A34BF9.5000905@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kfkp8aGCLpUYG6ZV6oWUm52FlUbSqe6TEqnWAlJHfTT
 e6BImG7OdYlbBs5UKOIhWNTCxX3QCUIK9ipsCIo/SmaJQUHtvk
 4Zw+uo7yakRd5KX1GJotnO0wjr+UVEimEiTxNEglNhua0F1sFc
 V5TXaTYoPWCqbynakTY4YDYyy+a8PHJcXK+pOExw38nU0/2NqP
 27GVfos6F8FRnaA50Z/vBhUtuSER0cCvnr9q4/DAMmkFnb9i/9
 hzkLQ0L+qEFVurtDPjzecqsXgYOZ4M6Uoj4sVfYyRjaNx94Zvs
 a5R0Vd9bSXCjSEz4N8jI8bg/PxH9jui0loqMj6XsppJ+HxOHly
 2Dsc2u1ISqzvnSKk1zuQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 May 2013 14:05:13 Nicolas Ferre wrote:
> On 27/05/2013 12:48, Alexandre Belloni :
> A v3 is not needed simply for this. Thanks, anyway!
> 
> One question though: why not just add
> 
>          select PHYLIB
> 
> In Kconfig entry:
> 
>   config MACH_SAMA5_DT
> 
> ?
> 
> (note that I like to play with everybody's nerves ;-))

That would make it impossible to build a sama5 kernel without networking
support, which is probably not what you want.

Jean-Christophe's suggestion to add the inline helper is best. Aside from
that, please note that

> > diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
> > index 705305e..e9ce541 100644
> > --- a/arch/arm/mach-at91/board-dt-sama5.c
> > +++ b/arch/arm/mach-at91/board-dt-sama5.c
> > @@ -47,22 +47,24 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
> >   #define GMII_ERCR	11
> >   #define GMII_ERDWR	12
> >
> > -	/* Set delay values */
> > -	value = GMII_RCCPSR | 0x8000;
> > -	phy_write(phy, GMII_ERCR, value);
> > -	value = 0xF2F4;
> > -	phy_write(phy, GMII_ERDWR, value);
> > -	value = GMII_RRDPSR | 0x8000;
> > -	phy_write(phy, GMII_ERCR, value);
> > -	value = 0x2222;
> > -	phy_write(phy, GMII_ERDWR, value);
> > +	if (IS_BUILTIN(CONFIG_PHYLIB)) {
> > +		/* Set delay values */
> > +		value = GMII_RCCPSR | 0x8000;
> > +		phy_write(phy, GMII_ERCR, value);
> > +		value = 0xF2F4;
> > +		phy_write(phy, GMII_ERDWR, value);
> > +		value = GMII_RRDPSR | 0x8000;
> > +		phy_write(phy, GMII_ERCR, value);
> > +		value = 0x2222;
> > +		phy_write(phy, GMII_ERDWR, value);
> > +	}
> >
> >   	return 0;
> >   }

This part of the patch is not actually needed if you

> >   static void __init sama5_dt_device_init(void)
> >   {
> > -	if (of_machine_is_compatible("atmel,sama5d3xcm"))
> > +	if (of_machine_is_compatible("atmel,sama5d3xcm") && IS_BUILTIN(CONFIG_PHYLIB))
> >   		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> >   			ksz9021rn_phy_fixup);

do this change, or the inline helper.

	Arnd
