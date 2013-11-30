Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3K3DFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 22:05:05 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:38441 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3K3DFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 22:05:03 -0500
Message-ID: <529955D5.7040908@gtsys.com.hk>
Date: Sat, 30 Nov 2013 11:04:53 +0800
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
>

Guys,,, I must be blind

hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
sts has a wrong value, its should be (sts << 29) when sts = 1
same for lpm value (lpm << 28)

Still needs to check the value of PTS, if PTS > 1  or sts flag is read only.


         if (ci->hw_bank.lpm) {
                 hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
                 if ( sts )
                         hw_write(ci, OP_DEVLC, DEVLC_STS, BIT(28));
                 else
                         hw_write(ci, OP_DEVLC, DEVLC_STS, ~BIT(28));
         } else {
                 hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
                 if (((portsc >> 30) & 0x3) > 1) {   /* check if STS is read only */
                         if (sts) {
                                 hw_write(ci, OP_PORTSC, PORTSC_STS, BIT(29));
                         }
                         else {
                                 portsc = (ioread32(ci->hw_bank.regmap[OP_PORTSC])
                                                 & BIT(29));
                                 if (portsc)  /* sts needs reset */
                                         hw_write(ci, OP_PORTSC, PORTSC_STS,
                                                         ~BIT(29));
                         }
                 }
         }


With a write to an already sts = 0 my kernel oops 808. so check if the sts is 0 
and if 0 then no write.

Can someone have a look for the lpm stuff ?


Michael, thanks for the NOACK ;-) otherwise

Regards
Chris








