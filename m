Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaJIAYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 20:24:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63797 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaJIAYe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 20:24:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141008214045.GF15198@dtor-ws>
References: <1412704473-6708-1-git-send-email-killertofu@gmail.com>
	<1412792742-4075-1-git-send-email-killertofu@gmail.com>
	<20141008214045.GF15198@dtor-ws>
Date: Wed, 8 Oct 2014 17:24:32 -0700
Message-ID: <CANRwn3TFS-jLwgjwautrofmuJ07PASBXMbTWocj3WQxQX3D6tg@mail.gmail.com>
Subject: Re: [PATCH v2] HID: wacom: Prevent potential null dereference after disconnect
From: Jason Gerecke <killertofu@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 2:40 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Oct 08, 2014 at 11:25:42AM -0700, Jason Gerecke wrote:
>> Repeated connect/disconnect cycles under GNOME can trigger an occasional
>> OOPS from within e.g. wacom_led_select_store, presumably due to a timing
>> issue where userspace begins setting a value immediately before the
>> device disconnects and our shared data is whisked away.
>>
>> Signed-off-by: Jason Gerecke <killertofu@gmail.com>
>> ---
>> Changes in v2:
>>  * Added in missing escape character
>>
>>  drivers/hid/wacom_sys.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
>> index 8593047..265429b 100644
>> --- a/drivers/hid/wacom_sys.c
>> +++ b/drivers/hid/wacom_sys.c
>> @@ -641,6 +641,9 @@ static ssize_t wacom_led_select_store(struct device *dev, int set_id,
>>       unsigned int id;
>>       int err;
>>
>> +     if (!wacom)
>> +             return -ENODEV;
>> +
>
> Strong NAK. If device could disappear before this check it could as well
> disappear after your check.
>
> This patch does not solve anything.
>

I assume I'll want to either disable interrupts or take a lock
depending on if `wacom_remove` is called from within the interrupt
context, but I haven't had to deal with concurrency in the kernel
before so I'm not entirely sure which option (or which primitive if
locking) would be appropriate...

Jason
---
Now instead of four in the eights place /
you’ve got three, ‘Cause you added one  /
(That is to say, eight) to the two,     /
But you can’t take seven from three,    /
So you look at the sixty-fours....

>>       err = kstrtouint(buf, 10, &id);
>>       if (err)
>>               return err;
>
> Thanks.
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
