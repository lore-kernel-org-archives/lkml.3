Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaCBOmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:42:09 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:46424 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaCBOmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:42:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140226230554.GE11655@kmo>
References: <cover.1391688720.git.agordeev@redhat.com>
	<dd1eb6b2f0f88e90417ba6ad57393147816a4287.1391688720.git.agordeev@redhat.com>
	<20140226230554.GE11655@kmo>
Date: Sun, 2 Mar 2014 22:42:05 +0800
Message-ID: <CACVXFVPNE=ecVqt9-SnuFG8yWQJuXVYKzuNNNKaDJyq6t6wucw@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] percpu_ida: Fix data race on cpus_have_tags cpumask
From: Ming Lei <tom.leiming@gmail.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 7:05 AM, Kent Overstreet <kmo@daterainc.com> wrote:
> On Thu, Feb 06, 2014 at 01:24:53PM +0100, Alexander Gordeev wrote:
>> Function steal_tags() might miss a bit in cpus_have_tags due to
>> unsynchronized access from percpu_ida_free(). As result, function
>> percpu_ida_alloc() might enter unwakable sleep. This update adds
>> memory barriers to prevent the described scenario.
>>
>> In fact, accesses to cpus_have_tags are fenced by prepare_to_wait()
>> and wake_up() calls at the moment and the aforementioned sequence
>> does not appear could hit. Nevertheless, explicit memory barriers
>> still seem justifiable.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: Kent Overstreet <kmo@daterainc.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
>> Acked-by: Kent Overstreet <kmo@daterainc.com>
>> ---
>>  lib/percpu_ida.c |   12 ++++++++++--
>>  1 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
>> index 7be235f..fccfb28 100644
>> --- a/lib/percpu_ida.c
>> +++ b/lib/percpu_ida.c
>> @@ -68,6 +68,11 @@ static inline void steal_tags(struct percpu_ida *pool,
>>       unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
>>       struct percpu_ida_cpu *remote;
>>
>> +     /*
>> +      * Pairs with smp_wmb() in percpu_ida_free()
>> +      */
>> +     smp_rmb();
>> +
>>       for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
>>            cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
>>            cpus_have_tags--) {
>> @@ -237,8 +242,11 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
>>       spin_unlock(&tags->lock);
>>
>>       if (nr_free == 1) {
>> -             cpumask_set_cpu(smp_processor_id(),
>> -                             &pool->cpus_have_tags);
>> +             cpumask_set_cpu(smp_processor_id(), &pool->cpus_have_tags);
>> +             /*
>> +              * Pairs with smp_rmb() in steal_tags()
>> +              */
>> +             smp_wmb();
>>               wake_up(&pool->wait);
>
> I think I'm nacking this - there's a lot of code in the kernel that relies on
> the fact that prepare_to_wait)/wake_up() do the appropriate fences, we really
> shouldn't be adding to the barriers those do.

In theory, it still might cause percpu_ida_alloc(TASK_RUNNING) failed,
looks it isn't a big deal for the case.

But I am wondering why cpumask_set_cpu() isn't called with
holding lock inside percpu_ida_free()? Looks 'nr_free == 1'
shouldn't have happened frequently.


Thanks,
-- 
Ming Lei
