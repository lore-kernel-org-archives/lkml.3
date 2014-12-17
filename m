Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaLQJJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:09:51 -0500
Received: from relay.parallels.com ([195.214.232.42]:40711 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaLQJJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:09:42 -0500
Message-ID: <1418807373.6074.18.camel@tkhai>
Subject: Re: [PATCH] sched/fair: Make cfs_rq::decay_counter non-atomic
From: Kirill Tkhai <ktkhai@parallels.com>
To: <bsegall@google.com>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>
Date: Wed, 17 Dec 2014 12:09:33 +0300
In-Reply-To: <xm26iohb79v5.fsf@sword-of-the-dawn.mtv.corp.google.com>
References: <1418739933.6074.15.camel@tkhai>
	 <xm26iohb79v5.fsf@sword-of-the-dawn.mtv.corp.google.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Вт, 16/12/2014 в 10:00 -0800, bsegall@google.com пишет:
> Kirill Tkhai <ktkhai@parallels.com> writes:
> 
> > We update decay_counter in update_cfs_rq_blocked_load()
> > only. This function is always called with rq lock locked,
> > so we can kill atomic actions.
> >
> > Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> > ---
> >  kernel/sched/fair.c  |   11 ++++++-----
> >  kernel/sched/sched.h |    2 +-
> >  2 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 5f3b5a7..af990c4 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -2570,7 +2570,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
> >  static inline u64 __synchronize_entity_decay(struct sched_entity *se)
> >  {
> >  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> > -	u64 decays = atomic64_read(&cfs_rq->decay_counter);
> > +	u64 decays = ACCESS_ONCE(cfs_rq->decay_counter);
> 
> This is called without rq lock held from migrate_task_rq_fair. (We could
> technically change the atomic_add to atomic64_set(atomic64_read() + x),
> but I don't know that that is a win) Now, we could do a
> min_vruntime-style two-copy thing if this atomic usage is a hot spot on
> 32-bit, we just didn't bother initially.

Oh, I forgot that 64-bit read is not everywhere atomic... Thanks, Ben.

Peter, please, ignore this patch.

