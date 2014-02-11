Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaBKRok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:44:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33407 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaBKRoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:44:38 -0500
MIME-Version: 1.0
In-Reply-To: <52F9E8E6.1090006@keymile.com>
References: <7510122.cayuQ6qt8r@wuerfel> <CAGVrzcZ4TFd=9KP+aoG47QbmqDJ1i23WBcEWDbzNRUfGmPvZHQ@mail.gmail.com>
 <52F8FB03.6040606@keymile.com> <29007785.iYrLORbRAN@lenovo> <52F9E8E6.1090006@keymile.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 11 Feb 2014 09:43:57 -0800
Message-ID: <CAGVrzca7CV1SM0PfV2o=02Zd8z-65002kq6e-fhG6gWdkCadGA@mail.gmail.com>
Subject: Re: [PATCH V3] net/dt: Add support for overriding phy configuration
 from device tree
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerlando,

2014-02-11 1:09 GMT-08:00 Gerlando Falauto <gerlando.falauto@keymile.com>:
> Hi Florian,
>
> first of all, thank you for your answer.
>
>
> On 02/10/2014 06:09 PM, Florian Fainelli wrote:
>>
>> Hi Gerlando,
>>
>> Le lundi 10 février 2014, 17:14:59 Gerlando Falauto a écrit :
>>>
>>> Hi,
>>>
>>> I'm currently trying to fix an issue for which this patch provides a
>>> partial solution, so apologies in advance for jumping into the
>>> discussion for my own purposes...
>>>
>>> On 02/04/2014 09:39 PM, Florian Fainelli wrote:> 2014-01-17 Matthew
>>>
>>> Garrett <matthew.garrett@nebula.com>:
>>>   >> Some hardware may be broken in interesting and board-specific ways,
>>> such
>>>   >> that various bits of functionality don't work. This patch provides a
>>>   >> mechanism for overriding mii registers during init based on the
>>>
>>> contents of
>>>
>>>   >> the device tree data, allowing board-specific fixups without having
>>> to
>>>   >> pollute generic code.
>>>   >
>>>   > It would be good to explain exactly how your hardware is broken
>>>   > exactly. I really do not think that such a fine-grained setting where
>>>   > you could disable, e.g: 100BaseT_Full, but allow 100BaseT_Half to
>>>   > remain usable makes that much sense. In general, Gigabit might be
>>>   > badly broken, but 100 and 10Mbits/sec should work fine. How about the
>>>   > MASTER-SLAVE bit, is overriding it really required?
>>>   >
>>>   > Is not a PHY fixup registered for a specific OUI the solution you are
>>>   > looking for? I am also concerned that this creates PHY
>>> troubleshooting
>>>   > issues much harder to debug than before as we may have no idea about
>>>   > how much information has been put in Device Tree to override that.
>>>   >
>>>   > Finally, how about making this more general just like the BCM87xx PHY
>>>   > driver, which is supplied value/reg pairs directly? There are 16
>>>   > common MII registers, and 16 others for vendor specific registers,
>>>   > this is just covering for about 2% of the possible changes.
>>>
>>> Good point. That would easily help me with my current issue, which
>>> requires autoneg to be disabled to begin with (by clearing BMCR_ANENABLE
>>> from register 0).
>>
>>
>> Is there a point in time (e.g: after some specific initial configuration
>> has
>> been made) where BMCR_ANENABLE can be used?
>
>
> What do you mean? In my case, for some HW-related reason (due to the PHY
> counterpart I guess) autoneg needs to be disabled.
> This is currently done by the bootloader code (which clears the bit).
> What I'm looking for is some way for the kernel to either reinforce this
> setting, or just take that into account and skip autoneg.
> On top of that, there's a HW errata about that particular PHY, which
> requires certain operations to be performed on the PHY as a workaround *WHEN
> AUTONEG IS DISABLED*. That I'd implement on a PHY-specif driver.

Ok.

>
>
>>> This would not however fix it entirely (I tried a quick hardwired
>>> implementation), as the whole PHY machinery would not take that into
>>> account and would re-enable autoneg anyway.
>>> I also tried changing the patch so that phydev->support gets updated
>>
>>
>> There are multiple things that you could try doing here:
>>
>> - override the PHY state machine in your read_status callback to make sure
>> that you always set phydev->autoneg set to AUTONEG_ENABLE
>
>
> [you mean AUTONEG_DISABLE, right?]

Right, I fat fingered here.

> Uhm, but I don't want to implement a driver for that PHY that always
> disables autoneg. I only want to disable autoneg for that particular board.
> I figure I might register a fixup for that board, but that kindof makes
> everything more complicated and less clear. Plus, what should be the
> criterion to determine whether we're running on that particular hardware?

of_machine_is_compatible() plus reading the specific PHY OUI should
provide you with with an unique machine + PHY tuple. If your machine
name is too generic.

>
>
>> - clear the SUPPORTED_Autoneg bits from phydev->supported right after PHY
>> registration and before the call to phy_start()
>
>
> I actually tried clearing it by tweaking the patch on this thread, but the
> end result is that it does not produce any effect (see further comments
> below). Only thing that seems to play a role here is explictly setting
> phydev->autoneg = AUTONEG_DISABLE.
>
>
>> - set the PHY_HAS_MAGICANEG bit in your PHY driver flag
>
>
> Again, this seems to play no role whatsoever here:
>
>                         } else if (0 == phydev->link_timeout--) {
>                                 needs_aneg = 1;
>                                 /* If we have the magic_aneg bit,
>                                  * we try again */
>                                 if (phydev->drv->flags & PHY_HAS_MAGICANEG)
>                                         break;
>                         }
>                         break;
>                 case PHY_NOLINK:
>
> This code might have made sense when it was written in 2006 -- back then,
> the break statement was skipping some fallback code. But now it seems to do
> nothing.
>
>
>>
>>>
>>> (instead of phydev->advertising):
>>>   >> +               if (!of_property_read_u32(np, override->prop, &tmp))
>>> {
>>>   >> +                       if (tmp) {
>>>   >> +                               *val |= override->value;
>>>   >> +                               phydev->advertising |=
>>>
>>> override->supported;
>>>
>>>   >> +                       } else {
>>>   >> +                               phydev->advertising &=
>>>
>>> ~(override->supported);
>>>
>>>   >> +                       }
>>>   >> +
>>>   >> +                       *mask |= override->value;
>>>
>>> What I find weird is that the only way phydev->autoneg could ever be set
>>> to disabled is from here (phy.c):
>>>
>>> static void phy_sanitize_settings(struct phy_device *phydev)
>>> {
>>>         u32 features = phydev->supported;
>>>         int idx;
>>>
>>>         /* Sanitize settings based on PHY capabilities */
>>>         if ((features & SUPPORTED_Autoneg) == 0)
>>>                 phydev->autoneg = AUTONEG_DISABLE;
>>>
>>> which is in turn only called when phydev->autoneg is set to
>>> AUTONEG_DISABLE to begin with:
>>>
>>> int phy_start_aneg(struct phy_device *phydev)
>>> {
>>>         int err;
>>>
>>>         mutex_lock(&phydev->lock);
>>>
>>>         if (AUTONEG_DISABLE == phydev->autoneg)
>>>                 phy_sanitize_settings(phydev);
>>>
>>> So could someone please help me figure out what I'm missing here?
>>
>>
>> At first glance it looks like the PHY driver should be reading the phydev-
>>>
>>> autoneg value when the PHY driver config_aneg() callback is called to be
>>
>> allowed to set the forced speed and settings.
>>
>> The way phy_sanitize_settings() is coded does not make it return a mask of
>> features, but only the forced supported speed and duplex. Then when the
>> link
>> is forced but we are having some issues getting a link status, libphy
>> tries
>> lower speeds and this function is used again to provide the next
>> speed/duplex
>> pair to try.
>>
>
> What I was trying to say is that phy_sanitize_settings() is only called when
> phydev->autoneg == AUTONEG_DISABLE, and in turn it's the only generic
> function setting phydev->autoneg = AUTONEG_DISABLE.
> So perhaps the condition should read:
>
> -       if (AUTONEG_DISABLE == phydev->autoneg)
> +       if ((features & SUPPORTED_Autoneg) == 0)
>                 phy_sanitize_settings(phydev);
>
> Or else, some other parts of the generic code should take care of setting it
> to AUTONEG_DISABLE, depending on whether the feature is supported or not.
> What I found weird is explicitly setting a value (phydev->autoneg =
> AUTONEG_DISABLE), from a static function which is only called when that
> condition is already true.

I do not think that this change is correct either, let me cook a patch
for you to allow disabling autoneg from the start.

>
> BTW, I feel like disabling autoneg from the start has never been a use case
> before, am I right?

Not really no, and that is because most hardware does not need quirks
to work correctly.

>
> Thanks!
> Gerlando



-- 
Florian
