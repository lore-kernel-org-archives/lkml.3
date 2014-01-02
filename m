Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaABUmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:42:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56640 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaABUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:42:34 -0500
Message-ID: <52C5CF38.1010704@codeaurora.org>
Date: Thu, 02 Jan 2014 12:42:32 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: v3.13-rc6+ regression (ARM board)
References: <m3mwjhux0e.fsf@t19.piap.pl>	<20131231104511.GA9688@1wt.eu>	<m3txdmu2ez.fsf@t19.piap.pl>	<20140102101455.GG10158@pengutronix.de>	<m3ppoatwn1.fsf@t19.piap.pl> <CA+55aFyZ0EXYkHd-BhQo6K++qKJVPdGeDbFTVTs3pAPCHFUpOA@mail.gmail.com> <52C5C5F6.70803@linaro.org> <52C5CC54.4050602@linaro.org>
In-Reply-To: <52C5CC54.4050602@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/14 12:30, John Stultz wrote:
> On 01/02/2014 12:03 PM, John Stultz wrote:
>> On 01/02/2014 11:38 AM, Linus Torvalds wrote:
>>> On Thu, Jan 2, 2014 at 4:07 AM, Krzysztof Hałasa <khalasa@piap.pl> wrote:
>>>> This means these two commits don't like each other:
>>>>
>>>>     seqcount: Add lockdep functionality to seqcount/seqlock structures
>>>>     sched_clock: Use seqcount instead of rolling our own
>>> Does something like this fix it for you?
>>>
>>>   --- a/kernel/time/sched_clock.c
>>>   +++ b/kernel/time/sched_clock.c
>>>   @@ -36,6 +36,7 @@ core_param(irqtime, irqtime, int, 0400);
>>>
>>>    static struct clock_data cd = {
>>>           .mult   = NSEC_PER_SEC / HZ,
>>>   +       .seq = SEQCNT_ZERO(cd.seq),
>>>    };
>>>
>>>    static u64 __read_mostly sched_clock_mask;
>>>
>>> (The above is not even compile-tested, because x86 doesn't use
>>> GENERIC_SCHED_CLOCK. So I did the patch blindly, but I think you get
>>> the idea..)
>> Sheesh. Just finishing up holiday email backlog and Linus already has a
>> fix. :)
>>
>> This looks like it should fix the issue, and does build for me.
>>
>> Assuming it works for Krzysztof,
> So something else may be at play. Even with Linus' patch I reproduced a
> similar hang here.
>
> Still chasing it down, but it looks like a seqlock deadlock where we're
> calling read while holding the lock.
>

Do you have tracing enabled? When I moved this code over to use
seqcounts it relied on the fact that the compiler wouldn't be generating
any function calls to the tracing code. Before seqcounts got lockdep
support it all collapsed down into sched_clock() due to the use of
inline on the seqlock API.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

