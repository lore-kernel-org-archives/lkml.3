Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968047Ab3HIQWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:22:43 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56660 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397Ab3HIQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:22:42 -0400
Message-ID: <5205170E.9030605@ahsoftware.de>
Date: Fri, 09 Aug 2013 18:21:34 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [rtc-linux] Re: [PATCH 2/2 RESEND] rtc: rtc-hid-sensor-time:
 enable HID input processing early
References: <1375382342-25454-1-git-send-email-holler@ahsoftware.de> <1375382342-25454-2-git-send-email-holler@ahsoftware.de> <20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org> <5204BA2E.8000100@ahsoftware.de> <alpine.LNX.2.00.1308091310490.13089@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1308091310490.13089@pobox.suse.cz>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.08.2013 13:12, schrieb Jiri Kosina:
> On Fri, 9 Aug 2013, Alexander Holler wrote:
>
>
>> =================================
>> [ INFO: inconsistent lock state ]
>> 3.10.5-dockstar-00038-g03242d1-dirty #408 Not tainted
>> ---------------------------------
>> inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>> swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>>   (&(&sd->dyn_callback_lock)->rlock){?.+...}, at: [<c02af9f8>]
>> sensor_hub_raw_event+0x10c/0x204
>> {HARDIRQ-ON-W} state was registered at:
>
> I think you need the patch below. Please let me know if it fixes it.

Thanks a lot. That actually fixed the bug I never have seen before and 
the patch might be a candidate for the stable series (even if almost no 
one would see the problem because there don't seem to be many 
hid-sensor-hub users and the bug seems only to be visible with some 
debug options enabled).

Btw, I've lied and that bug happened with the enforced error path as 
well as during normal operation. It seems I have enabled some debug 
option in the kernel, I never had enabled before.

Unfortunaly that doesn't answer Andrew Mortons questions.

I've now also verified if hid-sensor-hub receives an event with 
sensor_hub_raw_event() in the error-path (hid_device_io_stop() called 
and probe() failed), and this still *does* happen. That event (input 
report) doesn't come through hid-sensor-hub to my driver, but I think 
this is because of my call to sensor_hub_remove_callback() which is in 
the error path too.
So I actually wonder why the input report still is reported from the 
hid-subsystem to hid-sensor-hub, even after I've called 
hid_device_io_stop() and probe() failed.
Maybe everything is still ok and I just got confused with the somehow 
complicate interactions between the usb- and hid-subsystem, 
hid-sensor-hub (which uses MFD) and rtc-hid-sensor-time.

I will also have a look if I find the seem to be missing down(), maybe 
that will offer some explanations to what goes on. Unfortunately I still 
don't know the complete path of events, I've stopped reading the source 
after you've told me about the patch from Andrew de los Reyes, beeing 
happy to have found a nice and proper solution (instead of the delayed 
rtc-device registering I did before). ;)

Regards,

Alexander Holler
