Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3CDDY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:24:28 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42852 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3CDDY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:24:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130225235313.GE2679@htj.dyndns.org>
References: <CAJFUiJhxqWeQ9PiinpRYCUF8U_3dpaAdvsEKHW2i-QqZ=vkYsQ@mail.gmail.com>
 <20130225235313.GE2679@htj.dyndns.org>
From: Lianwei Wang <lianwei.wang@gmail.com>
Date: Mon, 4 Mar 2013 11:24:06 +0800
Message-ID: <CAJFUiJjy-7sS9xH76XMLs5SU6fUQ1Bk4Xn67jjHeZNQRjC54dg@mail.gmail.com>
Subject: Re: PATCH: freezer: add fake signal clearing back when thaw task
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late response.

Freeze/Thaw is a hot path for the Linux based mobile OS, e.g. Android.
If we don't remove the pending fake signal, then the user space apps
or the related kernel driver has to handle such error. And yes, the
user can handle such case by checking the return value, but it mislead
the user and confuse to them that why wait_event_freezable and friends
return a error on resume path every time? Can we avoid such useless
error return?

(Resend with plain text)

2013/2/26 Tejun Heo <tj@kernel.org>:
> (cc'ing Rafael and Oleg and quoting whole body)
>
> On Thu, Feb 21, 2013 at 02:19:21PM +0800, Lianwei Wang wrote:
>> Hi Tejun Heo and all,
>>
>> The commit of "34b087e freezer: kill unused
>> set_freezable_with_signal()" remove recalc_sigpending*() calls in
>> freezer, so the user tasks get TIF_SIGPENDING fake signal that is set
>> when freezing userspace process. It left the fake signal to userspcae
>> which cause the userspace task that wait_event_freezable and friends
>> return a wrong ERESTARTSYS. This is not good because it waste cpu time
>> to handle the fake signal.
>
> Is this even measureable?  Freeze / thaw isn't exactly a hot path and
> I'm having difficult time believing -ERESTARTSYS would have a
> noticeable impact on anything.  Can you please explain why this is a
> problem?
>
>> Can we just call the recalc_sigpending to clear the fake signal for
>> userspace tasks? as below patch do:
>>
>> From 176fccee178bc0185d92853dd2f521c9166b0853 Mon Sep 17 00:00:00 2001
>> From: Lianwei Wang <lianwei.wang@gmail.com>
>> Date: Mon, 21 Jan 2013 18:21:26 +0800
>> Subject: [PATCH] freezer: add fake signal clearing back when thaw task
>>
>> The fake TIF_SIGPENDING is set during freeze userspace process, but it
>> is not cleared when thaw tasks after below commit:
>>   34b087e freezer: kill unused set_freezable_with_signal()
>>
>> This will cause the userspace task that wait_event_freezable and friends
>> return a wrong ERESTARTSYS. This is not good because it waste cpu time to
>> handle the fake signal.
>>
>> Try to clear the TIF_SIGPENDING flag for userspace apps when wakeup the
>> frozen task to fix this issue.
>>
>> Change-Id: I91c90ad2ee9a46c42e3b39a7384ec81e97bc0394
>> Signed-off-by: Lianwei Wang <lianwei.wang@gmail.com>
>> ---
>>  kernel/freezer.c |   14 ++++++++++++++
>>  1 files changed, 14 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/freezer.c b/kernel/freezer.c
>> index c38893b..09557f6 100644
>> --- a/kernel/freezer.c
>> +++ b/kernel/freezer.c
>> @@ -46,6 +46,16 @@ bool freezing_slow_path(struct task_struct *p)
>>  }
>>  EXPORT_SYMBOL(freezing_slow_path);
>>
>> +static void fake_signal_clear(struct task_struct *p)
>> +{
>> + unsigned long flags;
>> +
>> + if (lock_task_sighand(p, &flags)) {
>> +     recalc_sigpending();
>> +     unlock_task_sighand(p, &flags);
>> + }
>> +}
>> +
>>  /* Refrigerator is place where frozen processes are stored :-). */
>>  bool __refrigerator(bool check_kthr_stop)
>>  {
>> @@ -74,6 +84,10 @@ bool __refrigerator(bool check_kthr_stop)
>>
>>   pr_debug("%s left refrigerator\n", current->comm);
>>
>> + if (!(current->flags & PF_KTHREAD))
>> +     if (test_tsk_thread_flag(current, TIF_SIGPENDING))
>> +         fake_signal_clear(current);
>> +
>>   /*
>>   * Restore saved task state before returning.  The mb'd version
>>   * needs to be used; otherwise, it might silently break
>> --
>> 1.7.4.1
>
>
>
> --
> tejun
