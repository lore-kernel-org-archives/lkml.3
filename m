Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaCKOB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:01:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaCKOB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:01:56 -0400
Date: Tue, 11 Mar 2014 15:03:23 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 1/3] percpu_ida: Fix data race on cpus_have_tags
 cpumask
Message-ID: <20140311140322.GA24065@dhcp-26-207.brq.redhat.com>
References: <cover.1391688720.git.agordeev@redhat.com>
 <dd1eb6b2f0f88e90417ba6ad57393147816a4287.1391688720.git.agordeev@redhat.com>
 <20140226230554.GE11655@kmo>
 <CACVXFVPNE=ecVqt9-SnuFG8yWQJuXVYKzuNNNKaDJyq6t6wucw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPNE=ecVqt9-SnuFG8yWQJuXVYKzuNNNKaDJyq6t6wucw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 10:42:05PM +0800, Ming Lei wrote:
> >> @@ -237,8 +242,11 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
> >>       spin_unlock(&tags->lock);
> >>
> >>       if (nr_free == 1) {
> >> -             cpumask_set_cpu(smp_processor_id(),
> >> -                             &pool->cpus_have_tags);
> >> +             cpumask_set_cpu(smp_processor_id(), &pool->cpus_have_tags);
> >> +             /*
> >> +              * Pairs with smp_rmb() in steal_tags()
> >> +              */
> >> +             smp_wmb();
> >>               wake_up(&pool->wait);
> >
> > I think I'm nacking this - there's a lot of code in the kernel that relies on
> > the fact that prepare_to_wait)/wake_up() do the appropriate fences, we really
> > shouldn't be adding to the barriers those do.
> 
> In theory, it still might cause percpu_ida_alloc(TASK_RUNNING) failed,
> looks it isn't a big deal for the case.
> 
> But I am wondering why cpumask_set_cpu() isn't called with
> holding lock inside percpu_ida_free()? Looks 'nr_free == 1'
> shouldn't have happened frequently.

Because bouncing on the lock is more expensive than occasionally putting
a thread into sleep.

> 
> 
> Thanks,
> -- 
> Ming Lei

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
