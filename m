Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaKJRG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:06:56 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50752 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaKJRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:06:53 -0500
MIME-Version: 1.0
In-Reply-To: <20141104062137.GC56751@vmdeb7>
References: <1415073514-12555-1-git-send-email-coproscefalo@gmail.com>
	<20141104062137.GC56751@vmdeb7>
Date: Mon, 10 Nov 2014 09:58:29 -0700
Message-ID: <CAGdLNWH9OqBO1TgNm7ZRnX_wnGwe3rUuxaqwvLfq=HdYXNmMbw@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Fix regression caused by backlight extra
 check code
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nuno Lopes <nunoplopes@sapo.pt>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

Sorry for the way late reply, I had to go out of town in a hurry.

2014-11-03 23:21 GMT-07:00 Darren Hart <dvhart@infradead.org>:
> On Mon, Nov 03, 2014 at 08:58:34PM -0700, Azael Avalos wrote:
>> Bug 86521 uncovered that some TOS6208 devices also return
>> non zero values on a write call to the backlight method,
>> thus getting caught and bailed out by the extra check code.
>>
>> This patch makes sure that the extra check is being done
>> on a TOS1900 device and then make the check for the broken
>> backlight code.
>>
>> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
>> ---
>>  drivers/platform/x86/toshiba_acpi.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
>> index ef3a190..e3fed12 100644
>> --- a/drivers/platform/x86/toshiba_acpi.c
>> +++ b/drivers/platform/x86/toshiba_acpi.c
>> @@ -944,9 +944,13 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
>>       /* Extra check for "incomplete" backlight method, where the AML code
>>        * doesn't check for HCI_SET or HCI_GET and returns TOS_SUCCESS,
>>        * the actual brightness, and in some cases the max brightness.
>> +      * Use the SPFC method as an indicator that we're on a TOS1900 device,
>> +      * otherwise some TOS6208 devices might get bailed out, see bug 86521
>
> This needs a clearer description here in this comment, rather than redirecting
> the reader to a bug report (which may or may not exist when needed).

Alright, will do whenever we reach an agreement below.

>
>>        */
>> -     if (out[2] > 0  || out[3] == 0xE000)
>> -             return -ENODEV;
>> +     if (acpi_has_method(dev->acpi_dev->handle, "SPFC")) {
>
> Hrm, this checking for the existence of a specific method seems suspect to me.
> We would know if we are on a TOS1900 as we matches the acpi id already. Is the
> SPFC significant here, or is it just a "we only see SPFC on TOS1900 so it's a
> convenient test"? If the latter, it seems rather fragile and prone to other
> breakage to me.

Yeah, its the latter, the "SPFC" method is specific to TOS1900 devices.

All of the TOS1900 support the Toshiba specific backlight read-only,
and that test is just to get those implementations where the AML
code doesn't check for read/write registers, so far I've identified three
series of laptops with this issue (all Qosmios), X500, X505 and X75-A
(and there might be more around).

We could dissable backlight on all TOS1900 or add those three models
to the (growing) DMI list on video.c, but of course, I would like to keep
the code in-house, but that's just me :-)

>
> Rafael, any recommendations here?
>
>> +             if (out[2] > 0  || out[3] == 0xE000)
>> +                     return -ENODEV;
>> +     }
>>
>>       return out[0] == TOS_SUCCESS ? 0 : -EIO;
>>  }
>> --
>> 2.1.1
>>
>>
>
> --
> Darren Hart
> Intel Open Source Technology Center

Cheers
Azael



-- 
-- El mundo apesta y vosotros apestais tambien --
