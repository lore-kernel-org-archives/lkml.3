Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3KTVFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:05:14 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45709 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3KTVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:05:12 -0500
Message-ID: <528D2403.5040204@gmail.com>
Date: Wed, 20 Nov 2013 22:05:07 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
To: Florian Fainelli <f.fainelli@gmail.com>
CC: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC v1 4/7] net: phy: suspend unused PHYs on mdio_bus
 in late_initcall
References: <1384978913-8052-1-git-send-email-sebastian.hesselbarth@gmail.com> <1384978913-8052-5-git-send-email-sebastian.hesselbarth@gmail.com> <CAGVrzcYBexBWrh2Nz8tu0KRLQ4YPjtJux9N-TC07-Hxf3On1FQ@mail.gmail.com>
In-Reply-To: <CAGVrzcYBexBWrh2Nz8tu0KRLQ4YPjtJux9N-TC07-Hxf3On1FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 09:58 PM, Florian Fainelli wrote:
> 2013/11/20 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>:
>> Since phy_attach ensures PHYs are resumed, we can now suspend all
>> PHYs that have no attached netdev after initcalls.
>
> I do like the idea, but I think you might want to make sure that the
> MDIO bus suspend policy was set to "auto" (which is the default afair)
> not to expose unexpected behavior.

Ok, TBH I haven't looked through all of phy internals. If we are fine
with the overall approach, I could use some guidance in the individual
patches and policies.

>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>   drivers/net/phy/mdio_bus.c |   27 +++++++++++++++++++++++++++
>>   1 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
>> index 5617876..10eba58 100644
>> --- a/drivers/net/phy/mdio_bus.c
>> +++ b/drivers/net/phy/mdio_bus.c
>> @@ -320,6 +320,33 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
>>                  (phydev->phy_id & phydrv->phy_id_mask));
>>   }
>>
>> +static int mdio_bus_suspend_unused(struct device *busdev, void *data)
>> +{
>> +       struct mii_bus *bus = to_mii_bus(busdev);
>> +       struct phy_device *phydev;
>> +       struct phy_driver *phydrv;
>> +       int i;
>> +
>> +       for (i = 0; i < PHY_MAX_ADDR; i++) {
>> +               if (!bus->phy_map[i])
>> +                       continue;
>> +
>> +               phydev = to_phy_device(&bus->phy_map[i]->dev);
>> +               phydrv = to_phy_driver(phydev->dev.driver);
>> +               if (!phydev->attached_dev && phydrv && phydrv->suspend)
>> +                       phy_suspend(phydev);
>> +       }
>> +
>> +       return 0;
>
> You might want to reuse mdio_bus_phy_may_suspend() here to have a
> central place checking for phydev->attached_dev and phydrv->suspend
> just in case we need to add more callbacks in the future or implicit
> PHY state machine hooks. That might also take care of my concern
> expressed above.

Unfortunately, mdio_bus_phy_may_suspend() doesn't help here. It will
correctly tell that unconnected PHYs may_suspend but also that PHYs
connected to PM aware drivers may_suspend.

I tried it and it will also suspend the PHY taken by mv643xx_eth.

But actually, as phy_suspend/resume check for phydrv->suspend
themselves, we can just call it on !phydev->attached_dev and remove
the additional checks.

>> +}
>> +
>> +static int mdio_bus_class_suspend_unused(void)
>> +{
>> +       return class_for_each_device(&mdio_bus_class, NULL, NULL,
>> +                                    mdio_bus_suspend_unused);
>> +}
>> +late_initcall_sync(mdio_bus_class_suspend_unused);
>> +
>>   #ifdef CONFIG_PM
>>
>>   static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
>> --
>> 1.7.2.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
>

