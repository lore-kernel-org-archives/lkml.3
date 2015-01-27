Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666AbbA0Jyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 04:54:39 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:65000 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbA0Jyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 04:54:36 -0500
MIME-Version: 1.0
In-Reply-To: <20150127025255.GA118747@vmdeb7>
References: <1418332715-10547-1-git-send-email-julijonas.kikutis@gmail.com>
	<20150127025255.GA118747@vmdeb7>
Date: Tue, 27 Jan 2015 09:54:35 +0000
Message-ID: <CAHR064iMG-Oy_Fe0tpmxaPLrQE+w1VU6xD2zHOtdM6cKsZwPhQ@mail.gmail.com>
Subject: Re: [PATCH] samsung-laptop: enable better lid handling
From: Corentin Chary <corentin.chary@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Julijonas Kikutis <julijonas.kikutis@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 2:52 AM, Darren Hart <dvhart@infradead.org> wrote:
> On Thu, Dec 11, 2014 at 09:18:35PM +0000, Julijonas Kikutis wrote:
>
> Hi Julijonas,
>
> Please Cc the maintainer listed in the MAINTERS file for a faster response.

The easiest to do that is to use " git send-email
--cc-cmd=scripts/get_maintainer.pl"

He did cc me though, I just don't have enough time to monitor this
mailing list currently, sorry for that.

>> Some Samsung laptops with SABI3 delay the sleep for 10 seconds after
>> the lid is closed and do not wake up from sleep after the lid is opened.
>> A SABI command is needed to enable the better behavior.
>>
>> Command = 0x6e, d0 = 0x81 enables this behavior. Returns d0 = 0x01.
>> Command = 0x6e, d0 = 0x80 disables this behavior. Returns d0 = 0x00.
>>
>> Command = 0x6d and any d0 queries the state. This returns:
>> d0 = 0x00000*01, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is enabled.
>> d0 = 0x00000*00, d1 = 0x00, d2 = 0x00, d3 = 0x0* when it is disabled.
>> Where * is 0 - laptop has never slept or hibernated after switch on,
>>            1 - laptop has hibernated just before,
>>            2 - laptop has slept just before.
>>
>> Patch addresses bug https://bugzilla.kernel.org/show_bug.cgi?id=75901.
>> It adds a sysfs attribute lid_handling with description and also an
>> addition to the quirks structure to enable the mode by default.
>>
>> However, a user with another laptop in the bug report says that "power
>> button has to be pressed twice to wake the machine" in this mode.
>
> This is with this patch applied?
>
>> Therefore, it is enabled by default only for the single laptop that I
>> have tested.
>>
>> This mode is also needed in UEFI, but there samsung-laptop is
>> unfortunately disabled.
>
> I don't follow. What are you saying here?

samsung-laptop doesn't current load when the laptop boots in UEFI mode
becaue this used to brick the laptop.
I don't think this is the case anymore with new laptops, unfortunately
I don't own any of these.

> This looks pretty much ready. The only comments I have are argued against by
> staying consistent with the existing driver. So just the above questions and one
> comment below. Please clarify, update, and resend. Be sure to add me to Cc this
> time :-)
>
>>
>> Signed-off-by: Julijonas Kikutis <julijonas.kikutis@gmail.com>
>> ---
>
> ...
>
>> @@ -1111,7 +1208,7 @@ static int __init samsung_backlight_init(struct samsung_laptop *samsung)
>>  }
>>
>>  static umode_t samsung_sysfs_is_visible(struct kobject *kobj,
>> -                                    struct attribute *attr, int idx)
>> +                                     struct attribute *attr, int idx)
>>  {
>>       struct device *dev = container_of(kobj, struct device, kobj);
>>       struct platform_device *pdev = to_platform_device(dev);
>> @@ -1124,6 +1221,8 @@ static umode_t samsung_sysfs_is_visible(struct kobject *kobj,
>>               ok = !!(read_battery_life_extender(samsung) >= 0);
>>       if (attr == &dev_attr_usb_charge.attr)
>>               ok = !!(read_usb_charge(samsung) >= 0);
>> +     if (attr == &dev_attr_lid_handling.attr)
>> +             ok = !!(read_lid_handling(samsung) >= 0);
>>
>>       return ok ? attr->mode : 0;
>>  }
>> @@ -1436,6 +1535,10 @@ static int samsung_pm_notification(struct notifier_block *nb,
>>           samsung->quirks->enable_kbd_backlight)
>>               kbd_backlight_enable(samsung);
>>
>> +     if (val == PM_POST_HIBERNATION &&
>> +         samsung->quirks->lid_handling)
>
> This can be one line.
>
>
> --
> Darren Hart
> Intel Open Source Technology Center



-- 
Corentin Chary
http://xf.iksaif.net
