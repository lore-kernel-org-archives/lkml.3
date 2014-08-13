Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaHMAxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:53:35 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:49390 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaHMAxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:53:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140812114430.GA7049@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140812114430.GA7049@dhcp22.suse.cz>
Date: Tue, 12 Aug 2014 17:53:33 -0700
Message-ID: <CAM_iQpUtvqnaSuzO9d+HSDhEwtwjP9J5JaZwYusdW157zCdhRw@mail.gmail.com>
Subject: Re: [Patch v2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 4:44 AM, Michal Hocko <mhocko@suse.cz> wrote:
> Has it stopped working as a result of a3201227f803 (freezer: make
> freezing() test freeze conditions in effect instead of TIF_FREEZE)?
> It removes clear_freeze_flag from __thaw_task and so the OOM victim
> cannot escape from the refrigerator. But there were a lot of changes in
> that area at the time so I might be missing some subtle details.

Probably, I don't have time to dig the history.

>
>> __thaw_task() just checks if it's frozen and then wakes it up,
>> but the frozen task, after waking up, will check if freezing()
>> is still true and continue to freeze itself if so. __thaw_task()
>> can't make freezing() return false since it doesn't change any
>> of these conditions, especially cgroup_freezing().
>>
>> Fix this straightly by checking if the frozen process itself
>> has been killed by OOM killer, so that the frozen process will
>> recover itself and be killed finally.
>
> OK, this should work. I remember Tejun mentioned that he wanted frozen
> tasks to be killable but I have no idea where this went. Maybe we want
> to go with the OOM part now as it fixes a real bug.


I think he rejected the patch from Bart which makes frozen tasks killable.

>> +static bool i_should_thaw_myself(bool check_kthr_stop)
>
> should_thaw_current?
>

I have no strong preference, whatever you prefer...

>> @@ -147,12 +156,6 @@ void __thaw_task(struct task_struct *p)
>>  {
>>       unsigned long flags;
>>
>> -     /*
>> -      * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
>> -      * be visible to @p as waking up implies wmb.  Waking up inside
>> -      * freezer_lock also prevents wakeups from leaking outside
>> -      * refrigerator.
>> -      */
>
> This is an unrelated change.
>

It is, because as I explained, __thaw_task() doesn't do what this comment
says therefore needs this patch. Or you prefer to make it a separated patch?

Thanks.
