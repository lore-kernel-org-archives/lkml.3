Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaCVRjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:39:35 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56143 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaCVRjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:39:32 -0400
Message-ID: <532DCB06.9040601@googlemail.com>
Date: Sat, 22 Mar 2014 18:40:22 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: shuah.kh@samsung.com, m.chehab@samsung.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] media: em28xx-video - change em28xx_scaler_set() to use
 em28xx_reg_len()
References: <1395435890-15100-1-git-send-email-shuah.kh@samsung.com> <532D82C9.6010401@googlemail.com> <532DAAD0.6060209@samsung.com>
In-Reply-To: <532DAAD0.6060209@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 22.03.2014 16:22, schrieb Shuah Khan:
> On 03/22/2014 06:32 AM, Frank Schäfer wrote:
>>
>> Am 21.03.2014 22:04, schrieb Shuah Khan:
>>> Change em28xx_scaler_set() to use em28xx_reg_len() to get register
>>> lengths for EM28XX_R30_HSCALELOW and EM28XX_R32_VSCALELOW registers,
>>> instead of hard-coding the length. Moved em28xx_reg_len() definition
>>> for it to be visible to em28xx_scaler_set().
>>>
>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>> ---
>>>   drivers/media/usb/em28xx/em28xx-video.c |   29
>>> ++++++++++++++++-------------
>>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c
>>> b/drivers/media/usb/em28xx/em28xx-video.c
>>> index 19af6b3..f8a91de 100644
>>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>>> @@ -272,6 +272,18 @@ static void em28xx_capture_area_set(struct
>>> em28xx *dev, u8 hstart, u8 vstart,
>>>       }
>>>   }
>>>
>>> +static int em28xx_reg_len(int reg)
>>> +{
>>> +    switch (reg) {
>>> +    case EM28XX_R40_AC97LSB:
>>> +    case EM28XX_R30_HSCALELOW:
>>> +    case EM28XX_R32_VSCALELOW:
>>> +        return 2;
>>> +    default:
>>> +        return 1;
>>> +    }
>>> +}
>>> +
>>>   static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
>>>   {
>>>       u8 mode;
>>> @@ -284,11 +296,13 @@ static int em28xx_scaler_set(struct em28xx
>>> *dev, u16 h, u16 v)
>>>
>>>           buf[0] = h;
>>>           buf[1] = h >> 8;
>>> -        em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf, 2);
>>> +        em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf,
>>> +                  em28xx_reg_len(EM28XX_R30_HSCALELOW));
>>>
>>>           buf[0] = v;
>>>           buf[1] = v >> 8;
>>> -        em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
>>> +        em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf,
>>> +                  em28xx_reg_len(EM28XX_R32_VSCALELOW));
>> Hmm... registers 0x30 and 0x32 are always 2 bytes long.
>> So this change would needlessly complicate the code.
>>
>
> The reason I made the change is that em28xx_reg_len() is handling
> these two registers and I thought it would be good to make it
> consistent with other writes to these registers and not hard-code the
> length.

Well, almost all register writes use a hardcoded length (most of the
time it's 1). ;-)

>
> I think it would help with maintenance later by avoiding hard-coding
> the length and use the existing routine that returns the length for
> these registers.

Yes, if the length would be variable, then this would be a good idea.
But AFAIK the length is always 2.

>
> You are correct that it does add a function call in the code path. So
> if you think the trade-off isn't worth it, I am not going to argue
> with it :)

I'm more concerned about the fact that readers of the code could think
that this is a write with a variable length, while the length is
actually always the same.

em28xx_reg_len() is a somewhat dirty hack for vidioc_[g,s]_register
debugging ioctls only.
Btw, what happens when you try to compile the code with this patch
applied and CONFIG_VIDEO_ADV_DEBUG disabled ? ;-)

Anyway, I very much appreciate your efforts to improve the em28xx
driver. :-)
There's much to do !

Regards,
Frank

>
> -- Shuah
>

