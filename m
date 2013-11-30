Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab3K3BSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 20:18:45 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:51837 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3K3BSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 20:18:43 -0500
Message-ID: <52993CE9.6030009@gtsys.com.hk>
Date: Sat, 30 Nov 2013 09:18:33 +0800
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
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
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

Michael,

I agree that this patch is not sufficient. I had a look in the reference manual 
for the imx27 and here:

Serial Transceiver Select—Read/Write. This register bit is used in conjunction 
with the configuration constant
VUSB_HS_PHY_SERIAL to control whether the parallel or serial transceiver 
interface is selected for FS and LS
operation. The Serial Interface Engine can be used in combination with the UTMI+ 
or ULPI physical interface to
provide FS/LS signaling instead of the parallel interface. If VUSB_HS_PHY_SERIAL 
is set for 0 or 1 then this
bit is read only. If VUSB_HS_PHY_SERIAL is 3 or 4 then this bit is read/write.
This bit has no effect unless Parallel Transceiver Select is set to UTMI+ or 
ULPI. The Serial/1.1 physical interface
will use the Serial Interface Engine for FS/LS signaling regardless of this bit 
value.
Note: This bit is reserved for future operation and is a placeholder adding 
dynamic use of the serial engine in
accord with UMTI+ and ULPI characterization logic.
This bit is not defined in the EHCI specification.


To make it short. In some VUSB_HS_PHY_SERIAL configurations the STS is a READ 
ONLY and should not be written. The current code (without my wrong patch) always 
write to the STS!
With the patch there was no write and no oops with Internal 808 ARM exception..

Let me rework it.

Regards
Chris
