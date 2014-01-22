Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaAVILo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:11:44 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59974 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaAVILl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:11:41 -0500
Message-ID: <52DF7D2C.1080802@ti.com>
Date: Wed, 22 Jan 2014 10:11:24 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, <tj@kernel.org>, <kishon@ti.com>
CC: <sergei.shtylyov@cogentembedded.com>, <b.zolnierkie@samsung.com>,
        <arnd@arndb.de>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 0/4] ata: ahci_platform: Add PHY support and OMAP support
References: <1390228888-5537-1-git-send-email-rogerq@ti.com> <52DD5368.5020301@redhat.com> <52DE3132.3000007@ti.com> <52DE6114.20601@ti.com> <52DE7D5D.8070307@redhat.com>
In-Reply-To: <52DE7D5D.8070307@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/21/2014 03:59 PM, Hans de Goede wrote:
> Hi,
> 
> On 01/21/2014 12:59 PM, Roger Quadros wrote:
>> On 01/21/2014 10:34 AM, Roger Quadros wrote:
>>> On 01/20/2014 06:48 PM, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 01/20/2014 03:41 PM, Roger Quadros wrote:
>>>>> Hi,
>>>>>
>>>>> Some platforms have a PHY hooked up to the SATA controller.
>>>>> The PHY needs to be initialized and powered up for SATA to work.
>>>>> We do that using the Generic PHY framework in PATCH 3.
>>>>>
>>>>> In order to support SATA on the OMAP platforms we need to runtime
>>>>> resume the device before use. PATCH 4 takes care of that.
>>>>
>>>> Thanks for keeping me in the loop on this. I'm afraid this conflicts
>>>> quite a bit with my recent ahci_platform.c work, not a big problem
>>>> really, the series can go in either way.
>>>>
>>>> Your phy support will slot nicely into the new ahci_platform_get_resources
>>>> and ahci_platform_enable_resources functions my refactoring introduces,
>>>> looking at it from this pov it might be better / easier to rebase your series
>>>> on top of the v4 of my series I've just send.
>>>>
>>>> Which brings me to one comment about your series why are you not doing phy_exit
>>>> and phy_init on suspend resp. resume ? The phy can use quite a bit of power,
>>>> if the phy init / exit end up in ahci_platform_enable_resources /
>>>> ahci_platform_disable_resources, this will happen automatically for better or
>>>> worse. So it would be good to test if this would work or not ...
>>>
>>> Right. Bartlomiej had pointed this out earlier, but I just wasn't very sure about it.
>>>
>>> Is it sufficient to just call phy_power_off() in suspend and phy_power_on() in resume?
>>> Or do we call phy_exit() and phy_init() respectively as well.
>>>
>>> Kishon, any suggestions?
>>
>> OK. Answering my own question.
>>
>> On OMAP platform we power down the phy in phy_power_off() and idle the DPLL in phy_exit(),
>> so my guess is both should be called in suspend() to save the most power.
> 
> Right, this would also match nicely with putting both the phy_init and the phy_power_on call
> in ahci_platform_enable_resources in ahci_platform.c as it looks after v4 of my ahci_platform
> rework patch-set, see:
> https://github.com/jwrdegoede/linux-sunxi/blob/sunxi-devel/drivers/ata/ahci_platform.c
> 
> If this goes there it will be automatically called on both probe and resume (and the counterparts
> should go to ahci_platform_disable_resources, which will be called on suspend and remove).
> 
> As said before I don't really have a preference for in which order these patches go upstream,
> but can you please check that calling phy_poweroff + phy_exit on suspend and undo on resume
> does not cause issues ?  If it does I need to rethink how things will work after my refactoring,
> because currently all the clks / optional regulator and now also optional phy get en/disabled in
> one go through ahci_platform_en/disable_resources.

I too don't have any preference of the upstream path. Maybe i'll repost this series based on your v4 an then you can include them in your series if you like. BTW why is your series still RFC at v4?

As far as OMAP platform is concerned, calling phy_power_off() + phy_exit() shouldn't be a problem for suspend.
Not sure about other platforms as we can't really know for sure what they do in phy_exit().

If phy_power_on/off() and phy_init()/phy_exit() are always meant to be called together then what is the point of having 2 functions each for power up/down.

cheers,
-roger
