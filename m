Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaAGNCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:02:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59577 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaAGNCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:02:20 -0500
Message-ID: <52CBFAC0.9040103@ti.com>
Date: Tue, 7 Jan 2014 18:31:52 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/5] arm: omap3: twl: use the new lookup method with usb
 phy
References: <1386601737-8735-1-git-send-email-heikki.krogerus@linux.intel.com> <1386601737-8735-5-git-send-email-heikki.krogerus@linux.intel.com> <52AEDE43.8030005@ti.com> <20131216144314.GB22944@xps8300>
In-Reply-To: <20131216144314.GB22944@xps8300>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 16 December 2013 08:13 PM, Heikki Krogerus wrote:
> Hi,
> 
> On Mon, Dec 16, 2013 at 04:34:35PM +0530, Kishon Vijay Abraham I wrote:
>> On Monday 09 December 2013 08:38 PM, Heikki Krogerus wrote:
>>> Provide a complete association for the phy and it's user
>>> (musb) with the new phy_lookup_table.
>>>
>>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>> ---
>>>  arch/arm/mach-omap2/twl-common.c | 15 ++++++---------
>>>  1 file changed, 6 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
>>> index b0d54da..972430b 100644
>>> --- a/arch/arm/mach-omap2/twl-common.c
>>> +++ b/arch/arm/mach-omap2/twl-common.c
>>> @@ -91,18 +91,13 @@ void __init omap_pmic_late_init(void)
>>>  }
>>>  
>>>  #if defined(CONFIG_ARCH_OMAP3)
>>> -struct phy_consumer consumers[] = {
>>> -	PHY_CONSUMER("musb-hdrc.0", "usb"),
>>> -};
>>> -
>>> -struct phy_init_data init_data = {
>>> -	.consumers = consumers,
>>> -	.num_consumers = ARRAY_SIZE(consumers),
>>> +static struct phy_lookup_table twl4030_usb_lookup = {
>>> +	.dev_id = "musb-hdrc.0",
>>> +	.table = PHY_LOOKUP("phy-twl4030_usb.0", NULL),
>>>  };
>>
>> had a similar approach during the initial version of phy framework [1] (see
>> phy_bind) but changed it later [2] . Here you should know the device names of
>> two devices and even if one of them started using DEVID_AUTO, it'll start
>> breaking. Such an approach needs to reviewed carefully.
> 
> If somebody creates a regression by changing something like the
> platform device id without checking all the users, he deserves to get
> into big trouble. I don't see why an individual framework should
> provide protection against such cases.
> 
> In any case, having two device names to deal with does not add any
> more risk. These associations should always be made in the place where
> the phy device is created so you will always know it's device name.

huh.. we should also know the 'controller' device name while defining these
associations and in some cases the controller device and phy device are created
in entirely different places.
> Normally the platform code creates these associations in the same
> place it creates the platform devices, so you definitely know what the
> device names will be.
> 
> In this case it's actually created in drivers/mfd/twl-core.c, so I do
> need to update this and move the lookup table there. We can still
> deliver the user name as platform data, though I believe it's always
> "musb". Maybe we could actually skip that and just hard code the name?

I would rather leave the way it is modelled now.

Thanks
Kishon
