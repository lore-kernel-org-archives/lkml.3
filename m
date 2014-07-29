Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaG2JxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:53:18 -0400
Received: from relay.parallels.com ([195.214.232.42]:52923 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaG2JxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:53:16 -0400
Message-ID: <1406627582.3600.9.camel@tkhai>
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, <linux-kernel@vger.kernel.org>,
        <nicolas.pitre@linaro.org>, <pjt@google.com>, <oleg@redhat.com>,
        <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>
Date: Tue, 29 Jul 2014 13:53:02 +0400
In-Reply-To: <1406538338.23175.12.camel@tkhai>
References: <20140726145508.6308.69121.stgit@localhost>
	 <20140726145912.6308.32554.stgit@localhost>
	 <20140728080122.GL6758@twins.programming.kicks-ass.net>
	 <1406538338.23175.12.camel@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 28/07/2014 в 13:05 +0400, Kirill Tkhai пишет:
> В Пн, 28/07/2014 в 10:01 +0200, Peter Zijlstra пишет:
> > On Sat, Jul 26, 2014 at 06:59:21PM +0400, Kirill Tkhai wrote:
> > 
> > > The profit is that double_rq_lock() is not needed now,
> > > and this may reduce the latencies in some situations.
> > 
> > > We add a loop in the beginning of set_cpus_allowed_ptr.
> > > It's like a handmade spinlock, which is similar
> > > to situation we had before. We used to spin on rq->lock,
> > > now we spin on "again:" label. Of course, it's worse
> > > than arch-dependent spinlock, but we have to have it
> > > here. 
> > 
> > > @@ -4623,8 +4639,16 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
> > >  	struct rq *rq;
> > >  	unsigned int dest_cpu;
> > >  	int ret = 0;
> > > +again:
> > > +	while (unlikely(task_migrating(p)))
> > > +		cpu_relax();
> > >  
> > >  	rq = task_rq_lock(p, &flags);
> > > +	/* Check again with rq locked */
> > > +	if (unlikely(task_migrating(p))) {
> > > +		task_rq_unlock(rq, p, &flags);
> > > +		goto again;
> > > +	}
> > >  
> > >  	if (cpumask_equal(&p->cpus_allowed, new_mask))
> > >  		goto out;
> > 
> > So I really dislike that, esp since you're now talking of adding more of
> > this goo all over the place.
> > 
> > I'll ask again, why isn't this in task_rq_lock() and co?
> 
> I thought, this may give a little profit in cases of priority inheritance etc.
> But since this is spreading throughout the scheduler, I'm agree with you.
> It's better to place this in task_rq_lock() etc. This will decide all
> the problems that we have discussed with Oleg.
> 
> > Also, you really need to talk the spin bounded, otherwise your two
> > quoted paragraphs above are in contradiction. Now I think you can
> > actually make an argument that way, so that's good.

How about this? Everything is inside task_rq_lock() now. The patch
became much less.

From: Kirill Tkhai <ktkhai@parallels.com>

    sched: Teach scheduler to understand ONRQ_MIGRATING state
    
    This is new on_rq state for the cases when task is migrating
    from one src_rq to another dst_rq, and there is no necessity
    to have both RQs locked at the same time.
    
    We will use the state this way:
    
    	raw_spin_lock(&src_rq->lock);
    	dequeue_task(src_rq, p, 0);
    	p->on_rq = ONRQ_MIGRATING;
    	set_task_cpu(p, dst_cpu);
    	raw_spin_unlock(&src_rq->lock);
    
    	raw_spin_lock(&dst_rq->lock);
    	p->on_rq = ONRQ_QUEUED;
    	enqueue_task(dst_rq, p, 0);
    	raw_spin_unlock(&dst_rq->lock);
    
    The profit is that double_rq_lock() is not needed now,
    and this may reduce the latencies in some situations.
    
    v2.1: Place task_migrating() into task_rq_lock() and
    __task_rq_lock().
    
    Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26aa7bc..00d7bcc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -333,7 +333,8 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 	for (;;) {
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) &&
+			   !task_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -352,7 +353,8 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) &&
+			   !task_migrating(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
@@ -1678,7 +1680,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (task_queued(p) && ttwu_remote(p, wake_flags))
+	if (p->on_rq && ttwu_remote(p, wake_flags))
 		goto stat;
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e5a9b6d..f6773d7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -17,6 +17,7 @@ struct rq;
 
 /* .on_rq states of struct task_struct: */
 #define ONRQ_QUEUED	1
+#define ONRQ_MIGRATING	2
 
 extern __read_mostly int scheduler_running;
 
@@ -950,6 +951,11 @@ static inline int task_queued(struct task_struct *p)
 	return p->on_rq == ONRQ_QUEUED;
 }
 
+static inline int task_migrating(struct task_struct *p)
+{
+	return p->on_rq == ONRQ_MIGRATING;
+}
+
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif


