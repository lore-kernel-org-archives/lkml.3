Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3FDNtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:49:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:48112 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3FDNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:49:07 -0400
Message-ID: <51ADF04D.3040703@atmel.com>
Date: Tue, 4 Jun 2013 15:49:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com> <51A34BF9.5000905@atmel.com> <6343931.uK9ItNlUFg@wuerfel>
In-Reply-To: <6343931.uK9ItNlUFg@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/05/2013 14:42, Arnd Bergmann :
> On Monday 27 May 2013 14:05:13 Nicolas Ferre wrote:
>> On 27/05/2013 12:48, Alexandre Belloni :
>> A v3 is not needed simply for this. Thanks, anyway!
>>
>> One question though: why not just add
>>
>>           select PHYLIB
>>
>> In Kconfig entry:
>>
>>    config MACH_SAMA5_DT
>>
>> ?
>>
>> (note that I like to play with everybody's nerves ;-))
>
> That would make it impossible to build a sama5 kernel without networking
> support, which is probably not what you want.
>
> Jean-Christophe's suggestion to add the inline helper is best.

It seems that it has been clearly rejected by David. So the best 
solution remains to...

> Aside from
> that, please note that
>
>>> diff --git a/arch/arm/mach-at91/board-dt-sama5.c b/arch/arm/mach-at91/board-dt-sama5.c
>>> index 705305e..e9ce541 100644
>>> --- a/arch/arm/mach-at91/board-dt-sama5.c
>>> +++ b/arch/arm/mach-at91/board-dt-sama5.c
>>> @@ -47,22 +47,24 @@ static int ksz9021rn_phy_fixup(struct phy_device *phy)
>>>    #define GMII_ERCR	11
>>>    #define GMII_ERDWR	12
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
>>>    	return 0;
>>>    }
>
> This part of the patch is not actually needed if you
>
>>>    static void __init sama5_dt_device_init(void)
>>>    {
>>> -	if (of_machine_is_compatible("atmel,sama5d3xcm"))
>>> +	if (of_machine_is_compatible("atmel,sama5d3xcm") && IS_BUILTIN(CONFIG_PHYLIB))
>>>    		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
>>>    			ksz9021rn_phy_fixup);
>
> do this change, or the inline helper.

... simply use this "IS_BUILTIN(CONFIG_PHYLIB)" here -----^^^^^^^^^ (and 
not above as suggested by Arnd).

Jean-Christophe, Alexandre: do you agree with this conclusion?

I plan to stack this patch for next at91-fixes batch.

Bye,
-- 
Nicolas Ferre
