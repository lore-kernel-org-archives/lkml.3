Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3BVQGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:06:38 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33608 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab3BVQGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 11:06:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAC4Lta2aFB5ainNp=pZsnjrGyCkZsE4pVKobSw8BVAyEFsoyHA@mail.gmail.com>
References: <20130220022712.0E8586607A4@gitolite.kernel.org>
	<CAKocOOMo-5Hiv_dBCpZNYMP_wXWiWugBYq4qsRcMBwm=TPM=dA@mail.gmail.com>
	<20130221085654.GB23223@gmail.com>
	<20130221232600.GA21754@amt.cnet>
	<CAC4Lta2aFB5ainNp=pZsnjrGyCkZsE4pVKobSw8BVAyEFsoyHA@mail.gmail.com>
Date: Fri, 22 Feb 2013 09:06:35 -0700
Message-ID: <CAKocOOOyt0Pg7tyPEFQ6XFiK0LCQcvrauoCkdu68SixgL0Z4fQ@mail.gmail.com>
Subject: Re: sched: Fix signedness bug in yield_to()
From: Shuah Khan <shuahkhan@gmail.com>
To: Raghavendra KT <raghavendra.kt.linux@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, dan.carpenter@oracle.com,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 11:42 PM, Raghavendra KT
<raghavendra.kt.linux@gmail.com> wrote:
> On Fri, Feb 22, 2013 at 4:56 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>> On Thu, Feb 21, 2013 at 09:56:54AM +0100, Ingo Molnar wrote:
>>>
>>> * Shuah Khan <shuahkhan@gmail.com> wrote:
>>>
>>> > On Tue, Feb 19, 2013 at 7:27 PM, Linux Kernel Mailing List
>>> > <linux-kernel@vger.kernel.org> wrote:
>>> > > Gitweb:     http://git.kernel.org/linus/;a=commit;h=c3c186403c6abd32e719f005f0af950155a9e54d
>>> > > Commit:     c3c186403c6abd32e719f005f0af950155a9e54d
>>> > > Parent:     e0a79f529d5ba2507486d498b25da40911d95cf6
>>> > > Author:     Dan Carpenter <dan.carpenter@oracle.com>
>>> > > AuthorDate: Tue Feb 5 14:37:51 2013 +0300
>>> > > Committer:  Ingo Molnar <mingo@kernel.org>
>>> > > CommitDate: Tue Feb 5 12:59:29 2013 +0100
>>> > >
>>> > >     sched: Fix signedness bug in yield_to()
>>> > >
>>> > >     In 7b270f6099 "sched: Bail out of yield_to when source and
>>> > >     target runqueue has one task" we changed this to store -ESRCH so
>>> > >     it needs to be signed.
>>> >
>>> > Dan, Ingo,
>>> >
>>> > I can't find the 7b270f6099 "sched: Bail out of yield_to when
>>> > source and target runqueue has one task" in the latest Linus's
>>> > git. Am I missing something.
>>> >
>>> > The current kenel/sched/core.c doesn't have the code from the
>>> > associated patch https://patchwork.kernel.org/patch/2016651/
>>>
>>> As per the lkml discussion that one was supposed to go upstream
>>> via the KVM tree. Marcelo?
>>
>> commit c3c186403c6abd32e719f005f0af950155a9e54d
>> Author: Dan Carpenter <dan.carpenter@oracle.com>
>> Date:   Tue Feb 5 14:37:51 2013 +0300
>>
>>     sched: Fix signedness bug in yield_to()
>>
>>     In 7b270f6099 "sched: Bail out of yield_to when source and
>>     target runqueue has one task" we changed this to store -ESRCH so
>>     it needs to be signed.
>>
>>     Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>     Cc: Peter Zijlstra <peterz@infradead.org>
>>     Cc: kbuild@01.org
>>     Cc: Steven Rostedt <rostedt@goodmis.org>
>>     Cc: Mike Galbraith <efault@gmx.de>
>>     Link: http://lkml.kernel.org/r/20130205113751.GA20521@elgon.mountain
>>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>>
>
> IIUC, we are only changing variable in yield_to  from bool to int.
> I am curious whether we need changes in struct  sched_class (sched.h)
>
>  bool (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
> ==>
> int (*yield_to_task) (struct rq *rq, struct task_struct *p, bool preempt);
>
> otherwise we would assign bool value  to int here
>
>  yielded = curr->sched_class->yield_to_task(rq, p, preempt);
>
> this return values also cascaded to kvm_main.c.
>
> If we need to patchup entire thing, I can cook a correction patch.
>
> Thanks and Regards
> Raghu

Right/. I was attempting to back-port
c3c186403c6abd32e719f005f0af950155a9e54d to stables when I noticed the
discrepancy. My concerns are:

1. Does it make sense to have c3c186403c6abd32e719f005f0af950155a9e54d
in without 7b270f6099 "sched: Bail out of yield_to when source and
target runqueue has one task" and?
2. Second concern is, is c3c186403c6abd32e719f005f0af950155a9e54d is
enough or more changes are needed? does __yield_to prototype needs
changes as well.

-- Shuah

-- Shuah
