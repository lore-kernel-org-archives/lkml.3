Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaEMNY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:24:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45213 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760026AbaEMNY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:24:56 -0400
Message-ID: <53721D24.4090704@ti.com>
Date: Tue, 13 May 2014 18:54:52 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/5] Add support for SW babble Control
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com> <5371EA01.3080307@gmail.com> <537208A9.4020507@ti.com> <53720E0F.3070008@gmail.com> <537216AC.4090401@ti.com> <53721ABF.8060705@gmail.com>
In-Reply-To: <53721ABF.8060705@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 5/13/2014 6:44 PM, Daniel Mack wrote:
> Hi George,
>
> On 05/13/2014 02:57 PM, George Cherian wrote:
>> I never enabled the MUSB_BABBLE_SW_SESSION_CTRL in the MUSB_BABBLE_CTL reg.
>> can you try with the following patch.
>>
>> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
>> index 1ae6681..1160cd1 100644
>> --- a/drivers/usb/musb/musb_dsps.c
>> +++ b/drivers/usb/musb/musb_dsps.c
>> @@ -477,8 +477,11 @@ static int dsps_musb_init(struct musb *musb)
>>    	 * logic enabled.
>>    	 */
>>    	val = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
>> -	if (val == MUSB_BABBLE_RCV_DISABLE)
>> +	if (val == MUSB_BABBLE_RCV_DISABLE) {
>>    		glue->sw_babble_enabled = true;
>> +		val |= MUSB_BABBLE_SW_SESSION_CTRL;
>> +	        dsps_writeb(musb->mregs, MUSB_BABBLE_CTL, val);
>> +	}
>>    
>>    	ret = dsps_musb_dbg_init(musb, glue);
>>    	if (ret)
> MUSB_BABBLE_STUCK_J still remains unset, so I get the same result as
> without the patch: a full glue reset is conducted. Do I get you right
> that you expect MUSB_BABBLE_STUCK_J to be set in babble conditions when
> MUSB_BABBLE_SW_SESSION_CTRL is set?
>
Basically, there are 2 types of babble conditions.
1) Transient babble condition - which could be recovered from without an 
IP reset .
2) Babble condition - which could be recovered from only by doing an IP 
reset.

Looks like you are always hitting case 2 (Most times am also hitting the 
same).
Case 1 is really hard to reproduce. I don't have a reliable method as of 
now to
reproduce this case consistently.
> [   19.672373] CAUTION: musb: Babble Interrupt Occurred
> [   19.677776] musb_stage0_irq 789: unhandled DISCONNECT transition
> (a_wait_bcon)
> [   19.685815] usb 1-1: USB disconnect, device number 3
> [   19.769720] musb-hdrc musb-hdrc.0.auto: babble: MUSB_BABBLE_CTL value 44
> [   19.776765] musb-hdrc musb-hdrc.0.auto: STUCK_J is reset
>
>
> I don't quite follow, especially as I lack documentation of the IP core.
> How do you test babble errors, is there any way to force them to happen
> reliably?

There is no 100% reliable method to force it to happen. Following is
my setup ,
I have a HUB with 4 devices connected , which gives me a Babble interrupt
on both connects and disconnects ( Not always though).
> Anyway, the full glue layer solves this rare condition quite well for
> me. Is there any downside of this?
>
>
> Daniel
>


-- 
-George

