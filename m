Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbaJaTfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:35:43 -0400
Received: from mail-bl2on0083.outbound.protection.outlook.com ([65.55.169.83]:24512
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752634AbaJaTfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:35:41 -0400
Message-ID: <5453E393.3090505@opensource.altera.com>
Date: Fri, 31 Oct 2014 14:31:31 -0500
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
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com> <20141030140416.GF6482@saruman> <5453A8A6.6020800@opensource.altera.com> <20141031174257.GA15756@saruman>
In-Reply-To: <20141031174257.GA15756@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: AMSPR02CA0046.eurprd02.prod.outlook.com (10.242.225.174) To
 BY1PR0301MB1192.namprd03.prod.outlook.com (25.160.195.150)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1192;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6049001)(6009001)(51704005)(51914003)(199003)(189002)(479174003)(24454002)(377454003)(95666004)(93886004)(54356999)(23746002)(42186005)(86362001)(92726001)(87266999)(50986999)(122386002)(76176999)(92566001)(83506001)(120916001)(102836001)(77096003)(50466002)(77156002)(65816999)(64126003)(97736003)(105586002)(40100003)(47776003)(21056001)(59896002)(107046002)(64706001)(31966008)(2351001)(101416001)(110136001)(46102003)(87976001)(65806001)(65956001)(106356001)(20776003)(66066001)(4396001)(80316001)(33656002)(62966003)(99396003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1192;H:[137.57.160.210];FPR:;MLV:ovrnspm;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 12:42 PM, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 31, 2014 at 10:20:06AM -0500, Dinh Nguyen wrote:
>>>> @@ -339,7 +339,8 @@ static void dwc2_handle_wakeup_detected_intr(struct dwc2_hsotg *hsotg)
>>>>  		}
>>>>  		/* Change to L0 state */
>>>>  		hsotg->lx_state = DWC2_L0;
>>>> -		call_gadget(hsotg, resume);
>>>> +		if (!IS_ERR(hsotg->clk))
>>>> +			call_gadget(hsotg, resume);
>>>
>>> instead of exposing the clock detail to the entire driver, add IS_ERR()
>>> checks to resume and suspend instead. In fact, NULL is a valid clock, so
>>> you might as well:
>>>
>>> 	clk = clk_get(foo, bar);
>>> 	if (IS_ERR(clk))
>>> 		dwc->clk = NULL;
>>> 	else
>>> 		dwc->clk = clk;
>>>
>>> Then you don't need any IS_ERR() checks sprinkled around the driver.
>>
>> But we would still need to check for the clock before accessing gadget
>> functionality right?
>>
>> 	if (dwc2->clk)
>> 		call_gadget();
> 
> Read my comment again. "NULL is a valid clock".  Look at what
> clk_enable() does when a NULL pointer is passed:
> 
> static int __clk_enable(struct clk *clk)
> {
> 	int ret = 0;
> 
> 	if (!clk)
> 		return 0;
> 
> 	if (WARN_ON(clk->prepare_count == 0))
> 		return -ESHUTDOWN;
> 
> 	if (clk->enable_count == 0) {
> 		ret = __clk_enable(clk->parent);
> 
> 		if (ret)
> 			return ret;
> 
> 		if (clk->ops->enable) {
> 			ret = clk->ops->enable(clk->hw);
> 			if (ret) {
> 				__clk_disable(clk->parent);
> 				return ret;
> 			}
> 		}
> 	}
> 
> 	clk->enable_count++;
> 	return 0;
> }
> 
> int clk_enable(struct clk *clk)
> {
> 	unsigned long flags;
> 	int ret;
> 
> 	flags = clk_enable_lock();
> 	ret = __clk_enable(clk);
> 	clk_enable_unlock(flags);
> 
> 	return ret;
> }
> EXPORT_SYMBOL_GPL(clk_enable);

Ah yes, thanks for the explanation. So if clk=NULL, it just return 0.
But what I'm saying is that if the driver is configured for dual-role
mode, and no clock is specified, then the driver should not be accessing
any gadget functionality.

So as the patch series stands right now, if I swap out an A connector to
a B-connector, then I get a connect_id_status change interrupt. The
status would show a device and I would initialize the gadget portion of
the driver.

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 44c609f..96810f7 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1371,7 +1371,8 @@ static void dwc2_conn_id_status_change(struct
work_struct *work)
                hsotg->op_state = OTG_STATE_B_PERIPHERAL;
                dwc2_core_init(hsotg, false, -1);
                dwc2_enable_global_interrupts(hsotg);
-               s3c_hsotg_core_init(hsotg);
+               if (hsotg->clk)
+                       s3c_hsotg_core_init(hsotg);

So if I don't have a valid clock, I'll be accessing the peripheral
portion of the IP.

But I guess not having the check for the valid clock here should be fine
as I don't see a case where there can be 2 different clocks for host and
peripheral?


> 
>>>> @@ -400,7 +401,8 @@ static void dwc2_handle_usb_suspend_intr(struct dwc2_hsotg *hsotg)
>>>>  			"DSTS.Suspend Status=%d HWCFG4.Power Optimize=%d\n",
>>>>  			!!(dsts & DSTS_SUSPSTS),
>>>>  			hsotg->hw_params.power_optimized);
>>>> -		call_gadget(hsotg, suspend);
>>>> +		if (!IS_ERR(hsotg->clk))
>>>> +			call_gadget(hsotg, suspend);
>>>>  	} else {
>>>>  		if (hsotg->op_state == OTG_STATE_A_PERIPHERAL) {
>>>>  			dev_dbg(hsotg->dev, "a_peripheral->a_host\n");
>>>> @@ -477,7 +479,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
>>>>  	spin_lock(&hsotg->lock);
>>>>  
>>>>  	if (dwc2_is_device_mode(hsotg))
>>>> -		retval = s3c_hsotg_irq(irq, dev);
>>>> +		if (!IS_ERR(hsotg->clk))
>>>> +			retval = s3c_hsotg_irq(irq, dev);
>>>
>>> wait a minute, if there is no clock we don't call the gadget interrupt
>>> handler ? Why ? Who will disable the IRQ line ?
>>
>> This portion is no static int __clk_enable(struct clk *clk)
> 
> huh ? What I mean is that this has the potential of leaving that IRQ
> line enabled. Imagine you don't have a clock and s3c_hsotg_irq() isn't
> called, then a peripheral IRQ fires, since the handler isn't called, who
> will clear the interrupt ?
> 

Yes, right. This portion of the code is no longer needed when I switched
to use a shared IRQ.

Dinh
