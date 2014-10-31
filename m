Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaJaQBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:01:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaJaQA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:00:59 -0400
Date: Fri, 31 Oct 2014 17:00:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH v3] sched/dl: Implement cancel_dl_timer() to use in
 switched_from_dl()
Message-ID: <20141031160055.GU23531@worktop.programming.kicks-ass.net>
References: <1414420852.19914.186.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414420852.19914.186.camel@tkhai>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 05:40:52PM +0300, Kirill Tkhai wrote:
> +static void cancel_dl_timer(struct rq *rq, struct task_struct *p)
> +{
> +	struct hrtimer *dl_timer = &p->dl.dl_timer;
> +
> +	/* Nobody will change task's class if pi_lock is held */
> +	lockdep_assert_held(&p->pi_lock);
> +
> +	if (hrtimer_active(dl_timer)) {
> +		int ret = hrtimer_try_to_cancel(dl_timer);
> +
> +		if (unlikely(ret == -1)) {
> +			/*
> +			 * Note, p may migrate OR new deadline tasks
> +			 * may appear in rq when we are unlocking it.
> +			 * A caller of us must be fine with that.
> +			 */
> +			raw_spin_unlock(&rq->lock);
> +			hrtimer_cancel(dl_timer);
> +			raw_spin_lock(&rq->lock);
> +		}
> +	}
> +}
> +
>  static void switched_from_dl(struct rq *rq, struct task_struct *p)
>  {
> +	cancel_dl_timer(rq, p);
>  
>  	__dl_clear_params(p);
>  

I added the below comments; just to make sure we all remember this...

---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1008,6 +1008,9 @@ inline int task_curr(const struct task_s
 	return cpu_curr(task_cpu(p)) == p;
 }
 
+/*
+ * Can drop rq->lock because from sched_class::switched_from() methods drop it.
+ */
 static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
 				       int oldprio)
@@ -1015,6 +1018,7 @@ static inline void check_class_changed(s
 	if (prev_class != p->sched_class) {
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p);
+		/* Possble rq->lock 'hole'.  */
 		p->sched_class->switched_to(rq, p);
 	} else if (oldprio != p->prio || dl_task(p))
 		p->sched_class->prio_changed(rq, p, oldprio);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1157,6 +1157,11 @@ struct sched_class {
 	void (*task_fork) (struct task_struct *p);
 	void (*task_dead) (struct task_struct *p);
 
+	/*
+	 * The switched_from() call is allowed to drop rq->lock, therefore we
+	 * cannot assume the switched_from/switched_to pair is serliazed by
+	 * rq->lock. They are however serialized by p->pi_lock.
+	 */
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
