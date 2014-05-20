Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaETGHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:07:24 -0400
Received: from forward15.mail.yandex.net ([95.108.130.119]:48033 "EHLO
	forward15.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaETGHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:07:22 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <1413311400562533@web30m.yandex.ru>
References: <20140516213003.10384.7946.stgit@localhost>
	 <20140519151233.5043b749361e1b384f1e5562@gmail.com>
	 <783871400527879@web2j.yandex.ru> <20140520000026.GD11096@twins.programming.kicks-ass.net> <1413311400562533@web30m.yandex.ru>
Subject: Re: [PATCH] sched/dl: Fix race between dl_task_timer() and sched_setaffinity()
MIME-Version: 1.0
Message-Id: <1694921400566038@web28j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 20 May 2014 10:07:18 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

20.05.2014, 09:08, "Kirill Tkhai" <tkhai@yandex.ru>:
> 20.05.2014, 04:00, "Peter Zijlstra" <peterz@infradead.org>:
>
>> šOn Mon, May 19, 2014 at 11:31:19PM +0400, Kirill Tkhai wrote:
>>> šš@@ -513,9 +513,17 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>>> ššššššššššššššššššššššššššššššššššššššššššššššššššššššššstruct sched_dl_entity,
>>> ššššššššššššššššššššššššššššššššššššššššššššššššššššššššdl_timer);
>>> šššššššššššstruct task_struct *p = dl_task_of(dl_se);
>>> šš- struct rq *rq = task_rq(p);
>>> šš+ struct rq *rq;
>>> šš+again:
>>> šš+ rq = task_rq(p);
>>> šššššššššššraw_spin_lock(&rq->lock);
>>>
>>> šš+ if (unlikely(rq != task_rq(p))) {
>>> šš+ /* Task was moved, retrying. */
>>> šš+ raw_spin_unlock(&rq->lock);
>>> šš+ goto again;
>>> šš+ }
>>> šš+
>> šThat thing is called: rq = __task_rq_lock(p);
>
> But p->pi_lock is not held. The problem is __task_rq_lock() has lockdep assert.
> Should we change it?

Or make something like this?

static inline struct rq *_task_rq_lock(struct task_struct *p)
{
        lockdep_assert_held(&p->pi_lock);

        return __task_rq_lock(p);
}

Thanks!
