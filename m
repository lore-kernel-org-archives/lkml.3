Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3CaKII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 06:08:08 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39646 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3CaKIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 06:08:06 -0400
Message-ID: <51580AFD.4000809@intel.com>
Date: Sun, 31 Mar 2013 18:07:57 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Artem Savkov <artem.savkov@gmail.com>
CC: Danny Baumann <dannybaumann@web.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi/video: lcd_get_level_current doen't return current
 level
References: <1364648501-5127-1-git-send-email-artem.savkov@gmail.com> <3fb82299-bdb9-4842-bd55-f3b87d2d789e@email.android.com> <20130331064619.GA11544@thinkpad.lan> <800799d9-f1ea-48ab-b565-4bd3ca230300@email.android.com> <20130331081600.GA4549@thinkpad.lan>
In-Reply-To: <20130331081600.GA4549@thinkpad.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 04:16 PM, Artem Savkov wrote:
> On Sun, Mar 31, 2013 at 09:04:21AM +0200, Danny Baumann wrote:
>> Hi,
>>
>> Artem Savkov <artem.savkov@gmail.com> schrieb:
>>
>>> On Sun, Mar 31, 2013 at 08:15:14AM +0200, Danny Baumann wrote:
>>>> Artem Savkov <artem.savkov@gmail.com> schrieb:
>>>>> acpi_video_device_lcd_get_level_current() called
>>>>> acpi_video_bqc_value_to_level()
>>>>> with "*level" as a second argument, resulting in level being
>>> returned
>>>>> based on
>>>>> initial input, not current brightness, breaking backlight controls.
>>>> I don't think this change is correct. As level was passed as
>>> parameter into the evaluation of _BQC, *level contains the AML returned
>>> brightness level afterwards, so it's correct to use it as an input to
>>> acpi_video_bqc_value_to_level(). Actually, the whole point of
>>> acpi_video_device_lcd_get_level_current() is to update
>>> device->brightness->curr, so it doesn't make sense to me to use it in
>>> that function.
>>>>
>>>> What's the exact problem this patch tries to solve?
>>>
>>> I'm running a -next kernel on my laptop and couple of days ago keyboard
>>> backlight controls stopped working: only 2 lower brightness levels.
>>> I've
>>> debugged it a bit and found out that acpi_video_switch_brightness()
>>> calls
>>> acpi_video_device_lcd_get_level_current() with level uninitialized and
>>> always gets lowest posible value.
>>
>> The point is: after the acpi_evaluate_object call, *level must contain the current brightness level, otherwise your BIOS is broken (this happens: e.g. my laptop always returns 100 from _BQC in Windows 8 mode). You can verify this easily by initializing level_current to some invalid value and checking it again after the call to _get_level_current. I'd be pretty surprised if the value didn't change. Also, if you look at [1], you'll see that the code operated on *level before as well.
>> This problem may have been obscured by the fact that the brightness device wasn't initialized properly before my patches went in. Does acpi_video_switch_brightness actually do anything for you when reverting the 3 newest commits of video.c?
>
> Yes, you are right. Both my patch and the version before your patches
> result in initial acpi_video_device_lcd_get_level_current call ending
> with invalid level being returned and bqc disabled, so they both just
> use *level = brightness->curr after that.
>

OK, this suggests the _BQC control method of your system is broken.
Please kindly file a bug in bugzilla.kernel.org, against
ACPI/Power-Video and attach the output of acpidump and dmidecode there,
I want to take a look, thanks.

-Aaron
