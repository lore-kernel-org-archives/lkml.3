Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaHLA1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 20:27:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:47353 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHLA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 20:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1408090152240.11855@chino.kir.corp.google.com>
References: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
	<alpine.DEB.2.02.1408090152240.11855@chino.kir.corp.google.com>
Date: Mon, 11 Aug 2014 17:20:50 -0700
Message-ID: <CAM_iQpV71KMJEm_-VY0EPJngM-yNHOVv5niXgy9+7jnWw3=wBQ@mail.gmail.com>
Subject: Re: [Patch] freezer: check OOM kill signal while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 1:55 AM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 8 Aug 2014, Cong Wang wrote:
>
>> diff --git a/kernel/freezer.c b/kernel/freezer.c
>> index aa6a8aa..c6d189d 100644
>> --- a/kernel/freezer.c
>> +++ b/kernel/freezer.c
>> @@ -68,7 +68,9 @@ bool __refrigerator(bool check_kthr_stop)
>>               spin_lock_irq(&freezer_lock);
>>               current->flags |= PF_FROZEN;
>>               if (!freezing(current) ||
>> -                 (check_kthr_stop && kthread_should_stop()))
>> +                 (check_kthr_stop && kthread_should_stop()) ||
>> +                 (test_tsk_thread_flag(current, TIF_MEMDIE) &&
>> +                      fatal_signal_pending(current)))
>>                       current->flags &= ~PF_FROZEN;
>>               spin_unlock_irq(&freezer_lock);
>>
>
> All threads with TIF_MEMDIE set would have been killed, why is the check
> for fatal_signal_pending(current) needed?

So just checking TIF_MEMDIE is enough, right?

>
> You can also use test_thread_flag(TIF_MEMDIE) instead since you're only
> concerned with current.
>

OK, will do.

> Furthermore, that conditional is getting difficult to read.  Maybe it
> would help to have a helper function that returns bool that determines
> whether PF_FROZEN should be cleared?

Makes sense.

Thanks.
