Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3JOHF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:05:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46826 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab3JOHF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:05:26 -0400
Message-ID: <525CE928.4060405@ti.com>
Date: Tue, 15 Oct 2013 12:35:12 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>,
        "kishon@ti.com" <kishon@ti.com>, "rob@landley.net" <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH] phy: omap: Adapt phy-omap-usb2 for AM437x
References: <1381754603-11581-1-git-send-email-george.cherian@ti.com> <20131014143259.GD31708@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131014143259.GD31708@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Fixed all your comments and already sent a V2.


On 10/14/2013 8:03 PM, Mark Rutland wrote:
> On Mon, Oct 14, 2013 at 01:43:23PM +0100, George Cherian wrote:
>> This patch adds a compatible for AM437x "ti,am43xx-usb2" to
>> reuse the same phy-omap-usb2 driver.
>>
>> Also updated the documentation to add the new compatible.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   Documentation/devicetree/bindings/usb/usb-phy.txt |  2 +-
>>   drivers/phy/phy-omap-usb2.c                       | 13 ++++++++++---
>>   2 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> index c0245c8..d5a7f21 100644
>> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> @@ -3,7 +3,7 @@ USB PHY
>>   OMAP USB2 PHY
>>   
>>   Required properties:
>> - - compatible: Should be "ti,omap-usb2"
>> + - compatible: Should be "ti,omap-usb2" or "ti,am437x-usb2"
> In case this needs to be modified in future, it might be best to split
> this up one per line, with a brief description of when it applies:
>
> - compatible: Should contain one of:
>    * "ti,omap-usb2" for ____ systems
>    * "ti,am437x-usb2" for ____ systems
>
>>    - reg : Address and length of the register set for the device.
>>    - #phy-cells: determine the number of cells that should be given in the
>>      phandle while referencing this phy.
>> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
>> index bfc5c33..0529c83 100644
>> --- a/drivers/phy/phy-omap-usb2.c
>> +++ b/drivers/phy/phy-omap-usb2.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/delay.h>
>>   #include <linux/usb/omap_control_usb.h>
>>   #include <linux/phy/phy.h>
>> +#include <linux/of.h>
>>   #include <linux/of_platform.h>
>>   
>>   /**
>> @@ -172,7 +173,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
>>   	phy->dev		= &pdev->dev;
>>   
>>   	phy->phy.dev		= phy->dev;
>> -	phy->phy.label		= "omap-usb2";
>> +	if (of_device_is_compatible(node, "ti,am437x-usb2"))
>> +		phy->phy.label		= "am437x-usb2";
>> +	else
>> +		phy->phy.label		= "omap-usb2";
> Instead of having this check here, you could put together a struct
> containing the data applying to a particular compatible string, and
> associate it with the compatible string using of_device_id::data.
>
> That means we don't need to duplicate the compatible strings, and it's
> easier to extend in future.
>
>>   	phy->phy.set_suspend	= omap_usb2_suspend;
>>   	phy->phy.otg		= otg;
>>   	phy->phy.type		= USB_PHY_TYPE_USB2;
>> @@ -201,8 +205,10 @@ static int omap_usb2_probe(struct platform_device *pdev)
>>   
>>   	otg->set_host		= omap_usb_set_host;
>>   	otg->set_peripheral	= omap_usb_set_peripheral;
>> -	otg->set_vbus		= omap_usb_set_vbus;
>> -	otg->start_srp		= omap_usb_start_srp;
>> +	if (of_device_is_compatible(node, "ti,omap-usb2")) {
>> +		otg->set_vbus		= omap_usb_set_vbus;
>> +		otg->start_srp		= omap_usb_start_srp;
>> +	}
> Similarly here.
>
> Cheers,
> Mark.


-- 
-George

