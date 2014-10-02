Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaJBUCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:02:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65099 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaJBUCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <20141002183230.GA1108@vmdeb7>
References: <1412045824-3515-1-git-send-email-coproscefalo@gmail.com>
	<20141002183230.GA1108@vmdeb7>
Date: Thu, 2 Oct 2014 14:02:10 -0600
Message-ID: <CAGdLNWGqJfzJW0q6ZJrmLqZrFS-1rXUkMuff-AD_Lvqz-p-uEg@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Adapt kbd_bl_timeout_store to the new kbd type
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

2014-10-02 12:32 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> On Mon, Sep 29, 2014 at 08:57:04PM -0600, Azael Avalos wrote:
>> With the introduccion of the new keyboard backlight
>> implementation, the *_timeout_store function is
>> broken, as it only supports the first kbd_type.
>>
>> This patch adapt such function for the new kbd_type,
>> as well as convert from using sscanf to kstrtoint.
>>
>> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
>> ---
>>  drivers/platform/x86/toshiba_acpi.c | 33 +++++++++++++++++++++++++--------
>>  1 file changed, 25 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
>> index 5d509ea..13ee56b 100644
>> --- a/drivers/platform/x86/toshiba_acpi.c
>> +++ b/drivers/platform/x86/toshiba_acpi.c
>> @@ -1453,18 +1453,35 @@ static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
>>                                           const char *buf, size_t count)
>>  {
>>       struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
>> -     int time = -1;
>> +     int time;
>> +     int ret;
>> +
>> +     ret = kstrtoint(buf, 0, &time);
>> +     if (ret)
>> +             return ret;
>>
>> -     if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
>> +     if (time < 1 || time > 60)
>>               return -EINVAL;
>
> If I'm parsing this correctly, previously a time==0 was valid, and now it will
> return -EINVAL. Is that intentional?

Yes, see below.

>
>>
>> -     /* Set the Keyboard Backlight Timeout: 0-60 seconds */
>> -     if (time != -1 && toshiba->kbd_time != time) {
>> +     /* Set the Keyboard Backlight Timeout: 1-60 seconds */
>
> So the time range change appears intentional. Why is that?

The previous implementation (type 1) accepted values 0-60,
but the new one (type 2) just accepts 1-60, so I basically
just changed both to the new range.

>
>> +
>> +     /* Only make a change if the actual timeout has changed */
>> +     if (toshiba->kbd_time != time) {
>> +             /* Shift the time to "base time" (0x3c0000 == 60 seconds)*/
>>               time = time << HCI_MISC_SHIFT;
>> -             time = (toshiba->kbd_mode == SCI_KBD_MODE_AUTO) ?
>> -                                                     time + 1 : time + 2;
>> -             if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
>> -                     return -EIO;
>> +             /* OR the "base time" to the actual method format */
>> +             if (toshiba->kbd_type == 1) {
>> +                     /* Type 1 requires the oposite mode */
>
> opposite

Typo there, sorry.

>
> Is it "opposite" or "current"?
>

Opposite (again, welcome to Toshiba's KBD BL implementation).

For type 1, to change modes you set (OR?) the value to
the current mode, if FNZ, you set it to AUTO, and viceversa.
Now, to change the time (in case we are in AUTO), you set
the timeout to the opposite mode, if AUTO, you set it to FNZ,
and viceversa (of course this will never happen as the sysfs
entry is hidden).

For type 2, to change modes and time you set the value to the desired
mode (ON, OFF or AUTO), again, the time can only be changed when
in AUTO mode (entry is hidden).

Perhaps something like this?

/* Type 1 requires FNZ mode, if set to AUTO, the time
 * will change, but the mode will be changed as well
 */

>> +                     time |= SCI_KBD_MODE_FNZ;
>> +             } else if (toshiba->kbd_type == 2) {
>> +                     /* Type 2 requires the actual mode */
>
> actual... as in the mode you are changing to or the mode you are changing from?

We're not changing modes here, just time. Perhaps that comment
is misleading, I can probaly change it to:

/* Type 2 requires SCI_KBD_MODE_AUTO */

Or leave it blank, or perhaps be more verbose:

/* Type 2 requires SCI_KBD_MODE_AUTO, if set to another
 * mode, the time will change but the mode will change as well
 */

>
> From the previous keyboard backlight type patch:
>
> toshiba_acpi: Support new keyboard backlight type
>
> There are several keyboard modes, why do we have only 2 of them here?

Because the timeout entry only takes place (and appears)
whenever the keyboard mode is set to AUTO, on any other
mode is hidden.

> Is it because by setting the timeout we are always changing to _AUTO?

Yes and no.
If the timeout entry exists, that means we are in AUTO, however,
the timeout can be changed even if we are on another mode (without
changing modes).

> Even if that's
> the case, shouldn't one of these be OR'ing in the current mode - whatever it is,
> instead of a fixed one?

Yes, you can do that, and it will change the time successfuly,
but again, this entry only appears whenever in AUTO mode,
so we only have one mode to deal here with.

>
>> +                     time |= SCI_KBD_MODE_AUTO;
>> +             }
>> +
>> +             ret = toshiba_kbd_illum_status_set(toshiba, time);
>> +             if (ret)
>> +                     return ret;
>> +
>
> So here you are changing the sysfs API as you can now return -ENODEV in addition
> to -EIO. We *can* do this, but it is a risk, and if a regression is reported, I
> will be forced to revert this patch.

I was just propagating the error code from toshiba_kbd_illum_status_set,
as it was already done on toshiba_kbd_bl_mode_store, but I can leave
this part intact if that's a concern, even tho' the kbd_mode file was recently
introduced.

>
> --
> Darren Hart
> Intel Open Source Technology Center


Cheers
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
