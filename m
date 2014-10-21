Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaJUTX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:23:26 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56973 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaJUTXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:23:25 -0400
Message-ID: <5446B2AA.9060106@amacapital.net>
Date: Tue, 21 Oct 2014 12:23:22 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>, John Stultz <john.stultz@linaro.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: A desktop environment[1] kernel wishlist
References: <1413881397.30379.7.camel@hadess.net>	 <CANcMJZA=7FNNCrMpz-mC4FaJMKi8hEhqGtO_bv7iJdWVC_GpWA@mail.gmail.com>	 <1413911644.30379.12.camel@hadess.net>	 <CALAqxLURBHdrprCZzUiXdO6M7sjbwawxyDQpoG1-HWRGBvaMjg@mail.gmail.com> <1413914978.30379.14.camel@hadess.net>
In-Reply-To: <1413914978.30379.14.camel@hadess.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 11:09 AM, Bastien Nocera wrote:
> On Tue, 2014-10-21 at 11:00 -0700, John Stultz wrote:
>> On Tue, Oct 21, 2014 at 10:14 AM, Bastien Nocera <hadess@hadess.net> wrote:
>>> Hey,
>>>
>>> On Tue, 2014-10-21 at 10:04 -0700, John Stultz wrote:
>>>> On Tue, Oct 21, 2014 at 1:49 AM, Bastien Nocera <hadess@hadess.net> wrote:
>>>>> Hey,
>>>>>
>>>>> GNOME has had discussions with kernel developers in the past, and,
>>>>> fortunately, in some cases we were able to make headway.
>>>>>
>>>>> There are however a number of items that we still don't have solutions
>>>>> for, items that kernel developers might not realise we'd like to rely
>>>>> on, or don't know that we'd make use of if merged.
>>>>>
>>>>> I've posted this list at:
>>>>> https://wiki.gnome.org/BastienNocera/KernelWishlist
>>>>>
>>>>> Let me know on-list or off-list if you have any comments about those, so
>>>>> I can update the list.
>>>>
>>>> As for: 'Export of "wake reason" when the system wakes up (rtc alarm,
>>>> lid open, etc.) and wakealarm (/sys/class/rtc/foo/wakealarm)
>>>> documentation'
>>>>
>>>> Can you expand more on the rational for the need here? Is this for UI
>>>> for power debugging, or something else?
>>>
>>> No, it would be used for automating backups, or implementing
>>> suspend->hibernation transitions. For example, right before the machine
>>> suspends, I would schedule it to wake up in a hour. If I get woken up by
>>> the rtc alarm (and not by the user through a lid open), I might:
>>> - check that I'm plugged into the AC, it's night, and in the vicinity of
>>> the server that handles my backups and so backup the system.
>>> - check whether the battery is low, and hibernate the machine (if it
>>> supports it, obviously).
>>>
>>> We cannot do that if we can't make out whether the wake-up came from a
>>> user action, or the alarm we set.
>>
>> I suspect wakeup type reporting is maybe not the best way to go about
>> this, since there may be a number of causes for wakeups and they can
>> arrive closely together in different orders, which can result in
>> races.
>>
>> For instance, if the machine suspends, and sets an alarm to be woken
>> up at midnight to do a backup, if the user resumes their laptop at
>> 11:59:59, should the backup still proceed at midnight?
> 
> No. And I would expect that we would get a wake up type of "power
> button" or "lid open" in this case.
> 
>>   What happens
>> if the user starts to use their machine at 12:00:01?
> 
> I would expect the backup to stop and be tried again later.
> 
>>   What about if
>> the user walked away from their machine at 11:55:01, and the system
>> would suspend at 12:00:01, should the backup commence at 12:00:00?
> 
> That wouldn't happen because we'd set the wake up time when suspending.
> 
>> Thus you probably want to have a "user present" status,
> 
> We can do any sort of thing once the laptop is awake. But right now
> there's no way to know whether the resume is due to a user action or
> not.

Let me try saying what I think John is saying a little differently:

I think it shouldn't really matter what caused the wakeup.  I think it
should matter what the state of the laptop is post-wakeup.

For example, suppose that the user opens the lid at effectively the same
time as an alarm fires.  By the time userspace code can run, the alarm
has fired *and* the lid is open.

Shouldn't the user code just check whether the alarm has fired and
whether the lid is open?

Admittedly, this gets a bit hairy for things like wake buttons (which my
laptop has two of), but I still think it's more important whether the
button was pressed recently, not whether the button press actually
caused the wakeup.

(With S0ix and similar technologies, I imagine that determining what
caused a "wakeup" could be extremely confusing.)

--Andy
