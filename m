Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161045AbaJaPYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:24:22 -0400
Received: from mail-by2on0092.outbound.protection.outlook.com ([207.46.100.92]:55968
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933533AbaJaPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:24:20 -0400
Message-ID: <5453A8A6.6020800@opensource.altera.com>
Date: Fri, 31 Oct 2014 10:20:06 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <paulz@synopsys.com>, <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 6/8] usb: dwc2: gadget: Do not fail probe if there isn't
 a clock node
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com> <20141030140416.GF6482@saruman>
In-Reply-To: <20141030140416.GF6482@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR06CA0022.apcprd06.prod.outlook.com (25.160.171.140) To
 CY1PR0301MB1193.namprd03.prod.outlook.com (25.160.165.24)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1193;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(479174003)(377454003)(199003)(24454002)(164054003)(189002)(51704005)(47776003)(106356001)(65956001)(65806001)(80316001)(33656002)(31966008)(122386002)(4396001)(42186005)(102836001)(23746002)(64706001)(101416001)(66066001)(20776003)(19580405001)(62966003)(40100003)(19580395003)(64126003)(92566001)(92726001)(86362001)(83506001)(87266999)(76176999)(21056001)(87976001)(95666004)(54356999)(99396003)(105586002)(65816999)(46102003)(110136001)(97736003)(59896002)(2351001)(50466002)(50986999)(120916001)(107046002)(77156002)(77096003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1193;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 09:04 AM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Oct 28, 2014 at 06:25:47PM -0500, dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>>
>> Since the dwc2 hcd driver is currently not looking for a clock node during
>> init, we should not completely fail if there isn't a clock provided.
>> For dual-role mode, we will only fail init for a non-clock node error. We
>> then update the HCD to only call gadget funtions if there is a proper clock
>> node.
>>
>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
>> ---
>> v5: reworked to not access gadget functions from the hcd.
>> ---
>>  drivers/usb/dwc2/core.h      |  3 +--
>>  drivers/usb/dwc2/core_intr.c |  9 ++++++---
>>  drivers/usb/dwc2/hcd.c       |  3 ++-
>>  drivers/usb/dwc2/platform.c  | 19 +++++++++++++++----
>>  4 files changed, 24 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
>> index ec70862..48120c8 100644
>> --- a/drivers/usb/dwc2/core.h
>> +++ b/drivers/usb/dwc2/core.h
>> @@ -660,6 +660,7 @@ struct dwc2_hsotg {
>>  #endif
>>  #endif /* CONFIG_USB_DWC2_HOST || CONFIG_USB_DWC2_DUAL_ROLE */
>>  
>> +	struct clk *clk;
>>  #if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
>>  	/* Gadget structures */
>>  	struct usb_gadget_driver *driver;
>> @@ -667,8 +668,6 @@ struct dwc2_hsotg {
>>  	struct usb_phy *uphy;
>>  	struct s3c_hsotg_plat *plat;
>>  
>> -	struct clk *clk;
>> -
>>  	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
>>  
>>  	u32 phyif;
>> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
>> index 1240875..1608037 100644
>> --- a/drivers/usb/dwc2/core_intr.c
>> +++ b/drivers/usb/dwc2/core_intr.c
>> @@ -339,7 +339,8 @@ static void dwc2_handle_wakeup_detected_intr(struct dwc2_hsotg *hsotg)
>>  		}
>>  		/* Change to L0 state */
>>  		hsotg->lx_state = DWC2_L0;
>> -		call_gadget(hsotg, resume);
>> +		if (!IS_ERR(hsotg->clk))
>> +			call_gadget(hsotg, resume);
> 
> instead of exposing the clock detail to the entire driver, add IS_ERR()
> checks to resume and suspend instead. In fact, NULL is a valid clock, so
> you might as well:
> 
> 	clk = clk_get(foo, bar);
> 	if (IS_ERR(clk))
> 		dwc->clk = NULL;
> 	else
> 		dwc->clk = clk;
> 
> Then you don't need any IS_ERR() checks sprinkled around the driver.

But we would still need to check for the clock before accessing gadget
functionality right?

	if (dwc2->clk)
		call_gadget();

> 
>> @@ -400,7 +401,8 @@ static void dwc2_handle_usb_suspend_intr(struct dwc2_hsotg *hsotg)
>>  			"DSTS.Suspend Status=%d HWCFG4.Power Optimize=%d\n",
>>  			!!(dsts & DSTS_SUSPSTS),
>>  			hsotg->hw_params.power_optimized);
>> -		call_gadget(hsotg, suspend);
>> +		if (!IS_ERR(hsotg->clk))
>> +			call_gadget(hsotg, suspend);
>>  	} else {
>>  		if (hsotg->op_state == OTG_STATE_A_PERIPHERAL) {
>>  			dev_dbg(hsotg->dev, "a_peripheral->a_host\n");
>> @@ -477,7 +479,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
>>  	spin_lock(&hsotg->lock);
>>  
>>  	if (dwc2_is_device_mode(hsotg))
>> -		retval = s3c_hsotg_irq(irq, dev);
>> +		if (!IS_ERR(hsotg->clk))
>> +			retval = s3c_hsotg_irq(irq, dev);
> 
> wait a minute, if there is no clock we don't call the gadget interrupt
> handler ? Why ? Who will disable the IRQ line ?

This portion is no longer needed when I use shared IRQ lines.

> 
>> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
>> index 44c609f..fa49c72 100644
>> --- a/drivers/usb/dwc2/hcd.c
>> +++ b/drivers/usb/dwc2/hcd.c
>> @@ -1371,7 +1371,8 @@ static void dwc2_conn_id_status_change(struct work_struct *work)
>>  		hsotg->op_state = OTG_STATE_B_PERIPHERAL;
>>  		dwc2_core_init(hsotg, false, -1);
>>  		dwc2_enable_global_interrupts(hsotg);
>> -		s3c_hsotg_core_init(hsotg);
>> +		if (!IS_ERR(hsotg->clk))
>> +			s3c_hsotg_core_init(hsotg);
>>  	} else {
>>  		/* A-Device connector (Host Mode) */
>>  		dev_dbg(hsotg->dev, "connId A\n");
>> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
>> index 72f32f7..77c8417 100644
>> --- a/drivers/usb/dwc2/platform.c
>> +++ b/drivers/usb/dwc2/platform.c
>> @@ -217,8 +217,17 @@ static int dwc2_driver_probe(struct platform_device *dev)
>>  
>>  	spin_lock_init(&hsotg->lock);
>>  	retval = dwc2_gadget_init(hsotg, irq);
>> -	if (retval)
>> -		return retval;
>> +	if (retval) {
>> +		/*
>> +		 * We will not fail the driver initialization for dual-role
>> +		 * if no clock node is supplied. However, all gadget
>> +		 * functionality will be disabled if a clock node is not
>> +		 * provided. Host functionality will continue.
>> +		 * TO-DO: make clock node a requirement for the HCD.
>> +		 */
>> +		if (!IS_ERR(hsotg->clk))
>> +			return retval;
>> +	}
> 
> no here... this should have been taken care by dwc2_gadget_init()
> itself.

Fixed..

Thanks,
Dinh

