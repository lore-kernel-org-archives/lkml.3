Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaABUaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:30:17 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41578 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaABUaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:30:15 -0500
Message-ID: <52C5CC54.4050602@linaro.org>
Date: Thu, 02 Jan 2014 12:30:12 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?B?S3J6eXN6dG9m?= =?UTF-8?B?IEhhxYJhc2E=?= 
	<khalasa@piap.pl>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: v3.13-rc6+ regression (ARM board)
References: <m3mwjhux0e.fsf@t19.piap.pl>	<20131231104511.GA9688@1wt.eu>	<m3txdmu2ez.fsf@t19.piap.pl>	<20140102101455.GG10158@pengutronix.de>	<m3ppoatwn1.fsf@t19.piap.pl> <CA+55aFyZ0EXYkHd-BhQo6K++qKJVPdGeDbFTVTs3pAPCHFUpOA@mail.gmail.com> <52C5C5F6.70803@linaro.org>
In-Reply-To: <52C5C5F6.70803@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 12:03 PM, John Stultz wrote:
> On 01/02/2014 11:38 AM, Linus Torvalds wrote:
>> On Thu, Jan 2, 2014 at 4:07 AM, Krzysztof Hałasa <khalasa@piap.pl> wrote:
>>> This means these two commits don't like each other:
>>>
>>>     seqcount: Add lockdep functionality to seqcount/seqlock structures
>>>     sched_clock: Use seqcount instead of rolling our own
>> Does something like this fix it for you?
>>
>>   --- a/kernel/time/sched_clock.c
>>   +++ b/kernel/time/sched_clock.c
>>   @@ -36,6 +36,7 @@ core_param(irqtime, irqtime, int, 0400);
>>
>>    static struct clock_data cd = {
>>           .mult   = NSEC_PER_SEC / HZ,
>>   +       .seq = SEQCNT_ZERO(cd.seq),
>>    };
>>
>>    static u64 __read_mostly sched_clock_mask;
>>
>> (The above is not even compile-tested, because x86 doesn't use
>> GENERIC_SCHED_CLOCK. So I did the patch blindly, but I think you get
>> the idea..)
> Sheesh. Just finishing up holiday email backlog and Linus already has a
> fix. :)
>
> This looks like it should fix the issue, and does build for me.
>
> Assuming it works for Krzysztof,

So something else may be at play. Even with Linus' patch I reproduced a
similar hang here.

Still chasing it down, but it looks like a seqlock deadlock where we're
calling read while holding the lock.

thanks
-john



