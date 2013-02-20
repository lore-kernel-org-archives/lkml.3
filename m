Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab3BTRYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:24:34 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:43996 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab3BTRYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:24:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130220171645.GB3570@htj.dyndns.org>
References: <1361380176-15081-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130220171645.GB3570@htj.dyndns.org>
Date: Wed, 20 Feb 2013 19:24:29 +0200
Message-ID: <CAHp75VcB2v=pqOHjUr_r=sp1git0vzYEdt0bLJo9QvD29-UO9g@mail.gmail.com>
Subject: Re: [PATCH] events: always do slow path when trying to find a pmu
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-next@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 7:16 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Feb 20, 2013 at 07:09:36PM +0200, Andy Shevchenko wrote:
>> The guilty commit is cc5b5f6 "events: convert to idr_alloc()" together with
>> f49318a "idr: implement lookup hint". In our case the idr_alloc is never called, but idr_find is. The hint field is never initialized and could not be dereferenced.
>
> Ah, right, ->hint is uninitialized at the beginning.
>
>> The proposed fix uses the idr_slowpath call which reflects old behaviour.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> ---
>>  kernel/events/core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 624e53f..20421ea 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6076,7 +6076,7 @@ struct pmu *perf_init_event(struct perf_event *event)
>>       idx = srcu_read_lock(&pmus_srcu);
>>
>>       rcu_read_lock();
>> -     pmu = idr_find(&pmu_idr, event->attr.type);
>> +     pmu = idr_find_slowpath(&pmu_idr, event->attr.type);
>
> But I don't think this is the right thing to do.  I'm working on
> proper fix for idr_find().  Will post soon.

Check my v2



-- 
With Best Regards,
Andy Shevchenko
