Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab3CLRwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:52:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47568 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3CLRwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130307143246.GB1859@redhat.com>
References: <1362586015-27951-1-git-send-email-fweisbec@gmail.com>
	<1362586015-27951-3-git-send-email-fweisbec@gmail.com>
	<20130307143246.GB1859@redhat.com>
Date: Tue, 12 Mar 2013 18:52:52 +0100
Message-ID: <CAFTL4hy=g=CgZ=LnRKZA4_okw9hJDvreVyaoCwPdKJVcEd1ypA@mail.gmail.com>
Subject: Re: [PATCH 2/2] sched: Lower chances of cputime scaling overflow
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/7 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Wed, Mar 06, 2013 at 05:06:55PM +0100, Frederic Weisbecker wrote:
>> If this solution appears not to be enough in the end, we'll
>> need to partly revert back to the behaviour prior to commit
>>      0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
>>      ("sched, cputime: Introduce thread_group_times()")
>>
>> Back then, the scaling was done on exit() time before adding the cputime
>> of an exiting thread to the signal struct. And then we'll need to
>> scale one-by-one the live threads cputime in thread_group_cputime(). The
>> drawback may be a slightly slower code on exit time.
>
> I do not see this part in the patch ? What I can see is just scaling
> algorithm change.

It's only a suggestion on how to solve the issue if this patch is not
enough. It's not yet implemented but if we still get reports of
overflow we'll need to go there unfortunately.

>
>> -static cputime_t scale_stime(cputime_t stime, cputime_t rtime, cputime_t total)
>> +static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
>>  {
>> -     u64 temp = (__force u64) rtime;
>> +     u64 rem, res, scaled;
>>
>> -     temp *= (__force u64) stime;
>> -
>> -     if (sizeof(cputime_t) == 4)
>> -             temp = div_u64(temp, (__force u32) total);
>> -     else
>> -             temp = div64_u64(temp, (__force u64) total);
>> +     if (rtime >= total) {
>> +             res = div64_u64_rem(rtime, total, &rem);
>> +             scaled = stime * res;
>> +             scaled += div64_u64(stime * rem, total);
>> +     } else {
>> +             res = div64_u64_rem(total, rtime, &rem);
>> +             scaled = div64_u64(stime, res);
>> +             scaled -= div64_u64(scaled * rem, total);
>
> Those calculus are not obvious. Perhaps it should be commented, how
> they evolved from scaled = (rtime*stime)/total ?

Yeah sure, I'll add some comments.

>
>> +     } else if (!total) {
>>               stime = rtime;
>
> I would prefer stime = rtime/2 (hence utime will be rtime/2 too), but this
> is not so important.

I can do that.

Thanks.
