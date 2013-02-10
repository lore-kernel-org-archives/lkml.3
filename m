Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073Ab3BJESr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 23:18:47 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47474 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761052Ab3BJESp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 23:18:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130209190826.GC2875@htj.dyndns.org>
References: <CAJd=RBD4ZJN7uXQ5xY1GF14j_DydDQEpuZNct-UiNXTBARpQSQ@mail.gmail.com>
	<20130209190826.GC2875@htj.dyndns.org>
Date: Sun, 10 Feb 2013 12:18:45 +0800
Message-ID: <CAJd=RBB2U5MVpwey7J8Hag1tb1Hi_Nepem+6H7qH_=QD8a2h-g@mail.gmail.com>
Subject: Re: [PATCH 1/2] stop_machine: check work->done while handling
 enqueued works
From: Hillf Danton <dhillf@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2013 at 3:08 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Hillf.
>
> On Fri, Feb 08, 2013 at 11:39:56AM +0800, Hillf Danton wrote:
>> The comment just above cpu_stop_signal_done() says it is uncertain that
>> the input @done is valid, and the works enqueued through the function
>> stop_one_cpu_nowait() do carry no done, thus we have to check if it is
>> valid when updating work result.
>
> How about something like the following?

Cool, I like it, thanks.

Hillf
>
> In cpu_stopper_thread(), @work->done may be NULL if the cpu stop work
> is queued from stop_one_cpu_nowait(); however, cpu_stopper_thread()
> updates @done->ret without checking whether @done exists or not when
> the work function fails.
>
> While this can lead to oops, the only current user of
> stop_one_cpu_nowait() - active_load_balance_cpu_stop() - always
> returns 0 and thus there's no in-kernel user which triggers this bug.
>
> Fix it by checking whether @done exists before updating @done->ret.
>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> ---
>>
>> --- a/kernel/stop_machine.c   Thu Feb  7 20:03:10 2013
>> +++ b/kernel/stop_machine.c   Fri Feb  8 11:07:40 2013
>> @@ -279,7 +279,7 @@ repeat:
>>               preempt_disable();
>>
>>               ret = fn(arg);
>> -             if (ret)
>> +             if (ret && done != NULL)
>
> It's a nitpick and probalby is just a preference but I've never liked
> != NULL or != 0.  Can we just do if (ret && done)?
>
> Thanks.
>
> --
> tejun
