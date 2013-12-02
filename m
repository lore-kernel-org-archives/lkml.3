Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3LBBtp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:49:45 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:52706 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3LBBto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:49:44 -0500
Message-ID: <529BE72C.9030805@gtsys.com.hk>
Date: Mon, 02 Dec 2013 09:49:32 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Peter Chen <Peter.Chen@freescale.com>
CC: "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
References: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk> <F281D0F91ED19E4D8E63A7504E8A64980413B204@039-SN2MPN1-021.039d.mgd.msft.net>
In-Reply-To: <F281D0F91ED19E4D8E63A7504E8A64980413B204@039-SN2MPN1-021.039d.mgd.msft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Saturday, November 30, 2013 06:20 PM, Peter Chen wrote:
>
>>
>> usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
>>
>> * init the sts flag to 0 (missed)
>> * Set PORTCS_STS only if VUSB_HS_PHY_TYPE>  1
>>    otherwise the register is ReadOnly
>> * Set/Reset correct BIT(28)/BIT(29) for STS
>>
>> Signed-off-by: Chris Ruehl<chris.ruehl@gtsys.com.hk>
>> ---
>>   drivers/usb/chipidea/core.c |   20 +++++++++++++++++---
>>   1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
>> index 5075407..2c634c1 100644
>> --- a/drivers/usb/chipidea/core.c
>> +++ b/drivers/usb/chipidea/core.c
>> @@ -243,7 +243,7 @@ static int hw_device_init(struct ci_hdrc *ci, void
>> __iomem *base)
>>
>>   static void hw_phymode_configure(struct ci_hdrc *ci)
>>   {
>> -	u32 portsc, lpm, sts;
>> +	u32 portsc, lpm, sts = 0;
>>
>>   	switch (ci->platdata->phy_mode) {
>>   	case USBPHY_INTERFACE_MODE_UTMI:
>> @@ -273,10 +273,24 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>>
>>   	if (ci->hw_bank.lpm) {
>>   		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
>> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
>> +		if ( sts )
>> +			hw_write(ci, OP_DEVLC, DEVLC_STS, BIT(28));
>> +		else
>> +			hw_write(ci, OP_DEVLC, DEVLC_STS, ~BIT(28));
>>   	} else {
>>   		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
>> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
>> +		if (((portsc>>  30)&  0x3)>  1) {
>> +			if (sts) {
>> +				hw_write(ci, OP_PORTSC, PORTSC_STS, BIT(29));
>> +			}
>> +			else {
>> +				portsc = (ioread32(ci->hw_bank.regmap[OP_PORTSC])
>> +						&  PORTSC_STS);
>> +				if (portsc)
>> +					hw_write(ci, OP_PORTSC, PORTSC_STS,
>> +							~BIT(29));
>> +			}
>> +		}
>>   	}
>>   }
>>
>> --
>
> At my chipidea datasheet, the VUSB_HS_PHY_SERIAL is at HWGENERAL (bit[10..11]),
> We are still not sure the portsc_sts is needed to set or clear, and how to do
> it. My suggestion is just use v2 patch (except fixing one code style problem)
>
> Peter
>

Peter,
Thanks you for your comments.

If you have a look into the function hw_write() you will see that there is no 
effect if hw_write(...,sts) is called with sts=0/1, because the mask will cut 
off all bits beside BIT(29).
I used BIT(29) rather then PORTCS_STS to make it more clear what going on.
A write to PORTCS will always be "0" for the STS Register no matter if sts is 1 
or 0 within Patch v2. Patch v3 will take care of the registers bit position and 
set 1 or 0 to PORTCS_STS.

I used the imx27 reference manual Capital 30.8.1.5.12 PORTSCx.

Please comment.
Chris
