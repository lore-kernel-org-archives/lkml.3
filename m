Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3E0M73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:59:29 -0400
Received: from 13.mo5.mail-out.ovh.net ([87.98.182.191]:48879 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932203Ab3E0M72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:59:28 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <51A356A2.4050502@free-electrons.com>
Date: Mon, 27 May 2013 20:59:14 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <8424D480-48DA-4094-AE68-6A6A66F8FE2B@jcrosoft.com>
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com> <E0B30581-DD0A-46C5-B541-08F389F17018@jcrosoft.com> <51A356A2.4050502@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
X-Mailer: Apple Mail (2.1503)
X-Ovh-Tracer-Id: 6389200498291354515
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


On May 27, 2013, at 8:50 PM, Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> On 27/05/2013 13:26, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On May 27, 2013, at 6:48 PM, Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
>> 
>>> Fixes:
>>> arch/arm/mach-at91/built-in.o: In function `ksz9021rn_phy_fixup':
>>> :(.text+0x1174): undefined reference to `mdiobus_write'
>>> :(.text+0x1188): undefined reference to `mdiobus_write'
>>> :(.text+0x119c): undefined reference to `mdiobus_write'
>>> :(.text+0x11b0): undefined reference to `mdiobus_write'
>>> arch/arm/mach-at91/built-in.o: In function `sama5_dt_device_init':
>>> :(.init.text+0x1e34): undefined reference to `phy_register_fixup_for_uid'
>>> 
>>> when CONFIG_PHYLIB is not selected.
>>> 
>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>> no for this change
>> 
>> add an inline version of phy_register_fixup_for_uid
>> 
>> this will do the same for every platform
> 
> I don't actually see the added value of doing that. Using IS_BUILTIN is
> readable and ensure that you will definitely be able to link. The
> functions will be optimized out and removed by gcc even when you have
> CONFIG_PHYLIB=m.

no will not as you do ifdef CONFIG_PHYLIB and if CONFIG_PHYLIB=m the macro is defended

we do this all the time in the kernel

I add the IS_BUILTIN & co to be used when a simple inline is not sufficient

Best Regards,
J/
> 
>>> ---
>>> Changes in v3:
>>> 	added SoB
>>> 	added Acked-By
>>> 
>>> Changes in v2:
>>> 	use IS_BUILTIN
>>> 	use CONFIG_PHYLIB and not CONFIG_PHY
>>> 
>>> arch/arm/mach-at91/board-dt-sama5.c | 22 ++++++++++++----------
>>> 1 file changed, 12 insertions(+), 10 deletions(-)
>>> 
>>> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
>>> index 705305e..e9ce541 100644
>>> --- a/arch/arm/mach-at91/board-dt-sama5.c
>>> +++ b/arch/arm/mach-at91/board-dt-sama5.c
>>> @@ -47,22 +47,24 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
>>> #define GMII_ERCR	11
>>> #define GMII_ERDWR	12
>>> 
>>> -	/* Set delay values */
>>> -	value = GMII_RCCPSR | 0x8000;
>>> -	phy_write(phy, GMII_ERCR, value);
>>> -	value = 0xF2F4;
>>> -	phy_write(phy, GMII_ERDWR, value);
>>> -	value = GMII_RRDPSR | 0x8000;
>>> -	phy_write(phy, GMII_ERCR, value);
>>> -	value = 0x2222;
>>> -	phy_write(phy, GMII_ERDWR, value);
>>> +	if (IS_BUILTIN(CONFIG_PHYLIB)) {
>>> +		/* Set delay values */
>>> +		value = GMII_RCCPSR | 0x8000;
>>> +		phy_write(phy, GMII_ERCR, value);
>>> +		value = 0xF2F4;
>>> +		phy_write(phy, GMII_ERDWR, value);
>>> +		value = GMII_RRDPSR | 0x8000;
>>> +		phy_write(phy, GMII_ERCR, value);
>>> +		value = 0x2222;
>>> +		phy_write(phy, GMII_ERDWR, value);
>>> +	}
>>> 
>>> 	return 0;
>>> }
>>> 
>>> static void __init sama5_dt_device_init(void)
>>> {
>>> -	if (of_machine_is_compatible("atmel,sama5d3xcm"))
>>> +	if (of_machine_is_compatible("atmel,sama5d3xcm") && IS_BUILTIN(CONFIG_PHYLIB))
>>> 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
>>> 			ksz9021rn_phy_fixup);
>>> 
>>> -- 
>>> 1.8.1.2
>>> 
> 
> 
> -- 
> Alexandre Belloni, Free Electrons
> Embedded Linux, Kernel and Android engineering
> http://free-electrons.com
> 

