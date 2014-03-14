Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaCNCPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:15:12 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:37843 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaCNCPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:15:10 -0400
MIME-Version: 1.0
In-Reply-To: <11925125.x6prlrSt00@vostro.rjw.lan>
References: <1394653598-17143-1-git-send-email-kandoiruchi@google.com>
	<1559784.2mnpODc5zV@vostro.rjw.lan>
	<CAL8qYTMKM-DrkxED-51YPRczWJpeEfZy25PORtUasi=7e58i6Q@mail.gmail.com>
	<11925125.x6prlrSt00@vostro.rjw.lan>
Date: Thu, 13 Mar 2014 19:15:09 -0700
Message-ID: <CAL8qYTNGxhzH=-pLC8OC3-e25a15vEvorBQFXxcW8zS8H+wToQ@mail.gmail.com>
Subject: Re: [PATCH v3] power: add an API to log wakeup reasons
From: Ruchi Kandoi <kandoiruchi@google.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Greg Hackmann <ghackmann@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Todd Poynor <toddpoynor@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

True, we could create new wakeup sources specifically to
track this information, perhaps as needed once an IRQ is first
observed to trigger a wakeup.

We would want to know which wakeup sources were responsible for the
most recent wakeup, since we keep a timeline of suspend/resume events
with wakeup reasons and durations.  It may require some extra work to
keep track of this information.

Apart from Google, other vendors like Qualcomm and Nvidia have already
introduced similar kinds of logging in their respective interrupt
controller drivers. We would really like to make this a standardized
logging for debugging purposes.



On Thu, Mar 13, 2014 at 6:06 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, March 13, 2014 05:43:20 PM Ruchi Kandoi wrote:
>> This should be true most of the times.
>>
>> But there might be cases otherwise too.
>>
>> For instance, there was a bug earlier with wi-fi which would cause the
>> system to wake up but not get hold of a wakeup source because there
>> wasn't any work for it to do. In that case, the wakeup sources would
>> not log such an event.
>>
>> Additionally, there could be a situation where an IRQ caused the
>> system to resume from suspend. And since the system was up, a driver
>> could take a wakeup source. In this case we would assume that the
>> driver would have woken the system, but in reality the driver held the
>> wakeup source only because the system was up and did not cause the
>> wake up to happen.
>
> But you can create special wakeup sources associated with interrupts (in
> addition to the existing ones) and use the statistics for those.
>
> It is possible to define wakeup sources that don't correspond to any
> devices.
>
> Rafael
>
>
>> On Thu, Mar 13, 2014 at 3:18 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > Hi,
>> >
>> > I saw the v4, but I don't have it handy, so replying here.
>> >
>> > On Wednesday, March 12, 2014 12:46:38 PM Ruchi Kandoi wrote:
>> >> For power management diagnostic purposes, it is often useful to know
>> >> what interrupts are frequently waking the system from low power
>> >> suspend mode, especially on battery-powered consumer electronics
>> >> devices that are expected to spend much of their time in low-power
>> >> suspend while not in active use.  For example, reduced battery life on
>> >> a mobile phone may be caused in part by frequent wakeups by broadcast
>> >> traffic on a busy wireless LAN even while the screen is off and the
>> >> phone not in active use.
>> >>
>> >> Add API log_wakeup_reason() exposes it to userspace via the sysfs path
>> >> /sys/kernel/wakeup_reasons/last_resume_reason. This API would be called
>> >> from the paltform specific, or from the driver for the interrupt controller,
>> >> when the system resumes because of an IRQ. It logs the reasons which caused
>> >> the system to wakeup from the low-power mode.
>> >
>> > So what exactly is wrong with using wakeup sources for this purpose?
>> >
>> > --
>> > I speak only for myself.
>> > Rafael J. Wysocki, Intel Open Source Technology Center.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
