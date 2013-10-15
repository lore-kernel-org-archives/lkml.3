Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3JOSXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 14:23:46 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:36186 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3JOSXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 14:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131012074848.GA25366@feng-snb>
References: <1368815045-21209-1-git-send-email-zoran.markovic@linaro.org>
	<20131012074848.GA25366@feng-snb>
Date: Tue, 15 Oct 2013 11:23:44 -0700
Message-ID: <CAME+o4nk7M8XxBgMzv6U_nOh=AU0OgypJZnd1nCH_H+8kmTzqA@mail.gmail.com>
Subject: Re: [RFC PATCH] timekeeping: Correct run-time detection of real-time clock.
From: Zoran Markovic <zoran.markovic@linaro.org>
To: Feng Tang <feng.tang@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,
Looking at the OMAP implementation, persistent_clock is updated on
every read of the 32K counter. If the read doesn't happen often enough
to accurately update persistent_clock, then the 32K counter would fail
the definition of a persistent clock and some other timekeeping source
should be used.

Regards, Zoran

On 12 October 2013 00:48, Feng Tang <feng.tang@intel.com> wrote:
> Hi Zoran,
>
> Thanks for the patch! (This reply may be toooo late :))
>
> One question just for curiosity: for the counter_32K timer, it's running
> at 32K Hz and has one 32b counter. I understand it is only for suspend
> time calculation use, but the wrap time for it is about
>         4G/32K ~= 128K seconds ~= 35 hours
> What if one suspend time is longer than that?
>
> - Feng
>
> On Fri, May 17, 2013 at 11:24:05AM -0700, Zoran Markovic wrote:
>> Since commit <31ade30692dc9680bfc95700d794818fa3f754ac>, timekeeping_init()
>> checks for presence of persistent clock by attempting to read a non-zero
>> time value from real-time clock. This is an issue on platforms where
>> persistent_clock (instead of a RTC) is implemented as a free-running counter
>> starting from zero on each boot and running during suspend. Examples are some
>> ARM platforms (e.g. PandaBoard). An attempt to read such a clock during
>> timekeeping_init() may return zero value and falsely declare persistent clock
>> as missing. Additionally, in the above case suspend times may be accounted
>> twice (once from timekeeping_resume() and once from rtc_resume()), resulting
>> in a gradual drift of system time.
>>
>> This patch does a run-time correction of the issue by doing the same check
>> during timekeeping_suspend().
>>
>> A better long-term solution would have to return error when trying to read
>> non-existing clock and zero when trying to read an uninitialized clock, but
>> that would require changing all persistent_clock implementations.
>>
>> This patch addresses the immediate breakage, for now.
>>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Feng Tang <feng.tang@intel.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
>> ---
>>  kernel/time/timekeeping.c |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index 98cd470..baeeb5c 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -975,6 +975,14 @@ static int timekeeping_suspend(void)
>>
>>       read_persistent_clock(&timekeeping_suspend_time);
>>
>> +     /*
>> +      * On some systems the persistent_clock can not be detected at
>> +      * timekeeping_init by its return value, so if we see a valid
>> +      * value returned, update the persistent_clock_exists flag.
>> +      */
>> +     if (timekeeping_suspend_time.tv_sec || timekeeping_suspend_time.tv_nsec)
>> +             persistent_clock_exist = true;
>> +
>>       raw_spin_lock_irqsave(&timekeeper_lock, flags);
>>       write_seqcount_begin(&timekeeper_seq);
>>       timekeeping_forward_now(tk);
>> --
>> 1.7.9.5
