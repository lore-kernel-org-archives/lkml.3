Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaGIWIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:08:23 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:59894 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaGIWIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:08:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140709163050.GM2635@lee--X1>
References: <1404763270-24932-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140709163050.GM2635@lee--X1>
Date: Thu, 10 Jul 2014 00:08:21 +0200
Message-ID: <CAFo99gYErPZo_f-5kZkDqZ0YSPirE1fLn2F1odMPSjuUdLUQ8A@mail.gmail.com>
Subject: Re: [PATCH] video: backlight: jornada720_lcd.c: Cleaning up variable
 that is never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-09 18:30 GMT+02:00 Lee Jones <lee.jones@linaro.org>:
> On Mon, 07 Jul 2014, Rickard Strandqvist wrote:
>
>> Variable ar assigned a value that is never used.
>> I have also removed all the code that thereby serves no purpose,
>> and made same change to clarify the similarities in function.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/video/backlight/jornada720_lcd.c |   31 ++++++++++++++----------------
>>  1 file changed, 14 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
>> index da3876c..d16abcf 100644
>> --- a/drivers/video/backlight/jornada720_lcd.c
>> +++ b/drivers/video/backlight/jornada720_lcd.c
>> @@ -36,44 +36,41 @@ static int jornada_lcd_get_power(struct lcd_device *ld)
>>
>>  static int jornada_lcd_get_contrast(struct lcd_device *ld)
>>  {
>> -     int ret;
>> +     int ret = -ETIMEDOUT;
>>
>>       if (jornada_lcd_get_power(ld) != FB_BLANK_UNBLANK)
>>               return 0;
>>
>>       jornada_ssp_start();
>>
>> -     if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
>> +     if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY)
>>               dev_err(&ld->dev, "get contrast failed\n");
>> -             jornada_ssp_end();
>> -             return -ETIMEDOUT;
>> -     } else {
>> +     else
>>               ret = jornada_ssp_byte(TXDUMMY);
>> -             jornada_ssp_end();
>> -             return ret;
>> -     }
>> +
>> +     jornada_ssp_end();
>> +
>> +     return ret;
>>  }
>>
>>  static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
>>  {
>> -     int ret;
>> +     int ret = -ETIMEDOUT;
>>
>>       jornada_ssp_start();
>>
>>       /* start by sending our set contrast cmd to mcu */
>> -     ret = jornada_ssp_byte(SETCONTRAST);
>> -
>> +     if (jornada_ssp_byte(SETCONTRAST) != TXDUMMY)
>> +             dev_err(&ld->dev, "set contrast failed\n");
>>       /* push the new value */
>> -     if (jornada_ssp_byte(value) != TXDUMMY) {
>> +     else if (jornada_ssp_byte(value) != TXDUMMY)
>>               dev_err(&ld->dev, "set contrast failed\n");
>> -             jornada_ssp_end();
>> -             return -ETIMEDOUT;
>> -     }
>> +     else /* if we get here we can assume everything went well */
>> +             ret = 0;
>>
>> -     /* if we get here we can assume everything went well */
>>       jornada_ssp_end();
>>
>> -     return 0;
>> +     return ret;
>>  }
>>
>>  static int jornada_lcd_set_power(struct lcd_device *ld, int power)
>
> Counter suggestion.
>
> What do you think, I think this looks cleaner:
>
> static int jornada_lcd_get_contrast(struct lcd_device *ld)
> {
>         int ret;
>
>         if (jornada_lcd_get_power(ld) != FB_BLANK_UNBLANK)
>                 return 0;
>
>         jornada_ssp_start();
>
>         if (jornada_ssp_byte(GETCONTRAST) == TXDUMMY) {
>                 ret = jornada_ssp_byte(TXDUMMY);
>                 goto success;
>         }
>
>         dev_err(&ld->dev, "failed to set contrast\n");
>         ret = -ETIMEDOUT;
>
> success:
>         jornada_ssp_end();
>         return ret;
> }
>
> static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
> {
>         int ret = 0;
>
>         jornada_ssp_start();
>
>         /* start by sending our set contrast cmd to mcu */
>         if (jornada_ssp_byte(SETCONTRAST) == TXDUMMY) {
>                 /* if successful, push the new value */
>                 if (jornada_ssp_byte(value) == TXDUMMY)
>                         goto success;
>         }
>
>         dev_err(&ld->dev, "failed to set contrast\n");
>         ret = -ETIMEDOUT;
>
> success:
>         jornada_ssp_end();
>         return ret;
> }


Hi Lee!

Yes, I agree!
Both are clean without so much repetition of code, which was what annoyd me.
But yours is clearer when things go good or bad, nice 1 ;)

I do not know what I can/may do, but I'll try. Remove what is not ok :-)

Reviewed-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Suggested-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>


Kind regards
Rickard Strandqvist
