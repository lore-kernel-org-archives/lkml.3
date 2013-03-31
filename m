Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3CaHEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 03:04:30 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39691 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3CaHE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 03:04:29 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130331064619.GA11544@thinkpad.lan>
References: <1364648501-5127-1-git-send-email-artem.savkov@gmail.com> <3fb82299-bdb9-4842-bd55-f3b87d2d789e@email.android.com> <20130331064619.GA11544@thinkpad.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] acpi/video: lcd_get_level_current doen't return current level
From: Danny Baumann <dannybaumann@web.de>
Date: Sun, 31 Mar 2013 09:04:21 +0200
To: Artem Savkov <artem.savkov@gmail.com>
CC: aaron.lu@intel.com, rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <800799d9-f1ea-48ab-b565-4bd3ca230300@email.android.com>
X-purgate: clean.bounce
X-purgate-type: clean.bounce
X-purgate-ID: 154106::1364713465-000004D6-6A36A9D6/0-0/0-18
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-03-31 09:04:25;2958ea57577a420ac546739ef491fec7
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-03-31 09:04:25;749093f1233530b1ada4728f3773976c
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail provider
 *      (dannybaumann[at]web.de)
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Artem Savkov <artem.savkov@gmail.com> schrieb:

>On Sun, Mar 31, 2013 at 08:15:14AM +0200, Danny Baumann wrote:
>> Artem Savkov <artem.savkov@gmail.com> schrieb:
>> >acpi_video_device_lcd_get_level_current() called
>> >acpi_video_bqc_value_to_level()
>> >with "*level" as a second argument, resulting in level being
>returned
>> >based on
>> >initial input, not current brightness, breaking backlight controls.
>> I don't think this change is correct. As level was passed as
>parameter into the evaluation of _BQC, *level contains the AML returned
>brightness level afterwards, so it's correct to use it as an input to
>acpi_video_bqc_value_to_level(). Actually, the whole point of
>acpi_video_device_lcd_get_level_current() is to update
>device->brightness->curr, so it doesn't make sense to me to use it in
>that function.
>> 
>> What's the exact problem this patch tries to solve?
>
>I'm running a -next kernel on my laptop and couple of days ago keyboard
>backlight controls stopped working: only 2 lower brightness levels.
>I've
>debugged it a bit and found out that acpi_video_switch_brightness()
>calls
>acpi_video_device_lcd_get_level_current() with level uninitialized and
>always gets lowest posible value.

The point is: after the acpi_evaluate_object call, *level must contain the current brightness level, otherwise your BIOS is broken (this happens: e.g. my laptop always returns 100 from _BQC in Windows 8 mode). You can verify this easily by initializing level_current to some invalid value and checking it again after the call to _get_level_current. I'd be pretty surprised if the value didn't change. Also, if you look at [1], you'll see that the code operated on *level before as well.
This problem may have been obscured by the fact that the brightness device wasn't initialized properly before my patches went in. Does acpi_video_switch_brightness actually do anything for you when reverting the 3 newest commits of video.c?

Regards,

Danny

[1] https://git.kernel.org/cgit/linux/kernel/git/rafael/linux-pm.git/commit/drivers/acpi/video.c?h=linux-next&id=994fa63c5b126df6e9f31ef4e09000e2e243234b

