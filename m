Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3FZMH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:07:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54654 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab3FZMHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:07:23 -0400
Message-ID: <51CAD977.6040309@ti.com>
Date: Wed, 26 Jun 2013 17:37:19 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: continue probe even if usb3 phy is not
 available
References: <1372238954-29047-1-git-send-email-george.cherian@ti.com> <20130626101647.GT12640@arwen.pp.htv.fi>
In-Reply-To: <20130626101647.GT12640@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/2013 3:46 PM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Jun 26, 2013 at 02:59:14PM +0530, George Cherian wrote:
>> There can be configurations in which DWC3 is hoooked up only to USB2 PHY.
>> In such cases we should not return -EPROBE_DEFER, rather continue probe
>> even if there is no USB3 PHY.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/usb/dwc3/core.c | 31 ++++++++++++++++++++++++-------
>>   1 file changed, 24 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index c35d49d..d5e6f3e 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -100,7 +100,9 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>>   	dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
>>   
>>   	usb_phy_init(dwc->usb2_phy);
>> -	usb_phy_init(dwc->usb3_phy);
>> +
>> +	if (dwc->usb3_phy)
>> +		usb_phy_init(dwc->usb3_phy);
> I would feel more comfortable if you would move our maximum_speed module
> parameter to DT with a property such as:
>
> snps,maximum_speed = "highspeed";
>
> then on driver you could:
okay
> ret = of_property_read_string(np, "snps,maximum_speed", &maximum_speed);
> if (ret < 0)
> 	bailout();
>
> if (strncmp(maximum_speed, "superspeed", 10) == 0) {
> 	/* grab USB3 PHY, return EPROBE_DEFER if not found */
> 	grab_usb3_phy();
> }
>
> if ((strncmp(maximum_speed, "highspeed", 9) == 0) ||
> 	(strncmp(maximum_speed, "fullspeed", 9) == 0) ||
> 	(strncmp(maximum_speed, "lowspeed", 8) == 0)) {
> 	/* grab USB2 PHY, return EPROBE_DEFER if not found */
> 	grab_usb2_phy();
> }
>
> this way, we depend solely on setting maximum_speed to highspeed for
> AM437x :-)
In dra7xx one instance is superspeed and one instance highspeed.
>
> ps: don't forget to default to superspeed in case no property is passed.
okay
Regards
-George
