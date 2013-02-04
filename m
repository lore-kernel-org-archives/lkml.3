Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab3BDS0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:26:10 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:26714 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab3BDSZy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:25:54 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1360002209!23385307!165
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Peter Huewe <peterhuewe@gmx.de>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Date: Mon, 4 Feb 2013 12:25:44 -0600
Subject: RE: [PATCH 08/10] staging/xgifb: Remove unnecessary bitshifts in
 XGI_SetCRT1ModeRegs
Thread-Topic: [PATCH 08/10] staging/xgifb: Remove unnecessary bitshifts in
 XGI_SetCRT1ModeRegs
Thread-Index: Ac4C14ZvkSYl8lB/QJaYhMlgp5hHlwAHtkuQ
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207D12B89AA@AUSP01VMBX24.collaborationhost.net>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
 <1359928479-8484-8-git-send-email-peterhuewe@gmx.de>
 <20130204125901.GH4937@mwanda>
In-Reply-To: <20130204125901.GH4937@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 5:59 AM, Dan Carpenter wrote:
> On Sun, Feb 03, 2013 at 10:54:37PM +0100, Peter Huewe wrote:
>> Since data can only be 0x0000, 0x0035 or 0x0048 we can simply skip the
>> bit shifting and masking as data & 0xFF is always equal to data and
>> data & 0xFF00 is always 0.
>> So we simply use data and 0 directly and save the assignment.
>> 
>> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
>> ---
>>  drivers/staging/xgifb/vb_setmode.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
>> index 6f366f4..1ff1178 100644
>> --- a/drivers/staging/xgifb/vb_setmode.c
>> +++ b/drivers/staging/xgifb/vb_setmode.c
>> @@ -1083,10 +1083,8 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
>>  			data = 0x0048;
>>  	}
>>  
>> -	data2 = data & 0x00FF;
>> -	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFF, data2);
>> -	data2 = (data & 0xFF00) >> 8;
>> -	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFC, data2);
>> +	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFF, data);
>> +	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFC, 0);
>
> This patch is fine.
>
> This is a fairly common pattern where people do:
>
>	write_a_char(data & 0xff);
>	write_a_char((data >> 8) & 0xff);
>
> It feels there should be a macro to do the shift and mask but I'm
> not sure what it would look like.

How about...

#define LOBYTE(x)	((x) & 0xff)
#define HIBYTE(x)	(((x) >> 8) & 0xff)

And for completeness...

#define LOWORD	((x) & 0xffff)
#define HIWORD	(((x) >> 16) & 0xffff)

There are a couple uses of these defines in the kernel already.
sound/synth/emux/emux_synth.c also has LO_BYTE and HI_BYTE
that do the same thing.

Of course these are probably not endian safe.

Regards,
Hartley

