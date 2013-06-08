Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3FHIXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:23:32 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48747 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3FHIX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:23:28 -0400
Message-ID: <51B2E9EC.1000205@ahsoftware.de>
Date: Sat, 08 Jun 2013 10:23:08 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: rtc-linux@googlegroups.com
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rtc-linux] Re: adjusting the monotonic system time (from inside
 the kernel)
References: <5187B813.8000907@ahsoftware.de> <51B27182.8010506@linaro.org>
In-Reply-To: <51B27182.8010506@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.06.2013 01:49, schrieb John Stultz:
> On 05/06/2013 07:02 AM, Alexander Holler wrote:
>> Hello,
>>
>> I'm looking at how to adjust the (monotonic) system time from inside
>> the kernel.
>>
>> Use case is that I have a hw-clock which (not necessarily) regulary
>> sends a timestamp with millisecond precision which I want to use to
>> adjust the system time.
>>
>> It seems the usual solution to do such, is to use NTP which uses it's
>> own driver (which usually seems to be based on some serial connection):
>>
>> hw-clock --serial--> kernel --serial-device--> ntpd -> kernel ->
>> system-time
>>
>> So one solution would be to emulate such a serial device:
>>
>> hw-clock --> kernel --emulated-serial-device--> ntpd -> kernel ->
>> system-time
>>
>> Another solution would be to "invent" a ntp-device and write a driver
>> for ntpd to use it:
>>
>> hw-clock --> kernel --ntp-device--> ntpd -> kernel -> system-time
>>
>> But I would prefer the following:
>>
>> hw-clock --> kernel -> system-time
>>
>> Problem is that the hw-clock in question doesn't offer something like
>> a tick. It just might send a timestamp with millisecond precision
>> whenever it wants.
>>
>> Because I don't want to reinvent the wheel and because I think there
>> are some people which already have spend some thoughts on similiar
>> things, I'm asking here before I try to implement something which then
>> never might find it's way into the mainline kernel.
>>
>> Any hints, suggestions, whatever?
>
> Sorry on the delay to reply here, just noticed this in my spam folder
> (hopefully I've trained it not to catch your mails now).
>
> You probably want to check out do_adjtimex() in the kernel. It has a
> number of ways that allow for the clock to be slewed or jumped.
> Otherwise you probably should look into the PPS subsystems to see if it
> could be extended to support your needs.

Thanks, I've already digged around in the source for adjtimex to get a 
clue about the ntp-api and how it works. At first view wasn't that 
enlightened. ;)

But that now has to wait. If the new hctosys mechanism ends up in the 
kernel, the millisecond support for rtc-hid-sensor-time will disappear 
because rtc-hid-sensor-time will not set the time itself afterwards.

So I have to figure out and implement a new way to feed a timestamp with 
milliseconds to hctosys.

My first idea would be to add a read_timeval() or even read_timespec() 
to rtc_class_ops which would be used by hctosys instead of read_time() 
if it exists.

Regards,

Alexander
