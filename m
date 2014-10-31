Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbaJaPEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:04:04 -0400
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:50442
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932248AbaJaPEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:04:02 -0400
Message-ID: <5453A3F9.2060606@opensource.altera.com>
Date: Fri, 31 Oct 2014 10:00:09 -0500
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
Subject: Re: [PATCHv6 4/8] usb: dwc2: Update common interrupt handler to call
 gadget interrupt handler
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-5-git-send-email-dinguyen@opensource.altera.com> <20141030140043.GD6482@saruman>
In-Reply-To: <20141030140043.GD6482@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR09CA0035.namprd09.prod.outlook.com (10.255.214.163) To
 DM2PR0301MB1198.namprd03.prod.outlook.com (25.160.217.148)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1198;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(199003)(164054003)(479174003)(377454003)(24454002)(189002)(51704005)(50466002)(33656002)(23746002)(64126003)(50986999)(87266999)(76176999)(54356999)(65816999)(87976001)(46102003)(20776003)(95666004)(106356001)(77156002)(77096003)(2351001)(107046002)(105586002)(65956001)(120916001)(65806001)(66066001)(47776003)(64706001)(99396003)(19580405001)(19580395003)(80316001)(110136001)(21056001)(59896002)(40100003)(83506001)(42186005)(102836001)(97736003)(92726001)(4396001)(86362001)(575784001)(31966008)(122386002)(92566001)(101416001)(62966003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1198;H:[137.57.160.210];FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/30/2014 09:00 AM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Oct 28, 2014 at 06:25:45PM -0500,
> dinguyen@opensource.altera.com wrote:
>> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>> 
>> Make dwc2_handle_common_intr call the gadget interrupt function
>> when operating in peripheral mode. Remove the spinlock functions
>> in s3c_hsotg_irq as dwc2_handle_common_intr() already has the
>> spinlocks.
>> 
>> Move the registeration of the IRQ to common code for platform and
>> PCI.
>> 
>> Remove duplicate interrupt conditions that was in gadget, as
>> those are handled by dwc2 common interrupt handler.
>> 
>> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com> 
>> Acked-by: Paul Zimmerman <paulz@synopsys.com> --- v5: remove
>> individual devm_request_irq from gadget and hcd, and place a 
>> single devm_request_irq in platform and pci. v2: Keep interrupt
>> handler for host and peripheral modes separate --- 
>> drivers/usb/dwc2/core.c      | 10 -------- 
>> drivers/usb/dwc2/core.h      |  3 +++ 
>> drivers/usb/dwc2/core_intr.c |  3 +++ drivers/usb/dwc2/gadget.c
>> | 57 ++------------------------------------------ 
>> drivers/usb/dwc2/pci.c       |  6 +++++ 
>> drivers/usb/dwc2/platform.c  |  9 +++++++ 6 files changed, 23
>> insertions(+), 65 deletions(-)
>> 
>> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c 
>> index d926945..7605850b 100644 --- a/drivers/usb/dwc2/core.c +++
>> b/drivers/usb/dwc2/core.c @@ -458,16 +458,6 @@ int
>> dwc2_core_init(struct dwc2_hsotg *hsotg, bool select_phy, int
>> irq) /* Clear the SRP success bit for FS-I2c */ 
>> hsotg->srp_success = 0;
>> 
>> -	if (irq >= 0) { -		dev_dbg(hsotg->dev, "registering common
>> handler for irq%d\n", -			irq); -		retval =
>> devm_request_irq(hsotg->dev, irq, -
>> dwc2_handle_common_intr, IRQF_SHARED, -
>> dev_name(hsotg->dev), hsotg); -		if (retval) -			return retval; -
>> } - /* Enable common interrupts */ 
>> dwc2_enable_common_interrupts(hsotg);
>> 
>> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h 
>> index 80d29c7..ec70862 100644 --- a/drivers/usb/dwc2/core.h +++
>> b/drivers/usb/dwc2/core.h @@ -967,6 +967,7 @@ extern int
>> s3c_hsotg_suspend(struct dwc2_hsotg *dwc2); extern int
>> s3c_hsotg_resume(struct dwc2_hsotg *dwc2); extern int
>> dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq); extern void
>> s3c_hsotg_core_init(struct dwc2_hsotg *dwc2); +irqreturn_t
>> s3c_hsotg_irq(int irq, void *pw); #else static inline int
>> s3c_hsotg_remove(struct dwc2_hsotg *dwc2) { return 0; } @@ -977,6
>> +978,8 @@ static inline int s3c_hsotg_resume(struct dwc2_hsotg
>> *dwc2) static inline int dwc2_gadget_init(struct dwc2_hsotg
>> *hsotg, int irq) { return 0; } static inline void
>> s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {} +static inline
>> irqreturn_t s3c_hsotg_irq(int irq, void *pw) +{ return
>> IRQ_HANDLED; } #endif
>> 
>> #if IS_ENABLED(CONFIG_USB_DWC2_HOST) ||
>> IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE) diff --git
>> a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c 
>> index b176c2f..b0c14e0 100644 --- a/drivers/usb/dwc2/core_intr.c 
>> +++ b/drivers/usb/dwc2/core_intr.c @@ -474,6 +474,9 @@
>> irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
>> 
>> spin_lock(&hsotg->lock);
>> 
>> +	if (dwc2_is_device_mode(hsotg)) +		retval = s3c_hsotg_irq(irq,
>> dev); + gintsts = dwc2_read_common_intr(hsotg); if (gintsts &
>> ~GINTSTS_PRTINT) retval = IRQ_HANDLED; diff --git
>> a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c index
>> 19d1b03..202f8cc 100644 --- a/drivers/usb/dwc2/gadget.c +++
>> b/drivers/usb/dwc2/gadget.c @@ -2257,14 +2257,13 @@ void
>> s3c_hsotg_core_init(struct dwc2_hsotg *hsotg) * @irq: The IRQ
>> number triggered * @pw: The pw value when registered the
>> handler. */ -static irqreturn_t s3c_hsotg_irq(int irq, void *pw) 
>> +irqreturn_t s3c_hsotg_irq(int irq, void *pw)
> 
> why ? It would've been a lot easier to just make the IRQ line
> shared.
> 

Reworked to use IRQF_SHARED...

Thanks,
Dinh
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJUU6P5AAoJEBmUBAuBoyj0vWwP/1Qq0Gt9U1MF6LHJU853+P+I
jx6xVVanPSuK8yTWprh7M/endv+UkVwwt+2sGZ0MMzLDH1T7Kf6FdqhjlNqvFeRK
qK5LUkpMKvMJKcw6tQNGsjB75X93GRkWLxuZEQ9BpGjfy1fct6Wic/kv66dUVCCI
DevfZZFPGdSmiichVup0sO/cfTJ84R8xyQVuF77LvZ/Wbm606ypV4PTMEjKcFhmr
5s6BeOINm7p1NMuoDaWbmjjOHAfTwy06W3p81LMsWH5yfVCq4TgJSwMbdo8s/i/Y
po/1Nu0x5lwwao1J2OZA7b30i1vbtztCzVPtFcO5quN9rOlsaXRNBGLf9jjHP1OO
PzRSsh1EbAinc4Ohbnii/bdx2g7lWP2ktf5qqoeVocgZkrKA/k5w/QK1qL1z3Onl
ZkylCf5VMd06eOkeGbdce8UFhbceNLw0ryqAVN0bsxiD0u78aH6KvhYhBo29p/1R
VMlKPrsYVDp9xjsp24S/u7o4NvNx8VeIfaKA5JN0Hnzncy03ByaO/o5iMPLb231l
/yCoVyt2A9q7LQs/HeyCZYOFAPpG8ZbTsZrucKB9rRWXizDIrpIfJdcH3mIp71ab
fhhf8sE1kDMrqADLTd1UL96DKCJnU2N8qJLSll6uWNi95J6OogIkj+H4YFPXXWiM
+wUVqVAyYzPKsCaMRNTF
=5+gL
-----END PGP SIGNATURE-----
