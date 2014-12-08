Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaLHD61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 22:58:27 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:42653 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaLHD60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 22:58:26 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: paul.zimmerman@synopsys.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <7266e55511200cdda1d877c6257f5461>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <548521D1.2060509@rock-chips.com>
Date: Mon, 08 Dec 2014 11:58:09 +0800
From: Yunzhi Li <lyz@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>
CC: "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "ulrich.prinz@googlemail.com" <ulrich.prinz@googlemail.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] usb: dwc2: Add generic PHY framework support for
 dwc2 usb controler platform driver.
References: <1417783941-2418-1-git-send-email-lyz@rock-chips.com> <1417783941-2418-4-git-send-email-lyz@rock-chips.com> <A2CA0424C0A6F04399FB9E1CD98E0304844FFB50@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844FFB50@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul:

Thank you for replying.

On 2014/12/6 3:04, Paul Zimmerman wrote:
>> From: Yunzhi Li [mailto:lyz@rock-chips.com]
>> Sent: Friday, December 05, 2014 4:52 AM
>>
>> Get PHY parameters from devicetree and power off usb PHY during
>> system suspend.
>>
>> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>> ---
>>
>>   drivers/usb/dwc2/gadget.c   | 33 ++++++++++++---------------------
>>   drivers/usb/dwc2/platform.c | 34 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 46 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
>> index 200168e..2601c61 100644
>> --- a/drivers/usb/dwc2/gadget.c
>> +++ b/drivers/usb/dwc2/gadget.c
>> [...]
>>
>>   	/*
>> -	 * Attempt to find a generic PHY, then look for an old style
>> -	 * USB PHY, finally fall back to pdata
>> +	 * If platform probe couldn't find a generic PHY or an old style
>> +	 * USB PHY, fall back to pdata
>>   	 */
>> -	phy = devm_phy_get(dev, "usb2-phy");
>> -	if (IS_ERR(phy)) {
>> -		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
>> -		if (IS_ERR(uphy)) {
>> -			/* Fallback for pdata */
>> -			plat = dev_get_platdata(dev);
>> -			if (!plat) {
>> -				dev_err(dev,
>> -				"no platform data or transceiver defined\n");
>> -				return -EPROBE_DEFER;
>> -			}
>> -			hsotg->plat = plat;
>> -		} else
>> -			hsotg->uphy = uphy;
>> -	} else {
>> -		hsotg->phy = phy;
>> +	if (IS_ERR_OR_NULL(hsotg->phy) && IS_ERR_OR_NULL(hsotg->uphy)) {
>> +		plat = dev_get_platdata(dev);
>> +		if (!plat) {
>> +			dev_err(dev,
>> +			"no platform data or transceiver defined\n");
>> +			return -EPROBE_DEFER;
>> +		}
>> +		hsotg->plat = plat;
>> +	} else if (hsotg->phy) {
> You have changed the behavior here. Previously, the driver would work
> even if there were no phys or pdata defined. Now it will return
> -EPROBE_DEFER instead. Are you sure that won't break any existing
> platforms?
>
I don't really catch your meaning. Could you please point out where is 
the difference? Thanks .

In previous version, if there were no phy or usb_phy defined, 
devm_phy_get() and devm_usb_get_phy() both failed, then driver falls 
back to find pdata, if no pdata defined dev_get_platdata() returns NULL, 
then dwc2_gadget_init returns -EPROBE_DEFER and the dwc2_driver_probe 
fail. So I think, for the dwc2 driver without my patch, when 
CONFIG_USB_DWC2_PERIPHERAL or CONFIG_USB_DWC2_DUAL_ROLE selected, if 
there were no phys or pdata defined, the driver probe will also return 
-EPROBE_DEFER. And when only CONFIG_USB_DWC2_HOST selected, the previous 
version driver didn't care any thing about phy, in my patch it will try 
to find a phy when platform driver probe, but do not fail probe if there 
isn't a phy node.


