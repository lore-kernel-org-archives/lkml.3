Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaG0V0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 17:26:36 -0400
Received: from forward1l.mail.yandex.net ([84.201.143.144]:60282 "EHLO
	forward1l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0V0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 17:26:35 -0400
X-Yandex-Uniq: 04091410-7aae-4612-8a4b-6efe058e69e2
Authentication-Results: smtp17.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1406496385.1856.34.camel@localhost.localdomain>
Subject: Re: [PATCH v2 0/5] sched: Add on_rq states and remove several
 double rq locks
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        peterz@infradead.org, pjt@google.com, rostedt@goodmis.org,
        umgwanakikbuti@gmail.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org
Date: Mon, 28 Jul 2014 01:26:25 +0400
References: <20140726145508.6308.69121.stgit@localhost>
	 <20140726193910.GA8420@redhat.com>
In-Reply-To: <20140726193910.GA8420@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26.07.2014 23:39, Oleg Nesterov wrote:
> Hi Kirill,
> 
> I'll try to read this series later, just one silly question for now.
> 
> On 07/26, Kirill Tkhai wrote:
>>
>> Patch [2/5] is main in the series. It introduces new state: ONRQ_MIGRATING
>> and teaches scheduler to understand it (we need a little changes predominantly
>> in try_to_wake_up()). This will be used in the following way:
>>
>>         (we are changing task's rq)
>>
>>         raw_spin_lock(&src_rq->lock);
>>         dequeue_task(src_rq, p, 0);
>>         p->on_rq = ONRQ_MIGRATING;
>>         set_task_cpu(p, dst_cpu);
>>         raw_spin_unlock(&src_rq->lock);
>>
>>         raw_spin_lock(&dst_rq->lock);
>>         p->on_rq = ONRQ_QUEUED;
>>         enqueue_task(dst_rq, p, 0);
>>         raw_spin_unlock(&dst_rq->lock);
> 
> Hmm. And what if the code above doesn't hold p->pi_lock (4/5) and, say,
> __sched_setscheduler() does fair_sched_class->rt_sched_class transition
> in between?
> 
> ONRQ_MIGRATING helps to avoid the wrong dequeue + enqueue, but I am not
> sure about check_class_changed().
> 
> Say, switched_from_fair() will use dst_rq even if p was never queued on
> this rq... This only affects the .decay_count logic, perhaps this is fine,
> I simply do not know what this code does.

You're right. We have to check for "task_migrating" in switched_from_fair().
One more place is switched_from_dl().

> What about switched_to_rt() ? we lose the push_rt_task() logic... Hmm,
> which I can't understand too ;)
> 
> And we also lose ENQUEUE_HEAD in this case, but this looks fine.
> 
> In short: could you confirm there are no problems here?

This will be the reason of some RT/DL imbalance. We need a method how to
avoid this.

Maybe, it would be good to call something like check_class_changed()
at the end of migration process. We just need to save task's class
before migration and compare with the class after migration (for [3/5],
__migrate_task()). For [4/5] and [5/5] the class is always fair_sched_class.

Thanks for the comments. I'll think how to fix this in a good way,
and update the series.

Kirill

