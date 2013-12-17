Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493Ab3LQFPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:15:24 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56729 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQFPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:15:22 -0500
Message-ID: <52AFDDE6.2020600@linaro.org>
Date: Mon, 16 Dec 2013 21:15:18 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/5] timekeeping: Avoid possible deadlock from clock_was_set_delayed
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org> <1386789098-17391-4-git-send-email-john.stultz@linaro.org> <52A9E5B2.8040702@oracle.com> <52AA014B.6000301@oracle.com> <52AA0798.1050709@linaro.org> <52AA08EB.1080703@oracle.com> <52AA0AD2.5030307@linaro.org>
In-Reply-To: <52AA0AD2.5030307@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 11:13 AM, John Stultz wrote:
> On 12/12/2013 11:05 AM, Sasha Levin wrote:
>> On 12/12/2013 01:59 PM, John Stultz wrote:
>>> On 12/12/2013 10:32 AM, Sasha Levin wrote:
>>>> On 12/12/2013 11:34 AM, Sasha Levin wrote:
>>>>> On 12/11/2013 02:11 PM, John Stultz wrote:
>>>>>> As part of normal operaions, the hrtimer subsystem frequently calls
>>>>>> into the timekeeping code, creating a locking order of
>>>>>>     hrtimer locks -> timekeeping locks
>>>>>>
>>>>>> clock_was_set_delayed() was suppoed to allow us to avoid deadlocks
>>>>>> between the timekeeping the hrtimer subsystem, so that we could
>>>>>> notify the hrtimer subsytem the time had changed while holding
>>>>>> the timekeeping locks. This was done by scheduling delayed work
>>>>>> that would run later once we were out of the timekeeing code.
>>>>>>
>>>>>> But unfortunately the lock chains are complex enoguh that in
>>>>>> scheduling delayed work, we end up eventually trying to grab
>>>>>> an hrtimer lock.
>>>>>>
>>>>>> Sasha Levin noticed this in testing when the new seqlock lockdep
>>>>>> enablement triggered the following (somewhat abrieviated) message:
>>>>> [snip]
>>>>>
>>>>> This seems to work for me, I don't see the lockdep spew anymore.
>>>>>
>>>>>       Tested-by: Sasha Levin <sasha.levin@oracle.com>
>>>> I think I spoke too soon.
>>>>
>>>> It took way more time to reproduce than previously, but I got:
>>>>
>>>>
>>>> -> #1 (&(&pool->lock)->rlock){-.-...}:
>>>> [ 1195.578519]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
>>>> [ 1195.578519]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
>>>> [ 1195.578519]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
>>>> [ 1195.578519]        [<ffffffff843b0760>] _raw_spin_lock+0x40/0x80
>>>> [ 1195.578519]        [<ffffffff81153e0e>] __queue_work+0x14e/0x3f0
>>>> [ 1195.578519]        [<ffffffff81154168>] queue_work_on+0x98/0x120
>>>> [ 1195.578519]        [<ffffffff81161351>]
>>>> clock_was_set_delayed+0x21/0x30
>>>> [ 1195.578519]        [<ffffffff811c4b41>] do_adjtimex+0x111/0x160
>>>> [ 1195.578519]        [<ffffffff811360e3>] SYSC_adjtimex+0x43/0x80
>>>> [ 1195.578519]        [<ffffffff8113612e>] SyS_adjtimex+0xe/0x10
>>>> [ 1195.578519]        [<ffffffff843baed0>] tracesys+0xdd/0xe2
>>>> [ 1195.578519]
>>> Are you sure you have that patch applied?
>>>
>>> With it we shouldn't be calling clock_was_set_delayed() from
>>> do_adjtimex().
>> Hm, It seems that there's a conflict there that wasn't resolved
>> properly. Does this patch
>> depend on anything else that's not currently in -next?
> Oh yes, sorry, I didn't cc you on the entire patch set. Apologies!
>
> You'll probably want to grab the two previous patches:
> https://lkml.org/lkml/2013/12/11/479
> https://lkml.org/lkml/2013/12/11/758

Just wanted to follow up here. Did you happen to get a chance to try to
reproduce w/ the three patch patchset?

I'm hoping to submit them to Ingo tomorrow, and want to make sure I've
got your tested-by.

thanks
-john

