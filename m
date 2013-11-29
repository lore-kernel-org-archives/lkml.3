Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3K2Ejm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 23:39:42 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:49598 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3K2Ejg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 23:39:36 -0500
Message-ID: <52981AD7.2020102@gtsys.com.hk>
Date: Fri, 29 Nov 2013 12:40:55 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Peter Chen <Peter.Chen@freescale.com>
CC: "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] usb: chipidea: Fix Internal error: : 808 [#1] ARM
 related to STS flag
References: <1385690869-32266-1-git-send-email-chris.ruehl@gtsys.com.hk> <F281D0F91ED19E4D8E63A7504E8A649804139AAE@039-SN2MPN1-021.039d.mgd.msft.net>
In-Reply-To: <F281D0F91ED19E4D8E63A7504E8A649804139AAE@039-SN2MPN1-021.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 29, 2013 11:27 AM, Peter Chen wrote:
>   
>> * init the sts flag to 0 (missed)
>> * set the sts flag only if not 0
>>
> does PORTSC_STS bit as 1 or 0 affect your case?
> If not, please remove hw_write(ci, OP_DEVLC, DEVLC_STS, sts),
> since it is useless at current code logic.
>
> Peter

Peter,

in the switch statement sts is set to 1 therefore I think its used.

        case USBPHY_INTERFACE_MODE_SERIAL:
                 portsc = PORTSC_PTS(PTS_SERIAL);
                 lpm = DEVLC_PTS(PTS_SERIAL);
                 sts = 1;
                 break;

Regards
Chris


>
>> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
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
>>   	u32 portsc, lpm, sts;
>>
>> +	sts = 0;
>> +
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
>>   	}
>>   }
>>
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

