Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaBRRGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:06:08 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:52316 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaBRRGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:06:04 -0500
Message-ID: <5303A10A.3060106@cogentembedded.com>
Date: Tue, 18 Feb 2014 21:06:02 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
CC: linux-kernel@lists.codethink.co.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] of_mdio: fix phy interrupt passing
References: <1392654580-3706-1-git-send-email-ben.dooks@codethink.co.uk> < 20140218093024.D0E94C403C8@trevor.secretlab.ca> <53032A97.8050201@codethink .co.uk> <20140218170202.424D7C40517@trevor.secretlab.ca>
In-Reply-To: <20140218170202.424D7C40517@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/18/2014 08:02 PM, Grant Likely wrote:

>>> On Mon, 17 Feb 2014 16:29:40 +0000, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>>>> The of_mdiobus_register_phy() is not setting phy->irq this causing
>>>> some drivers to incorrectly assume that the PHY does not have an
>>>> IRQ associated with it or install an interrupt handler for the
>>>> PHY.

>>>> Simplify the code setting irq and set the phy->irq at the same
>>>> time so that the case if mdio->irq is not NULL is easier to read.

>>>> This fixes the issue:
>>>>    net eth0: attached PHY 1 (IRQ -1) to driver Micrel KSZ8041RNLI

>>>> to the correct:
>>>>    net eth0: attached PHY 1 (IRQ 416) to driver Micrel KSZ8041RNLI

>>>> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
>>>> ---
>>>>    drivers/of/of_mdio.c | 12 ++++++------
>>>>    1 file changed, 6 insertions(+), 6 deletions(-)

>>>> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
>>>> index 875b7b6..7b3e7b0 100644
>>>> --- a/drivers/of/of_mdio.c
>>>> +++ b/drivers/of/of_mdio.c
>>>> @@ -44,7 +44,7 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
>>>>    {
>>>>    	struct phy_device *phy;
>>>>    	bool is_c45;
>>>> -	int rc, prev_irq;
>>>> +	int rc;
>>>>    	u32 max_speed = 0;
>>>>
>>>>    	is_c45 = of_device_is_compatible(child,
>>>> @@ -55,11 +55,11 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
>>>>    		return 1;
>>>>
>>>>    	if (mdio->irq) {
>>>> -		prev_irq = mdio->irq[addr];
>>>> -		mdio->irq[addr] =
>>>> -			irq_of_parse_and_map(child, 0);
>>>> -		if (!mdio->irq[addr])
>>>> -			mdio->irq[addr] = prev_irq;

>>> I cannot for the life for me remeber why the code was structured that
>>> way. Your change is better.

>>>> +		rc = irq_of_parse_and_map(child, 0);
>>>> +		if (rc > 0) {
>>>> +			mdio->irq[addr] = rc;
>>>> +			phy->irq = rc;
>>>> +		}
>>>>    	}

>>> The outer if is merely protecting against no irq array being allocated
>>> for the bus. Would not the following be better:

>>> 	rc = irq_of_parse_and_map(child, 0);
>>> 	if (rc > 0) {
>>> 		phy->irq = rc;
>>> 		if (mdio->irq)
>>> 			mdio->irq[addr] = rc;
>>> 	}

>> Thanks, that makes sense, although we've both failed to work
>> out if mdio->irq is set, and rc <= 0 case, so:

>>    	rc = irq_of_parse_and_map(child, 0);
>>    	if (rc > 0) {
>>    		phy->irq = rc;
>>    		if (mdio->irq)
>>    			mdio->irq[addr] = rc;
>>    	} else {
>> 		if (mdio->irq)
>> 			phy->irq = mdio->irq[addr];
>> 	}

> Is this actually a valid thing to do? I think the only time mdio->irq[]
> is non-zero is when it is set to PHY_POLL. Is it valid to set phy->irq
> to PHY_POLL? I didn't think it was.

    It is valid, AFAIK.

> g.

>> --
>> Ben Dooks				http://www.codethink.co.uk/
>> Senior Engineer				Codethink - Providing Genius

WBR, Sergei

