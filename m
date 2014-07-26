Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaGZTl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbaGZTlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:41:24 -0400
Date: Sat, 26 Jul 2014 21:39:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org,
        peterz@infradead.org, pjt@google.com, rostedt@goodmis.org,
        umgwanakikbuti@gmail.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH v2 0/5] sched: Add on_rq states and remove several
	double rq locks
Message-ID: <20140726193910.GA8420@redhat.com>
References: <20140726145508.6308.69121.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140726145508.6308.69121.stgit@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

I'll try to read this series later, just one silly question for now.

On 07/26, Kirill Tkhai wrote:
>
> Patch [2/5] is main in the series. It introduces new state: ONRQ_MIGRATING
> and teaches scheduler to understand it (we need a little changes predominantly
> in try_to_wake_up()). This will be used in the following way:
>
>         (we are changing task's rq)
>
>         raw_spin_lock(&src_rq->lock);
>         dequeue_task(src_rq, p, 0);
>         p->on_rq = ONRQ_MIGRATING;
>         set_task_cpu(p, dst_cpu);
>         raw_spin_unlock(&src_rq->lock);
>
>         raw_spin_lock(&dst_rq->lock);
>         p->on_rq = ONRQ_QUEUED;
>         enqueue_task(dst_rq, p, 0);
>         raw_spin_unlock(&dst_rq->lock);

Hmm. And what if the code above doesn't hold p->pi_lock (4/5) and, say,
__sched_setscheduler() does fair_sched_class->rt_sched_class transition
in between?

ONRQ_MIGRATING helps to avoid the wrong dequeue + enqueue, but I am not
sure about check_class_changed().

Say, switched_from_fair() will use dst_rq even if p was never queued on
this rq... This only affects the .decay_count logic, perhaps this is fine,
I simply do not know what this code does.

What about switched_to_rt() ? we lose the push_rt_task() logic... Hmm,
which I can't understand too ;)

And we also lose ENQUEUE_HEAD in this case, but this looks fine.

In short: could you confirm there are no problems here?

Oleg.

