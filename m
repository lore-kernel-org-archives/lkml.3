Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaIBWPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:15:15 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:46308 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaIBWPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:15:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140901083828.GA27892@worktop.ger.corp.intel.com>
References: <1409268455-11807-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140901083828.GA27892@worktop.ger.corp.intel.com>
Date: Tue, 2 Sep 2014 15:15:10 -0700
Message-ID: <CAHA+R7OVn+GFoY=_FnWNbKi0i1ubOm8f=ymCjweNrSu=2SDVCQ@mail.gmail.com>
Subject: Re: [Patch] perf_event: fix a race condition in perf_remove_from_context()
From: Cong Wang <cwang@twopensource.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 1:38 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Aug 28, 2014 at 04:27:35PM -0700, Cong Wang wrote:
>> From: Cong Wang <cwang@twopensource.com>
>>
>> We saw a kernel soft lockup in perf_remove_from_context(),
>> it looks like the `perf` process, when exiting, could not go
>> out of the retry loop. Meanwhile, the target process was forking
>> a child. So either the target process should execute the smp
>> function call to deactive the event (if it was running) or it should
>> do a context switch which deactives the event.
>>
>> It seems we optimize out a context switch in perf_event_context_sched_out(),
>> and what's more important, we still test an obsolete task pointer when
>> retrying, so no one actually would deactive that event in this situation.
>> Fix it directly by reloading the task pointer in perf_remove_from_context().
>> This should fix the above soft lockup.
>
>
>
>> ---
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index f9c1ed0..c4141a0 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -1524,6 +1524,11 @@ retry:
>
> Please use either:
>
> .gitconfig:
>
> [diff "default"]
>         xfuncname = "^[[:alpha:]$_].*[^:]$"
>
> .quiltrc:
>
> QUILT_DIFF_OPTS="-F ^[[:alpha:]\$_].*[^:]\$"
>

OK, I didn't know this before.


>>        */
>>       if (ctx->is_active) {
>>               raw_spin_unlock_irq(&ctx->lock);
>> +             /*
>> +              * Reload the task pointer, it might have been changed by
>> +              * a concurrent perf_event_context_sched_out() without switching
>> +              */
>> +             task = ctx->task;
>>               goto retry;
>>       }
>
> You forgot to check if that same error happened in other places (it
> does), please fix all of them.

I think you mean perf_install_in_context()? I only saw the soft lockup in
perf_remove_from_context() so far, but I can fix other places if you want.

Thanks!
