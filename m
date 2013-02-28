Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab3B1KQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:16:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37147 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab3B1KQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:16:22 -0500
Message-ID: <512F2E6F.5010802@ti.com>
Date: Thu, 28 Feb 2013 12:16:15 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        <Russ.Dill@gmail.com>
Subject: Re: [ 79/86] USB: ehci-omap: Dont free gpios that we didnt request
References: <20130226235912.881663118@linuxfoundation.org> <20130226235921.105248169@linuxfoundation.org> <512DBB46.1080609@ti.com> <20130227172059.GA5066@hercules>
In-Reply-To: <20130227172059.GA5066@hercules>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On 02/27/2013 07:20 PM, Luis Henriques wrote:
> Hi Roger,
> 
> On Wed, Feb 27, 2013 at 09:52:38AM +0200, Roger Quadros wrote:
>> Hi Greg,
>>
>> On 02/27/2013 02:08 AM, Greg Kroah-Hartman wrote:
>>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Roger Quadros <rogerq@ti.com>
>>>
>>> commit 428525f97153505e83983460a8d08a3210aa6b8a upstream.
>>>
>>> This driver does not request any gpios so don't free them.
>>> Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
>>> with ehci-omap in use.
>>
>> Please drop this patch from 3.4-stable.
>>
>> In 3.4, the driver requests the gpios in probe() so they must be freed
>> in remove() and this patch should not be applied. Thanks.
> 
> I believe this is also true for the 3.5 kernels.  Can you confirm this?
> 

The problem was introduced in v3.5 by this commit.

commit c05995c3d7d0d8edda6ecd2855ac5fad15fa4723
Author: Russ Dill <Russ.Dill@gmail.com>
Date:   Thu Jun 14 09:24:21 2012 -0700

    mfd: USB: Fix the omap-usb EHCI ULPI PHY reset fix issues.


So the fix is applicable from v3.5 to v3.8

cheers,
-roger


>>
>>>
>>> Without this patch, EHCI will break on repeated insmod/rmmod
>>> of ehci_hcd for all OMAP2+ platforms that use EHCI and
>>> set 'phy_reset = true' in usbhs_omap_board_data.
>>> i.e.
>>>
>>> board-3430sdp.c:	.phy_reset  = true,
>>> board-3630sdp.c:	.phy_reset  = true,
>>> board-am3517crane.c:	.phy_reset  = true,
>>> board-am3517evm.c:	.phy_reset  = true,
>>> board-cm-t3517.c:	.phy_reset  = true,
>>> board-cm-t35.c:	.phy_reset  = true,
>>> board-devkit8000.c:	.phy_reset  = true,
>>> board-igep0020.c:	.phy_reset = true,
>>> board-igep0020.c:	.phy_reset = true,
>>> board-omap3beagle.c:	.phy_reset  = true,
>>> board-omap3evm.c:	.phy_reset  = true,
>>> board-omap3pandora.c:	.phy_reset  = true,
>>> board-omap3stalker.c:	.phy_reset = true,
>>> board-omap3touchbook.c:	.phy_reset  = true,
>>> board-omap4panda.c:	.phy_reset  = false,
>>> board-overo.c:	.phy_reset  = true,
>>> board-zoom.c:	.phy_reset		= true,
>>>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> Reviewed-by: Felipe Balbi <balbi@ti.com>
>>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> ---
>>>  drivers/usb/host/ehci-omap.c |    8 --------
>>>  1 file changed, 8 deletions(-)
>>>
>>> --- a/drivers/usb/host/ehci-omap.c
>>> +++ b/drivers/usb/host/ehci-omap.c
>>> @@ -288,7 +288,6 @@ static int ehci_hcd_omap_remove(struct p
>>>  {
>>>  	struct device *dev				= &pdev->dev;
>>>  	struct usb_hcd *hcd				= dev_get_drvdata(dev);
>>> -	struct ehci_hcd_omap_platform_data *pdata	= dev->platform_data;
>>>  
>>>  	usb_remove_hcd(hcd);
>>>  	disable_put_regulator(dev->platform_data);
>>> @@ -297,13 +296,6 @@ static int ehci_hcd_omap_remove(struct p
>>>  	pm_runtime_put_sync(dev);
>>>  	pm_runtime_disable(dev);
>>>  
>>> -	if (pdata->phy_reset) {
>>> -		if (gpio_is_valid(pdata->reset_gpio_port[0]))
>>> -			gpio_free(pdata->reset_gpio_port[0]);
>>> -
>>> -		if (gpio_is_valid(pdata->reset_gpio_port[1]))
>>> -			gpio_free(pdata->reset_gpio_port[1]);
>>> -	}
>>>  	return 0;
>>>  }
>>>  
>>>
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe stable" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

