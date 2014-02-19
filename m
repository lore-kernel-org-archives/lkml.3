Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaBSTSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:18:52 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:39223 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbaBSTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:18:49 -0500
Message-ID: <530511AC.7030907@cogentembedded.com>
Date: Wed, 19 Feb 2014 23:18:52 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
CC: Grant Likely <grant.likely@linaro.org>,
        linux-kernel <linux-kernel@lists.codethink.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] of_mdio: fix phy interrupt passing
References: <1392654580-3706-1-git-send-email-ben.dooks@codethink.co.uk> <CAGVrzcYeuTA0Yd5YyOTuWQfnwLw9zP87MaYJOLwprZRCtvuaXw@mail.gmail.com> <530249EF.4060803@codethink.co.uk> <CAGVrzcZGW05uNj75VG7w4iSGre4OzEMhHedQfaynekrbhP4NLQ@mail.gmail.com>
In-Reply-To: <CAGVrzcZGW05uNj75VG7w4iSGre4OzEMhHedQfaynekrbhP4NLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/17/2014 08:48 PM, Florian Fainelli wrote:

>>>> The of_mdiobus_register_phy() is not setting phy->irq this causing
>>>> some drivers to incorrectly assume that the PHY does not have an
>>>> IRQ associated with it or install an interrupt handler for the
>>>> PHY.

>>>> Simplify the code setting irq and set the phy->irq at the same
>>>> time so that the case if mdio->irq is not NULL is easier to read.

>>> The real bug fix, which is not properly explained here, is that
>>> irq_of_parse_and_map() should return values > 0 when the interrupt is
>>> valid, so this makes me wonder why we are not propagating the return
>>> value from irq_of_parse_and_map() in case the call to
>>> of_irq_parse_one() does return something non-zero?

>> No, the first issue is phy->dev never gets set, which causes the
>> issue. The cleanup was added as it seemed easier to put it in with
>> this.

> Ok, that really needs to be mentioned in the commit message, even
> being quite familiar (and possibly dumb too) with the code, I could
> not figure this out by reading your patch.

    Yes, the main issue was that phy->irq wasn't overridden from the value set 
by phy_device_create().

>> I think phy->irq is already initialised to PHY_POLL and thus there
>> is no need to set phy->irq if the irq_of_parse_and_map() fails.

> That is correct, the reason why I introduced 7d97637 ("net: of_mdio:
> do not overwrite PHY interrupt configuration") was that you are also
> allowed to change the irq type before calling into
> of_mdiobus_register(),

    Not really: of_mdiobus_register() init's all of mdio->irq[] with IRQ_POLL, 
thus wiping out all of the previous initialization, so I don't know what you 
did achieve with the aforementioned commit.

> so we want to preserve other irq values being
> set here, such as PHY_IGNORE_INTERRUPT. Your patch does take care of
> that since it only overrides the irq in case we could parse it.

    And it should have stayed that way. The latter change was unnecessary.

WBR, Sergei

