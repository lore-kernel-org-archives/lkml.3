Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3CKPfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:35:30 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:46831 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab3CKPf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:35:29 -0400
MIME-Version: 1.0
In-Reply-To: <1363010894.12608.5.camel@gandalf.local.home>
References: <513D8433.8000806@huawei.com>
	<1363010894.12608.5.camel@gandalf.local.home>
Date: Mon, 11 Mar 2013 23:35:28 +0800
Message-ID: <CACV3sb+b1TGzsSwsoCxXCf5=6KXbAf-=XhnNz3wL5upLq8LPtw@mail.gmail.com>
Subject: Re: [PATCH 06/13] tracing: remove dump_ran check in __ftrace_dump
From: Jovi Zhang <bookjovi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 10:08 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2013-03-11 at 15:13 +0800, zhangwei(Jovi) wrote:
>> It's reasonable to call __ftrace_dump function not only once,
>> so remove the dump_ran variable checking.
>
> This needs a little more work. On an oops, I only want it dumped once,
> because a crash can cause another crash while its dumping, and without
> that check in will corrupt the buffer.
For reclusive dumping, it's already under the protection of
ftrace_dump_lock spinlock,
I missed something? would you explain more on this case?
>
> Now, we have things like ctrl^z that also does a dump where we don't
> want to disable it. Cleaning this up has been on my todo list for a
> while. I may go ahead and clean that up myself.
Nice, please ignore this patch if that code will be cleanup.
Thanks.

>
> -- Steve
>
>>
>> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
>> ---
>>  kernel/trace/trace.c |    6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 090eddb..4cec7b8 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -5106,17 +5106,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>>       /* use static because iter can be a bit big for the stack */
>>       static struct trace_iterator iter;
>>       unsigned int old_userobj;
>> -     static int dump_ran;
>>       unsigned long flags;
>>       int cnt = 0, cpu;
>>
>>       /* only one dump */
>>       local_irq_save(flags);
>>       arch_spin_lock(&ftrace_dump_lock);
>> -     if (dump_ran)
>> -             goto out;
>> -
>> -     dump_ran = 1;
>>
>>       tracing_off();
>>
>> @@ -5206,7 +5201,6 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
>>               tracing_on();
>>       }
>>
>> - out:
>>       arch_spin_unlock(&ftrace_dump_lock);
>>       local_irq_restore(flags);
>>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
