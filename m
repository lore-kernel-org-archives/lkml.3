Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3HZMBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:01:44 -0400
Received: from mo3.mail-out.ovh.net ([178.32.228.3]:43300 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3HZMBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:01:43 -0400
Message-ID: <521B43A1.7060406@overkiz.com>
Date: Mon, 26 Aug 2013 14:01:37 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] net/cadence/macb: fix kernel Oops if no PHY were discovered
 during probe
References: <1377372065-8938-1-git-send-email-b.brezillon@overkiz.com> <521B1B56.8060903@atmel.com>
In-Reply-To: <521B1B56.8060903@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4886968546829891635
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bo,

On 26/08/2013 11:09, Bo Shen wrote:
> Hi Boris,
>
> On 08/25/2013 03:21 AM, Boris BREZILLON wrote:
>> Test the presence of a PHY device before printing attached PHY
>> informations.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   drivers/net/ethernet/cadence/macb.c |    6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb.c 
>> b/drivers/net/ethernet/cadence/macb.c
>> index e866608..fd3b67f 100644
>> --- a/drivers/net/ethernet/cadence/macb.c
>> +++ b/drivers/net/ethernet/cadence/macb.c
>> @@ -1868,8 +1868,10 @@ static int __init macb_probe(struct 
>> platform_device *pdev)
>>               dev->irq, dev->dev_addr);
>>
>>       phydev = bp->phy_dev;
>> -    netdev_info(dev, "attached PHY driver [%s] (mii_bus:phy_addr=%s, 
>> irq=%d)\n",
>> -            phydev->drv->name, dev_name(&phydev->dev), phydev->irq);
>> +    if (phydev)
>> +        netdev_info(dev, "attached PHY driver [%s] 
>> (mii_bus:phy_addr=%s, irq=%d)\n",
>> +                phydev->drv->name, dev_name(&phydev->dev),
>> +                phydev->irq);
>
> Actually no need this check, if PHY is attached failed, the macb 
> driver probe will fail, then it won't show this message.

You're right (thanks for pointing this out).
Indeed this is a bug I introduced in this patch series ( 
https://lkml.org/lkml/2013/8/22/381).

In macb_mii_init function, the err field may be set to 0 (instead of the 
default -ENXIO value) if no PHY
is discovered.
As macb_mii_probe return code is not copied to err, this result in a 0 
return even if macb_mii_probe
failed.

Nicolas, forget about this patch, I'll fix this in the appropriate patch 
series (except if you plan to add
dynamic MAC/PHY association, and treat missing PHY during probe process 
as an acceptable result :-)).

Best Regards,

Boris BREZILLON

>
>>       return 0;
>>
>>
>
> Best Regards,
> Bo Shen

