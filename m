Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3K3BeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:34:01 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:49726 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab3K3Bd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:33:59 -0500
Message-ID: <5299407C.30109@gtsys.com.hk>
Date: Sat, 30 Nov 2013 09:33:48 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Michael Grzeschik <mgr@pengutronix.de>
CC: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
References: <1385709585-10459-1-git-send-email-chris.ruehl@gtsys.com.hk> <20131129182812.GF3516@pengutronix.de>
In-Reply-To: <20131129182812.GF3516@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 30, 2013 02:28 AM, Michael Grzeschik wrote:
> On Fri, Nov 29, 2013 at 03:19:45PM +0800, Chris Ruehl wrote:
>> usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
>>
>> * init the sts flag to 0 (missed)
>> * set the sts flag only if not 0
>>
>> Signed-off-by: Chris Ruehl<chris.ruehl@gtsys.com.hk>
>> ---
>>   drivers/usb/chipidea/core.c |    8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
>> index 5075407..1a6010e 100644
>> --- a/drivers/usb/chipidea/core.c
>> +++ b/drivers/usb/chipidea/core.c
>> @@ -245,6 +245,8 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>>   {
>>   	u32 portsc, lpm, sts = 0;
>>
>>   	switch (ci->platdata->phy_mode) {
>>   	case USBPHY_INTERFACE_MODE_UTMI:
>>   		portsc = PORTSC_PTS(PTS_UTMI);
>> @@ -273,10 +275,12 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>>
>>   	if (ci->hw_bank.lpm) {
>>   		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
>> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
>> +		if (sts)
>> +			hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
>>   	} else {
>>   		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
>> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
>> +		if ( sts )
>> +			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
>
> The conditions coding style is broken.
>
>>   	}
>>   }
>
> Still don't get why a system with ehci compliant PORTSC register
> should not want to have the sts bit _explicitly_ set to 0 if
> we don't use serial phy mode. So NACK!
>
> Michael

That's happen when I remove the if() statements and unconditional write the sts flag

[    1.128482] ehci-mxc: Freescale On-Chip EHCI Host driver
[    1.136702] usbcore: registered new interface driver usb-storage
[    1.147594] imx_usb 10024000.usb: dummy supplies not allowed
[    1.154803] Unhandled fault: external abort on non-linefetch (0x808) at 
0xf4424184
[    1.162424] Internal error: : 808 [#1] ARM
[    1.166548] Modules linked in:
[    1.169670] CPU: 0 PID: 1 Comm: swapper Not tainted 
3.13.0-rc1-next-20131125-dirty #44
[    1.177629] task: cf850000 ti: cf852000 task.ti: cf852000
[    1.183086] PC is at ci_hdrc_probe+0x250/0x630
[    1.187582] LR is at console_unlock+0x2d4/0x30c
[    1.192165] pc : [<c025f7a8>]    lr : [<c003ec50>]    psr: 60000013


regards
Chris

-- 
GTSYS Limited RFID Technology
A01 24/F Gold King Industrial Bld
35-41 Tai Lin Pai Road, Kwai Chung, Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
