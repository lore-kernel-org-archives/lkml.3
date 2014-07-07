Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaGGQBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:01:53 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:39175 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaGGQBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:01:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAN+gG=GM9FqZJwJF0G41E9oWEjcWDeavd=kfZ9qcXvoAkmUdpA@mail.gmail.com>
References: <1404022428-2816-1-git-send-email-borneo.antonio@gmail.com>
	<CAN+gG=GM9FqZJwJF0G41E9oWEjcWDeavd=kfZ9qcXvoAkmUdpA@mail.gmail.com>
Date: Tue, 8 Jul 2014 00:01:50 +0800
Message-ID: <CAAj6DX1UgwxvGEr2twznoSfGLEZ2ojcB0fyotSgQ0648ZU=KLQ@mail.gmail.com>
Subject: Re: [PATCH] HID: cp2112: fix gpio value in gpio_direction_output
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        David Barksdale <dbarksdale@uplogix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 10:03 PM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Sun, Jun 29, 2014 at 2:13 AM, Antonio Borneo
> <borneo.antonio@gmail.com> wrote:
>> CP2112 does not offer an atomic method to set both gpio
>> direction and value.
>> Also it does not permit to set gpio value before putting
>> gpio in output. In fact, accordingly to Silicon Labs
>> AN495, Rev. 0.2, cpt. 4.4, the HID report to set gpio
>> values "does not affect any pins that are not configured
>> as outputs".
>>
>> This is confirmed on evaluation board CP2112-EK.
>> With current driver, after execute:
>>         echo in > /sys/class/gpio/gpio248/direction
>>         echo low > /sys/class/gpio/gpio248/direction
>> gpio output is still high. Only after a following
>>         echo low > /sys/class/gpio/gpio248/direction
>> gpio output gets low.
>>
>> Fix driver by changing order of operations; first set
>> direction then set value.
>>
>> The drawback of this new sequence is that we can have
>> a pulse on gpio pin when direction is changed from
>> input to output-low, but this cannot be avoided on
>> current CP2112.
>
> In this case, does keeping the first cp2112_gpio_set() before setting
> the output direction prevents the pulse?
> If so, then you can just keep the current code, and simply add the
> cp2112_gpio_set() at the end of cp2112_gpio_direction_output().

Hi Benjamin,

unfortunately this would not prevent the pulse.
In fact:

a) if gpio is already output
- the first cp2112_gpio_set() will set the value
- then cp2112_gpio_direction_output() would be redundant
- finally the second cp2112_gpio_set() would be redundant too.

b) if gpio is input
- the first cp2112_gpio_set() would be ignored, as explained in AN495
- then cp2112_gpio_direction_output() would put gpio in output.
Accordingly to my experiments the value is set high
- finally the second cp2112_gpio_set() would set the proper value. If
value is different from what is set by cp2112_gpio_direction_output()
we get a pulse.

That's why I removed the first cp2112_gpio_set() or, better, I moved
it after setting gpio direction.

Thanks for the review.
Antonio

>
> In both case, this is:
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> Cheers,
> Benjamin
>
>>
>> Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
>> ---
>>  drivers/hid/hid-cp2112.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
>> index 56be85a..3952d90 100644
>> --- a/drivers/hid/hid-cp2112.c
>> +++ b/drivers/hid/hid-cp2112.c
>> @@ -240,8 +240,6 @@ static int cp2112_gpio_direction_output(struct gpio_chip *chip,
>>         u8 buf[5];
>>         int ret;
>>
>> -       cp2112_gpio_set(chip, offset, value);
>> -
>>         ret = hid_hw_raw_request(hdev, CP2112_GPIO_CONFIG, buf,
>>                                        sizeof(buf), HID_FEATURE_REPORT,
>>                                        HID_REQ_GET_REPORT);
>> @@ -260,6 +258,12 @@ static int cp2112_gpio_direction_output(struct gpio_chip *chip,
>>                 return ret;
>>         }
>>
>> +       /*
>> +        * Set gpio value when output direction is already set,
>> +        * as specified in AN495, Rev. 0.2, cpt. 4.4
>> +        */
>> +       cp2112_gpio_set(chip, offset, value);
>> +
>>         return 0;
>>  }
>>
>> --
>> 2.0.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
