Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3FXFc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 01:32:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52190 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3FXFc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 01:32:57 -0400
Message-ID: <51C7D9CC.8090901@ti.com>
Date: Mon, 24 Jun 2013 11:01:56 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 7/9] usb: musb: omap2430: use the new generic PHY framework
References: <1371113039-5784-1-git-send-email-kishon@ti.com> <1371113039-5784-8-git-send-email-kishon@ti.com> <20130618094703.GV5461@arwen.pp.htv.fi>
In-Reply-To: <20130618094703.GV5461@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18 June 2013 03:17 PM, Felipe Balbi wrote:
> Hi,
>
> On Thu, Jun 13, 2013 at 02:13:57PM +0530, Kishon Vijay Abraham I wrote:
>> Use the generic PHY framework API to get the PHY. The usb_phy_set_resume
>> and usb_phy_set_suspend is replaced with power_on/get_sync and
>> power_off/put_sync to align with the new PHY framework.
>>
>> musb->xceiv can't be removed as of now because musb core uses xceiv.state and
>> xceiv.otg. Once there is a separate state machine to handle otg, these can be
>> moved out of xceiv and then we can start using the generic PHY framework.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   drivers/usb/musb/musb_core.c |    1 +
>>   drivers/usb/musb/musb_core.h |    3 +++
>>   drivers/usb/musb/omap2430.c  |   29 +++++++++++++++++++++--------
>>   3 files changed, 25 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
>> index 37a261a..f732bcc 100644
>> --- a/drivers/usb/musb/musb_core.c
>> +++ b/drivers/usb/musb/musb_core.c
>> @@ -1864,6 +1864,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
>>   	musb->board_set_power = plat->set_power;
>>   	musb->min_power = plat->min_power;
>>   	musb->ops = plat->platform_ops;
>> +	musb->phy_label = plat->phy_label;
>>
>>   	/* The musb_platform_init() call:
>>   	 *   - adjusts musb->mregs
>> diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
>> index 7fb4819..498ae21 100644
>> --- a/drivers/usb/musb/musb_core.h
>> +++ b/drivers/usb/musb/musb_core.h
>> @@ -46,6 +46,7 @@
>>   #include <linux/usb.h>
>>   #include <linux/usb/otg.h>
>>   #include <linux/usb/musb.h>
>> +#include <linux/phy/phy.h>
>>
>>   struct musb;
>>   struct musb_hw_ep;
>> @@ -357,6 +358,7 @@ struct musb {
>>   	u16			int_tx;
>>
>>   	struct usb_phy		*xceiv;
>> +	struct phy		*phy;
>>
>>   	int nIrq;
>>   	unsigned		irq_wake:1;
>> @@ -434,6 +436,7 @@ struct musb {
>>   	unsigned                double_buffer_not_ok:1;
>>
>>   	struct musb_hdrc_config	*config;
>> +	const char		*phy_label;
>>
>>   #ifdef MUSB_CONFIG_PROC_FS
>>   	struct proc_dir_entry *proc_entry;
>> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
>> index 628b93f..c62a004 100644
>> --- a/drivers/usb/musb/omap2430.c
>> +++ b/drivers/usb/musb/omap2430.c
>> @@ -348,14 +348,24 @@ static int omap2430_musb_init(struct musb *musb)
>>   	 * up through ULPI.  TWL4030-family PMICs include one,
>>   	 * which needs a driver, drivers aren't always needed.
>>   	 */
>> -	if (dev->parent->of_node)
>> +	if (dev->parent->of_node) {
>> +		musb->phy = devm_phy_get(dev->parent, "usb2-phy");
>> +
>> +		/* We can't totally remove musb->xceiv as of now because
>> +		 * musb core uses xceiv.state and xceiv.otg. Once we have
>> +		 * a separate state machine to handle otg, these can be moved
>> +		 * out of xceiv and then we can start using the generic PHY
>> +		 * framework
>> +		 */
>>   		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
>>   		    "usb-phy", 0);
>> -	else
>> +	} else {
>>   		musb->xceiv = devm_usb_get_phy_dev(dev, 0);
>> +		musb->phy = devm_phy_get(dev, musb->phy_label);
>> +	}
>>
>> -	if (IS_ERR(musb->xceiv)) {
>> -		status = PTR_ERR(musb->xceiv);
>> +	if (IS_ERR(musb->xceiv) || IS_ERR(musb->phy)) {
>> +		status = PTR_ERR(musb->xceiv) | PTR_ERR(musb->phy);
>>
>>   		if (status == -ENXIO)
>>   			return status;
>> @@ -397,9 +407,10 @@ static int omap2430_musb_init(struct musb *musb)
>>   	if (glue->status != OMAP_MUSB_UNKNOWN)
>>   		omap_musb_set_mailbox(glue);
>>
>> -	usb_phy_init(musb->xceiv);
>> +	phy_init(musb->phy);
>>
>>   	pm_runtime_put_noidle(musb->controller);
>> +	phy_pm_runtime_put(musb->phy);
>
> see, weird unbalanced calls :-)
>
> Make it all explicit:
>
> phy_pm_runtime_get_sync(phy);
> phy_init(phy);
> phy_pm_runtime_put(phy);

I think then it makes sense to drop get_sync from phy_init()?

Thanks
Kishon
