Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaENQn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:43:28 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60824 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaENQn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <CADYTM3YH2TJpS0z-Pb=rQPVV5ETHwfYMOOv=BohNB7UmahC9Rw@mail.gmail.com>
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com>
	<5371EA01.3080307@gmail.com>
	<537208A9.4020507@ti.com>
	<53720E0F.3070008@gmail.com>
	<537216AC.4090401@ti.com>
	<53721ABF.8060705@gmail.com>
	<53721D24.4090704@ti.com>
	<CADYTM3bvQPHLJSR=ytTR3bupo=Nk6nQtw=4UgbXurbjkEFSQoA@mail.gmail.com>
	<53730130.3000300@ti.com>
	<CADYTM3YH2TJpS0z-Pb=rQPVV5ETHwfYMOOv=BohNB7UmahC9Rw@mail.gmail.com>
Date: Wed, 14 May 2014 11:43:25 -0500
Message-ID: <CADYTM3bfnhCVi8VKiypMsQOndmzG-=yPksYNV+qZ8X73LPTZog@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Add support for SW babble Control
From: Bin Liu <binmlist@gmail.com>
To: George Cherian <george.cherian@ti.com>
Cc: Daniel Mack <zonque@gmail.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org, balbi@ti.com,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George,

On Wed, May 14, 2014 at 9:34 AM, Bin Liu <binmlist@gmail.com> wrote:
> George,
>
> On Wed, May 14, 2014 at 12:37 AM, George Cherian <george.cherian@ti.com> wrote:
>> On 5/14/2014 12:07 AM, Bin Liu wrote:
>>>
>>> Hi,
>>>
>>> On Tue, May 13, 2014 at 8:24 AM, George Cherian <george.cherian@ti.com>
>>> wrote:
>>>>
>>>> Hi Daniel,
>>>>
>>>>
>>>> On 5/13/2014 6:44 PM, Daniel Mack wrote:
>>>>>
>>>>> Hi George,
>>>>>
>>>>> On 05/13/2014 02:57 PM, George Cherian wrote:
>>>>>>
>>>>>> I never enabled the MUSB_BABBLE_SW_SESSION_CTRL in the MUSB_BABBLE_CTL
>>>>>> reg.
>>>>>> can you try with the following patch.
>>>>>>
>>>>>> diff --git a/drivers/usb/musb/musb_dsps.c
>>>>>> b/drivers/usb/musb/musb_dsps.c
>>>>>> index 1ae6681..1160cd1 100644
>>>>>> --- a/drivers/usb/musb/musb_dsps.c
>>>>>> +++ b/drivers/usb/musb/musb_dsps.c
>>>>>> @@ -477,8 +477,11 @@ static int dsps_musb_init(struct musb *musb)
>>>>>>           * logic enabled.
>>>>>>           */
>>>>>>          val = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
>>>>>> -       if (val == MUSB_BABBLE_RCV_DISABLE)
>>>>>> +       if (val == MUSB_BABBLE_RCV_DISABLE) {
>>>>>>                  glue->sw_babble_enabled = true;
>>>>>> +               val |= MUSB_BABBLE_SW_SESSION_CTRL;
>>>>>> +               dsps_writeb(musb->mregs, MUSB_BABBLE_CTL, val);
>>>>>> +       }
>>>>>>          ret = dsps_musb_dbg_init(musb, glue);
>>>>>>          if (ret)
>>>>>
>>>>> MUSB_BABBLE_STUCK_J still remains unset, so I get the same result as
>>>>> without the patch: a full glue reset is conducted. Do I get you right
>>>>> that you expect MUSB_BABBLE_STUCK_J to be set in babble conditions when
>>>>> MUSB_BABBLE_SW_SESSION_CTRL is set?
>>>>>
>>>> Basically, there are 2 types of babble conditions.
>>>> 1) Transient babble condition - which could be recovered from without an
>>>> IP
>>>> reset .
>>>> 2) Babble condition - which could be recovered from only by doing an IP
>>>> reset.
>>>>
>>>> Looks like you are always hitting case 2 (Most times am also hitting the
>>>> same).
>>>> Case 1 is really hard to reproduce. I don't have a reliable method as of
>>>> now
>>>> to
>>>> reproduce this case consistently.
>>>>
>>>>> [   19.672373] CAUTION: musb: Babble Interrupt Occurred
>>>>> [   19.677776] musb_stage0_irq 789: unhandled DISCONNECT transition
>>>>> (a_wait_bcon)
>>>>> [   19.685815] usb 1-1: USB disconnect, device number 3
>>>>> [   19.769720] musb-hdrc musb-hdrc.0.auto: babble: MUSB_BABBLE_CTL value
>>>>> 44
>>>>> [   19.776765] musb-hdrc musb-hdrc.0.auto: STUCK_J is reset
>>>>>
>>>>>
>>>>> I don't quite follow, especially as I lack documentation of the IP core.
>>>>> How do you test babble errors, is there any way to force them to happen
>>>>> reliably?
>>>>
>>>>
>>>> There is no 100% reliable method to force it to happen. Following is
>>>
>>> I have a way to force babble happen reliably - shorting DP or DM to
>>> VBUS. I opened the far-end plug of the USB cable, so I can easily
>>> short DP or DM to VBUS.
>>
>> Good to know that you have a reliable way to test babble condition.
>> Can you please do a quick test on 3.15.0-rc4 with the series applied?
>> In case of any assistance please do let me know.
>
> Sure, but could you please re-send those patches to my corporate email
> so that I can apply them from Thunderbird?

You don't have to resend the patches. Nishanth Menon showed me a way
to extract the patch from Gmail - Thanks Nishanth.

But which repo do you want to me test with? The first patch ([PATCH v2
1/5] usb: musb: core: Convert babble recover work to delayed work)
does not apply to v3.15-rc4 tag. the current musb_core.c does not have
the recovery work for musb. Please let me know what I missed.

Thanks,
-Bin.

>
> I read these linux-usb emails in Gmail, and  am not aware of any easy
> way to extract patches from Gmail.
>
> BTY, I tested with TI 3.12.10 kernel, in which I guess the babble
> handling is similar to this patch set. With TI3.12.10, MISC is always
> 0x64, so MUSB never restarts.
>
> Thanks,
> -Bin.
>
>>
>>> But the interesting thing is that with TI 3.2 kernel, shorting DP or
>>> DM to VBUS causes MISC register to be 0x4, but the result is
>>> completely opposite in TI 3.12.10 kernel, which cause MISC to be 0x64.
>>>
>>> So in the 3.2 kernel, the babble handing resets the controller, but
>>> the 3.12.10 does not.
>>>
>>> Regards,
>>> -Bin.
>>>
>>>> my setup ,
>>>> I have a HUB with 4 devices connected , which gives me a Babble interrupt
>>>> on both connects and disconnects ( Not always though).
>>>>
>>>>> Anyway, the full glue layer solves this rare condition quite well for
>>>>> me. Is there any downside of this?
>>>>>
>>>>>
>>>>> Daniel
>>>>>
>>>>
>>>> --
>>>> -George
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>>>>
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> -George
>>
