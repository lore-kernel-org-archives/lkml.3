Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab3LLS7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:59:44 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36873 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3LLS7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:59:41 -0500
Message-ID: <52AA0798.1050709@linaro.org>
Date: Thu, 12 Dec 2013 10:59:36 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/5] timekeeping: Avoid possible deadlock from clock_was_set_delayed
References: <1386789098-17391-1-git-send-email-john.stultz@linaro.org> <1386789098-17391-4-git-send-email-john.stultz@linaro.org> <52A9E5B2.8040702@oracle.com> <52AA014B.6000301@oracle.com>
In-Reply-To: <52AA014B.6000301@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 10:32 AM, Sasha Levin wrote:
> On 12/12/2013 11:34 AM, Sasha Levin wrote:
>> On 12/11/2013 02:11 PM, John Stultz wrote:
>>> As part of normal operaions, the hrtimer subsystem frequently calls
>>> into the timekeeping code, creating a locking order of
>>>    hrtimer locks -> timekeeping locks
>>>
>>> clock_was_set_delayed() was suppoed to allow us to avoid deadlocks
>>> between the timekeeping the hrtimer subsystem, so that we could
>>> notify the hrtimer subsytem the time had changed while holding
>>> the timekeeping locks. This was done by scheduling delayed work
>>> that would run later once we were out of the timekeeing code.
>>>
>>> But unfortunately the lock chains are complex enoguh that in
>>> scheduling delayed work, we end up eventually trying to grab
>>> an hrtimer lock.
>>>
>>> Sasha Levin noticed this in testing when the new seqlock lockdep
>>> enablement triggered the following (somewhat abrieviated) message:
>>
>> [snip]
>>
>> This seems to work for me, I don't see the lockdep spew anymore.
>>
>>      Tested-by: Sasha Levin <sasha.levin@oracle.com>
>
> I think I spoke too soon.
>
> It took way more time to reproduce than previously, but I got:
>
>
> -> #1 (&(&pool->lock)->rlock){-.-...}:
> [ 1195.578519]        [<ffffffff81194803>] validate_chain+0x6c3/0x7b0
> [ 1195.578519]        [<ffffffff81194d9d>] __lock_acquire+0x4ad/0x580
> [ 1195.578519]        [<ffffffff81194ff2>] lock_acquire+0x182/0x1d0
> [ 1195.578519]        [<ffffffff843b0760>] _raw_spin_lock+0x40/0x80
> [ 1195.578519]        [<ffffffff81153e0e>] __queue_work+0x14e/0x3f0
> [ 1195.578519]        [<ffffffff81154168>] queue_work_on+0x98/0x120
> [ 1195.578519]        [<ffffffff81161351>]
> clock_was_set_delayed+0x21/0x30
> [ 1195.578519]        [<ffffffff811c4b41>] do_adjtimex+0x111/0x160
> [ 1195.578519]        [<ffffffff811360e3>] SYSC_adjtimex+0x43/0x80
> [ 1195.578519]        [<ffffffff8113612e>] SyS_adjtimex+0xe/0x10
> [ 1195.578519]        [<ffffffff843baed0>] tracesys+0xdd/0xe2
> [ 1195.578519]

Are you sure you have that patch applied?

With it we shouldn't be calling clock_was_set_delayed() from do_adjtimex().

thanks
-john




