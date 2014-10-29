Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbaJ2NgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:36:01 -0400
Received: from mail-by2on0053.outbound.protection.outlook.com ([207.46.100.53]:40273
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932729AbaJ2Nf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:35:59 -0400
Message-ID: <5450ED1C.7030208@opensource.altera.com>
Date: Wed, 29 Oct 2014 08:35:24 -0500
From: Dinh Nguyen <dinguyen@opensource.altera.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>
CC: "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 8/8] usb: dwc2: move usb_disabled() call to host driver
 only
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-9-git-send-email-dinguyen@opensource.altera.com> <A2CA0424C0A6F04399FB9E1CD98E0304844E6ACC@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844E6ACC@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.71.243.105]
X-ClientProxiedBy: DM2PR03CA0031.namprd03.prod.outlook.com (10.141.96.30) To
 DM2PR0301MB1200.namprd03.prod.outlook.com (25.160.217.15)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1200;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(51704005)(24454002)(199003)(377454003)(479174003)(66066001)(99396003)(101416001)(83506001)(64706001)(40100003)(23756003)(105586002)(87266999)(106356001)(95666004)(85306004)(65956001)(42186005)(33656002)(47776003)(107046002)(54356999)(102836001)(76482002)(76176999)(87976001)(120916001)(20776003)(97736003)(19580405001)(65816999)(2501002)(19580395003)(122386002)(64126003)(21056001)(77096002)(50986999)(4396001)(31966008)(80316001)(50466002)(80022003)(85852003)(86362001)(46102003)(92566001)(92726001)(59896002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1200;H:Dinhs-MacBook-Pro.local;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/28/14, 8:26 PM, Paul Zimmerman wrote:
>> From: dinguyen@opensource.altera.com [mailto:dinguyen@opensource.altera.com]
>> Sent: Tuesday, October 28, 2014 4:26 PM
>>
>> Now that platform.c will get built for both Host and Gadget, if we leave the
>> usb_disabled() call in platform.c, it results in the following build error
>> when (!USB && USB_GADGET) condition is met.
>>
>> ERROR: "usb_disabled" [drivers/usb/dwc2/dwc2_platform.ko] undefined!
>>
>> Since usb_disabled() is mostly used to disable USB host functionality, move
>> the call the host portion for the DWC2 driver.
>>
>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
>> ---
>>  drivers/usb/dwc2/hcd.c      | 3 +++
>>  drivers/usb/dwc2/platform.c | 3 ---
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
>> index fa49c72..b741997 100644
>> --- a/drivers/usb/dwc2/hcd.c
>> +++ b/drivers/usb/dwc2/hcd.c
>> @@ -2780,6 +2780,9 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg, int irq,
>>  	int i, num_channels;
>>  	int retval;
>>
>> +	if (usb_disabled())
>> +		return -ENODEV;
>> +
>>  	dev_dbg(hsotg->dev, "DWC OTG HCD INIT\n");
>>
>>  	/* Detect config values from hardware */
>> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
>> index 77c8417..123cf54 100644
>> --- a/drivers/usb/dwc2/platform.c
>> +++ b/drivers/usb/dwc2/platform.c
>> @@ -157,9 +157,6 @@ static int dwc2_driver_probe(struct platform_device *dev)
>>  	int retval;
>>  	int irq;
>>
>> -	if (usb_disabled())
>> -		return -ENODEV;
>> -
>>  	match = of_match_device(dwc2_of_match_table, &dev->dev);
>>  	if (match && match->data) {
>>  		params = match->data;
> 
> I'm confused. You are saying the build is broken until patch 8/8 is
> applied? As always, that is not acceptable. You need to fix the
> breakage at the point where it was introduced, not leave it broken
> until the last patch in the series.
> 

The build gets broken when patch 7/8 of is applied. That is the patch
that finally allows platform.c to get built for host and gadget. I can
fold this patch into patch 7/8.

Dinh
