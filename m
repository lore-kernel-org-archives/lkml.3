Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3IJQ3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:29:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41891 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3IJQ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:29:00 -0400
Message-ID: <522F48C9.3060606@linaro.org>
Date: Tue, 10 Sep 2013 09:28:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] seqcount: Add lockdep functionality to seqcount/seqlock
 structures
References: <1378788166-18474-1-git-send-email-john.stultz@linaro.org> <20130910084340.GL26785@twins.programming.kicks-ass.net>
In-Reply-To: <20130910084340.GL26785@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 01:43 AM, Peter Zijlstra wrote:
> On Mon, Sep 09, 2013 at 09:42:46PM -0700, John Stultz wrote:
>> Currently seqlocks and seqcounts don't support lockdep.
>>
>> After running across a seqcount related deadlock in the timekeeping
>> code, I used a less-refined and more focused varient of this patch
>> to narrow down the cause of the issue.
>>
>> This is a first-pass attempt to properly enable lockdep functionality
>> on seqlocks and seqcounts.
>>
>> Due to seqlocks/seqcounts having slightly different possible semantics
>> then standard locks (ie: reader->reader and reader->writer recursion is
>> fine, but writer->reader is not), this implementation is probably not
>> as exact as I'd like (currently using a hack by only spot checking
>> readers), and may be overly strict in some cases.
>>
>> I've handled one cases where there were nested seqlock writers, and
>> there may be more edge cases, as while I've gotten it to run cleanly,
>> depending on config its reporting issues that I'm not sure if they are
>> flaws in the implementation or actual bugs. But I wanted to send this
>> out for some initial thoughts as until today I hadn't looked at much
>> of the lockdep infrastructure. So I'm sure there are improvements
>> that could be made.
>>
>> Comments and feedback would be appreciated!
>> --- a/arch/x86/vdso/vclock_gettime.c
>> +++ b/arch/x86/vdso/vclock_gettime.c
>> @@ -178,13 +178,15 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
>>  
>>  	ts->tv_nsec = 0;
>>  	do {
>> -		seq = read_seqcount_begin(&gtod->seq);
>> +		seq = __read_seqcount_begin(&gtod->seq);
>> +		smp_rmb();
>>  		mode = gtod->clock.vclock_mode;
>>  		ts->tv_sec = gtod->wall_time_sec;
>>  		ns = gtod->wall_time_snsec;
>>  		ns += vgetsns(&mode);
>>  		ns >>= gtod->clock.shift;
>> -	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
>> +		smp_rmb();
>> +	} while (unlikely(__read_seqcount_retry(&gtod->seq, seq)));
>>  
>>  	timespec_add_ns(ts, ns);
>>  	return mode;
>
> You didn't mention the VDSO 'fun' in you Changelog!

No, although its not any net change. I'll clean it up w/ a helper
function so that we're not doing the memory barriers in the logic here.
That should simplify the diff a bit.

thanks
-john
